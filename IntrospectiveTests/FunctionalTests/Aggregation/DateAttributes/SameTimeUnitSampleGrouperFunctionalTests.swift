//
//  SameTimeUnitSampleGrouperFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftDate
@testable import Introspective

final class SameTimeUnitSampleGrouperFunctionalTests: FunctionalTest {

	// MARK: - group

	func testGivenGroupStartDateBySameDay_group_returnsCorrectlyGroupedSamples() throws {
		// given
		let grouper = SameTimeUnitSampleGrouper(attributes: [], .day, CommonSampleAttributes.startDate)
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
		let expectedGroup1Date = DependencyInjector.util.calendar.start(of: .day, in: group1Date)
		let expectedGroup2Date = DependencyInjector.util.calendar.start(of: .day, in: group2Date)
		let expectedGroup3Date = DependencyInjector.util.calendar.start(of: .day, in: group3Date)

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(groups, hasGroup(forValue: expectedGroup1Date, withSamples: samples[0...1].map({ $0 })))
		assertThat(groups, hasGroup(forValue: expectedGroup2Date, withSamples: samples[2...4].map({ $0 })))
		assertThat(groups, hasGroup(forValue: expectedGroup3Date, withSamples: samples[5...6].map({ $0 })))
	}

	func testGivenGroupHealthKitStartDateBySameHour_group_returnsCorrectlyGroupedSamples() throws {
		// given
		let grouper = SameTimeUnitSampleGrouper(attributes: [], .hour, CommonSampleAttributes.healthKitStartDate)
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
		let expectedGroup1Date = DependencyInjector.util.calendar.start(of: .hour, in: group1Date)
		let expectedGroup2Date = DependencyInjector.util.calendar.start(of: .hour, in: group2Date)
		let expectedGroup3Date = DependencyInjector.util.calendar.start(of: .hour, in: group3Date)

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(groups, hasGroup(forValue: expectedGroup1Date, withSamples: samples[0...1].map({ $0 })))
		assertThat(groups, hasGroup(forValue: expectedGroup2Date, withSamples: samples[2...4].map({ $0 })))
		assertThat(groups, hasGroup(forValue: expectedGroup3Date, withSamples: samples[5...6].map({ $0 })))
	}

	func testGivenGroupHealthKitEndDateBySameMinute_group_returnsCorrectlyGroupedSamples() throws {
		// given
		let grouper = SameTimeUnitSampleGrouper(attributes: [], .minute, CommonSampleAttributes.healthKitEndDate)
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
		let expectedGroup1Date = DependencyInjector.util.calendar.start(of: .minute, in: group1Date)
		let expectedGroup2Date = DependencyInjector.util.calendar.start(of: .minute, in: group2Date)
		let expectedGroup3Date = DependencyInjector.util.calendar.start(of: .minute, in: group3Date)

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(groups, hasGroup(forValue: expectedGroup1Date, withSamples: samples[0...1].map({ $0 })))
		assertThat(groups, hasGroup(forValue: expectedGroup2Date, withSamples: samples[2...4].map({ $0 })))
		assertThat(groups, hasGroup(forValue: expectedGroup3Date, withSamples: samples[5...6].map({ $0 })))
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "text")
		let grouper = SameTimeUnitSampleGrouper(attributes: [], .minute)

		// when
		XCTAssertThrowsError(try grouper.value(of: unknownAttribute)) { error in
			// then
			assertThat(error, instanceOf(UnknownAttributeError.self))
		}
	}

	func testGivenTimeUnitAttribute_valueOf_returnsCorrectValue() throws {
		// given
		let expectedValue = Calendar.Component.hour
		let grouper = SameTimeUnitSampleGrouper(attributes: [], expectedValue)

		// when
		let actualValue = try grouper.value(of: SameTimeUnitSampleGrouper.timeUnitAttribute) as! Calendar.Component

		// then
		XCTAssertEqual(actualValue, expectedValue)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_set_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "text")
		let grouper = SameTimeUnitSampleGrouper(attributes: [], .minute)

		// when
		XCTAssertThrowsError(try grouper.set(attribute: unknownAttribute, to: nil)) { error in
			// then
			assertThat(error, instanceOf(UnknownAttributeError.self))
		}
	}

	func testGivenTimeUnitAttributeWithNonCalendarComponentValue_set_throwsTypeMismatchError() {
		// given
		let grouper = SameTimeUnitSampleGrouper(attributes: [], .minute)
		let value = "not a calendar component"

		// when
		XCTAssertThrowsError(try grouper.set(attribute: SameTimeUnitSampleGrouper.timeUnitAttribute, to: value)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	func testGivenTimeUnitAttributeWithCalendarComponentValue_set_correctlySetsValue() throws {
		// given
		let grouper = SameTimeUnitSampleGrouper(attributes: [], .minute)
		let expectedValue = Calendar.Component.day

		// when
		try grouper.set(attribute: SameTimeUnitSampleGrouper.timeUnitAttribute, to: expectedValue)

		// then
		XCTAssertEqual(grouper.timeUnit, expectedValue)
	}
}
