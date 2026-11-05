//
//  DiscreteMoodRatingTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 4/3/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

public final class DiscreteMoodRatingTableViewCell: UITableViewCell {
	// MARK: - Static Variables

	private typealias Me = DiscreteMoodRatingTableViewCell

	private static let log = Log()

	// MARK: - IBOutlet

	@IBOutlet final var scrollView: UIScrollView!
	@IBOutlet final var moodContentView: UIView!

	// MARK: - Instance Variables

	public final var minRating: Int! {
		didSet { setNeedsLayout() }
	}

	public final var maxRating: Int! {
		didSet { setNeedsLayout() }
	}

	public final var rating: Int! {
		didSet { setNeedsLayout() }
	}

	private struct RatingScale: Equatable {
		let min: Int
		let max: Int
	}

	private struct RatingButtonLayout {
		let button: UIButton
		let width: NSLayoutConstraint
		let top: NSLayoutConstraint
		let bottom: NSLayoutConstraint
	}

	private var renderedScale: RatingScale?
	private weak var renderedContentView: UIView?
	private var ratingButtons = [RatingButtonLayout]()
	private var ratingConstraints = [NSLayoutConstraint]()
	private var selectedRating: Int?
	private var baseRatingButtonWidth: CGFloat?

	private final let spacingBetweenRatingButtons: CGFloat = 5

	// MARK: - UIView Overrides

	public final override func layoutSubviews() {
		super.layoutSubviews()
		updateUI()
	}

	// MARK: - Actions

	@objc private final func moodRatingButtonPressed(_ button: UIButton) {
		if let title = button.currentTitle {
			if let rating = Int(title) {
				guard scrollView != nil, let contentView = renderedContentView,
					contentView === moodContentView, button.superview === contentView,
					let scale = renderedScale, minRating == scale.min, maxRating == scale.max,
					let layout = getRatingButton(forRating: rating), layout.button === button
				else { return }
				self.rating = rating
				updateButtonWidths()
				updateSelectedRating()

				post(.moodRatingChanged, userInfo: [.number: Double(rating)])
			} else {
				Me.log.error("Unable to get rating from button title")
			}
		} else {
			Me.log.error("Missing title for mood rating button")
		}
	}

	// MARK: - Helper Functions

	private final func updateUI() {
		guard scrollView != nil, let contentView = moodContentView,
			let min = minRating, let max = maxRating, min <= max
		else {
			removeExistingRatingButtons()
			return
		}
		let scale = RatingScale(min: min, max: max)
		if renderedScale != scale || renderedContentView !== contentView {
			rebuildRatingButtons(for: scale, in: contentView)
		}
		updateButtonWidths()
		updateSelectedRating()
	}

	private final func removeExistingRatingButtons() {
		NSLayoutConstraint.deactivate(ratingConstraints)
		for layout in ratingButtons {
			layout.button.removeFromSuperview()
		}
		ratingButtons.removeAll()
		ratingConstraints.removeAll()
		renderedScale = nil
		renderedContentView = nil
		selectedRating = nil
		baseRatingButtonWidth = nil
	}

	private final func rebuildRatingButtons(for scale: RatingScale, in contentView: UIView) {
		removeExistingRatingButtons()
		renderedScale = scale
		renderedContentView = contentView

		let uiUtil = injected(MoodUiUtil.self)
		var lastView: UIView?
		for value in scale.min ... scale.max {
			let button = createButtonForRating(value, scale: scale, uiUtil: uiUtil)
			contentView.addSubview(button)
			ratingButtons.append(addConstraintsForRatingButton(button, lastView, in: contentView))
			lastView = button
		}
		if let lastView = lastView {
			ratingConstraints.append(contentView.trailingAnchor.constraint(equalTo: lastView.trailingAnchor))
		}
		// UIKit also owns internal button constraints; identify the ones this renderer manages.
		for constraint in ratingConstraints { constraint.identifier = "discreteRatingEditor" }
		NSLayoutConstraint.activate(ratingConstraints)
	}

