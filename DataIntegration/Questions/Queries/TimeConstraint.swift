//
//  TimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public struct TimeConstraint {

	public enum ConstraintType: CustomStringConvertible {
		case before
		case after
		case on

		public static func types() -> [ConstraintType] {
			return [before, after, on]
		}

		public var description: String {
			switch(self) {
				case .before: return "before"
				case .after: return "after"
				case .on: return "on"
			}
		}
	}

	public enum StartOrEnd: CustomStringConvertible {
		case start
		case end

		public var description: String {
			switch(self) {
				case .start: return "Starts"
				case .end: return "Ends"
			}
		}
	}

	public var useStartOrEndDate: StartOrEnd = .start
	public var daysOfWeek: Set<DayOfWeek> = Set<DayOfWeek>()
	public var specificDate: Date?
	public var constraintType: ConstraintType = .on

	public func isValid() -> Bool {
		return (constraintType == .on && !daysOfWeek.isEmpty && specificDate == nil) ||
			(constraintType == .on && daysOfWeek.isEmpty && specificDate != nil) ||
			((constraintType == .before || constraintType == .after) && daysOfWeek.isEmpty && specificDate != nil)
	}
}
