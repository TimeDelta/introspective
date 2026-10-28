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

	public static let descriptionPresenter = injected(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center
	)

	private static let log = Log()
	private var healthExchangeInProgress = false

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

		if #available(iOS 18.0, *) {
			navigationItem.rightBarButtonItems = [navigationItem.rightBarButtonItem!,
				UIBarButtonItem(title: "Health", style: .plain, target: self, action: #selector(showHealthExchange))]
		}

		injected(UiUtil.self).setBackButton(for: self, title: "Settings", action: #selector(done))
	}

	// MARK: - Actions


	@objc private func showHealthExchange() {
		guard #available(iOS 18.0, *), !healthExchangeInProgress else { return }
		let alert = UIAlertController(title: "Moods in Apple Health",
			message: "Import State of Mind ratings, or export your moods as momentary emotions. Repeating a transfer skips records already transferred. Notes, emotion labels, and associations are not transferred. Existing records are not updated or deleted.",
			preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Import from Health", style: .default) { _ in self.exchangeHealthMoods(export: false) })
		alert.addAction(UIAlertAction(title: "Export to Health", style: .default) { _ in self.exchangeHealthMoods(export: true) })
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(alert, animated: true)
	}

	@available(iOS 18.0, *)
	private func exchangeHealthMoods(export: Bool) {
		guard !healthExchangeInProgress else { return }
		healthExchangeInProgress = true
		navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = false }
		let exchange = MoodHealthExchange()
		let completion: (Result<Int, Error>) -> Void = { [weak self] result in
			guard let self = self else { return }
			self.healthExchangeInProgress = false
			self.navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = true }
			switch result {
			case .failure(let error): self.showError(title: "Mood transfer failed", error: error)
			case .success(let count):
				let message = export ? "Exported \(count) new moods to Health." :
					"Imported \(count) new moods. Health only returns records you allow Introspective to read. If none were imported, check State of Mind access in Health Settings."
				let alert = UIAlertController(title: "Mood transfer complete", message: message, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default))
				self.present(alert, animated: true)
			}
		}
		if export { exchange.exportMoods(completion: completion) }
		else { exchange.importMoods(completion: completion) }
	}

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
		injected(Settings.self).reset()
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

		injected(Settings.self).setMinMood(minRating)
		injected(Settings.self).setMaxMood(maxRating)
		injected(Settings.self).setScaleMoodsOnImport(scaleMoodsOnImportSwitch.isOn)
		injected(Settings.self).setDiscreteMoods(useDiscreteMoodsSwitch.isOn)

		if changed(.discreteMoods) {
			post(MoodUiUtilImpl.useDiscreteMoodChanged)
		}

		if changed(.maxMood) || changed(.minMood) {
			if injected(Settings.self).changed(.minMood) {
				post(MoodUiUtilImpl.minRatingChanged)
			}
			if injected(Settings.self).changed(.maxMood) {
				post(MoodUiUtilImpl.maxRatingChanged)
			}
			presentScaleMoodsAlert()
		}
		saveAndGoBackToSettings()
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
		minMoodField.text = injected(MoodUiUtil.self)
			.valueToString(injected(Settings.self).minMood)
		maxMoodField.text = injected(MoodUiUtil.self)
			.valueToString(injected(Settings.self).maxMood)
		scaleMoodsOnImportSwitch.isOn = injected(Settings.self).scaleMoodsOnImport
		useDiscreteMoodsSwitch.isOn = injected(Settings.self).discreteMoods
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
					try injected(MoodUtil.self).scaleMoods()
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
		} else if injected(Settings.self).changed(.maxMood) {
			return "maximum"
		}
		return "minimum"
	}

	private final func changed(_ setting: Setting) -> Bool {
		injected(Settings.self).changed(setting)
	}
}
