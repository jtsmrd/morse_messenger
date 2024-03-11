//
//  AccountService.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SwiftData

final class AccountService {
        
    static let shared = AccountService()
    
    @Published var currentUser: User?
    
    private let firebaseAuth = FirebaseManager.shared.auth
    private var firestoreListener: ListenerRegistration?
    
    init() { }
    
    func fetchUser() async throws {
        
        guard let firebaseUser = firebaseAuth.currentUser else {
            return
        }
        
        let snapshotData = try await FirebaseManager.shared.firestore
            .collection(FirebaseConstants.users)
            .document(firebaseUser.uid)
            .getDocument()
        
        currentUser = try snapshotData.data(as: User.self)
    }
    
    func fetchUser2() {
        guard let firebaseUser = firebaseAuth.currentUser else {
            return
        }
        
        firestoreListener?.remove()
        
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.users)
            .document(firebaseUser.uid)
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    return
                }
                
                self?.currentUser = try? document.data(as: User.self)
            }
    }
    
    func usernameIsAvailable(username: String) async throws -> Bool {
        
        let usersRef = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.users)
        
        let query = usersRef.whereField(FirebaseConstants.username, isEqualTo: username)
        
        let snapshot = try? await query.getDocuments()
    
        guard let users = snapshot?.documents else {
            return false
        }
        
        return users.isEmpty
    }
    
    func createNewUser(image: UIImage?, fullName: String, username: String) async throws {
        
        guard let firebaseUser = firebaseAuth.currentUser else {
            return
        }
        
        let profileImageUrl = try await saveAccountImage(image)?.absoluteString
        
        let newUser = User(
            id: firebaseUser.uid,
            username: username,
            fullName: fullName,
            profileImageUrl: profileImageUrl
        )
        try await self.saveAccountData(user: newUser)
    }
    
    private func saveAccountImage(_ image: UIImage?) async throws -> URL? {

        guard let firebaseUser = firebaseAuth.currentUser else {
            return nil
        }
        
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        
        let ref = FirebaseManager.shared.storage
            .reference(withPath: firebaseUser.uid)
        
        let _ = try await ref.putDataAsync(imageData)
    
        return try? await ref.downloadURL()
    }
    
    @MainActor
    private func saveAccountData(user: User) async throws {
        
        try await FirebaseManager.shared.firestore
            .collection(FirebaseConstants.users)
            .document(user.id)
            .setData(user.toFirebaseData)
    }
}
