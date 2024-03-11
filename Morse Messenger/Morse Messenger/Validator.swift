//
//  Validator.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import Foundation

enum Validator {
    static func validateEmail(_ email: String) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"

        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    static func validateUsername(_ username: String) -> Bool {
        let usernameRegex = #"^[a-zA-Z0-9._-]{5,20}$"#
        
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }
    
    // TODO:
    static func isEmail() -> Bool {
        
        return false
    }
    
    // TODO:
    static func isPhoneNumber() -> Bool {
        
        return false
    }
}
