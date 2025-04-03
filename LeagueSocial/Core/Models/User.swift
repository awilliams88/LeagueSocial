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
