//
//  BasicXYGraphTypeSetupViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import AAInfographics
import UIKit

import Common

public class BasicXYGraphTypeSetupViewController: GraphTypeSetupViewController {
	private typealias Me = BasicXYGraphTypeSetupViewController

	private static let log = Log()

	public final var chartType: AAChartType! { didSet { chartTypeSet() } }

	func chartTypeSet() {
		Me.log.debug("chartTypeSet() not overriden")
	}
}
