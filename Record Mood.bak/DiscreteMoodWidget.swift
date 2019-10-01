//
//  DiscreteMoodWidget.swift
//  Record Mood
//
//  Created by Bryan Nova on 9/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit
import NotificationCenter
import UserNotifications

class DiscreteMoodWidget: UIViewController, NCWidgetProviding {

private typealias Me = DiscreteMoodWidget
	private static var realSettings: Settings

	// MARK: - IBOutlets

	@IBOutlet weak final var noteView: UITextView!
	@IBOutlet weak final var scrollView: UIScrollView!
	@IBOutlet weak final var moodContentView: UIView!
	@IBOutlet weak final var doneButton: UIButton!

	// MARK: - Instance Variables

	/// This is not made private solely for testing purposes
	final var note: String? = nil
	private final var rating: Int = Int(DependencyInjector.settings.maxMood)
	private final var ratingButtons = [UIButton]()

	private final let spacingBetweenRatingButtons: CGFloat = 5

	private var settings: Settings {
		do {
			let existingSettings = try database().query(SettingsImpl.fetchRequest())
			if existingSettings.count == 0 {
				do {
					let transaction = database().transaction()
					let settings = try retryOnFail({ try transaction.new(SettingsImpl.self) }, maxRetries: 2)
					try retryOnFail({ try transaction.commit() }, maxRetries: 2)
					Me.realSettings = try database().pull(savedObject: settings)
				} catch {
					fatalError(String(format: "Failed to create or save default settings: %@", errorInfo(error)))
				}
			} else {
				Me.realSettings = existingSettings[0]
			}
		} catch {
			fatalError(String(format: "Failed to load settings: %@", errorInfo(error)))
		}
	}

	private let log = Log()

