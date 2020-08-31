//
//  ActiveImportTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/23/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky
@testable import Introspective
@testable import Common

final class ActiveImportTableViewCellUnitTests: UnitTest {

	private final var cell: ActiveImportTableViewCell!
	private final var cancelButton: UIButton!
	private final var descriptionLabel: UILabel!
	private final var progressView: UIProgressView!
	private final var percentLabel: UILabel!

	private final let backgroundTaskId = UIBackgroundTaskIdentifier(rawValue: 32)

	final override func setUp() {
		super.setUp()

		cancelButton = UIButton()
		descriptionLabel = UILabel()
		progressView = UIProgressView()
		percentLabel = UILabel()

		cell = ActiveImportTableViewCell()
		cell.cancelButton = cancelButton
		cell.descriptionLabel = descriptionLabel
		cell.progressView = progressView
		cell.percentLabel = percentLabel

		cell.backgroundTaskId = backgroundTaskId
	}

	// MARK: - didSetImporter

	func testGivenNil_didSetImporter_doesNotThrowError() {
		// when
		cell.importer = nil

		// then - no errors thrown
	}

	func testGivenNonNilExporter_didSetExporter_correctlyUpdatesProgressBar() {
		// given
		let percentComplete = 0.432
		let importer = setUpMockImporter(percentComplete: percentComplete)

		// when
		cell.importer = importer

		// then
		XCTAssertEqual(progressView.progress, Float(percentComplete))
	}

	func testGivenNonNilExporter_didSetExporter_correctlySetsPercentCompleteLabelText() {
		// given
		let percentComplete = 0.43
		let importer = setUpMockImporter(percentComplete: percentComplete)

		// when
		cell.importer = importer

		// then
		XCTAssertEqual(percentLabel.text, String(Int(percentComplete * 100)) + "%")
	}

	// MARK: - prepareForReuse

	func testGivenCancelButtonDisabled_prepareForReuse_enablesCancelButton() {
		// given
		cancelButton.isEnabled = false

		// when
		cell.prepareForReuse()

		// then
		Verify(mockUiUtil, .setButton(.value(cancelButton), enabled: .value(true), hidden: .value(false)))
	}

	// MARK: - cancelImport

	func testGivenExporterSet_cancelImport_disablesCancelButton() {
		// given
		cell.importer = setUpMockImporter()

		// when
		cell.cancelImport(cancelButton)

		// then
		Verify(mockUiUtil, .setButton(.value(cancelButton), enabled: .value(false), hidden: .value(false)))
	}

	func testGivenExporterSet_cancelImport_sendsPresentCancelExportPromptNotification() {
		// given
		cell.importer = setUpMockImporter()

		// when
		cell.cancelImport(cancelButton)

		// then
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(.presentView), object: .any, userInfo: .capturing(userInfoCaptor)))
		guard let userInfo = userInfoCaptor.value as? UserInfo else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.controller, withValue: UIAlertController(), { _,_  in true }))
	}

	func testGivenCancelExportPromptShown_pressingYes_postsCancelBackgroundTaskNotification() throws {
		// given
		cell.importer = setUpMockImporter()
		cell.cancelImport(cancelButton)
		var userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(.presentView), object: .any, userInfo: .capturing(userInfoCaptor)))
		guard let promptUserInfo = userInfoCaptor.value as? UserInfo else {
			XCTFail("No User Info")
			return
		}
		guard let prompt = promptUserInfo[UserInfoKey.controller] as? UIAlertController else {
			XCTFail("No controller in User Info")
			return
		}

		// when
		try prompt.tapButton(withTitle: "Yes")

		// then
		userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(.cancelBackgroundTask), object: .any, userInfo: .capturing(userInfoCaptor)))
		guard let userInfo = userInfoCaptor.value as? UserInfo else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.backgroundTaskId, withValue: String(backgroundTaskId.rawValue)))
	}

	func testGivenCancelExportPromptShown_pressingNo_enablesCancelButton() throws {
		// given
		cell.importer = setUpMockImporter()
		cell.cancelImport(cancelButton)
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(.presentView), object: .any, userInfo: .capturing(userInfoCaptor)))
		guard let promptUserInfo = userInfoCaptor.value as? UserInfo else {
			XCTFail("No User Info")
			return
		}
		guard let prompt = promptUserInfo[UserInfoKey.controller] as? UIAlertController else {
			XCTFail("No controller in User Info")
			return
		}

		// when
		try prompt.tapButton(withTitle: "No")

		// then
		Verify(mockUiUtil, .setButton(.value(cancelButton), enabled: .value(true), hidden: .value(false)))
	}

	// MARK: - Helper Functions

	private final func setUpMockImporter(percentComplete: Double = 0) -> ImporterMock {
		let importer = ImporterMock()
		Given(importer, .percentComplete(willReturn: percentComplete))
		Given(importer, .dataTypePluralName(getter: "this is the importer data type"))
		Given(importer, .sourceName(getter: "this is the importer source name"))
		return importer
	}
}
