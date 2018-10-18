//
//  SameTimeUnitSampleGrouperFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class SameTimeUnitSampleGrouperFunctionalTests: FunctionalTest {

	func testGivenGroupStartDateBySameDay_group_returnsCorrectlyGroupedSamples() {
		// given
		let grouper = SameTimeUnitSampleGrouper(.day)
		let group1Date = Date()
		let group2Date = group1Date + 1.days
		let group3Date = group1Date - 1.days
		let samples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: group1Date, endDate: Date() - 1.days),
			(startDate: group1Date, endDate: Date() + 1.days),
			(startDate: group2Date, endDate: nil),
			(startDate: group2Date, endDate: Date() + 1.days),
			(startDate: group2Date, endDate: Date() - 1.days),
			(startDate: group3Date, endDate: Date() + 1.days),
			(startDate: group3Date, endDate: Date() - 1.days),
		])
		let expectedGroup1Date = DependencyInjector.util.calendarUtil.start(of: .day, in: group1Date)
		let expectedGroup2Date = DependencyInjector.util.calendarUtil.start(of: .day, in: group2Date)
		let expectedGroup3Date = DependencyInjector.util.calendarUtil.start(of: .day, in: group3Date)

		// when
		let groups = grouper.group(samples: samples, by: CommonSampleAttributes.startDate)

		// then
		assertGroupExists(in: groups, withDate: expectedGroup1Date, andSamples: samples[0...1].map({ $0 }))
		assertGroupExists(in: groups, withDate: expectedGroup2Date, andSamples: samples[2...4].map({ $0 }))
		assertGroupExists(in: groups, withDate: expectedGroup3Date, andSamples: samples[5...6].map({ $0 }))
	}

	func testGivenGroupHealthKitStartDateBySameHour_group_returnsCorrectlyGroupedSamples() {
		// given
		let grouper = SameTimeUnitSampleGrouper(.hour)
		let group1Date = Date()
		let group2Date = group1Date + 1.hours
		let group3Date = group1Date - 1.hours
		let samples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: group1Date, endDate: Date() - 1.hours),
			(startDate: group1Date, endDate: Date() + 1.hours),
			(startDate: group2Date, endDate: nil),
			(startDate: group2Date, endDate: Date() + 1.hours),
			(startDate: group2Date, endDate: Date() - 1.hours),
			(startDate: group3Date, endDate: Date() + 1.hours),
			(startDate: group3Date, endDate: Date() - 1.hours),
		])
		let expectedGroup1Date = DependencyInjector.util.calendarUtil.start(of: .hour, in: group1Date)
		let expectedGroup2Date = DependencyInjector.util.calendarUtil.start(of: .hour, in: group2Date)
		let expectedGroup3Date = DependencyInjector.util.calendarUtil.start(of: .hour, in: group3Date)

		// when
		let groups = grouper.group(samples: samples, by: CommonSampleAttributes.healthKitStartDate)

		// then
		assertGroupExists(in: groups, withDate: expectedGroup1Date, andSamples: samples[0...1].map({ $0 }))
		assertGroupExists(in: groups, withDate: expectedGroup2Date, andSamples: samples[2...4].map({ $0 }))
		assertGroupExists(in: groups, withDate: expectedGroup3Date, andSamples: samples[5...6].map({ $0 }))
	}

	func testGivenGroupHealthKitEndDateBySameMinute_group_returnsCorrectlyGroupedSamples() {
		// given
		let grouper = SameTimeUnitSampleGrouper(.minute)
		let group1Date = Date()
		let group2Date = group1Date + 1.minutes
		let group3Date = group1Date - 1.minutes
		let samples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: Date() - 1.minutes, endDate: group1Date),
			(startDate: Date() + 1.minutes, endDate: group1Date),
			(startDate: nil, endDate: group2Date),
			(startDate: Date() + 1.minutes, endDate: group2Date),
			(startDate: Date() - 1.minutes, endDate: group2Date),
			(startDate: Date() + 1.minutes, endDate: group3Date),
			(startDate: Date() - 1.minutes, endDate: group3Date),
		])
		let expectedGroup1Date = DependencyInjector.util.calendarUtil.start(of: .minute, in: group1Date)
		let expectedGroup2Date = DependencyInjector.util.calendarUtil.start(of: .minute, in: group2Date)
		let expectedGroup3Date = DependencyInjector.util.calendarUtil.start(of: .minute, in: group3Date)

		// when
		let groups = grouper.group(samples: samples, by: CommonSampleAttributes.healthKitEndDate)

		// then
		assertGroupExists(in: groups, withDate: expectedGroup1Date, andSamples: samples[0...1].map({ $0 }))
		assertGroupExists(in: groups, withDate: expectedGroup2Date, andSamples: samples[2...4].map({ $0 }))
		assertGroupExists(in: groups, withDate: expectedGroup3Date, andSamples: samples[5...6].map({ $0 }))
	}

	private final func assertGroupExists(in groups: [(Any, [Sample])], withDate date: Date, andSamples samples: [Sample]) {
		let group = groups.first(where: { group in return group.0 as? Date == date })
		XCTAssertNotNil(group, "Missing group with date: \(date)")
		if let group = group {
			XCTAssertEqual(group.1.count, samples.count)
			let unexpectecdSamples = group.1.filter({ sample in !samples.contains(where: { $0.equalTo(sample) }) })
			XCTAssert(unexpectecdSamples.count == 0, "\(unexpectecdSamples.count) unexpected Samples: \(unexpectecdSamples.debugDescription)")
			let missingSamples = samples[0...1].filter({ expectedSample in return !group.1.contains(where: { $0.equalTo(expectedSample) }) })
			XCTAssert(missingSamples.count == 0, "Missing Samples for \(date.description): \(missingSamples.debugDescription)")
		}
	}
}
