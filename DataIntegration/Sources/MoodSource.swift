//
//  MoodSource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class MoodSource: Source {

	override init() {
		super.init()
		requiredFields.append(SourceField(name: "Timestamp", type: SourceField.FieldType.DateTime))
		requiredFields.append(SourceField(name: "Mood Rating", type: SourceField.FieldType.Decimal))
	}
}
