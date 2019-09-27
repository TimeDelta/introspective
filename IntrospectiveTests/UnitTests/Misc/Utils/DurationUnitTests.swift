//
//  DurationUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 12/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftDate
@testable import Introspective

final class DurationUnitTests: UnitTest {

	// MARK: - Initializers

	func testGivenMapFromCalendarComponentToInt_init_returnsSameValueAsWithDateComponents() {
		// given
		let numNanoseconds = 1
		let numSeconds = 2
		let numMinutes = 3
		let numHours = 4
		let numDays = 5
		let numWeeks = 6
		let numMonths = 7
		let numYears = 8
		let dateComponents =
			numYears.years +
			numMonths.months +
			numWeeks.weeks +
			numDays.days +
			numHours.hours +
			numMinutes.minutes +
			numSeconds.seconds +
			numNanoseconds.nanoseconds
		let calendarComponents: [Calendar.Component: Int] = [
			.year: numYears,
			.month: numMonths,
			.weekOfYear: numWeeks,
			.day: numDays,
			.hour: numHours,
			.minute: numMinutes,
			.second: numSeconds,
			.nanosecond: numNanoseconds,
		]

		// when
		let duration = Duration(calendarComponents)

		// then
		let expectedDuration = Duration(dateComponents)
		XCTAssertEqual(duration, expectedDuration)
	}

	func testGivenStartAndEndDate_init_returnsSameValueAsWithDateComponents() {
		// given
		let difference = 8.days + 7.hours + 3.minutes + 23.seconds
		let startDate = Date()
		let endDate = startDate + difference

		// when
		let duration = Duration(start: startDate, end: endDate)

		// then
		let expectedDuration = Duration(difference)
		XCTAssertEqual(duration, expectedDuration)
	}

	func testGivenStartAndEndDateInDifferentTimeZones_init_returnsCorrectDuration() {
		// given
		let startDate = DateInRegion(
			Date(),
			region: Region(calendar: Calendars.gregorian, zone: Zones.americaDenver, locale: Locales.englishUnitedStates))
		let endDate = DateInRegion(
			(startDate + 3.hours).date,
			region: Region(calendar: Calendars.gregorian, zone: Zones.americaNewYork, locale: Locales.englishUnitedStates))

		// when
		let duration = Duration(start: startDate.date, end: endDate.date)

		// then
		assertThat(duration.inUnit(.hour), equalTo(3))
	}

	func testGivenUnknownCalendarComponent_init_skipsIt() {
		// given
		let numDays = 1
		let calendarComponents: [Calendar.Component: Int] = [.calendar: 123, .day: numDays]

		// when
		let duration = Duration(calendarComponents)

		// then
		let expectedDuration = Duration(numDays.days)
		XCTAssertEqual(duration, expectedDuration)
	}

	// MARK: - units

	func testGivenDaysHoursMinutesSeconds_units_returnsCorrectNumberOfEachUnit() {
		// given
		let numDays = 1
		let numHours = 2
		let numMinutes = 3
		let numSeconds = 4
		let duration = Duration(numDays.days + numHours.hours + numMinutes.minutes + numSeconds.seconds)

		// when
		let units = duration.units(Set([.day, .hour, .minute, .second]))

		// then
		assertThat(units, hasEntry(.day, numDays))
		assertThat(units, hasEntry(.hour, numHours))
		assertThat(units, hasEntry(.minute, numMinutes))
		assertThat(units, hasEntry(.second, numSeconds))
	}

	// MARK: - description

	func testGivenLessThan10Seconds_description_returnsCorrectValue() {
		// given
		let numSeconds = 9
		let duration = Duration(numSeconds.seconds)

		// when
		let description = duration.description

		// then
		XCTAssertEqual(description, "0:00:0" + String(numSeconds))
	}

	func testGiven10Seconds_description_returnsCorrectValue() {
		// given
		let numSeconds = 10
		let duration = Duration(numSeconds.seconds)

		// when
		let description = duration.description

		// then
		XCTAssertEqual(description, "0:00:" + String(numSeconds))
	}

	func testGivenLessThan1MinuteAndMoreThan10Seconds_description_returnsCorrectValue() {
		// given
		let numSeconds = 59
		let duration = Duration(numSeconds.seconds)

		// when
		let description = duration.description

		// then
		XCTAssertEqual(description, "0:00:" + String(numSeconds))
	}

	func testGivenLessThan10Minutes_description_returnsCorrectValue() {
		// given
		let numMinutes = 9
		let duration = Duration(numMinutes.minutes)

		// when
		let description = duration.description

		// then
		XCTAssertEqual(description, "0:0" + String(numMinutes) + ":00")
	}

