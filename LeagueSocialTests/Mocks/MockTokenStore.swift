//
//  MockTokenStore.swift
//  LeagueSocialTests
//
//  Created by Arpit Williams on 03/04/25.
//

@testable import LeagueSocial

final class MockTokenStore: TokenStore {
    var savedToken: String?
    func loadToken() -> String? { savedToken }
    func deleteToken() -> Bool { savedToken = nil; return true }
    func saveToken(_ token: String) -> Bool { savedToken = token; return true }
}
