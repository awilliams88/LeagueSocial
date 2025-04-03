//
//  MockAPIService.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

/// Mocked API service for testing and preview purposes
public final class MockAPIService: APIServiceProtocol {
    func logout() {}
    func authToken() -> String? { "1234" }
    func fetchUsers() async throws -> [User] { [ User.userA, User.userB ] }
    func fetchPosts() async throws -> [Post] { Post.mock }
    func login(username: String, password: String) async throws -> String { ""}
}
