//
//  PasswordTextField.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI

struct PasswordTextField: View {
    
    @Binding var passwordText: String
    @Binding var isValidPassword: Bool
    let validatePassword: (String) -> Bool
    let errorText: String
    let placeholder: String
    
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            SecureField(placeholder, text: $passwordText)
                .focused($focusedField, equals: .password)
                .padding()
                .background(Color("secondaryBlue"))
                .cornerRadius(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(!isValidPassword ? .red : focusedField == .password ? Color("primaryBlue"): .white, lineWidth: 3)
                )
                .padding(.horizontal)
                .onChange(of: passwordText) {
                    isValidPassword = validatePassword(passwordText)
                }
            
            if !isValidPassword {
                HStack {
                    Text(errorText)
                        .foregroundColor(.red)
                        .padding(.leading)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    PasswordTextField(
        passwordText: .constant(""),
        isValidPassword: .constant(false),
        validatePassword: Validator.validatePassword,
        errorText: "Password Error",
        placeholder: "Password")
}
