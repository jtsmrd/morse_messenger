//
//  RegistrationViewModel.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI

@Observable
class RegistrationViewModel {
    
    private let authService = AuthenticationService.shared
    
    var isLoading = false
    var hasError = false
    var errorMessage = ""
    
    @MainActor
    func createAccount(email: String, password: String) async {
        
        isLoading = true
        hasError = false
        errorMessage = ""
        
        do {
            try await authService.createAccount(
                email: email,
                password: password)
            
            self.isLoading = false
            
        } catch {
            self.isLoading = false
            self.hasError = true
            self.errorMessage = error.localizedDescription
        }
    }
}
