//
//  AttributeRestrictionMock.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import DataIntegration

// sourcery: mock = "AttributeRestriction"
class AttributeRestrictionMock: AttributeRestriction, Mock {
	fileprivate var _description: String!

	var description: String {
		get { return _description }
		set { _description = newValue }
	}

// sourcery:inline:auto:AttributeRestrictionMock.autoMocked
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    var restrictedAttribute: Attribute { 
		get {	invocations.append(.restrictedAttribute_get)
				return __restrictedAttribute.orFail("AttributeRestrictionMock - value for restrictedAttribute was not defined") }
		set {	invocations.append(.restrictedAttribute_set(.value(newValue)))
				__restrictedAttribute = newValue }
	}
	private var __restrictedAttribute: (Attribute)?


    var name: String { 
		get {	invocations.append(.name_get)
				return __name.orFail("AttributeRestrictionMock - value for name was not defined") }
		set {	invocations.append(.name_set(.value(newValue)))
				__name = newValue }
	}
	private var __name: (String)?


    var attributes: [Attribute] { 
		get {	invocations.append(.attributes_get)
				return __attributes.orFail("AttributeRestrictionMock - value for attributes was not defined") }
		set {	invocations.append(.attributes_set(.value(newValue)))
				__attributes = newValue }
	}
	private var __attributes: ([Attribute])?


    struct Property {
        fileprivate var method: MethodType
        static var restrictedAttribute: Property { return Property(method: .restrictedAttribute_get) }
		static func restrictedAttribute(set newValue: Parameter<Attribute>) -> Property { return Property(method: .restrictedAttribute_set(newValue)) }
        static var name: Property { return Property(method: .name_get) }
		static func name(set newValue: Parameter<String>) -> Property { return Property(method: .name_set(newValue)) }
        static var attributes: Property { return Property(method: .attributes_get) }
		static func attributes(set newValue: Parameter<[Attribute]>) -> Property { return Property(method: .attributes_set(newValue)) }
    }




    required init(attribute: Attribute) { }

