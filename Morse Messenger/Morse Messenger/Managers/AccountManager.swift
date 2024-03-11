//
//  AccountManager.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftData
import Firebase
import FirebaseFirestore
import FirebaseAuth

final class AccountManager {
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = AccountManager()
    
    @Published var firebaseUser: Firebase.User?
    @Published var account: Account?
    
    @Published var createUser: Bool = false
    @Published var isLoggedOut: Bool = true
    @Published var isLoading: Bool = true
    
    private let firebaseAuth = FirebaseManager.shared.auth
    private let firestore = FirebaseManager.shared.firestore
    private var firebaseAuthStateListener: AuthStateDidChangeListenerHandle?
    private var firestoreAccountUserListener: ListenerRegistration?
    
    
    @MainActor
    private init() {
        
        self.modelContainer = try! ModelContainer(for: Account.self)
        self.modelContext = modelContainer.mainContext
        
        registerAuthStateListener()
    }
    
    deinit {
        if let firebaseAuthStateListener {
            firebaseAuth.removeStateDidChangeListener(firebaseAuthStateListener)
        }
        firestoreAccountUserListener?.remove()
    }
    
    
    private func registerAuthStateListener() {
        
        firebaseAuthStateListener = firebaseAuth.addStateDidChangeListener { auth, user in
            if self.firebaseUser != user {
                self.firebaseUser = user
            }
            
            if let user = self.firebaseUser {
                self.registerFirestoreAccountUserListener(accountUserId: user.uid)
            } else {
                self.isLoggedOut = true
                self.isLoading = false
            }
        }
    }
    
    
    private func registerFirestoreAccountUserListener(accountUserId: String) {
        firestoreAccountUserListener?.remove()
        
        firestoreAccountUserListener = firestore
            .collection(FirebaseConstants.users)
            .document(accountUserId)
            .addSnapshotListener(includeMetadataChanges: true, listener: { [weak self] documentSnapshot, error in
                
                guard let userData = documentSnapshot?.data() else {
                    self?.createUser = true
                    self?.isLoading = false
                    return
                }
                
                let user = User(data: userData)
                
                self?.setAccount(user: user)
                self?.firestoreAccountUserListener?.remove()
                self?.isLoggedOut = false
                self?.isLoading = false
                
            })
    }
    
    
    private func setAccount(user: User) {
        account = loadAccount(id: user.id) ?? createAccount(user: user)
    }
    
    
    private func loadAccount(id: String) -> Account? {
        
        let predicate = #Predicate<Account> {
            $0.id == id
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        let account = try? modelContext.fetch(descriptor).first
        return account
    }
    
    
    private func createAccount(user: User) -> Account {
        
        let metaData = MetaData()
        
        let accountUser = User(
            id: user.id,
            username: user.username,
            fullName: user.fullName,
            profileImageUrl: user.profileImageUrl,
            metaData: metaData)
        
        let account = Account(id: user.id, user: accountUser)
        
        modelContext.insert(account)
        
        do {
            try modelContext.save()
            createUser = false
        } catch {
            fatalError(error.localizedDescription)
        }
        return account
    }
}
