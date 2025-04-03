//
//  KeychainTokenStore.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import Foundation
import Security

/// A Keychain-based implementation of `TokenStore` for secure token storage.
public final class KeychainTokenStore: TokenStore {
    
    private let tokenKey = "com.leaguesocial.token"

    /// Saves the token to the Keychain. Overwrites any existing token.
    public func saveToken(_ token: String) -> Bool {
        guard let data = token.data(using: .utf8) else { return false }

        // Remove any existing token to avoid duplicates
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey
        ]
        SecItemDelete(deleteQuery as CFDictionary)

        // Add the new token
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data
        ]

        return SecItemAdd(addQuery as CFDictionary, nil) == errSecSuccess
    }

    /// Loads the stored token from the Keychain, if it exists.
    public func loadToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }

        return String(data: data, encoding: .utf8)
    }

    /// Deletes the stored token from the Keychain.
    public func deleteToken() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey
        ]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
