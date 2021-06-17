//
//  PainSettingsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 6/17/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import UIKit

import Presentr
import UIKit

import Common
import DependencyInjection
import Samples
import Settings

final class PainSettingsViewController: UIViewController {
	// MARK: - Static Variables

	private typealias Me = PainSettingsViewController

	public static let descriptionPresenter = injected(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center
	)

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var minPainField: UITextField!
	@IBOutlet final var maxPainField: UITextField!
	@IBOutlet final var useDiscretePainsSwitch: UISwitch!

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

		injected(UiUtil.self).setBackButton(for: self, title: "Settings", action: #selector(done))
	}

	// MARK: - Actions

	@IBAction final func showDiscretePainsDescription(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText =
			"Instead of letting you set whatever value you want (i.e. 4.367) for your pain, only allow integer values like 1, 2, or 3. This will not change any existing Pain records."
		present(controller, using: Me.descriptionPresenter)
	}

	@objc private func reset(_: Any) {
		injected(Settings.self).reset()
		updateUI()
	}

	@objc private final func done() {
		guard let minPainText = minPainField.text else { return }
		guard let maxPainText = maxPainField.text else { return }
		guard let minRating = Double(minPainText) else {
			showError(title: "Invalid minimum Pain", message: "'\(minPainText)' is not a number.")
			return
		}
		guard let maxRating = Double(maxPainText) else {
			showError(title: "Invalid minimum Pain", message: "'\(minPainText)' is not a number.")
			return
		}
		guard minRating <= maxRating else {
			showError(title: "Maximum Pain must be greater than minimum Pain.", message: nil)
			return
		}

		injected(Settings.self).setMinPain(minRating)
		injected(Settings.self).setMaxPain(maxRating)
		injected(Settings.self).setDiscretePain(useDiscretePainsSwitch.isOn)

		if changed(.discretePain) {
			post(PainUiUtilImpl.useDiscretePainChanged)
		}

		if changed(.minPain) {
			post(PainUiUtilImpl.minRatingChanged)
		}
		if changed(.maxPain) {
			post(PainUiUtilImpl.maxRatingChanged)
		}
		saveAndGoBackToSettings()
	}

	// MARK: - Helper Functions

	private final func saveAndGoBackToSettings() {
		do {
			try retryOnFail({ try injected(Settings.self).save() }, maxRetries: 2)
			navigationController?.popViewController(animated: false)
		} catch {
			Me.log.error("Failed to save Pain settings: %@", errorInfo(error))
			showError(title: "Failed to save settings", error: error, tryAgain: saveAndGoBackToSettings)
		}
	}

	private final func updateUI() {
		minPainField.text = injected(PainUiUtil.self)
			.valueToString(injected(Settings.self).minPain)
		maxPainField.text = injected(PainUiUtil.self)
			.valueToString(injected(Settings.self).maxPain)
		useDiscretePainsSwitch.isOn = injected(Settings.self).discretePain
	}

	private final func minAndOrMax() -> String {
		if changed(.maxPain) && changed(.minPain) {
			return "minimum and maximum"
		} else if injected(Settings.self).changed(.maxPain) {
			return "maximum"
		}
		return "minimum"
	}

	private final func changed(_ setting: Setting) -> Bool {
		injected(Settings.self).changed(setting)
	}
}
