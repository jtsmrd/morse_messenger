//
//  Conversation.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/3/24.
//

import SwiftData

@Model
class Conversation {
    
    @Attribute(.unique) var id: String
    var lastMessage: String
    var isDeleted: Bool
    var members: [User]
    var messages: [Message]
    var metaData: MetaData
    
    init(
        id: String,
        lastMessage: String,
        isDeleted: Bool,
        members: [User],
        messages: [Message],
        metaData: MetaData
    ) {
        self.id = id
        self.lastMessage = lastMessage
        self.isDeleted = isDeleted
        self.members = members
        self.messages = messages
        self.metaData = metaData
    }
}
