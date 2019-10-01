//
//  QueryResultsGraphSetupViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

final class QueryResultsGraphSetupViewController: UIViewController {

	// MARK: - Static Variables

	private typealias Me = QueryResultsGraphSetupViewController
	private static let setGraphType = Notification.Name("changedGraphType")

	// MARK: - IBOutlets

	@IBOutlet weak final var graphTypeButton: UIButton!
	@IBOutlet weak final var subView: UIView!

	// MARK: - Instance Variables

	public final var samples: [Sample]!
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

	// MARK: - Actions

	@IBAction final func setGraphTypewButtonPressed(sender: Any) {
		let controller: ChooseGraphTypeViewController = viewController(named: "chooseGraphType")
		controller.currentValue = graphType
		controller.notificationToSendOnAccept = Me.setGraphType
		customPresentViewController(DependencyInjector.get(UiUtil.self).defaultPresenter, viewController: controller, animated: false)
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

	// MARK: - Helper Functions

	private final func shouldNotResetSubView(_ newGraphType: GraphType) -> Bool {
		return graphType == newGraphType || (
			(graphType == .line || graphType == .bar || graphType == .scatter)
			&&
			(newGraphType == .line || newGraphType == .bar || newGraphType == .scatter)
		)
	}

	private final func updateChooseGraphTypeButtonTitle() {
		graphTypeButton.setTitle(graphType.description, for: .normal)
	}

	private final func updateSubView() {
		subViewController?.view.removeFromSuperview()
		subViewController?.removeFromParent()
		switch (graphType!) {
			case .line, .bar, .scatter:
				let controller: QueryResultsBasicXYGraphCustomizationViewController = viewController(named: "queryResultsGraphSetup", fromStoryboard: "BasicXYGraph")
				controller.realNavigationController = navigationController
				controller.chartType = graphType.aaChartType
				controller.samples = samples
				controller.view.frame = subView.frame
				controller.view.addConstraints(subView.constraints)
				subViewController = controller
				view.addSubview(controller.view)
				addChild(controller)
				break
		}
	}
}
