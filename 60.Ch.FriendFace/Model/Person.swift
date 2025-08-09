//
//  Person.swift
//  60.Ch.FriendFace
//
//  Created by Валентин on 09.08.2025.
//

import Foundation
import SwiftData

@Model
class Person {
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
    
    init(from apiItem: PersonAPI) {
        self.id = apiItem.id
        self.isActive = apiItem.isActive
        self.name = apiItem.name
        self.age = apiItem.age
        self.company = apiItem.company
        self.address = apiItem.address
        self.about = apiItem.about
        self.registered = apiItem.registered
        self.tags = apiItem.tags
        self.friends = apiItem.friends.map { Friend(id: $0.id, name: $0.name) }
     }
    
    init(id: String, isActive: Bool, name: String, age: Int, company: String, address: String, about: String, registered: Date, tags: [String], friends: [Friend]) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.address = address
        self.about = about
        self.registered = registered
        self.tags = tags
        self.friends = friends
    }
}

@Model
class Friend {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

