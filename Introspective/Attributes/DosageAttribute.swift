//
//  DosageAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class DosageAttribute: AttributeBase {

	public override init(
		name: String = "Dosage",
		pluralName: String? = "Dosages",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false)
	{
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		guard let castedValue = value as? Dosage else { throw AttributeError.typeMismatch }
		return castedValue.description
	}
}
