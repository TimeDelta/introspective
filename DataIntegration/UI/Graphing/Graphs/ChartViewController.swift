//
//  ChartViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Charts

public class ChartViewController: UIViewController, ChartViewDelegate {

	public enum ChartProperty {
		case xAxisAttribute
		case yAxisAttribute
	}

	public final var properties = [ChartProperty: Any]()
	public final var samples: [Sample]!

	final func setUp(chartView: ChartViewBase) {
		chartView.delegate = self
		chartView.backgroundColor = UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1)
	}
}
