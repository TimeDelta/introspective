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
import os

final class QueryResultsLineGraphCustomizationViewController: UIViewController, QueryResultsGraphCustomizationViewController {

	// MARK: - Enums / Structs

	private struct AttributeOrInformation {
		fileprivate var attribute: Attribute?
		fileprivate var information: ExtraInformation?

		fileprivate init(attribute: Attribute? = nil, information: ExtraInformation? = nil) {
			self.attribute = attribute
			self.information = information
		}
	}

	// MARK: - Static Member Variables

	private typealias Me = QueryResultsLineGraphCustomizationViewController
	private static let xAxisChanged = Notification.Name("xAxisChanged")
	private static let yAxisChanged = Notification.Name("yAxisChanged")
	private static let aggregationChanged = Notification.Name("aggregationChanged")

	// MARK: - Instance Member Variables

	public final var samples: [Sample]!

	private final var xAxis: AttributeOrInformation! {
		didSet {
			if xAxis == nil {
				xAxisButton.setTitle("Choose x-axis information", for: .normal)
				yAxis = nil
				UiUtil.setButton(yAxisButton, enabled: false)
			} else if let attribute = xAxis.attribute {
				xAxisButton.setTitle("X-Axis: " + attribute.name.localizedLowercase, for: .normal)
				UiUtil.setButton(yAxisButton, enabled: true)
			} else if let information = xAxis.information {
				var text = information.description.localizedLowercase
				if grouping != nil {
					text += " per " + grouping!.description.localizedLowercase
				}
				xAxisButton.setTitle("X-Axis: " + text, for: .normal)
				UiUtil.setButton(yAxisButton, enabled: true)
			}
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
			updateShowGraphButtonState()
		}
	}

	private final var grouping: Calendar.Component?
	private final var chartController: LineChartViewController!

	// MARK: - IBOutlets

	@IBOutlet weak final var xAxisButton: UIButton!
	@IBOutlet weak final var yAxisButton: UIButton!
	@IBOutlet weak final var showGraphButton: UIButton!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		NotificationCenter.default.addObserver(self, selector: #selector(xAxisChanged), name: Me.xAxisChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(yAxisChanged), name: Me.yAxisChanged, object: nil)

		updateShowGraphButtonState()
	}

	// MARK: - Button Actions

	@IBAction func editXAxis(_ sender: Any) {
		let controller = storyboard!.instantiateViewController(withIdentifier: "xAxisSetup") as! XAxisSetupViewController
		controller.attributes = type(of: samples[0]).attributes
		controller.selectedAttribute = xAxis?.attribute
		controller.selectedInformation = xAxis?.information
		controller.grouping = grouping
		controller.notificationToSendWhenFinished = Me.xAxisChanged
		controller.attributes = samples[0].attributes
		navigationController?.pushViewController(controller, animated: true)
	}

	@IBAction func editYAxis(_ sender: Any) {
		if grouping == nil {
			let controller = storyboard!.instantiateViewController(withIdentifier: "chooseAttributes") as! ChooseAttributesToGraphTableViewController
			controller.allowedAttributes = type(of: samples[0]).attributes.filter{ $0 is NumericAttribute }
			controller.selectedAttributes = yAxis?.map{ $0.attribute! }
			controller.notificationToSendWhenFinished = Me.yAxisChanged
			navigationController?.pushViewController(controller, animated: true)
		} else {
			let controller = storyboard!.instantiateViewController(withIdentifier: "chooseInformation") as! ChooseInformationToGraphTableViewController
			controller.attributes = type(of: samples[0]).attributes
			controller.limitToNumericInformation = true
			controller.chosenInformation = yAxis?.map{ $0.information! }
			controller.notificationToSendWhenFinished = Me.yAxisChanged
			navigationController?.pushViewController(controller, animated: true)
		}
	}

	@IBAction final func showGraph(_ sender: Any) {
		chartController = (storyboard!.instantiateViewController(withIdentifier: "LineChartViewController") as! LineChartViewController)
		DispatchQueue.global(qos: .userInitiated).async {
			self.updateChartData()
		}
		navigationController?.pushViewController(chartController, animated: true)
	}

