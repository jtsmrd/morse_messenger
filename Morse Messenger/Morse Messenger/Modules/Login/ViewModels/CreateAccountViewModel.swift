//
//  CreateAccountViewModel.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI

@Observable
class CreateAccountViewModel {
    
    private let accountService = AccountService.shared
    private var usernameLookup: [String: Bool] = [:]
    
    var usernameAvailable = true
    var isLoading = false
    
    @MainActor
    func checkUsernameAvailability(_ username: String) async {
        // Could be handled with rebounce
        guard username.count > 4 else {
            return
        }
        
        let lowercasedUsername = username.lowercased()
        
        if let available = usernameLookup[lowercasedUsername] {
            usernameAvailable = available
            return
        }
        
        do {
            usernameAvailable = try await accountService.usernameIsAvailable(
                username: lowercasedUsername
            )
            usernameLookup[lowercasedUsername] = usernameAvailable
            
        } catch {
            usernameAvailable = false
        }
    }
    
    
    @MainActor
    func createNewUser(image: UIImage?, fullName: String, username: String) async {
        
        isLoading = true
        
        do {
            try await accountService.createNewUser(
                image: image,
                fullName: fullName,
                username: username)
                        
            self.isLoading = false
            
        } catch {
            self.isLoading = false
        }
    }
}
