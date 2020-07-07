//
//  GraphSetupViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

final class GraphSetupViewController: UIViewController {
	// MARK: - Static Variables

	private typealias Me = GraphSetupViewController
	private static let setGraphType = Notification.Name("changedGraphType")

	// MARK: - IBOutlets

	@IBOutlet final var graphTypeButton: UIButton!
	@IBOutlet final var subView: UIView!

	// MARK: - Instance Variables

	private final var graphType: GraphType!
	private final var subViewController: UIViewController?

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		if graphType == nil {
			graphType = GraphType.allTypes[0]
		}
		observe(selector: #selector(setGraphType), name: Me.setGraphType)
		updateChooseGraphTypeButtonTitle()
		updateSubView()
	}

	// MARK: - Received Notifications

	@objc private final func setGraphType(notification: Notification) {
		guard let newGraphType: GraphType = value(for: .graphType, from: notification) else { return }
		let skipUpdateSubView = shouldNotResetSubView(newGraphType)
		graphType = newGraphType
		if let controller = subViewController as? BasicXYGraphTypeSetupViewController {
			controller.chartType = graphType.aaChartType
		}
		updateChooseGraphTypeButtonTitle()

		if skipUpdateSubView { return }

		updateSubView()
	}

	// MARK: - Actions

	@IBAction final func setGraphTypewButtonPressed(sender _: Any) {
		let controller: ChooseGraphTypeViewController = viewController(named: "chooseGraphType")
		controller.currentValue = graphType
		controller.notificationToSendOnAccept = Me.setGraphType
		customPresentViewController(
			DependencyInjector.get(UiUtil.self).defaultPresenter,
			viewController: controller,
			animated: false
		)
	}

	// MARK: - Helper Functions

	private final func shouldNotResetSubView(_ newGraphType: GraphType) -> Bool {
		graphType == newGraphType || (
			(graphType == .line || graphType == .bar || graphType == .scatter)
				&&
				(newGraphType == .line || newGraphType == .bar || newGraphType == .scatter)
		)
	}

	private final func updateChooseGraphTypeButtonTitle() {
		graphTypeButton.setTitle(graphType.description, for: .normal)
		graphTypeButton.accessibilityValue = graphType.description
	}

	private final func updateSubView() {
		subViewController?.view.removeFromSuperview()
		subViewController?.removeFromParent()
		switch graphType! {
		case .line, .bar, .scatter:
			let controller: BasicXYGraphSetupViewController = viewController(
				named: "graphSetup",
				fromStoryboard: "BasicXYGraph"
			)
			controller.realNavigationController = navigationController
			controller.chartType = graphType.aaChartType
			controller.view.frame = subView.frame
			controller.view.addConstraints(subView.constraints)
			subViewController = controller
			view.addSubview(controller.view)
			addChild(controller)
			break
		}
	}
}
