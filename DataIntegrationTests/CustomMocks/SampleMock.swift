//
//  SampleMock.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import XCTest
import SwiftyMocky
@testable import DataIntegration

// sourcery: mock = "Sample"
class SampleMock: Sample, Mock {
	fileprivate var _description: String!

	var description: String {
		get { return _description }
		set { _description = newValue }
	}

// sourcery:inline:auto:SampleMock.autoMocked
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default
    static private var invocations: [StaticMethodType] = []
    static private var methodReturnValues: [StaticGiven] = []
    static private var methodPerformValues: [StaticPerform] = []
    static var matcher: Matcher = Matcher.default
    static func clear() {
        invocations = []
        methodReturnValues = []
        methodPerformValues = []
    }


    var name: String { 
		get {	invocations.append(.name_get)
				return __name.orFail("SampleMock - value for name was not defined") }
		set {	invocations.append(.name_set(.value(newValue)))
				__name = newValue }
	}
	private var __name: (String)?


    var attributes: [Attribute] { 
		get {	invocations.append(.attributes_get)
				return __attributes.orFail("SampleMock - value for attributes was not defined") }
		set {	invocations.append(.attributes_set(.value(newValue)))
				__attributes = newValue }
	}
	private var __attributes: ([Attribute])?


    var debugDescription: String { 
		get {	invocations.append(.debugDescription_get)
				return __debugDescription.orFail("SampleMock - value for debugDescription was not defined") }
		set {	invocations.append(.debugDescription_set(.value(newValue)))
				__debugDescription = newValue }
	}
	private var __debugDescription: (String)?


    struct Property {
        fileprivate var method: MethodType
        static var name: Property { return Property(method: .name_get) }
		static func name(set newValue: Parameter<String>) -> Property { return Property(method: .name_set(newValue)) }
        static var attributes: Property { return Property(method: .attributes_get) }
		static func attributes(set newValue: Parameter<[Attribute]>) -> Property { return Property(method: .attributes_set(newValue)) }
        static var debugDescription: Property { return Property(method: .debugDescription_get) }
		static func debugDescription(set newValue: Parameter<String>) -> Property { return Property(method: .debugDescription_set(newValue)) }
    }

    static var name: String { 
		get {	SampleMock.invocations.append(.name_get)
				return SampleMock.__name.orFail("SampleMock - value for name was not defined") }
		set {	SampleMock.invocations.append(.name_set(.value(newValue)))
				SampleMock.__name = newValue }
	}
	private static var __name: (String)?


    static var attributes: [Attribute] { 
		get {	SampleMock.invocations.append(.attributes_get)
				return SampleMock.__attributes.orFail("SampleMock - value for attributes was not defined") }
		set {	SampleMock.invocations.append(.attributes_set(.value(newValue)))
				SampleMock.__attributes = newValue }
	}
	private static var __attributes: ([Attribute])?


    static var defaultDependentAttribute: Attribute { 
		get {	SampleMock.invocations.append(.defaultDependentAttribute_get)
				return SampleMock.__defaultDependentAttribute.orFail("SampleMock - value for defaultDependentAttribute was not defined") }
		set {	SampleMock.invocations.append(.defaultDependentAttribute_set(.value(newValue)))
				SampleMock.__defaultDependentAttribute = newValue }
	}
	private static var __defaultDependentAttribute: (Attribute)?


    static var defaultIndependentAttribute: Attribute { 
		get {	SampleMock.invocations.append(.defaultIndependentAttribute_get)
				return SampleMock.__defaultIndependentAttribute.orFail("SampleMock - value for defaultIndependentAttribute was not defined") }
		set {	SampleMock.invocations.append(.defaultIndependentAttribute_set(.value(newValue)))
				SampleMock.__defaultIndependentAttribute = newValue }
	}
	private static var __defaultIndependentAttribute: (Attribute)?


