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

	// MARK: - Instance Variables

	private final let seriesGrouper: SampleGrouper?
	private final let pointGrouper: SampleGrouper?
	private final let xAxis: AttributeOrInformation!
	private final let yAxis: [AttributeOrInformation]
	/// leaving this as public only for testing purposes. do not set this from here
	public final var usePointGroupValueForXAxis: Bool

	private final let signpost =
		Signpost(log: OSLog(
			subsystem: Bundle.main.bundleIdentifier!,
			category: "SingleSampleTypeXYGraphCreationPerformance"
		))
	private final let log = Log()

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
		super.init(signpost: signpost, log: log)
	}

	// MARK: - Public Functions

	public final func generateData(samples: [Sample]) throws -> GraphData {
		var allData = GraphData()

		if let seriesGrouper = seriesGrouper {
			signpost.begin(name: "Grouping samples for series", "Grouping %d samples", samples.count)
			let seriesGroups = try seriesGrouper.group(samples: samples)
			signpost.end(
				name: "Grouping samples for series",
				"Grouped %d samples into %d groups",
				samples.count,
				seriesGroups.count
			)
			populateColors(seriesGroups.count)
			for (groupValue, samples) in seriesGroups {
				let groupName = try seriesGrouper.groupNameFor(value: groupValue)
				try addData(to: &allData, for: samples, as: groupName)
			}
		} else {
			populateColors(1)
			try addData(to: &allData, for: samples)
		}

		return allData
	}

	// MARK: - Helper Functions

	private final func addData(
		to allData: inout GraphData,
		for samples: [Sample],
		as groupName: String? = nil
	)
		throws {
		if let pointGrouper = pointGrouper {
			let groups = try pointGrouper.group(samples: samples)
			allData.append(contentsOf: try getDataFor(groups: groups, groupedBy: pointGrouper, as: groupName))
		} else {
			for yAttribute in yAxis.map({ $0.attribute! }) {
				let data = try getSeriesDataFor(yAttribute, from: samples)
				var name = yAttribute.name
				if let groupName = groupName {
					name = "\(groupName): \(name)"
				}
				allData.append(
					AASeriesElement()
						.name(name)
						.data(data)
						.color(getNextColor())
						.toDic()!
				)
			}
		}
	}

	private final func getSeriesDataFor(_ yAttribute: Attribute, from samples: [Sample]) throws -> [[Any]] {
		guard let xAxisAttribute = xAxis.attribute else {
			throw GenericError("No x-axis attribute specified")
		}
		let filteredSamples = try samples.filter {
			let xValue = try $0.value(of: xAxisAttribute)
			if xValue == nil { return false }
			let yValue = try! $0.value(of: yAttribute)
			return yValue != nil
		}
		return try filteredSamples.map { (sample: Sample) -> [Any] in
			var xValue: Any = try sample.value(of: xAxisAttribute) as Any
			if !(xAxisAttribute is NumericAttribute) {
				xValue = try self.xAxis.attribute!.convertToDisplayableString(from: xValue)
			}

			var yValue: Any = try sample.value(of: yAttribute) as Any
			if let graphableAttribute = yAttribute as? GraphableAttribute {
				yValue = try graphableAttribute.graphableValueFor(yValue)
			} else {
				yValue = try xAxisAttribute.convertToDisplayableString(from: yValue)
			}
			return [xValue, yValue]
		}
	}

	private final func getDataFor(
		groups: [(Any, [Sample])],
		groupedBy grouper: SampleGrouper,
		as groupName: String? = nil
	) throws -> GraphData {
		let xValues: [(groupValue: Any, sampleValue: String)]
		if usePointGroupValueForXAxis {
			xValues = try groups.map { (groupValue: $0.0, sampleValue: try grouper.groupNameFor(value: $0.0)) }
		} else {
			xValues = try transform(sampleGroups: groups, information: xAxis.information!)
		}
		let sortedXValues = getSortedXValues(xValues)

		return try getSeriesDataForYInformation(
			yAxis.map { $0.information! },
			fromGroups: groups,
			groupedBy: grouper,
			withGroupName: groupName,
			sortedXValues: sortedXValues
		)
	}
}
