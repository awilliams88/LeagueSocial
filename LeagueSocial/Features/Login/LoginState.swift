//
//  LoginState.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

enum LoginState: Equatable {
    case idle
    case loading
    case success(token: String)
    case failure(error: String)
}
