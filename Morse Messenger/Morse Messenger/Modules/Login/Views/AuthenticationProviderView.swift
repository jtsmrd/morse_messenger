//
//  AuthenticationProviderView.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI

struct AuthenticationProviderView: View {
    
    @State var authenticationProviderVM: AuthenticationProviderViewModel
    
    var body: some View {
        VStack {
            Text("Or continue with")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color("primaryBlue"))
                .padding(.bottom)
            
            HStack {
                Button {
                    authenticationProviderVM.signInWithApple()
                } label: {
                    Image("apple-logo")
                }
                .iconButtonStyle
                
                Button {
                    Task {
                        await authenticationProviderVM.signInWithGoogle()
                    }
                } label: {
                    Image("google-logo")
                }
                .iconButtonStyle
                
                Button {
                    authenticationProviderVM.signInWithFacebook()
                } label: {
                    Image("facebook-logo")
                }
                .iconButtonStyle
            }
        }
    }
}

#Preview {
    AuthenticationProviderView(authenticationProviderVM: .init())
}