    struct StaticProperty {
        fileprivate var method: StaticMethodType
        static var name: StaticProperty { return StaticProperty(method: .name_get) }
		static func name(set newValue: Parameter<String>) -> StaticProperty { return StaticProperty(method: .name_set(newValue)) }
        static var attributes: StaticProperty { return StaticProperty(method: .attributes_get) }
		static func attributes(set newValue: Parameter<[Attribute]>) -> StaticProperty { return StaticProperty(method: .attributes_set(newValue)) }
        static var defaultDependentAttribute: StaticProperty { return StaticProperty(method: .defaultDependentAttribute_get) }
		static func defaultDependentAttribute(set newValue: Parameter<Attribute>) -> StaticProperty { return StaticProperty(method: .defaultDependentAttribute_set(newValue)) }
        static var defaultIndependentAttribute: StaticProperty { return StaticProperty(method: .defaultIndependentAttribute_get) }
		static func defaultIndependentAttribute(set newValue: Parameter<Attribute>) -> StaticProperty { return StaticProperty(method: .defaultIndependentAttribute_set(newValue)) }
    }



    func dates() -> [DateType: Date] {
        addInvocation(.idates)
		let perform = methodPerformValue(.idates) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.idates)
		let value = givenValue.value as? [DateType: Date]
		return value.orFail("stub return value not specified for dates(). Use given")
    }

    func equalTo(_ otherSample: Sample) -> Bool {
        addInvocation(.iequalTo__otherSample(Parameter<Sample>.value(otherSample)))
		let perform = methodPerformValue(.iequalTo__otherSample(Parameter<Sample>.value(otherSample))) as? (Sample) -> Void
		perform?(otherSample)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iequalTo__otherSample(Parameter<Sample>.value(otherSample)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for equalTo(_ otherSample: Sample). Use given")
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

    fileprivate enum StaticMethodType {

        case name_get
		case name_set(Parameter<String>)
        case attributes_get
		case attributes_set(Parameter<[Attribute]>)
        case defaultDependentAttribute_get
		case defaultDependentAttribute_set(Parameter<Attribute>)
        case defaultIndependentAttribute_get
		case defaultIndependentAttribute_set(Parameter<Attribute>)

        static func compareParameters(lhs: StaticMethodType, rhs: StaticMethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.name_get,.name_get): return true
				case (.name_set(let left),.name_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
                case (.attributes_get,.attributes_get): return true
				case (.attributes_set(let left),.attributes_set(let right)): return Parameter<[Attribute]>.compare(lhs: left, rhs: right, with: matcher)
                case (.defaultDependentAttribute_get,.defaultDependentAttribute_get): return true
				case (.defaultDependentAttribute_set(let left),.defaultDependentAttribute_set(let right)): return Parameter<Attribute>.compare(lhs: left, rhs: right, with: matcher)
                case (.defaultIndependentAttribute_get,.defaultIndependentAttribute_get): return true
				case (.defaultIndependentAttribute_set(let left),.defaultIndependentAttribute_set(let right)): return Parameter<Attribute>.compare(lhs: left, rhs: right, with: matcher)
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case .name_get: return 0
				case .name_set(let newValue): return newValue.intValue
                case .attributes_get: return 0
				case .attributes_set(let newValue): return newValue.intValue
                case .defaultDependentAttribute_get: return 0
				case .defaultDependentAttribute_set(let newValue): return newValue.intValue
                case .defaultIndependentAttribute_get: return 0
				case .defaultIndependentAttribute_set(let newValue): return newValue.intValue
            }
        }
    }

    struct StaticGiven {
        fileprivate var method: StaticMethodType
        var returns: Any?
        var `throws`: Error?

        private init(method: StaticMethodType, returns: Any?, throws: Error?) {
            self.method = method
            self.returns = returns
            self.`throws` = `throws`
        }

    }

    struct StaticVerify {
        fileprivate var method: StaticMethodType

    }

    struct StaticPerform {
        fileprivate var method: StaticMethodType
        var performs: Any

    }

        fileprivate enum MethodType {
        case idates
        case iequalTo__otherSample(Parameter<Sample>)
        case ivalue__of_attribute(Parameter<Attribute>)
        case iset__attribute_attributeto_value(Parameter<Attribute>, Parameter<Any>)
        case iequalTo__otherAttributed(Parameter<Attributed>)
        case name_get
		case name_set(Parameter<String>)
        case attributes_get
		case attributes_set(Parameter<[Attribute]>)
        case debugDescription_get
		case debugDescription_set(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.idates, .idates):
                    return true 
                case (.iequalTo__otherSample(let lhsOthersample), .iequalTo__otherSample(let rhsOthersample)):
                    guard Parameter.compare(lhs: lhsOthersample, rhs: rhsOthersample, with: matcher) else { return false } 
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
                case (.name_get,.name_get): return true
				case (.name_set(let left),.name_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
                case (.attributes_get,.attributes_get): return true
				case (.attributes_set(let left),.attributes_set(let right)): return Parameter<[Attribute]>.compare(lhs: left, rhs: right, with: matcher)
                case (.debugDescription_get,.debugDescription_get): return true
				case (.debugDescription_set(let left),.debugDescription_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case .idates: return 0
                case let .iequalTo__otherSample(p0): return p0.intValue
                case let .ivalue__of_attribute(p0): return p0.intValue
                case let .iset__attribute_attributeto_value(p0, p1): return p0.intValue + p1.intValue
                case let .iequalTo__otherAttributed(p0): return p0.intValue
                case .name_get: return 0
				case .name_set(let newValue): return newValue.intValue
                case .attributes_get: return 0
				case .attributes_set(let newValue): return newValue.intValue
                case .debugDescription_get: return 0
				case .debugDescription_set(let newValue): return newValue.intValue
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

        static func dates(willReturn: [DateType: Date]) -> Given {
            return Given(method: .idates, returns: willReturn, throws: nil)
        }
        static func equalTo(otherSample: Parameter<Sample>, willReturn: Bool) -> Given {
            return Given(method: .iequalTo__otherSample(otherSample), returns: willReturn, throws: nil)
        }
        static func value(of attribute: Parameter<Attribute>, willReturn: Any) -> Given {
            return Given(method: .ivalue__of_attribute(attribute), returns: willReturn, throws: nil)
        }
        static func equalTo(otherAttributed: Parameter<Attributed>, willReturn: Bool) -> Given {
            return Given(method: .iequalTo__otherAttributed(otherAttributed), returns: willReturn, throws: nil)
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

        static func dates() -> Verify {
            return Verify(method: .idates)
        }
        static func equalTo(otherSample: Parameter<Sample>) -> Verify {
            return Verify(method: .iequalTo__otherSample(otherSample))
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

        static func dates(perform: () -> Void) -> Perform {
            return Perform(method: .idates, performs: perform)
        }
        static func equalTo(otherSample: Parameter<Sample>, perform: (Sample) -> Void) -> Perform {
            return Perform(method: .iequalTo__otherSample(otherSample), performs: perform)
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

    static private func matchingCalls(_ method: StaticVerify) -> Int {
        return matchingCalls(method.method).count
    }

    static public func given(_ method: StaticGiven) {
        methodReturnValues.append(method)
        methodReturnValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    static public func perform(_ method: StaticPerform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    static public func verify(_ method: StaticVerify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expeced: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    static public func verify(property: StaticProperty, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(property.method)
        MockyAssert(count.matches(invocations.count), "Expeced: \(count) invocations of `\(property.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    static private func addInvocation(_ call: StaticMethodType) {
        invocations.append(call)
    }

    static private func methodReturnValue(_ method: StaticMethodType) -> (value: Any?, error: Error?) {
        let matched = methodReturnValues.reversed().first { StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher)  }
        return (value: matched?.returns, error: matched?.`throws`)
    }

    static private func methodPerformValue(_ method: StaticMethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }

    static private func matchingCalls(_ method: StaticMethodType) -> [StaticMethodType] {
        return invocations.filter { StaticMethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
// sourcery:end
}
