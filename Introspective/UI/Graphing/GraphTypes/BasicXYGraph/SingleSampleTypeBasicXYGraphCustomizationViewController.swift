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
	private final var xAxis: SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation? {
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
	private final var pointGrouper: SampleGrouper? = nil {
		didSet { pointGrouperSet() }
	}
	private final var oldSampleType: Sample.Type! = nil
	private final var sampleType: Sample.Type! {
		didSet { sampleTypeSet() }
	}
	private final var chartController: BasicXYChartViewController!

	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SingleSampleTypeBasicXYGraphCustomizationViewController"))
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

	deinit {
		NotificationCenter.default.removeObserver(self)
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
			notification: .seriesGrouperEdited,
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
			notification: .pointGrouperEdited,
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
			xAxis = SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(attribute: attribute)
		} else if let information: ExtraInformation? = value(for: .information, from: notification, keyIsOptional: true) {
			usePointGroupValueForXAxis = false
			xAxis = SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(information: information)
		} else if let usePointGroupValue: Bool = value(for: .usePointGroupValue, from: notification) {
			usePointGroupValueForXAxis = usePointGroupValue
			xAxis = nil
		} else {
			log.error("Missing both optional attributes in x-axis setup notification")
		}
	}

	@objc private final func yAxisChanged(notification: Notification) {
		if let attributes: [Attribute] = value(for: .attributes, from: notification, keyIsOptional: true) {
			yAxis = attributes.map{ SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(attribute: $0) }
		} else if let information: [ExtraInformation] = value(for: .information, from: notification, keyIsOptional: true) {
			yAxis = information.map{ SingleSampleTypeXYGraphDataGenerator.AttributeOrInformation(information: $0) }
		} else {
			yAxis = nil
		}
	}

	// MARK: - Helper Functions

	private final func updateShowGraphButtonState() {
		showGraphButton.isEnabled =
			(xAxis?.attribute != nil || xAxis?.information != nil || usePointGroupValueForXAxis) &&
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

		let dataGenerator = SingleSampleTypeXYGraphDataGenerator(
			seriesGrouper: seriesGrouper,
			pointGrouper: pointGrouper,
			xAxis: xAxis,
			yAxis: yAxis,
			usePointGroupValueForXAxis: usePointGroupValueForXAxis)

		// leave this outside of DispatchQueue.main.async because it can take a while
		let allData = try dataGenerator.generateData(samples: samples)

		DispatchQueue.main.async {
			self.chartController.dataSeries = allData
		}
	}

	private final func showGrouperEditController(
		grouper: SampleGrouper?,
		editedCallback: Selector,
		notification: NotificationName,
		grouperName: String)
	{
		observe(selector: editedCallback, name: notification)

		let controller = viewController(named: "chooseGrouper", fromStoryboard: "Util") as! GroupingChooserTableViewController
		controller.sampleType = sampleType
		controller.currentGrouper = grouper?.copy()
		controller.title = grouperName
		controller.notificationToSendOnAccept = notification
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
		} else if let attribute = xAxis?.attribute {
			xAxisButton.setTitle("X-Axis: " + attribute.name.localizedLowercase, for: .normal)
		} else if let information = xAxis?.information {
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
		oldSampleType = sampleType
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
