//
//  BooleanExpressionParser.swift
//  Introspective
//
//  Created by Bryan Nova on 4/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common

public typealias BooleanExpressionPart = (type: BooleanExpressionType, expression: BooleanExpression?)
public enum BooleanExpressionType {
	case groupStart
	case groupEnd
	case expression
	case and
	case or
	case not
}

// sourcery: AutoMockable
public protocol BooleanExpressionParser {
	func parse(_ parts: [BooleanExpressionPart]) throws -> BooleanExpression
}

internal final class BooleanExpressionParserImpl: BooleanExpressionParser {
	private typealias Me = BooleanExpressionParserImpl

	private static let log = Log()

	public final func parse(_ parts: [BooleanExpressionPart]) throws -> BooleanExpression {
		guard !parts.isEmpty else {
			throw GenericError("Nothing to parse")
		}
		var stack = [BooleanExpression]()
		for part in parts {
			switch part.type {
			case .not:
				stack.append(NotExpression())
				break
			case .and:
				try parseAnd(&stack)
				break
			case .or:
				try parseOr(&stack)
				break
			case .groupStart:
				stack.append(BooleanExpressionGroup())
				break
			case .groupEnd:
				try parseGroupEnd(&stack)
				break
			case .expression:
				try parseExpression(&stack, part.expression)
				break
			}
		}
		while stack.count > 1 {
			let current = stack.removeLast()
			if let and = stack[0] as? AndExpression {
				and.expression2 = current
				stack[0] = and
			} else if let or = stack[0] as? OrExpression {
				or.expression2 = current
				stack[0] = or
			} else if let not = stack[0] as? NotExpression {
				not.subExpression = current
				stack[0] = not
			} else {
				throw GenericError("Expected 'and' / 'or' / 'not' but received \(current.description)")
			}
		}
		guard let expression = stack.first else {
			// this shouldn't be able to happen even with an invalid expression
			Me.log.error("Nothing left in stack after parsing boolean expression")
			throw GenericError("No expression")
		}
		guard expression.isValid() else {
			throw GenericError("Invalid expression")
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
		guard stack.count > 1 else {
			throw GenericError("Empty stack while parsing group end")
		}
		var subGroup = stack.removeLast()
		var current = stack.removeLast()
		while !(current is BooleanExpressionGroup) {
			if let and = current as? AndExpression {
				and.expression2 = subGroup
				subGroup = and
			} else if let or = current as? OrExpression {
				or.expression2 = subGroup
				subGroup = or
			} else if let not = current as? NotExpression {
				not.subExpression = subGroup
				subGroup = not
			} else {
				throw GenericError("Expected AND or OR but received \(current.description)")
			}
			guard !stack.isEmpty else {
				throw GenericError("Empty stack while parsing group end")
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
		} else if let not = stack.last as? NotExpression {
			not.subExpression = group
			stack[stack.count - 1] = not
		}
		stack.append(group)
	}

	private final func parseExpression(_ stack: inout [BooleanExpression], _ expression: BooleanExpression?) throws {
		guard let expression = expression else {
			throw GenericError("Missing expression for sub-expression")
		}
		if stack.isEmpty {
			stack.append(expression)
		} else if let not = stack.last as? NotExpression {
			not.subExpression = expression
			stack[stack.count - 1] = not
		} else if let and = stack.last as? AndExpression {
			and.expression2 = expression
			stack[stack.count - 1] = and
		} else if let or = stack.last as? OrExpression {
			or.expression2 = expression
			stack[stack.count - 1] = or
		} else if stack.last is BooleanExpressionGroup {
			stack.append(expression)
		} else {
			throw GenericError("Cannot have two expressions next to each other without an and / or")
		}
	}
}
