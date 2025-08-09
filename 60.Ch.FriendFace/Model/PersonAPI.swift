//
//  Model.swift
//  60.Ch.FriendFace
//
//  Created by Валентин on 30.07.2025.
//

import Foundation
import SwiftData

struct PersonAPI: Codable, Identifiable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [FriendAPI]
}

struct FriendAPI: Codable {
    let id: String
    let name: String
}
