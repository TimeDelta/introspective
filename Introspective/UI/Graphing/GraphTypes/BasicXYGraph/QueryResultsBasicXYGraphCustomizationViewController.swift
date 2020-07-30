//
//  QueryResultsBasicXYGraphCustomizationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import AAInfographics
import os
import Presentr
import UIKit

import Attributes
import Common
import DependencyInjection
import SampleGroupers
import SampleGroupInformation
import Samples

final class QueryResultsBasicXYGraphCustomizationViewController: BasicXYGraphTypeSetupViewController,
	QueryResultsGraphCustomizationViewController {
	// MARK: - Static Variables

	private typealias Me = QueryResultsBasicXYGraphCustomizationViewController

	// MARK: Presenters

	private static let aggregationChanged = Notification.Name("aggregationChanged")
	private static let presenter: Presentr = DependencyInjector.get(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center
	)

	// MARK: Logging / Performance

	private static let log = Log()
	private static let signpost =
		Signpost(log: OSLog(
			subsystem: Bundle.main.bundleIdentifier!,
			category: "QueryResultsBasicXYGraphCustomizationViewController"
		))

	// MARK: - IBOutlets

	@IBOutlet final var clearSeriesGrouperButton: UIButton!
	@IBOutlet final var chooseSeriesGrouperButton: UIButton!
	@IBOutlet final var clearPointGrouperButton: UIButton!
	@IBOutlet final var choosePointGrouperButton: UIButton!
	@IBOutlet final var xAxisButton: UIButton!
	@IBOutlet final var yAxisButton: UIButton!
	@IBOutlet final var showGraphButton: UIButton!

	// MARK: - Instance Variables

	public final var samples: [Sample]!

	private final var usePointGroupValueForXAxis = false
	private final var xAxis: SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation! {
		didSet { xAxisSet() }
	}

	private final var yAxis: [SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation]! {
		didSet { yAxisSet() }
	}

	private final var seriesGrouper: SampleGrouper? {
		didSet { seriesGrouperSet() }
	}

	/// need to reset y-axis if going between nil and some or vice-versa for pointGrouper
	private final var pointGrouperWasNil = true
	private final var pointGrouper: SampleGrouper? {
		didSet { pointGrouperSet() }
	}

	private final var chartController: BasicXYChartViewController!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		NotificationCenter.default.removeObserver(self)

		observe(selector: #selector(xAxisChanged), name: .xAxisInformationChanged)
		observe(selector: #selector(yAxisChanged), name: .yAxisInformationChanged)
		observe(selector: #selector(seriesGrouperEdited), name: .seriesGrouperEdited)
		observe(selector: #selector(pointGrouperEdited), name: .pointGrouperEdited)

		updateShowGraphButtonState()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Button Actions

	@IBAction final func seriesGroupingInfoButtonPressed(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller
			.descriptionText =
			"This allows you to optionally group things into different data series. Each data series is drawn in its own color on the generated graph."
		present(controller, using: Me.presenter)
	}

	@IBAction final func chooseSeriesGroupingButtonPressed(_: Any) {
		showGrouperEditController(
			grouper: seriesGrouper,
			notificationToSendOnAccept: .seriesGrouperEdited,
			grouperName: "Series Grouping"
		)
	}

	@IBAction final func clearSeriesGroupingButtonPressed(_: Any) {
		seriesGrouper = nil
	}

	@IBAction final func pointGroupingInfoButtonPressed(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller
			.descriptionText =
			"This allows grouping multiple samples into a single point based on group value (i.e. same day of week or same group name for advanced grouping)."
		present(controller, using: Me.presenter)
	}

	@IBAction final func choosePointGroupingButtonPressed(_: Any) {
		showGrouperEditController(
			grouper: pointGrouper,
			notificationToSendOnAccept: .pointGrouperEdited,
			grouperName: "Point Grouping"
		)
	}

	@IBAction final func clearPointGroupingButtonPressed(_: Any) {
		pointGrouper = nil
	}

	@IBAction func editXAxis(_: Any) {
		let controller = viewController(named: "xAxisSetup") as! XAxisSetupViewController
		controller.attributes = samples[0].attributes
		controller.selectedAttribute = xAxis?.attribute
		controller.selectedInformation = xAxis?.information
		controller.grouped = pointGrouper != nil
		controller.usePointGroupValue = usePointGroupValueForXAxis
		controller.notificationToSendWhenFinished = .xAxisInformationChanged
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction func editYAxis(_: Any) {
		if pointGrouper == nil {
			let controller = viewController(named: "chooseAttributes") as! ChooseAttributesToGraphTableViewController
			controller.allowedAttributes = samples[0].attributes.filter { $0 is GraphableAttribute }
			controller.selectedAttributes = yAxis?.map { $0.attribute! }
			controller.notificationToSendWhenFinished = .yAxisInformationChanged
			realNavigationController?.pushViewController(controller, animated: false)
		} else {
			let controller = viewController(named: "chooseInformation") as! ChooseInformationToGraphTableViewController
			controller.attributes = type(of: samples[0]).attributes
			controller.limitToNumericInformation = true
			if let yAxis = yAxis {
				controller.chosenInformation = yAxis.map { $0.information! }
			}
			controller.notificationToSendWhenFinished = .yAxisInformationChanged
			realNavigationController?.pushViewController(controller, animated: false)
		}
	}

	@IBAction final func showGraph(_: Any) {
		chartController = (viewController(named: "BasicXYChartViewController") as! BasicXYChartViewController)
		chartController.chartType = chartType
		DispatchQueue.global(qos: .userInitiated).async {
			do {
				try self.updateChartData()
			} catch {
				Me.log.error("Failed to update chart data: %@", errorInfo(error))
				DispatchQueue.main.async {
					self.chartController.showError(title: "Failed to gather required data", error: error)
				}
			}
		}
		realNavigationController?.pushViewController(chartController, animated: false)
	}

	// MARK: - Received Notifications

	@objc private final func seriesGrouperEdited(notification: Notification) {
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

	@objc private final func xAxisChanged(notification: Notification) {
		if let attribute: Attribute? = value(for: .attribute, from: notification, keyIsOptional: true) {
			usePointGroupValueForXAxis = false
			xAxis = SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(attribute: attribute)
		} else if let information: SampleGroupInformation = value(
			for: .information,
			from: notification,
			keyIsOptional: true
		) {
			usePointGroupValueForXAxis = false
			xAxis = SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(information: information)
		} else if let usePointGroupValue: Bool = value(for: .usePointGroupValue, from: notification) {
			usePointGroupValueForXAxis = usePointGroupValue
			xAxis = nil
		} else {
			Me.log.error("Missing both optional attributes in x-axis setup notification")
		}
	}

	@objc private final func yAxisChanged(notification: Notification) {
		if let attributes: [Attribute] = value(for: .attributes, from: notification, keyIsOptional: true) {
			yAxis = attributes.map { SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(attribute: $0) }
		} else if let information: [SampleGroupInformation] = value(
			for: .information,
			from: notification,
			keyIsOptional: true
		) {
			yAxis = information.map { SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(information: $0) }
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
		if #available(iOS 13.0, *) {
			showGraphButton.backgroundColor = showGraphButton.isEnabled ? .label : .systemGray
		} else {
			showGraphButton.backgroundColor = showGraphButton.isEnabled ? .black : .gray
		}
	}

	private final func updateChartData() throws {
		let dataGenerator = SingleSampleTypeXYGraphDataGenerator(
			seriesGrouper: seriesGrouper,
			pointGrouper: pointGrouper,
			xAxis: xAxis,
			yAxis: yAxis,
			usePointGroupValueForXAxis: usePointGroupValueForXAxis
		)

		// leave this outside of DispatchQueue.main because it can take a while
		let allData = try dataGenerator.generateData(samples: samples)

		DispatchQueue.main.async {
			self.chartController.dataSeries = allData
		}
	}

	private final func showGrouperEditController(
		grouper: SampleGrouper?,
		notificationToSendOnAccept: NotificationName,
		grouperName: String
	) {
		let controller = viewController(
			named: "chooseGrouper",
			fromStoryboard: "Util"
		) as! GroupingChooserTableViewController
		controller.sampleType = type(of: samples[0])
		controller.currentGrouper = grouper?.copy()
		controller.notificationToSendOnAccept = notificationToSendOnAccept
		controller.title = grouperName
		pushToNavigationController(controller)
	}

	// MARK: On Set Functions

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
			DependencyInjector.get(UiUtil.self).setButton(clearSeriesGrouperButton, enabled: true, hidden: false)
		} else {
			chooseSeriesGrouperButton.setTitle("Choose series grouping (optional)", for: .normal)
			DependencyInjector.get(UiUtil.self).setButton(clearSeriesGrouperButton, enabled: false, hidden: true)
		}
		chooseSeriesGrouperButton.accessibilityValue = chooseSeriesGrouperButton.currentTitle
	}

	private final func pointGrouperSet() {
		if let _ = pointGrouper {
			choosePointGrouperButton.setTitle("Point grouping chosen", for: .normal)
			DependencyInjector.get(UiUtil.self).setButton(clearPointGrouperButton, enabled: true, hidden: false)
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
			DependencyInjector.get(UiUtil.self).setButton(clearPointGrouperButton, enabled: false, hidden: true)
			if !pointGrouperWasNil {
				// old value of yAxis (if it exists) will be [Information] but [Attribute]
				// is needed when pointGrouper is not provided
				yAxis = nil
				// old value of xAxis (if it exists) will be Information but Attribute
				// is needed when pointGrouper is not provided
				xAxis = nil
			}
		}
		choosePointGrouperButton.accessibilityValue = choosePointGrouperButton.currentTitle
		pointGrouperWasNil = pointGrouper == nil
	}
}
