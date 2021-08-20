//
//  SingleSampleTypeXYGraphDataGenerator.swift
//  Introspective
//
//  Created by Bryan Nova on 8/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import AAInfographics
import Foundation
import os

import Attributes
import Common
import SampleGroupers
import SampleGroupInformation
import Samples

public final class SingleSampleTypeXYGraphDataGenerator: XYGraphDataGenerator {
	// MARK: - Structs

	public struct AttributeOrInformation {
		public var attribute: Attribute?
		public var information: SampleGroupInformation?

		public init(attribute: Attribute? = nil, information: SampleGroupInformation? = nil) {
			self.attribute = attribute
			self.information = information
		}
	}

	// MARK: - Static Variables

	private typealias Me = SingleSampleTypeXYGraphDataGenerator

	private static let signpost =
		Signpost(log: OSLog(
			subsystem: Bundle.main.bundleIdentifier!,
			category: "SingleSampleTypeXYGraphCreationPerformance"
		))
	private static let log = Log()

	// MARK: - Instance Variables

	/// The grouper to use for grouping samples into data series
	private final let seriesGrouper: SampleGrouper?
	/// The grouper to use for grouping samples into individual points
	private final let pointGrouper: SampleGrouper?
	private final let xAxis: AttributeOrInformation!
	private final let yAxis: [AttributeOrInformation]
	private final var usePointGroupValueForXAxis: Bool

	// MARK: - Initializers

	public init(
		seriesGrouper: SampleGrouper?,
		pointGrouper: SampleGrouper?,
		xAxis: AttributeOrInformation?,
		yAxis: [AttributeOrInformation],
		usePointGroupValueForXAxis: Bool
	) {
		self.seriesGrouper = seriesGrouper
		self.pointGrouper = pointGrouper
		self.xAxis = xAxis
		self.yAxis = yAxis
		self.usePointGroupValueForXAxis = usePointGroupValueForXAxis
		super.init(signpost: Me.signpost, log: Me.log)
	}

	// MARK: - Public Functions

	public final func generateData(samples: [Sample]) throws -> GraphData {
		var allData = GraphData()

		if let seriesGrouper = seriesGrouper {
			Me.signpost.begin(name: "Grouping samples for series", "Grouping %d samples", samples.count)
			let seriesGroups = try seriesGrouper.group(samples: samples)
			Me.signpost.end(
				name: "Grouping samples for series",
				"Grouped %d samples into %d groups",
				samples.count,
				seriesGroups.count
			)
			populateColors(seriesGroups.count * yAxis.count)

			let allSortedXGroupValues = try getAllSortedXGroupValuesIfPointGrouped(seriesGroups: seriesGroups)

			for (groupValue, samples) in seriesGroups {
				let seriesName = try seriesGrouper.groupNameFor(value: groupValue)
				try addData(to: &allData, for: samples, as: seriesName, withXGroupValues: allSortedXGroupValues)
			}
		} else {
			populateColors(yAxis.count)
			try addData(to: &allData, for: samples)
		}

		return allData
	}

	// MARK: - Helper Functions

	/// - Parameter xGroupValues: All x-values that will be produced. Should already be sorted by groupValue. Only necessary when using a point grouper.
	/// This parameter allows the transformed x-values to be put in the right place on the screen even when it is not a numerical value because it can calculate
	/// the point along the x-axis where it should go based on the index in the array divided by the array's length. If there is a point grouper, this parameter
	/// **must** be provided.
	private final func addData(
		to allData: inout GraphData,
		for samples: [Sample],
		as seriesNamePrefix: String? = nil,
		withXGroupValues xGroupValues: [Any]? = nil
	) throws {
		if let pointGrouper = pointGrouper {
			let groups = try pointGrouper.group(samples: samples)
			allData.append(
				contentsOf:
				try getDataFor(
					groups: groups,
					groupedBy: pointGrouper,
					as: seriesNamePrefix,
					allSortedXGroupValues: xGroupValues
				)
			)
		} else {
			for yAttribute in yAxis.map({ $0.attribute! }) {
				let data = try getDataPoints(for: yAttribute, from: samples)
				var name = yAttribute.name
				if let namePrefix = seriesNamePrefix {
					name = "\(namePrefix): \(name)"
				}
				allData.append(
					AASeriesElement()
						.name(name)
						.data(data)
						.color(getNextColor())
				)
			}
		}
	}

