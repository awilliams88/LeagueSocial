//
//  Token.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import Foundation

struct Token: Codable {
    let key: String

    enum CodingKeys: String, CodingKey {
        case key = "api_key"
    }
}
