//
//  LoginNavigationRouter.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/3/24.
//

import SwiftUI
import Combine

@Observable
class LoginNavigationRouter {
    
    private let authService = AuthenticationService.shared
    private let accountManager = AccountManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    private var rootCoordinator: LoginFlowCoordinator
    
    var path: NavigationPath

    
    init() {
        path = NavigationPath()
        rootCoordinator = LoginFlowCoordinator(page: .login)
        bind(loginFlowCoordinator: rootCoordinator)
                
        subscribeToLoginStatus()
        
        subscribeToCreateUserFlag()
    }
    
    @ViewBuilder
    func view() -> some View {
        rootCoordinator.view()
    }
    
    private func subscribeToCreateUserFlag() {
        accountManager.$createUser
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] createUser in
                if createUser {
                    self?.showCreateUser()
                }
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToLoginStatus() {
        accountManager.$isLoggedOut
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] loggedOut in
                if loggedOut == false {
                    self?.path = NavigationPath()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bind(loginFlowCoordinator: LoginFlowCoordinator) {
        loginFlowCoordinator.pushCoordinator
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coordinator in
                self?.push(coordinator)
            }
            .store(in: &cancellables)
    }
    
    private func push(_ coordinator: LoginFlowCoordinator) {
        bind(loginFlowCoordinator: coordinator)
        path.append(coordinator)
    }
    
}

extension LoginNavigationRouter {
    
    private func showCreateUser() {
        push(.init(page: .createUser))
    }
}
