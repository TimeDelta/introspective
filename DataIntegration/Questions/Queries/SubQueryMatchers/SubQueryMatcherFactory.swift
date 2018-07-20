//
//  SubQueryMatcherFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SubQueryMatcherFactory {

	public static var allMatchers: [SubQueryMatcher.Type] = [
		WithinXCalendarUnitsSubQueryMatcher.self,
		InSameCalendarUnitSubQueryMatcher.self,
		SameDatesSubQueryMatcher.self,
		SameStartDatesSubQueryMatcher.self,
		SameEndDatesSubQueryMatcher.self,
	]

	public func withinXCalendarUnitsSubQueryMatcher() -> WithinXCalendarUnitsSubQueryMatcher {
		return WithinXCalendarUnitsSubQueryMatcher()
	}

	public func inSameCalendarUnitSubQueryMatcher() -> InSameCalendarUnitSubQueryMatcher {
		return InSameCalendarUnitSubQueryMatcher()
	}

	public func sameDatesSubQueryMatcher() -> SameDatesSubQueryMatcher {
		return SameDatesSubQueryMatcher()
	}

	public func sameStartDatesSubQueryMatcher() -> SameStartDatesSubQueryMatcher {
		return SameStartDatesSubQueryMatcher()
	}

	public func sameEndDatesSubQueryMatcher() -> SameEndDatesSubQueryMatcher {
		return SameEndDatesSubQueryMatcher()
	}
}
