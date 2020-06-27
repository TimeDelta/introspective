//
//  ArgumentCaptor.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky

public class ArgumentCaptor<Type> {
	/// Last captured value (if any)
	public var value: Type? {
		return allValues.last
	}
	/// All captured values
	public private(set) var allValues = [Type]()

	public init() {}

	/// Return parameter matcher which captures the argument.
	public func capture() -> Parameter<Type> {
		return .matching({ (value: Type) -> Bool in
			self.allValues.append(value)
			return true
		})
	}
}
