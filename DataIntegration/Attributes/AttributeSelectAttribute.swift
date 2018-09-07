//
//  AttributeSelectAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class AttributeSelectAttribute: TypedSelectOneAttribute<Attribute> {

	public init(name: String = "Attribute", pluralName: String? = "Attributes", description: String? = nil, variableName: String? = nil, attributes: [Attribute]) {
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, possibleValues: attributes, possibleValueToString: { $0.name }, areEqual: { $0.equalTo($1) })
	}
}
