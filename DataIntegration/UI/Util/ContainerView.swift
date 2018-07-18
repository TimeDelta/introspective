//
//  ContainerView.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public class ContainerView<T: UIViewController>: UIView {

	unowned var parentController: UIViewController
	weak var currentController: T?

	init(parentController: UIViewController) {
		self.parentController = parentController
		super.init(frame: CGRect.zero)
	}

	public required init?(coder aDecoder: NSCoder) {
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
			parentController.addChildViewController(controller)
			controller.view.frame = self.bounds
			self.addSubview(controller.view)
			controller.didMove(toParentViewController: parentController)
		}
	}

	fileprivate func removeCurrentController() {
		if let _viewController = currentController {
			_viewController.willMove(toParentViewController: nil)
			_viewController.view.removeFromSuperview()
			_viewController.removeFromParentViewController()
			currentController = nil
		}
	}
}
