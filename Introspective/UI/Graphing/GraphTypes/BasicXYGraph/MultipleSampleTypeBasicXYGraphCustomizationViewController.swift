//
//  MultipleSampleTypeBasicXYGraphCustomizationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import AAInfographics
import os
import Presentr
import UIKit

import Common
import DependencyInjection
import Queries
import SampleGroupers
import SampleGroupInformation
import Samples
import UIExtensions

final class MultipleSampleTypeBasicXYGraphCustomizationViewController: BasicXYGraphTypeSetupViewController {
	// MARK: - Static Variables

	private typealias Me = MultipleSampleTypeBasicXYGraphCustomizationViewController

	// MARK: Presenters

	private static let presenter: Presentr = injected(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center
	)

	// MARK: Logging / Performance

	private static let signpost = Signpost(log: OSLog(
		subsystem: Bundle.main.bundleIdentifier!,
		category: "MultipleSampleTypeBasicXYGraphCustomizationViewController"
	))
	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var chooseXAxisSampleTypeButton: UIButton!
	@IBOutlet final var clearXAxisQueryButton: UIButton!
	@IBOutlet final var chooseXAxisQueryButton: UIButton!
	@IBOutlet final var chooseXAxisInformationButton: UIButton!

	@IBOutlet final var chooseYAxisSampleTypeButton: UIButton!
	@IBOutlet final var clearYAxisQueryButton: UIButton!
	@IBOutlet final var chooseYAxisQueryButton: UIButton!
	@IBOutlet final var chooseYAxisInformationButton: UIButton!

	@IBOutlet final var clearSeriesGroupingButton: UIButton!
	@IBOutlet final var chooseSeriesGroupingButton: UIButton!
	@IBOutlet final var choosePointGroupingButton: UIButton!
	@IBOutlet final var showGraphButton: UIButton!

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
	private final var seriesGroupers: MultipleSampleTypeXYGraphDataGenerator.Groupers? {
		didSet { seriesGrouperSet() }
	}

	private final var pointGrouperAttributeType: String?
	private final var pointGroupers: MultipleSampleTypeXYGraphDataGenerator.Groupers? {
		didSet { pointGrouperSet() }
	}

	private final var usePointGroupValueForXAxis = false
	private final var xAxisInformation: SampleGroupInformation? {
		didSet { xAxisInformationSet() }
	}

	private final var yAxisInformation: [SampleGroupInformation]? {
		didSet { yAxisInformationSet() }
	}

	private final var xAxisSamples: [Sample]! { didSet { samplesAssigned() } }
	private final var yAxisSamples: [Sample]! { didSet { samplesAssigned() } }
	private final var chartController: BasicXYChartViewController!

	// MARK: - UIViewController Overloads

