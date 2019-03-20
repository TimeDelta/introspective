//
//  DiscreteRatingTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 4/3/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

public final class DiscreteRatingTableViewCell: UITableViewCell {

	// MARK: - IBOutlet

	@IBOutlet weak final var scrollView: UIScrollView!
	@IBOutlet weak final var moodContentView: UIView!

	// MARK: - Instance Variables

	public final var minRating: Int!
	public final var maxRating: Int!
	public final var rating: Int!
	private final var ratingButtons = [UIButton]()

	private final let spacingBetweenRatingButtons: CGFloat = 5

	private final let log = Log()

	// MARK: - UIView Overrides

	public final override func layoutSubviews() {
		super.layoutSubviews()
		updateUI()
	}

	// MARK: - Actions

	@objc private final func moodRatingButtonPressed(_ button: UIButton) {
		if let title = button.currentTitle {
			if let rating = Int(title) {
				let oldRatingButton = getRatingButton(forRating: self.rating)
				let newRatingButton = getRatingButton(forRating: rating)

				deselectRatingButton(oldRatingButton)
				selectRatingButton(newRatingButton)

				self.rating = rating

				post(.moodRatingUpdated, userInfo: [.number: Double(rating)])
			} else {
				log.error("Unable to get rating from button title")
			}
		} else {
			log.error("Missing title for mood rating button")
		}
	}

	// MARK: - Helper Functions

	private final func updateUI() {
		removeExistingMoodButtons()

		var lastView: UIView? = nil
		for i in minRating ... maxRating {
			let ratingButton = createButtonForRating(i)
			ratingButtons.append(ratingButton)
			moodContentView.addSubview(ratingButton)
			addConstraintsForRatingButton(ratingButton, lastView)
			lastView = ratingButton
		}
		if let lastView = lastView {
			moodContentView.trailingAnchor.constraint(equalTo: lastView.trailingAnchor).isActive = true
		}
		let ratingButton = getRatingButton(forRating: Int(rating))
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
		let min = Double(minRating)
		let max = Double(maxRating)
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
}
