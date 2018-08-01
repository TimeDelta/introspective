//
//  TextAttribute.swft
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class TextAttribute: AnyAttribute {

	public var value: String

	public required init(name: String, description: String? = nil) {
		self.value = ""
		super.init(name: name, description: description)
	}

	public override func isValid(value: String) -> Bool {
		return true
	}

	public override func errorMessageFor(invalidValue: String) -> String {
		return ""
	}

	public override func convertToValue(from strValue: String) throws -> Any {
		return strValue
	}

	public override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
		return castedValue
	}
}
