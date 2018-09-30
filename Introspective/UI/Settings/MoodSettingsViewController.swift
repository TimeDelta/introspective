//
//  MoodSettingsViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

final class MoodSettingsViewController: UIViewController {

	private typealias Me = MoodSettingsViewController
	private static let answeredOldMoodsModalNotification = Notification.Name("answeredScaleOldMoodsQuestion")

	private final let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)

		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		customPresenter.dismissOnSwipe = false
		customPresenter.dismissOnTap = false
		return customPresenter
	}()

	@IBOutlet weak final var maxMoodField: UITextField!

	final override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))

		UiUtil.setBackButton(for: self, title: "Settings", action: #selector(saveAndGoBackToSettings))

		NotificationCenter.default.addObserver(self, selector: #selector(saveAndGoBackToSettings), name: Me.answeredOldMoodsModalNotification, object: nil)
	}

	@IBAction final func doneEditingMaxMood(_ sender: Any) {
		if !DependencyInjector.util.stringUtil.isNumber(maxMoodField.text!) {
			maxMoodField.text = String(DependencyInjector.settings.maximumMood)
		}
	}

	@objc private func reset(_ sender: Any) {
		DependencyInjector.settings.reset()
		updateUI()
	}

	@objc private final func done() {
		if DependencyInjector.util.stringUtil.isNumber(maxMoodField.text!) {
			DependencyInjector.settings.setMaxMood(Double(maxMoodField.text!)!)
		}

		if DependencyInjector.settings.changed(.maxMood) {
			let scaleOldMoodsController = storyboard!.instantiateViewController(withIdentifier: "ScaleOldMoodsViewController") as! ScaleOldMoodsViewController
			scaleOldMoodsController.notificationToSendOnCompletion = Me.answeredOldMoodsModalNotification
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
