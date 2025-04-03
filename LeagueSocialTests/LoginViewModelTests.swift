//
//  LoginViewModelTests.swift
//  LeagueSocialTests
//
//  Created by Arpit Williams on 03/04/25.
//

@testable import LeagueSocial
import XCTest

@MainActor
final class LoginViewModelTests: XCTestCase {
    private var mockAPI: MockAPIService!
    private var viewModel: LoginViewModel!

    override func setUp() {
        mockAPI = MockAPIService()
        viewModel = LoginViewModel(api: mockAPI)
    }

    func test_validateInputs_invalidUsername_returnsFalse() {
        viewModel.username = "ab"
        viewModel.password = "validpass"
        XCTAssertFalse(viewModel.validateInputs())
        XCTAssertEqual(viewModel.validationMessage, "Username must be at least 4 characters.")
    }

    func test_validateInputs_invalidPassword_returnsFalse() {
        viewModel.username = "validUser"
        viewModel.password = "123"
        XCTAssertFalse(viewModel.validateInputs())
        XCTAssertEqual(viewModel.validationMessage, "Password must be at least 6 characters.")
    }

    func test_validateInputs_validInputs_returnsTrue() {
        viewModel.username = "validUser"
        viewModel.password = "validPassword"
        XCTAssertTrue(viewModel.validateInputs())
        XCTAssertNil(viewModel.validationMessage)
    }

    func test_isTokenValid_setsStateToSuccessIfTokenExists() {
        viewModel.isTokenValid()
        guard case let .success(token) = viewModel.state else {
            XCTFail("Expected success from token check")
            return
        }
        XCTAssertEqual(token, "1234")
    }

    func test_resetState_resetsAllFields() {
        viewModel.username = "user"
        viewModel.password = "pass"
        viewModel.validationMessage = "error"
        viewModel.state = .success(token: "abc")
        viewModel.isGuest = true
        viewModel.resetState()
        XCTAssertEqual(viewModel.username, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertNil(viewModel.validationMessage)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertFalse(viewModel.isGuest)
    }
}
