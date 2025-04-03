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
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("League Social")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 24)
            
            VStack(spacing: 16) {
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let message = viewModel.validationMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                
                if case .failure(let error) = viewModel.state {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            VStack(spacing: 16) {
                Button(action: {
                    Task { await viewModel.login() }
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.continueAsGuest()
                }) {
                    Text("Continue as Guest")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 40)
            
            if case .loading = viewModel.state {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top)
            }
            
            Spacer()
        }
        .padding(24)
        .background(Color.teal.opacity(0.1))
        .onChange(of: viewModel.state) { _, state in
            if case .success = state {
                isAuthenticated = true
            }
        }
        .navigationDestination(isPresented: $isAuthenticated) {}
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(api: MockAPIService()))
        .environment(\.dependencies, Container(apiService: MockAPIService()))
}
