//
//  ScaleOldMoodsViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

class ScaleOldMoodsViewController: UIViewController {

	public var notificationToSendOnCompletion: Notification.Name!

	@IBAction func userChoseYes(_ sender: Any) {
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
		NotificationCenter.default.post(name: notificationToSendOnCompletion, object: nil)
		dismiss(animated: true, completion: nil)
	}

	@IBAction func userChoseNo(_ sender: Any) {
		NotificationCenter.default.post(name: notificationToSendOnCompletion, object: nil)
		dismiss(animated: true, completion: nil)
	}
}
