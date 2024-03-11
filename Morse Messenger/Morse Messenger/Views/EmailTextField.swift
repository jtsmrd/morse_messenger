//
//  EmailTextField.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI

struct EmailTextField: View {
    
    @Binding var emailText: String
    @Binding var isValidEmail: Bool
    
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            TextField("Email", text: $emailText)
                .focused($focusedField, equals: .email)
                .padding()
                .background(Color("secondaryBlue"))
                .cornerRadius(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(!isValidEmail ? .red : focusedField == .email ? Color("primaryBlue"): .white, lineWidth: 3)
                )
                .padding(.horizontal)
                .onChange(of: emailText) {
                    isValidEmail = Validator.validateEmail(emailText)
                }
                .padding(.bottom, isValidEmail ? 16 : 0)
            
            if !isValidEmail {
                HStack {
                    Text("Please enter a valid email")
                        .foregroundColor(.red)
                        .padding(.leading)
                    Spacer()
                }
                .padding(.bottom, isValidEmail ? 0 : 16)
            }
        }
    }
}

#Preview {
    EmailTextField(emailText: .constant(""), isValidEmail: .constant(true))
}
