//
//  TokenStore.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import Foundation

/// Protocol for secure access token management.
public protocol TokenStore {
    func loadToken() -> String?
    @discardableResult func deleteToken() -> Bool
    @discardableResult func saveToken(_ token: String) -> Bool
}
