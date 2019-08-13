//
//  XYGraphDataGenerator.swift
//  Introspective
//
//  Created by Bryan Nova on 8/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import AAInfographics

public typealias GraphData = [Dictionary<String, Any>]

public class XYGraphDataGenerator {

	// MARK: - Instance Variables

	private final let signpost: Signpost?
	private final let log: Log

	// MARK: - Initializers

	init(signpost: Signpost? = nil, log: Log) {
		self.signpost = signpost
		self.log = log
	}

	// MARK: - Are All _

	final func areAllNumbers(_ values: [String]) -> Bool {
		signpost?.begin(name: "Are all numbers", "Checking if %d values are all numbers", values.count)
		for value in values {
			if !DependencyInjector.util.string.isNumber(value) {
				signpost?.end(name: "Are all numbers", "Finished checking if %d values are all numbers", values.count)
				return false
			}
		}
		signpost?.end(name: "Are all numbers", "Finished checking if %d values are all numbers", values.count)
		return true
	}

	final func areAllDates(_ values: [String]) -> Bool {
		signpost?.begin(name: "Are all dates", "Checking if %d values are all dates", values.count)
		for value in values {
			let date = getDate(value)
			if date == nil {
				signpost?.end(name: "Are all dates", "Finished checking if %d values are all dates", values.count)
				return false
			}
		}
		signpost?.end(name: "Are all dates", "Finished checking if %d values are all dates", values.count)
		return true
	}

	final func areAllDaysOfWeek(_ values: [String]) -> Bool {
		signpost?.begin(name: "Are all days of week", "Checking if %d values are all days of week", values.count)
		for value in values {
			if !DependencyInjector.util.string.isDayOfWeek(value) {
				signpost?.end(
					name: "Are all days of week",
					"Finished checking if %d values are all days of week",
					values.count)
				return false
			}
		}
		signpost?.end(
			name: "Are all days of week",
			"Finished checking if %d values are all days of week",
			values.count)
		return true
	}

	// MARK: - Sorting

	final func getSortedXValues(_ xValues: [(groupValue: Any, sampleValue: String)]) -> [(groupValue: Any, sampleValue: Any)] {
		let values = xValues.map{ $0.sampleValue }
		// if x values are numbers and are not sorted, graph will look very weird
		if areAllNumbers(values) {
			return sortXValuesByNumber(xValues)
		} else if areAllDates(values) {
			return sortXValuesByDate(xValues)
		} else if areAllDaysOfWeek(values) {
			return sortXValuesByDayOfWeek(xValues)
		}
		return xValues.map{ (groupValue: $0.groupValue, sampleValue: $0.sampleValue as Any) }
	}

	final func sortXValuesByNumber(_ xValues: [(groupValue: Any, sampleValue: String)])
	-> [(groupValue: Any, sampleValue: Any)] {
		let sortedXValues: [(groupValue: Any, sampleValue: Any)]
		let mappedXValues = xValues.map{ (groupValue: $0.groupValue, sampleValue: Double(formatNumber($0.sampleValue))!) }
		signpost?.begin(name: "Sort x values as numbers", "Number of x values: %d", xValues.count)
		sortedXValues = mappedXValues.sorted{
			$0.sampleValue < $1.sampleValue
		}.map{
			(groupValue: $0.groupValue, sampleValue: $0.sampleValue as Any)
		}
		signpost?.end(name: "Sort x values as numbers")
		return sortedXValues
	}

	/// - Precondition: All sample values are valid date strings
	final func sortXValuesByDate(_ xValues: [(groupValue: Any, sampleValue: String)])
	-> [(groupValue: Any, sampleValue: Any)] {
		let sortedXValues: [(groupValue: Any, sampleValue: Any)]
		signpost?.begin(name: "Sort x values as dates", "Number of x values: %d", xValues.count)
		sortedXValues = xValues.sorted{
			getDate($0.sampleValue)! < getDate($1.sampleValue)!
		}.map{
			(groupValue: $0.groupValue, sampleValue: $0.sampleValue as Any)
		}
		signpost?.end(name: "Sort x values as dates")
		return sortedXValues
	}

	final func sortXValuesByDayOfWeek(_ xValues: [(groupValue: Any, sampleValue: String)])
	-> [(groupValue: Any, sampleValue: Any)] {
		let sortedXValues: [(groupValue: Any, sampleValue: Any)]
		signpost?.begin(name: "Sort x values as days of week", "Number of x values: %d", xValues.count)
		sortedXValues = xValues.sorted{
			let day1 = try! DayOfWeek.fromString($0.sampleValue)
			let day2 = try! DayOfWeek.fromString($1.sampleValue)
			return day1 < day2
		}.map{
			(groupValue: $0.groupValue, sampleValue: $0.sampleValue as Any)
		}
		signpost?.end(name: "Sort x values as days of week")
		return sortedXValues
	}

	// MARK: - Misc.

	final func getSeriesDataForYInformation(
		_ yInformation: [ExtraInformation],
		fromGroups groups: [(Any, [Sample])],
		groupedBy grouper: SampleGrouper,
		withGroupName groupName: String?,
		sortedXValues: [(groupValue: Any, sampleValue: Any)])
	throws -> GraphData {
		var graphData = GraphData()
		for yInformation in yInformation {
			var seriesData = [[Any]]()
			let yValues = try transform(sampleGroups: groups, information: yInformation)
			for (xGroupValue, xSampleValue) in sortedXValues { // loop over x values so that series data is already sorted
				if let yValueIndex = index(ofValue: xGroupValue, in: yValues, groupedBy: grouper) {
					let yValue = yValues[yValueIndex].sampleValue
					seriesData.append([xSampleValue, Double(formatNumber(yValue))!])
				}
			}
			var name = yInformation.description.localizedCapitalized
			if let groupName = groupName {
				name = "\(groupName): \(name)"
			}
			graphData.append(AASeriesElement()
				.name(name)
				.data(seriesData)
				.toDic()!)
		}
		return graphData
	}

	final func formatNumber(_ value: String) -> String {
		var copiedValue = value
		if let decimalIndex = value.index(where: { $0 == "." }) {
			if let lastCharIndex = copiedValue.index(decimalIndex, offsetBy: 3, limitedBy: value.endIndex) {
				copiedValue.removeSubrange(lastCharIndex ..< value.endIndex)
			}
		}
		return copiedValue
	}

	final func getDate(_ value: String) -> Date? {
		return DependencyInjector.util.calendar.date(from: value)
	}

	final func transform(sampleGroups: [(Any, [Sample])], information: ExtraInformation)
	throws -> [(groupValue: Any, sampleValue: String)] {
		signpost?.begin(name: "Transform", "Number of sample groups: %d", sampleGroups.count)
		var values = [(groupValue: Any, sampleValue: String)]()
		for (groupValue, samples) in sampleGroups {
			let sampleValue = try information.computeGraphable(forSamples: samples)
			values.append((groupValue: groupValue, sampleValue: sampleValue))
		}
		signpost?.end(name: "Transform", "Finished transforming %d groups", sampleGroups.count)
		return values
	}

	final func index(
		ofValue value: Any,
		in groupValues: [(groupValue: Any, sampleValue: String)],
		groupedBy grouper: SampleGrouper)
	-> Int? {
		return groupValues.index(where: {
			do {
				return try grouper.groupValuesAreEqual($0.groupValue, value)
			} catch {
				self.log.error(
					"Failed to test for value equality between '%@' and '%@': %@",
					String(describing: $0.groupValue),
					String(describing: value),
					errorInfo(error))
				return false
			}
		})
	}
}