	func testGiven10Minutes_description_returnsCorrectValue() {
		// given
		let numMinutes = 10
		let duration = Duration(numMinutes.minutes)

		// when
		let description = duration.description

		// then
		XCTAssertEqual(description, "0:" + String(numMinutes) + ":00")
	}

	func testGivenLessThan1HourAndMoreThan10Minutes_description_returnsCorrectValue() {
		// given
		let numMinutes = 59
		let duration = Duration(numMinutes.minutes)

		// when
		let description = duration.description

		// then
		XCTAssertEqual(description, "0:" + String(numMinutes) + ":00")
	}

	func testGivenLessThan10Hours_description_returnsCorrectValue() {
		// given
		let numHours = 9
		let duration = Duration(numHours.hours)

		// when
		let description = duration.description

		// then
		XCTAssertEqual(description, String(numHours) + ":00:00")
	}

	func testGiven10Hours_description_returnsCorrectValue() {
		// given
		let numHours = 10
		let duration = Duration(numHours.hours)

		// when
		let description = duration.description

		// then
		XCTAssertEqual(description, String(numHours) + ":00:00")
	}

	func testGivenLessThan1DayAndMoreThan10Hours_description_returnsCorrectValue() {
		// given
		let numHours = 23
		let duration = Duration(numHours.hours)

		// when
		let description = duration.description

		// then
		XCTAssertEqual(description, String(numHours) + ":00:00")
	}

	func testGivenMoreThan1Day_description_returnsCorrectValue() {
		// given
		let numDays = 2
		let duration = Duration(numDays.days)

		// when
		let description = duration.description

		// then
		XCTAssertEqual(description, String(numDays) + "d 0:00:00")
	}

	func testGivenAllComponents_description_returnsCorrectValue() {
		// given
		let numWeeks = 1
		let numDays = 2
		let numHours = 10
		let numMinutes = 11
		let numSeconds = 12
		let duration = Duration(numWeeks.weeks + numDays.days + numHours.hours + numMinutes.minutes + numSeconds.seconds)

		// when
		let description = duration.description

		// then
		let expectedDescription =
			String(numWeeks) + "w " +
			String(numDays) + "d " +
			String(numHours) + ":" +
			String(numMinutes) + ":" +
			String(numSeconds)
		XCTAssertEqual(description, expectedDescription)
	}

	// MARK: - <

	func testGiven4MinutesComparedTo5Minutes_lessThan_returnsTrue() {
		// given
		let fourMinutes = Duration(4.minutes)
		let fiveMinutes = Duration(5.minutes)

		// when
		let lessThan = fourMinutes < fiveMinutes

		// then
		XCTAssert(lessThan)
	}

	func testGiven5MinutesComparedTo4Minutes_lessThan_returnsFalse() {
		// given
		let fourMinutes = Duration(4.minutes)
		let fiveMinutes = Duration(5.minutes)

		// when
		let lessThan = fiveMinutes < fourMinutes

		// then
		XCTAssertFalse(lessThan)
	}

	func testGiven4MinutesComparedTo4Minutes_lessThan_returnsFalse() {
		// given
		let fourMinutes = Duration(4.minutes)

		// when
		let lessThan = fourMinutes < fourMinutes

		// then
		XCTAssertFalse(lessThan)
	}

	func testGiven1MinuteComparedTo60Seconds_lessThan_returnsFalse() {
		// given
		let oneMinute = Duration(1.minutes)
		let sixtySeconds = Duration(60.seconds)

		// when
		let lessThan = oneMinute < sixtySeconds

		// then
		XCTAssertFalse(lessThan)
	}

	func testGiven59SecondsComparedTo1Minute_lessThan_returnsTrue() {
		// given
		let oneMinute = Duration(1.minutes)
		let fiftyNineSeconds = Duration(59.seconds)

		// when
		let lessThan = fiftyNineSeconds < oneMinute

		// then
		XCTAssert(lessThan)
	}

	// MARK: - +

	func testGiven10SecondsPlus50Seconds_plus_returnsOneMinute() {
		// given
		let tenSeconds = Duration(10.seconds)

		// when
		let sum = tenSeconds + Duration(50.seconds)

		// then
		XCTAssertEqual(sum, Duration(1.minutes))
	}

	func testGiven10SecondsPlus50SecondsAsDateComponents_plus_returnsOneMinute() {
		// given
		let tenSeconds = Duration(10.seconds)

		// when
		let sum = tenSeconds + 50.seconds

		// then
		XCTAssertEqual(sum, Duration(1.minutes))
	}

