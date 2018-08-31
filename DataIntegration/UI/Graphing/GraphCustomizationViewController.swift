//
//  GraphCustomizationViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class GraphCustomizationViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

	enum ChartType: CustomStringConvertible {

		case lineGraph
		case barChart
		case horizontalBarChart
		case pieChart
		case scatterPlot
		case boxPlot
		case bubbleChart
		case radarChart

		public static let allTypes: [ChartType] = [
			.lineGraph,
			.barChart,
			.horizontalBarChart,
			.pieChart,
			.scatterPlot,
			.boxPlot,
			.bubbleChart,
			.radarChart,
		]

		public var description: String {
			switch (self) {
				case .lineGraph: return "Line graph"
				case .barChart: return "Bar chart"
				case .horizontalBarChart: return "Horizontal bar chart"
				case .pieChart: return "Pie chart"
				case .scatterPlot: return "Scatter plot"
				case .boxPlot: return "Box plot"
				case .bubbleChart: return "Bubble chart"
				case .radarChart: return "Radar chart"
			}
		}

		public var viewControllerClass: ChartViewController.Type {
			switch (self) {
				case .lineGraph: return LineChartViewController.self
				default: fatalError("Missing controller class for chart type: \(self)")
			}
		}
	}

	public final var samples: [Sample]!
	public final var dataType: DataTypes!

	private final var xAxisAttribute: Attribute!
	private final var yAxisAttribute: Attribute!
	private final var aggregator: SampleAggregator!

	@IBOutlet weak final var graphTypePicker: UIPickerView!
	@IBOutlet weak final var xAxisButton: UIButton!
	@IBOutlet weak final var yAxisButton: UIButton!
	@IBOutlet weak final var aggregationButton: UIButton!

	final override func viewDidLoad() {
		super.viewDidLoad()

		graphTypePicker.delegate = self
		graphTypePicker.dataSource = self

		if xAxisAttribute == nil {
			xAxisAttribute = dataType.defaultIndependentAttribute
		}
		if yAxisAttribute == nil {
			yAxisAttribute = dataType.defaultDependentAttribute
		}
		updateXAttributeDisplay()
		updateYAttributeDisplay()
	}

	public final func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public final func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return ChartType.allTypes.count
	}

	public final func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return ChartType.allTypes[row].description
	}

	public final func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}

	// MARK: - Navigation

	final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is AxisAttributeViewController {
			let controller = segue.destination as! AxisAttributeViewController
			controller.modalPresentationStyle = UIModalPresentationStyle.popover
			controller.popoverPresentationController!.delegate = self
			let source = sender as! UIButton
			if source == xAxisButton {
				controller.selectedAttribute = xAxisAttribute
			} else if source == yAxisButton {
				controller.selectedAttribute = yAxisAttribute
			}
			controller.attributes = DataTypes.attributesFor(dataType)
		} else if segue.destination is EditSampleAggregationViewController {
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

	@IBAction final func showGraph(_ sender: Any) {
		let chartType = getSelectedChartType()
		let controllerType = chartType.viewControllerClass
		let controller = UIStoryboard(name: "LineChart", bundle: nil).instantiateViewController(withIdentifier: String(describing: controllerType)) as! ChartViewController
		controller.properties[.xAxisAttribute] = xAxisAttribute
		controller.properties[.yAxisAttribute] = yAxisAttribute
		if aggregator == nil {
			controller.samples = samples
		} else {
			controller.samples = aggregator.aggregate(samples: samples)
		}

		navigationController!.pushViewController(controller, animated: true)
	}

	@IBAction final func xAxisChanged(_ segue: UIStoryboardSegue) {
		let controller = segue.source as! AxisAttributeViewController
		xAxisAttribute = controller.selectedAttribute
		updateXAttributeDisplay()
	}

	@IBAction final func yAxisChanged(_ segue: UIStoryboardSegue) {
		let controller = segue.source as! AxisAttributeViewController
		yAxisAttribute = controller.selectedAttribute
		updateYAttributeDisplay()
	}

	@IBAction final func graphSampleAggregationChanged(_ segue: UIStoryboardSegue) {
		let controller = segue.source as! EditSampleAggregationViewController
		aggregator = controller.currentAggregator
		aggregationButton.setTitle(aggregator.description, for: .normal)
	}

	private final func updateXAttributeDisplay() {
		xAxisButton.setTitle(xAxisAttribute.name, for: .normal)
	}

	private final func updateYAttributeDisplay() {
		yAxisButton.setTitle(yAxisAttribute.name, for: .normal)
	}

	private final func getSelectedChartType() -> ChartType {
		let selectedIndex = graphTypePicker.selectedRow(inComponent: 0)
		return ChartType.allTypes[selectedIndex]
	}
}
