//
//  GeneralSettingsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 3/3/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Settings

public final class GeneralSettingsViewController: UIViewController {
	// MARK: - Static Variables

	private typealias Me = GeneralSettingsViewController

	private static let choseDefaultSearchNearbyDuration = Notification.Name("choseDefaultSearchNearbyDuration")

	private static let descriptionPresenter = injected(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center
	)

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var convertTimeZonesSwitch: UISwitch!
	@IBOutlet final var defaultSearchNearbyDurationButton: UIButton!

	// MARK: - Instance Variables

	private final var defaultSearchNearbyDuration: TimeDuration!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		defaultSearchNearbyDuration = injected(Settings.self).defaultSearchNearbyDuration

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

	@IBAction final func showConvertTimeZonesDescription(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		let date = Date()
		let currentTimeZone = TimeZone.autoupdatingCurrent
		guard let currentTimeZoneName = currentTimeZone.localizedName(
			for: .generic,
			locale: Locale.autoupdatingCurrent
		) else {
			Me.log.error("Failed to get localized name for current time zone", currentTimeZone.description)
			return
		}
		guard let targetTimeZone = getTargetTimeZone(currentTimeZone) else {
			Me.log.error("Failed to get target time zone.")
			return
		}
		guard let targetTimeZoneName = targetTimeZone.localizedName(
			for: .generic,
			locale: Locale.autoupdatingCurrent
		) else {
			Me.log.error("Failed to get localized name for current time zone", currentTimeZone.description)
			return
		}
		let recordedTime = TimeOfDay(date)
		let convertedDate = injected(CalendarUtil.self)
			.convert(date, from: currentTimeZone, to: targetTimeZone)
		let convertedTime = TimeOfDay(convertedDate)
		controller.descriptionText =
			"When time zone information is available for a date, convert it to the original time zone. For example, with this enabled, if you were in \(targetTimeZoneName) on vacation and recorded a heart rate at \(convertedTime.toString()) then came back to \(currentTimeZoneName), it would appear as if it had been recorded at \(convertedTime.toString()). Without this enabled, it will appear to have been recorded at \(recordedTime.toString()). This does not have to be enabled at the time that the data was recorded for this conversion to happen. For data pulled from Apple Health, this information will not always be available as it is up to the source app to record it. Also, any data imported from external sources may not have time zone information recorded. However, any data recorded by this app will contain time zone information."
		present(controller, using: Me.descriptionPresenter)
	}

	@IBAction func chooseDefaultSearchNearbyDuration() {
		let controller = viewController(
			named: "durationChooser",
			fromStoryboard: "Util"
		) as! SelectDurationViewController
		controller.initialDuration = defaultSearchNearbyDuration
		controller.notificationToSendOnAccept = Me.choseDefaultSearchNearbyDuration
		present(controller, using: SelectDurationViewControllerImpl.presenter)
	}

	@objc private final func reset(_: Any) {
		injected(Settings.self).reset()
		updateUI()
	}

	@objc private final func done(_: Any) {
		injected(Settings.self).setConvertTimeZones(convertTimeZonesSwitch.isOn)
		injected(Settings.self).setDefaultSearchNearbyDuration(defaultSearchNearbyDuration)
		saveAndGoBackToSettings()
	}

	// MARK: - Received Notifications

	@objc private final func choseDefaultSearchNearbyDuration(notification: Notification) {
		guard let duration: TimeDuration = value(for: .duration, from: notification) else { return }
		defaultSearchNearbyDuration = duration
		updateUI()
	}

	// MARK: - Helper Functions

	private final func saveAndGoBackToSettings() {
		do {
			try retryOnFail({ try injected(Settings.self).save() }, maxRetries: 2)
			navigationController?.popViewController(animated: false)
		} catch {
			Me.log.error("Failed to save mood settings: %@", errorInfo(error))
			showError(title: "Failed to save settings", error: error, tryAgain: saveAndGoBackToSettings)
		}
	}

	private final func updateUI() {
		convertTimeZonesSwitch.isOn = injected(Settings.self).convertTimeZones
		let currentDefaultSearchNearbyDuration = injected(Settings.self).defaultSearchNearbyDuration
		defaultSearchNearbyDurationButton.setTitle(currentDefaultSearchNearbyDuration.description, for: .normal)
	}

	private final func getTargetTimeZone(_ currentTimeZone: TimeZone) -> TimeZone? {
		let currentAbbreviation = currentTimeZone.abbreviation()
		let currentIsEastern = currentAbbreviation == "EST" || currentAbbreviation == "EDT"
		let easternTimeZone = TimeZone(abbreviation: "EST")
		let mountainTimeZone = TimeZone(abbreviation: "MST")
		return currentIsEastern ? mountainTimeZone : easternTimeZone
	}
}
