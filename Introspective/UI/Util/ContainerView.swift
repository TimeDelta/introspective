//
//  ContainerView.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common

public final class ContainerView<T: UIViewController>: UIView {
	unowned final var parentController: UIViewController
	weak final var currentController: T?

	private final let log = Log()

	init(parentController: UIViewController) {
		self.parentController = parentController
		super.init(frame: CGRect.zero)
	}

	public required init?(coder _: NSCoder) {
		log.error("init(coder:) has not been implemented - cannot use with storyboards")
		return nil
	}

	final func install(_ controller: T) {
		removeCurrentController()
		currentController = controller
		setUpViewController(controller, animated: false)
	}

	final func uninstall() {
		removeCurrentController()
	}

	private final func setUpViewController(_ targetController: T?, animated _: Bool) {
		if let controller = targetController {
			parentController.addChild(controller)
			controller.view.frame = bounds
			addSubview(controller.view)
			controller.didMove(toParent: parentController)
		}
	}

	private final func removeCurrentController() {
		if let _viewController = currentController {
			_viewController.willMove(toParent: nil)
			_viewController.view.removeFromSuperview()
			_viewController.removeFromParent()
			currentController = nil
		}
	}
}
