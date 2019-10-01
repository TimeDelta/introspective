//
//  ActiveExportTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/23/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
@testable import Introspective
@testable import Common

final class ActiveExportTableViewCellUnitTests: UnitTest {

	private final var cell: ActiveExportTableViewCell!
	private final var cancelButton: UIButton!
	private final var descriptionLabel: UILabel!
	private final var progressView: UIProgressView!
	private final var percentLabel: UILabel!
	private final var toolbar: UIToolbar!

	private final let backgroundTaskId = UIBackgroundTaskIdentifier(rawValue: 32)

	final override func setUp() {
		super.setUp()

		cancelButton = UIButton()
		descriptionLabel = UILabel()
		progressView = UIProgressView()
		percentLabel = UILabel()
		toolbar = UIToolbar()

		cell = ActiveExportTableViewCell()
		cell.cancelButton = cancelButton
		cell.descriptionLabel = descriptionLabel
		cell.progressView = progressView
		cell.percentLabel = percentLabel
		cell.toolbar = toolbar

		cell.backgroundTaskId = backgroundTaskId
	}

	// MARK: - didSetExporter

	func testGivenNil_didSetExporter_doesNotThrowError() {
		// when
		cell.exporter = nil

		// then - no errors thrown
	}

	func testGivenNonNilExporter_didSetExporter_correctlyUpdatesProgressBar() {
		// given
		let percentComplete = 0.432
		let exporter = setUpMockExporter(percentComplete: percentComplete)

		// when
		cell.exporter = exporter

		// then
		XCTAssertEqual(progressView.progress, Float(percentComplete))
	}

	func testGivenNonNilExporter_didSetExporter_correctlySetsPercentCompleteLabelText() {
		// given
		let percentComplete = 0.43
		let exporter = setUpMockExporter(percentComplete: percentComplete)

		// when
		cell.exporter = exporter

		// then
		XCTAssertEqual(percentLabel.text, String(Int(percentComplete * 100)) + "%")
	}

	// MARK: - prepareForReuse

	func testGivenCellAlreadyUsedBefore_prepareForReuse_stopsObservingBackgroundExportFinishedForAssociatedExporter() {
		// given
		let exporter = setUpMockExporter()
		cell.exporter = exporter
		Given(exporter, .equalTo(.any, willReturn: true))

		// when
		cell.prepareForReuse()

		// then
		Verify(mockUiUtil, .stopObserving(.value(cell), name: .value(.backgroundExportFinished), object: .value(exporter)))
	}

	func testGivenToolbarNotHidden_prepareForReuse_hidesToolbar() {
		// given
		toolbar.isHidden = false

		// when
		cell.prepareForReuse()

		// then
		XCTAssert(toolbar.isHidden)
	}

	func testGivenCancelButtonDisabled_prepareForReuse_enablesCancelButton() {
		// given
		cancelButton.isEnabled = false

		// when
		cell.prepareForReuse()

		// then
		Verify(mockUiUtil, .setButton(.value(cancelButton), enabled: .value(true), hidden: .value(false)))
	}

	// MARK: - cancelExport

	func testGivenExporterSet_cancelExport_disablesCancelButton() {
		// given
		cell.exporter = setUpMockExporter()

		// when
		cell.cancelExport(cancelButton)

		// then
		Verify(mockUiUtil, .setButton(.value(cancelButton), enabled: .value(false), hidden: .value(false)))
	}

	func testGivenExporterSet_cancelExport_sendsPresentCancelExportPromptNotification() {
		// given
		cell.exporter = setUpMockExporter()

		// when
		cell.cancelExport(cancelButton)

		// then
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(.presentView), object: .any, userInfo: userInfoCaptor.capture()))
		guard let userInfo = userInfoCaptor.value as? UserInfo else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.controller, withValue: UIAlertController(), { _,_  in true }))
	}

	func testGivenCancelExportPromptShown_pressingYes_postsCancelBackgroundTaskNotification() throws {
		// given
		cell.exporter = setUpMockExporter()
		cell.cancelExport(cancelButton)
		var userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(.presentView), object: .any, userInfo: userInfoCaptor.capture()))
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
		Verify(mockUiUtil, .post(name: .value(.cancelBackgroundTask), object: .any, userInfo: userInfoCaptor.capture()))
		guard let userInfo = userInfoCaptor.value as? UserInfo else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.backgroundTaskId, withValue: String(backgroundTaskId.rawValue)))
	}

	func testGivenCancelExportPromptShown_pressingNo_enablesCancelButton() throws {
		// given
		cell.exporter = setUpMockExporter()
		cell.cancelExport(cancelButton)
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(.presentView), object: .any, userInfo: userInfoCaptor.capture()))
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

	// MARK: - share

	func test_share_postsShareExportFileNotification() {
		// when
		cell.share(self)

		// then
		let userInfoCaptor = ArgumentCaptor<UserInfo?>()
		Verify(mockUiUtil, .post(name: .value(.shareExportFile), object: .any, userInfo: userInfoCaptor.capture()))
		guard let userInfo = userInfoCaptor.value as? UserInfo else {
			XCTFail("No User Info")
			return
		}
		assertThat(userInfo, userInfoHasKey(UserInfoKey.backgroundTaskId, withValue: backgroundTaskId))
	}

	// MARK: - exportFinished

	func testGivenExporterSet_exportFinished_disablesCancelButton() {
		// given
		let exporter = setUpMockExporter()
		cell.exporter = exporter

		// when
		let name = NotificationName.backgroundExportFinished.toName()
		NotificationCenter.default.post(name: name, object: exporter, userInfo: nil)

		// then
		Verify(mockUiUtil, .setButton(.value(cancelButton), enabled: .value(false), hidden: .value(false)))
	}

	func testGivenExporterSet_exportFinished_unhidesToolbar() {
		// given
		let exporter = setUpMockExporter()
		cell.exporter = exporter
		toolbar.isHidden = true

		// when
		let name = NotificationName.backgroundExportFinished.toName()
		NotificationCenter.default.post(name: name, object: exporter, userInfo: nil)

		// then
		XCTAssertFalse(toolbar.isHidden)
	}

	// MARK: - Helper Functions

	private final func setUpMockExporter(percentComplete: Double = 0) -> ExporterMock {
		let exporter = ExporterMock()
		Given(exporter, .percentComplete(willReturn: percentComplete))
		Given(exporter, .dataTypePluralName(getter: "this is the exporter data type"))
		return exporter
	}
}
