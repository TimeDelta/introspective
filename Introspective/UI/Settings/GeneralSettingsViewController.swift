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

	// MARK - Static Variables

	private typealias Me = GeneralSettingsViewController

	private static let descriptionPresenter = DependencyInjector.get(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center)

	// MARK: - IBOutlets

	@IBOutlet weak final var convertTimeZonesSwitch: UISwitch!

	// MARK: - Member Variables

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		updateUI()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))

		DependencyInjector.get(UiUtil.self).setBackButton(for: self, title: "Settings", action: #selector(done))
	}

	// MARK: - Actions

	@IBAction final func showConvertTimeZonesDescription(_ sender: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		let date = Date()
		let currentTimeZone = TimeZone.autoupdatingCurrent
		guard let currentTimeZoneName = currentTimeZone.localizedName(
			for: .generic,
			locale: Locale.autoupdatingCurrent)
		else {
			log.error("Failed to get localized name for current time zone", currentTimeZone.description)
			return
		}
		guard let targetTimeZone = getTargetTimeZone(currentTimeZone) else {
			log.error("Failed to get target time zone.")
			return
		}
		guard let targetTimeZoneName = targetTimeZone.localizedName(
			for: .generic,
			locale: Locale.autoupdatingCurrent)
		else {
			log.error("Failed to get localized name for current time zone", currentTimeZone.description)
			return
		}
		let recordedTime = TimeOfDay(date)
		let convertedDate = DependencyInjector.get(CalendarUtil.self).convert(date, from: currentTimeZone, to: targetTimeZone)
		let convertedTime = TimeOfDay(convertedDate)
		controller.descriptionText = "When time zone information is available for a date, convert it to the original time zone. For example, with this enabled, if you were in \(targetTimeZoneName) on vacation and recorded a heart rate at \(convertedTime.toString()) then came back to \(currentTimeZoneName), it would appear as if it had been recorded at \(convertedTime.toString()). Without this enabled, it will appear to have been recorded at \(recordedTime.toString()). This does not have to be enabled at the time that the data was recorded for this conversion to happen. For data pulled from Apple Health, this information will not always be available as it is up to the source app to record it. Also, any data imported from external sources may not have time zone information recorded. However, any data recorded by this app will contain time zone information."
		present(controller, using: Me.descriptionPresenter)
	}

	@objc private final func reset(_ sender: Any) {
		DependencyInjector.get(Settings.self).reset()
		updateUI()
	}

	@objc private final func done(_ sender: Any) {
		DependencyInjector.get(Settings.self).setConvertTimeZones(convertTimeZonesSwitch.isOn)
		saveAndGoBackToSettings()
	}

	// MARK: - Helper Functions

	private final func saveAndGoBackToSettings() {
		do {
			try retryOnFail({ try DependencyInjector.get(Settings.self).save() }, maxRetries: 2)
			self.navigationController?.popViewController(animated: false)
		} catch {
			log.error("Failed to save mood settings: %@", errorInfo(error))
			showError(title: "Failed to save settings", error: error, tryAgain: saveAndGoBackToSettings)
		}
	}

	private final func updateUI() {
		convertTimeZonesSwitch.isOn = DependencyInjector.get(Settings.self).convertTimeZones
	}

	private final func getTargetTimeZone(_ currentTimeZone: TimeZone) -> TimeZone? {
		let currentAbbreviation = currentTimeZone.abbreviation()
		let currentIsEastern = currentAbbreviation == "EST" || currentAbbreviation == "EDT"
		let easternTimeZone = TimeZone.init(abbreviation: "EST")
		let mountainTimeZone = TimeZone.init(abbreviation: "MST")
		return currentIsEastern ? mountainTimeZone : easternTimeZone
	}
}
