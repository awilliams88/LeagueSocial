//
//  Post.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import Foundation

struct Post: Identifiable, Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
    var user: User?
}

// MARK: - Mocks

extension Post {
    static let mock: [Post] = [
        Post(id: 1, userId: 101, title: "Welcome to League", body: "This is your first post.", user: User.userA),
        Post(id: 2, userId: 102, title: "SwiftUI Rocks", body: "Loving the declarative way!", user: User.userB),
    ]
}
