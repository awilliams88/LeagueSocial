//
//  LoginViewModel.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var state: LoginState = .idle
    @Published var validationMessage: String?
    
    private let api: APIServiceProtocol
    init(api: APIServiceProtocol) {
        self.api = api
    }
    
    /// Calls the login api service to authenticate user
    func login() async {
        do {
            state = .loading
            let token = try await api.login(username: username, password: password)
            state = .success(token: token)
        } catch {
            state = .failure(error: error.localizedDescription)
        }
    }
    
    /// Resets state of view model
    func resetState() {
        state = .idle
        username = ""
        password = ""
    }
    
    /// Skips login screen if a valid token already exists.
    func checkIfAlreadyAuthenticated() {
        if let token = api.authToken(), !token.isEmpty {
            state = .success(token: token)
        }
    }
    
    /// Validates text input for username and password fields.
    func validateInputs() -> Bool {
        if username.trimmingCharacters(in: .whitespaces).count < 4 {
            validationMessage = "Username must be at least 4 characters."
            return false
        }
        
        if password.count < 6 {
            validationMessage = "Password must be at least 6 characters."
            return false
        }
        
        validationMessage = nil
        return true
    }
}