	func testGiven23SecondsPlus1AsInt_plus_returns24Seconds() {
		// given
		let twentyThreeSeconds = Duration(23.seconds)

		// when
		let result = twentyThreeSeconds + 1

		// then
		let expectedDuration = Duration(24.seconds)
		XCTAssertEqual(result, expectedDuration)
	}

	func testGiven23SecondsPlus1AsDouble_plus_returns24Seconds() {
		// given
		let twentyThreeSeconds = Duration(23.seconds)

		// when
		let result = twentyThreeSeconds + 1.0

		// then
		let expectedDuration = Duration(24.seconds)
		XCTAssertEqual(result, expectedDuration)
	}

	func testGivenDatePlusDuration_plus_returnsCorrectValue() {
		// given
		let date = Date()
		let duration = Duration(1.days)

		// when
		let addedDate = date + duration

		// then
		assertThat(addedDate, equalTo(date + 1.days))
	}

	// MARK: - +=

	func testGiven10SecondsPlus50Seconds_plusEquals_assignsOneMinute() {
		// given
		var duration = Duration(10.seconds)

		// when
		duration += Duration(50.seconds)

		// then
		XCTAssertEqual(duration, Duration(1.minutes))
	}

	func testGiven10SecondsPlus50SecondsAsDateComponents_plusEquals_assignsOneMinute() {
		// given
		var duration = Duration(10.seconds)

		// when
		duration += 50.seconds

		// then
		XCTAssertEqual(duration, Duration(1.minutes))
	}

	func testGiven23SecondsPlus1AsInt_plusEquals_assigns24Seconds() {
		// given
		var duration = Duration(23.seconds)

		// when
		duration += 1

		// then
		let expectedDuration = Duration(24.seconds)
		XCTAssertEqual(duration, expectedDuration)
	}

	func testGiven23SecondsMinus1AsDouble_minusEquals_assigns24Seconds() {
		// given
		var duration = Duration(23.seconds)

		// when
		duration += 1.0

		// then
		let expectedDuration = Duration(24.seconds)
		XCTAssertEqual(duration, expectedDuration)
	}

	// MARK: - -

	func testGiven5DaysMinus24Hours_minus_returns4Days() {
		// given
		let fiveDays = Duration(5.days)

		// when
		let result = fiveDays - Duration(24.hours)

		// then
		XCTAssertEqual(result, Duration(4.days))
	}

	func testGiven5DaysMinus24HoursAsDateComponents_minus_returns4Days() {
		// given
		let fiveDays = Duration(5.days)

		// when
		let result = fiveDays - 24.hours

		// then
		XCTAssertEqual(result, Duration(4.days))
	}

	func testGiven23SecondsMinus1AsInt_minus_returns22Seconds() {
		// given
		let twentyThreeSeconds = Duration(23.seconds)

		// when
		let result = twentyThreeSeconds - 1

		// then
		let expectedDuration = Duration(22.seconds)
		XCTAssertEqual(result, expectedDuration)
	}

	func testGiven23SecondsMinus1AsDouble_minus_returns22Seconds() {
		// given
		let twentyThreeSeconds = Duration(23.seconds)

		// when
		let result = twentyThreeSeconds - 1.0

		// then
		let expectedDuration = Duration(22.seconds)
		XCTAssertEqual(result, expectedDuration)
	}

	func testGivenDateMinusDuration_minus_returnsCorrectValue() {
		// given
		let date = Date()
		let duration = Duration(1.days)

		// when
		let addedDate = date - duration

		// then
		assertThat(addedDate, equalTo(date - 1.days))
	}

	// MARK: - -=

	func testGiven5DaysMinus24Hours_minusEquals_assigns4Days() {
		// given
		var duration = Duration(5.days)

		// when
		duration -= Duration(24.hours)

		// then
		XCTAssertEqual(duration, Duration(4.days))
	}

	func testGiven5DaysMinus24HoursAsDateComponents_minusEquals_assigns4Days() {
		// given
		var duration = Duration(5.days)

		// when
		duration -= 24.hours

		// then
		XCTAssertEqual(duration, Duration(4.days))
	}

	func testGiven23SecondsMinus1AsInt_minusEquals_assigns22Seconds() {
		// given
		var duration = Duration(23.seconds)

		// when
		duration -= 1

		// then
		let expectedDuration = Duration(22.seconds)
		XCTAssertEqual(duration, expectedDuration)
	}

	func testGiven23SecondsMinus1AsDouble_minusEquals_assigns22Seconds() {
		// given
		var duration = Duration(23.seconds)

		// when
		duration -= 1.0

		// then
		let expectedDuration = Duration(22.seconds)
		XCTAssertEqual(duration, expectedDuration)
	}

