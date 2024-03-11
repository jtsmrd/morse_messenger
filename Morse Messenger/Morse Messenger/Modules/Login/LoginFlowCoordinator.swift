//
//  LoginFlowCoordinator.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/3/24.
//

import SwiftUI
import Combine

enum LoginPage: String, Identifiable {
    case login
    case registration
    case createUser
    
    var id: String {
        self.rawValue
    }
}

@Observable
final class LoginFlowCoordinator: Hashable, CustomDebugStringConvertible {
    
    var page: LoginPage
    
    private var id: UUID
    private var cancellables = Set<AnyCancellable>()
    
    let pushCoordinator = PassthroughSubject<LoginFlowCoordinator, Never>()
    
    init(page: LoginPage) {
        
        id = UUID()
        self.page = page
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self.page {
        case .login:
            loginView()
        case .registration:
            registrationView()
        case .createUser:
            createAccountView()
        }
    }
    
    private func loginView() -> some View {
        let loginVM = LoginViewModel()
        bind(viewModel: loginVM)
        let loginView = LoginView(loginVM: loginVM)
        return loginView
    }
    
    private func bind(viewModel: LoginViewModel) {
        viewModel.createAccountSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showRegistrationView()
            }
            .store(in: &cancellables)
    }
    
    private func registrationView() -> some View {
        let registrationVM = RegistrationViewModel()
        let registrationView = RegistrationView(registrationVM: registrationVM)
        return registrationView
    }
    
    private func createAccountView() -> some View {
        let createAccountVM = CreateAccountViewModel()
        let createAccountView = CreateAccountView(createAccountVM: createAccountVM)
        return createAccountView
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LoginFlowCoordinator, rhs: LoginFlowCoordinator) -> Bool {
        return lhs.id == rhs.id
    }
    
    var debugDescription: String {
        "\(page)"
    }
}

extension LoginFlowCoordinator {
    
    private func showRegistrationView() {
        pushCoordinator.send(LoginFlowCoordinator(page: .registration))
    }
}
