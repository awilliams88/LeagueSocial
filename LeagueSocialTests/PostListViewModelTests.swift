//
//  PostListViewModelTests.swift
//  LeagueSocialTests
//
//  Created by Arpit Williams on 03/04/25.
//

@testable import LeagueSocial
import XCTest

@MainActor
final class PostListViewModelTests: XCTestCase {
    private var mockAPI: MockAPIService!
    private var viewModel: PostListViewModel!

    override func setUp() {
        mockAPI = MockAPIService()
        viewModel = PostListViewModel(api: mockAPI, isGuest: false)
    }

    func test_loadPosts() async {
        await viewModel.loadPosts()
        XCTAssertEqual(viewModel.posts.count, 2)
        XCTAssertEqual(viewModel.posts[0].user?.id, 101)
        XCTAssertEqual(viewModel.posts[1].user?.username, "jdoe")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
}
