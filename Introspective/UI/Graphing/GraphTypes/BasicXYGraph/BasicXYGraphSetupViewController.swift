//
//  BasicXYGraphSetupViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import AAInfographics
import UIKit

import Common

final class BasicXYGraphSetupViewController: BasicXYGraphTypeSetupViewController {
	// MARK: - Static Variables

	private typealias Me = BasicXYGraphSetupViewController

	private static let singleDataType = 0
	private static let multipleDataTypes = 1

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var numberOfDataTypesSegmentedControl: UISegmentedControl!
	@IBOutlet final var subView: UIView!

	// MARK: - Instance Variables

	private final var subViewController: BasicXYGraphTypeSetupViewController?

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		updateSubView(sender: self)
	}

	// MARK: - BasicXYGraphTypeSetupViewController Overrides

	final override func chartTypeSet() {
		subViewController?.chartType = chartType
	}

	// MARK: - Actions

	@IBAction final func updateSubView(sender _: Any) {
		subViewController?.view.removeFromSuperview()
		subViewController?.removeFromParent()
		switch numberOfDataTypesSegmentedControl.selectedSegmentIndex {
		case Me.singleDataType:
			let controller: SingleSampleTypeBasicXYGraphCustomizationViewController =
				viewController(named: "singleSampleTypeSetup")
			controller.realNavigationController = realNavigationController
			controller.chartType = chartType
			controller.view.frame = subView.frame
			controller.view.addConstraints(subView.constraints)
			subViewController = controller
			view.addSubview(controller.view)
			addChild(controller)
			break
		case Me.multipleDataTypes:
			let controller: MultipleSampleTypeBasicXYGraphCustomizationViewController =
				viewController(named: "multipleSampleTypeSetup")
			controller.realNavigationController = realNavigationController
			controller.chartType = chartType
			controller.view.frame = subView.frame
			controller.view.addConstraints(subView.constraints)
			subViewController = controller
			view.addSubview(controller.view)
			addChild(controller)
			break
		default:
			Me.log.error("Unknown segmented control index: %d", numberOfDataTypesSegmentedControl.selectedSegmentIndex)
		}
	}
}
