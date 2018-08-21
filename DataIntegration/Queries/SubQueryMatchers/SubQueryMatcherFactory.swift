//
//  SubQueryMatcherFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol SubQueryMatcherFactory {

	func withinXCalendarUnitsSubQueryMatcher() -> WithinXCalendarUnitsSubQueryMatcher
	func inSameCalendarUnitSubQueryMatcher() -> InSameCalendarUnitSubQueryMatcher
	func sameDatesSubQueryMatcher() -> SameDatesSubQueryMatcher
	func sameStartDatesSubQueryMatcher() -> SameStartDatesSubQueryMatcher
	func sameEndDatesSubQueryMatcher() -> SameEndDatesSubQueryMatcher
}

public class SubQueryMatcherFactoryImpl: SubQueryMatcherFactory {

	public static var allMatcherTypes: [SubQueryMatcher.Type] = [
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
