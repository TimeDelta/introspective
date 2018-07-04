//
//  QuerierFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class QuerierFactory: NSObject {

	fileprivate static let realHeartRateQuerier = HeartRateQuerier()

	public var heartRateQuerier: HeartRateQuerier { return QuerierFactory.realHeartRateQuerier }
}
