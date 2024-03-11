//
//  View+Extensions.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import SwiftUI

extension View {
    
    var iconButtonStyle: some View {
        self.padding()
            .background(Color("lightGray"))
            .cornerRadius(8)
    }
    
    func withoutAnimation(action: @escaping () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
}
