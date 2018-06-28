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

	struct Label: Equatable {
		public fileprivate(set) var tag: NLTag
		public fileprivate(set) var token: String
		public fileprivate(set) var tokenRange: Range<String.Index>

		static func ==(left: Label, right: Label) -> Bool {
			return left.tag == right.tag && left.token == right.token && left.tokenRange == right.tokenRange
		}

		public init(tag: NLTag, token: String, tokenRange: Range<String.Index>) {
			self.tag = tag
			self.token = token
			self.tokenRange = tokenRange
		}
	}

	static func ==(left: Labels, right: Labels) -> Bool {
		if left.count != right.count {
			return false
		}
		for i in 0 ..< left.count {
			if left.byIndex[i] != right.byIndex[i] {
				return false
			}
		}
		return true
	}

	typealias Element = Label

	public var count: Int { get { return byIndex.count } }
	public var isEmpty: Bool { get { return byIndex.isEmpty } }
	public fileprivate(set) var byTag: [NLTag: [Label]]
	public fileprivate(set) var byIndex: [Label]
	fileprivate var currentIteratorIndex: Int
	fileprivate var lastSetVerbIndex: Int

	public override init() {
		byTag = [NLTag: [Label]]()
		byIndex = [Label]()
		currentIteratorIndex = 0
		lastSetVerbIndex = 0
	}

	/// Add the specified `Label` as the next in the underlying sequence.
	/// All consecutive `Label`s with a tag type other than `Tags.none` that have identical tags will be consolidated into one `Label`.
	public func addLabel(_ label: Label) {
		// concatenate identical consecutive tags
		var lastLabel = byIndex.last
		if lastLabel?.tag == label.tag && label.tag != Tags.none {
			lastLabel!.token.append(" " + label.token)
			// TODO - construct new token range
//			lastLabel!.tokenRange = Range(NSRange(lastLabel!.tokenRange.lowerBound...label.tokenRange.upperBound, in: ""))
			var labelsForTag = byTag[lastLabel!.tag]
			labelsForTag!.removeLast()
			labelsForTag!.append(lastLabel!)
			byTag[lastLabel!.tag] = labelsForTag
		} else {
			if byTag[label.tag] == nil {
				byTag[label.tag] = [Label]()
			}
			byTag[label.tag]!.append(label)
			byIndex.append(label)
		}
	}

	/// Return true if at least one `Label` of type tag has been added.
	public func hasLabelFor(_ tag: NLTag) -> Bool {
		return byTag[tag] != nil
	}

	/// Return true if at least one `Label` has been added else false.
	public func hasLabels() -> Bool {
		return !byIndex.isEmpty
	}

	/// Get all `Label`s for each specified tag.
	public func labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label] {
		var labels = [Label]()
		for tag in tags {
			let labelsForCurrentTag = byTag[tag]
			if labelsForCurrentTag != nil {
				labels.append(contentsOf: labelsForCurrentTag!)
			}
		}
		return labels
	}

	/// Get all `Label`s for each specified tag.
	/// This function preserves ordering of underlying `Label` objects.
	public func labelsFor(tags: Set<NLTag>) -> [Label] {
		var labels = [Label]()
		for label in byIndex {
			if tags.contains(label.tag) {
				labels.append(label)
			}
		}
		return labels
	}

	/// Right before each instance of the specified tag, create a new `Labels` object and add it to an array that will be returned.
	/// This function guarantees that every `Labels` object in the returned array will contain at least one `Label`.
	/// This function preserves ordering of underlying `Label` objects.
	public func splitBefore(tag: NLTag) -> [Labels] {
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
		labelsArray.append(labelsForCurrentPart)

		return labelsArray
	}

	/// Right before each instance of the specified tags, create a new `Labels` object and add it to an array that will be returned.
	/// This function guarantees that every `Labels` object in the returned array will contain at least one `Label`.
	/// This function preserves ordering of underlying `Label` objects.
	public func splitBefore(tags: Set<NLTag>) -> [Labels] {
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
		if !labelsForCurrentPart.isEmpty {
			labelsArray.append(labelsForCurrentPart)
		}

		return labelsArray
	}

	/// Right after each instance of the specified tag, create a new `Labels` object and add it to an array that will be returned.
	/// This function guarantees that every `Labels` object in the returned array will contain at least one `Label`.
	/// This function preserves ordering of underlying `Label` objects.
	public func splitAfter(tag: NLTag) -> [Labels] {
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
		if !labelsForCurrentPart.isEmpty {
			labelsArray.append(labelsForCurrentPart)
		}

		return labelsArray
	}

	/// Right after each instance of the specified tags, create a new `Labels` object and add it to an array that will be returned.
	/// This function guarantees that every `Labels` object in the returned array will contain at least one `Label`.
	/// This function preserves ordering of underlying `Label` objects.
	public func splitAfter(tags: Set<NLTag>) -> [Labels] {
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
		labelsArray.append(labelsForCurrentPart)

		return labelsArray
	}

	/// Looks for the nearest `Label` with a specific tag to a given index.
	/// If no `Label` with the specified tag exists, returns nil.
	/// If the `Label` at the given index has the specified tag, it will be returned.
	/// In the case of a tie, both of the closest labels will be returned with the one having a lower index being first.
	public func findNearestLabelWith(tag: NLTag, to index: Int) -> [Label]? {
		if byTag[tag] == nil {
			return nil
		}
		// at this point, it is guaranteed that the returned Label array will not be empty

		// put this here instead of starting for loop at 0 to avoid double adding same Label if match at given index
		if byIndex[index].tag == tag {
			return [byIndex[index]]
		}

		var closestLabels = [Label]()
		for i in 1 ..< byIndex.count {
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
	public func findNearestLabelWith(tag: NLTag, before index: Int) -> Label? {
		if byTag[tag] == nil {
			return nil
		}

		while index >= 0 {
			if byIndex[index].tag == tag {
				return byIndex[index]
			}
		}
		return nil
	}

	/// Looks for the nearest `Label` with a specific tag to a given index.
	/// If no `Label` with the specified tag exists, returns nil.
	/// If the `Label` at the given index has the specified tag, it will be returned.
	public func findNearestLabelWith(tag: NLTag, after index: Int) -> Label? {
		if byTag[tag] == nil {
			return nil
		}

		while index < byIndex.count {
			if byIndex[index].tag == tag {
				return byIndex[index]
			}
		}
		return nil
	}

	/// Mark the `Label` in the given range as the specified `NLTag` type only if it is currently a `Tags.none` type.
	/// If the `Label` in the given range is not currently a `Tags.none` type, this method will do nothing.
	/// If no `Label` has an exact match for the given token range, this method will do nothing.
	public func markTokenIn(range: Range<String.Index>, asTag: NLTag) {
		var index = 0
		while byIndex[index].tokenRange != range {
			index += 1
		}

		byIndex[index].tag = asTag
	}

	/// Get the shortest distance from a `Label` tagged as `between` to a `Label` tagged as `and`.
	/// If the two tags given are equal to each other, this function will return 0.
	public func shortestDistance(between tag1: NLTag, and tag2: NLTag) -> Int {
		var shortestDistance = Int.max
		var tag1Index = -1
		for index in 0 ..< byIndex.count {
			if byIndex[index].tag == tag1 {
				tag1Index = index
			}
			if byIndex[index].tag == tag2 && tag1Index != -1 {
				let currentDistance = index - tag1Index
				if currentDistance < shortestDistance {
					shortestDistance = currentDistance
				}
			}
		}
		return shortestDistance
	}

	public func next() -> Labels.Label? {
		if currentIteratorIndex == byIndex.count {
			return nil
		}
		let nextLabel = byIndex[currentIteratorIndex]
		currentIteratorIndex += 1
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
