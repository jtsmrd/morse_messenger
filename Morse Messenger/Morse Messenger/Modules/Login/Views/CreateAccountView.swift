//
//  CreateAccountView.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI

struct CreateAccountView: View {
    
    @State var createAccountVM: CreateAccountViewModel
    
    @State private var shouldShowImagePicker = false
    @State private var userImage: UIImage?
    @State private var fullName = ""
    @State private var username = ""
    @State private var isValidName = true
    @State private var isValidUsername = true
    
    private var canProceed: Bool {
        !username.isEmptyOrWhiteSpace
        && !fullName.isEmptyOrWhiteSpace
        && isValidName
        && isValidUsername
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Button {
                shouldShowImagePicker.toggle()
            } label: {
                VStack {
                    if let userImage {
                        Image(uiImage: userImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
                            .cornerRadius(64)
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 64))
                            .padding()
                            .foregroundColor(Color(.label))
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 64)
                        .stroke(Color.black, lineWidth: 3)
                )
            }
            StandardTextField(
                placeholder: "Full name",
                textValue: $fullName,
                isValid: $isValidName)
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            
            StandardTextField(
                placeholder: "Username",
                textValue: $username,
                isValid: $isValidUsername)
            .textInputAutocapitalization(.none)
            .autocorrectionDisabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .onChange(of: username) {
                Task {
                    await createAccountVM.checkUsernameAvailability(username)
                }
            }
            Button {
                Task {
                    print("Create user called")
                    await createAccountVM.createNewUser(
                        image: userImage,
                        fullName: fullName,
                        username: username)
                }
            } label: {
                Text("Create account")
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
        }
        .padding()
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $userImage)
        }
    }
}

#Preview {
    CreateAccountView(createAccountVM: .init())
}
