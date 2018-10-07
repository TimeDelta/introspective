//
//  BasicXYGraphSetupViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import AAInfographics
import os

final class BasicXYGraphSetupViewController: BasicXYGraphTypeSetupViewController {

	// MARK: - Static Member Variables

	private typealias Me = BasicXYGraphSetupViewController
	private static let singleDataType = 0
	private static let multipleDataTypes = 1

	// MARK: - IBOutlets

	@IBOutlet weak final var numberOfDataTypesSegmentedControl: UISegmentedControl!
	@IBOutlet weak final var subView: UIView!

	// MARK: - Instance Member Variables

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

	@IBAction final func updateSubView(sender: Any) {
		subViewController?.view.removeFromSuperview()
		subViewController?.removeFromParent()
		switch (numberOfDataTypesSegmentedControl.selectedSegmentIndex) {
			case Me.singleDataType:
				let controller = storyboard!.instantiateViewController(withIdentifier: "singleSampleTypeSetup") as! SingleSampleTypeBasicXYGraphCustomizationViewController
				controller.realNavigationController = realNavigationController
				controller.chartType = chartType
				controller.view.frame = subView.frame
				controller.view.addConstraints(subView.constraints)
				subViewController = controller
				view.addSubview(controller.view)
				addChild(controller)
				break
			case Me.multipleDataTypes:
				let controller = storyboard!.instantiateViewController(withIdentifier: "multipleSampleTypeSetup") as! MultipleSampleTypeBasicXYGraphCustomizationViewController
				controller.realNavigationController = realNavigationController
				controller.chartType = chartType
				controller.view.frame = subView.frame
				controller.view.addConstraints(subView.constraints)
				subViewController = controller
				view.addSubview(controller.view)
				addChild(controller)
				break
			default:
				os_log("Unknown segmented control index: %d", type: .error, numberOfDataTypesSegmentedControl.selectedSegmentIndex)
		}
	}
}
