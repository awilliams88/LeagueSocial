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
        checkIfAlreadyAuthenticated()
    }
    
    func login() async {
        guard validateInputs() else { return }
        do {
            state = .loading
            let token = try await api.login(username: username, password: password)
            state = .success(token: token)
        } catch {
            state = .failure(error: error.localizedDescription)
        }
    }
    
    func continueAsGuest() {
        state = .success(token: "")
        validationMessage = nil
    }
    
    private func checkIfAlreadyAuthenticated() {
        if let token = api.authToken() {
            state = .success(token: token)
        }
    }
    
    private func validateInputs() -> Bool {
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
