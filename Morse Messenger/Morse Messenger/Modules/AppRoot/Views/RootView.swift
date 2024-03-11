//
//  RootView.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/3/24.
//

import SwiftUI

struct RootView: View {
    
    @State var rootVM: RootViewModel
    @State var loginRouter = LoginNavigationRouter()
    
    var body: some View {
        VStack {
            if let account = rootVM.account {
                Text("Logged in")
            } else {
                AppLoadingView()
            }
        }
        .fullScreenCover(isPresented: $rootVM.showLogin) {
            LoginNavigationView(loginRouter: loginRouter)
        }
    }
}

#Preview {
    RootView(rootVM: .init())
}