	// MARK: - Received Notifications

	@objc private final func xAxisChanged(notification: Notification) {
		if let value = notification.object as? (grouping: Calendar.Component?, xAxis: Attribute) {
			grouping = value.grouping
			xAxis = AttributeOrInformation(attribute: value.xAxis)
		} else if let value = notification.object as? (grouping: Calendar.Component?, xAxis: ExtraInformation) {
			grouping = value.grouping
			xAxis = AttributeOrInformation(information: value.xAxis)
		} else {
			os_log("Unknown object type returned from x-axis setup: %@", type: .error, String(describing: type(of: notification.object)))
		}
	}

	@objc private final func yAxisChanged(notification: Notification) {
		if let attributes = notification.object as? [Attribute] {
			yAxis = attributes.map{ AttributeOrInformation(attribute: $0) }
		} else if let information = notification.object as? [ExtraInformation] {
			yAxis = information.map{ AttributeOrInformation(information: $0) }
		} else if notification.object == nil {
			yAxis = nil
		} else {
			os_log("Unknown object type returned from y-axis setup: %@", type: .error, String(describing: type(of: notification.object)))
		}
	}

	// MARK: - Helper Functions

	private final func updateShowGraphButtonState() {
		 showGraphButton.isEnabled =
			xAxis != nil &&
			(xAxis.attribute != nil || xAxis.information != nil) &&
			yAxis != nil
		showGraphButton.backgroundColor = showGraphButton.isEnabled ? .black : .gray
	}

	private final func firstDateAttributeFor(_ sampleType: Sample.Type) -> DateAttribute {
		if let index = sampleType.attributes.index(where: { $0 is DateAttribute }) {
			return sampleType.attributes[index] as! DateAttribute
		}
		os_log("No DateAttribute found for sample type: %@", type: .error, String(describing: sampleType))
		return CommonSampleAttributes.timestamp
	}

	private final func updateChartData() {
		var allData = [Dictionary<String, Any>]()
		var xValuesAreNumbers: Bool
		if grouping != nil {
			let grouper = SameTimeUnitSampleGrouper(grouping!)
			let groups = grouper.group(samples: samples, by: firstDateAttributeFor(type(of: samples[0]))) as! [(Date, [Sample])]

			let xValues = transform(sampleGroups: groups, information: xAxis.information!)
			xValuesAreNumbers = areAllNumbers(xValues.map{ $0.sampleValue })
			var sortedXValues = xValues
			// if x values are numbers and are not sorted, graph will look very weird
			if xValuesAreNumbers {
				sortedXValues = xValues.sorted(by: { Double($0.sampleValue)! < Double($1.sampleValue)! })
			}

			for yInformation in yAxis.map({ $0.information! }) {
				let yValues = transform(sampleGroups: groups, information: yInformation)
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
			}
		} else {
			xValuesAreNumbers = xAxis.attribute! is NumericAttribute
			for yAttribute in yAxis.map({ $0.attribute! }) {
				let data = samples.map({ (sample: Sample) -> [Any] in
					let rawXValue = try! sample.value(of: self.xAxis.attribute!)
					var xValue: Any = rawXValue
					if !xValuesAreNumbers {
						do {
							xValue = try self.xAxis.attribute!.convertToDisplayableString(from: rawXValue)
						} catch {
							xValue = ""
							os_log("Failed to convert value (%@) to displayable string: %@", type: .error, String(describing: rawXValue), error.localizedDescription)
						}
					}
					return [xValue, try! sample.value(of: yAttribute)]
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
	}

	private final func transform(sampleGroups: [(Date, [Sample])], information: ExtraInformation) -> [(groupValue: Date, sampleValue: String)] {
		var values = [(groupValue: Date, sampleValue: String)]()
		for (groupValue, samples) in sampleGroups {
			let sampleValue = try! information.compute(forSamples: samples)
			values.append((groupValue: groupValue, sampleValue: sampleValue))
		}
		return values
	}

	private final func areAllNumbers(_ values: [String]) -> Bool {
		for value in values {
			if !DependencyInjector.util.stringUtil.isNumber(value) {
				return false
			}
		}
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
}
