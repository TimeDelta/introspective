//
//  MoodSettingsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import NotificationBannerSwift
import Presentr
import UIKit

import Common
import DependencyInjection
import Samples
import Settings

final class MoodSettingsViewController: UIViewController {
	// MARK: - Static Variables

	private typealias Me = MoodSettingsViewController

	public static let descriptionPresenter = DependencyInjector.get(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center
	)

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var minMoodField: UITextField!
	@IBOutlet final var maxMoodField: UITextField!
	@IBOutlet final var scaleMoodsOnImportSwitch: UISwitch!
	@IBOutlet final var useDiscreteMoodsSwitch: UISwitch!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Reset",
			style: .plain,
			target: self,
			action: #selector(reset)
		)

		DependencyInjector.get(UiUtil.self).setBackButton(for: self, title: "Settings", action: #selector(done))
	}

	// MARK: - Actions

	@IBAction final func showAutoScaleMoodsOnImportDescription(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText =
			"Automatically scale any imported moods to match the minimum and maximum moods at the time of import."
		present(controller, using: Me.descriptionPresenter)
	}

	@IBAction final func showDiscreteMoodsDescription(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText =
			"Instead of letting you set whatever value you want (i.e. 4.367) for your mood, only allow integer values like 1, 2, or 3. This will not change any existing mood records."
		present(controller, using: Me.descriptionPresenter)
	}

	@objc private func reset(_: Any) {
		DependencyInjector.get(Settings.self).reset()
		updateUI()
	}

	@objc private final func done() {
		guard let minMoodText = minMoodField.text else { return }
		guard let maxMoodText = maxMoodField.text else { return }
		guard let minRating = Double(minMoodText) else {
			showError(title: "Invalid minimum mood", message: "'\(minMoodText)' is not a number.")
			return
		}
		guard let maxRating = Double(maxMoodText) else {
			showError(title: "Invalid minimum mood", message: "'\(minMoodText)' is not a number.")
			return
		}
		guard minRating <= maxRating else {
			showError(title: "Maximum mood must be greater than minimum mood.", message: nil)
			return
		}

		DependencyInjector.get(Settings.self).setMinMood(minRating)
		DependencyInjector.get(Settings.self).setMaxMood(maxRating)
		DependencyInjector.get(Settings.self).setScaleMoodsOnImport(scaleMoodsOnImportSwitch.isOn)
		DependencyInjector.get(Settings.self).setDiscreteMoods(useDiscreteMoodsSwitch.isOn)

		if changed(.discreteMoods) {
			post(MoodUiUtilImpl.useDiscreteMoodChanged)
		}

		if changed(.maxMood) || changed(.minMood) {
			if DependencyInjector.get(Settings.self).changed(.minMood) {
				post(MoodUiUtilImpl.minRatingChanged)
			}
			if DependencyInjector.get(Settings.self).changed(.maxMood) {
				post(MoodUiUtilImpl.maxRatingChanged)
			}
			presentScaleMoodsAlert()
		}
		saveAndGoBackToSettings()
	}

	// MARK: - Helper Functions

	private final func saveAndGoBackToSettings() {
		do {
			try retryOnFail({ try DependencyInjector.get(Settings.self).save() }, maxRetries: 2)
			navigationController?.popViewController(animated: false)
		} catch {
			Me.log.error("Failed to save mood settings: %@", errorInfo(error))
			showError(title: "Failed to save settings", error: error, tryAgain: saveAndGoBackToSettings)
		}
	}

	private final func updateUI() {
		minMoodField.text = DependencyInjector.get(MoodUiUtil.self)
			.valueToString(DependencyInjector.get(Settings.self).minMood)
		maxMoodField.text = DependencyInjector.get(MoodUiUtil.self)
			.valueToString(DependencyInjector.get(Settings.self).maxMood)
		scaleMoodsOnImportSwitch.isOn = DependencyInjector.get(Settings.self).scaleMoodsOnImport
		useDiscreteMoodsSwitch.isOn = DependencyInjector.get(Settings.self).discreteMoods
	}

	private final func presentScaleMoodsAlert() {
		let scaleOldMoodsController = UIAlertController(
			title: "Scale existing moods?",
			message: "Applying this new \(minAndOrMax()) to existing moods will scale them to have the same ratio with the new range as they have with their current range.",
			preferredStyle: .alert
		)
		scaleOldMoodsController.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
			DispatchQueue.global(qos: .userInitiated).async {
				do {
					try DependencyInjector.get(MoodUtil.self).scaleMoods()
				} catch {
					Me.log.error("Failed to scale existing moods: %@", errorInfo(error))
					StatusBarNotificationBanner(title: "Failed to scale existing moods", style: .danger).show()
				}
			}
			self.saveAndGoBackToSettings()
		})
		scaleOldMoodsController.addAction(UIAlertAction(title: "No", style: .default) { _ in
			self.saveAndGoBackToSettings()
		})
		present(scaleOldMoodsController, animated: false)
	}

	private final func minAndOrMax() -> String {
		if changed(.maxMood) && changed(.minMood) {
			return "minimum and maximum"
		} else if DependencyInjector.get(Settings.self).changed(.maxMood) {
			return "maximum"
		}
		return "minimum"
	}

	private final func changed(_ setting: Setting) -> Bool {
		DependencyInjector.get(Settings.self).changed(setting)
	}
}
