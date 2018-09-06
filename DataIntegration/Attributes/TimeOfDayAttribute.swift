//
//  TimeOfDayAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class TimeOfDayAttribute: AttributeBase {

	public required override init(name: String = "Time of day", pluralName: String? = "Times of day", description: String? = nil, variableName: String? = nil) {
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName)
	}

	public final override func convertToDisplayableString(from value: Any) throws -> String {
		guard let castedValue = value as? TimeOfDay else { throw AttributeError.typeMismatch }
		return castedValue.toString()
	}
}
