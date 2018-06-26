//
//  Labels.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage

class Labels: NSObject, IteratorProtocol {

	struct Label {
		fileprivate(set) var tag: NLTag
		fileprivate(set) var token: String

		init(tag: NLTag, token: String) {
			self.tag = tag
			self.token = token
		}
	}

	typealias Element = Label

	fileprivate var labelsByTag: [NLTag: [Label]]
	fileprivate var labelsByIndex: [Label]
	fileprivate var currentIndex: Int

	override init() {
		labelsByTag = [NLTag: [Label]]()
		labelsByIndex = [Label]()
		currentIndex = 0
	}

	func addLabel(_ label: Label) {
		// concatenate identical consecutive tags
		var lastLabel = labelsByIndex.last
		if lastLabel?.tag == label.tag {
			lastLabel!.token.append(label.token)
			var labelsForTag = labelsByTag[lastLabel!.tag]
			labelsForTag!.removeLast()
			labelsForTag!.append(lastLabel!)
			labelsByTag[lastLabel!.tag] = labelsForTag
		} else {
			labelsByTag[label.tag]?.append(label)
			labelsByIndex.append(label)
		}
	}

	func label(_ index: Int) -> Label {
		return labelsByIndex[index]
	}

	func labels(_ tag: NLTag) -> [Label]? {
		return labelsByTag[tag]
	}

	func hasLabels() -> Bool {
		return !labelsByIndex.isEmpty
	}

	/// This function guarantees that fevery Labels object in the returned array will contain at least one label
	func splitBeforeTag(_ tag: NLTag) -> [Labels] {
		if labelsByTag[tag] == nil {
			return [self]
		}

		var labelsArray = [Labels]()

		var labelsForCurrentPart = Labels()
		for label in labelsByIndex {
			if label.tag == tag && labelsForCurrentPart.hasLabels() {
				labelsArray.append(labelsForCurrentPart)
				labelsForCurrentPart = Labels()
			}
			labelsForCurrentPart.addLabel(label)
		}

		return labelsArray
	}

	/// This function guarantees that fevery Labels object in the returned array will contain at least one label
	func splitAfterTag(_ tag: NLTag) -> [Labels] {
		if labelsByTag[tag] == nil {
			return [self]
		}

		var labelsArray = [Labels]()

		var labelsForCurrentPart = Labels()
		for label in labelsByIndex {
			labelsForCurrentPart.addLabel(label)
			if label.tag == tag && labelsForCurrentPart.hasLabels() {
				labelsArray.append(labelsForCurrentPart)
				labelsForCurrentPart = Labels()
			}
		}

		return labelsArray
	}

	func next() -> Labels.Label? {
		if currentIndex == labelsByIndex.count {
			return nil
		}
		let nextLabel = labelsByIndex[currentIndex]
		currentIndex += 1
		return nextLabel
	}
}
