//
//  AuthenticationProviderViewModel.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI
import Combine

@Observable
class AuthenticationProviderViewModel {
    
    private let authService = AuthenticationService.shared
    
    var isLoading = false
    var hasError = false
    var errorMessage = ""
    
    
    @MainActor
    func signInWithGoogle() async {
        
        isLoading = true
        hasError = false
        errorMessage = ""
        
        do {
            try await authService.authenticateWithGoogle()
            
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.hasError = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    func signInWithApple() {
        authService.authenticateWithApple()
    }
    
    func signInWithFacebook() {
        
    }
}
