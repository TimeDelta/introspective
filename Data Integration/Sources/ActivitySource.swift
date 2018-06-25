//
//  ActivitySource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class ActivitySource: Source {

	override init() {
		super.init()
		requiredFields.append(SourceField(name: "Activity Name", type: SourceField.FieldType.DateTime))
		requiredFields.append(SourceField(name: "Start", type: SourceField.FieldType.DateTime))
		requiredFields.append(SourceField(name: "End", type: SourceField.FieldType.DateTime))

		optionalFields.append(SourceField(name: "Notes", type: SourceField.FieldType.String))
		optionalFields.append(SourceField(name: "Categories", type: SourceField.FieldType.List))
		optionalFields.append(SourceField(name: "Description", type: SourceField.FieldType.String))
	}
}
