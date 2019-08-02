//
//  MultipleSampleTypeBasicXYGraphCustomizationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import AAInfographics
import Presentr
import os

final class MultipleSampleTypeBasicXYGraphCustomizationViewController: BasicXYGraphTypeSetupViewController {

	// MARK: - Static Variables

	private typealias Me = MultipleSampleTypeBasicXYGraphCustomizationViewController
	private static let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - Structs

	private struct Groupers {
		var x: SampleGrouper
		var y: SampleGrouper

		init(x: SampleGrouper, y: SampleGrouper) {
			self.x = x
			self.y = y
		}
	}

	// MARK: - IBOutlets

	@IBOutlet weak final var chooseXAxisSampleTypeButton: UIButton!
	@IBOutlet weak final var clearXAxisQueryButton: UIButton!
	@IBOutlet weak final var chooseXAxisQueryButton: UIButton!
	@IBOutlet weak final var chooseXAxisInformationButton: UIButton!

	@IBOutlet weak final var chooseYAxisSampleTypeButton: UIButton!
	@IBOutlet weak final var clearYAxisQueryButton: UIButton!
	@IBOutlet weak final var chooseYAxisQueryButton: UIButton!
	@IBOutlet weak final var chooseYAxisInformationButton: UIButton!

	@IBOutlet weak final var clearSeriesGroupingButton: UIButton!
	@IBOutlet weak final var chooseSeriesGroupingButton: UIButton!
	@IBOutlet weak final var choosePointGroupingButton: UIButton!
	@IBOutlet weak final var showGraphButton: UIButton!

	// MARK: - Instance Variables

	private final var oldXAxisSampleType: Sample.Type!
	private final var xAxisSampleType: Sample.Type! {
		didSet { xAxisSampleTypeSet() }
	}
	private final var oldYAxisSampleType: Sample.Type!
	private final var yAxisSampleType: Sample.Type! {
		didSet { yAxisSampleTypeSet() }
	}
	private final var xAxisQuery: Query? {
		didSet { xAxisQuerySet() }
	}
	private final var yAxisQuery: Query? {
		didSet { yAxisQuerySet() }
	}
	private final var seriesGrouperAttributeType: String?
	private final var seriesGroupers: Groupers? {
		didSet { seriesGrouperSet() }
	}
	private final var pointGrouperAttributeType: String?
	private final var pointGroupers: Groupers? {
		didSet { pointGrouperSet() }
	}
	private final var usePointGroupValueForXAxis = false
	private final var xAxisInformation: ExtraInformation? {
		didSet { xAxisInformationSet() }
	}
	private final var yAxisInformation: [ExtraInformation]? {
		didSet { yAxisInformationSet() }
	}
	private final var xAxisSamples: [Sample]! { didSet { samplesAssigned() } }
	private final var yAxisSamples: [Sample]! { didSet { samplesAssigned() } }
	private final var chartController: BasicXYChartViewController!

	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MultiplSampleTypeGraphCreationPerformance"))
	private final let log = Log()

	// MARK: - UIViewController Overloads

