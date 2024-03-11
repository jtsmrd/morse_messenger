//
//  RootViewModel.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/3/24.
//

import SwiftUI
import Combine
import Firebase

@Observable
class RootViewModel {
    
    @ObservationIgnored
    private let accountManager = AccountManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    var account: Account?
    var isLoggedOut: Bool = true
    var showLogin: Bool = false
    private var isLoading: Bool = false
        
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        
        accountManager.$isLoggedOut
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] isLoggedOut in
                
                if isLoggedOut == true && self?.isLoading == false {
                    self?.showLogin = true
                } else if isLoggedOut == false && self?.isLoading == false {
                    self?.showLogin = false
                }
            }
            .store(in: &cancellables)
        
        accountManager.$isLoading
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
                
                if isLoading == false && self?.isLoggedOut == true {
                    self?.showLogin = true
                }
            }
            .store(in: &cancellables)
        
        accountManager.$account
            .removeDuplicates()
            .sink { [weak self] account in
                
                if account != nil {
                    self?.account = account
                    self?.isLoggedOut = false
                }
            }
            .store(in: &cancellables)
    }
}
