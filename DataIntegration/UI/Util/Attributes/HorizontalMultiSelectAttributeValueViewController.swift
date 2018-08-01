//
//  HorizontalMultiSelectAttributeValueViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class HorizontalMultiSelectAttributeValueViewController: AttributeValueTypeViewController, MultiSelectSegmentedControlDelegate {

	public var multiSelectAttribute: MultiSelectAttribute!

	@IBOutlet weak var multiSelect: MultiSelectSegmentedControl!

	override func viewDidLoad() {
		super.viewDidLoad()

		multiSelect.removeAllSegments()
		var index = 0
		for value in multiSelectAttribute.possibleValues {
			let segmentTitle = try! multiSelectAttribute.convertToDisplayableString(from: value)
			multiSelect.insertSegment(withTitle: segmentTitle, at: index, animated: false)
			index += 1
		}
		multiSelect.delegate = self

		if currentValue != nil {
			for value in try! multiSelectAttribute.valueAsArray(currentValue) {
				let index = multiSelectAttribute.indexOf(possibleValue: value)
				if index != nil {
					multiSelect.selectedSegmentIndexes.insert(index!)
				}
			}
		}
	}

	public func multiSelect(multiSelectSegmendedControl: MultiSelectSegmentedControl, didChangeValue value: Bool, atIndex index: Int) {
		var values = [Any]()
		for index in multiSelect.selectedSegmentIndexes {
			let value = multiSelectAttribute.possibleValues[Int(index)]
			values.append(value)
		}
		currentValue = try! multiSelectAttribute.valueFromArray(values)
	}
}
