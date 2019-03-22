//
//  QueryResultsBasicXYGraphCustomizationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import AAInfographics

final class QueryResultsBasicXYGraphCustomizationViewController: BasicXYGraphTypeSetupViewController, QueryResultsGraphCustomizationViewController {

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

	private typealias Me = QueryResultsBasicXYGraphCustomizationViewController
	private static let xAxisChanged = Notification.Name("xAxisChanged")
	private static let yAxisChanged = Notification.Name("yAxisChanged")
	private static let aggregationChanged = Notification.Name("aggregationChanged")

	// MARK: - Instance Variables

	public final var samples: [Sample]!

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

	private final var grouping: Calendar.Component?
	private final var chartController: BasicXYChartViewController!

	private final let log = Log()

	// MARK: - IBOutlets

	@IBOutlet weak final var xAxisButton: UIButton!
	@IBOutlet weak final var yAxisButton: UIButton!
	@IBOutlet weak final var showGraphButton: UIButton!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		observe(selector: #selector(xAxisChanged), name: Me.xAxisChanged)
		observe(selector: #selector(yAxisChanged), name: Me.yAxisChanged)

		updateShowGraphButtonState()
	}

	// MARK: - Button Actions

	@IBAction func editXAxis(_ sender: Any) {
		let controller: XAxisSetupViewController = viewController(named: "xAxisSetup")
		controller.attributes = type(of: samples[0]).attributes
		controller.selectedAttribute = xAxis?.attribute
		controller.selectedInformation = xAxis?.information
		controller.grouping = grouping
		controller.notificationToSendWhenFinished = Me.xAxisChanged
		controller.attributes = samples[0].attributes
		realNavigationController?.pushViewController(controller, animated: false)
	}

	@IBAction func editYAxis(_ sender: Any) {
		if grouping == nil {
			let controller: ChooseAttributesToGraphTableViewController = viewController(named: "chooseAttributes")
			controller.allowedAttributes = type(of: samples[0]).attributes.filter{ $0 is NumericAttribute }
			controller.selectedAttributes = yAxis?.map{ $0.attribute! }
			controller.notificationToSendWhenFinished = Me.yAxisChanged
			realNavigationController?.pushViewController(controller, animated: false)
		} else {
			let controller: ChooseInformationToGraphTableViewController = viewController(named: "chooseInformation")
			controller.attributes = type(of: samples[0]).attributes
			controller.limitToNumericInformation = true
			if let yAxis = yAxis {
				controller.chosenInformation = yAxis.map{ $0.information! }
			}
			controller.notificationToSendWhenFinished = Me.yAxisChanged
			realNavigationController?.pushViewController(controller, animated: false)
		}
	}

	@IBAction final func showGraph(_ sender: Any) {
		chartController = viewController(named: "BasicXYChartViewController")
		chartController.chartType = chartType
		DispatchQueue.global(qos: .userInitiated).async {
			do {
				try self.updateChartData()
			} catch {
				self.log.error("Failed to update chart data: %@", errorInfo(error))
				DispatchQueue.main.async {
					self.chartController.showError(title: "Failed to gather required data", error: error)
				}
			}
		}
		realNavigationController?.pushViewController(chartController, animated: false)
	}

	// MARK: - Received Notifications

	@objc private final func xAxisChanged(notification: Notification) {
		grouping = value(for: .calendarComponent, from: notification)
		if let attribute: Attribute? = value(for: .attribute, from: notification, keyIsOptional: true) {
			xAxis = AttributeOrInformation(attribute: attribute)
		} else if let information: ExtraInformation = value(for: .information, from: notification, keyIsOptional: true) {
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
			yAxis != nil
		showGraphButton.backgroundColor = showGraphButton.isEnabled ? .black : .gray
	}

	private final func firstDateAttributeFor(_ sampleType: Sample.Type) -> DateAttribute {
		if let index = sampleType.attributes.index(where: { $0 is DateAttribute }) {
			return sampleType.attributes[index] as! DateAttribute
		}
		log.error("No DateAttribute found for sample type: %@", String(describing: sampleType))
		return CommonSampleAttributes.timestamp
	}

	private final func updateChartData() throws {
		var allData = [Dictionary<String, Any>]()
		var xValuesAreNumbers: Bool
		if grouping != nil {
			let grouper = SameTimeUnitSampleGrouper(grouping!)
			let groups = try grouper.group(samples: samples, by: firstDateAttributeFor(type(of: samples[0]))) as! [(Date, [Sample])]

			let xValues = try transform(sampleGroups: groups, information: xAxis.information!)
			xValuesAreNumbers = areAllNumbers(xValues.map{ $0.sampleValue })
			var sortedXValues = xValues
			// if x values are numbers and are not sorted, graph will look very weird
			if xValuesAreNumbers {
				sortedXValues = xValues.sorted(by: { Double($0.sampleValue)! < Double($1.sampleValue)! })
			}

			for yInformation in yAxis.map({ $0.information! }) {
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
			}
		} else {
			xValuesAreNumbers = xAxis.attribute! is NumericAttribute
			for yAttribute in yAxis.map({ $0.attribute! }) {
				let filteredSamples = try samples.filter{
					let xValue = try $0.graphableValue(of: self.xAxis.attribute!)
					if xValue == nil { return false }
					let yValue = try! $0.graphableValue(of: yAttribute)
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
	}

	private final func transform(sampleGroups: [(Date, [Sample])], information: ExtraInformation)
	throws -> [(groupValue: Date, sampleValue: String)] {
		var values = [(groupValue: Date, sampleValue: String)]()
		for (groupValue, samples) in sampleGroups {
			let sampleValue = try information.computeGraphable(forSamples: samples)
			values.append((groupValue: groupValue, sampleValue: sampleValue))
		}
		return values
	}

	private final func areAllNumbers(_ values: [String]) -> Bool {
		for value in values {
			if !DependencyInjector.util.string.isNumber(value) {
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
