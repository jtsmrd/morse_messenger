//
//  StandardTextField.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI

struct StandardTextField: View {
    
    let validateText: ((String) -> Bool)? = nil
    let errorText: String = ""
    let placeholder: String
    
    @Binding var textValue: String
    @Binding var isValid: Bool
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $textValue)
                .focused($isFocused)
                .padding()
                .background(Color("secondaryBlue"))
                .cornerRadius(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(!isValid ? .red : isFocused ? Color("primaryBlue"): .white, lineWidth: 3)
                )
                .padding(.horizontal)
                .onChange(of: textValue) {
                    if let validateText {
                        isValid = validateText(textValue)
                    } else {
                        isValid = true
                    }
                }
                .padding(.bottom, isValid ? 16 : 0)
            
            if !isValid {
                HStack {
                    Text(errorText)
                        .foregroundColor(.red)
                        .padding(.leading)
                    Spacer()
                }
                .padding(.bottom, isValid ? 0 : 16)
            }
        }
    }
}

#Preview {
    StandardTextField(placeholder: "", textValue: .constant(""), isValid: .constant(true))
}