	/// - Note: Use this when no grouping is required.
	/// - Parameter yAttribute: The attribute of each sample to use for the y-value of each point.
	private final func getDataPoints(for yAttribute: Attribute, from samples: [Sample]) throws -> [[Any]] {
		guard let xAxisAttribute = xAxis.attribute else {
			throw GenericError("No x-axis attribute specified")
		}
		let filteredSamples = try samples.filter {
			let xValue = try $0.value(of: xAxisAttribute)
			if xValue == nil { return false }
			let yValue = try $0.value(of: yAttribute)
			return yValue != nil
		}
		let mappedValues = try filteredSamples.map { (sample: Sample) -> [Any] in
			var xValue: Any = try sample.value(of: xAxisAttribute) as Any
			if !(xAxisAttribute is NumericAttribute) {
				xValue = try xAxisAttribute.convertToDisplayableString(from: xValue)
			}

			var yValue: Any = try sample.value(of: yAttribute) as Any
			if let graphableAttribute = yAttribute as? GraphableAttribute {
				yValue = try graphableAttribute.graphableValueFor(yValue)
			} else {
				yValue = try xAxisAttribute.convertToDisplayableString(from: yValue)
			}
			return [xValue, yValue]
		}
		// sort by x-value
		return sort(mappedValues, by: { gentlyResolveAsString($0[0]) })
	}

	/// - Precondition: `allSortedXValues` **must** be sorted by group values.
	/// - Parameter pointGrouper: The grouper to use for creating individual points.
	/// - Parameter allSortedXValues: **Must** be sorted by group value.
	private final func getDataFor(
		groups: [(Any, [Sample])],
		groupedBy pointGrouper: SampleGrouper,
		as groupName: String? = nil,
		allSortedXGroupValues: [Any]?
	) throws -> GraphData {
		let xValues: [(groupValue: Any, sampleValue: String)]
		if usePointGroupValueForXAxis {
			xValues = try groups.map { (groupValue: $0.0, sampleValue: try pointGrouper.groupNameFor(value: $0.0)) }
		} else {
			xValues = try transform(sampleGroups: groups, information: xAxis.information!)
		}
		let sortedXValues = sort(xValues, by: { gentlyResolveAsString($0.groupValue) })

		return try getSeriesDataForYInformation(
			yAxis.map { $0.information! },
			fromGroups: groups,
			groupedBy: pointGrouper,
			seriesNamePrefix: groupName,
			sortedXValuesForSeries: sortedXValues,
			allSortedXGroupValues: allSortedXGroupValues ?? sortedXValues.map { $0.groupValue }
		)
	}

	/// - Returns: If a `pointGrouper` is set, then produce the point groups  and return all sorted group values for the x-axis (de-duplicated). Otherwise return `nil`.
	private final func getAllSortedXGroupValuesIfPointGrouped(seriesGroups: [(Any, [Sample])]) throws -> [Any]? {
		if let pointGrouper = pointGrouper {
			var xGroupValues = [Any]()
			for (_, samples) in seriesGroups {
				let groups = try pointGrouper.group(samples: samples)
				xGroupValues.append(contentsOf: groups.map { $0.0 })
			}
			return sort(unique(xGroupValues), by: { gentlyResolveAsString($0) })
		}
		return nil
	}

	private final func unique(_ values: [Any]) -> [Any] {
		var valuesSeen = Set<String>()
		return values.filter {
			let stringValue = String(describing: $0)
			let previouslySeen = valuesSeen.contains(stringValue)
			valuesSeen.insert(stringValue)
			return !previouslySeen
		}
	}
}
