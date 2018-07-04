//
//  QueryFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class QueryFactory: NSObject {

	public func heartRateQuery() -> HeartRateQuery {
		return HeartRateQuery()
	}
}
