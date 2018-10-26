//
//  GraphSetupViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class GraphSetupViewController: UIViewController {

	// MARK: - Static Variables

	private typealias Me = GraphSetupViewController
	private static let setGraphType = Notification.Name("changedGraphType")

	// MARK: - IBOutlets

	@IBOutlet weak final var graphTypeButton: UIButton!
	@IBOutlet weak final var subView: UIView!

	// MARK: - Instance Variables

	private final var graphType: GraphType!
	private final var subViewController: UIViewController?

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		if graphType == nil {
			graphType = GraphType.allTypes[0]
		}
		NotificationCenter.default.addObserver(self, selector: #selector(setGraphType), name: Me.setGraphType, object: nil)
		updateChooseGraphTypeButtonTitle()
		updateSubView()
	}

	// MARK: - Actions

	@IBAction final func setGraphTypewButtonPressed(sender: Any) {
		let controller = storyboard!.instantiateViewController(withIdentifier: "chooseGraphType") as! ChooseGraphTypeViewController
		controller.currentValue = graphType
		controller.notificationToSendOnAccept = Me.setGraphType
		customPresentViewController(UiUtil.defaultPresenter, viewController: controller, animated: false)
	}

	// MARK: - Received Notifications

	@objc private final func setGraphType(notification: Notification) {
		let newGraphType = notification.object as! GraphType
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
		graphTypeButton.accessibilityValue = graphType.description
	}

	private final func updateSubView() {
		subViewController?.view.removeFromSuperview()
		subViewController?.removeFromParent()
		switch (graphType!) {
			case .line, .bar, .scatter:
				let controller = UIStoryboard(name: "BasicXYGraph", bundle: nil).instantiateViewController(withIdentifier: "graphSetup") as! BasicXYGraphSetupViewController
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
