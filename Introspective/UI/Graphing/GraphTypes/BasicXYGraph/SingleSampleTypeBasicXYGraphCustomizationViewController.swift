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
	private static let xAxisChanged = Notification.Name("xAxisChanged")
	private static let yAxisChanged = Notification.Name("yAxisChanged")
	private static let queryChanged = Notification.Name("queryChanged")
	private static let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var sampleTypePicker: UIPickerView!
	@IBOutlet weak final var queryButton: UIButton!
	@IBOutlet weak final var xAxisButton: UIButton!
	@IBOutlet weak final var yAxisButton: UIButton!
	@IBOutlet weak final var showGraphButton: UIButton!
	@IBOutlet weak final var clearQueryButton: UIButton!

	// MARK: - Instance Variables

	private final var query: Query? {
		didSet {
			if query == nil {
				queryButton.setTitle("Choose query (optional)", for: .normal)
				DependencyInjector.util.ui.setButton(clearQueryButton, enabled: false, hidden: true)
			} else {
				queryButton.setTitle("Query chosen (click to change)", for: .normal)
				DependencyInjector.util.ui.setButton(clearQueryButton, enabled: true, hidden: false)
			}
			queryButton.accessibilityValue = queryButton.currentTitle
		}
	}
	private final var xAxis: AttributeOrInformation! {
		didSet {
			if xAxis == nil {
				xAxisButton.setTitle("Choose x-axis information", for: .normal)
				yAxis = nil
				DependencyInjector.util.ui.setButton(yAxisButton, enabled: false)
			} else if let attribute = xAxis.attribute {
				xAxisButton.setTitle("X-Axis: " + attribute.name.localizedLowercase, for: .normal)
				DependencyInjector.util.ui.setButton(yAxisButton, enabled: true)
			} else if let information = xAxis.information {
				var text = information.description.localizedLowercase
				if grouping != nil {
					text += " per " + grouping!.description.localizedLowercase
				}
				xAxisButton.setTitle("X-Axis: " + text, for: .normal)
				DependencyInjector.util.ui.setButton(yAxisButton, enabled: true)
			}
			xAxisButton.accessibilityValue = xAxisButton.currentTitle
			updateShowGraphButtonState()
		}
	}
	private final var yAxis: [AttributeOrInformation]! {
		didSet {
			if yAxis == nil {
				yAxisButton.setTitle("Choose y-axis information", for: .disabled)
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
	}
	private final var grouping: Calendar.Component!
	private final var oldSampleType: Sample.Type!
	private final var sampleType: Sample.Type! {
		didSet {
			if oldSampleType != sampleType {
				query = nil
				xAxis = nil
				yAxis = nil
				grouping = nil
			}
		}
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

		observe(selector: #selector(xAxisChanged), name: Me.xAxisChanged)
		observe(selector: #selector(yAxisChanged), name: Me.yAxisChanged)
		observe(selector: #selector(queryChanged), name: Me.queryChanged)

		updateShowGraphButtonState()
	}

	// MARK: - Button Actions

	@IBAction final func clearQueryButtonPressed(_ sender: Any) {
		query = nil
	}

	@IBAction final func chooseQueryButtonPressed(_ sender: Any) {
		let controller: QueryViewController = viewController(named: "queryView", fromStoryboard: "Query")
		controller.finishedButtonTitle = "Use Query"
		controller.topmostSampleType = sampleType
		controller.finishedButtonNotification = Me.queryChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func showGraph(_ sender: Any) {
		do {
			if query == nil {
				query = try DependencyInjector.query.queryFor(sampleType)
			}
			chartController = viewController(named: "BasicXYChartViewController")
			chartController.chartType = chartType
			chartController.queries = [query!]
			DispatchQueue.global(qos: .userInitiated).async {
				self.runQuery()
			}
			realNavigationController?.pushViewController(chartController, animated: false)
		} catch {
			log.error("Failed to get %@ query: %@", sampleType.name, errorInfo(error))
			showError(title: "You found a bug", message: "Sorry for the inconvenience.")
		}
	}

	@IBAction final func editXAxis(_ sender: Any) {
		let controller: XAxisSetupViewController = viewController(named: "xAxisSetup")
		controller.attributes = sampleType.attributes
		controller.selectedAttribute = xAxis?.attribute
		controller.selectedInformation = xAxis?.information
		controller.grouping = grouping
		controller.notificationToSendWhenFinished = Me.xAxisChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func editYAxis(_ sender: Any) {
		if grouping == nil {
			let controller: ChooseAttributesToGraphTableViewController = viewController(named: "chooseAttributes")
			controller.allowedAttributes = sampleType.attributes.filter{ $0 is NumericAttribute || $0 is DurationAttribute }
			controller.selectedAttributes = yAxis?.map{ $0.attribute! }
			controller.notificationToSendWhenFinished = Me.yAxisChanged
			realNavigationController?.pushViewController(controller, animated: false)
		} else {
			let controller: ChooseInformationToGraphTableViewController = viewController(named: "chooseInformation")
			controller.attributes = sampleType.attributes
			controller.limitToNumericInformation = true
			controller.chosenInformation = yAxis?.map{ $0.information! }
			controller.notificationToSendWhenFinished = Me.yAxisChanged
			realNavigationController?.pushViewController(controller, animated: false)
		}
	}

	// MARK: - Received Notifications

	@objc private final func queryChanged(notification: Notification) {
		query = value(for: .query, from: notification)
	}

	@objc private final func xAxisChanged(notification: Notification) {
		grouping = value(for: .calendarComponent, from: notification)
		if let attribute: Attribute? = value(for: .attribute, from: notification, keyIsOptional: true) {
			xAxis = AttributeOrInformation(attribute: attribute)
		} else if let information: ExtraInformation? = value(for: .information, from: notification, keyIsOptional: true) {
			xAxis = AttributeOrInformation(information: information)
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
			xAxis != nil &&
			(xAxis.attribute != nil || xAxis.information != nil) &&
			yAxis != nil &&
			!yAxis.isEmpty
		showGraphButton.backgroundColor = showGraphButton.isEnabled ? .black : .gray
	}

	private final func runQuery() {
		signpost.begin(name: "Query")
		if query == nil { log.error("Query was unexpectedly nil") }
		query?.runQuery { (result, error) in
			self.signpost.end(name: "Query")
			if let error = error {
				self.log.error("Query run failed: %@", errorInfo(error))
				DispatchQueue.main.async {
					if let displayableError = error as? DisplayableError {
						self.chartController.errorMessage = displayableError.displayableDescription
					} else {
						self.chartController.errorMessage = "Something went wrong while running the query. Sorry for the inconvenience this has caused you."
					}
				}
				return
			}
			if let samples = result?.samples {
				do {
					try self.updateChartData(samples)
				} catch {
					self.log.error("Failed to update chart data: %@", errorInfo(error))
					self.chartController.errorMessage = "Something went wrong while gathering the required data"
				}
			} else {
				self.log.error("Query run did not return an error or any results")
			}
		}
	}

	private final func firstDateAttributeFor(_ sampleType: Sample.Type) -> DateAttribute {
		if let index = sampleType.attributes.index(where: { $0 is DateAttribute }) {
			return sampleType.attributes[index] as! DateAttribute
		}
		log.error("No DateAttribute found for sample type: %@", String(describing: sampleType))
		return CommonSampleAttributes.timestamp
	}

	private final func updateChartData(_ samples: [Sample]) throws {
		signpost.begin(name: "Update Chart Data", "Number of samples: %d", samples.count)

		var allData = [Dictionary<String, Any>]()
		var xValuesAreNumbers: Bool
		if grouping != nil {
			let grouper = SameTimeUnitSampleGrouper(grouping!)
			signpost.begin(name: "Grouping samples", "Grouping %d samples", samples.count)
			let groups = try grouper.group(samples: samples, by: firstDateAttributeFor(type(of: samples[0]))) as! [(Date, [Sample])]
			signpost.end(name: "Grouping samples", "Grouped %d samples into %d groups", samples.count, groups.count)

			let xValues = try transform(sampleGroups: groups, information: xAxis.information!)
			xValuesAreNumbers = areAllNumbers(xValues.map{ $0.sampleValue })
			// if x values are numbers or dates and are not sorted, graph will look very weird
			var sortedXValues = xValues
			if xValuesAreNumbers {
				sortedXValues = sortXValuesByNumber(xValues)
			} else if areAllDates(xValues.map{ $0.sampleValue }) {
				sortedXValues = sortXValuesByDate(xValues)
			}

			signpost.begin(name: "Creating series data", "Creating %d series", yAxis.count)
			for yInformation in yAxis.map({ $0.information! }) {
				signpost.begin(name: "Computing data points for information", idObject: yInformation as AnyObject, "%@", yInformation.description)
				let yValues = try transform(sampleGroups: groups, information: yInformation)
				var seriesData = [[Any]]()
				for (xGroupValue, xSampleValue) in sortedXValues { // loop over x values so that series data is already sorted
					if let yValueIndex = yValues.index(where: { $0.groupValue == xGroupValue }) {
						let yValue = yValues[yValueIndex].sampleValue
						var xValue: Any = xSampleValue
						if xValuesAreNumbers {
							xValue = Double(formatNumber(xSampleValue))!
						}
						seriesData.append([xValue, Double(formatNumber(yValue))!])
					}
				}
				allData.append(AASeriesElement()
					.name(yInformation.description.localizedCapitalized)
					.data(seriesData)
					.toDic()!)
				signpost.end(name: "Computing data points for information", idObject: yInformation as AnyObject, "%@", yInformation.description)
			}
			signpost.end(name: "Creating series data")
		} else {
			xValuesAreNumbers = xAxis.attribute! is NumericAttribute || xAxis.attribute! is DurationAttribute

			var sortedSamples = try samples.filter{ try $0.graphableValue(of: xAxis.attribute!) != nil }
			// if x values are numbers or dates and are not sorted, graph will look very weird
			if xValuesAreNumbers || xAxis.attribute! is DateAttribute {
				sortedSamples = try sortSamples(sortedSamples, by: xAxis.attribute!)
			}

			for yAttribute in yAxis.map({ $0.attribute! }) {
				let filteredSamples = try sortedSamples.filter{
					let yValue = try $0.graphableValue(of: yAttribute)
					return yValue != nil
				}
				let data = try filteredSamples.map({ (sample: Sample) -> [Any] in
					let rawXValue = try sample.graphableValue(of: self.xAxis.attribute!)
					var xValue: Any = rawXValue as Any
					if !xValuesAreNumbers {
						xValue = try self.xAxis.attribute!.convertToDisplayableString(from: rawXValue)
					}
					return [xValue, try sample.graphableValue(of: yAttribute) as Any]
				})
				allData.append(AASeriesElement()
					.name(yAttribute.name)
					.data(data)
					.toDic()!)
			}
		}
		DispatchQueue.main.async {
			self.chartController.displayXAxisValueLabels = xValuesAreNumbers
			self.chartController.dataSeries = allData
		}

		signpost.end(name: "Update Chart Data", "Finished updating chart data")
	}

	private final func transform(sampleGroups: [(Date, [Sample])], information: ExtraInformation)
	throws -> [(groupValue: Date, sampleValue: String)] {
		signpost.begin(name: "Transform", "Number of sample groups: %d", sampleGroups.count)
		var values = [(groupValue: Date, sampleValue: String)]()
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

	private final func sortXValuesByNumber(_ xValues: [(groupValue: Date, sampleValue: String)]) -> [(groupValue: Date, sampleValue: String)] {
		var sortedXValues = xValues
		signpost.begin(name: "Sort x values as numbers", "Number of x values: %d", xValues.count)
		sortedXValues = xValues.sorted(by: { Double($0.sampleValue)! < Double($1.sampleValue)! })
		signpost.end(name: "Sort x values as numbers")
		return sortedXValues
	}

	/// - Precondition: All sample values are valid date strings
	private final func sortXValuesByDate(_ xValues: [(groupValue: Date, sampleValue: String)]) -> [(groupValue: Date, sampleValue: String)] {
		var sortedXValues = xValues
		signpost.begin(name: "Sort x values as dates", "Number of x values: %d", xValues.count)
		sortedXValues = xValues.sorted(by: { getDate($0.sampleValue)! < getDate($1.sampleValue)! })
		signpost.end(name: "Sort x values as dates")
		return sortedXValues
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


