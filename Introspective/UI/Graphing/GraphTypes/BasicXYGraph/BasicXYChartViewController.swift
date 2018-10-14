//
//  BasicXYChartViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import AAInfographics
import SwiftDate

class BasicXYChartViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak final var errorMessageLabel: UILabel!
	@IBOutlet weak final var chartViewOutline: UIView!

	// MARK: - Instance Variables

	public final var queries: [Query]?
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
	public final var chartType: AAChartType!
	public final var categories: [String]?
	private final var finishedSetup: Bool = false
	private final var chartView: AAChartView!
	private final var chartModel = AAChartModel()
		.animationType(.EaseInCubic)
		.dataLabelEnabled(true)
		.zoomType(.XY)

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()

		chartModel = chartModel.chartType(chartType)

		chartView = AAChartView()
		chartView.frame = chartViewOutline.frame
		chartView.contentHeight = chartViewOutline.frame.size.height
		chartView.scrollEnabled = false
		view.insertSubview(chartView, at: 0)

		UiUtil.setBackButton(for: self, title: "Graph Setup", action: #selector(back))

		finishedSetup = true
	}

	// MARK: - Button Actions

	@objc private final func back() {
		if queries != nil {
			for query in queries! {
				query.stop()
			}
		}
		self.navigationController?.popViewController(animated: true)
	}

	// MARK: - Helper Functions

	private final func updateChartData() {
		while !finishedSetup {}
		doneWaiting()
		chartModel = chartModel
			.xAxisVisible(displayXAxisValueLabels)
			.legendEnabled(true)
			.series(dataSeries)
		if categories != nil {
			chartModel = chartModel.categories(categories!)
		}
		chartView.aa_drawChartWithChartModel(chartModel)
	}

	private final func doneWaiting() {
		activityIndicator.isHidden = true
		activityIndicator.isUserInteractionEnabled = false
	}
}
