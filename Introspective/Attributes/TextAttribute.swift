//
//  TextAttribute.swft
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol TextAttributeDelegate {

	func isValid(value: String?) -> Bool
	func errorMessageFor(invalidValue: String?) -> String
}

public final class TextAttribute: AttributeBase {

	private final let delegate: TextAttributeDelegate?

	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		delegate: TextAttributeDelegate? = nil)
	{
		self.delegate = delegate
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	public final func isValid(value: String?) -> Bool {
		return delegate?.isValid(value: value) ?? true
	}

	public final func errorMessageFor(invalidValue: String?) -> String {
		return delegate?.errorMessageFor(invalidValue: invalidValue) ?? ""
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		guard let castedValue = value as? String else { throw AttributeError.typeMismatch }
		return castedValue
	}
}
