//
//  LoginView.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import SwiftUI

struct LoginView: View {
    @State private var isAuthenticated = false
    @StateObject private var viewModel: LoginViewModel
    @Environment(\.dependencies) private var dependencies

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 24) {

            // Title
            Text("League Social")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 24)

            // Form Fields
            VStack(spacing: 16) {
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Validation Message
                if let message = viewModel.validationMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundColor(.red)
                }

                // Error Message
                if case let .failure(error) = viewModel.state {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            VStack(spacing: 16) {

                // Login Button
                Button(action: {
                    Task {
                        guard viewModel.validateInputs() else { return }
                        await viewModel.login()
                    }
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Guest Button
                Button(action: {
                    Task { await viewModel.login(isGuest: true) }
                }) {
                    Text("Continue as Guest")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 34)

            // Progress View
            if case .loading = viewModel.state {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top)
            }

            Spacer()
        }
        .padding(24)
        .background(Color.teal.opacity(0.14))
        .onAppear {
            // Reset view state and check for valid token
            viewModel.resetState()
            viewModel.isTokenValid()
        }
        .onChange(of: viewModel.state) { _, state in
            // Authenticate user when login state changes to success
            if case .success = state {
                isAuthenticated = true
            }
        }
        .navigationDestination(isPresented: $isAuthenticated) {
            PostListView(viewModel: PostListViewModel(
                api: dependencies.apiService,
                isGuest: viewModel.isGuest
            ))
        }
    }
}

#Preview {
    NavigationStack {
        LoginView(viewModel: LoginViewModel(api: MockAPIService()))
            .environment(\.dependencies, Container(apiService: MockAPIService()))
    }
}
