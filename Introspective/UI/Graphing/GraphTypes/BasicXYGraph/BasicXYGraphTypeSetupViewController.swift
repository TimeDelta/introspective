//
//  BasicXYGraphTypeSetupViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import AAInfographics

import Common

public class BasicXYGraphTypeSetupViewController: GraphTypeSetupViewController {

	public final var chartType: AAChartType! { didSet { chartTypeSet() } }

	private final let log = Log()

	func chartTypeSet() {
		log.debug("chartTypeSet() not overriden")
	}
}
