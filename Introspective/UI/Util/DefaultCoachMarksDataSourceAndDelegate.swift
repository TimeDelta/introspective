//
//  DefaultCoachMarksDataSourceAndDelegate.swift
//  Introspective
//
//  Created by Bryan Nova on 2/18/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Instructions

import Common
import DependencyInjection
import UIExtensions

// sourcery: AutoMockable
public protocol CoachMarksDataSourceAndDelegate: CoachMarksControllerDataSource, CoachMarksControllerDelegate {}

public final class DefaultCoachMarksDataSourceAndDelegate: CoachMarksDataSourceAndDelegate {
	// MARK: - Static Variables

	private typealias Me = DefaultCoachMarksDataSourceAndDelegate

	private static let log = Log()

	// MARK: - Static Functions

	static func defaultSkipInstructionsView() -> CoachMarkSkipView {
		let skipView = CoachMarkSkipDefaultView()
		skipView.setTitle("Skip instructions", for: .normal)
		skipView.frame = CGRect(x: 0.0, y: 0.0, width: skipView.frame.width, height: skipView.frame.height)
		return skipView
	}

	static func defaultCoachMarkSkipViewConstraints() -> [CoachMarkSkipViewConstraint] {
		[
			HorizontallyCenteredCoachMarkSkipViewConstraint(),
			GenericCoachMarkSkipViewConstraint(
				skipViewAttribute: .bottom,
				relatedBy: .equal,
				parentViewAttribute: .bottomMargin
			),
		]
	}

	// MARK: - Instance Variables

	private final let _coachMarksInfo: [WeakRef<CoachMarkInfo>]
	private final let instructionsShownKey: UserDefaultKey
	private final let cleanup: (() -> Void)?
	private final let skipViewLayoutConstraints: [CoachMarkSkipViewConstraint]?

	// MARK: - Initializers

	/// - Parameter instructionsShownKey: The UserDefaults key to be used when determining if the instructions for this screen have been shown yet.
	/// - Parameter cleanup: When the user either skips the remaining instructions or finishes the instructions, this will run.
	public init(
		_ coachMarksInfo: [CoachMarkInfo],
		instructionsShownKey: UserDefaultKey,
		cleanup: (() -> Void)? = nil,
		skipViewLayoutConstraints: [CoachMarkSkipViewConstraint]? = nil
	) {
		_coachMarksInfo = coachMarksInfo.map { WeakRef($0) }
		self.instructionsShownKey = instructionsShownKey
		self.cleanup = cleanup
		self.skipViewLayoutConstraints = skipViewLayoutConstraints
	}

	// MARK: - CoachMarksControllerDataSource

	public final func coachMarksController(
		_ coachMarksController: CoachMarksController,
		coachMarkViewsAt index: Int,
		madeFrom coachMark: CoachMark
	) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
		let coachViews = coachMarksController.helper.makeDefaultCoachViews(
			withArrow: coachMarksInfo(index).useArrow,
			arrowOrientation: coachMark.arrowOrientation
		)

		coachViews.bodyView.hintLabel.text = coachMarksInfo(index).hintText
		coachViews.bodyView.nextLabel.text = coachMarksInfo(index).nextText

		return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
	}

	public final func coachMarksController(
		_ coachMarksController: CoachMarksController,
		coachMarkAt index: Int
	) -> CoachMark {
		if let runSetup = coachMarksInfo(index).setup {
			runSetup()
		}
		if index == _coachMarksInfo.count - 1 {
			injected(UserDefaultsUtil.self).setUserDefault(true, forKey: instructionsShownKey)
		}
		return coachMarksController.helper.makeCoachMark(for: coachMarksInfo(index).view)
	}

	public final func numberOfCoachMarks(for _: CoachMarksController) -> Int {
		_coachMarksInfo.count
	}

	public final func coachMarksController(
		_: CoachMarksController,
		constraintsForSkipView skipView: UIView,
		inParent parentView: UIView
	) -> [NSLayoutConstraint]? {
		if let skipViewLayoutConstraints = skipViewLayoutConstraints {
			return skipViewLayoutConstraints.map { $0.constraint(skipView: skipView, parentView: parentView) }
		}
		return nil
	}

	// MARK: - CoachMarksControllerDelegate

	public final func coachMarksController(_: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
		if skipped {
			injected(UserDefaultsUtil.self).setUserDefault(true, forKey: instructionsShownKey)
		}
		if let cleanup = cleanup {
			cleanup()
		}
	}

	// MARK: - Helper Functions

	private final func coachMarksInfo(_ index: Int) -> CoachMarkInfo {
		guard let coachMark = _coachMarksInfo[index].value else {
			Me.log.error("Unable to resolve CoachMarkInfo")
			return CoachMarkInfo(hint: "", useArrow: false)
		}
		return coachMark
	}
}
