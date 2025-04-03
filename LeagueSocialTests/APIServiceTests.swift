//
//  APIServiceTests.swift
//  LeagueSocialTests
//
//  Created by Arpit Williams on 03/04/25.
//

@testable import LeagueSocial
import XCTest

final class APIServiceTests: XCTestCase {
    private var tokenStore: MockTokenStore!
    private var apiService: APIService!

    override func setUp() {
        super.setUp()
        tokenStore = MockTokenStore()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        apiService = APIService(session: session, tokenStore: tokenStore)
    }

    func test_login_success() async throws {
        let expectedToken = "test-token"
        MockURLProtocol.responseHandler = { _ in
            let jsonData = """
            { "api_key": "\(expectedToken)" }
            """.data(using: .utf8)!

            let response = HTTPURLResponse(
                url: APIEndpoints.login!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, jsonData)
        }
        let token = try await apiService.login(username: "user", password: "pass")
        XCTAssertEqual(token, expectedToken)
        XCTAssertEqual(tokenStore.savedToken, expectedToken)
    }

    func test_login_failure() async {
        MockURLProtocol.responseHandler = { _ in
            let malformedJSON = """
            { "invalid_key": "no_api_key_here" }
            """.data(using: .utf8)!
            let response = HTTPURLResponse(url: APIEndpoints.login!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, malformedJSON)
        }

        do {
            _ = try await apiService.login(username: "user", password: "pass")
            XCTFail("Expected decodingFailed error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error.localizedDescription, NetworkError.decodingFailed.localizedDescription)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchPosts_success() async throws {
        tokenStore.savedToken = "valid-token"
        let mockPosts: [Post] = [.mock.first!]
        let mockData = try JSONEncoder().encode(mockPosts)
        MockURLProtocol.responseHandler = { _ in
            let response = HTTPURLResponse(url: APIEndpoints.posts!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockData)
        }
        let posts = try await apiService.fetchPosts()
        XCTAssertEqual(posts.count, 1)
        XCTAssertEqual(posts.first?.id, mockPosts.first?.id)
    }

    func test_fetchPosts_failure() async {
        do {
            tokenStore.savedToken = nil
            _ = try await apiService.fetchPosts()
            XCTFail("Expected unauthorized error")
        } catch let error as NetworkError {
            XCTAssertEqual(error.localizedDescription, NetworkError.unauthorized.localizedDescription)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchUsers_success() async throws {
        tokenStore.savedToken = "valid-token"
        let mockUsers = [User.userA, User.userB]
        let mockData = try JSONEncoder().encode(mockUsers)
        MockURLProtocol.responseHandler = { _ in
            let response = HTTPURLResponse(url: APIEndpoints.users!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockData)
        }
        let users = try await apiService.fetchUsers()
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users.first?.id, mockUsers.first?.id)
    }

    func test_fetchUsers_failure() async {
        do {
            tokenStore.savedToken = nil
            _ = try await apiService.fetchUsers()
            XCTFail("Expected unauthorized error")
        } catch let error as NetworkError {
            XCTAssertEqual(error.localizedDescription, NetworkError.unauthorized.localizedDescription)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_authToken_returnsStoredToken() {
        tokenStore.savedToken = "abc123"
        let token = apiService.authToken()
        XCTAssertEqual(token, "abc123")
    }

    func test_logout_deletesToken() {
        tokenStore.savedToken = "abc123"
        apiService.logout()
        XCTAssertNil(tokenStore.savedToken)
    }
}
