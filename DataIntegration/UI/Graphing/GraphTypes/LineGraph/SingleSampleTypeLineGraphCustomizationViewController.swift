//
//  SingleSampleTypeLineGraphCustomizationViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import AAInfographics
import os

final class SingleSampleTypeLineGraphCustomizationViewController: UIViewController {

	// MARK: - Static Member Variables

	private typealias Me = SingleSampleTypeLineGraphCustomizationViewController
	private static let xAxisChanged = Notification.Name("xAxisChanged")
	private static let yAxisChanged = Notification.Name("yAxisChanged")
	private static let queryChanged = Notification.Name("queryChanged")
	private static let aggregationChanged = Notification.Name("aggregationChanged")
	private static let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - Instance Member Variables

	private final var query: Query? {
		didSet {
			if query == nil {
				queryButton.setTitle("Choose query (optional)", for: .normal)
			} else {
				queryButton.setTitle("Query chosen (click to change)", for: .normal)
			}
		}
	}
	private final var xAxisAttribute: Attribute! {
		didSet {
			if xAxisAttribute == nil {
				xAxisButton.setTitle("Choose x-axis attribute", for: .normal)
			} else {
				xAxisButton.setTitle("X-Axis: " + xAxisAttribute.name, for: .normal)
			}
		}
	}
	private final var yAxisAttribute: Attribute! {
		didSet {
			if yAxisAttribute == nil {
				yAxisButton.setTitle("Choose y-axis attribute", for: .normal)
			} else {
				yAxisButton.setTitle("Y-Axis: " + yAxisAttribute.name, for: .normal)
			}
		}
	}
	private final var aggregator: SampleAggregator! {
		didSet {
			if aggregator == nil {
				aggregationButton.setTitle("Choose aggregation (optional)", for: .normal)
			} else {
				aggregationButton.setTitle(aggregator.description, for: .normal)
			}
		}
	}
	private final var oldSampleType: Sample.Type!
	private final var sampleType: Sample.Type! {
		didSet {
			if oldSampleType != sampleType {
				query = nil
				xAxisAttribute = nil
				yAxisAttribute = nil
				aggregator = nil
			}
		}
	}

	// MARK: - IBOutlets

	@IBOutlet weak final var sampleTypePicker: UIPickerView!
	@IBOutlet weak final var queryButton: UIButton!
	@IBOutlet weak final var xAxisButton: UIButton!
	@IBOutlet weak final var yAxisButton: UIButton!
	@IBOutlet weak final var aggregationButton: UIButton!
	@IBOutlet weak final var showMeTheGraphButton: UIButton!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		sampleType = DependencyInjector.sample.allTypes()[0]
		sampleTypePicker.dataSource = self
		sampleTypePicker.delegate = self

		if xAxisAttribute == nil {
			xAxisAttribute = sampleType.defaultIndependentAttribute
		}
		if yAxisAttribute == nil {
			yAxisAttribute = sampleType.defaultDependentAttribute
		}

		NotificationCenter.default.addObserver(self, selector: #selector(xAxisChanged), name: Me.xAxisChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(yAxisChanged), name: Me.yAxisChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(aggregationChanged), name: Me.aggregationChanged, object: nil)
	}

	// MARK: - Button Actions

