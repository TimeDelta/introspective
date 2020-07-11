//
//  SingleSampleTypeXYGraphDataGeneratorUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/27/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky

@testable import Attributes
@testable import SampleGroupers
@testable import Introspective

class SingleSampleTypeXYGraphDataGeneratorUnitTests: UnitTest {

	// MARK: - generateData()

	func testGivenNoSeriesGrouperOrPointGrouperWithMultipleYAttributes_generateData_returnsCorrectData() throws {
		// given
		let xAttribute = DoubleAttribute(name: "x")
		let yAttributes = [DoubleAttribute(name: "y1"), DoubleAttribute(name: "y2")]
		let xAxis = SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(attribute: xAttribute)
		let yAxis = yAttributes.map {
			SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(attribute: $0)
		}
		let generator = SingleSampleTypeXYGraphDataGenerator(
			seriesGrouper: nil,
			pointGrouper: nil,
			xAxis: xAxis,
			yAxis: yAxis,
			usePointGroupValueForXAxis: false
		)
		let xValues = [0.1, 0.2]
		let yValues = [8.2, 3.4]
		let samples = [
			SampleCreatorTestUtil.createSample(withValues: [
				(xValues[0], xAttribute),
				(yValues[0], yAttributes[0]),
				(yValues[1], yAttributes[1]),
			]),
			SampleCreatorTestUtil.createSample(withValues: [
				(xValues[1], xAttribute),
				(yValues[0], yAttributes[0]),
				(yValues[1], yAttributes[1]),
			]),
		]
		Given(mockStringUtil, .isNumber(.any, willReturn: true))

		// when
		let graphData = try generator.generateData(samples: samples)

		// then
		assertThat(graphData,
			hasSeries(allOf(
				with(name: yAttributes[0].name),
				with(data: [
					[xValues[0], yValues[0]],
					[xValues[1], yValues[0]],
				]))))
		assertThat(graphData,
			hasSeries(allOf(
				with(name: yAttributes[1].name),
				with(data: [
					[xValues[0], yValues[1]],
					[xValues[1], yValues[1]],
				]))))
	}

	func testGivenSeriesGrouperButNoPointGrouperWithMultipleYAttributes_generateData_returnsCorrectData() throws {
		// given
		let xAttribute = DoubleAttribute(name: "x")
		let yAttributes = [DoubleAttribute(name: "y1"), DoubleAttribute(name: "y2")]
		let xAxis = SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(attribute: xAttribute)
		let yAxis = yAttributes.map {
			SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(attribute: $0)
		}
		let seriesGrouper = SampleGrouperMock(attributes: [])
		let groupNames = ["group 1", "group 2", "group 3"]
		for name in groupNames {
			Given(seriesGrouper, .groupNameFor(value: .value(name), willReturn: name))
		}
		let generator = SingleSampleTypeXYGraphDataGenerator(
			seriesGrouper: seriesGrouper,
			pointGrouper: nil,
			xAxis: xAxis,
			yAxis: yAxis,
			usePointGroupValueForXAxis: false
		)
		let xValues = [0.1, 0.3, 0.2]
		let yValues = [8.2, 3.4]
		let samples = [
			SampleCreatorTestUtil.createSample(withValues: [
				(xValues[0], xAttribute),
				(yValues[0], yAttributes[0]),
				(yValues[1], yAttributes[1]),
			]),
			SampleCreatorTestUtil.createSample(withValues: [
				(xValues[1], xAttribute),
				(yValues[0], yAttributes[0]),
				(yValues[1], yAttributes[1]),
			]),
			SampleCreatorTestUtil.createSample(withValues: [
				(xValues[2], xAttribute),
				(yValues[0], yAttributes[0]),
				(yValues[1], yAttributes[1]),
			]),
		]
		Given(mockStringUtil, .isNumber(.any, willReturn: true))
		let seriesGroups = [
			(groupNames[0], [samples[0], samples[1]]),
			(groupNames[1], [samples[1], samples[2]]),
			(groupNames[2], [samples[0], samples[2]]),
		]
		Given(seriesGrouper, .group(samples: .any, willReturn: seriesGroups))

		// when
		let graphData = try generator.generateData(samples: samples)

		// then
		assertThat(graphData,
			hasSeries(allOf(
				with(name: "\(groupNames[0]): \(yAttributes[0].name)"),
				with(data: [
					[xValues[0], yValues[0]],
					[xValues[1], yValues[0]],
				]))))
		assertThat(graphData,
			hasSeries(allOf(
				with(name: "\(groupNames[0]): \(yAttributes[1].name)"),
				with(data: [
					[xValues[0], yValues[1]],
					[xValues[1], yValues[1]],
				]))))
		assertThat(graphData,
			hasSeries(allOf(
				with(name: "\(groupNames[1]): \(yAttributes[0].name)"),
				with(data: [
					[xValues[2], yValues[0]],
					[xValues[1], yValues[0]],
				]))))
		assertThat(graphData,
			hasSeries(allOf(
				with(name: "\(groupNames[1]): \(yAttributes[1].name)"),
				with(data: [
					[xValues[2], yValues[1]],
					[xValues[1], yValues[1]],
				]))))
		assertThat(graphData,
			hasSeries(allOf(
				with(name: "\(groupNames[2]): \(yAttributes[0].name)"),
				with(data: [
					[xValues[0], yValues[0]],
					[xValues[2], yValues[0]],
				]))))
		assertThat(graphData,
			hasSeries(allOf(
				with(name: "\(groupNames[2]): \(yAttributes[1].name)"),
				with(data: [
					[xValues[0], yValues[1]],
					[xValues[2], yValues[1]],
				]))))
	}
}
