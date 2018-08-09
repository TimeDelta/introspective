//
//  LineChartViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

class LineChartViewController: ChartViewController {

	fileprivate var xAxisAttribute: Attribute!
	fileprivate var yAxisAttribute: Attribute!

	@IBOutlet weak var chartView: LineChartView!

	override func viewDidLoad() {
		super.viewDidLoad()

		xAxisAttribute = (properties[.xAxisAttribute]! as! Attribute)
		yAxisAttribute = (properties[.yAxisAttribute]! as! Attribute)

		setUp(chartView: chartView)
		chartView.setViewPortOffsets(left: 20, top: 20, right: 20, bottom: 0)
		chartView.dragEnabled = true
		chartView.setScaleEnabled(true)
		chartView.pinchZoomEnabled = true

		chartView.rightAxis.enabled = false
		chartView.legend.enabled = false
		chartView.backgroundColor = UIColor(white: 255, alpha: 1)

		let yAxis = chartView.leftAxis
		yAxis.labelTextColor = .black
		yAxis.labelPosition = .insideChart
		yAxis.axisLineColor = .black

		let marker = BalloonMarker(
			color: UIColor(white: 180/255, alpha: 1),
			font: .systemFont(ofSize: 12),
			textColor: .white,
			insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
		marker.xAttributeType = type(of: xAxisAttribute)
		if xAxisAttribute is DateAttribute {
			marker.earliestDate = try! samples[0].value(of: xAxisAttribute) as! Date
		}
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker

		updateChartData()
	}

	fileprivate func updateChartData() {
		let dataEntries = samples.map { (sample: Sample) -> ChartDataEntry in
			let xValue = getDouble(for: xAxisAttribute, from: sample)
			let yValue = getDouble(for: yAxisAttribute, from: sample)
			return ChartDataEntry(x: xValue, y: yValue)
		}

		let dataSet = LineChartDataSet(values: dataEntries, label: "")
		dataSet.mode = .cubicBezier
		dataSet.lineWidth = 1
		dataSet.circleRadius = 4
		dataSet.setCircleColor(.black)
		dataSet.setColor(.black)
		dataSet.fillColor = .white
		dataSet.fillAlpha = 1
		dataSet.valueFont = .systemFont(ofSize: 9)
		dataSet.mode = .horizontalBezier

		let gradientColors = [
			ChartColorTemplates.colorFromString("#00ff0000").cgColor,
			ChartColorTemplates.colorFromString("#ffff0000").cgColor,
		]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

        dataSet.fill = Fill(linearGradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true

		let data = LineChartData(dataSet: dataSet)
		chartView.data = data

		chartView.animate(xAxisDuration: 2, yAxisDuration: 2)
	}

	fileprivate func getDouble(for attribute: Attribute, from sample: Sample) -> Double {
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
		fatalError("Forgot an x-axis data type")
	}
}
