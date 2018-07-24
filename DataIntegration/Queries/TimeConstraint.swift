//
//  TimeConstraint.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public class TimeConstraint: NSObject {

	public enum ConstraintType: CustomStringConvertible {
		case before
		case after
		case on

		public static var allTypes: [ConstraintType] {
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

		public static var allTypes: [StartOrEnd] {
			return [start, end]
		}

		public var description: String {
			switch(self) {
				case .start: return "Starts"
				case .end: return "Ends"
			}
		}
	}

	override public var description: String {
		var text = useStartOrEndDate.description + " " + constraintType.description + " "
		switch (constraintType) {
			case .after, .before:
				if specificDate != nil {
					text += DependencyInjector.util.calendarUtil.string(for: specificDate!)
				} else {
					os_log("No date for time constraint being displayed", type: .error)
				}
				break
			case .on:
				if !daysOfWeek.isEmpty {
					var daysOfWeekText = ""
					for dayOfWeek in daysOfWeek {
						daysOfWeekText += dayOfWeek.abbreviation + ", "
					}
					daysOfWeekText.removeLast()
					daysOfWeekText.removeLast()
					text += daysOfWeekText
				} else if specificDate != nil {
					text += DependencyInjector.util.calendarUtil.string(for: specificDate!, inFormat: "YYYY-MM-dd")
				} else {
					os_log("No date or days of week for time constraint being displayed", type: .error)
				}
				break
		}
		return text
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
