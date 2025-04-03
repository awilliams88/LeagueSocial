//
//  APIServiceProtocol.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import Foundation

protocol APIServiceProtocol {
    func logout()
    func authToken() -> String?
    func fetchUsers() async throws -> [User]
    func fetchPosts() async throws -> [Post]
    func login(username: String, password: String) async throws -> String
}