	private final func createButtonForRating(_ rating: Int, scale: RatingScale, uiUtil: MoodUiUtil) -> UIButton {
		let button = UIButton(type: .custom)
		button.addTarget(self, action: #selector(moodRatingButtonPressed), for: .touchUpInside)
		button.backgroundColor = uiUtil.colorForMood(
			rating: Double(rating),
			minRating: Double(scale.min),
			maxRating: Double(scale.max)
		)
		let titleColor = button.backgroundColor?.highContrast()
		button.setTitleColor(titleColor, for: .normal)
		button.setTitle("\(rating)", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.accessibilityIdentifier = "set mood to \(rating) button"
		button.accessibilityLabel = "set mood to \(rating) button"
		return button
	}

	private final func addConstraintsForRatingButton(
		_ button: UIButton,
		_ lastView: UIView?,
		in contentView: UIView
	) -> RatingButtonLayout {
		let leading: NSLayoutConstraint
		if let lastView = lastView {
			leading = button.leadingAnchor.constraint(
				equalTo: lastView.trailingAnchor,
				constant: spacingBetweenRatingButtons
			)
		} else {
			leading = button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
		}
		let width = button.widthAnchor.constraint(equalToConstant: 30)
		let top = button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
		let bottom = button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
		ratingConstraints.append(contentsOf: [leading, width, top, bottom])
		return RatingButtonLayout(button: button, width: width, top: top, bottom: bottom)
	}

	private final func getRatingButton(forRating rating: Int) -> RatingButtonLayout? {
		guard let scale = renderedScale, rating >= scale.min, rating <= scale.max else { return nil }
		let (index, overflow) = rating.subtractingReportingOverflow(scale.min)
		guard !overflow, ratingButtons.indices.contains(index) else { return nil }
		return ratingButtons[index]
	}

	private final func updateButtonWidths() {
		guard let scrollView = scrollView, !ratingButtons.isEmpty else { return }
		let count = CGFloat(ratingButtons.count)
		let hasSelection = rating.flatMap { getRatingButton(forRating: $0) } != nil
		// The selected button adds one spacing, in addition to the gaps between buttons.
		let totalSpacing = spacingBetweenRatingButtons * (count - 1 + (hasSelection ? 1 : 0))
		let width = Swift.max(30, (scrollView.bounds.width - totalSpacing) / count)
		guard width != baseRatingButtonWidth else { return }
		baseRatingButtonWidth = width
		let selectedButton = selectedRating.flatMap { getRatingButton(forRating: $0)?.button }
		for layout in ratingButtons {
			let extraWidth = layout.button === selectedButton ? spacingBetweenRatingButtons : 0
			updateConstraint(layout.width, constant: width + extraWidth)
		}
	}

	private final func updateSelectedRating() {
		let newSelectedRating = rating.flatMap { value in
			getRatingButton(forRating: value).map { _ in value }
		}
		guard selectedRating != newSelectedRating else { return }
		if let oldRating = selectedRating, let oldLayout = getRatingButton(forRating: oldRating) {
			updateRatingButton(oldLayout, selected: false)
		}
		if let newRating = newSelectedRating, let newLayout = getRatingButton(forRating: newRating) {
			updateRatingButton(newLayout, selected: true)
		}
		selectedRating = newSelectedRating
	}

	private final func updateRatingButton(_ layout: RatingButtonLayout, selected: Bool) {
		guard let baseWidth = baseRatingButtonWidth else { return }
		updateConstraint(layout.width, constant: baseWidth + (selected ? spacingBetweenRatingButtons : 0))
		updateConstraint(layout.top, constant: selected ? 0 : 5)
		updateConstraint(layout.bottom, constant: selected ? 0 : -5)
	}

	private final func updateConstraint(_ constraint: NSLayoutConstraint, constant: CGFloat) {
		if constraint.constant != constant {
			constraint.constant = constant
		}
	}
}
