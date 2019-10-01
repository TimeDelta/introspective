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

//sourcery: AutoMockable
public protocol CoachMarksDataSourceAndDelegate: CoachMarksControllerDataSource, CoachMarksControllerDelegate {}

public final class DefaultCoachMarksDataSourceAndDelegate: CoachMarksDataSourceAndDelegate {

	private final let coachMarksInfo: [CoachMarkInfo]
	private final let instructionsShownKey: UserDefaultKey
	private final let cleanup: (() -> Void)?
	private final let skipViewLayoutConstraints: [CoachMarkSkipViewConstraint]?

	/// - Parameter instructionsShownKey: The UserDefaults key to be used when determining if the instructions for this screen have been shown yet.
	/// - Parameter cleanup: When the user either skips the remaining instructions or finishes the instructions, this will run.
	public init(
		_ coachMarksInfo: [CoachMarkInfo],
		instructionsShownKey: UserDefaultKey,
		cleanup: (() -> Void)? = nil,
		skipViewLayoutConstraints: [CoachMarkSkipViewConstraint]? = nil)
	{
		self.coachMarksInfo = coachMarksInfo
		self.instructionsShownKey = instructionsShownKey
		self.cleanup = cleanup
		self.skipViewLayoutConstraints = skipViewLayoutConstraints
	}

	// MARK: - CoachMarksControllerDataSource

	public final func coachMarksController(
		_ coachMarksController: CoachMarksController,
		coachMarkViewsAt index: Int,
		madeFrom coachMark: CoachMark)
	-> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
		let coachViews = coachMarksController.helper.makeDefaultCoachViews(
			withArrow: coachMarksInfo[index].useArrow,
			arrowOrientation: coachMark.arrowOrientation)

		coachViews.bodyView.hintLabel.text = coachMarksInfo[index].hintText
		coachViews.bodyView.nextLabel.text = coachMarksInfo[index].nextText

		return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
	}

	public final func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
		if let runSetup = coachMarksInfo[index].setup {
			runSetup()
		}
		if index == coachMarksInfo.count - 1 {
			DependencyInjector.get(UserDefaultsUtil.self).setUserDefault(true, forKey: instructionsShownKey)
		}
		return coachMarksController.helper.makeCoachMark(for: coachMarksInfo[index].view)
	}

	public final func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
		return coachMarksInfo.count
	}

	public final func coachMarksController(_ coachMarksController: CoachMarksController, constraintsForSkipView skipView: UIView, inParent parentView: UIView) -> [NSLayoutConstraint]? {
		if let skipViewLayoutConstraints = skipViewLayoutConstraints {
			return skipViewLayoutConstraints.map({ $0.constraint(skipView: skipView, parentView: parentView) })
		}
		return nil
	}

	// MARK: - CoachMarksControllerDelegate

	public final func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
		if skipped {
			DependencyInjector.get(UserDefaultsUtil.self).setUserDefault(true, forKey: instructionsShownKey)
		}
		if let cleanup = cleanup {
			cleanup()
		}
	}
}
