//
//  LoginView.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI

enum FocusedField {
    case email
    case password
    case fullName
    case username
}

struct LoginView: View {
    
    @State var loginVM: LoginViewModel
    @State var authenticationProviderVM = AuthenticationProviderViewModel()
    
    @State var emailText = ""
    @State var passwordText = ""
    @State var isValidEmail = true
    @State var isValidPassword = true
    @State var focusedField: FocusedField?
    
    private var canProceed: Bool {
        !emailText.isEmptyOrWhiteSpace
        && !passwordText.isEmptyOrWhiteSpace
        && isValidEmail
        && isValidPassword
    }
    
    var body: some View {
        ZStack {
            
            if loginVM.isLoading {
                ProgressView()
            }
            
            VStack {
                Text("Welcome to")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .padding()
                
                Text("Morse Messenger")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color("primaryBlue"))
                    .padding(.bottom)
                
                EmailTextField(
                    emailText: $emailText,
                    isValidEmail: $isValidEmail)
                
                PasswordTextField(
                    passwordText: $passwordText,
                    isValidPassword: $isValidPassword,
                    validatePassword: Validator.validatePassword,
                    errorText: "Your password is not valid",
                    placeholder: "Password")
                
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Forgot your password?")
                            .foregroundColor(Color("primaryBlue"))
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .padding()
                }
                
                Button {
                    Task {
                        await loginVM.loginUser(
                            with: emailText,
                            password: passwordText)
                    }
                } label: {
                    Text("Sign in")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color("primaryBlue"))
                .cornerRadius(12)
                .padding([.horizontal, .top])
                .opacity(canProceed ? 1.0 : 0.5)
                .disabled(!canProceed)
                
                Button {
                    loginVM.createAccountSelected.send()
                } label: {
                    Text("Create new account")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("gray"))
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background()
                .cornerRadius(12)
                .padding(.horizontal)
                
                AuthenticationProviderView(authenticationProviderVM: authenticationProviderVM)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Error", isPresented: $loginVM.hasError) {
            Button("Ok") {
                isValidEmail = false
                isValidPassword = false
                emailText = ""
                passwordText = ""
            }
        } message: {
            Text(loginVM.errorMessage)
        }
    }
}

#Preview {
    LoginView(loginVM: .init(), authenticationProviderVM: .init())
}
