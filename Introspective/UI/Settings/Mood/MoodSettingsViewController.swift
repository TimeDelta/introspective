//
//  MoodSettingsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import NotificationBannerSwift

final class MoodSettingsViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var minMoodField: UITextField!
	@IBOutlet weak final var maxMoodField: UITextField!
	@IBOutlet weak final var scaleMoodsOnImportSwitch: UISwitch!

	// MARK: - Instance Variables

	private final let log = Log()

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))

		DependencyInjector.util.ui.setBackButton(for: self, title: "Settings", action: #selector(done))
	}

	// MARK: - Actions

	@IBAction final func showAutoScaleMoodsOnImportDescription(_ sender: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText = "Automatically scale any imported moods to match the minimum and maximum moods at the time of import."
		present(controller, using: DependencyInjector.util.ui.defaultPresenter)
	}

	@objc private func reset(_ sender: Any) {
		DependencyInjector.settings.reset()
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

		DependencyInjector.settings.setMinMood(minRating)
		DependencyInjector.settings.setMaxMood(maxRating)
		DependencyInjector.settings.setScaleMoodsOnImport(scaleMoodsOnImportSwitch.isOn)

		if DependencyInjector.settings.changed(.maxMood) || DependencyInjector.settings.changed(.minMood) {
			if DependencyInjector.settings.changed(.minMood) {
				post(MoodUiUtil.minRatingChanged)
			}
			if DependencyInjector.settings.changed(.maxMood) {
				post(MoodUiUtil.maxRatingChanged)
			}
			presentScaleMoodsAlert()
		}
		saveAndGoBackToSettings()
	}

	@objc private final func saveAndGoBackToSettings() {
		do {
			try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)
			self.navigationController?.popViewController(animated: false)
		} catch {
			log.error("Failed to save mood settings: %@", errorInfo(error))
			showError(title: "Failed to save settings", error: error, tryAgain: saveAndGoBackToSettings)
		}
	}

	// MARK: - Helper Functions

	private final func updateUI() {
		minMoodField.text = MoodUiUtil.valueToString(DependencyInjector.settings.minMood)
		maxMoodField.text = MoodUiUtil.valueToString(DependencyInjector.settings.maxMood)
		scaleMoodsOnImportSwitch.isOn = DependencyInjector.settings.scaleMoodsOnImport
	}

	private final func presentScaleMoodsAlert() {
		let scaleOldMoodsController = UIAlertController(
			title: "Scale existing moods?",
			message: "Applying this new \(minAndOrMax()) to existing moods will scale them to have the same ratio with the new range as they have with their current range.",
			preferredStyle: .alert)
		scaleOldMoodsController.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
			DispatchQueue.global(qos: .userInitiated).async {
				do {
					try DependencyInjector.util.mood.scaleMoods()
				} catch {
					self.log.error("Failed to scale existing moods: %@", errorInfo(error))
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
		if DependencyInjector.settings.changed(.maxMood) && DependencyInjector.settings.changed(.minMood) {
			return "minimum and maximum"
		} else if DependencyInjector.settings.changed(.maxMood) {
			return "maximum"
		}
		return "minimum"
	}
}
