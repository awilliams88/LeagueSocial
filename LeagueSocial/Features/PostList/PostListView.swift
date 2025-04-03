//
//  PostListView.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import SwiftUI

struct PostListView: View {
    @State private var selectedUser: User?
    @State private var showExitAlert = false
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PostListViewModel
    
    init(viewModel: PostListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        // List View
        List {
            ForEach(viewModel.posts) { post in
                PostRowView(post: post) {
                    selectedUser = post.user
                }
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
            }
        }
        // List Background
        .scrollContentBackground(.hidden)
        .background(Color(.mint.opacity(0.2)))
        // Navigation bar
        .navigationTitle("Posts")
        .navigationBarBackButtonHidden(true)
        // Toolbar
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Logout button
                Button(viewModel.isGuest ? "Exit" : "Logout") {
                    if viewModel.isGuest {
                        showExitAlert = true
                    } else {
                        viewModel.logout()
                        dismiss()
                    }
                }
            }
        }
        // Progress view
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        // Error Alert
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: { Text(viewModel.errorMessage ?? "") }
        // Exit Alert
        .alert("Thank you for trialing this app 🙏", isPresented: $showExitAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Exit", role: .destructive) { dismiss() }
        } message: { Text("You’re currently logged in as a guest.") }
        // User Info View
        .sheet(item: $selectedUser) { UserInfoView(user: $0) }
        // Load Posts
        .task { await viewModel.loadPosts() }
    }
}

#Preview {
    NavigationStack {
        PostListView(viewModel: PostListViewModel(api: MockAPIService(), isGuest: true))
            .environment(\.dependencies, Container(apiService: MockAPIService()))
    }
}
