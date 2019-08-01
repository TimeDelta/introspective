//
//  SingleSampleTypeBasicXYGraphCustomizationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import AAInfographics
import os

final class SingleSampleTypeBasicXYGraphCustomizationViewController: BasicXYGraphTypeSetupViewController {

	// MARK: - Enums / Structs

	private struct AttributeOrInformation {
		fileprivate var attribute: Attribute?
		fileprivate var information: ExtraInformation?

		fileprivate init(attribute: Attribute? = nil, information: ExtraInformation? = nil) {
			self.attribute = attribute
			self.information = information
		}
	}

	// MARK: - Static Variables

	private typealias Me = SingleSampleTypeBasicXYGraphCustomizationViewController
	private static let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var sampleTypePicker: UIPickerView!
	@IBOutlet weak final var clearSeriesGrouperButton: UIButton!
	@IBOutlet weak final var chooseSeriesGrouperButton: UIButton!
	@IBOutlet weak final var clearPointGrouperButton: UIButton!
	@IBOutlet weak final var choosePointGrouperButton: UIButton!
	@IBOutlet weak final var queryButton: UIButton!
	@IBOutlet weak final var xAxisButton: UIButton!
	@IBOutlet weak final var yAxisButton: UIButton!
	@IBOutlet weak final var showGraphButton: UIButton!
	@IBOutlet weak final var clearQueryButton: UIButton!

	// MARK: - Instance Variables

	private final var query: Query? {
		didSet { querySet() }
	}
	private final var usePointGroupValueForXAxis = false
	private final var xAxis: AttributeOrInformation! {
		didSet { xAxisSet() }
	}
	private final var yAxis: [AttributeOrInformation]! {
		didSet { yAxisSet() }
	}
	private final var seriesGrouper: SampleGrouper? {
		didSet { seriesGrouperSet() }
	}
	/// need to reset y-axis if going between nil and some or vice-versa for pointGrouper
	private final var pointGrouperWasNil = true
	private final var pointGrouper: SampleGrouper? = nil {
		didSet { pointGrouperSet() }
	}
	private final var oldSampleType: Sample.Type!
	private final var sampleType: Sample.Type! {
		didSet { sampleTypeSet() }
	}
	private final var chartController: BasicXYChartViewController!

	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SingleSampleTypeGraphCreationPerformance"))
	private final let log = Log()

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		sampleType = DependencyInjector.sample.allTypes()[0]
		sampleTypePicker.dataSource = self
		sampleTypePicker.delegate = self

