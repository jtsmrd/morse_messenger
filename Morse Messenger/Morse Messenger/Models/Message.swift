//
//  Message.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/3/24.
//

import SwiftData

@Model
class Message {
    
    @Attribute(.unique) var id: String
    var encodedMessage: String
    var decodedMessage: String
    var senderId: String
    var metaData: MetaData
    
    init(
        id: String,
        encodedMessage: String,
        decodedMessage: String,
        senderId: String,
        metaData: MetaData
    ) {
        self.id = id
        self.encodedMessage = encodedMessage
        self.decodedMessage = decodedMessage
        self.senderId = senderId
        self.metaData = metaData
    }
}
