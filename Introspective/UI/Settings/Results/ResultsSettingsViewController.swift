//
//  ResultsSettingsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/10/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Settings

public final class ResultsSettingsViewController: UIViewController {
	// MARK: - Static Variables

	private typealias Me = ResultsSettingsViewController

	private static let choseDefaultSearchNearbyDuration = Notification.Name("choseDefaultSearchNearbyDuration")

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var defaultSearchNearbyDurationButton: UIButton!

	// MARK: - Instance Variables

	private final var duration: TimeDuration!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		duration = injected(Settings.self).defaultSearchNearbyDuration
		updateUI()
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Reset",
			style: .plain,
			target: self,
			action: #selector(reset)
		)

		injected(UiUtil.self).setBackButton(for: self, title: "Settings", action: #selector(done))

		observe(selector: #selector(choseDefaultSearchNearbyDuration), name: Me.choseDefaultSearchNearbyDuration)
	}

	// MARK: - Actions

	@objc private func reset(_: Any) {
		injected(Settings.self).reset()
		updateUI()
	}

	@objc private final func done() {
		injected(Settings.self).setDefaultSearchNearbyDuration(duration)
		saveAndGoBackToSettings()
	}

	@IBAction func chooseDefaultSearchNearbyDuration() {
		let controller = viewController(
			named: "durationChooser",
			fromStoryboard: "Util"
		) as! SelectDurationViewController
		controller.initialDuration = duration
		controller.notificationToSendOnAccept = Me.choseDefaultSearchNearbyDuration
		present(controller, using: injected(UiUtil.self).defaultPresenter)
	}

	// MARK: - Received Notifications

	@objc private final func choseDefaultSearchNearbyDuration(notification: Notification) {
		guard let duration: TimeDuration = value(for: .duration, from: notification) else { return }
		self.duration = duration
	}

	// MARK: - Helper Functions

	private final func updateUI() {
		let currentDefaultSearchNearbyDuration = injected(Settings.self).defaultSearchNearbyDuration
		defaultSearchNearbyDurationButton.setTitle(currentDefaultSearchNearbyDuration.description, for: .normal)
	}

	private final func saveAndGoBackToSettings() {
		do {
			try retryOnFail({ try injected(Settings.self).save() }, maxRetries: 2)
			navigationController?.popViewController(animated: false)
		} catch {
			Me.log.error("Failed to save results view settings: %@", errorInfo(error))
			showError(title: "Failed to save settings", error: error, tryAgain: saveAndGoBackToSettings)
		}
	}
}
