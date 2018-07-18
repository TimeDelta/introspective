//
//  QuerierFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol QuerierFactory {
	var heartRateQuerier: HeartRateQuerier { get }
}

public class QuerierFactoryImpl: QuerierFactory {

	fileprivate typealias Me = QuerierFactoryImpl

	fileprivate static let realHeartRateQuerier = HeartRateQuerier()

	public var heartRateQuerier: HeartRateQuerier { return Me.realHeartRateQuerier }
}
