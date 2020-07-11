//
//  XYGraphDataGenerator.swift
//  Introspective
//
//  Created by Bryan Nova on 8/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import AAInfographics
import Foundation

import Common
import DependencyInjection
import SampleGroupers
import SampleGroupInformation
import Samples

public typealias GraphData = [AASeriesElement]

public class XYGraphDataGenerator {
	// MARK: - Instance Variables

	private final var colors = [UIColor]()

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
			if !DependencyInjector.get(StringUtil.self).isNumber(value) {
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
			guard let _ = getDate(value) else {
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
			if !DependencyInjector.get(StringUtil.self).isDayOfWeek(value) {
				signpost?.end(
					name: "Are all days of week",
					"Finished checking if %d values are all days of week",
					values.count
				)
				return false
			}
		}
		signpost?.end(
			name: "Are all days of week",
			"Finished checking if %d values are all days of week",
			values.count
		)
		return true
	}

	// MARK: - Sorting

	/// - Parameter values:
	///     - groupValue: Whatever the grouper passed back for the group value in the tuple returned from `group(samples: [Sample])`.
	///     - sampleValue: The combined value over all samples.
	/// - Parameter valueResolver: How to resolve the value by which to sort each `(groupValue: Any, sampleValue: String)` tuple.
	final func sort<ValueType>(
		_ values: [ValueType],
		by valueResolver: (ValueType) -> String
	) -> [ValueType] {
		let resolvedValues: [String] = values.map { valueResolver($0) }
		if areAllNumbers(resolvedValues) {
			return sortValuesAsNumbers(values, by: valueResolver)
		} else if areAllDates(resolvedValues) {
			return sortValuesAsDates(values, by: valueResolver)
		} else if areAllDaysOfWeek(resolvedValues) {
			return sortValuesAsDaysOfWeek(values, by: valueResolver)
		}
		return values
	}

	/// - Precondition: All resolved values are numbers
	/// - Parameter values:
	///     - groupValue: Whatever the grouper passed back for the group value in the tuple returned from `group(samples: [Sample])`.
	///     - sampleValue: The combined value over all samples.
	/// - Parameter valueResolver: How to resolve the value by which to sort each `(groupValue: Any, sampleValue: String)` tuple.
	final func sortValuesAsNumbers<ValueType>(
		_ values: [ValueType],
		by valueResolver: (ValueType) -> String
	) -> [ValueType] {
		signpost?.begin(name: "Sort values as numbers", "Number of values: %d", values.count)
		let sortedValues: [ValueType] = values.sorted {
			let first = Double(formatNumber(valueResolver($0)))!
			let second = Double(formatNumber(valueResolver($1)))!
			return first < second
		}
		signpost?.end(name: "Sort values as numbers")
		return sortedValues
	}

	/// - Precondition: All resolved values are valid date strings
	/// - Parameter values:
	///     - groupValue: Whatever the grouper passed back for the group value in the tuple returned from `group(samples: [Sample])`.
	///     - sampleValue: The combined value over all samples.
	/// - Parameter valueResolver: How to resolve the value by which to sort each `(groupValue: Any, sampleValue: String)` tuple.
	final func sortValuesAsDates<ValueType>(
		_ values: [ValueType],
		by valueResolver: (ValueType) -> String
	) -> [ValueType] {
		signpost?.begin(name: "Sort values as dates", "Number of values: %d", values.count)
		let sortedValues: [ValueType] = values.sorted {
			getDate(valueResolver($0))! < getDate(valueResolver($1))!
		}
		signpost?.end(name: "Sort values as dates")
		return sortedValues
	}

	/// - Precondition: All resolved values are days of the week
	/// - Parameter values:
	///     - groupValue: Whatever the grouper passed back for the group value in the tuple returned from `group(samples: [Sample])`.
	///     - sampleValue: The combined value over all samples.
	/// - Parameter valueResolver: How to resolve the value by which to sort each `(groupValue: Any, sampleValue: String)` tuple.
	final func sortValuesAsDaysOfWeek<ValueType>(
		_ values: [ValueType],
		by valueResolver: (ValueType) -> String
	) -> [ValueType] {
		signpost?.begin(name: "Sort values as days of week", "Number of values: %d", values.count)
		let sortedValues: [ValueType] = values.sorted {
			let day1 = try! DayOfWeek.fromString(valueResolver($0))
			let day2 = try! DayOfWeek.fromString(valueResolver($1))
			return day1 < day2
		}
		signpost?.end(name: "Sort values as days of week")
		return sortedValues
	}

	// MARK: - Misc.

