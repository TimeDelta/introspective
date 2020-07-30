//
//  MultipleSampleTypeXYGraphDataGenerator.swift
//  Introspective
//
//  Created by Bryan Nova on 8/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import AAInfographics
import Foundation
import os

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

	// MARK: - Static Variables

	private typealias Me = MultipleSampleTypeXYGraphDataGenerator

	private static let signpost =
		Signpost(log: OSLog(
			subsystem: Bundle.main.bundleIdentifier!,
			category: "MultiplSampleTypeXYGraphCreationPerformance"
		))
	private static let log = Log()

	// MARK: - Instance Variables

	private final let seriesGroupers: Groupers?
	private final let pointGroupers: Groupers
	private final let xInformation: SampleGroupInformation?
	private final let yInformation: [SampleGroupInformation]
	// leaving this as public only for testing purposes
	public final var usePointGroupValueForXAxis: Bool

	// MARK: - Initializers

	public init(
		seriesGroupers: Groupers?,
		pointGroupers: Groupers,
		xInformation: SampleGroupInformation?,
		yInformation: [SampleGroupInformation],
		usePointGroupValueForXAxis: Bool
	) {
		self.seriesGroupers = seriesGroupers
		self.pointGroupers = pointGroupers
		self.xInformation = xInformation
		self.yInformation = yInformation
		self.usePointGroupValueForXAxis = usePointGroupValueForXAxis
		super.init(signpost: Me.signpost, log: Me.log)
	}

	// MARK: - Public Functions

	public final func generateData(xSamples: [Sample], ySamples: [Sample]) throws -> GraphData {
		var allData = GraphData()

		if let seriesGroupers = seriesGroupers {
			let xAxisSeriesGroups = try groupXAxisSeries(xSamples)
			let yAxisSeriesGroups = try groupYAxisSeries(ySamples)
			populateColors(max(xAxisSeriesGroups.count, yAxisSeriesGroups.count))
			for (xGroupValue, xSamples) in xAxisSeriesGroups {
				let correspondingYAxisSeriesGroupIndex = try yAxisSeriesGroups.firstIndex { (yGroupValue, _) -> Bool in
					try seriesGroupers.x.groupValuesAreEqual(xGroupValue, yGroupValue)
				}
				if let correspondingYAxisSeriesGroupIndex = correspondingYAxisSeriesGroupIndex {
					let ySamples = yAxisSeriesGroups[correspondingYAxisSeriesGroupIndex].1
					let groupName = try seriesGroupers.x.groupNameFor(value: xGroupValue)
					try addData(
						to: &allData,
						forX: xSamples,
						andY: ySamples,
						as: groupName,
						usePointGroupValueForXAxis: usePointGroupValueForXAxis
					)
				}
			}
		} else {
			try addData(
				to: &allData,
				forX: xSamples,
				andY: ySamples,
				usePointGroupValueForXAxis: usePointGroupValueForXAxis
			)
		}

		return allData
	}

	// MARK: - Helper Functions

	private final func groupXAxisSeries(_ xSamples: [Sample]) throws -> [(Any, [Sample])] {
		guard let seriesGroupers = seriesGroupers else {
			throw GenericError("Tried to group x-axis series without seriesGroupers set")
		}
		Me.signpost.begin(name: "Grouping x-axis samples for series", "Grouping %d samples", xSamples.count)
		let xAxisSeriesGroups = try seriesGroupers.x.group(samples: xSamples)
		Me.signpost.end(
			name: "Grouping x-axis samples for series",
			"Grouped %d samples into %d groups",
			xSamples.count,
			xAxisSeriesGroups.count
		)
		return xAxisSeriesGroups
	}

	private final func groupYAxisSeries(_ ySamples: [Sample]) throws -> [(Any, [Sample])] {
		guard let seriesGroupers = seriesGroupers else {
			throw GenericError("Tried to group y-axis series without seriesGroupers set")
		}
		Me.signpost.begin(name: "Grouping y-axis samples for series", "Grouping %d samples", ySamples.count)
		let yAxisSeriesGroups = try seriesGroupers.y.group(samples: ySamples)
		Me.signpost.end(
			name: "Grouping y-axis samples for series",
			"Grouped %d samples into %d groups",
			ySamples.count,
			yAxisSeriesGroups.count
		)
		return yAxisSeriesGroups
	}

	private final func addData(
		to graphData: inout GraphData,
		forX xSamples: [Sample],
		andY ySamples: [Sample],
		as groupName: String? = nil,
		usePointGroupValueForXAxis: Bool
	) throws {
		Me.signpost.begin(name: "Grouping x-axis samples", "Grouping %d samples", xSamples.count)
		let xGroups = try pointGroupers.x.group(samples: xSamples)
		Me.signpost.end(
			name: "Grouping x-axis samples",
			"Grouped %d samples into %d groups",
			xSamples.count,
			xGroups.count
		)

		let xValues: [(groupValue: Any, sampleValue: String)]
		if usePointGroupValueForXAxis {
			xValues = try xGroups.map { (groupValue: $0.0, sampleValue: try pointGroupers.x.groupNameFor(value: $0.0)) }
		} else {
			xValues = try transform(sampleGroups: xGroups, information: xInformation!)
		}
		let sortedXValues = sort(xValues, by: { gentlyResolveAsString($0.groupValue) })

		Me.signpost.begin(name: "Grouping y-axis samples", "Grouping %d samples", ySamples.count)
		let yGroups = try pointGroupers.y.group(samples: ySamples)
		Me.signpost.end(
			name: "Grouping x-axis samples",
			"Grouped %d samples into %d groups",
			ySamples.count,
			yGroups.count
		)

		graphData.append(contentsOf: try getSeriesDataForYInformation(
			yInformation,
			fromGroups: yGroups,
			groupedBy: pointGroupers.x,
			seriesNamePrefix: groupName,
			sortedXValuesForSeries: sortedXValues,
			allSortedXGroupValues: sortedXValues
		))
	}
}
