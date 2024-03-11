//
//  LoginNavigationView.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI

struct LoginNavigationView: View {
    @State var loginRouter: LoginNavigationRouter
    
    var body: some View {
        NavigationStack(path: $loginRouter.path) {
            loginRouter.view()
                .navigationDestination(for: LoginFlowCoordinator.self) { coordinator in
                    coordinator.view()
                }
        }
    }
}

#Preview {
    LoginNavigationView(loginRouter: .init())
}
