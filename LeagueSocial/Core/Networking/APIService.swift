//
//  APIService.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import Foundation

final class APIService: APIServiceProtocol {
    private let session: URLSession
    private let tokenStore: TokenStore

    /// Initializes the API service with optional custom dependencies.
    /// - Parameters:
    ///   - session: The URLSession to use for network calls (defaults to `.shared`).
    ///   - tokenStore: A secure token storage mechanism (defaults to `KeychainTokenStore`).
    init(session: URLSession = .shared, tokenStore: TokenStore = KeychainTokenStore()) {
        self.session = session
        self.tokenStore = tokenStore
    }
}

// MARK: - Public Methods

extension APIService {
    /// Fetches the list of posts. Requires a valid access token.
    /// - Returns: Array of `Post` objects.
    func fetchPosts() async throws -> [Post] {
        let request = try makeGETRequest(to: APIEndpoints.posts)
        let data = try await perform(request: request)
        return try JSONDecoder().decode([Post].self, from: data)
    }

    /// Fetches the list of users. Requires a valid access token.
    /// - Returns: Array of `User` objects.
    func fetchUsers() async throws -> [User] {
        let request = try makeGETRequest(to: APIEndpoints.users)
        let data = try await perform(request: request)
        return try JSONDecoder().decode([User].self, from: data)
    }

    /// Logs in the user using username and password, and stores the access token in Keychain.
    /// - Parameters:
    ///   - username: The username for login.
    ///   - password: The password for login.
    /// - Returns: Access token string if successful.
    func login(username: String, password: String) async throws -> String {
        // Create url with components
        guard let url = APIEndpoints.login,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { throw NetworkError.invalidURL }

        // Add query items to components
        components.queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password),
        ]

        // Create request and fetch response data
        guard let url = components.url else { throw NetworkError.invalidURL }
        let request = URLRequest(url: url)
        let data = try await perform(request: request, requiresAuth: false)

        // Decode and persist token in key chain token store
        guard let token = try? JSONDecoder().decode(Token.self, from: data) else {
            throw NetworkError.decodingFailed
        }
        tokenStore.saveToken(token.key)

        return token.key
    }

    /// Deletes stored token from key chain token store
    func logout() {
        tokenStore.deleteToken()
    }

    /// Returns stored token from keychain store if it exists
    func authToken() -> String? {
        guard let token = tokenStore.loadToken() else { return nil }
        return token
    }
}

// MARK: - Private Helpers

extension APIService {
    /// Builds a GET request with authorization header.
    private func makeGETRequest(to url: URL?) throws -> URLRequest {
        guard let url = url else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Load token from keychain store and add it to all GET requests
        guard let token = tokenStore.loadToken() else {
            throw NetworkError.unauthorized
        }

        request.addValue(token, forHTTPHeaderField: "x-access-token")
        return request
    }

    /// Performs the request and handles basic response validation.
    private func perform(request: URLRequest, requiresAuth _: Bool = true) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }

        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 401 {
                throw NetworkError.unauthorized
            }
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }

        return data
    }
}
