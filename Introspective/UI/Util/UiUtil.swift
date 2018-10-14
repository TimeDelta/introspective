//
//  UiUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

final class UiUtil {

	public static let defaultPresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	public static func customPresenter(width: ModalSize = .default, height: ModalSize = .default, center: ModalCenterPosition = .center) -> Presentr {
		let customType = PresentationType.custom(width: width, height: height, center: center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}

	public static func setView(_ view: UIView, enabled: Bool? = nil, hidden: Bool? = nil) {
		view.isHidden = hidden ?? view.isHidden
		view.isUserInteractionEnabled = enabled ?? view.isUserInteractionEnabled
	}

	public static func setButton(_ button: UIButton, enabled: Bool? = nil, hidden: Bool? = nil) {
		button.isEnabled = enabled ?? button.isEnabled
		setView(button, enabled: enabled, hidden: hidden)
	}

	public static func setBackButton(for viewController: UIViewController, title: String, action selector: Selector) {
		// Disable the swipe to make sure user presses button
		viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

		// Replace the default back button
		viewController.navigationItem.setHidesBackButton(true, animated: false)

		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "back-button"), for: .normal)
		button.setTitle(title, for: .normal)
		button.sizeToFit()
		button.addTarget(viewController, action: selector, for: .touchUpInside)

		let backButton = UIBarButtonItem(customView: button)
		viewController.navigationItem.leftBarButtonItem = backButton
	}
}
