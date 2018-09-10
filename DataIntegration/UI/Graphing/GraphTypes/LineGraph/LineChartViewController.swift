//
//  LineChartViewController.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import AAInfographics
import SwiftDate

final class LineChartViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak final var errorMessageLabel: UILabel!
	@IBOutlet weak final var chartViewOutline: UIView!

	// MARK: - Instance Member Variables

	public final var dataSeries: [Dictionary<String, Any>]! {
		didSet {
			dataSeries = dataSeries ?? [Dictionary<String, Any>]()
			updateChartData()
		}
	}
	public final var errorMessage: String? {
		didSet {
			if errorMessage != nil {
				errorMessageLabel.text = errorMessage
				errorMessageLabel.isHidden = false
				doneWaiting()
			}
		}
	}
	public final var displayXAxisValueLabels: Bool = true
	private final var finishedSetup: Bool = false
	private final var chartView: AAChartView!
	private final var chartModel = AAChartModel()
		.chartType(.Spline)
		.animationType(.EaseInCubic)
		.dataLabelEnabled(true)
		.zoomType(.XY)

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		chartView = AAChartView()
		chartView.frame = chartViewOutline.frame
		chartView.contentHeight = chartViewOutline.frame.size.height
		chartView.scrollEnabled = true
		view.insertSubview(chartView, at: 0)

		finishedSetup = true
	}

	// MARK: - Helper Functions

	private final func updateChartData() {
		while !finishedSetup {}
		doneWaiting()
		chartModel = chartModel
			.xAxisVisible(displayXAxisValueLabels)
			.series(dataSeries)
		chartView.aa_drawChartWithChartModel(chartModel)
	}

	private final func doneWaiting() {
		activityIndicator.isHidden = true
		activityIndicator.isUserInteractionEnabled = false
	}
}
