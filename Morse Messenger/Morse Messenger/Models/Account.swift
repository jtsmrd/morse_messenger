//
//  Account.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/3/24.
//

import SwiftData

@Model
class Account {
    
    @Attribute(.unique) var id: String
    var user: User
    var conversations: [Conversation]
    
    init(
        id: String,
        user: User,
        conversations: [Conversation] = []
    ) {
        self.id = id
        self.user = user
        self.conversations = conversations
    }
}