	final override func viewDidLoad() {
		super.viewDidLoad()

		observe(selector: #selector(xAxisQueryChanged), name: .xAxisQueryChanged)
		observe(selector: #selector(yAxisQueryChanged), name: .yAxisQueryChanged)
		observe(selector: #selector(xAxisSampleTypeChanged), name: .xAxisSampleTypeChanged)
		observe(selector: #selector(yAxisSampleTypeChanged), name: .yAxisSampleTypeChanged)
		observe(selector: #selector(xAxisInformationChanged), name: .xAxisInformationChanged)
		observe(selector: #selector(yAxisInformationChanged), name: .yAxisInformationChanged)
		observe(selector: #selector(seriesGroupersChanged), name: .seriesGrouperEdited)
		observe(selector: #selector(pointGroupersChanged), name: .pointGrouperEdited)

		updateShowGraphButtonState()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Button Actions

	@IBAction final func clearSeriesGroupingButtonPressed(_: Any) {
		seriesGroupers = nil
	}

	@IBAction final func chooseSeriesGroupingButtonPressed(_: Any) {
		let controller = viewController(named: "chooseXYGroupers") as! ChooseGroupersForXYGraphViewController
		controller.xSampleType = xAxisSampleType
		controller.ySampleType = yAxisSampleType
		controller.navBarTitle = "Series Grouping"
		controller.xGrouper = seriesGroupers?.x.copy()
		controller.yGrouper = seriesGroupers?.y.copy()
		controller.currentAttributeType = seriesGrouperAttributeType
		controller.notificationToSendOnAccept = .seriesGrouperEdited
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func seriesGroupingInfoButtonPressed(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller
			.descriptionText =
			"This allows you to optionally group things into different data series. Each data series is drawn in its own color on the generated graph."
		present(controller, using: Me.presenter)
	}

	@IBAction final func choosePointGroupingButtonPressed(_: Any) {
		let controller = viewController(named: "chooseXYGroupers") as! ChooseGroupersForXYGraphViewController
		controller.xSampleType = xAxisSampleType
		controller.ySampleType = yAxisSampleType
		controller.navBarTitle = "Point Grouping"
		controller.xGrouper = pointGroupers?.x.copy()
		controller.yGrouper = pointGroupers?.y.copy()
		controller.currentAttributeType = pointGrouperAttributeType
		controller.notificationToSendOnAccept = .pointGrouperEdited
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func pointGroupingInfoButtonPressed(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller
			.descriptionText =
			"This is how the x-axis samples are connected to the y-axis samples. Groups from the x-axis samples are matched to groups from the y-axis samples based on group values (i.e. same day of week or same group name for advanced grouping). This allows you to connect two types of data that don't have the same attributes."
		present(controller, using: Me.presenter)
	}

	@IBAction final func chooseXAxisSampleTypeButtonPressed(_: Any) {
		let controller = viewController(
			named: "chooseSampleType",
			fromStoryboard: "Util"
		) as! ChooseSampleTypeViewController
		controller.selectedSampleType = xAxisSampleType
		controller.notificationToSendOnAccept = .xAxisSampleTypeChanged
		customPresentViewController(Me.presenter, viewController: controller, animated: false)
	}

	@IBAction final func clearXAxisQueryButtonPressed(_: Any) {
		xAxisQuery = nil
	}

	@IBAction final func chooseXAxisQueryButtonPressed(_: Any) {
		let controller = viewController(named: "queryView", fromStoryboard: "Query") as! QueryViewController
		controller.finishedButtonTitle = "Use Query"
		controller.topmostSampleType = xAxisSampleType
		controller.initialQuery = xAxisQuery
		controller.finishedButtonNotification = .xAxisQueryChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func chooseXAxisInformationButtonPressed(_: Any) {
		let controller = viewController(named: "xAxisSetup") as! XAxisSetupViewController
		controller.attributes = xAxisSampleType.attributes
		controller.selectedAttribute = xAxisInformation?.attribute
		controller.selectedInformation = xAxisInformation
		controller.grouped = true
		controller.usePointGroupValue = usePointGroupValueForXAxis
		controller.notificationToSendWhenFinished = .xAxisInformationChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func chooseYAxisSampleTypeButtonPressed(_: Any) {
		let controller = viewController(
			named: "chooseSampleType",
			fromStoryboard: "Util"
		) as! ChooseSampleTypeViewController
		controller.selectedSampleType = yAxisSampleType
		controller.notificationToSendOnAccept = .yAxisSampleTypeChanged
		customPresentViewController(Me.presenter, viewController: controller, animated: false)
	}

	@IBAction final func clearYAxisQueryButtonPressed(_: Any) {
		yAxisQuery = nil
	}

	@IBAction final func chooseYAxisQueryButtonPressed(_: Any) {
		let controller = viewController(named: "queryView", fromStoryboard: "Query") as! QueryViewController
		controller.finishedButtonTitle = "Use Query"
		controller.topmostSampleType = yAxisSampleType
		controller.initialQuery = yAxisQuery
		controller.finishedButtonNotification = .yAxisQueryChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func chooseYAxisInformationButtonPressed(_: Any) {
		let controller = viewController(named: "chooseInformation") as! ChooseInformationToGraphTableViewController
		controller.attributes = yAxisSampleType.attributes
		if let yAxisInformation = yAxisInformation {
			controller.chosenInformation = yAxisInformation
		}
		controller.notificationToSendWhenFinished = .yAxisInformationChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction final func showMeTheGraphButtonPressed(_: Any) {
		chartController = (viewController(named: "BasicXYChartViewController") as! BasicXYChartViewController)

		do {
			if xAxisQuery == nil {
				xAxisQuery = try injected(QueryFactory.self).queryFor(xAxisSampleType)
			}
			if yAxisQuery == nil {
				yAxisQuery = try injected(QueryFactory.self).queryFor(yAxisSampleType)
			}

			chartController.queries = [xAxisQuery!, yAxisQuery!]
			chartController.chartType = chartType
			DispatchQueue.global(qos: .userInteractive).async {
				self.runQueries()
			}
			realNavigationController?.pushViewController(chartController, animated: false)
		} catch {
			Me.log.error("Failed to get query: %@", errorInfo(error))
			showError(title: "You found a bug", error: error)
		}
	}

	// MARK: - Received Notifications

	@objc private final func seriesGroupersChanged(notification: Notification) {
		stopObserving(.groupersEdited)
		if
			let xGrouper: SampleGrouper? = value(for: .x, from: notification),
			let yGrouper: SampleGrouper? = value(for: .y, from: notification),
			let currentAttributeType: String? = value(for: .attribute, from: notification) {
			seriesGroupers = MultipleSampleTypeXYGraphDataGenerator.Groupers(x: xGrouper!, y: yGrouper!)
			seriesGrouperAttributeType = currentAttributeType
		}
	}

	@objc private final func pointGroupersChanged(notification: Notification) {
		stopObserving(.groupersEdited)
		if
			let xGrouper: SampleGrouper? = value(for: .x, from: notification),
			let yGrouper: SampleGrouper? = value(for: .y, from: notification),
			let currentAttributeType: String? = value(for: .attribute, from: notification) {
			pointGroupers = MultipleSampleTypeXYGraphDataGenerator.Groupers(x: xGrouper!, y: yGrouper!)
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
		if let information: SampleGroupInformation? = value(
			for: .information,
			from: notification,
			keyIsOptional: true
		) {
			usePointGroupValueForXAxis = false
			xAxisInformation = information
		} else if let _: Bool = value(for: .usePointGroupValue, from: notification) {
			usePointGroupValueForXAxis = true
			xAxisInformation = nil
		}
	}

	@objc private final func yAxisInformationChanged(notification: Notification) {
		if let information: [SampleGroupInformation] = value(for: .information, from: notification) {
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
		if #available(iOS 13.0, *) {
			showGraphButton.backgroundColor = showGraphButton.isEnabled ? .label : .systemGray
		} else {
			showGraphButton.backgroundColor = showGraphButton.isEnabled ? .black : .gray
		}
	}

	private final func runQueries() {
		xAxisQuery?.resetStoppedState()
		xAxisQuery!.runQuery { result, error in
			if let error = error {
				Me.log.error("X-axis query run failed: %@", errorInfo(error))
				DispatchQueue.main.async {
					self.chartController.showError(title: "Failed to run the x-axis query", error: error)
				}
				return
			}
			if let samples = result?.samples {
				self.xAxisSamples = samples
			} else {
				Me.log.error("X-axis query run did not return an error or any results")
			}
		}

		yAxisQuery?.resetStoppedState()
		yAxisQuery!.runQuery { result, error in
			if let error = error {
				Me.log.error("Y-axis query run failed: %@", errorInfo(error))
				DispatchQueue.main.async {
					self.chartController.showError(title: "Failed to run the y-axis query", error: error)
				}
				return
			}
			if let samples = result?.samples {
				self.yAxisSamples = samples
			} else {
				Me.log.error("Y-axis query run did not return an error or any results")
			}
		}
	}

	private final func samplesAssigned() {
		do {
			try updateChartData()
		} catch {
			Me.log.error("Failed to update chart data: %@", errorInfo(error))
			DispatchQueue.main.async {
				self.chartController.showError(title: "Failed to gather the required data", error: error)
			}
		}
	}

	private final func updateChartData() throws {
		guard let xAxisSamples = xAxisSamples, let yAxisSamples = yAxisSamples else { return }
		if xAxisSamples.isEmpty {
			DispatchQueue.main.async {
				self.chartController.showError(title: "No data returned for x-axis query")
			}
			return
		}
		if yAxisSamples.isEmpty {
			DispatchQueue.main.async {
				self.chartController.showError(title: "No data returned for y-axis query")
			}
			return
		}

		Me.signpost.begin(
			name: "Update Chart Data", "Number of samples: (x-axis: %d, y-axis: %d)",
			xAxisSamples.count,
			yAxisSamples.count
		)

		guard let yInformation = yAxisInformation else {
			throw GenericDisplayableError(title: "Must choose y-axis information")
		}

		guard let pointGroupers = pointGroupers else {
			throw GenericDisplayableError(
				title: "Unable to graph",
				description: "Must choose point grouping or there is no way to correlate x-axis to y-axis"
			)
		}

		let dataGenerator = MultipleSampleTypeXYGraphDataGenerator(
			seriesGroupers: seriesGroupers,
			pointGroupers: pointGroupers,
			xInformation: xAxisInformation,
			yInformation: yInformation,
			usePointGroupValueForXAxis: usePointGroupValueForXAxis
		)
		// leave this outside of DispatchQueue.main.async because it can take a while
		let allData = try dataGenerator.generateData(xSamples: xAxisSamples, ySamples: yAxisSamples)

		DispatchQueue.main.async {
			self.chartController.dataSeries = allData
		}

		Me.signpost.end(
			name: "Update Chart Data", "Number of samples: (x-axis: %d, y-axis: %d)",
			xAxisSamples.count,
			yAxisSamples.count
		)
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
			injected(UiUtil.self).setButton(clearXAxisQueryButton, enabled: false, hidden: true)
		} else {
			chooseXAxisQueryButton.setTitle("Query chosen (click to change)", for: .normal)
			injected(UiUtil.self).setButton(clearXAxisQueryButton, enabled: true, hidden: false)
		}
		chooseXAxisQueryButton.accessibilityValue = chooseXAxisQueryButton.currentTitle
	}

	private final func yAxisQuerySet() {
		if yAxisQuery == nil {
			chooseYAxisQueryButton.setTitle("Choose query (optional)", for: .normal)
			injected(UiUtil.self).setButton(clearYAxisQueryButton, enabled: false, hidden: true)
		} else {
			chooseYAxisQueryButton.setTitle("Query chosen (click to change)", for: .normal)
			injected(UiUtil.self).setButton(clearYAxisQueryButton, enabled: true, hidden: false)
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
			injected(UiUtil.self).setButton(clearSeriesGroupingButton, enabled: false, hidden: true)
		} else {
			chooseSeriesGroupingButton.setTitle("Series grouping chosen", for: .normal)
			injected(UiUtil.self).setButton(clearSeriesGroupingButton, enabled: true, hidden: false)
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