	/// Generate series data, producing a separate series for each of the given `SampleGroupInformation`. A different color is generated for each series, maximizing average distance between colors (using the [populateColors() method](x-source-tag://populateColors))
	///
	/// For each series:
	///   1. Transform `groups` by reducing the samples in each using the `SampleGroupInformation` associated with the series.
	///   1. Iterate over thee x-values in the series, finidng the matching y-value based on same group value.
	///
	/// - Parameter yInformation: The information to apply to each group (point) in the series.
	/// - Parameter groups: The groups of samples to include in the series.
	/// - Parameter pointGrouper: This is only for use of `groupValuesAreEqual`. No additional grouping is done by this method.
	/// - Parameter seriesNamePrefix: If provided, prepend the series name with this followed by `": "`.
	/// - Parameter sortedXValuesForSeries: **Must** be sorted by group value.
	/// - Parameter allSortedXGroupValues: **Must** be sorted by group value.
	final func getSeriesDataForYInformation(
		_ yInformation: [SampleGroupInformation],
		fromGroups groups: [(Any, [Sample])],
		groupedBy pointGrouper: SampleGrouper,
		seriesNamePrefix: String?,
		sortedXValuesForSeries: [(groupValue: Any, sampleValue: Any)],
		allSortedXGroupValues: [Any]
	) throws -> GraphData {
		var graphData = GraphData()
		if colors.isEmpty {
			populateColors(yInformation.count)
		}
		for yInformation in yInformation {
			var seriesData = [Any]()
			let yValues = try transform(sampleGroups: groups, information: yInformation)
			var xValueIndex: Int = 0
			for (xGroupValue, xSampleValue) in sortedXValuesForSeries {
				let alreadyAtCurrentXValueIndex = try pointGrouper.groupValuesAreEqual(
					xGroupValue,
					allSortedXGroupValues[xValueIndex]
				)
				if !alreadyAtCurrentXValueIndex {
					// since x-value groups for series and all x-value groups are both sorted same, we only need to search from current position in x-value groups forward
					let remainingXValues = allSortedXGroupValues[xValueIndex...]
					// Note that because remainingXValues is an array slice, calling .firstIndex will return index relative to original array while only searching within the array slice
					guard let newXValueIndex = try remainingXValues.firstIndex(where: { groupValue -> Bool in
						try pointGrouper.groupValuesAreEqual(groupValue, xGroupValue)
					}) else {
						// if this happens, it means we can't match the y-value group to an x-value group
						continue
					}
					xValueIndex = newXValueIndex
				}
				if let yValueIndex = index(ofValue: xGroupValue, in: yValues, groupedBy: pointGrouper) {
					let yValue = yValues[yValueIndex].sampleValue
					guard let yValueNum = Float(formatNumber(yValue)) else {
						log.debug("Skipping y-value: %@", String(describing: yValue))
						continue
					}
					if let xValue = xSampleValue as? Int {
						seriesData.append([xValue, yValueNum])
					} else if let xValue = xSampleValue as? Double {
						seriesData.append([xValue, yValueNum])
					} else if let xValue = xSampleValue as? Float {
						seriesData.append([xValue, yValueNum])
					} else {
						let dataElement = AADataElement()
							.name(String(describing: xSampleValue))
							.x(Float(xValueIndex + 1) / Float(allSortedXGroupValues.count))
							.y(yValueNum)
						seriesData.append(dataElement)
					}
				}
			}
			var name = yInformation.description.localizedCapitalized
			if let prefix = seriesNamePrefix {
				name = "\(prefix): \(name)"
			}
			graphData.append(
				AASeriesElement()
					.name(name)
					.data(seriesData)
					.color(getNextColor())
			)
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
		DependencyInjector.get(CalendarUtil.self).date(from: value)
	}

	/// Apply the given `SampleGroupInformation` to each sample group.
	/// - Returns: An array of tuples with:
	///     - the group value
	///     - resulting value from applying the `information` to the samples in the group
	final func transform(
		sampleGroups: [(Any, [Sample])],
		information: SampleGroupInformation
	) throws -> [(groupValue: Any, sampleValue: String)] {
		signpost?.begin(name: "Transform", "Number of sample groups: %d", sampleGroups.count)
		var values = [(groupValue: Any, sampleValue: String)]()
		for (groupValue, samples) in sampleGroups {
			if samples.count == 0 {
				values.append((groupValue: groupValue, sampleValue: "0"))
			} else {
				let sampleValue = try information.computeGraphable(forSamples: samples)
				values.append((groupValue: groupValue, sampleValue: sampleValue))
			}
		}
		signpost?.end(name: "Transform", "Finished transforming %d groups", sampleGroups.count)
		return values
	}

	/// - Parameter value: The groupValue for which to search.
	final func index(
		ofValue value: Any,
		in groupValues: [(groupValue: Any, sampleValue: String)],
		groupedBy grouper: SampleGrouper
	) -> Int? {
		groupValues.index(where: {
			do {
				return try grouper.groupValuesAreEqual($0.groupValue, value)
			} catch {
				self.log.error(
					"Failed to test for value equality between '%@' and '%@': %@",
					String(describing: $0.groupValue),
					String(describing: value),
					errorInfo(error)
				)
				return false
			}
		})
	}

	/// Calculate `number` different colors, evenly spaced in the HSB color space, maximizing distance between colors.
	/// - Parameter number: The number of colors to generate (e.g. the number of series for which data is being generated)
	/// - Tag: populateColors
	final func populateColors(_ number: Int) {
		for i in 0 ..< number {
			let hue = CGFloat(Double(i) / Double(number))
			let brightness = CGFloat(Double.random(in: 0.6 ... 1.0))
			let saturation = CGFloat(Double.random(in: 0.6 ... 1.0))
			colors.append(UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1))
		}
	}

	/// Get the next color that was generated by calling [populateColors()](x-source-tag://populateColors)
	final func getNextColor() -> String {
		colorToHex(colors.removeFirst())
	}

	final func gentlyResolveAsString(_ value: Any) -> String {
		if let castedValue = value as? String {
			return castedValue
		}
		if let describable = value as? CustomStringConvertible {
			return describable.description
		}
		if isOptional(value) {
			var stringValue = String(describing: value)
				.replacingOccurrences(of: "Optional(", with: "")
			stringValue.removeLast()
			return stringValue
		}
		return String(describing: value)
	}

	private final func colorToHex(_ color: UIColor) -> String {
		let components = color.cgColor.components!
		let r = Float(components[0])
		let g = Float(components[1])
		let b = Float(components[2])
		return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
	}
}
