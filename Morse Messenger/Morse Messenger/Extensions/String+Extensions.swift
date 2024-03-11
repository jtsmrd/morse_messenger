//
//  String+Extensions.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/7/24.
//

import Foundation

extension String {
    
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
