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
	private static let yAxisInformationChanged = Notification.Name("chosenDataToGraphChanged")
	private static let xAxisSampleTypeChanged = Notification.Name("xAxisSampleTypeChanged")
	private static let yAxisSampleTypeChanged = Notification.Name("yAxisSampleTypeChanged")
	private static let xAxisQueryChanged = Notification.Name("xAxisQueryChanged")
	private static let yAxisQueryChanged = Notification.Name("yAxisQueryChanged")
	private static let groupingChanged = Notification.Name("xAxisGroupingChanged")
	private static let xAxisInformationChanged = Notification.Name("xAxisInformationChanged")
	private static let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var chooseXAxisSampleTypeButton: UIButton!
	@IBOutlet weak final var clearXAxisQueryButton: UIButton!
	@IBOutlet weak final var chooseXAxisQueryButton: UIButton!
	@IBOutlet weak final var chooseXAxisInformationButton: UIButton!

	@IBOutlet weak final var chooseYAxisSampleTypeButton: UIButton!
	@IBOutlet weak final var clearYAxisQueryButton: UIButton!
	@IBOutlet weak final var chooseYAxisQueryButton: UIButton!
	@IBOutlet weak final var chooseYAxisInformationButton: UIButton!

	@IBOutlet weak final var chooseGroupingButton: UIButton!
	@IBOutlet weak var showGraphButton: UIButton!

	// MARK: - Instance Variables

	private final var oldXAxisSampleType: Sample.Type!
	private final var xAxisSampleType: Sample.Type! {
		didSet {
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
		}
	}
	private final var oldYAxisSampleType: Sample.Type!
	private final var yAxisSampleType: Sample.Type! {
		didSet {
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
		}
	}
	private final var xAxisQuery: Query? {
		didSet {
			if xAxisQuery == nil {
				chooseXAxisQueryButton.setTitle("Choose query (optional)", for: .normal)
				DependencyInjector.util.ui.setButton(clearXAxisQueryButton, enabled: false, hidden: true)
			} else {
				chooseXAxisQueryButton.setTitle("Query chosen (click to change)", for: .normal)
				DependencyInjector.util.ui.setButton(clearXAxisQueryButton, enabled: true, hidden: false)
			}
			chooseXAxisQueryButton.accessibilityValue = chooseXAxisQueryButton.currentTitle
		}
	}
	private final var yAxisQuery: Query? {
		didSet {
			if yAxisQuery == nil {
				chooseYAxisQueryButton.setTitle("Choose query (optional)", for: .normal)
				DependencyInjector.util.ui.setButton(clearYAxisQueryButton, enabled: false, hidden: true)
			} else {
				chooseYAxisQueryButton.setTitle("Query chosen (click to change)", for: .normal)
				DependencyInjector.util.ui.setButton(clearYAxisQueryButton, enabled: true, hidden: false)
			}
			chooseYAxisQueryButton.accessibilityValue = chooseYAxisQueryButton.currentTitle
		}
	}
	private final var grouping: Calendar.Component? {
		didSet {
			if grouping != nil {
				chooseGroupingButton.setTitle("Group by same " + grouping!.description.localizedLowercase, for: .normal)
			}
			chooseGroupingButton.accessibilityValue = chooseGroupingButton.currentTitle
			updateShowGraphButtonState()
		}
	}
	private final var xAxisInformation: ExtraInformation? {
		didSet {
			if xAxisInformation == nil {
				chooseXAxisInformationButton.setTitle("Choose information", for: .normal)
			} else {
				chooseXAxisInformationButton.setTitle(xAxisInformation!.description.localizedLowercase, for: .normal)
			}
			chooseXAxisInformationButton.accessibilityValue = chooseXAxisInformationButton.currentTitle
			updateShowGraphButtonState()
		}
	}
	private final var yAxisInformation: [ExtraInformation]? {
		didSet {
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
	}
	private final var xAxisSampleGroups: [(Date, [Sample])]! { didSet { sampleGroupsAssigned() } }
	private final var yAxisSampleGroups: [(Date, [Sample])]! { didSet { sampleGroupsAssigned() } }
	private final var chartController: BasicXYChartViewController!

	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MultiplSampleTypeGraphCreationPerformance"))
	private final let log = Log()

	// MARK: - UIViewController Overloads

	final override func viewDidLoad() {
		super.viewDidLoad()

		observe(selector: #selector(groupingChanged), name: Me.groupingChanged)
		observe(selector: #selector(xAxisQueryChanged), name: Me.xAxisQueryChanged)
		observe(selector: #selector(yAxisQueryChanged), name: Me.yAxisQueryChanged)
		observe(selector: #selector(xAxisSampleTypeChanged), name: Me.xAxisSampleTypeChanged)
		observe(selector: #selector(yAxisSampleTypeChanged), name: Me.yAxisSampleTypeChanged)
		observe(selector: #selector(xAxisInformationChanged), name: Me.xAxisInformationChanged)
		observe(selector: #selector(yAxisInformationChanged), name: Me.yAxisInformationChanged)

		updateShowGraphButtonState()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Button Actions

	@IBAction final func chooseGroupingButtonPressed(_ sender: Any) {
		// TODO - limit the available calendar components to ones that will produce a date (e.g. exclude .dayOfWeek)
		let controller: ChooseCalendarComponentViewController = viewController(named: "chooseCalendarComponent", fromStoryboard: "Util")
		controller.selectedComponent = grouping
		controller.notificationToSendOnAccept = Me.groupingChanged
		customPresentViewController(Me.presenter, viewController: controller, animated: false)
	}

	@IBAction final func chooseXAxisSampleTypeButtonPressed(_ sender: Any) {
		let controller: ChooseSampleTypeViewController = viewController(named: "chooseSampleType", fromStoryboard: "Util")
		controller.selectedSampleType = xAxisSampleType
		controller.notificationToSendOnAccept = Me.xAxisSampleTypeChanged
		customPresentViewController(Me.presenter, viewController: controller, animated: false)
	}

	@IBAction final func clearXAxisQueryButtonPressed(_ sender: Any) {
		xAxisQuery = nil
	}

	@IBAction final func chooseXAxisQueryButtonPressed(_ sender: Any) {
		let controller: QueryViewController = viewController(named: "queryView", fromStoryboard: "Query")
		// TODO - support passing in existing query
		controller.finishedButtonTitle = "Use Query"
		controller.topmostSampleType = xAxisSampleType
		controller.finishedButtonNotification = Me.xAxisQueryChanged
		realNavigationController!.pushViewController(controller, animated: false)
	}

	@IBAction final func chooseXAxisInformationButtonPressed(_ sender: Any) {
		let controller: SelectExtraInformationViewController = viewController(named: "editExtraInformation", fromStoryboard: "Util")
		controller.attributes = xAxisSampleType.attributes
		controller.selectedAttribute = xAxisInformation?.attribute
		controller.selectedInformation = xAxisInformation
		controller.notificationToSendWhenFinished = Me.xAxisInformationChanged
		realNavigationController!.pushViewController(controller, animated: false)
	}

	@IBAction final func chooseYAxisSampleTypeButtonPressed(_ sender: Any) {
		let controller: ChooseSampleTypeViewController = viewController(named: "chooseSampleType", fromStoryboard: "Util")
		controller.selectedSampleType = yAxisSampleType
		controller.notificationToSendOnAccept = Me.yAxisSampleTypeChanged
		customPresentViewController(Me.presenter, viewController: controller, animated: false)
	}

	@IBAction final func clearYAxisQueryButtonPressed(_ sender: Any) {
		yAxisQuery = nil
	}

	@IBAction final func chooseYAxisQueryButtonPressed(_ sender: Any) {
		let controller: QueryViewController = viewController(named: "queryView", fromStoryboard: "Query")
		// TODO - support passing in existing query
		controller.finishedButtonTitle = "Use Query"
		controller.topmostSampleType = yAxisSampleType
		controller.finishedButtonNotification = Me.yAxisQueryChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func chooseYAxisInformationButtonPressed(_ sender: Any) {
		let controller: ChooseInformationToGraphTableViewController = viewController(named: "chooseInformation")
		controller.attributes = yAxisSampleType.attributes
		controller.chosenInformation = yAxisInformation
		controller.notificationToSendWhenFinished = Me.yAxisInformationChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func showMeTheGraphButtonPressed(_ sender: Any) {
		chartController = viewController(named: "BasicXYChartViewController")

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
			realNavigationController!.pushViewController(chartController, animated: false)
		} catch {
			log.error("Failed to get query: %@", errorInfo(error))
			showError(title: "You found a bug", error: error)
		}
	}

	// MARK: - Received Notifications

	@objc private final func groupingChanged(notification: Notification) {
		if let grouping: Calendar.Component = value(for: .calendarComponent, from: notification) {
			self.grouping = grouping
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
		if let information: ExtraInformation? = value(for: .information, from: notification) {
			xAxisInformation = information
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
			xAxisInformation != nil &&
			yAxisInformation != nil &&
			grouping != nil
		showGraphButton.backgroundColor = showGraphButton.isEnabled ? .black : .gray
	}

	private final func runQueries() {
		xAxisQuery!.runQuery { (result, error) in
			if let error = error {
				self.log.error("X-axis query run failed: %@", errorInfo(error))
				DispatchQueue.main.async {
					self.chartController.errorMessage = "Something went wrong while running the query. Sorry for the inconvenience this has caused you."
				}
				return
			}
			if let samples = result?.samples {
				self.signpost.begin(name: "Grouping x-axis samples", "Grouping %d samples", samples.count)
				let grouper = SameTimeUnitSampleGrouper(self.grouping!)
				let firstDateAttribute = self.firstDateAttributeFor(self.xAxisSampleType)
				do {
					self.xAxisSampleGroups = (try grouper.group(samples: samples, by: firstDateAttribute) as! [(Date, [Sample])])
				} catch {
					self.log.error("Failed to group x-axis samples: %@", errorInfo(error))
					var message = "Something went wrong while trying to group the x-axis samples. Sorry for the inconvenience."
					if let error = error as? DisplayableError {
						message = error.displayableTitle
						if let description = error.displayableDescription {
							message += ". \(description)"
						}
					}
					self.chartController.errorMessage = message
				}
				self.signpost.end(name: "Grouping x-axis samples", "Grouped %d samples into %d groups", samples.count, self.xAxisSampleGroups.count)
			} else {
				self.log.error("X-axis query run did not return an error or any results")
			}
		}

		yAxisQuery!.runQuery { (result, error) in
			if let error = error {
				self.log.error("Y-axis query run failed: %@", errorInfo(error))
				DispatchQueue.main.async {
					self.chartController.errorMessage = "Something went wrong while running the query. Sorry for the inconvenience this has caused you."
				}
				return
			}
			if let samples = result?.samples {
				self.signpost.begin(name: "Grouping y-axis samples", "Grouping %d samples", samples.count)
				let grouper = SameTimeUnitSampleGrouper(self.grouping!)
				let firstDateAttribute = self.firstDateAttributeFor(self.yAxisSampleType)
				do {
					self.yAxisSampleGroups = (try grouper.group(samples: samples, by: firstDateAttribute) as! [(Date, [Sample])])
				} catch {
					self.log.error("Failed to group y-axis samples: %@", errorInfo(error))
					var message = "Something went wrong while trying to group the y-axis samples. Sorry for the inconvenience."
					if let error = error as? DisplayableError {
						message = error.displayableTitle
						if let description = error.displayableDescription {
							message += ". \(description)"
						}
					}
					self.chartController.errorMessage = message
				}
				self.signpost.end(name: "Grouping y-axis samples", "Grouped %d samples into %d groups", samples.count, self.yAxisSampleGroups.count)
			} else {
				self.log.error("Y-axis query run did not return an error or any results")
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

	private final func sampleGroupsAssigned() {
		do {
			try updateChartData()
		} catch {
			log.error("Failed to update chart data: %@", errorInfo(error))
			var message = "Something went wrong while gathering the required data"
			if let error = error as? DisplayableError {
				message = error.displayableTitle
				if let description = error.displayableDescription {
					message += ". \(description)"
				}
			}
			chartController.errorMessage = message
		}
	}

	private final func updateChartData() throws {
		if xAxisSampleGroups == nil || yAxisSampleGroups == nil { return }
		if xAxisSampleGroups.count == 0 {
			DispatchQueue.main.async { self.chartController.errorMessage = "No data returned for x-axis query" }
			return
		}
		if yAxisSampleGroups.count == 0 {
			DispatchQueue.main.async { self.chartController.errorMessage = "No data returned for y-axis query" }
			return
		}

		signpost.begin(name: "Update Chart Data", "Number of groups: (x-axis: %d, y-axis: %d)", xAxisSampleGroups.count, yAxisSampleGroups.count)

		let xValues = try transform(sampleGroups: xAxisSampleGroups, information: xAxisInformation!)
		let xValuesAreNumbers = areAllNumbers(xValues.map{ $0.sampleValue })
		var sortedXValues = xValues
		// if x values are numbers or dates and are not sorted, graph will look very weird
		if xValuesAreNumbers {
			sortedXValues = sortXValuesByNumber(xValues)
		} else if areAllDates(xValues.map{ $0.sampleValue }) {
			sortedXValues = sortXValuesByDate(xValues)
		}

		signpost.begin(name: "Creating series data", "Creating %d series", yAxisInformation!.count)
		var allData = [Dictionary<String, Any>]()
		for yInformation in yAxisInformation! {
			signpost.begin(name: "Computing data points for information", idObject: yInformation as AnyObject, "%@", yInformation.description)
			let yValues = try transform(sampleGroups: yAxisSampleGroups, information: yInformation)
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
}

