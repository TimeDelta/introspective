//
//  FatigueSettingsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 12/8/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import Presentr
import UIKit

import Common
import DependencyInjection
import Samples
import Settings

final class FatigueSettingsViewController: UIViewController {
	// MARK: - Static Variables

	private typealias Me = FatigueSettingsViewController

	public static let descriptionPresenter = injected(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center
	)

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var minFatigueField: UITextField!
	@IBOutlet final var maxFatigueField: UITextField!
	@IBOutlet final var useDiscreteFatiguesSwitch: UISwitch!

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

	@IBAction final func showDiscreteFatiguesDescription(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText =
			"Instead of letting you set whatever value you want (i.e. 4.367) for your fatigue, only allow integer values like 1, 2, or 3. This will not change any existing Fatigue records."
		present(controller, using: Me.descriptionPresenter)
	}

	@objc private func reset(_: Any) {
		injected(Settings.self).reset()
		updateUI()
	}

	@objc private final func done() {
		guard let minFatigueText = minFatigueField.text else { return }
		guard let maxFatigueText = maxFatigueField.text else { return }
		guard let minRating = Double(minFatigueText) else {
			showError(title: "Invalid minimum Fatigue", message: "'\(minFatigueText)' is not a number.")
			return
		}
		guard let maxRating = Double(maxFatigueText) else {
			showError(title: "Invalid minimum Fatigue", message: "'\(minFatigueText)' is not a number.")
			return
		}
		guard minRating <= maxRating else {
			showError(title: "Maximum Fatigue must be greater than minimum Fatigue.", message: nil)
			return
		}

		injected(Settings.self).setMinFatigue(minRating)
		injected(Settings.self).setMaxFatigue(maxRating)
		injected(Settings.self).setDiscreteFatigue(useDiscreteFatiguesSwitch.isOn)

		if changed(.discreteFatigue) {
			post(FatigueUiUtilImpl.useDiscreteFatigueChanged)
		}

		if changed(.minFatigue) {
			post(FatigueUiUtilImpl.minRatingChanged)
		}
		if changed(.maxFatigue) {
			post(FatigueUiUtilImpl.maxRatingChanged)
		}
		saveAndGoBackToSettings()
	}

	// MARK: - Helper Functions

	private final func saveAndGoBackToSettings() {
		do {
			try retryOnFail({ try injected(Settings.self).save() }, maxRetries: 2)
			navigationController?.popViewController(animated: false)
		} catch {
			Me.log.error("Failed to save Fatigue settings: %@", errorInfo(error))
			showError(title: "Failed to save settings", error: error, tryAgain: saveAndGoBackToSettings)
		}
	}

	private final func updateUI() {
		minFatigueField.text = injected(FatigueUiUtil.self)
			.valueToString(injected(Settings.self).minFatigue)
		maxFatigueField.text = injected(FatigueUiUtil.self)
			.valueToString(injected(Settings.self).maxFatigue)
		useDiscreteFatiguesSwitch.isOn = injected(Settings.self).discreteFatigue
	}

	private final func minAndOrMax() -> String {
		if changed(.maxFatigue) && changed(.minFatigue) {
			return "minimum and maximum"
		} else if injected(Settings.self).changed(.maxFatigue) {
			return "maximum"
		}
		return "minimum"
	}

	private final func changed(_ setting: Setting) -> Bool {
		injected(Settings.self).changed(setting)
	}
}
