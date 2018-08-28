//
//  SearchUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol SearchUtil {
	func binarySearch<T:Comparable>(for targetItem: T, in items: Array<T>) -> Int?
	func binarySearch<T>(for targetItem: T, in items: Array<T>, compare: (T, T) -> ComparisonResult) -> Int?
	func closestItem<T>(to targetItem: T, in items: Array<T>, distance: (T, T) -> Int) -> T
}

public class SearchUtilImpl: SearchUtil {

	/// - Precondition: input array is sorted in ascending order.
	public func binarySearch<T: Comparable>(for targetItem: T, in items: Array<T>) -> Int? {
		if items.count == 0 {
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
	public func binarySearch<T>(for targetItem: T, in items: Array<T>, compare: (T, T) -> ComparisonResult) -> Int? {
		if items.count == 0 {
			return nil
		}

		var lowerIndex = 0
		var upperIndex = items.count - 1

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

	/// - Precondition: input array has at least one element.
	public func closestItem<T>(to targetItem: T, in items: Array<T>, distance: (T, T) -> Int) -> T {
		precondition(items.count > 0, "Precondition violated: input array must have at least one element")

		return items.sorted { (item1: T, item2: T) -> Bool in
			return distance(item1, targetItem) < distance(item2, targetItem)
		}[0]
	}
}
