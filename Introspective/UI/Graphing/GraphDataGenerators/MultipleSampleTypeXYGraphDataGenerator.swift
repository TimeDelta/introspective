//
//  MultipleSampleTypeXYGraphDataGenerator.swift
//  Introspective
//
//  Created by Bryan Nova on 8/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import os
import AAInfographics

import Common
import SampleGroupers
import SampleGroupInformation
import Samples

public final class MultipleSampleTypeXYGraphDataGenerator: XYGraphDataGenerator {

	// MARK: - Structs

	public struct Groupers {
		var x: SampleGrouper
		var y: SampleGrouper

		init(x: SampleGrouper, y: SampleGrouper) {
			self.x = x
			self.y = y
		}
	}

	// MARK: - Instance Variables

	private final let seriesGroupers: Groupers?
	private final let pointGroupers: Groupers
	private final let xInformation: ExtraInformation?
	private final let yInformation: [ExtraInformation]
	// leaving this as public only for testing purposes
	public final var usePointGroupValueForXAxis: Bool

	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MultiplSampleTypeXYGraphCreationPerformance"))
	private final let log = Log()

	// MARK: - Initializers

	public init(
		seriesGroupers: Groupers?,
		pointGroupers: Groupers,
		xInformation: ExtraInformation?,
		yInformation: [ExtraInformation],
		usePointGroupValueForXAxis: Bool)
	{
		self.seriesGroupers = seriesGroupers
		self.pointGroupers = pointGroupers
		self.xInformation = xInformation
		self.yInformation = yInformation
		self.usePointGroupValueForXAxis = usePointGroupValueForXAxis
		super.init(signpost: signpost, log: log)
	}

	// MARK: - Public Functions

	public final func generateData(xSamples: [Sample], ySamples: [Sample]) throws -> GraphData {
		var allData = GraphData()

		if let seriesGroupers = seriesGroupers {
			let xAxisSeriesGroups = try groupXAxisSeries(xSamples)
			let yAxisSeriesGroups = try groupYAxisSeries(ySamples)
			populateColors(max(xAxisSeriesGroups.count, yAxisSeriesGroups.count))
			for (xGroupValue, xSamples) in xAxisSeriesGroups {
				let correspondingYAxisSeriesGroupIndex = try yAxisSeriesGroups.firstIndex{ (yGroupValue, _) -> Bool in
					return try seriesGroupers.x.groupValuesAreEqual(xGroupValue, yGroupValue)
				}
				if let correspondingYAxisSeriesGroupIndex = correspondingYAxisSeriesGroupIndex {
					let ySamples = yAxisSeriesGroups[correspondingYAxisSeriesGroupIndex].1
					let groupName = try seriesGroupers.x.groupNameFor(value: xGroupValue)
					try addData(
						to: &allData,
						forX: xSamples,
						andY: ySamples,
						as: groupName,
						usePointGroupValueForXAxis: usePointGroupValueForXAxis)
				}
			}
		} else {
			try addData(to: &allData, forX: xSamples, andY: ySamples, usePointGroupValueForXAxis: usePointGroupValueForXAxis)
		}

		return allData
	}

	// MARK: - Helper Functions

	private final func groupXAxisSeries(_ xSamples: [Sample]) throws -> [(Any, [Sample])] {
		guard let seriesGroupers = seriesGroupers else {
			throw GenericError("Tried to group x-axis series without seriesGroupers set")
		}
		signpost.begin(name: "Grouping x-axis samples for series", "Grouping %d samples", xSamples.count)
		let xAxisSeriesGroups = try seriesGroupers.x.group(samples: xSamples)
		signpost.end(
			name: "Grouping x-axis samples for series",
			"Grouped %d samples into %d groups",
			xSamples.count,
			xAxisSeriesGroups.count)
		return xAxisSeriesGroups
	}

	private final func groupYAxisSeries(_ ySamples: [Sample]) throws -> [(Any, [Sample])] {
		 guard let seriesGroupers = seriesGroupers else {
			throw GenericError("Tried to group y-axis series without seriesGroupers set")
		}
		signpost.begin(name: "Grouping y-axis samples for series", "Grouping %d samples", ySamples.count)
		let yAxisSeriesGroups = try seriesGroupers.y.group(samples: ySamples)
		signpost.end(
			name: "Grouping y-axis samples for series",
			"Grouped %d samples into %d groups",
			ySamples.count,
			yAxisSeriesGroups.count)
		return yAxisSeriesGroups
	}

	private final func addData(
		to graphData: inout GraphData,
		forX xSamples: [Sample],
		andY ySamples: [Sample],
		as groupName: String? = nil,
		usePointGroupValueForXAxis: Bool)
	throws {
		self.signpost.begin(name: "Grouping x-axis samples", "Grouping %d samples", xSamples.count)
		let xGroups = try pointGroupers.x.group(samples: xSamples)
		self.signpost.end(name: "Grouping x-axis samples", "Grouped %d samples into %d groups", xSamples.count, xGroups.count)

		let xValues: [(groupValue: Any, sampleValue: String)]
		if usePointGroupValueForXAxis {
			xValues = try xGroups.map{ (groupValue: $0.0, sampleValue: try pointGroupers.x.groupNameFor(value: $0.0)) }
		} else {
			xValues = try transform(sampleGroups: xGroups, information: xInformation!)
		}
		let sortedXValues = getSortedXValues(xValues)

		self.signpost.begin(name: "Grouping y-axis samples", "Grouping %d samples", ySamples.count)
		let yGroups = try pointGroupers.y.group(samples: ySamples)
		self.signpost.end(name: "Grouping x-axis samples", "Grouped %d samples into %d groups", ySamples.count, yGroups.count)

		graphData.append(contentsOf: try getSeriesDataForYInformation(
			yInformation,
			fromGroups: yGroups,
			groupedBy: pointGroupers.x,
			withGroupName: groupName,
			sortedXValues: sortedXValues))
	}
}
