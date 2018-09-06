//
//  BooleanAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class BooleanAttribute: AttributeBase {

	public final override func convertToDisplayableString(from value: Any) throws -> String {
		guard let castedValue = value as? Bool else { throw AttributeError.typeMismatch }
		return castedValue ? "on" : "off"
	}
}
