//
//  AttributedChooserViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

class AttributedChooserViewController: UIViewController {

	public var possibleValues: [Attributed]!
	public var currentValue: Attributed!
	public var notificationToSendWhenAccepted: Notification.Name!

	@IBOutlet weak var valuePicker: UIPickerView!
	@IBOutlet weak var attributeScrollView: UIScrollView!

	fileprivate var attributeViewControllers: [AttributeViewController]!
	fileprivate let verticalSpacing = CGFloat(5)

	override func viewDidLoad() {
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

	public override func reloadInputViews() {
		super.reloadInputViews()
		valuePicker.reloadAllComponents()
		resetScrollView()
		populateScrollView()
	}

	@objc func accepted() {
		for controller in attributeViewControllers {
			let attribute = controller.attribute!
			let attributeValue = controller.attributeValue!
			try! currentValue.set(attribute: attribute, to: attributeValue)
		}
		NotificationCenter.default.post(name: notificationToSendWhenAccepted, object: currentValue)
	}

	fileprivate func resetScrollView() {
		attributeViewControllers = [AttributeViewController]()
		for view in attributeScrollView.subviews {
			attributeScrollView.willRemoveSubview(view)
			view.removeFromSuperview()
		}
	}

	fileprivate func populateScrollView() {
		populateAttributes()
		createAndAddAcceptButton()
	}

	fileprivate func populateAttributes() {
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

	fileprivate func createAndAddAcceptButton() {
		let controller = UIStoryboard(name: "AttributeList", bundle: nil).instantiateViewController(withIdentifier: "acceptButton") as! AttributeListAcceptButtonViewController
		let x = attributeScrollView.frame.minX
		controller.view.frame = CGRect(x: x, y: getNextYPosForScrollView(), width: subViewWidth(), height: 30)
		controller.acceptButton.addTarget(self, action: #selector(accepted), for: .touchUpInside)
		attributeScrollView.addSubview(controller.view)
		controller.didMove(toParentViewController: self)
	}

	fileprivate func getNextYPosForScrollView() -> CGFloat {
		var yPos = CGFloat(0)
		for view in attributeScrollView.subviews {
			yPos += view.frame.height + verticalSpacing
		}
		return yPos
	}

	fileprivate func subViewWidth() -> CGFloat {
		return attributeScrollView.frame.maxX - attributeScrollView.frame.minX - attributeScrollView.adjustedContentInset.right - attributeScrollView.adjustedContentInset.left
	}
}

extension AttributedChooserViewController: UIPickerViewDataSource {

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return possibleValues.count
	}
}

extension AttributedChooserViewController: UIPickerViewDelegate {

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return possibleValues[row].name
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		currentValue = possibleValues[row]
		resetScrollView()
		populateScrollView()
	}
}
