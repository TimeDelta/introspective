//
//  BasicXYChartViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import AAInfographics
import SwiftDate
import UIKit

import Common
import DependencyInjection
import Queries
import UIExtensions

public protocol BasicXYChartViewController: UIViewController {
	var queries: [Query]? { get set }
	var dataSeries: [[String: Any]]! { get set }
	var displayXAxisValueLabels: Bool { get set }
	var chartType: AAChartType! { get set }
	var categories: [String]? { get set }
}

public final class BasicXYChartViewControllerImpl: UIViewController, BasicXYChartViewController {
	// MARK: - IBOutlets

	@IBOutlet final var activityIndicator: UIActivityIndicatorView!
	@IBOutlet final var chartViewOutline: UIView!

	// MARK: - Instance Variables

	public final var queries: [Query]?
	public final var dataSeries: [[String: Any]]! {
		didSet {
			dataSeries = dataSeries ?? [[String: Any]]()
			updateChartData()
		}
	}

	public final var displayXAxisValueLabels: Bool = false
	public final var chartType: AAChartType!
	public final var categories: [String]?
	private final var finishedSetup: Bool = false
	private final var chartView: AAChartView!
	private final var chartModel = AAChartModel()
		.animationType(.easeInCubic)
		.zoomType(.xy)
		.backgroundColor(AAColor.darkGray)
		.dataLabelsEnabled(true)

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		chartModel = chartModel.chartType(chartType)

		DependencyInjector.get(UiUtil.self).setBackButton(for: self, title: "Graph Setup", action: #selector(back))

		finishedSetup = true
	}

	public final override func viewDidLayoutSubviews() {
		chartView = AAChartView()
		chartView.frame = chartViewOutline.frame
		chartView.contentHeight = chartViewOutline.frame.size.height
		chartView.scrollEnabled = false
		view.insertSubview(chartView, at: 0)
	}

	public final override func showError(
		title: String,
		message: String? = "Sorry for the inconvenience.",
		error: Error? = nil,
		tryAgain: (() -> Void)? = nil,
		onDismiss originalOnDismiss: ((UIAlertAction) -> Void)? = nil,
		onDonePresenting: (() -> Void)? = nil
	) {
		doneWaiting()
		let onDismiss: ((UIAlertAction) -> Void) = { action in
			if let originalOnDismiss = originalOnDismiss {
				originalOnDismiss(action)
			}
			self.navigationController?.popViewController(animated: false)
		}
		super.showError(
			title: title,
			message: message,
			error: error,
			tryAgain: tryAgain,
			onDismiss: onDismiss,
			onDonePresenting: onDonePresenting
		)
	}

	// MARK: - Button Actions

	@objc private final func back() {
		if let queries = queries {
			for query in queries {
				query.stop()
			}
		}
		navigationController?.popViewController(animated: false)
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
		let xAxis = AAXAxis().min(0).max(1).linkedTo(0).visible(false)
		let chartOptions = AAOptionsConstructor.configureChartOptions(chartModel).xAxis(xAxis)
		chartView.aa_drawChartWithChartOptions(chartOptions)
	}

	private final func doneWaiting() {
		activityIndicator.isHidden = true
		activityIndicator.isUserInteractionEnabled = false
	}
}
