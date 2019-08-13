//
//  Test.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/12/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

class Test: XCTestCase {

	override func setUp() {
		super.setUp()
		registerMatchers()
	}

	final func registerMatchers() {
		Matcher.default.register(AnySample.self) { $0.equalTo($1) }
		Matcher.default.register(Attribute.self) { $0.equalTo($1) }
		Matcher.default.register(AttributeRestriction.self) { $0.equalTo($1) }
		Matcher.default.register(AttributeRestriction.Type.self) { $0 == $1 }
		Matcher.default.register(DayOfWeek.self)
		Matcher.default.register(HeartRate.Type.self) { _,_ in true }
		Matcher.default.register(Sample.self) { $0.equalTo($1) }
		Matcher.default.register(Any.self) { self.anyMatcher($0, $1) }
		Matcher.default.register(Optional<Any>.self) { self.anyMatcher($0, $1) }
		Matcher.default.register(Exportable.Type.self) { $0 == $1 }
		Matcher.default.register(UIViewController.Type.self)
		Matcher.default.register(Sample.Type.self) { $0.name == $1.name }
		Matcher.default.register(GroupDefinition.self) {
			if let first = $0 as? GroupDefinitionMock, let second = $1 as? GroupDefinitionMock {
				return first === second
			}
			return $0.equalTo($1)
		}
		Matcher.default.register(BooleanExpressionPart.self) { self.booleanExpressionPartsMatch($0, $1) }
		Matcher.default.register(ExtraInformation.self) { $0.equalTo($1) }
		Matcher.default.register(Optional<SampleGrouper>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(Optional<Query>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(Optional<Attribute>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(Optional<ExtraInformation>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(Optional<Array<Attribute>>.self) {
			self.optionalEqualTo($0, $1, { $0.elementsEqual($1, by: { $0.equalTo($1) }) })
		}
		Matcher.default.register(Array<Attribute>.self) { $0.elementsEqual($1, by: { $0.equalTo($1) }) }
		Matcher.default.register(Optional<Array<ExtraInformation>>.self) {
			self.optionalEqualTo($0, $1, { $0.elementsEqual($1, by: { $0.equalTo($1) }) })
		}
		Matcher.default.register(Array<ExtraInformation>.self) { $0.elementsEqual($1, by: { $0.equalTo($1) }) }
	}

	// MARK: - Helper Functions

	private final func anyMatcher(_ one: Any?, _ two: Any?) -> Bool {
		if type(of: one) != type(of: two) && (isOptional(one) == isOptional(two)) {
			return false
		}
		if (one == nil && two == nil) { return true }
		if let attribute1 = one as? Attribute, let attribute2 = two as? Attribute {
			return attribute1.equalTo(attribute2)
		}
		if let _ = one as? ATrackerActivityImporterMock, let _ = two as? ATrackerActivityImporterMock {
			// no way to mock equalTo function when other value is also a mock because the
			// Given statement would recursively call this code:
			// Given(importer, .equalTo(.value(other), willReturn: true))
			//                          ^^^^^^^^^^^^^
			// when this ran, it would go to check if the passed other value matches the
			// one from the Given statement, which would call this code, ending in infinite
			// recursion. Also, pointer comparison is not good enough because of copy
			// constructor.
			return true
		}
		if let _ = one as? ActivityExporterMock, let _ = two as? ActivityExporterMock {
			// no way to mock equalTo function when other value is also a mock because the
			// Given statement would recursively call this code:
			// Given(exporter, .equalTo(.value(other), willReturn: true))
			//                          ^^^^^^^^^^^^^
			// when this ran, it would go to check if the passed other value matches the
			// one from the Given statement, which would call this code, ending in infinite
			// recursion. Also, pointer comparison is not good enough because of copy
			// constructor.
			return true
		}
		if let importer1 = one as? Importer, let importer2 = two as? Importer {
			return importer1.equalTo(importer2)
		}
		if let exporter1 = one as? Exporter, let exporter2 = two as? Exporter {
			return exporter1.equalTo(exporter2)
		}
		if let view1 = one as? UIView, let view2 = two as? UIView {
			return view1 == view2
		}
		if let viewController1 = one as? UIViewController, let viewController2 = two as? UIViewController {
			return viewController1 == viewController2
		}
		if let cell1 = one as? UITableViewCell, let cell2 = two as? UITableViewCell {
			return cell1 == cell2
		}
		fatalError("Missing equality test for Any Matcher")
	}

	private final func booleanExpressionPartsMatch(_ first: BooleanExpressionPart, _ second: BooleanExpressionPart) -> Bool {
		if first.type != second.type {
			return false
		}
		if first.expression == nil && second.expression == nil {
			return true
		}
		guard let expression1 = first.expression, let expression2 = second.expression else {
			return false
		}
		return expression1.equalTo(expression2)
	}

	private final func optionalEqualTo<Type>(_ first: Type?, _ second: Type?, _ areEqual: (Type, Type) -> Bool) -> Bool {
		guard let first = first else { return second == nil }
		guard let second = second else { return false }
		return areEqual(first, second)
	}
}
