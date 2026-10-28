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
	var dataSeries: [AASeriesElement]! { get set }
	var displayXAxisValueLabels: Bool { get set }
	var chartType: AAChartType! { get set }
	var categories: [String]? { get set }
}

public final class BasicXYChartViewControllerImpl: UIViewController, BasicXYChartViewController {
	// MARK: - IBOutlets

	@IBOutlet final var pleaseBePatientLabel: UILabel!
	@IBOutlet final var activityIndicator: UIActivityIndicatorView!
	@IBOutlet final var chartViewOutline: UIView!

	// MARK: - Instance Variables

	public final var queries: [Query]?
	public final var dataSeries: [AASeriesElement]! {
		didSet {
			dataSeries = dataSeries ?? [AASeriesElement]()
			updateChartData()
		}
	}

	public final var displayXAxisValueLabels: Bool = false
	public final var chartType: AAChartType!
	public final var categories: [String]?
	private final var chartView: AAChartView!
	private final var chartModel = AAChartModel()
		.animationType(.easeInCubic)
		.zoomType(.xy)
		.backgroundColor(colorToHex(.secondarySystemBackground))
		.dataLabelsEnabled(true)

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		chartModel = chartModel.chartType(chartType)
		chartView = AAChartView()
		chartView.scrollEnabled = false
		view.insertSubview(chartView, at: 0)
		updateChartFrame()

		injected(UiUtil.self).setBackButton(for: self, title: "Graph Setup", action: #selector(back))

		// Data may arrive before UIKit loads the view. Render the latest value now.
		if dataSeries != nil { updateChartData() }
	}

	public final override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateChartFrame()
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
		let onDismiss: ((UIAlertAction) -> Void) = { [weak self] action in
			if let originalOnDismiss = originalOnDismiss {
				originalOnDismiss(action)
			}
			self?.navigationController?.popViewController(animated: false)
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

	private final func updateChartFrame() {
		guard let chartView = chartView, let outline = chartViewOutline else { return }
		chartView.frame = outline.frame
		let height = outline.frame.height
		if chartView.contentHeight != height { chartView.contentHeight = height }
	}

	private final func updateChartData() {
		guard isViewLoaded, chartView != nil else { return }
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
		pleaseBePatientLabel.isHidden = true
		pleaseBePatientLabel.isUserInteractionEnabled = false
	}
}
