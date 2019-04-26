//
//  ExpressionStub.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
@testable import Introspective

final class ExpressionStub: BooleanExpression {

	var description: String
	var evaluation: Bool = true

	init(_ name: String) {
		description = name
	}

	func evaluate(_ parameters: [UserInfoKey: Any]?) throws -> Bool { return evaluation }

	func equalTo(_ other: BooleanExpression) -> Bool {
		guard let otherExpression = other as? ExpressionStub else { return false }
		return description == otherExpression.description
	}
}
