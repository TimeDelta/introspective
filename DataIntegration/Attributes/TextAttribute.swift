//
//  TextAttribute.swft
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class TextAttribute: AttributeBase {

	public required init(name: String, pluralName: String? = nil, description: String? = nil, variableName: String? = nil) {
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName)
	}

	public final override func isValid(value: String) -> Bool {
		return true
	}

	public final override func errorMessageFor(invalidValue: String) -> String {
		return ""
	}

	public final override func convertToValue(from strValue: String) throws -> Any {
		return strValue
	}

	public final override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
		return castedValue
	}
}
