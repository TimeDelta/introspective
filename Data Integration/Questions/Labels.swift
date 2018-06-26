//
//  Labels.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage

class Labels: NSObject, IteratorProtocol, Sequence {

	struct Label {
		fileprivate(set) var tag: NLTag
		fileprivate(set) var token: String

		init(tag: NLTag, token: String) {
			self.tag = tag
			self.token = token
		}
	}

	typealias Element = Label

	fileprivate(set) var byTag: [NLTag: [Label]]
	fileprivate(set) var byIndex: [Label]
	fileprivate var currentIndex: Int

	override init() {
		byTag = [NLTag: [Label]]()
		byIndex = [Label]()
		currentIndex = 0
	}

	func addLabel(_ label: Label) {
		// concatenate identical consecutive tags
		var lastLabel = byIndex.last
		if lastLabel?.tag == label.tag {
			lastLabel!.token.append(label.token)
			var labelsForTag = byTag[lastLabel!.tag]
			labelsForTag!.removeLast()
			labelsForTag!.append(lastLabel!)
			byTag[lastLabel!.tag] = labelsForTag
		} else {
			byTag[label.tag]?.append(label)
			byIndex.append(label)
		}
	}

	/// Return the label
	func hasLabelFor(_ tag: NLTag) -> Bool {
		return byTag[tag] != nil
	}

	/// Return true if at least one `Label` has been added else false
	func hasLabels() -> Bool {
		return !byIndex.isEmpty
	}

	/// Right before each instance of the specified tag, create a new `Labels` object and add it to an array that will be returned.
	/// This function guarantees that every `Labels` object in the returned array will contain at least one `Label`.
	/// This function preserves ordering of underlying `Label` objects.
	func splitBefore(tag: NLTag) -> [Labels] {
		if byTag[tag] == nil {
			return [self]
		}

		var labelsArray = [Labels]()

		var labelsForCurrentPart = Labels()
		for label in byIndex {
			if label.tag == tag && labelsForCurrentPart.hasLabels() {
				labelsArray.append(labelsForCurrentPart)
				labelsForCurrentPart = Labels()
			}
			labelsForCurrentPart.addLabel(label)
		}

		return labelsArray
	}

	/// Right before each instance of the specified tags, create a new `Labels` object and add it to an array that will be returned.
	/// This function guarantees that every `Labels` object in the returned array will contain at least one `Label`.
	/// This function preserves ordering of underlying `Label` objects.
	func splitBefore(tags: Set<NLTag>) -> [Labels] {
		if !haveAtLeastOneTagFrom(tags) {
			return [self]
		}

		var labelsArray = [Labels]()

		var labelsForCurrentPart = Labels()
		for label in byIndex {
			if tags.contains(label.tag) && labelsForCurrentPart.hasLabels() {
				labelsArray.append(labelsForCurrentPart)
				labelsForCurrentPart = Labels()
			}
			labelsForCurrentPart.addLabel(label)
		}

		return labelsArray
	}

	/// Right after each instance of the specified tag, create a new `Labels` object and add it to an array that will be returned.
	/// This function guarantees that every `Labels` object in the returned array will contain at least one `Label`.
	/// This function preserves ordering of underlying `Label` objects.
	func splitAfter(tag: NLTag) -> [Labels] {
		if byTag[tag] == nil {
			return [self]
		}

		var labelsArray = [Labels]()

		var labelsForCurrentPart = Labels()
		for label in byIndex {
			labelsForCurrentPart.addLabel(label)
			if label.tag == tag && labelsForCurrentPart.hasLabels() {
				labelsArray.append(labelsForCurrentPart)
				labelsForCurrentPart = Labels()
			}
		}

		return labelsArray
	}

	/// Right after each instance of the specified tags, create a new `Labels` object and add it to an array that will be returned.
	/// This function guarantees that every `Labels` object in the returned array will contain at least one `Label`.
	/// This function preserves ordering of underlying `Label` objects.
	func splitAfter(tags: Set<NLTag>) -> [Labels] {
		if !haveAtLeastOneTagFrom(tags) {
			return [self]
		}

		var labelsArray = [Labels]()

		var labelsForCurrentPart = Labels()
		for label in byIndex {
			labelsForCurrentPart.addLabel(label)
			if tags.contains(label.tag) && labelsForCurrentPart.hasLabels() {
				labelsArray.append(labelsForCurrentPart)
				labelsForCurrentPart = Labels()
			}
		}

		return labelsArray
	}

	/// Looks for the nearest `Label` with a specific tag to a given index.
	/// If no `Label` with the specified tag exists, returns nil.
	/// If the `Label` at the given index has the specified tag, it will be returned.
	/// In the case of a tie, both of the closest labels will be returned with the one having a lower index being first.
	func findNearestLabelWith(tag: NLTag, to index: Int) -> [Label]? {
		if byTag[tag] == nil {
			return nil
		}

		// put this here instead of starting for loop at 0 to avoid double adding same Label if match at given index
		if byIndex[index].tag == tag {
			return [byIndex[index]]
		}

		var closestLabels = [Label]()
		for i in 1..<byIndex.count {
			if index - i > 0 { // protect against index out of bounds
				if byIndex[index - i].tag == tag {
					closestLabels.append(byIndex[index - i])
				}
			}
			if index + i < byIndex.count { // protect against index out of bounds
				if byIndex[index + i].tag == tag {
					closestLabels.append(byIndex[index + i])
				}
			}
			if closestLabels.count != 0 {
				break
			}
		}
		return closestLabels
	}

	/// Looks for the nearest `Label` with a specific tag to a given index.
	/// If no `Label` with the specified tag exists, returns nil.
	/// If the `Label` at the given index has the specified tag, it will be returned.
	func findNearestLabelWith(tag: NLTag, before index: Int) -> Label? {
		if byTag[tag] == nil {
			return nil
		}

		while index >= 0 {
			if byIndex[index].tag == tag {
				return byIndex[index]
			}
		}
		return nil // this should NEVER happen but need to make compiler happy
	}

	/// Looks for the nearest `Label` with a specific tag to a given index.
	/// If no `Label` with the specified tag exists, returns nil.
	/// If the `Label` at the given index has the specified tag, it will be returned.
	func findNearestLabelWith(tag: NLTag, after index: Int) -> Label? {
		if byTag[tag] == nil {
			return nil
		}

		while index < byIndex.count {
			if byIndex[index].tag == tag {
				return byIndex[index]
			}
		}
		return nil // this should NEVER happen but need to make comnpiler happy
	}

	func next() -> Labels.Label? {
		if currentIndex == byIndex.count {
			return nil
		}
		let nextLabel = byIndex[currentIndex]
		currentIndex += 1
		return nextLabel
	}

	fileprivate func haveAtLeastOneTagFrom(_ tags: Set<NLTag>) -> Bool {
		var foundTag = false
		for tag in tags {
			if hasLabelFor(tag) {
				foundTag = true
				break
			}
		}
		return foundTag
	}
}
