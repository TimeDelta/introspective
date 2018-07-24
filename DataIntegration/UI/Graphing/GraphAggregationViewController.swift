//
//  GraphAggregationViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

class GraphAggregationViewController: UIViewController {

	public var aggregationAttribute: Attribute!
	public var aggregator: Aggregator!

	@IBOutlet weak var parameterStackView: UIStackView!

	override func viewDidLoad() {
		super.viewDidLoad()
		switch (aggregationAttribute.type) {
			case .date: populateParametersForDates(); break
			case .quantity: populateParametersForQuantities(); break
			case .string: populateParametersForStrings(); break
		}
	}

	@IBAction func accepted(_ sender: Any) {
		for view in parameterStackView.arrangedSubviews {
			let containerView = view as! ContainerView<AggregationParameterViewController>
			let controller = containerView.currentController!
			let parameter = controller.parameter!
			let parameterValue = controller.parameterValue!
			try! aggregator.set(parameter: parameter, to: parameterValue)
		}
	}

	fileprivate func populateParametersForDates() {
		if aggregator == nil {
			aggregator = DateAggregator()
		}
		populateParameters()
	}

	fileprivate func populateParametersForQuantities() {
	}

	fileprivate func populateParametersForStrings() {
	}

	fileprivate func populateParameters() {
		for parameter in type(of: aggregator).parameters {
			let controller = UIStoryboard(name: "Graph", bundle: nil).instantiateViewController(withIdentifier: "parameterView") as! AggregationParameterViewController
			controller.parameter = parameter
			let containerView: ContainerView<AggregationParameterViewController> = ContainerView(parentController: self)
			containerView.install(controller)
			parameterStackView.addArrangedSubview(containerView)
		}
	}
}

class ContainerView<T: UIViewController>: UIView {

	unowned var parentController: UIViewController
	weak var currentController: T?

	init(parentController: UIViewController) {
		self.parentController = parentController
		super.init(frame: CGRect.zero)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func install(_ controller: T) {
		removeCurrentController()
		currentController = controller
		setUpViewController(controller, animated: false)
	}

	func uninstall() {
		removeCurrentController()
	}

	fileprivate func setUpViewController(_ targetController: T?, animated: Bool) {
		if let controller = targetController {
			parentController.addChild(controller)
			controller.view.frame = self.bounds
			self.addSubview(controller.view)
			controller.didMove(toParent: parentController)
		}
	}

	fileprivate func removeCurrentController() {
		if let _viewController = currentController {
			_viewController.willMove(toParent: nil)
			_viewController.view.removeFromSuperview()
			_viewController.removeFromParent()
			currentController = nil
		}
	}
}