	// MARK: - *

	func testGiven6MinutesTimes4AsInt_multiply_returns24Minutes() {
		// given
		let sixMinutes = Duration(6.minutes)

		// when
		let result = sixMinutes * 4

		// then
		XCTAssertEqual(result, Duration(24.minutes))
	}

	func testGiven6MinutesTimes4AsDouble_multiply_returns24Minutes() {
		// given
		let sixMinutes = Duration(6.minutes)

		// when
		let result = sixMinutes * 4.0

		// then
		XCTAssertEqual(result, Duration(24.minutes))
	}

	func testCommutativeProperty_multiplyByInt() {
		// given
		let sixMinutes = Duration(6.minutes)

		// when
		let order1 = sixMinutes * 2
		let order2 = 2 * sixMinutes

		// then
		XCTAssertEqual(order1, order2)
	}

	func testCommutativeProperty_multiplyByDouble() {
		// given
		let sixMinutes = Duration(6.minutes)

		// when
		let order1 = sixMinutes * 2.0
		let order2 = 2.0 * sixMinutes

		// then
		XCTAssertEqual(order1, order2)
	}

	// MARK: - *=

	func testGiven6MinutesTimes4AsInt_multiplyEquals_assigns24Minutes() {
		// given
		var duration = Duration(6.minutes)

		// when
		duration *= 4

		// then
		XCTAssertEqual(duration, Duration(24.minutes))
	}

	func testGiven6MinutesTimes4AsDouble_multiplyEquals_assigns24Minutes() {
		// given
		var duration = Duration(6.minutes)

		// when
		duration *= 4.0

		// then
		XCTAssertEqual(duration, Duration(24.minutes))
	}

	// MARK: - /

	func testGiven10DaysDividedBy5Days_divided_returns2() {
		// given
		let tenDays = Duration(10.days)
		let fiveDays = Duration(5.days)

		// when
		let result = tenDays / fiveDays

		// then
		XCTAssertEqual(result, 2.0)
	}

	func testGiven10DaysDividedBy5DaysAsDateComponents_divided_returns2() {
		// given
		let tenDays = Duration(10.days)

		// when
		let result = tenDays / 5.days

		// then
		XCTAssertEqual(result, 2.0)
	}

	func testGiven10DaysDividedBy2AsInt_divided_returns5Days() {
		// given
		let tenDays = Duration(10.days)

		// when
		let result = tenDays / 2

		// then
		XCTAssertEqual(result, Duration(5.days))
	}

	func testGiven10DaysDividedBy2AsDouble_divided_returns5Days() {
		// given
		let tenDays = Duration(10.days)

		// when
		let result = tenDays / 2.0

		// then
		XCTAssertEqual(result, Duration(5.days))
	}

	// MARK: - /=

	func testGiven10DaysDividedBy2AsInt_dividedEquals_assigns5Days() {
		// given
		var duration = Duration(10.days)

		// when
		duration /= 2

		// then
		XCTAssertEqual(duration, Duration(5.days))
	}

	func testGiven10DaysDividedBy2AsDouble_dividedEquals_assigns5Days() {
		// given
		var duration = Duration(10.days)

		// when
		duration /= 2.0

		// then
		XCTAssertEqual(duration, Duration(5.days))
	}

	// MARK: - inUnit()

	func testGivenSeconds_inUnit_returnsCorrectValue() {
		// given
		let duration = Duration(10.seconds)

		// when
		let valueInHours = duration.inUnit(.second)

		// then
		XCTAssertEqual(valueInHours, 10.0)
	}

	func testGivenMinutes_inUnit_returnsCorrectValue() {
		// given
		let duration = Duration(326.minutes + 30.seconds)

		// when
		let valueInHours = duration.inUnit(.minute)

		// then
		XCTAssertEqual(valueInHours, 326.5)
	}

	func testGivenHours_inUnit_returnsCorrectValue() {
		// given
		let duration = Duration(2.days + 15.minutes)

		// when
		let valueInHours = duration.inUnit(.hour)

		// then
		XCTAssertEqual(valueInHours, 48.25)
	}

	func testGivenDays_inUnit_returnsCorrectValue() {
		// given
		let duration = Duration(2.days + 12.hours)

		// when
		let valueInHours = duration.inUnit(.day)

		// then
		XCTAssertEqual(valueInHours, 2.5)
	}

	func testGivenWeeks_inUnit_returnsCorrectValue() {
		// given
		let duration = Duration(3.weeks + 3.days + 12.hours)

		// when
		let valueInHours = duration.inUnit(.weekOfYear)

		// then
		XCTAssertEqual(valueInHours, 3.5)
	}
}
