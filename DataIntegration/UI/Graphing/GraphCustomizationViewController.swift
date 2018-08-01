//
//  GraphCustomizationViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class GraphCustomizationViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

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

	public var samples: [Sample]!
	public var dataType: DataTypes!

	fileprivate var xAxisAttribute: Attribute!
	fileprivate var yAxisAttribute: Attribute!
	fileprivate var aggregator: Aggregator!

	@IBOutlet weak var graphTypePicker: UIPickerView!
	@IBOutlet weak var xAxisButton: UIButton!
	@IBOutlet weak var yAxisButton: UIButton!
	@IBOutlet weak var aggregationButton: UIButton!

	override func viewDidLoad() {
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

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return ChartType.allTypes.count
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return ChartType.allTypes[row].description
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
		} else if segue.destination is AttributedChooserViewController {
			let controller = segue.destination as! AttributedChooserViewController
			var possibleAggregators: [Aggregator]
			if xAxisAttribute is DateAttribute {
				possibleAggregators = [DateAggregator()]
			} else {
				possibleAggregators = []
			}
			controller.possibleValues = possibleAggregators
		}
    }

	@IBAction func showGraph(_ sender: Any) {
		let chartType = getSelectedChartType()
		let controllerType = chartType.viewControllerClass
		let controller = UIStoryboard(name: "LineChart", bundle: nil).instantiateViewController(withIdentifier: String(describing: controllerType)) as! ChartViewController
		controller.properties[.xAxisAttribute] = xAxisAttribute
		controller.properties[.yAxisAttribute] = yAxisAttribute
		controller.samples = samples

		navigationController!.pushViewController(controller, animated: true)
	}

    @IBAction func xAxisChanged(_ segue: UIStoryboardSegue) {
		let controller = segue.source as! AxisAttributeViewController
		xAxisAttribute = controller.selectedAttribute
		updateXAttributeDisplay()
	}

	@IBAction func yAxisChanged(_ segue: UIStoryboardSegue) {
		let controller = segue.source as! AxisAttributeViewController
		yAxisAttribute = controller.selectedAttribute
		updateYAttributeDisplay()
	}

	@IBAction func aggregationChanged(_ segue: UIStoryboardSegue) {
		let controller = segue.source as! AttributedChooserViewController
		aggregator = (controller.currentValue as! Aggregator)
		aggregationButton.setTitle(aggregator.description, for: .normal)
	}

	fileprivate func updateXAttributeDisplay() {
		xAxisButton.setTitle(xAxisAttribute.name, for: .normal)
	}

	fileprivate func updateYAttributeDisplay() {
		yAxisButton.setTitle(yAxisAttribute.name, for: .normal)
	}

	fileprivate func getSelectedChartType() -> ChartType {
		let selectedIndex = graphTypePicker.selectedRow(inComponent: 0)
		return ChartType.allTypes[selectedIndex]
	}
}
