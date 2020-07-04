//
//  DiscreteMoodWidget.swift
//  DiscreteMoodWidget
//
//  Created by Bryan Nova on 9/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import NotificationCenter
import UIKit
import UserNotifications

import Common
import DependencyInjection
import Notifications
import Persistence
import Samples
import Settings
import SwiftDate
import UIExtensions

public class DiscreteMoodWidget: UIViewController {
	private typealias Me = DiscreteMoodWidget
	private static let moodRatingButtonPressed = Notification.Name("moodRatingButtonPressed")

	// MARK: - IBOutlets

	@IBOutlet final var moodButtonsView: UICollectionView!

	// MARK: - Instance Variables

	private let log = Log()

	// MARK: - UIView Overrides

	override public func viewDidLoad() {
		super.viewDidLoad()
		DependencyInjector.register(CommonInjectionProvider())
		DependencyInjector.register(PersistenceInjectionProvider(ObjectModelContainer.objectModel))
		DependencyInjector.register(SamplesInjectionProvider())
		DependencyInjector.register(SettingsInjectionProvider())

		observe(selector: #selector(moodRatingButtonPressed), name: Me.moodRatingButtonPressed)

		moodButtonsView.delegate = self
		moodButtonsView.dataSource = self
		moodButtonsView.setCollectionViewLayout(MoodRatingsFlowLayout(), animated: false)

		extensionContext?.widgetLargestAvailableDisplayMode = .expanded
	}

	// MARK: - Received Notifications

	@objc final func moodRatingButtonPressed(notification: Notification) {
		if let rating: Int? = value(for: .mood, from: notification) {
			do {
				let transaction = DependencyInjector.get(Database.self).transaction()
				let mood = try DependencyInjector.get(SampleFactory.self).mood(using: transaction)
				mood.date = Date()
				mood.rating = Double(rating!)
				mood.minRating = DependencyInjector.get(Settings.self).minMood
				mood.maxRating = DependencyInjector.get(Settings.self).maxMood
				mood.setSource(.introspective)
				try transaction.commit()
				moodButtonsView.isHidden = true
				Timer.scheduledTimer(
					timeInterval: 5,
					target: self,
					selector: #selector(resetState),
					userInfo: nil,
					repeats: true
				)
			} catch {
				let content = UNMutableNotificationContent()
				content.title = NSString.localizedUserNotificationString(
					forKey: "Failed to record mood",
					arguments: nil
				)
				var message = ""
				if let displayableError = error as? DisplayableError {
					message = displayableError.displayableTitle + "."
					if let errorDescription = displayableError.displayableDescription {
						message += " " + errorDescription + "."
					}
				}
				content.body = message
				content.sound = UNNotificationSound.default
				content.categoryIdentifier = UserNotificationDelegate.generalError.identifier
				sendUserNotification(withContent: content, id: "ImportErrorOccurred")
			}
		}
	}

	// MARK: - Helper Functions

	@objc private final func resetState() {
		moodButtonsView.isHidden = false
	}

	private final func numberOfMoodRatings() -> Int {
		let min = DependencyInjector.get(Settings.self).minMood
		let max = DependencyInjector.get(Settings.self).maxMood
		return Int(max - min + 1)
	}
}

// MARK: - NCWidgetProviding

extension DiscreteMoodWidget: NCWidgetProviding {
	public func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
		// Perform any setup necessary in order to update the view.
		// If an error is encountered, use NCUpdateResult.Failed
		// If there's no update required, use NCUpdateResult.NoData
		// If there's an update, use NCUpdateResult.NewData
		let expectedNumCells = numberOfMoodRatings()
		if expectedNumCells != moodButtonsView.visibleCells.count {
			moodButtonsView.reloadData()
			completionHandler(NCUpdateResult.newData)
		} else {
			completionHandler(NCUpdateResult.noData)
		}
	}

	public func widgetActiveDisplayModeDidChange(
		_ activeDisplayMode: NCWidgetDisplayMode,
		withMaximumSize maxSize: CGSize
	) {
		if activeDisplayMode == .compact {
			preferredContentSize = CGSize(width: maxSize.width, height: 110)
		} else {
			(moodButtonsView.collectionViewLayout as? MoodRatingsFlowLayout)?.setContentSize()
			preferredContentSize = CGSize(width: maxSize.width, height: moodButtonsView.contentSize.height)
		}
	}
}

// MARK: - UICollectionViewDataSource

extension DiscreteMoodWidget: UICollectionViewDataSource {
	public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
		numberOfMoodRatings()
	}
}

// MARK: - UICollectionViewDelegate

extension DiscreteMoodWidget: UICollectionViewDelegate {
	public func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = moodButtonsView.dequeueReusableCell(withReuseIdentifier: "mood rating", for: indexPath)
		let moodRatingCell = cell as! MoodRatingCollectionViewCell
		let min = Int(DependencyInjector.get(Settings.self).minMood)
		moodRatingCell.rating = min + indexPath.row
		moodRatingCell.notificationToSendOnAccept = Me.moodRatingButtonPressed
		return moodRatingCell
	}
}
