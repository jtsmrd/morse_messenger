//
//  AuthenticationService.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import Firebase
import SwiftUI
import GoogleSignIn
import CryptoKit
import AuthenticationServices

final class AuthenticationService: NSObject {
        
    static let shared = AuthenticationService()
    
    private let firebaseAuth = FirebaseManager.shared.auth
    private var currentNonce: String?
        
    // MARK: - Public Methods
    
    func createAccount(email: String, password: String) async throws {
        
        try await firebaseAuth.createUser(
            withEmail: email,
            password: password)
    }
    
    func login(email: String, password: String) async throws {
        
        try await firebaseAuth.signIn(
            withEmail: email,
            password: password)
    }
    
    @MainActor
    func authenticateWithGoogle() async throws {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        
        // Call on main thread
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        do {
            let authResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
            
            guard let idToken = authResult.user.idToken?.tokenString else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: authResult.user.accessToken.tokenString)
            
            try await self.signInWithAuthCredential(credential: credential)
            
        } catch {
            print("DEBUG: Failed to authenticate user with google: \(error.localizedDescription)")
        }
    }
    
    func authenticateWithApple() {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authenticateWithFacebook() {
        
    }
    
    func logout() {
        try? firebaseAuth.signOut()
    }
    
    // MARK: - Private Methods
    
    private func randomNonceString(length: Int = 32) -> String {
        
        precondition(length > 0)
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func signInWithAuthCredential(credential: AuthCredential) async throws {
        do {
            try await firebaseAuth.signIn(with: credential)
        } catch {
            print("DEBUG: Failed to authenticate with auth credential: \(error.localizedDescription)")
        }
    }
}

extension AuthenticationService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce)
            
            Task {
                try await signInWithAuthCredential(credential: credential)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
}
