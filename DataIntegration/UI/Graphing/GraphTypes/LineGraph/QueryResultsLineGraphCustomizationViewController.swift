//
//  QueryResultsLineGraphCustomizationViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import AAInfographics

final class QueryResultsLineGraphCustomizationViewController: UIViewController, QueryResultsGraphCustomizationViewController {

	// MARK: - Static Member Variables

	private typealias Me = QueryResultsLineGraphCustomizationViewController
	private static let xAxisChanged = Notification.Name("xAxisChanged")
	private static let yAxisChanged = Notification.Name("yAxisChanged")
	private static let aggregationChanged = Notification.Name("aggregationChanged")
	private static let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - Instance Member Variables

	public final var samples: [Sample]!

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

	// MARK: - IBOutlets

	@IBOutlet weak final var xAxisButton: UIButton!
	@IBOutlet weak final var yAxisButton: UIButton!
	@IBOutlet weak final var aggregationButton: UIButton!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		if xAxisAttribute == nil {
			xAxisAttribute = type(of: samples[0]).defaultIndependentAttribute
		}
		if yAxisAttribute == nil {
			yAxisAttribute = type(of: samples[0]).defaultDependentAttribute
		}

		NotificationCenter.default.addObserver(self, selector: #selector(xAxisChanged), name: Me.xAxisChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(yAxisChanged), name: Me.yAxisChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(aggregationChanged), name: Me.aggregationChanged, object: nil)
	}

	// MARK: - Navigation

	final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is EditSampleAggregationViewController {
			let controller = segue.destination as! EditSampleAggregationViewController
			if aggregator == nil {
				aggregator = SampleAggregator(groupingBy: xAxisAttribute, combining: yAxisAttribute)
			} else {
				aggregator.groupByAttribute = xAxisAttribute
				aggregator.combinationAttribute = yAxisAttribute
			}
			controller.currentAggregator = aggregator
		}
	}

	// MARK: - Received Notifications

	@objc private final func xAxisChanged(notification: Notification) {
		xAxisAttribute = notification.object as! Attribute
	}

	@objc private final func yAxisChanged(notification: Notification) {
		xAxisAttribute = notification.object as! Attribute
	}

	@objc private final func aggregationChanged(notification: Notification) {
		aggregator = notification.object as! SampleAggregator
	}

	// MARK: - Button Actions

	@IBAction final func showGraph(_ sender: Any) {
		let controller = storyboard!.instantiateViewController(withIdentifier: "LineChartViewController") as! LineChartViewController

		DispatchQueue.global(qos: .userInitiated).async {
			var aggregatedSamples: [Sample] = self.samples
			if self.aggregator != nil {
				aggregatedSamples = self.aggregator.aggregate(samples: self.samples)
			}
			let data = aggregatedSamples.map{ (sample) -> [Any] in
				let rawXValue = try! sample.value(of: self.xAxisAttribute)
				var xValue: Any = rawXValue
				if !(self.xAxisAttribute is NumericAttribute) {
					xValue = try! self.xAxisAttribute.convertToDisplayableString(from: rawXValue)
				}
				return [xValue, self.getDouble(for: self.yAxisAttribute, from: sample)]
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
		}

		navigationController!.pushViewController(controller, animated: true)
	}

	@IBAction func editXAxis(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "selectAttribtue") as! AttributeSelectionViewController
		controller.selectedAttribute = xAxisAttribute
		controller.notificationToSendWhenAccepted = Me.xAxisChanged
		controller.attributes = samples[0].attributes
		customPresentViewController(Me.presenter, viewController: controller, animated: true)
	}

	@IBAction func editYAxis(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "selectAttribtue") as! AttributeSelectionViewController
		controller.selectedAttribute = yAxisAttribute
		controller.notificationToSendWhenAccepted = Me.yAxisChanged
		controller.attributes = samples[0].attributes
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

	// MARK: - Helper Functions

	private final func getDouble(for attribute: Attribute, from sample: Sample) -> Double {
		let value: Any = try! sample.value(of: attribute)
		if value is Date {
			let earliestDate = try! samples[0].value(of: attribute) as! Date
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
