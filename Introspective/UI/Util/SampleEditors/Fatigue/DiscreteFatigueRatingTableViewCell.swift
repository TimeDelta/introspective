//
//  DiscreteFatigueRatingTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/8/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Settings

public final class DiscreteFatigueRatingTableViewCell: UITableViewCell {
	// MARK: - Static Variables

	private typealias Me = DiscreteFatigueRatingTableViewCell

	private static let log = Log()

	// MARK: - IBOutlet

	@IBOutlet final var scrollView: UIScrollView!
	@IBOutlet final var fatigueContentView: UIView!

	// MARK: - Instance Variables

	public final var minRating: Int!
	public final var maxRating: Int!
	public final var rating: Int!
	private final var ratingButtons = [UIButton]()

	private final let spacingBetweenRatingButtons: CGFloat = 5

	// MARK: - UIView Overrides

	public final override func layoutSubviews() {
		super.layoutSubviews()
		updateUI()
	}

	// MARK: - Actions

	@objc private final func fatigueRatingButtonPressed(_ button: UIButton) {
		if let title = button.currentTitle {
			if let rating = Int(title) {
				let oldRatingButton = getRatingButton(forRating: self.rating)
				let newRatingButton = getRatingButton(forRating: rating)

				deselectRatingButton(oldRatingButton)
				selectRatingButton(newRatingButton)

				self.rating = rating

				post(.fatigueRatingChanged, userInfo: [.number: Double(rating)])
			} else {
				Me.log.error("Unable to get rating from button title")
			}
		} else {
			Me.log.error("Missing title for fatigue rating button")
		}
	}

	// MARK: - Helper Functions

	private final func updateUI() {
		removeExistingFatigueButtons()

		var lastView: UIView?
		for i in minRating ... maxRating {
			let ratingButton = createButtonForRating(i)
			ratingButtons.append(ratingButton)
			fatigueContentView.addSubview(ratingButton)
			addConstraintsForRatingButton(ratingButton, lastView)
			lastView = ratingButton
		}
		if let lastView = lastView {
			fatigueContentView.trailingAnchor.constraint(equalTo: lastView.trailingAnchor).isActive = true
		}
		let ratingButton = getRatingButton(forRating: Int(rating))
		selectRatingButton(ratingButton)
	}

	private final func removeExistingFatigueButtons() {
		ratingButtons = [UIButton]()
		for subView in fatigueContentView.subviews {
			fatigueContentView.willRemoveSubview(subView)
			subView.removeFromSuperview()
		}
	}

	private final func createButtonForRating(_ rating: Int) -> UIButton {
		let min = Double(minRating)
		let max = Double(maxRating)
		let button = UIButton(type: .custom)
		button.addTarget(self, action: #selector(fatigueRatingButtonPressed), for: .touchUpInside)
		button.backgroundColor = injected(FatigueUiUtil.self)
			.colorForFatigue(rating: Double(rating), minRating: min, maxRating: max)
		let titleColor = button.backgroundColor?.highContrast()
		button.setTitleColor(titleColor, for: .normal)
		button.setTitle("\(rating)", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.accessibilityIdentifier = "set fatigue to \(rating) button"
		button.accessibilityLabel = "set fatigue to \(rating) button"
		return button
	}

	private final func addConstraintsForRatingButton(_ ratingButton: UIButton, _ lastView: UIView?) {
		if let lastView = lastView {
			ratingButton.leadingAnchor.constraint(
				equalTo: lastView.trailingAnchor,
				constant: spacingBetweenRatingButtons
			).isActive = true
		} else {
			ratingButton.leadingAnchor.constraint(equalTo: fatigueContentView.leadingAnchor).isActive = true
		}
		widthConstraint(for: ratingButton, width: getBaseWidth()).isActive = true
		ratingButton.topAnchor.constraint(equalTo: fatigueContentView.topAnchor, constant: 5).isActive = true
		ratingButton.bottomAnchor.constraint(equalTo: fatigueContentView.bottomAnchor, constant: -5).isActive = true
	}

	private final func getRatingButton(forRating rating: Int) -> UIButton {
		let buttonIndex = rating - Int(injected(Settings.self).minFatigue)
		return ratingButtons[buttonIndex]
	}

	private final func selectRatingButton(_ ratingButton: UIButton) {
		removeTopBottomAndWidthConstraintsFor(ratingButton)
		widthConstraint(for: ratingButton, width: getBaseWidth() + spacingBetweenRatingButtons).isActive = true
		ratingButton.topAnchor.constraint(equalTo: fatigueContentView.topAnchor).isActive = true
		ratingButton.bottomAnchor.constraint(equalTo: fatigueContentView.bottomAnchor).isActive = true
	}

	private final func deselectRatingButton(_ ratingButton: UIButton) {
		removeTopBottomAndWidthConstraintsFor(ratingButton)
		widthConstraint(for: ratingButton, width: getBaseWidth()).isActive = true
		ratingButton.topAnchor.constraint(equalTo: fatigueContentView.topAnchor, constant: 5).isActive = true
		ratingButton.bottomAnchor.constraint(equalTo: fatigueContentView.bottomAnchor, constant: -5).isActive = true
	}

	private final func removeTopBottomAndWidthConstraintsFor(_ ratingButton: UIButton) {
		for constraint in fatigueContentView.constraints {
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
		constraint.firstItem?.accessibilityIdentifier == item.accessibilityIdentifier ||
			constraint.secondItem?.accessibilityIdentifier == item.accessibilityIdentifier
	}

	private final func widthConstraint(for view: UIView, width: CGFloat) -> NSLayoutConstraint {
		let widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
		widthConstraint.priority = .required
		return widthConstraint
	}

	private final func getBaseWidth() -> CGFloat {
		let minWidth: CGFloat = 30
		let max = injected(Settings.self).maxFatigue
		let min = injected(Settings.self).minFatigue
		let numberOfFatigues = CGFloat(max - min + 1)
		// not -1 because need to account for one fatigue always being selected, which adds 1 spacing
		let totalSpacingRequired = spacingBetweenRatingButtons * numberOfFatigues
		let proportionalWidth = (scrollView.frame.width - totalSpacingRequired) / numberOfFatigues
		if proportionalWidth > minWidth {
			return proportionalWidth
		}
		return minWidth
	}
}
