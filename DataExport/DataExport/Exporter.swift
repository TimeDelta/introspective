//
//  Exporter.swift
//  Introspective
//
//  Created by Bryan Nova on 4/17/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
public protocol Exporter {
	var dataTypePluralName: String { get }
	var isPaused: Bool { get }
	var isCancelled: Bool { get }
	var url: URL { get }

	func exportData() throws

	/// - Returns: A value between 0 and 1
	func percentComplete() -> Double

	/// Once cancelled, an export cannot be resumed.
	func cancel()
	func pause()
	func resume() throws

	func equalTo(_ other: Exporter) -> Bool
}

public extension Exporter {
	func equalTo(_ other: Exporter) -> Bool {
		guard type(of: self) == type(of: other) else { return false }
		return withUnsafePointer(to: self) { me in
			withUnsafePointer(to: other) { them in
				me == them
			}
		}
	}
}
