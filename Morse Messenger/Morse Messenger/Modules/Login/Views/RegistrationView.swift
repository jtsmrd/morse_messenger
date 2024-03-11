//
//  RegistrationView.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI

struct RegistrationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var registrationVM: RegistrationViewModel
    
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @FocusState private var focusedField: FocusedField?
    
    private var canProceed: Bool {
        !emailText.isEmptyOrWhiteSpace
        && !passwordText.isEmptyOrWhiteSpace
        && Validator.validateEmail(emailText)
        && Validator.validatePassword(passwordText)
    }
    
    var body: some View {
        ZStack {
            if registrationVM.isLoading {
                ProgressView()
            }
            VStack {
                Text("Create Account")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color("primaryBlue"))
                    .padding(.bottom)
                    .padding(.top, 48)
                
                EmailTextField(
                    emailText: $emailText,
                    isValidEmail: $isValidEmail)
                
                PasswordTextField(
                    passwordText: $passwordText,
                    isValidPassword: $isValidPassword,
                    validatePassword: Validator.validatePassword,
                    errorText: "Your password is not valid",
                    placeholder: "Password")
                
                continueButton
            }
            .opacity(registrationVM.isLoading ? 0.5 : 1.0)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .alert("Error", isPresented: $registrationVM.hasError) {
                Button("Ok") {
                    dismiss()
                }
            } message: {
                Text(registrationVM.errorMessage)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var continueButton: some View {
        Button {
            Task {
                await registrationVM.createAccount(
                    email: emailText,
                    password: passwordText)
            }
        } label: {
            Text("Continue")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(.vertical)
        }
        .frame(maxWidth: .infinity)
        .background(Color("primaryBlue"))
        .cornerRadius(12)
        .padding(.horizontal)
        .opacity(canProceed ? 1.0 : 0.5)
        .disabled(!canProceed)
        .padding(.top, 30)
    }
}

#Preview {
    RegistrationView(registrationVM: .init())
}
