//
//  LoginViewModel.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI
import Combine

@Observable
class LoginViewModel {
    
    private let authService = AuthenticationService.shared
    
    let createAccountSelected = PassthroughSubject<Void, Never>()
    
    var isLoading = false
    var hasError = false
    var errorMessage = ""
    
    
    @MainActor
    func loginUser(with email: String, password: String) async {
        
        isLoading = true
        hasError = false
        errorMessage = ""
        
        do {
            try await authService.login(
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
