//
//  MedicationsSource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

class MedicationSource: Source {

	override init() {
		super.init()
		requiredFields.append(SourceField(name: "Timestamp", type: SourceField.FieldType.DateTime))
		requiredFields.append(SourceField(name: "Medication Name", type: SourceField.FieldType.String))

		optionalFields.append(SourceField(name: "Dosage", type: SourceField.FieldType.String))
	}
}