    func samplePasses(_ sample: Sample) throws -> Bool {
        addInvocation(.isamplePasses__sample(Parameter<Sample>.value(sample)))
		let perform = methodPerformValue(.isamplePasses__sample(Parameter<Sample>.value(sample))) as? (Sample) -> Void
		perform?(sample)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isamplePasses__sample(Parameter<Sample>.value(sample)))
		if let error = givenValue.error { throw error }
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for samplePasses(_ sample: Sample). Use given")
    }

    func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
        addInvocation(.iequalTo__otherRestriction(Parameter<AttributeRestriction>.value(otherRestriction)))
		let perform = methodPerformValue(.iequalTo__otherRestriction(Parameter<AttributeRestriction>.value(otherRestriction))) as? (AttributeRestriction) -> Void
		perform?(otherRestriction)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iequalTo__otherRestriction(Parameter<AttributeRestriction>.value(otherRestriction)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for equalTo(_ otherRestriction: AttributeRestriction). Use given")
    }

    func value(of attribute: Attribute) throws -> Any {
        addInvocation(.ivalue__of_attribute(Parameter<Attribute>.value(attribute)))
		let perform = methodPerformValue(.ivalue__of_attribute(Parameter<Attribute>.value(attribute))) as? (Attribute) -> Void
		perform?(attribute)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.ivalue__of_attribute(Parameter<Attribute>.value(attribute)))
		if let error = givenValue.error { throw error }
		let value = givenValue.value as? Any
		return value.orFail("stub return value not specified for value(of attribute: Attribute). Use given")
    }

    func set(attribute: Attribute, to value: Any) throws {
        addInvocation(.iset__attribute_attributeto_value(Parameter<Attribute>.value(attribute), Parameter<Any>.value(value)))
		let perform = methodPerformValue(.iset__attribute_attributeto_value(Parameter<Attribute>.value(attribute), Parameter<Any>.value(value))) as? (Attribute, Any) -> Void
		perform?(attribute, value)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iset__attribute_attributeto_value(Parameter<Attribute>.value(attribute), Parameter<Any>.value(value)))
		if let error = givenValue.error { throw error }
    }

    func equalTo(_ otherAttributed: Attributed) -> Bool {
        addInvocation(.iequalTo__otherAttributed(Parameter<Attributed>.value(otherAttributed)))
		let perform = methodPerformValue(.iequalTo__otherAttributed(Parameter<Attributed>.value(otherAttributed))) as? (Attributed) -> Void
		perform?(otherAttributed)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iequalTo__otherAttributed(Parameter<Attributed>.value(otherAttributed)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for equalTo(_ otherAttributed: Attributed). Use given")
    }

    fileprivate enum MethodType {
        case isamplePasses__sample(Parameter<Sample>)
        case iequalTo__otherRestriction(Parameter<AttributeRestriction>)
        case ivalue__of_attribute(Parameter<Attribute>)
        case iset__attribute_attributeto_value(Parameter<Attribute>, Parameter<Any>)
        case iequalTo__otherAttributed(Parameter<Attributed>)
        case restrictedAttribute_get
		case restrictedAttribute_set(Parameter<Attribute>)
        case name_get
		case name_set(Parameter<String>)
        case attributes_get
		case attributes_set(Parameter<[Attribute]>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.isamplePasses__sample(let lhsSample), .isamplePasses__sample(let rhsSample)):
                    guard Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher) else { return false } 
                    return true 
                case (.iequalTo__otherRestriction(let lhsOtherrestriction), .iequalTo__otherRestriction(let rhsOtherrestriction)):
                    guard Parameter.compare(lhs: lhsOtherrestriction, rhs: rhsOtherrestriction, with: matcher) else { return false } 
                    return true 
                case (.ivalue__of_attribute(let lhsAttribute), .ivalue__of_attribute(let rhsAttribute)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    return true 
                case (.iset__attribute_attributeto_value(let lhsAttribute, let lhsValue), .iset__attribute_attributeto_value(let rhsAttribute, let rhsValue)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                    return true 
                case (.iequalTo__otherAttributed(let lhsOtherattributed), .iequalTo__otherAttributed(let rhsOtherattributed)):
                    guard Parameter.compare(lhs: lhsOtherattributed, rhs: rhsOtherattributed, with: matcher) else { return false } 
                    return true 
                case (.restrictedAttribute_get,.restrictedAttribute_get): return true
				case (.restrictedAttribute_set(let left),.restrictedAttribute_set(let right)): return Parameter<Attribute>.compare(lhs: left, rhs: right, with: matcher)
                case (.name_get,.name_get): return true
				case (.name_set(let left),.name_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
                case (.attributes_get,.attributes_get): return true
				case (.attributes_set(let left),.attributes_set(let right)): return Parameter<[Attribute]>.compare(lhs: left, rhs: right, with: matcher)
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .isamplePasses__sample(p0): return p0.intValue
                case let .iequalTo__otherRestriction(p0): return p0.intValue
                case let .ivalue__of_attribute(p0): return p0.intValue
                case let .iset__attribute_attributeto_value(p0, p1): return p0.intValue + p1.intValue
                case let .iequalTo__otherAttributed(p0): return p0.intValue
                case .restrictedAttribute_get: return 0
				case .restrictedAttribute_set(let newValue): return newValue.intValue
                case .name_get: return 0
				case .name_set(let newValue): return newValue.intValue
                case .attributes_get: return 0
				case .attributes_set(let newValue): return newValue.intValue
            }
        }
    }

    struct Given {
        fileprivate var method: MethodType
        var returns: Any?
        var `throws`: Error?

        private init(method: MethodType, returns: Any?, throws: Error?) {
            self.method = method
            self.returns = returns
            self.`throws` = `throws`
        }

        static func samplePasses(sample: Parameter<Sample>, willReturn: Bool) -> Given {
            return Given(method: .isamplePasses__sample(sample), returns: willReturn, throws: nil)
        }
        static func equalTo(otherRestriction: Parameter<AttributeRestriction>, willReturn: Bool) -> Given {
            return Given(method: .iequalTo__otherRestriction(otherRestriction), returns: willReturn, throws: nil)
        }
        static func value(of attribute: Parameter<Attribute>, willReturn: Any) -> Given {
            return Given(method: .ivalue__of_attribute(attribute), returns: willReturn, throws: nil)
        }
        static func equalTo(otherAttributed: Parameter<Attributed>, willReturn: Bool) -> Given {
            return Given(method: .iequalTo__otherAttributed(otherAttributed), returns: willReturn, throws: nil)
        }
        static func samplePasses(sample: Parameter<Sample>, willThrow: Error) -> Given {
            return Given(method: .isamplePasses__sample(sample), returns: nil, throws: willThrow)
        }
        static func value(of attribute: Parameter<Attribute>, willThrow: Error) -> Given {
            return Given(method: .ivalue__of_attribute(attribute), returns: nil, throws: willThrow)
        }
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any>, willThrow: Error) -> Given {
            return Given(method: .iset__attribute_attributeto_value(attribute, value), returns: nil, throws: willThrow)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func samplePasses(sample: Parameter<Sample>) -> Verify {
            return Verify(method: .isamplePasses__sample(sample))
        }
        static func equalTo(otherRestriction: Parameter<AttributeRestriction>) -> Verify {
            return Verify(method: .iequalTo__otherRestriction(otherRestriction))
        }
        static func value(of attribute: Parameter<Attribute>) -> Verify {
            return Verify(method: .ivalue__of_attribute(attribute))
        }
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any>) -> Verify {
            return Verify(method: .iset__attribute_attributeto_value(attribute, value))
        }
        static func equalTo(otherAttributed: Parameter<Attributed>) -> Verify {
            return Verify(method: .iequalTo__otherAttributed(otherAttributed))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func samplePasses(sample: Parameter<Sample>, perform: (Sample) -> Void) -> Perform {
            return Perform(method: .isamplePasses__sample(sample), performs: perform)
        }
        static func equalTo(otherRestriction: Parameter<AttributeRestriction>, perform: (AttributeRestriction) -> Void) -> Perform {
            return Perform(method: .iequalTo__otherRestriction(otherRestriction), performs: perform)
        }
        static func value(of attribute: Parameter<Attribute>, perform: (Attribute) -> Void) -> Perform {
            return Perform(method: .ivalue__of_attribute(attribute), performs: perform)
        }
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any>, perform: (Attribute, Any) -> Void) -> Perform {
            return Perform(method: .iset__attribute_attributeto_value(attribute, value), performs: perform)
        }
        static func equalTo(otherAttributed: Parameter<Attributed>, perform: (Attributed) -> Void) -> Perform {
            return Perform(method: .iequalTo__otherAttributed(otherAttributed), performs: perform)
        }
    }

    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
        methodReturnValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expeced: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(property.method)
        MockyAssert(count.matches(invocations.count), "Expeced: \(count) invocations of `\(property.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }

    private func methodReturnValue(_ method: MethodType) -> (value: Any?, error: Error?) {
        let matched = methodReturnValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher)  }
        return (value: matched?.returns, error: matched?.`throws`)
    }

    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }

    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
// sourcery:end
}