	// MARK: - UIView Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
		reset()
	}

	public final override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateUI()
	}

	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		// Perform any setup necessary in order to update the view.

		// If an error is encountered, use NCUpdateResult.Failed
		// If there's no update required, use NCUpdateResult.NoData
		// If there's an update, use NCUpdateResult.NewData

		completionHandler(NCUpdateResult.noData)
	}

	// MARK: - Button Actions

	@IBAction final func doneButtonPressed(_ sender: Any) {
		do {
			let transaction = DependencyInjector.db.transaction()
			let mood = try DependencyInjector.sample.mood(using: transaction)
			mood.date = Date()
			mood.rating = Double(rating)
			mood.note = note
			mood.minRating = DependencyInjector.settings.minMood
			mood.maxRating = DependencyInjector.settings.maxMood
			mood.setSource(.introspective)
			try transaction.commit()

			reset()
			updateUI()
		} catch {
			let content = UNMutableNotificationContent()
			content.title = NSString.localizedUserNotificationString(forKey: "Failed to record mood", arguments: nil)
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

	@objc private final func moodRatingButtonPressed(_ button: UIButton) {
		if let title = button.currentTitle {
			if let rating = Int(title) {
				let oldRatingButton = getRatingButton(forRating: self.rating)
				let newRatingButton = getRatingButton(forRating: rating)

				deselectRatingButton(oldRatingButton)
				selectRatingButton(newRatingButton)

				self.rating = rating
			} else {
				log.error("Unable to get rating from button title")
			}
		} else {
			log.error("Missing title for mood rating button")
		}
	}

	// MARK: - Helper Functions

	@objc private final func resetAndUpdateUI() {
		reset()
		updateUI()
	}

	private final func reset() {
		note = nil
		noteView.text = ""
		let min = DependencyInjector.settings.minMood
		let max = DependencyInjector.settings.maxMood
		rating = Int((max - min) / 2 + min)
	}

	private final func updateUI() {
		removeExistingMoodButtons()

		let min = DependencyInjector.settings.minMood
		let max = DependencyInjector.settings.maxMood
		var lastView: UIView? = nil
		for i in Int(min) ... Int(max) {
			let ratingButton = createButtonForRating(i)
			ratingButtons.append(ratingButton)
			moodContentView.addSubview(ratingButton)
			addConstraintsForRatingButton(ratingButton, lastView)
			lastView = ratingButton
		}
		if let lastView = lastView {
			moodContentView.trailingAnchor.constraint(equalTo: lastView.trailingAnchor).isActive = true
		}
		let ratingButton = getRatingButton(forRating: rating)
		selectRatingButton(ratingButton)
	}

	private final func removeExistingMoodButtons() {
		ratingButtons = [UIButton]()
		for subView in moodContentView.subviews {
			moodContentView.willRemoveSubview(subView)
			subView.removeFromSuperview()
		}
	}

	private final func createButtonForRating(_ rating: Int) -> UIButton {
		let min = DependencyInjector.settings.minMood
		let max = DependencyInjector.settings.maxMood
		let button = UIButton(type: .custom)
		button.addTarget(self, action: #selector(moodRatingButtonPressed), for: .touchUpInside)
		button.backgroundColor = MoodUiUtil.colorForMood(rating: Double(rating), minRating: min, maxRating: max)
		let titleColor = button.backgroundColor?.highContrast()
		button.setTitleColor(titleColor, for: .normal)
		button.setTitle("\(rating)", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.accessibilityIdentifier = "set mood to \(rating) button"
		button.accessibilityLabel = "set mood to \(rating) button"
		return button
	}

	private final func addConstraintsForRatingButton(_ ratingButton: UIButton, _ lastView: UIView?) {
		if let lastView = lastView {
			ratingButton.leadingAnchor.constraint(
				equalTo: lastView.trailingAnchor,
				constant: spacingBetweenRatingButtons).isActive = true
		} else {
			ratingButton.leadingAnchor.constraint(equalTo: moodContentView.leadingAnchor).isActive = true
		}
		widthConstraint(for: ratingButton, width: getBaseWidth()).isActive = true
		ratingButton.topAnchor.constraint(equalTo: moodContentView.topAnchor, constant: 5).isActive = true
		ratingButton.bottomAnchor.constraint(equalTo: moodContentView.bottomAnchor, constant: -5).isActive = true
	}

	private final func getRatingButton(forRating rating: Int) -> UIButton {
		let buttonIndex = rating - Int(DependencyInjector.settings.minMood)
		return ratingButtons[buttonIndex]
	}

	private final func selectRatingButton(_ ratingButton: UIButton) {
		removeTopBottomAndWidthConstraintsFor(ratingButton)
		widthConstraint(for: ratingButton, width: getBaseWidth() + spacingBetweenRatingButtons).isActive = true
		ratingButton.topAnchor.constraint(equalTo: moodContentView.topAnchor).isActive = true
		ratingButton.bottomAnchor.constraint(equalTo: moodContentView.bottomAnchor).isActive = true
	}

	private final func deselectRatingButton(_ ratingButton: UIButton) {
		removeTopBottomAndWidthConstraintsFor(ratingButton)
		widthConstraint(for: ratingButton, width: getBaseWidth()).isActive = true
		ratingButton.topAnchor.constraint(equalTo: moodContentView.topAnchor, constant: 5).isActive = true
		ratingButton.bottomAnchor.constraint(equalTo: moodContentView.bottomAnchor, constant: -5).isActive = true
	}

	private final func removeTopBottomAndWidthConstraintsFor(_ ratingButton: UIButton) {
		for constraint in moodContentView.constraints {
			let involvesRatingButton = thisConstraint(constraint, involves: ratingButton)
			if involvesRatingButton && [.top, .bottom].contains(constraint.secondAttribute) {
				constraint.isActive = false
			}
		}
		for constraint in ratingButton.constraints {
			if [.width, .top, .bottom].contains(constraint.firstAttribute) {
				constraint.isActive = false
			}
		}
	}

	private final func thisConstraint(_ constraint: NSLayoutConstraint, involves item: UIView) -> Bool {
		return constraint.firstItem?.accessibilityIdentifier == item.accessibilityIdentifier ||
			constraint.secondItem?.accessibilityIdentifier == item.accessibilityIdentifier
	}

	private final func widthConstraint(for view: UIView, width: CGFloat) -> NSLayoutConstraint {
		let widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
		widthConstraint.priority = .required
		return widthConstraint
	}

	private final func getBaseWidth() -> CGFloat {
		let minWidth: CGFloat = 30
		let numberOfMoods = CGFloat(DependencyInjector.settings.maxMood - DependencyInjector.settings.minMood + 1)
		// not -1 because need to account for one mood always being selected, which adds 1 spacing
		let totalSpacingRequired = spacingBetweenRatingButtons * numberOfMoods
		let proportionalWidth = (scrollView.width - totalSpacingRequired) / numberOfMoods
		if proportionalWidth > minWidth {
			return proportionalWidth
		}
		return minWidth
	}

	private final func sendUserNotification(
		withContent content: UNMutableNotificationContent,
		id: String,
		repeats: Bool = false,
		interval: TimeInterval = 1)
	{
		DependencyInjector.util.ui.sendUserNotification(withContent: content, id: id, repeats: repeats, interval: interval)
	}
}
