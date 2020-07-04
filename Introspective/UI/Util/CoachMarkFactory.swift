//
//  CoachMarkFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 4/24/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import Instructions

// sourcery: AutoMockable
public protocol CoachMarkFactory {
	func controller() -> CoachMarksControllerProtocol
}

public final class CoachMarkFactoryImpl: CoachMarkFactory {
	public final func controller() -> CoachMarksControllerProtocol {
		CoachMarksController()
	}
}

// sourcery: AutoMockable
public protocol CoachMarksControllerProtocol {
	/// Implement the data source protocol and supply
	/// the coach marks to display.
	var dataSource: CoachMarksControllerDataSource? { get set }
	/// Implement the delegate protocol, which methods will
	/// be called at various points.
	var delegate: CoachMarksControllerDelegate? { get set }
	/// Implement the animation delegate protocol, which methods will
	/// be called at various points.
	var animationDelegate: CoachMarksControllerAnimationDelegate? { get set }
	/// Controls the style of the status bar when coach marks are displayed
	var statusBarStyle: UIStatusBarStyle? { get set }
	var rotationStyle: RotationStyle { get set }
	var statusBarVisibility: StatusBarVisibility { get set }
	var interfaceOrientations: InterfaceOrientations { get set }
	var skipView: CoachMarkSkipView? { get set }

	func start(in presentationContext: PresentationContext)
	func stop(immediately: Bool)
	func prepareForChange()
	func restoreAfterChangeDidComplete()
}

extension CoachMarksController: CoachMarksControllerProtocol {}
