//
//  APIEndpoints.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import Foundation

enum APIEndpoints {
    static let baseURL = "https://engineering.league.dev/challenge/api"
    static let login = URL(string: "\(baseURL)/login")
    static let posts = URL(string: "\(baseURL)/posts")
    static let users = URL(string: "\(baseURL)/users")
}