	@IBAction final func chooseQueryButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Query", bundle: nil).instantiateViewController(withIdentifier: "queryView") as! QueryViewController
		controller.finishedButtonTitle = "Use Query"
		controller.topmostSampleType = sampleType
		controller.finishedButtonNotification = Me.queryChanged
		navigationController?.pushViewController(controller, animated: true)
	}

	@IBAction final func showGraph(_ sender: Any) {
		let controller = storyboard!.instantiateViewController(withIdentifier: "LineChartViewController") as! LineChartViewController
		if query == nil {
			query = try! DependencyInjector.query.queryFor(sampleType)
		}
		query!.runQuery { (result, error) in
			if error != nil {
				os_log("Query run failed: %@", type: .error, error!.localizedDescription)
				controller.errorMessage = "Something went wrong while running the query. Sorry for the inconvenience this has caused you."
				return
			}
			if let samples = result?.samples {
				var aggregatedSamples: [Sample] = samples
				if self.aggregator != nil {
					aggregatedSamples = self.aggregator.aggregate(samples: samples)
				}
				let data = aggregatedSamples.map{ (sample) -> [Any] in
					let rawXValue = try! sample.value(of: self.xAxisAttribute)
					var xValue: Any = rawXValue
					if !(self.xAxisAttribute is NumericAttribute) {
						xValue = try! self.xAxisAttribute.convertToDisplayableString(from: rawXValue)
					}
					return [xValue, self.getDouble(for: self.yAxisAttribute, from: sample, allSamples: samples)]
				}
				if !(self.xAxisAttribute is NumericAttribute) {
					controller.displayXAxisValueLabels = false
				}
				DispatchQueue.main.async {
					controller.dataSeries = [
						AASeriesElement()
							.name(self.yAxisAttribute.name.localizedCapitalized)
							.data(data)
							.toDic()!
					]
				}
			} else {
				os_log("Query run did not return an error or any results", type: .error)
				controller.dataSeries = nil
			}
		}
		navigationController!.pushViewController(controller, animated: true)
	}

	@IBAction final func editXAxis(_ sender: Any) {
		let controller = UIStoryboard(name: "GraphingUtil", bundle: nil).instantiateViewController(withIdentifier: "selectAttribtue") as! AttributeSelectionViewController
		controller.selectedAttribute = xAxisAttribute
		controller.notificationToSendWhenAccepted = Me.xAxisChanged
		controller.attributes = sampleType.attributes
		customPresentViewController(Me.presenter, viewController: controller, animated: true)
	}

	@IBAction final func editYAxis(_ sender: Any) {
		let controller = UIStoryboard(name: "GraphingUtil", bundle: nil).instantiateViewController(withIdentifier: "selectAttribtue") as! AttributeSelectionViewController
		controller.selectedAttribute = yAxisAttribute
		controller.notificationToSendWhenAccepted = Me.yAxisChanged
		controller.attributes = sampleType.attributes
		customPresentViewController(Me.presenter, viewController: controller, animated: true)
	}

	@IBAction final func chooseAggregationButtonPressed(_ sender: Any) {
		let controller = storyboard!.instantiateViewController(withIdentifier: "chooseAggregation") as! EditSampleAggregationViewController
		controller.notificationToSendOnAccept = Me.aggregationChanged
		if aggregator == nil {
			aggregator = SampleAggregator(groupingBy: xAxisAttribute, combining: yAxisAttribute)
		} else {
			aggregator.groupByAttribute = xAxisAttribute
			aggregator.combinationAttribute = yAxisAttribute
		}
		controller.currentAggregator = aggregator
		navigationController!.pushViewController(controller, animated: true)
	}

	// MARK: - Received Notifications

	@objc private final func queryChanged(notification: Notification) {
		query = (notification.object as! Query)
	}

	@objc private final func xAxisChanged(notification: Notification) {
		xAxisAttribute = (notification.object as! Attribute)
	}

	@objc private final func yAxisChanged(notification: Notification) {
		xAxisAttribute = (notification.object as! Attribute)
	}

	@objc private final func aggregationChanged(notification: Notification) {
		aggregator = (notification.object as! SampleAggregator)
	}

	// MARK: - Helper Functions

	private final func enableGraphButtonIfValid() {
		if xAxisAttribute != nil && yAxisAttribute != nil {
			showMeTheGraphButton.isEnabled = true
			showMeTheGraphButton.isUserInteractionEnabled = true
		}
	}

	private final func getDouble(for attribute: Attribute, from sample: Sample, allSamples: [Sample]) -> Double {
		let value: Any = try! sample.value(of: attribute)
		if value is Date {
			let earliestDate = try! allSamples[0].value(of: attribute) as! Date
			let date = value as! Date
			let totalSeconds = earliestDate.getInterval(toDate: date, component: .second)
			return Double(totalSeconds)
		} else if value is DayOfWeek {
			let dayOfWeek = value as! DayOfWeek
			return Double(dayOfWeek.intValue)
		} else if value is Double {
			return value as! Double
		} else if value is Int {
			return Double(value as! Int)
		}
		// TODO - gracefully tell user about this
		fatalError("Forgot a data type")
	}
}

// MARK: - UIPickerViewDataSource

extension SingleSampleTypeLineGraphCustomizationViewController: UIPickerViewDataSource {

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return DependencyInjector.sample.allTypes().count
	}
}

// MARK: - UIPickerViewDelegate

extension SingleSampleTypeLineGraphCustomizationViewController: UIPickerViewDelegate {

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return DependencyInjector.sample.allTypes()[row].name
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		sampleType = DependencyInjector.sample.allTypes()[row]
	}
}
