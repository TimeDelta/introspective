//
//  SampleUtilUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import HealthKit
import SwiftyMocky
import SwiftDate
@testable import Introspective

class SampleUtilUnitTests: UnitTest {

	fileprivate var util: SampleUtilImpl!

	override func setUp() {
		super.setUp()
		util = SampleUtilImpl()
	}

	func testGivenEmptyDayOfWeekSet_sampleOccursOnOneOf_returnsTrue() {
		// given
		let sample = SampleCreatorTestUtil.createSample()

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: Set<DayOfWeek>())

		// then
		XCTAssert(onOneOf)
	}

	func testGivenEveryDayOfWeekExceptOneForDate_dateIsOnOneOf_returnsFalse() {
		// given
		let date = DateInRegion().dateAt(.nextWeekday(.saturday)).date
		let sample = SampleCreatorTestUtil.createSample(startDate: date)
		let daysOfWeek = Set<DayOfWeek>([
			DayOfWeek.Sunday,
			DayOfWeek.Monday,
			DayOfWeek.Tuesday,
			DayOfWeek.Wednesday,
			DayOfWeek.Thursday,
			DayOfWeek.Friday,
		])
		Given(mockCalendarUtil, .date(date: .value(date), isOnOneOf: .value(daysOfWeek), willReturn: false))

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: daysOfWeek)

		// then
		XCTAssertFalse(onOneOf)
	}

	func testGivenEveryDayOfWeek_dateIsOnOneOf_returnsTrue() {
		// given
		let sample = SampleCreatorTestUtil.createSample(startDate: Date())
		let daysOfWeek = Set<DayOfWeek>(DayOfWeek.allDays)
		Given(mockCalendarUtil, .date(date: .any(Date.self), isOnOneOf: .value(daysOfWeek), willReturn: true))

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: daysOfWeek)

		// then
		XCTAssert(onOneOf)
	}

	func testGivenOnlyDayOfWeekOnWhichDateOccurs_dateIsOnOneOf_returnsTrue() {
		// given
		let date = DateInRegion().dateAt(.nextWeekday(.saturday)).date
		let sample = SampleCreatorTestUtil.createSample(startDate: date)
		let daysOfWeek = Set<DayOfWeek>([DayOfWeek.Saturday])
		Given(mockCalendarUtil, .date(date: .any(Date.self), isOnOneOf: .value(daysOfWeek), willReturn: true))

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: daysOfWeek)

		// then
		XCTAssert(onOneOf)
	}

	func testGivenSampleWithStartDateOnDifferentDayAndEndDateOnOneOfTheDays_dateIsOnOneOf_returnsTrue() {
		// given
		let startDate = Date()
		let endDate = DateInRegion().dateAt(.nextWeekday(.saturday)).date
		let sample = SampleCreatorTestUtil.createSample(startDate: startDate, endDate: endDate)
		let daysOfWeek = Set<DayOfWeek>([DayOfWeek.Saturday])
		Given(mockCalendarUtil, .date(date: .value(startDate), isOnOneOf: .value(daysOfWeek), willReturn: false))
		Given(mockCalendarUtil, .date(date: .value(endDate), isOnOneOf: .value(daysOfWeek), willReturn: true))

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: daysOfWeek)

		// then
		XCTAssert(onOneOf)
	}

	func testGivenSampleWithStartAndEndDatesOnDifferentDays_dateIsOnOneOf_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(startDate: Date(), endDate: Date())
		let daysOfWeek = Set<DayOfWeek>(DayOfWeek.allDays)
		Given(mockCalendarUtil, .date(date: .any(Date.self), isOnOneOf: .value(daysOfWeek), willReturn: false))

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: daysOfWeek)

		// then
		XCTAssertFalse(onOneOf)
	}

	func testGivenEmptySamplesArray_convertOneDateSamplesToTwoDateSamples_returnsEmptyArray() {
		// given
		let samples = [Sample]()

		// when
		let convertedSamples = util.convertOneDateSamplesToTwoDateSamples(
			samples,
			samplesShouldNotBeJoined: { (_, _) -> Bool in
				return true
			},
			joinSamples: { (_ , _, _) -> Sample in
				return SampleCreatorTestUtil.createSample()
			}
		)

		// then
		XCTAssert(convertedSamples.count == 0, "Found \(convertedSamples.count) samples")
	}

	func testGivenTwoSamplesThatShouldBeCombined_convertOneDateSamplesToTwoDateSamples_combinesThemWithCorrectDates() {
		// given
		let expectedStartDate = Date()
		let expectedEndDate = expectedStartDate + 1.years
		let samples = SampleCreatorTestUtil.createSamples(withDates: [expectedStartDate, expectedEndDate])
		Given(mockCalendarUtil, .compare(date1: .value(expectedStartDate), date2: .value(expectedEndDate), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(expectedEndDate), date2: .value(expectedStartDate), willReturn: .orderedDescending))

		// when
		let convertedSamples = util.convertOneDateSamplesToTwoDateSamples(
			samples,
			samplesShouldNotBeJoined: { (_, _) -> Bool in
				return false
			},
			joinSamples: { (_, start: Date, end: Date) -> Sample in
				return SampleCreatorTestUtil.createSample(startDate: start, endDate: end)
			}
		)

		// then
		XCTAssert(convertedSamples.count == 1, "Found \(convertedSamples.count) samples")
		XCTAssert(convertedSamples[0].dates()[.start] == expectedStartDate)
		XCTAssert(convertedSamples[0].dates()[.end] == expectedEndDate)
	}

	func testGivenTwoSamplesThatShouldNotBeCombined_convertOneDateSamplesToTwoDateSamples_doesNotCombineThem() {
		// given
		let date1 = Date()
		let date2 = Date() + 1.years
		let samples = SampleCreatorTestUtil.createSamples(withDates: [date1, date2])
		Given(mockCalendarUtil, .compare(date1: .value(date1), date2: .value(date2), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(date2), date2: .value(date1), willReturn: .orderedDescending))

		// when
		let convertedSamples = util.convertOneDateSamplesToTwoDateSamples(
			samples,
			samplesShouldNotBeJoined: { (_, _) -> Bool in
				return true
			},
			joinSamples: { (_, start: Date, end: Date) -> Sample in
				return SampleCreatorTestUtil.createSample(startDate: start, endDate: end)
			}
		)

		// then
		XCTAssert(convertedSamples.count == 2, "Found \(convertedSamples.count) samples")
		if convertedSamples.count > 0 {
			let startDate = convertedSamples[0].dates()[.start]!
			let endDate = convertedSamples[0].dates()[.end]!
			XCTAssert(startDate == date1, "Expected \(date1.toString()) but got \(startDate.toString())")
			XCTAssert(endDate == date1, "Expected \(date1.toString()) but got \(endDate.toString())")
		}
		if convertedSamples.count > 1 {
			let startDate = convertedSamples[1].dates()[.start]!
			let endDate = convertedSamples[1].dates()[.end]!
			XCTAssert(startDate == date2, "Expected \(date2.toString()) but got \(startDate.toString())")
			XCTAssert(endDate == date2, "Expected \(date2.toString()) but got \(endDate.toString())")
		}
	}

	func testGivenManySamples_convertOneDateSamplesToTwoDateSamples_correctlyCombinesThem() {
		// given
		let date1 = Date()
		let date2 = Date() + 5.hours
		let date3 = Date() + 2.days
		let date4 = Date() + 1.years
		let samples = SampleCreatorTestUtil.createSamples(withDates: [date1, date2, date3, date4])
		Given(mockCalendarUtil, .compare(date1: .value(date1), date2: .value(date2), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(date1), date2: .value(date3), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(date1), date2: .value(date4), willReturn: .orderedAscending))

		Given(mockCalendarUtil, .compare(date1: .value(date2), date2: .value(date1), willReturn: .orderedDescending))
		Given(mockCalendarUtil, .compare(date1: .value(date2), date2: .value(date3), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(date2), date2: .value(date4), willReturn: .orderedAscending))

		Given(mockCalendarUtil, .compare(date1: .value(date3), date2: .value(date1), willReturn: .orderedDescending))
		Given(mockCalendarUtil, .compare(date1: .value(date3), date2: .value(date2), willReturn: .orderedDescending))
		Given(mockCalendarUtil, .compare(date1: .value(date3), date2: .value(date4), willReturn: .orderedAscending))

		Given(mockCalendarUtil, .compare(date1: .value(date4), date2: .value(date1), willReturn: .orderedDescending))
		Given(mockCalendarUtil, .compare(date1: .value(date4), date2: .value(date2), willReturn: .orderedDescending))
		Given(mockCalendarUtil, .compare(date1: .value(date4), date2: .value(date3), willReturn: .orderedDescending))

		// when
		let convertedSamples = util.convertOneDateSamplesToTwoDateSamples(
			samples,
			samplesShouldNotBeJoined: { (s1, s2) -> Bool in
				// combine samples 1, 2 and 3
				return !s1.equalTo(samples[0]) && !s1.equalTo(samples[1])
			},
			joinSamples: { (_, start: Date, end: Date) -> Sample in
				return SampleCreatorTestUtil.createSample(startDate: start, endDate: end)
			}
		)

		XCTAssert(convertedSamples.count == 2, "Found \(convertedSamples.count) samples")
		if convertedSamples.count > 0 {
			let startDate = convertedSamples[0].dates()[.start]!
			let endDate = convertedSamples[0].dates()[.end]!
			XCTAssert(startDate == date1, "Expected \(date1.toString()) but got \(startDate.toString())")
			XCTAssert(endDate == date3, "Expected \(date3.toString()) but got \(endDate.toString())")
		}
		if convertedSamples.count > 1 {
			let startDate = convertedSamples[1].dates()[.start]!
			let endDate = convertedSamples[1].dates()[.end]!
			XCTAssert(startDate == date4, "Expected \(date4.toString()) but got \(startDate.toString())")
			XCTAssert(endDate == date4, "Expected \(date4.toString()) but got \(endDate.toString())")
		}
	}

	func testGivenEmptySamplesArray_genericConvertOneDateSamplesToTwoDateSamples_returnsEmptyArray() {
		// given
		let samples = [AnySample]()

		// when
		let convertedSamples = util.convertOneDateSamplesToTwoDateSamples(
			samples,
			samplesShouldNotBeJoined: { (_, _) -> Bool in
				return true
			},
			joinSamples: { (_ , _, _) -> AnySample in
				return SampleCreatorTestUtil.createSample()
			}
		)

		// then
		XCTAssert(convertedSamples.count == 0, "Found \(convertedSamples.count) samples")
	}

	func testGivenTwoSamplesThatShouldBeCombined_genericConvertOneDateSamplesToTwoDateSamples_combinesThemWithCorrectDates() {
		// given
		let expectedStartDate = Date()
		let expectedEndDate = expectedStartDate + 1.years
		let samples = SampleCreatorTestUtil.createSamples(withDates: [expectedStartDate, expectedEndDate])
		Given(mockCalendarUtil, .compare(date1: .value(expectedStartDate), date2: .value(expectedEndDate), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(expectedEndDate), date2: .value(expectedStartDate), willReturn: .orderedDescending))

		// when
		let convertedSamples = util.convertOneDateSamplesToTwoDateSamples(
			samples,
			samplesShouldNotBeJoined: { (_, _) -> Bool in
				return false
			},
			joinSamples: { (_, start: Date, end: Date) -> AnySample in
				return SampleCreatorTestUtil.createSample(startDate: start, endDate: end)
			}
		)

		// then
		XCTAssert(convertedSamples.count == 1, "Found \(convertedSamples.count) samples")
		XCTAssert(convertedSamples[0].dates()[.start] == expectedStartDate)
		XCTAssert(convertedSamples[0].dates()[.end] == expectedEndDate)
	}

	func testGivenTwoSamplesThatShouldNotBeCombined_genericConvertOneDateSamplesToTwoDateSamples_doesNotCombineThem() {
		// given
		let date1 = Date()
		let date2 = Date() + 1.years
		let samples = SampleCreatorTestUtil.createSamples(withDates: [date1, date2])
		Given(mockCalendarUtil, .compare(date1: .value(date1), date2: .value(date2), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(date2), date2: .value(date1), willReturn: .orderedDescending))

		// when
		let convertedSamples = util.convertOneDateSamplesToTwoDateSamples(
			samples,
			samplesShouldNotBeJoined: { (_, _) -> Bool in
				return true
			},
			joinSamples: { (_, start: Date, end: Date) -> AnySample in
				return SampleCreatorTestUtil.createSample(startDate: start, endDate: end)
			}
		)

		// then
		XCTAssert(convertedSamples.count == 2, "Found \(convertedSamples.count) samples")
		if convertedSamples.count > 0 {
			let startDate = convertedSamples[0].dates()[.start]!
			let endDate = convertedSamples[0].dates()[.end]!
			XCTAssert(startDate == date1, "Expected \(date1.toString()) but got \(startDate.toString())")
			XCTAssert(endDate == date1, "Expected \(date1.toString()) but got \(endDate.toString())")
		}
		if convertedSamples.count > 1 {
			let startDate = convertedSamples[1].dates()[.start]!
			let endDate = convertedSamples[1].dates()[.end]!
			XCTAssert(startDate == date2, "Expected \(date2.toString()) but got \(startDate.toString())")
			XCTAssert(endDate == date2, "Expected \(date2.toString()) but got \(endDate.toString())")
		}
	}

	func testGivenManySamples_genericConvertOneDateSamplesToTwoDateSamples_correctlyCombinesThem() {
		// given
		let date1 = Date()
		let date2 = Date() + 5.hours
		let date3 = Date() + 2.days
		let date4 = Date() + 1.years
		let samples = SampleCreatorTestUtil.createSamples(withDates: [date1, date2, date3, date4])
		Given(mockCalendarUtil, .compare(date1: .value(date1), date2: .value(date2), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(date1), date2: .value(date3), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(date1), date2: .value(date4), willReturn: .orderedAscending))

		Given(mockCalendarUtil, .compare(date1: .value(date2), date2: .value(date1), willReturn: .orderedDescending))
		Given(mockCalendarUtil, .compare(date1: .value(date2), date2: .value(date3), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(date2), date2: .value(date4), willReturn: .orderedAscending))

		Given(mockCalendarUtil, .compare(date1: .value(date3), date2: .value(date1), willReturn: .orderedDescending))
		Given(mockCalendarUtil, .compare(date1: .value(date3), date2: .value(date2), willReturn: .orderedDescending))
		Given(mockCalendarUtil, .compare(date1: .value(date3), date2: .value(date4), willReturn: .orderedAscending))

		Given(mockCalendarUtil, .compare(date1: .value(date4), date2: .value(date1), willReturn: .orderedDescending))
		Given(mockCalendarUtil, .compare(date1: .value(date4), date2: .value(date2), willReturn: .orderedDescending))
		Given(mockCalendarUtil, .compare(date1: .value(date4), date2: .value(date3), willReturn: .orderedDescending))

		// when
		let convertedSamples = util.convertOneDateSamplesToTwoDateSamples(
			samples,
			samplesShouldNotBeJoined: { (s1, s2) -> Bool in
				// combine samples 1, 2 and 3
				return !s1.equalTo(samples[0]) && !s1.equalTo(samples[1])
			},
			joinSamples: { (_, start: Date, end: Date) -> AnySample in
				return SampleCreatorTestUtil.createSample(startDate: start, endDate: end)
			}
		)

		XCTAssert(convertedSamples.count == 2, "Found \(convertedSamples.count) samples")
		if convertedSamples.count > 0 {
			let startDate = convertedSamples[0].dates()[.start]!
			let endDate = convertedSamples[0].dates()[.end]!
			XCTAssert(startDate == date1, "Expected \(date1.toString()) but got \(startDate.toString())")
			XCTAssert(endDate == date3, "Expected \(date3.toString()) but got \(endDate.toString())")
		}
		if convertedSamples.count > 1 {
			let startDate = convertedSamples[1].dates()[.start]!
			let endDate = convertedSamples[1].dates()[.end]!
			XCTAssert(startDate == date4, "Expected \(date4.toString()) but got \(startDate.toString())")
			XCTAssert(endDate == date4, "Expected \(date4.toString()) but got \(endDate.toString())")
		}
	}

	func testGivenSameExactSampleTwice_distance_returnsZero() {
		// given
		let sample = SampleCreatorTestUtil.createSample(startDate: Date(), endDate: Date())

		// when
		let distance = util.distance(between: sample, and: sample)

		// then
		XCTAssert(distance == 0, "Distance: \(distance)")
	}

	func testGivenSamplesWithSameStartDatesAndNoEndDates_distance_returnsZero() {
		// given
		let date = Date()
		let sample1 = SampleCreatorTestUtil.createSample(startDate: date)
		let sample2 = SampleCreatorTestUtil.createSample(startDate: date)

		// when
		let distance = util.distance(between: sample1, and: sample2)

		// then
		XCTAssert(distance == 0, "Distance: \(distance)")
	}

	func testGivenSamplesWithSameEndDatesButDifferentStartDates_distance_returnsZero() {
		// given
		let date = Date()
		let sample1 = SampleCreatorTestUtil.createSample(startDate: Date() - 1.days, endDate: date)
		let sample2 = SampleCreatorTestUtil.createSample(startDate: Date() + 1.days, endDate: date)

		// when
		let distance = util.distance(between: sample1, and: sample2)

		// then
		XCTAssert(distance == 0, "Distance: \(distance)")
	}

	func testGivenFirstSampleHasStartDateThatIsSameAsEndDateOfSecondSample_distance_returnsZero() {
		// given
		let date = Date()
		let sample1 = SampleCreatorTestUtil.createSample(startDate: date, endDate: Date() - 1.days)
		let sample2 = SampleCreatorTestUtil.createSample(startDate: Date() + 1.days, endDate: date)

		// when
		let distance = util.distance(between: sample1, and: sample2)

		// then
		XCTAssert(distance == 0, "Distance: \(distance)")
	}

	func testGivenFirstSampleHasEndDateThatIsSameAsStartDateOfSecondSample_distance_returnsZero() {
		// given
		let date = Date()
		let sample1 = SampleCreatorTestUtil.createSample(startDate: Date() - 1.days, endDate: date)
		let sample2 = SampleCreatorTestUtil.createSample(startDate: date, endDate: Date() + 1.days)

		// when
		let distance = util.distance(between: sample1, and: sample2)

		// then
		XCTAssert(distance == 0, "Distance: \(distance)")
	}

	func testGivenSamplesHaveStartDatesThatAreOneDayApartAndEndDatesThatAreTwoDaysApart_distanceInDays_returnsOne() {
		// given
		let startDate = Date()
		let endDate = Date()
		let sample1 = SampleCreatorTestUtil.createSample(startDate: startDate, endDate: endDate)
		let sample2 = SampleCreatorTestUtil.createSample(startDate: startDate + 1.days, endDate: endDate + 2.days)

		// when
		let distance = util.distance(between: sample1, and: sample2, in: .day)

		// then
		XCTAssert(distance == 1, "Distance: \(distance)")
	}

	func testGivenSamplesHaveStartDatesThatAreTwoDaysApartAndEndDatesThatAreOneDayApart_distanceInDays_returnsOne() {
		// given
		let startDate = Date()
		let endDate = Date()
		let sample1 = SampleCreatorTestUtil.createSample(startDate: startDate, endDate: endDate)
		let sample2 = SampleCreatorTestUtil.createSample(startDate: startDate + 2.days, endDate: endDate + 1.days)

		// when
		let distance = util.distance(between: sample1, and: sample2, in: .day)

		// then
		XCTAssert(distance == 1, "Distance: \(distance)")
	}

	func testGivenSamplesHaveStartDatesThatAreOneHourApartAndEndDatesThatAreOneDayApart_distanceInHours_returnsOne() {
		// given
		let startDate = Date()
		let endDate = Date()
		let sample1 = SampleCreatorTestUtil.createSample(startDate: startDate, endDate: endDate)
		let sample2 = SampleCreatorTestUtil.createSample(startDate: startDate + 1.hours, endDate: endDate + 1.days)

		// when
		let distance = util.distance(between: sample1, and: sample2, in: .hour)

		// then
		XCTAssert(distance == 1, "Distance: \(distance)")
	}

	func testGivenEmptySampleArray_aggregate_returnsEmptyAggregation() {
		// given
		let samples = [Sample]()
		let unit = Calendar.Component.day

		// when
		let aggregatedSamples = util.aggregate(samples: samples, by: unit)

		// then
		XCTAssert(aggregatedSamples.count == 0, "Found \(aggregatedSamples.count) aggregations")
	}

	func testGivenOneSampleAndAggregationUnitOfHour_aggregate_returnsThatSampleAtBeginningOfHour() {
		// given
		let date = Date()
		let beginningOfHour = date.dateAtStartOf(.hour)
		let samples = SampleCreatorTestUtil.createSamples(withDates: [date])
		let unit = Calendar.Component.hour
		Given(mockCalendarUtil, .start(of: .value(unit), in: .value(date), willReturn: beginningOfHour))

		// when
		let aggregatedSamples = util.aggregate(samples: samples, by: unit)

		// then
		XCTAssert(aggregatedSamples.count == 1, "Found \(aggregatedSamples.count) aggregations")
		if aggregatedSamples.count > 0 {
			let samplesForHour = aggregatedSamples[beginningOfHour]
			XCTAssert(samplesForHour != nil, "Wrong aggregation date")
			if samplesForHour != nil {
				XCTAssert(samplesForHour!.elementsEqual(samples, by: { $0.equalTo($1) }), "Wrong samples found")
			}
		}
	}

	func testGivenTwoSamplesOnSameDayAndAggregationUnitOfDay_aggregate_aggregatesBothSamplesToBeginningOfDay() {
		// given
		let date1 = Date()
		let date2 = Date()
		let beginningOfDay = date1.dateAtStartOf(.day)
		let samples = SampleCreatorTestUtil.createSamples(withDates: [date1, date2])
		let unit = Calendar.Component.day
		Given(mockCalendarUtil, .start(of: .value(unit), in: .value(date1), willReturn: beginningOfDay))
		Given(mockCalendarUtil, .start(of: .value(unit), in: .value(date2), willReturn: beginningOfDay))

		// when
		let aggregatedSamples = util.aggregate(samples: samples, by: unit)

		// then
		XCTAssert(aggregatedSamples.count == 1, "Found \(aggregatedSamples.count) aggregations")
		if aggregatedSamples.count > 0 {
			let samplesForDay = aggregatedSamples[beginningOfDay]
			XCTAssert(samplesForDay != nil, "Wrong aggregation date")
			if samplesForDay != nil {
				XCTAssert(samplesForDay!.elementsEqual(samples, by: { $0.equalTo($1) }), "Wrong samples found")
			}
		}
	}

	func testGivenTwoSamplesOnDifferentDaysWithAggregationUnitOfDay_aggregate_aggregatesSamplesCorrectly() {
		// given
		let date1 = Date()
		let date2 = Date() + 1.days
		let beginningOfDay1 = date1.dateAtStartOf(.day)
		let beginningOfDay2 = date2.dateAtStartOf(.day)
		let samples = SampleCreatorTestUtil.createSamples(withDates: [date1, date2])
		let unit = Calendar.Component.day
		Given(mockCalendarUtil, .start(of: .value(unit), in: .value(date1), willReturn: beginningOfDay1))
		Given(mockCalendarUtil, .start(of: .value(unit), in: .value(date2), willReturn: beginningOfDay2))

		// when
		let aggregatedSamples = util.aggregate(samples: samples, by: unit)

		// then
		XCTAssert(aggregatedSamples.count == 2, "Found \(aggregatedSamples.count) aggregations")
		if aggregatedSamples.count > 0 {
			let samplesForDay = aggregatedSamples[beginningOfDay1]
			XCTAssert(samplesForDay != nil, "Wrong aggregation date")
			if samplesForDay != nil {
				XCTAssert(samplesForDay!.elementsEqual([samples[0]], by: { $0.equalTo($1) }), "Wrong samples found")
			}
		}
		if aggregatedSamples.count > 1 {
			let samplesForDay = aggregatedSamples[beginningOfDay2]
			XCTAssert(samplesForDay != nil, "Wrong aggregation date")
			if samplesForDay != nil {
				XCTAssert(samplesForDay!.elementsEqual([samples[1]], by: { $0.equalTo($1) }), "Wrong samples found")
			}
		}
	}

	func testGivenEmptySampleArray_getOnlySamplesFromTo_returnsEmptyArray() {
		// given
		let fromDate: Date? = Date()
		let toDate: Date? = Date()
		let samples = [Sample]()

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == 0, "Found \(returnedSamples.count) samples")
	}

	func testGivenNonEmptySampleArrayWithNilFromaAndToDates_getOnlySamplesFromTo_returnsOriginalSamplesArray() {
		// given
		let fromDate: Date? = nil
		let toDate: Date? = nil
		let samples: [Sample] = SampleCreatorTestUtil.createSamples(count: 3)

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == samples.count, "Found \(returnedSamples.count) samples")
		XCTAssert(returnedSamples.elementsEqual(samples, by: { $0.equalTo($1) }), "Wrong samples found")
	}

	func testGivenNonEmptySampleArrayNonNilFromDateAndNilToDate_getOnlySamplesFromTo_returnsOnlySamplesThatStartAfterFromDate() {
		// given
		let fromDate: Date? = Date()
		let toDate: Date? = nil
		let samples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [fromDate! - 1.days, fromDate! + 1.days, fromDate! - 2.days])

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == 1, "Found \(returnedSamples.count) samples")
		if returnedSamples.count > 0 {
			XCTAssert(returnedSamples[0].equalTo(samples[1]), "Wrong sample returned")
		}
	}

	func testGivenNilFromDateNonNilToDateAndNonEmptySampleArrayWithOnlyStartDates_getOnlySamplesFromTo_returnsOnlySamplesThatStartBeforeToDate() {
		// given
		let fromDate: Date? = nil
		let toDate: Date? = Date()
		let samples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [toDate! - 1.days, toDate! + 1.days, toDate! - 2.days])

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == 2, "Found \(returnedSamples.count) samples")
		if returnedSamples.count > 0 {
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[0]) }))
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[2]) }))
		}
	}

	func testGivenNilFromDateNonNilToDateAndNonEmptySampleArrayWithStartAndEndDates_getOnlySamplesFromTo_returnsOnlySamplesThatEndBeforeToDate() {
		// given
		let fromDate: Date? = nil
		let toDate: Date? = Date()
		let samples: [Sample] = SampleCreatorTestUtil.createSamples(withDates:[
			(startDate: Date(), endDate: toDate! - 1.days),
			(startDate: Date(), endDate: toDate! + 1.days),
			(startDate: Date(), endDate: toDate! - 2.days),
		])

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == 2, "Found \(returnedSamples.count) samples")
		if returnedSamples.count > 0 {
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[0]) }))
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[2]) }))
		}
	}

	func testGivenNonNilFromAndToDatesAndNonEmptySampleArrayWithStartAndEndDates_getOnlySamplesFromTo_returnsOnlySamplesThatStartAfterFromDateAndEndBeforeToDate() {
		// given
		let fromDate: Date? = Date() - 2.days
		let toDate: Date? = Date() + 1.days
		let samples: [Sample] = SampleCreatorTestUtil.createSamples(withDates:[
			(startDate: fromDate! + 1.hours, endDate: toDate! - 1.hours),
			(startDate: fromDate! + 1.hours, endDate: toDate! + 1.days),
			(startDate: fromDate! + 2.hours, endDate: toDate! - 1.days),
			(startDate: fromDate! - 3.days, endDate: toDate! - 1.hours),
		])

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == 2, "Found \(returnedSamples.count) samples")
		if returnedSamples.count > 0 {
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[0]) }))
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[2]) }))
		}
	}

	func testGivenEmptySampleArray_genericGetOnlySamplesFromTo_returnsEmptyArray() {
		// given
		let fromDate: Date? = Date()
		let toDate: Date? = Date()
		let samples = [AnySample]()

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == 0, "Found \(returnedSamples.count) samples")
	}

	func testGivenNonEmptySampleArrayWithNilFromaAndToDates_genericGetOnlySamplesFromTo_returnsOriginalSamplesArray() {
		// given
		let fromDate: Date? = nil
		let toDate: Date? = nil
		let samples = SampleCreatorTestUtil.createSamples(count: 3)

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == samples.count, "Found \(returnedSamples.count) samples")
		XCTAssert(returnedSamples.elementsEqual(samples, by: { $0.equalTo($1) }), "Wrong samples found")
	}

	func testGivenNonEmptySampleArrayNonNilFromDateAndNilToDate_genericGetOnlySamplesFromTo_returnsOnlySamplesThatStartAfterFromDate() {
		// given
		let fromDate: Date? = Date()
		let toDate: Date? = nil
		let samples = SampleCreatorTestUtil.createSamples(withDates: [fromDate! - 1.days, fromDate! + 1.days, fromDate! - 2.days])

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == 1, "Found \(returnedSamples.count) samples")
		if returnedSamples.count > 0 {
			XCTAssert(returnedSamples[0].equalTo(samples[1]), "Wrong sample returned")
		}
	}

	func testGivenNilFromDateNonNilToDateAndNonEmptySampleArrayWithOnlyStartDates_genericGetOnlySamplesFromTo_returnsOnlySamplesThatStartBeforeToDate() {
		// given
		let fromDate: Date? = nil
		let toDate: Date? = Date()
		let samples = SampleCreatorTestUtil.createSamples(withDates: [toDate! - 1.days, toDate! + 1.days, toDate! - 2.days])

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == 2, "Found \(returnedSamples.count) samples")
		if returnedSamples.count > 0 {
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[0]) }))
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[2]) }))
		}
	}

	func testGivenNilFromDateNonNilToDateAndNonEmptySampleArrayWithStartAndEndDates_genericGetOnlySamplesFromTo_returnsOnlySamplesThatEndBeforeToDate() {
		// given
		let fromDate: Date? = nil
		let toDate: Date? = Date()
		let samples = SampleCreatorTestUtil.createSamples(withDates:[
			(startDate: Date(), endDate: toDate! - 1.days),
			(startDate: Date(), endDate: toDate! + 1.days),
			(startDate: Date(), endDate: toDate! - 2.days),
		])

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == 2, "Found \(returnedSamples.count) samples")
		if returnedSamples.count > 0 {
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[0]) }))
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[2]) }))
		}
	}

	func testGivenNonNilFromAndToDatesAndNonEmptySampleArrayWithStartAndEndDates_genericGetOnlySamplesFromTo_returnsOnlySamplesThatStartAfterFromDateAndEndBeforeToDate() {
		// given
		let fromDate: Date? = Date() - 2.days
		let toDate: Date? = Date() + 1.days
		let samples = SampleCreatorTestUtil.createSamples(withDates:[
			(startDate: fromDate! + 1.hours, endDate: toDate! - 1.hours),
			(startDate: fromDate! + 1.hours, endDate: toDate! + 1.days),
			(startDate: fromDate! + 2.hours, endDate: toDate! - 1.days),
			(startDate: fromDate! - 3.days, endDate: toDate! - 1.hours),
		])

		// when
		let returnedSamples = util.getOnly(samples: samples, from: fromDate, to: toDate)

		// then
		XCTAssert(returnedSamples.count == 2, "Found \(returnedSamples.count) samples")
		if returnedSamples.count > 0 {
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[0]) }))
			XCTAssert(returnedSamples.contains(where: { $0.equalTo(samples[2]) }))
		}
	}
}
