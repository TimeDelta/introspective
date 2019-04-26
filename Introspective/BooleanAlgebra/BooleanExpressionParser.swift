//
//  BooleanExpressionParser.swift
//  Introspective
//
//  Created by Bryan Nova on 4/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public enum ExpressionType {
	case groupStart
	case groupEnd
	case expression
	case and
	case or
}

//sourcery: AutoMockable
public protocol BooleanExpressionParser {

	func parse(_ parts :[(type: ExpressionType, expression: BooleanExpression?)]) throws -> BooleanExpression
}

public final class BooleanExpressionParserImpl: BooleanExpressionParser {

	public final func parse(_ parts :[(type: ExpressionType, expression: BooleanExpression?)]) throws -> BooleanExpression {
		precondition(parts.count > 0)
		var stack = [BooleanExpression]()
		for part in parts {
			switch (part.type) {
				case .and:
					try parseAnd(&stack)
					break
				case .or:
					try parseOr(&stack)
					break
				case .groupStart:
					let group = BooleanExpressionGroup()
					stack.append(group)
					break
				case .groupEnd:
					try parseGroupEnd(&stack)
					break
				case .expression:
					guard let expression = part.expression else {
						throw GenericError("Missing expression for sub-expression")
					}
					if stack.isEmpty {
						stack.append(expression)
					} else if let and = stack.last as? AndExpression {
						and.expression2 = expression
						stack[stack.count - 1] = and
					} else if let or = stack.last as? OrExpression {
						or.expression2 = expression
						stack[stack.count - 1] = or
					} else if stack.last is BooleanExpressionGroup {
						stack.append(expression)
					}
					break
			}
		}
		if stack.count > 1 {
			let current = stack.removeLast()
			if let and = stack[0] as? AndExpression {
				and.expression2 = current
				stack[0] = and
			} else if let or = stack[0] as? OrExpression {
				or.expression2 = current
				stack[0] = or
			} else {
				throw GenericError("Expected and / or but received \(current.description)")
			}
		}
		guard let expression = stack.first else {
			throw GenericError("No expression")
		}
		return expression
	}

	private final func parseAnd(_ stack: inout [BooleanExpression]) throws {
		let and = AndExpression()
		guard !stack.isEmpty else {
			throw GenericError("Expected left-hand side of and expression but got nothing")
		}
		and.expression1 = stack.removeLast()
		stack.append(and)
	}

	private final func parseOr(_ stack: inout [BooleanExpression]) throws {
		let or = OrExpression()
		guard !stack.isEmpty else {
			throw GenericError("Expected left-hand side of or expression but got nothing")
		}
		or.expression1 = stack.removeLast()
		stack.append(or)
	}

	private final func parseGroupEnd(_ stack: inout [BooleanExpression]) throws {
		var subGroup = stack.removeLast()
		var current = stack.removeLast()
		while !(current is BooleanExpressionGroup) {
			if let and = current as? AndExpression {
				and.expression2 = subGroup
				subGroup = and
			} else if let or = current as? OrExpression {
				or.expression2 = subGroup
				subGroup = or
			} else {
				throw GenericError("Expected AND or OR but received \(current.description)")
			}
			current = stack.removeLast()
		}
		guard let group = current as? BooleanExpressionGroup else {
			throw GenericError("Expected group expression start but did not find one")
		}
		group.subExpression = subGroup
		if let and = stack.last as? AndExpression {
			and.expression2 = group
			stack[stack.count - 1] = and
		} else if let or = stack.last as? OrExpression {
			or.expression2 = group
			stack[stack.count - 1] = or
		}
		stack.append(group)
	}
}
