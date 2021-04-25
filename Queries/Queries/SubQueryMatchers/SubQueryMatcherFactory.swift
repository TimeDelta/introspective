//
//  SubQueryMatcherFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
public protocol SubQueryMatcherFactory {
	func withinXCalendarUnitsSubQueryMatcher() -> WithinXCalendarUnitsSubQueryMatcher
	func withinXCalendarUnitsBeforeSubQueryMatcher() -> WithinXCalendarUnitsBeforeSubQueryMatcher
	func withinXCalendarUnitsAfterSubQueryMatcher() -> WithinXCalendarUnitsAfterSubQueryMatcher
	func inSameCalendarUnitSubQueryMatcher() -> InSameCalendarUnitSubQueryMatcher
	func sameDatesSubQueryMatcher() -> SameDatesSubQueryMatcher
	func sameStartDatesSubQueryMatcher() -> SameStartDatesSubQueryMatcher
	func sameEndDatesSubQueryMatcher() -> SameEndDatesSubQueryMatcher
}

public final class SubQueryMatcherFactoryImpl: SubQueryMatcherFactory {
	public static var allMatcherTypes: [SubQueryMatcher.Type] = [
		WithinXCalendarUnitsSubQueryMatcher.self,
		WithinXCalendarUnitsBeforeSubQueryMatcher.self,
		WithinXCalendarUnitsAfterSubQueryMatcher.self,
		InSameCalendarUnitSubQueryMatcher.self,
		SameDatesSubQueryMatcher.self,
		SameStartDatesSubQueryMatcher.self,
		SameEndDatesSubQueryMatcher.self,
	]

	public final func withinXCalendarUnitsSubQueryMatcher() -> WithinXCalendarUnitsSubQueryMatcher {
		WithinXCalendarUnitsSubQueryMatcher()
	}

	public final func withinXCalendarUnitsBeforeSubQueryMatcher() -> WithinXCalendarUnitsBeforeSubQueryMatcher {
		WithinXCalendarUnitsBeforeSubQueryMatcher()
	}

	public final func withinXCalendarUnitsAfterSubQueryMatcher() -> WithinXCalendarUnitsAfterSubQueryMatcher {
		WithinXCalendarUnitsAfterSubQueryMatcher()
	}

	public final func inSameCalendarUnitSubQueryMatcher() -> InSameCalendarUnitSubQueryMatcher {
		InSameCalendarUnitSubQueryMatcher()
	}

	public final func sameDatesSubQueryMatcher() -> SameDatesSubQueryMatcher {
		SameDatesSubQueryMatcher()
	}

	public final func sameStartDatesSubQueryMatcher() -> SameStartDatesSubQueryMatcher {
		SameStartDatesSubQueryMatcher()
	}

	public final func sameEndDatesSubQueryMatcher() -> SameEndDatesSubQueryMatcher {
		SameEndDatesSubQueryMatcher()
	}
}
