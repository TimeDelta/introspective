//
//  HeartRateSource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class HeartRateSource: Source {

	override init() {
		super.init()
		requiredFields.append(SourceField(name: "Timestamp", type: SourceField.FieldType.DateTime))
		requiredFields.append(SourceField(name: "Heart Rate", type: SourceField.FieldType.Integer))
	}
}
