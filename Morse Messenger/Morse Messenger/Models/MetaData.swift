//
//  MetaData.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/3/24.
//

import Firebase

struct MetaData: Codable {
    
    var createDate: Date
    var updateDate: Date
    var syncDate: Date
    
    init() {
        self.createDate = Date()
        self.updateDate = Date()
        self.syncDate = Date()
    }
    
    init(data: [String: Any]) {
        self.createDate = (data["createDate"] as! Firebase.Timestamp).dateValue()
        self.updateDate = (data["updateDate"] as! Firebase.Timestamp).dateValue()
        self.syncDate = (data["syncDate"] as! Firebase.Timestamp).dateValue()
    }
}

extension MetaData {
    
    var toFirebaseData: [String: Any] {
        [
            FirebaseConstants.createDate: createDate,
            FirebaseConstants.updateDate: updateDate,
            FirebaseConstants.syncDate: syncDate
        ]
    }
}

extension MetaData: CustomDebugStringConvertible {
    
    var debugDescription: String {
        """
        createDate: \(createDate),\n
        updateDate: \(updateDate),\n
        syncDate: \(syncDate)
        """
    }
}
