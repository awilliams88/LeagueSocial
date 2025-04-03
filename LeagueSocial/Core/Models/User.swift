//
//  User.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: Int
    let avatar: URL
    let name: String
    let email: String
    let username: String
}

// MARK: - Mocks

extension User {
    
    static let userA = User(
        id: 101,
        avatar: URL(string: "https://i.pravatar.cc/150?u=Sincere@april.biz")!,
        name: "Axl Rose",
        email: "axl@league.biz",
        username: "axlrose"
    )
    
    static let userB = User(
        id: 102,
        avatar: URL(string: "https://example.co/avatar.png")!,
        name: "Jane Doe",
        email: "jane@league.dev",
        username: "jdoe"
    )
}
