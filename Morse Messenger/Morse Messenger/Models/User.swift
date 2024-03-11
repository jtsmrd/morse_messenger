//
//  User.swift
//  Morse Messenger
//
//  Created by JT Smrdel on 3/3/24.
//

import Foundation
import SwiftData

@Model
class User: Codable {
    
    @Attribute(.unique) var id: String
    var username: String
    var fullName: String
    var profileImageUrl: String?
    var metaData: MetaData
    
    init(
        id: String,
        username: String,
        fullName: String,
        profileImageUrl: String? = nil,
        metaData: MetaData = .init()
    ) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.profileImageUrl = profileImageUrl
        self.metaData = metaData
    }
    
    convenience init(data: [String: Any]) {
        self.init(
            id: data["uid"] as! String,
            username: data["username"] as! String,
            fullName: data["fullName"] as! String,
            profileImageUrl: data["profileImageUrl"] as? String,
            metaData: .init(data: data["metaData"] as! [String: Any]))
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl)
        self.metaData = try container.decode(MetaData.self, forKey: .metaData)
    }
    
    
    enum CodingKeys: CodingKey {
        case id
        case username
        case fullName
        case profileImageUrl
        case metaData
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(fullName, forKey: .fullName)
        try container.encodeIfPresent(profileImageUrl, forKey: .profileImageUrl)
        try container.encode(metaData, forKey: .metaData)
    }
}

extension User {
    
    var toFirebaseData: [String: Any] {
        [
            FirebaseConstants.uid: id,
            FirebaseConstants.username: username,
            FirebaseConstants.fullName: fullName,
            FirebaseConstants.profileImageUrl: profileImageUrl as Any,
            FirebaseConstants.metaData: metaData.toFirebaseData
        ]
    }
}

extension User: CustomDebugStringConvertible {
    var debugDescription: String {
        """
        id: \(id),\n
        username: \(username),\n
        fullName: \(fullName),\n
        profileImageUrl: \(String(describing: profileImageUrl)),\n
        metaData:\n
            \(metaData.debugDescription)
        """
    }
}
