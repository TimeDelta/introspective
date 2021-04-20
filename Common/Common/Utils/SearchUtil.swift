//
//  SearchUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
public protocol SearchUtil {
	/// - Precondition: input array is sorted in ascending order.
	func binarySearch<T: Comparable>(for targetItem: T, in items: [T]) -> Int?
	/// - Precondition: input array is sorted in ascending order based on the given compare function.
	/// - Returns: `nil` if target item not found
	func binarySearch<T>(for targetItem: T, in items: [T], compare: (T, T) -> ComparisonResult) -> Int?
	/// - Precondition: input array is sorted in ascending order based on the given distance function (distance can be negative and this will find the closest to 0).
	/// - Returns: `nil` if the input array is empty, otherwise the index of the item with closest distance
	func closestItem<T>(to targetItem: T, in items: [T], distance: (T, T) -> Int) -> T
	/// - Precondition: input array is not empty and is sorted in ascending order based on the given distance function (distance can be negative and this will find the closest to 0).
	/// - Returns: the index of the item with closest distance.
	func binarySearchForClosest<T>(to targetItem: T, in items: [T], distance: (T, T) -> Int) -> Int
}

public final class SearchUtilImpl: SearchUtil {
	/// - Precondition: input array is sorted in ascending order.
	public final func binarySearch<T: Comparable>(for targetItem: T, in items: [T]) -> Int? {
		if items.isEmpty {
			return nil
		}

		var lowerIndex = 0
		var upperIndex = items.count - 1

		while true {
			let currentIndex = (lowerIndex + upperIndex) / 2
			if items[currentIndex] == targetItem {
				return currentIndex
			}

			if lowerIndex > upperIndex {
				return nil
			}

			if items[currentIndex] > targetItem {
				upperIndex = currentIndex - 1
			} else {
				lowerIndex = currentIndex + 1
			}
		}
	}

	/// - Precondition: input array is sorted in ascending order based on the given compare function.
	/// - Returns: `nil` if target item not found
	public final func binarySearch<T>(for targetItem: T, in items: [T], compare: (T, T) -> ComparisonResult) -> Int? {
		if items.isEmpty {
			return nil
		}

		var lowerIndex = 0
		var upperIndex = items.count - 1

		// use iterative version instead of recursive to avoid stack overflow
		while true {
			let currentIndex = (lowerIndex + upperIndex) / 2
			let comparison = compare(items[currentIndex], targetItem)
			if comparison == .orderedSame {
				return currentIndex
			}

			if lowerIndex > upperIndex {
				return nil
			}

			if comparison == .orderedDescending {
				upperIndex = currentIndex - 1
			} else {
				lowerIndex = currentIndex + 1
			}
		}
	}

	/// - Precondition: input array is not empty and is sorted in ascending order based on the given distance function (distance can be negative and this will find the closest to 0).
	/// - Returns: the index of the item with closest distance.
	public final func binarySearchForClosest<T>(to targetItem: T, in items: [T], distance: (T, T) -> Int) -> Int {
		precondition(items.count > 0)

		var lowerIndex = 0
		var upperIndex = items.count - 1

		var closestDistance = Int.max
		var closestDistanceIndex = 0

		// use iterative version instead of recursive to avoid stack overflow
		while true {
			let currentIndex = (lowerIndex + upperIndex) / 2
			let distance = distance(items[currentIndex], targetItem)

			if distance == 0 {
				return currentIndex
			}

			if abs(distance) < abs(closestDistance) {
				closestDistance = distance
				closestDistanceIndex = currentIndex
			}

			if lowerIndex > upperIndex {
				return closestDistanceIndex
			}

			if distance > 0 {
				upperIndex = currentIndex - 1
			} else {
				lowerIndex = currentIndex + 1
			}
		}
	}

	/// - Precondition: input array has at least one element.
	public final func closestItem<T>(to targetItem: T, in items: [T], distance: (T, T) -> Int) -> T {
		precondition(!items.isEmpty, "Precondition violated: input array must have at least one element")

		return items.sorted { (item1: T, item2: T) -> Bool in
			distance(item1, targetItem) < distance(item2, targetItem)
		}[0]
	}
}