	final override func viewDidLoad() {
		super.viewDidLoad()

		observe(selector: #selector(xAxisQueryChanged), name: .xAxisQueryChanged)
		observe(selector: #selector(yAxisQueryChanged), name: .yAxisQueryChanged)
		observe(selector: #selector(xAxisSampleTypeChanged), name: .xAxisSampleTypeChanged)
		observe(selector: #selector(yAxisSampleTypeChanged), name: .yAxisSampleTypeChanged)
		observe(selector: #selector(xAxisInformationChanged), name: .xAxisInformationChanged)
		observe(selector: #selector(yAxisInformationChanged), name: .yAxisInformationChanged)

		updateShowGraphButtonState()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Button Actions

	@IBAction final func clearSeriesGroupingButtonPressed(_ sender: Any) {
		seriesGroupers = nil
	}

	@IBAction final func chooseSeriesGroupingButtonPressed(_ sender: Any) {
		let controller = viewController(named: "chooseXYGroupers") as! ChooseGroupersForXYGraphViewController
		controller.xSampleType = xAxisSampleType
		controller.ySampleType = yAxisSampleType
		controller.navBarTitle = "Series Grouping"
		controller.xGrouper = seriesGroupers?.x
		controller.yGrouper = seriesGroupers?.y
		controller.currentAttributeType = seriesGrouperAttributeType
		observe(selector: #selector(seriesGroupersChanged), name: .groupersEdited)
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func seriesGroupingInfoButtonPressed(_ sender: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText = "This allows you to optionally group things into different data series. Each data series is drawn in its own color on the generated graph."
		present(controller, using: Me.presenter)
	}

	@IBAction final func choosePointGroupingButtonPressed(_ sender: Any) {
		let controller = viewController(named: "chooseXYGroupers") as! ChooseGroupersForXYGraphViewController
		controller.xSampleType = xAxisSampleType
		controller.ySampleType = yAxisSampleType
		controller.navBarTitle = "Point Grouping"
		controller.xGrouper = pointGroupers?.x
		controller.yGrouper = pointGroupers?.y
		controller.currentAttributeType = pointGrouperAttributeType
		observe(selector: #selector(pointGroupersChanged), name: .groupersEdited)
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func pointGroupingInfoButtonPressed(_ sender: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText = "This is how the x-axis samples are connected to the y-axis samples. Groups from the x-axis samples are matched to groups from the y-axis samples based on group values (i.e. same day of week or same group name for advanced grouping). This allows you to connect two types of data that don't have the same attributes."
		present(controller, using: Me.presenter)
	}

	@IBAction final func chooseXAxisSampleTypeButtonPressed(_ sender: Any) {
		let controller = viewController(named: "chooseSampleType", fromStoryboard: "Util") as! ChooseSampleTypeViewController
		controller.selectedSampleType = xAxisSampleType
		controller.notificationToSendOnAccept = .xAxisSampleTypeChanged
		customPresentViewController(Me.presenter, viewController: controller, animated: false)
	}

	@IBAction final func clearXAxisQueryButtonPressed(_ sender: Any) {
		xAxisQuery = nil
	}

	@IBAction final func chooseXAxisQueryButtonPressed(_ sender: Any) {
		let controller = viewController(named: "queryView", fromStoryboard: "Query") as! QueryViewController
		controller.finishedButtonTitle = "Use Query"
		controller.topmostSampleType = xAxisSampleType
		controller.initialQuery = xAxisQuery
		controller.finishedButtonNotification = .xAxisQueryChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func chooseXAxisInformationButtonPressed(_ sender: Any) {
		let controller = viewController(named: "xAxisSetup") as! XAxisSetupViewController
		controller.attributes = xAxisSampleType.attributes
		controller.selectedAttribute = xAxisInformation?.attribute
		controller.selectedInformation = xAxisInformation
		controller.grouped = true
		controller.usePointGroupValue = usePointGroupValueForXAxis
		controller.notificationToSendWhenFinished = .xAxisInformationChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func chooseYAxisSampleTypeButtonPressed(_ sender: Any) {
		let controller = viewController(named: "chooseSampleType", fromStoryboard: "Util") as! ChooseSampleTypeViewController
		controller.selectedSampleType = yAxisSampleType
		controller.notificationToSendOnAccept = .yAxisSampleTypeChanged
		customPresentViewController(Me.presenter, viewController: controller, animated: false)
	}

	@IBAction final func clearYAxisQueryButtonPressed(_ sender: Any) {
		yAxisQuery = nil
	}

	@IBAction final func chooseYAxisQueryButtonPressed(_ sender: Any) {
		let controller = viewController(named: "queryView", fromStoryboard: "Query") as! QueryViewController
		controller.finishedButtonTitle = "Use Query"
		controller.topmostSampleType = yAxisSampleType
		controller.initialQuery = yAxisQuery
		controller.finishedButtonNotification = .yAxisQueryChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func chooseYAxisInformationButtonPressed(_ sender: Any) {
		let controller = viewController(named: "chooseInformation") as! ChooseInformationToGraphTableViewController
		controller.attributes = yAxisSampleType.attributes
		if let yAxisInformation = yAxisInformation {
			controller.chosenInformation = yAxisInformation
		}
		controller.notificationToSendWhenFinished = .yAxisInformationChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func showMeTheGraphButtonPressed(_ sender: Any) {
		chartController = (viewController(named: "BasicXYChartViewController") as! BasicXYChartViewController)

		do {
			if xAxisQuery == nil {
				xAxisQuery = try DependencyInjector.query.queryFor(xAxisSampleType)
			}
			if yAxisQuery == nil {
				yAxisQuery = try DependencyInjector.query.queryFor(yAxisSampleType)
			}

			chartController.queries = [xAxisQuery!, yAxisQuery!]
			chartController.chartType = chartType
			DispatchQueue.global(qos: .userInteractive).async {
				self.runQueries()
			}
			realNavigationController?.pushViewController(chartController, animated: false)
		} catch {
			log.error("Failed to get query: %@", errorInfo(error))
			showError(title: "You found a bug", error: error)
		}
	}

	// MARK: - Received Notifications

	@objc private final func seriesGroupersChanged(notification: Notification) {
		stopObserving(.groupersEdited)
		if
			let xGrouper: SampleGrouper? = value(for: .x, from: notification),
			let yGrouper: SampleGrouper? = value(for: .y, from: notification),
			let currentAttributeType: String? = value(for: .attribute, from: notification)
		{
			seriesGroupers = Groupers(x: xGrouper!, y: yGrouper!)
			seriesGrouperAttributeType = currentAttributeType
		}
	}

	@objc private final func pointGroupersChanged(notification: Notification) {
		stopObserving(.groupersEdited)
		if
			let xGrouper: SampleGrouper? = value(for: .x, from: notification),
			let yGrouper: SampleGrouper? = value(for: .y, from: notification),
			let currentAttributeType: String? = value(for: .attribute, from: notification)
		{
			pointGroupers = Groupers(x: xGrouper!, y: yGrouper!)
			pointGrouperAttributeType = currentAttributeType
		}
	}

	@objc private final func xAxisSampleTypeChanged(notification: Notification) {
		if let sampleType: Sample.Type = value(for: .sampleType, from: notification) {
			xAxisSampleType = sampleType
		}
	}

	@objc private final func yAxisSampleTypeChanged(notification: Notification) {
		if let sampleType: Sample.Type = value(for: .sampleType, from: notification) {
			yAxisSampleType = sampleType
		}
	}

	@objc private final func xAxisQueryChanged(notification: Notification) {
		if let query: Query = value(for: .query, from: notification) {
			xAxisQuery = query
		}
	}

	@objc private final func yAxisQueryChanged(notification: Notification) {
		if let query: Query = value(for: .query, from: notification) {
			yAxisQuery = query
		}
	}

	@objc private final func xAxisInformationChanged(notification: Notification) {
		if let information: ExtraInformation? = value(for: .information, from: notification, keyIsOptional: true) {
			usePointGroupValueForXAxis = false
			xAxisInformation = information
		} else if let _: Bool = value(for: .usePointGroupValue, from: notification) {
			usePointGroupValueForXAxis = true
			xAxisInformation = nil
		}
	}

	@objc private final func yAxisInformationChanged(notification: Notification) {
		if let information: [ExtraInformation] = value(for: .information, from: notification) {
			yAxisInformation = information
		}
	}

	// MARK: - Helper Functions

	private final func updateShowGraphButtonState() {
		showGraphButton.isEnabled =
			xAxisSampleType != nil &&
			yAxisSampleType != nil &&
			(xAxisInformation != nil || usePointGroupValueForXAxis) &&
			yAxisInformation != nil &&
			pointGroupers != nil
		showGraphButton.backgroundColor = showGraphButton.isEnabled ? .black : .gray
	}

	private final func runQueries() {
		xAxisQuery?.resetStoppedState()
		xAxisQuery!.runQuery { (result, error) in
			if let error = error {
				self.log.error("X-axis query run failed: %@", errorInfo(error))
				DispatchQueue.main.async {
					self.chartController.showError(title: "Failed to run the x-axis query", error: error)
				}
				return
			}
			if let samples = result?.samples {
				self.xAxisSamples = samples
			} else {
				self.log.error("X-axis query run did not return an error or any results")
			}
		}

		yAxisQuery?.resetStoppedState()
		yAxisQuery!.runQuery { (result, error) in
			if let error = error {
				self.log.error("Y-axis query run failed: %@", errorInfo(error))
				DispatchQueue.main.async {
					self.chartController.showError(title: "Failed to run the y-axis query", error: error)
				}
				return
			}
			if let samples = result?.samples {
				self.yAxisSamples = samples
			} else {
				self.log.error("Y-axis query run did not return an error or any results")
			}
		}
	}

	private final func samplesAssigned() {
		do {
			try updateChartData()
		} catch {
			log.error("Failed to update chart data: %@", errorInfo(error))
			DispatchQueue.main.async {
				self.chartController.showError(title: "Failed to gather the required data", error: error)
			}
		}
	}

	private final func updateChartData() throws {
		guard let xAxisSamples = xAxisSamples, let yAxisSamples = yAxisSamples else { return }
		if xAxisSamples.count == 0 {
			DispatchQueue.main.async {
				self.chartController.showError(title: "No data returned for x-axis query")
			}
			return
		}
		if yAxisSamples.count == 0 {
			DispatchQueue.main.async {
				self.chartController.showError(title: "No data returned for y-axis query")
			}
			return
		}

		signpost.begin(name: "Update Chart Data", "Number of samples: (x-axis: %d, y-axis: %d)", xAxisSamples.count, yAxisSamples.count)

		var allData = [Dictionary<String, Any>]()

		if let seriesGroupers = seriesGroupers {
			signpost.begin(name: "Grouping x-axis samples for series", "Grouping %d samples", xAxisSamples.count)
			let xAxisSeriesGroups = try seriesGroupers.x.group(samples: xAxisSamples)
			signpost.end(
				name: "Grouping x-axis samples for series",
				"Grouped %d samples into %d groups",
				xAxisSamples.count,
				xAxisSeriesGroups.count)
			signpost.begin(name: "Grouping y-axis samples for series", "Grouping %d samples", yAxisSamples.count)
			let yAxisSeriesGroups = try seriesGroupers.y.group(samples: yAxisSamples)
			signpost.end(
				name: "Grouping y-axis samples for series",
				"Grouped %d samples into %d groups",
				yAxisSamples.count,
				yAxisSeriesGroups.count)
			for (xGroupValue, xSamples) in xAxisSeriesGroups {
				let correspondingYAxisSeriesGroupIndex = try yAxisSeriesGroups.firstIndex{ (yGroupValue, _) -> Bool in
					return try seriesGroupers.x.groupValuesAreEqual(xGroupValue, yGroupValue)
				}
				if let correspondingYAxisSeriesGroupIndex = correspondingYAxisSeriesGroupIndex {
					let ySamples = yAxisSeriesGroups[correspondingYAxisSeriesGroupIndex].1
					let groupName = try seriesGroupers.x.groupNameFor(value: xGroupValue)
					try addData(to: &allData, forX: xSamples, andY: ySamples, as: groupName)
				}
			}
		} else {
			try addData(to: &allData, forX: xAxisSamples, andY: yAxisSamples)
		}

		DispatchQueue.main.async {
			self.chartController.dataSeries = allData
		}
	}

	private final func addData(
		to allData: inout [Dictionary<String, Any>],
		forX xSamples: [Sample],
		andY ySamples: [Sample],
		as groupName: String? = nil)
	throws {
		guard let pointGroupers = pointGroupers else {
			throw GenericDisplayableError(
				title: "Unable to graph",
				description: "Must choose point grouping or there is no way to correlate x-axis to y-axis")
		}
		guard let yAxisInformation = yAxisInformation else {
			throw GenericDisplayableError(title: "Must choose y-axis information")
		}
		self.signpost.begin(name: "Grouping x-axis samples", "Grouping %d samples", xSamples.count)
		let xGroups = try pointGroupers.x.group(samples: xSamples)
		self.signpost.end(name: "Grouping x-axis samples", "Grouped %d samples into %d groups", xSamples.count, xGroups.count)
		let xValues: [(groupValue: Any, sampleValue: String)]
		if usePointGroupValueForXAxis {
			xValues = try xGroups.map{ (groupValue: $0.0, sampleValue: try pointGroupers.x.groupNameFor(value: $0.0)) }
		} else {
			xValues = try transform(sampleGroups: xGroups, information: xAxisInformation!)
		}
		let xValuesAreNumbers = areAllNumbers(xValues.map{ $0.sampleValue })
		var sortedXValues = xValues
		// if x values are numbers and are not sorted, graph will look very weird
		if xValuesAreNumbers {
			sortedXValues = sortXValuesByNumber(xValues)
		} else if areAllDates(xValues.map{ $0.sampleValue }) {
			sortedXValues = sortXValuesByDate(xValues)
		} else if areAllDaysOfWeek(xValues.map{ $0.sampleValue }) {
			sortedXValues = sortXValuesByDayOfWeek(xValues)
		}

		self.signpost.begin(name: "Grouping y-axis samples", "Grouping %d samples", ySamples.count)
		let yGroups = try pointGroupers.y.group(samples: ySamples)
		self.signpost.end(name: "Grouping x-axis samples", "Grouped %d samples into %d groups", ySamples.count, yGroups.count)

		for yInformation in yAxisInformation {
			var seriesData = [[Any]]()
			let yValues = try transform(sampleGroups: yGroups, information: yInformation)
			for (xGroupValue, xSampleValue) in sortedXValues { // loop over x values so that series data is already sorted
				if let yValueIndex = index(ofValue: xGroupValue, in: yValues, groupedBy: pointGroupers.x) {
					let yValue = yValues[yValueIndex].sampleValue
					var xValue: Any = xSampleValue
					if xValuesAreNumbers {
						xValue = Double(formatNumber(xSampleValue))!
					}
					seriesData.append([xValue, Double(formatNumber(yValue))!])
				}
			}
			var name = yInformation.description.localizedCapitalized
			if let groupName = groupName {
				name = "\(groupName): \(name)"
			}
			allData.append(AASeriesElement()
				.name(name)
				.data(seriesData)
				.toDic()!)
		}

		DispatchQueue.main.async {
			self.chartController.displayXAxisValueLabels = xValuesAreNumbers
		}
	}

	private final func index(
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

	private final func transform(sampleGroups: [(Any, [Sample])], information: ExtraInformation)
	throws -> [(groupValue: Any, sampleValue: String)] {
		signpost.begin(name: "Transform", "Number of sample groups: %d", sampleGroups.count)
		var values = [(groupValue: Any, sampleValue: String)]()
		for (groupValue, samples) in sampleGroups {
			let sampleValue = try information.computeGraphable(forSamples: samples)
			values.append((groupValue: groupValue, sampleValue: sampleValue))
		}
		signpost.end(name: "Transform", "Finished transforming %d groups", sampleGroups.count)
		return values
	}

	private final func areAllNumbers(_ values: [String]) -> Bool {
		signpost.begin(name: "Are all numbers", "Checking if %d values are all numbers", values.count)
		for value in values {
			if !DependencyInjector.util.string.isNumber(value) {
				signpost.end(name: "Are all numbers", "Finished checking if %d values are all numbers", values.count)
				return false
			}
		}
		signpost.end(name: "Are all numbers", "Finished checking if %d values are all numbers", values.count)
		return true
	}

	private final func areAllDates(_ values: [String]) -> Bool {
		signpost.begin(name: "Are all dates", "Checking if %d values are all dates", values.count)
		for value in values {
			let date = getDate(value)
			if date == nil {
				signpost.end(name: "Are all dates", "Finished checking if %d values are all dates", values.count)
				return false
			}
		}
		signpost.end(name: "Are all dates", "Finished checking if %d values are all dates", values.count)
		return true
	}

	private final func areAllDaysOfWeek(_ values: [String]) -> Bool {
		signpost.begin(name: "Are all days of week", "Checking if %d values are all days of week", values.count)
		for value in values {
			if !DayOfWeek.isDayOfWeek(value) {
				signpost.end(
					name: "Are all days of week",
					"Finished checking if %d values are all days of week",
					values.count)
				return false
			}
		}
		signpost.end(
			name: "Are all days of week",
			"Finished checking if %d values are all days of week",
			values.count)
		return true
	}

	private final func sortXValuesByNumber(_ xValues: [(groupValue: Any, sampleValue: String)])
	-> [(groupValue: Any, sampleValue: String)] {
		let sortedXValues: [(groupValue: Any, sampleValue: String)]
		signpost.begin(name: "Sort x values as numbers", "Number of x values: %d", xValues.count)
		sortedXValues = xValues.sorted(by: { Double($0.sampleValue)! < Double($1.sampleValue)! })
		signpost.end(name: "Sort x values as numbers")
		return sortedXValues
	}

	/// - Precondition: All sample values are valid date strings
	private final func sortXValuesByDate(_ xValues: [(groupValue: Any, sampleValue: String)])
	-> [(groupValue: Any, sampleValue: String)] {
		let sortedXValues: [(groupValue: Any, sampleValue: String)]
		signpost.begin(name: "Sort x values as dates", "Number of x values: %d", xValues.count)
		sortedXValues = xValues.sorted(by: { getDate($0.sampleValue)! < getDate($1.sampleValue)! })
		signpost.end(name: "Sort x values as dates")
		return sortedXValues
	}

	private final func sortXValuesByDayOfWeek(_ xValues: [(groupValue: Any, sampleValue: String)])
	-> [(groupValue: Any, sampleValue: String)] {
		let sortedXValues: [(groupValue: Any, sampleValue: String)]
		signpost.begin(name: "Sort x values as days of week", "Number of x values: %d", xValues.count)
		sortedXValues = xValues.sorted(by: {
			let day1 = try! DayOfWeek.fromString($0.sampleValue)
			let day2 = try! DayOfWeek.fromString($1.sampleValue)
			return day1 < day2
		})
		signpost.end(name: "Sort x values as days of week")
		return sortedXValues
	}

	private final func formatNumber(_ value: String) -> String {
		var copiedValue = value
		if let decimalIndex = value.index(where: { $0 == "." }) {
			if let lastCharIndex = copiedValue.index(decimalIndex, offsetBy: 3, limitedBy: value.endIndex) {
				copiedValue.removeSubrange(lastCharIndex ..< value.endIndex)
			}
		}
		return copiedValue
	}

	private final func getDate(_ value: String) -> Date? {
		return DependencyInjector.util.calendar.date(from: value)
	}

	// MARK: Did Set Functions

	private final func xAxisSampleTypeSet() {
		if oldXAxisSampleType != xAxisSampleType {
			xAxisQuery = nil
			xAxisInformation = nil
			chooseXAxisSampleTypeButton.setTitle(xAxisSampleType.name, for: .normal)
		}
		if xAxisSampleType != nil {
			chooseXAxisQueryButton.isEnabled = true
			chooseXAxisInformationButton.isEnabled = true
		}
		chooseXAxisSampleTypeButton.accessibilityValue = chooseXAxisSampleTypeButton.currentTitle
		updateGroupingButtonStates()
	}

	private final func yAxisSampleTypeSet() {
		if oldYAxisSampleType != yAxisSampleType {
			yAxisQuery = nil
			yAxisInformation = nil
			chooseYAxisSampleTypeButton.setTitle(yAxisSampleType.name, for: .normal)
		}
		if yAxisSampleType != nil {
			chooseYAxisQueryButton.isEnabled = true
			chooseYAxisInformationButton.isEnabled = true
		}
		chooseYAxisSampleTypeButton.accessibilityValue = chooseYAxisSampleTypeButton.currentTitle
		updateGroupingButtonStates()
	}

	private final func xAxisQuerySet() {
		if xAxisQuery == nil {
			chooseXAxisQueryButton.setTitle("Choose query (optional)", for: .normal)
			DependencyInjector.util.ui.setButton(clearXAxisQueryButton, enabled: false, hidden: true)
		} else {
			chooseXAxisQueryButton.setTitle("Query chosen (click to change)", for: .normal)
			DependencyInjector.util.ui.setButton(clearXAxisQueryButton, enabled: true, hidden: false)
		}
		chooseXAxisQueryButton.accessibilityValue = chooseXAxisQueryButton.currentTitle
	}

	private final func yAxisQuerySet() {
		if yAxisQuery == nil {
			chooseYAxisQueryButton.setTitle("Choose query (optional)", for: .normal)
			DependencyInjector.util.ui.setButton(clearYAxisQueryButton, enabled: false, hidden: true)
		} else {
			chooseYAxisQueryButton.setTitle("Query chosen (click to change)", for: .normal)
			DependencyInjector.util.ui.setButton(clearYAxisQueryButton, enabled: true, hidden: false)
		}
		chooseYAxisQueryButton.accessibilityValue = chooseYAxisQueryButton.currentTitle
	}

	private final func xAxisInformationSet() {
		if xAxisInformation == nil {
			if usePointGroupValueForXAxis {
				chooseXAxisInformationButton.setTitle("Use point group value", for: .normal)
			} else {
				chooseXAxisInformationButton.setTitle("Choose information", for: .normal)
			}
		} else {
			chooseXAxisInformationButton.setTitle(xAxisInformation!.description.localizedLowercase, for: .normal)
		}
		chooseXAxisInformationButton.accessibilityValue = chooseXAxisInformationButton.currentTitle
		updateShowGraphButtonState()
	}

	private final func yAxisInformationSet() {
		if yAxisInformation == nil {
			chooseYAxisInformationButton.setTitle("Choose information", for: .normal)
		} else {
			var description = ""
			for information in yAxisInformation! {
				description += information.description.localizedLowercase + ", "
			}
			description.removeLast()
			description.removeLast()
			chooseYAxisInformationButton.setTitle(description, for: .normal)
		}
		chooseYAxisInformationButton.accessibilityValue = chooseYAxisInformationButton.currentTitle
		updateShowGraphButtonState()
	}

	private final func seriesGrouperSet() {
		if seriesGroupers == nil {
			chooseSeriesGroupingButton.setTitle("Choose series grouping", for: .normal)
			DependencyInjector.util.ui.setButton(clearSeriesGroupingButton, enabled: false, hidden: true)
		} else {
			chooseSeriesGroupingButton.setTitle("Series grouping chosen", for: .normal)
			DependencyInjector.util.ui.setButton(clearSeriesGroupingButton, enabled: true, hidden: false)
		}
		chooseSeriesGroupingButton.accessibilityValue = chooseSeriesGroupingButton.currentTitle
	}

	private final func pointGrouperSet() {
		if pointGroupers == nil {
			choosePointGroupingButton.setTitle("Choose point grouping", for: .normal)
		} else {
			choosePointGroupingButton.setTitle("Point grouping chosen", for: .normal)
		}
		choosePointGroupingButton.accessibilityValue = choosePointGroupingButton.currentTitle
		updateShowGraphButtonState()
	}

	private final func updateGroupingButtonStates() {
		guard xAxisSampleType != nil && yAxisSampleType != nil else { return }
		chooseSeriesGroupingButton.isEnabled = true
		choosePointGroupingButton.isEnabled = true
	}
}
