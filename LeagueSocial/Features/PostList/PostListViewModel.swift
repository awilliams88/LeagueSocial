//
//  PostListViewModel.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

import Foundation

@MainActor
final class PostListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    let isGuest: Bool
    let api: APIServiceProtocol

    init(api: APIServiceProtocol, isGuest: Bool = false) {
        self.api = api
        self.isGuest = isGuest
    }

    /// Loads posts and users, then maps user to corresponding post.
    func loadPosts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Fetch posts and users concurrently for performance
            async let fetchedPosts = api.fetchPosts()
            async let fetchedUsers = api.fetchUsers()
            let posts = try await fetchedPosts
            let users = try await fetchedUsers

            // Create a user lookup dictionary [userId: User]
            let userMap = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })

            // Attach corresponding user to each post (if found)
            self.posts = posts.map {
                var post = $0
                post.user = userMap[post.userId]
                return post
            }

        } catch {
            // Show error message
            errorMessage = error.localizedDescription
        }
    }

    /// Clears stored token (if any) from keychain token store.
    func logout() {
        api.logout()
    }
}
