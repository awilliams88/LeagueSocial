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
}
