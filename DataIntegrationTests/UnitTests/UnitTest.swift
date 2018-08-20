//
//  UnitTest.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import HealthKit
import SwiftyMocky
@testable import DataIntegration

class UnitTest: XCTestCase {

	var injectionProvider: InjectionProviderMock!

	var mockDatabase: DatabaseMock!

	var utilFactory: UtilFactory!
	var mockAttributeRestrictionUtil: AttributeRestrictionUtilMock!
	var mockCalendarUtil: CalendarUtilMock!
	var mockNumericSampleUtil: NumericSampleUtilMock!
	var mockSampleUtil: SampleUtilMock!
	var mockSearchUtil: SearchUtilMock!
	var mockStringUtil: StringUtilMock!
	var mockTextNormalizationUtil: TextNormalizationUtilMock!

	var mockDataTypeFactory: DataTypeFactoryMock!
	var mockQueryFactory: QueryFactoryMock!

	override func setUp() {
		super.setUp()
		resetMocks()
		registerMatchers()
	}

	override func tearDown() {
		DependencyInjector.injectionProvider = ProductionInjectionProvider()
		super.tearDown()
	}

	/// Create a mock sample
	func createSample(startDate: Date? = nil, endDate: Date? = nil, withAttributes attributes: [Attribute] = [Attribute]()) -> AnySample {
		let sample = AnySample()
		var dates = [DateType: Date]()
		if startDate != nil {
			dates[.start] = startDate!
		}
		if endDate != nil {
			dates[.end] = endDate!
		}
		sample.set(dates: dates)
		sample.attributes = attributes
		return sample
	}

	/// Create a single sample with the specified value for the given attribute
	func createSample(withValue value: Any, for attribute: Attribute) -> AnySample {
		let sample = createSample(withAttributes: [attribute])
		try! sample.set(attribute: attribute, to: value)
		return sample
	}

	/// Create a single sample with the specified values for the given attributes
	func createSample(withValues values: [(Any, Attribute)]) -> AnySample {
		let attributes = values.map({ (_, attribute) in return attribute })
		let sample = createSample(withAttributes: attributes)
		for (value, attribute) in values {
			try! sample.set(attribute: attribute, to: value)
		}
		return sample
	}

	/// Create `count` mock samples
	/// - Parameter attributes: Optionally provide the attributes that each sample should have
	func createSamples(count: Int, withAttributes attributes: [Attribute] = [Attribute]()) -> [AnySample] {
		var samples = [AnySample]()
		for _ in 1...count {
			samples.append(createSample(withAttributes: attributes))
		}
		return samples
	}

	/// Create a new sample for each given value, assigning the value to the given attribute
	func createSamples(withValues values: [Any], for attribute: Attribute) -> [AnySample] {
		var samples = [AnySample]()
		for value in values {
			samples.append(createSample(withValue: value, for: attribute))
		}
		return samples
	}

	func createSamples(withDates dates: [(startDate: Date, endDate: Date)]) -> [AnySample] {
		var samples = [AnySample]()
		for (startDate, endDate) in dates {
			samples.append(createSample(startDate: startDate, endDate: endDate))
		}
		return samples
	}

	func createSamples(withDates dates: [Date]) -> [AnySample] {
		var samples = [AnySample]()
		for date in dates {
			samples.append(createSample(startDate: date))
		}
		return samples
	}

	func createSamples<ValueType: Any>(_ sampleValues: [(startDate: Date, value: ValueType)], for attribute: Attribute) -> [AnySample] {
		var samples = [AnySample]()
		for values in sampleValues {
			let sample = createSample(startDate: values.startDate, withAttributes: [attribute])
			try! sample.set(attribute: attribute, to: values.value)
			samples.append(sample)
		}
		return samples
	}

	func oldDate() -> Date {
		var dateComponents: DateComponents = DateComponents()
		dateComponents.year = 1998
		dateComponents.month = 1
		dateComponents.day = 1

		return Calendar.autoupdatingCurrent.date(from: dateComponents)!
	}

	fileprivate func registerMatchers() {
		Matcher.default.register(AnySample.self) { lhs,rhs in return lhs.equalTo(rhs) }
		Matcher.default.register(Attribute.self) { lhs,rhs in return lhs.equalTo(rhs) }
		Matcher.default.register(AttributeRestriction.self) { lhs,rhs in return lhs.equalTo(rhs) }
		Matcher.default.register(DayOfWeek.self)
		Matcher.default.register(HeartRate.Type.self) { _,_ in return true }
		Matcher.default.register(Sample.self) { lhs,rhs in return lhs.equalTo(rhs) }
	}

	fileprivate func resetMocks() {
		injectionProvider = InjectionProviderMock()
		DependencyInjector.injectionProvider = injectionProvider

		mockDatabase = DatabaseMock()
		Given(injectionProvider, .database(willReturn: mockDatabase))

		mockDataTypeFactory = DataTypeFactoryMock()
		Given(injectionProvider, .dataTypeFactory(willReturn: mockDataTypeFactory))

		mockQueryFactory = QueryFactoryMock()
		Given(injectionProvider, .queryFactory(willReturn: mockQueryFactory))

		utilFactory = UtilFactory()
		Given(injectionProvider, .utilFactory(willReturn: utilFactory))

		mockAttributeRestrictionUtil = AttributeRestrictionUtilMock()
		utilFactory.attributeRestrictionUtil = mockAttributeRestrictionUtil
		mockCalendarUtil = CalendarUtilMock()
		utilFactory.calendarUtil = mockCalendarUtil
		mockNumericSampleUtil = NumericSampleUtilMock()
		utilFactory.numericSampleUtil = mockNumericSampleUtil
		mockSampleUtil = SampleUtilMock()
		utilFactory.sampleUtil = mockSampleUtil
		mockSearchUtil = SearchUtilMock()
		utilFactory.searchUtil = mockSearchUtil
		mockStringUtil = StringUtilMock()
		utilFactory.stringUtil = mockStringUtil
		mockTextNormalizationUtil = TextNormalizationUtilMock()
		utilFactory.textNormalizationUtil = mockTextNormalizationUtil
	}
}