		observe(selector: #selector(xAxisChanged), name: .xAxisInformationChanged)
		observe(selector: #selector(yAxisChanged), name: .yAxisInformationChanged)
		observe(selector: #selector(queryChanged), name: .queryChanged)

		updateShowGraphButtonState()
	}

	// MARK: - Button Actions

	@IBAction final func seriesGroupingInfoButtonPressed(_ sender: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText = "This allows you to optionally group things into different data series. Each data series is drawn in its own color on the generated graph."
		present(controller, using: Me.presenter)
	}

	@IBAction final func chooseSeriesGroupingButtonPressed(_ sender: Any) {
		showGrouperEditController(
			grouper: seriesGrouper,
			editedCallback: #selector(seriesGrouperEdited),
			grouperName: "Series Grouping")
	}

	@IBAction final func clearSeriesGroupingButtonPressed(_ sender: Any) {
		seriesGrouper = nil
	}

	@IBAction final func pointGroupingInfoButtonPressed(_ sender: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText = "This allows grouping multiple samples into a single point based on group value (i.e. same day of week or same group name for advanced grouping)."
		present(controller, using: Me.presenter)
	}

	@IBAction final func choosePointGroupingButtonPressed(_ sender: Any) {
		showGrouperEditController(
			grouper: pointGrouper,
			editedCallback: #selector(pointGrouperEdited),
			grouperName: "Point Grouping")
	}

	@IBAction final func clearPointGroupingButtonPressed(_ sender: Any) {
		pointGrouper = nil
	}

	@IBAction final func clearQueryButtonPressed(_ sender: Any) {
		query = nil
	}

	@IBAction final func chooseQueryButtonPressed(_ sender: Any) {
		let controller = viewController(named: "queryView", fromStoryboard: "Query") as! QueryViewController
		controller.finishedButtonTitle = "Use Query"
		controller.topmostSampleType = sampleType
		controller.initialQuery = query
		controller.finishedButtonNotification = .queryChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func showGraph(_ sender: Any) {
		do {
			if query == nil {
				query = try DependencyInjector.query.queryFor(sampleType)
			}
			chartController = (viewController(named: "BasicXYChartViewController") as! BasicXYChartViewController)
			chartController.chartType = chartType
			chartController.queries = [query!]
			DispatchQueue.global(qos: .userInitiated).async {
				self.runQuery()
			}
			realNavigationController?.pushViewController(chartController, animated: false)
		} catch {
			log.error("Failed to get %@ query: %@", sampleType.name, errorInfo(error))
			showError(title: "You found a bug", error: error)
		}
	}

	@IBAction final func editXAxis(_ sender: Any) {
		let controller = viewController(named: "xAxisSetup") as! XAxisSetupViewController
		controller.attributes = sampleType.attributes
		controller.selectedAttribute = xAxis?.attribute
		controller.selectedInformation = xAxis?.information
		controller.grouped = pointGrouper != nil
		controller.usePointGroupValue = usePointGroupValueForXAxis
		controller.notificationToSendWhenFinished = .xAxisInformationChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func editYAxis(_ sender: Any) {
		if pointGrouper == nil {
			let controller = viewController(named: "chooseAttributes") as! ChooseAttributesToGraphTableViewController
			controller.allowedAttributes = sampleType.attributes.filter{ $0 is GraphableAttribute }
			controller.selectedAttributes = yAxis?.map{ $0.attribute! }
			controller.notificationToSendWhenFinished = .yAxisInformationChanged
			realNavigationController?.pushViewController(controller, animated: false)
		} else {
			let controller = viewController(named: "chooseInformation") as! ChooseInformationToGraphTableViewController
			controller.attributes = sampleType.attributes
			controller.limitToNumericInformation = true
			if let yAxis = yAxis {
				controller.chosenInformation = yAxis.map{ $0.information! }
			}
			controller.notificationToSendWhenFinished = .yAxisInformationChanged
			realNavigationController?.pushViewController(controller, animated: false)
		}
	}

	// MARK: - Received Notifications

	@objc private final func seriesGrouperEdited(notification: Notification) {
		stopObserving(.grouperEdited)
		if let grouper: SampleGrouper = value(for: .sampleGrouper, from: notification) {
			guard seriesGrouper != nil else {
				seriesGrouper = grouper
				return
			}
			// seriesGrouper can't be nil here
			guard !seriesGrouper!.equalTo(grouper) else { return }
			seriesGrouper = grouper
		}
	}

	@objc private final func pointGrouperEdited(notification: Notification) {
		stopObserving(.grouperEdited)
		if let grouper: SampleGrouper = value(for: .sampleGrouper, from: notification) {
			guard pointGrouper != nil else {
				pointGrouper = grouper
				return
			}
			// pointGrouper can't be nil here
			guard !pointGrouper!.equalTo(grouper) else { return }
			pointGrouper = grouper
		}
	}

	@objc private final func queryChanged(notification: Notification) {
		query = value(for: .query, from: notification)
	}

	@objc private final func xAxisChanged(notification: Notification) {
		if let attribute: Attribute? = value(for: .attribute, from: notification, keyIsOptional: true) {
			usePointGroupValueForXAxis = false
			xAxis = AttributeOrInformation(attribute: attribute)
		} else if let information: ExtraInformation? = value(for: .information, from: notification, keyIsOptional: true) {
			usePointGroupValueForXAxis = false
			xAxis = AttributeOrInformation(information: information)
		} else if let usePointGroupValue: Bool = value(for: .usePointGroupValue, from: notification) {
			usePointGroupValueForXAxis = usePointGroupValue
			xAxis = nil
		} else {
			log.error("Missing both optional attributes in x-axis setup notification")
		}
	}

	@objc private final func yAxisChanged(notification: Notification) {
		if let attributes: [Attribute] = value(for: .attributes, from: notification, keyIsOptional: true) {
			yAxis = attributes.map{ AttributeOrInformation(attribute: $0) }
		} else if let information: [ExtraInformation] = value(for: .information, from: notification, keyIsOptional: true) {
			yAxis = information.map{ AttributeOrInformation(information: $0) }
		} else {
			yAxis = nil
		}
	}

	// MARK: - Helper Functions

	private final func updateShowGraphButtonState() {
		showGraphButton.isEnabled =
			(
				(xAxis != nil && (xAxis.attribute != nil || xAxis.information != nil)) ||
				usePointGroupValueForXAxis
			) &&
			yAxis != nil &&
			!yAxis.isEmpty
		showGraphButton.backgroundColor = showGraphButton.isEnabled ? .black : .gray
	}

	private final func runQuery() {
		signpost.begin(name: "Query")
		if query == nil { log.error("Query was unexpectedly nil") }
		query?.resetStoppedState()
		query?.runQuery { (result, error) in
			self.signpost.end(name: "Query")
			if let error = error {
				self.log.error("Query run failed: %@", errorInfo(error))
				DispatchQueue.main.async {
					self.chartController.showError(title: "Failed to run the query", error: error)
				}
				return
			}
			if let samples = result?.samples {
				do {
					try self.updateChartData(samples)
				} catch {
					self.log.error("Failed to update chart data: %@", errorInfo(error))
					DispatchQueue.main.async {
						self.chartController.showError(title: "Failed to gather the required data", error: error)
					}
				}
			} else {
				self.log.error("Query run did not return an error or any results")
			}
		}
	}

	private final func updateChartData(_ samples: [Sample]) throws {
		signpost.begin(name: "Update Chart Data", "Number of samples: %d", samples.count)

		var allData = [Dictionary<String, Any>]()

		if let seriesGrouper = seriesGrouper {
			signpost.begin(name: "Grouping samples for series", "Grouping %d samples", samples.count)
			let seriesGroups = try seriesGrouper.group(samples: samples)
			signpost.end(name: "Grouping samples for series", "Grouped %d samples into %d groups", samples.count, seriesGroups.count)
			for (groupValue, samples) in seriesGroups {
				let groupName = try seriesGrouper.groupNameFor(value: groupValue)
				try addData(to: &allData, for: samples, as: groupName)
			}
		} else {
			try addData(to: &allData, for: samples)
		}

		DispatchQueue.main.async {
			self.chartController.dataSeries = allData
		}
	}

	private final func addData(
		to allData: inout [Dictionary<String, Any>],
		for samples: [Sample],
		as groupName: String? = nil)
	throws {
		if let pointGrouper = pointGrouper {
			let groups = try pointGrouper.group(samples: samples)
			allData.append(contentsOf: try getDataFor(groups: groups, groupedBy: pointGrouper, as: groupName))
		} else {
			let xValuesAreNumbers = xAxis.attribute is NumericAttribute
			for yAttribute in yAxis.map({ $0.attribute! }) {
				let data = try getSeriesDataFor(yAttribute, from: samples)
				var name = yAttribute.name
				if let groupName = groupName {
					name = "\(groupName): \(name)"
				}
				allData.append(AASeriesElement()
					.name(name)
					.data(data)
					.toDic()!)
			}

			DispatchQueue.main.async {
				self.chartController.displayXAxisValueLabels = xValuesAreNumbers
			}
		}
	}

	private final func getSeriesDataFor(_ yAttribute: Attribute, from samples: [Sample]) throws -> [[Any]] {
		let filteredSamples = try samples.filter{
			let xValue = try $0.graphableValue(of: self.xAxis.attribute!)
			if xValue == nil { return false }
			let yValue = try! $0.graphableValue(of: yAttribute)
			return yValue != nil
		}
		return try filteredSamples.map{ (sample: Sample) -> [Any] in
			let rawXValue = try sample.graphableValue(of: self.xAxis.attribute!)
			var xValue: Any = rawXValue as Any
			if !(xAxis.attribute is NumericAttribute) {
				xValue = try self.xAxis.attribute!.convertToDisplayableString(from: rawXValue)
			}
			return [xValue, try sample.graphableValue(of: yAttribute) as Any]
		}
	}

	private final func getDataFor(
		groups: [(Any, [Sample])],
		groupedBy grouper: SampleGrouper,
		as groupName: String? = nil)
	throws
	-> [Dictionary<String, Any>] {
		let xValues: [(groupValue: Any, sampleValue: String)]
		if usePointGroupValueForXAxis {
			xValues = try groups.map{ (groupValue: $0.0, sampleValue: try grouper.groupNameFor(value: $0.0)) }
		} else {
			xValues = try transform(sampleGroups: groups, information: xAxis.information!)
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

		var allData = [Dictionary<String, Any>]()
		for yInformation in yAxis.map({ $0.information! }) {
			var seriesData = [[Any]]()
			let yValues = try transform(sampleGroups: groups, information: yInformation)
			for (xGroupValue, xSampleValue) in sortedXValues { // loop over x values so that series data is already sorted
				if let yValueIndex = index(ofValue: xGroupValue, in: yValues, groupedBy: grouper) {
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

		return allData
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

	/// - Precondition: Samples array is not empty and no samples have invalid or nil value for given attribute
	private final func sortSamples(_ samples: [Sample], by attribute: Attribute) throws -> [Sample] {
		signpost.begin(name: "Sort samples", "Sorting %d sample by %@", samples.count, attribute.name)
		let sortedSamples = try samples.sorted(by: {
			if let attribute = attribute as? DoubleAttribute {
				let first = try $0.graphableValue(of: attribute) as! Double
				let second = try $1.graphableValue(of: attribute) as! Double
				return first < second
			}
			if let attribute = attribute as? IntegerAttribute {
				let first = try $0.graphableValue(of: attribute) as! Int
				let second = try $1.graphableValue(of: attribute) as! Int
				return first < second
			}
			if let attribute = attribute as? DateAttribute {
				let first = try $0.graphableValue(of: attribute) as! Date
				let second = try $1.graphableValue(of: attribute) as! Date
				return first < second
			}
			return true
		})
		signpost.end(name: "Sort samples")
		return sortedSamples
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

	private final func showGrouperEditController(
		grouper: SampleGrouper?,
		editedCallback: Selector,
		grouperName: String)
	{
		observe(selector: editedCallback, name: .grouperEdited)

		let controller = viewController(named: "chooseGrouper", fromStoryboard: "Util") as! GroupingChooserTableViewController
		controller.sampleType = sampleType
		controller.currentGrouper = grouper?.copy()
		controller.title = grouperName
		pushToNavigationController(controller)
	}

	// MARK: On Set Functions

	private final func querySet() {
		if query == nil {
			queryButton.setTitle("Choose query (optional)", for: .normal)
			DependencyInjector.util.ui.setButton(clearQueryButton, enabled: false, hidden: true)
		} else {
			queryButton.setTitle("Query chosen (click to change)", for: .normal)
			DependencyInjector.util.ui.setButton(clearQueryButton, enabled: true, hidden: false)
		}
		queryButton.accessibilityValue = queryButton.currentTitle
	}

	private final func xAxisSet() {
		if xAxis == nil {
			if usePointGroupValueForXAxis {
				xAxisButton.setTitle("X-Axis: Use point group value", for: .normal)
			} else {
				xAxisButton.setTitle("Choose x-axis information", for: .normal)
			}
		} else if let attribute = xAxis.attribute {
			xAxisButton.setTitle("X-Axis: " + attribute.name.localizedLowercase, for: .normal)
		} else if let information = xAxis.information {
			xAxisButton.setTitle("X-Axis: " + information.description.localizedLowercase, for: .normal)
		}
		xAxisButton.accessibilityValue = xAxisButton.currentTitle
		updateShowGraphButtonState()
	}

	private final func yAxisSet() {
		if yAxis == nil {
			yAxisButton.setTitle("Choose y-axis information", for: .normal)
		} else {
			var description = "Y-Axis: "
			for value in yAxis! {
				if let information = value.information {
					description += information.description.localizedLowercase + ", "
				} else if let attribute = value.attribute {
					description += attribute.name.localizedLowercase + ", "
				}
			}
			description.removeLast()
			description.removeLast()
			yAxisButton.setTitle(description, for: .normal)
		}
		yAxisButton.accessibilityValue = yAxisButton.currentTitle
		updateShowGraphButtonState()
	}

	private final func seriesGrouperSet() {
		if seriesGrouper != nil {
			chooseSeriesGrouperButton.setTitle("Series grouping chosen", for: .normal)
			DependencyInjector.util.ui.setButton(clearSeriesGrouperButton, enabled: true, hidden: false)
		} else {
			chooseSeriesGrouperButton.setTitle("Choose series grouping (optional)", for: .normal)
			DependencyInjector.util.ui.setButton(clearSeriesGrouperButton, enabled: false, hidden: true)
		}
		chooseSeriesGrouperButton.accessibilityValue = chooseSeriesGrouperButton.title(for: .normal)
	}

	private final func pointGrouperSet() {
		if pointGrouper != nil {
			choosePointGrouperButton.setTitle("Point grouping chosen", for: .normal)
			DependencyInjector.util.ui.setButton(clearPointGrouperButton, enabled: true, hidden: false)
			if pointGrouperWasNil {
				// old value of yAxis (if it exists) will be [Attribute] but [Information]
				// is needed when pointGrouper is provided
				yAxis = nil
				// old value of xAxis (if it exists) will be Attribute but Information
				// is needed when pointGrouper is not provided
				xAxis = nil
			}
		} else {
			choosePointGrouperButton.setTitle("Choose point grouping (optional)", for: .normal)
			DependencyInjector.util.ui.setButton(clearPointGrouperButton, enabled: false, hidden: true)
			if !pointGrouperWasNil {
				// old value of yAxis (if it exists) will be [Information] but [Attribute]
				// is needed when pointGrouper is not provided
				yAxis = nil
				// old value of xAxis (if it exists) will be Information but Attribute
				// is needed when pointGrouper is not provided
				xAxis = nil
			}
		}
		pointGrouperWasNil = pointGrouper == nil
		choosePointGrouperButton.accessibilityValue = choosePointGrouperButton.title(for: .normal)
	}

	private final func sampleTypeSet() {
		if oldSampleType != sampleType {
			query = nil
			xAxis = nil
			yAxis = nil
			seriesGrouper = nil
			pointGrouper = nil
		}
	}
}

// MARK: - UIPickerViewDataSource

extension SingleSampleTypeBasicXYGraphCustomizationViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return DependencyInjector.sample.allTypes().count
	}
}

// MARK: - UIPickerViewDelegate

extension SingleSampleTypeBasicXYGraphCustomizationViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return DependencyInjector.sample.allTypes()[row].name
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		sampleType = DependencyInjector.sample.allTypes()[row]
	}
}
