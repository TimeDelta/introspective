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

	// TODO - might need to allow a Label to have multiple tags with activity parsing, location parsing, etc.
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

	public enum ErrorTypes: Error {
		case IndexOutOfRange
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
			byIndex[byIndex.count - 1] = lastLabel!
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

	/// Return true if a label with the same range, tag and token has been previously added otherwise false.
	public func labelHasBeenAdded(_ label: Label) -> Bool {
		if count > 0 {
			var index = 0
			while index < count && byIndex[index].tokenRange != label.tokenRange && byIndex[index].token != label.token {
				index += 1
			}

			return index < count
		}
		return false
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
		if self.isEmpty {
			return []
		}
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
		if self.isEmpty {
			return []
		}
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
		if !labelsForCurrentPart.isEmpty {
			labelsArray.append(labelsForCurrentPart)
		}

		return labelsArray
	}

	/// Looks for the nearest `Label` with a specific tag to a given index.
	/// If no `Label` with the specified tag exists, returns nil.
	/// If the `Label` at the given index has the specified tag, it will be returned.
	/// In the case of a tie, both of the closest labels will be returned with the one having a lower index being first.
	public func findNearestLabelWith(tag: NLTag, to index: Int) throws -> [Label]? {
		if index >= count || index < 0 {
			throw ErrorTypes.IndexOutOfRange
		}
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
			if index - i >= 0 { // protect against index out of bounds
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
	public func findNearestLabelWith(tag: NLTag, before index: Int) throws -> Label? {
		if index >= count || index < 0 {
			throw ErrorTypes.IndexOutOfRange
		}
		if byTag[tag] == nil {
			return nil
		}

		var i = index
		while i >= 0 {
			if byIndex[i].tag == tag {
				return byIndex[i]
			}
			i -= 1
		}
		return nil
	}

	/// Looks for the nearest `Label` with a specific tag to a given index.
	/// If no `Label` with the specified tag exists, returns nil.
	/// If the `Label` at the given index has the specified tag, it will be returned.
	public func findNearestLabelWith(tag: NLTag, after index: Int) throws -> Label? {
		if index >= count || index < 0 {
			throw ErrorTypes.IndexOutOfRange
		}
		if byTag[tag] == nil {
			return nil
		}

		var i = index
		while i < byIndex.count {
			if byIndex[i].tag == tag {
				return byIndex[i]
			}
			i += 1
		}
		return nil
	}

	/// Mark the `Label` in the given range as the specified `NLTag` type only if it is currently a `Tags.none` type.
	/// If the `Label` in the given range is not currently a `Tags.none` type, this method will do nothing.
	/// If no `Label` has an exact match for the given token range, this method will do nothing.
	public func ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag) {
		if count > 0 {
			var index = 0
			while index < count && byIndex[index].tokenRange != range {
				index += 1
			}

			if index < count && byIndex[index].tag == Tags.none {
				byIndex[index].tag = asTag
			}
		}
	}

	/// Get the shortest distance from a `Label` tagged as `between` to a `Label` tagged as `and`.
	/// If the two tags given are equal to each other, this function will not use the same `Label` for both and return a distance of 0.
	/// If one or both of the specified tags have not been added, this will return `Int.max`.
	/// This method does not require that the tags appear in the same order they were given.
	public func shortestDistance(between tag1: NLTag, and tag2: NLTag) -> Int {
		var shortestDistance = Int.max
		var lastIndex = -1
		var lastTagWasTag1: Bool? = nil
		for index in 0 ..< byIndex.count {
			let currentTag = byIndex[index].tag
			if lastTagWasTag1 != nil {
				if (currentTag == tag1 && (!lastTagWasTag1! || tag1 == tag2)) || (currentTag == tag2 && (lastTagWasTag1! || tag1 == tag2)) {
					let currentDistance = index - lastIndex
					if currentDistance < shortestDistance {
						shortestDistance = currentDistance
					}
				}
			}
			if currentTag == tag1 {
				lastTagWasTag1 = true
				lastIndex = index
			} else if currentTag == tag2 {
				lastTagWasTag1 = false
				lastIndex = index
			}
		}
		return shortestDistance
	}

	public func shortestDistance(from: Label, toLabelWith: NLTag) -> Int? {
		var shortestDistance = Int.max
		if !labelHasBeenAdded(from) {
			return nil
		}

		// TODO finish this method

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
