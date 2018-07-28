//
//  TimeConstraintFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class TimeConstraintFactory {

	public static let allTypes: [TimeConstraint.Type] = [
		StartsBeforeDateOnlyTimeConstraint.self,
		StartsBeforeTimeConstraint.self,
		StartsAfterDateOnlyTimeConstraint.self,
		StartsAfterTimeConstraint.self,
		EndsBeforeDateOnlyTimeConstraint.self,
		EndsBeforeTimeConstraint.self,
		EndsAfterDateOnlyTimeConstraint.self,
		EndsAfterTimeConstraint.self,
		StartsOnDateTimeConstraint.self,
		EndsOnDateTimeConstraint.self,
		StartsOnDayOfWeekTimeConstraint.self,
		EndsOnDayOfWeekTimeConstraint.self,
	]

	public func timeConstraint(_ type: TimeConstraint.Type) -> TimeConstraint {
		return type.init()
	}

	public func defaultTimeConstraint() -> TimeConstraint {
		return StartsBeforeTimeConstraint()
	}
}
