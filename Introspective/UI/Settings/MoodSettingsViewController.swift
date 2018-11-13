//
//  MoodSettingsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import os

final class MoodSettingsViewController: UIViewController {

	private final let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)

		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		customPresenter.dismissOnSwipe = false
		return customPresenter
	}()

	@IBOutlet weak final var maxMoodField: UITextField!

	final override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))

		UiUtil.setBackButton(for: self, title: "Settings", action: #selector(done))
	}

	@IBAction final func doneEditingMaxMood(_ sender: Any) {
		if !DependencyInjector.util.string.isNumber(maxMoodField.text!) {
			maxMoodField.text = String(DependencyInjector.settings.maximumMood)
		}
	}

	@objc private func reset(_ sender: Any) {
		DependencyInjector.settings.reset()
		updateUI()
	}

	@objc private final func done() {
		if DependencyInjector.util.string.isNumber(maxMoodField.text!) {
			DependencyInjector.settings.setMaxMood(Double(maxMoodField.text!)!)
		}

		if DependencyInjector.settings.changed(.maxMood) {
			let scaleOldMoodsController = UIAlertController(
				title: "Scale old moods?",
				message: "Applying this new maximum to old moods will scale them to have the same ratio with this max that they had with the max at the time they were created.",
				preferredStyle: .alert)
			scaleOldMoodsController.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
				DispatchQueue.global(qos: .userInitiated).async {
					MoodQueryImpl.updatingMoodsInBackground = true
					DependencyInjector.query.moodQuery().runQuery { (result, error) in
						if error != nil {
							// TODO - send user a notification that this failed
							os_log("Failed to scale old moods: %@", type: .error, error!.localizedDescription)
							MoodQueryImpl.updatingMoodsInBackground = false
							return
						}
						for sample in result!.samples {
							let mood = (sample as! Mood)
							let oldMax = mood.maxRating
							let oldRating = mood.rating
							mood.maxRating = DependencyInjector.settings.maximumMood
							mood.rating = (oldRating / oldMax) * DependencyInjector.settings.maximumMood
						}
						DependencyInjector.db.save()
						MoodQueryImpl.updatingMoodsInBackground = false
					}
				}
				self.saveAndGoBackToSettings()
			})
			scaleOldMoodsController.addAction(UIAlertAction(title: "No", style: .default) { _ in
				self.saveAndGoBackToSettings()
			})
			customPresentViewController(presenter, viewController: scaleOldMoodsController, animated: true)
		}
		saveAndGoBackToSettings()
	}

	@objc private final func saveAndGoBackToSettings() {
		DependencyInjector.settings.save()
		self.navigationController?.popViewController(animated: true)
	}

	private final func updateUI() {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		maxMoodField.text = MoodUiUtil.valueToString(DependencyInjector.settings.maximumMood)
	}
}
