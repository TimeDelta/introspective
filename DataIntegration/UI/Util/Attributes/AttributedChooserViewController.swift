//
//  AttributedChooserViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class AttributedChooserViewController: UIViewController {

	public final var possibleValues: [Attributed]!
	public final var currentValue: Attributed!
	public final var notificationToSendWhenAccepted: Notification.Name!

	@IBOutlet weak final var valuePicker: UIPickerView!
	@IBOutlet weak final var attributeScrollView: UIScrollView!

	private final var attributeViewControllers: [AttributeViewController]!
	private final let verticalSpacing = CGFloat(5)

	final override func viewDidLoad() {
		super.viewDidLoad()

		valuePicker.delegate = self
		valuePicker.dataSource = self

		if currentValue == nil {
			currentValue = possibleValues[0]
			valuePicker.selectRow(0, inComponent: 0, animated: false)
		} else {
			var index = 0
			for value in possibleValues {
				if value.name == currentValue.name {
					valuePicker.selectRow(index, inComponent: 0, animated: false)
					break
				}
				index += 1
			}
		}

		attributeViewControllers = [AttributeViewController]()
		populateScrollView()
	}

	public final override func reloadInputViews() {
		super.reloadInputViews()
		valuePicker.reloadAllComponents()
		resetScrollView()
		populateScrollView()
	}

	@objc final func accepted() {
		for controller in attributeViewControllers {
			let attribute = controller.attribute!
			let attributeValue = controller.attributeValue!
			try! currentValue.set(attribute: attribute, to: attributeValue)
		}
		NotificationCenter.default.post(name: notificationToSendWhenAccepted, object: currentValue)
	}

	private final func resetScrollView() {
		attributeViewControllers = [AttributeViewController]()
		for view in attributeScrollView.subviews {
			attributeScrollView.willRemoveSubview(view)
			view.removeFromSuperview()
		}
	}

	private final func populateScrollView() {
		populateAttributes()
		createAndAddAcceptButton()
	}

	private final func populateAttributes() {
		var yPos = CGFloat(0)
		let height = CGFloat(70)
		for attribute in currentValue.attributes {
			let controller = UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "attributeView") as! AttributeViewController
			controller.attribute = attribute
			controller.attributeValue = try! currentValue.value(of: attribute)
			let x = attributeScrollView.frame.minX
			controller.view.frame = CGRect(x: x, y: yPos, width: subViewWidth(), height: height)
			attributeViewControllers.append(controller)
			attributeScrollView.addSubview(controller.view)
			controller.didMove(toParentViewController: self)
			yPos += height + verticalSpacing
		}
	}

	private final func createAndAddAcceptButton() {
		let controller = UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "acceptButton") as! AttributeListAcceptButtonViewController
		let x = attributeScrollView.frame.minX
		controller.view.frame = CGRect(x: x, y: getNextYPosForScrollView(), width: subViewWidth(), height: 30)
		controller.acceptButton.addTarget(self, action: #selector(accepted), for: .touchUpInside)
		attributeScrollView.addSubview(controller.view)
		controller.didMove(toParentViewController: self)
	}

	private final func getNextYPosForScrollView() -> CGFloat {
		var yPos = CGFloat(0)
		for view in attributeScrollView.subviews {
			yPos += view.frame.height + verticalSpacing
		}
		return yPos
	}

	private func subViewWidth() -> CGFloat {
		return attributeScrollView.frame.maxX - attributeScrollView.frame.minX - attributeScrollView.adjustedContentInset.right - attributeScrollView.adjustedContentInset.left
	}
}

extension AttributedChooserViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return possibleValues.count
	}
}

extension AttributedChooserViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return possibleValues[row].name
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		currentValue = possibleValues[row]
		resetScrollView()
		populateScrollView()
	}
}
