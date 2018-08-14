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

    var dates: [DateType: Date] { 
		get {	invocations.append(.dates_get)
				return __dates.orFail("SampleMockMock - value for dates was not defined") }
		set {	invocations.append(.dates_set(.value(newValue)))
				__dates = newValue }
	}
	private var __dates: ([DateType: Date])?
    var dataType: DataTypes { 
		get {	invocations.append(.dataType_get)
				return __dataType.orFail("SampleMockMock - value for dataType was not defined") }
		set {	invocations.append(.dataType_set(.value(newValue)))
				__dataType = newValue }
	}
	private var __dataType: (DataTypes)?
    var name: String { 
		get {	invocations.append(.name_get)
				return __name.orFail("SampleMockMock - value for name was not defined") }
		set {	invocations.append(.name_set(.value(newValue)))
				__name = newValue }
	}
	private var __name: (String)?
    var attributes: [Attribute] { 
		get {	invocations.append(.attributes_get)
				return __attributes.orFail("SampleMockMock - value for attributes was not defined") }
		set {	invocations.append(.attributes_set(.value(newValue)))
				__attributes = newValue }
	}
	private var __attributes: ([Attribute])?

    struct Property {
        fileprivate var method: MethodType
        static var dates: Property { return Property(method: .dates_get) }
		static func dates(set newValue: Parameter<[DateType: Date]>) -> Property { return Property(method: .dates_set(newValue)) }
        static var dataType: Property { return Property(method: .dataType_get) }
		static func dataType(set newValue: Parameter<DataTypes>) -> Property { return Property(method: .dataType_set(newValue)) }
        static var name: Property { return Property(method: .name_get) }
		static func name(set newValue: Parameter<String>) -> Property { return Property(method: .name_set(newValue)) }
        static var attributes: Property { return Property(method: .attributes_get) }
		static func attributes(set newValue: Parameter<[Attribute]>) -> Property { return Property(method: .attributes_set(newValue)) }
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

    fileprivate enum MethodType {
        case iequalTo__otherSample(Parameter<Sample>)
        case ivalue__of_attribute(Parameter<Attribute>)
        case iset__attribute_attributeto_value(Parameter<Attribute>, Parameter<Any>)
        case dates_get
		case dates_set(Parameter<[DateType: Date]>)
        case dataType_get
		case dataType_set(Parameter<DataTypes>)
        case name_get
		case name_set(Parameter<String>)
        case attributes_get
		case attributes_set(Parameter<[Attribute]>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
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
                case (.dates_get,.dates_get): return true
				case (.dates_set(let left),.dates_set(let right)): return Parameter<[DateType: Date]>.compare(lhs: left, rhs: right, with: matcher)
                case (.dataType_get,.dataType_get): return true
				case (.dataType_set(let left),.dataType_set(let right)): return Parameter<DataTypes>.compare(lhs: left, rhs: right, with: matcher)
                case (.name_get,.name_get): return true
				case (.name_set(let left),.name_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
                case (.attributes_get,.attributes_get): return true
				case (.attributes_set(let left),.attributes_set(let right)): return Parameter<[Attribute]>.compare(lhs: left, rhs: right, with: matcher)
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .iequalTo__otherSample(p0): return p0.intValue
                case let .ivalue__of_attribute(p0): return p0.intValue
                case let .iset__attribute_attributeto_value(p0, p1): return p0.intValue + p1.intValue
                case .dates_get: return 0
				case .dates_set(let newValue): return newValue.intValue
                case .dataType_get: return 0
				case .dataType_set(let newValue): return newValue.intValue
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

        static func equalTo(otherSample: Parameter<Sample>, willReturn: Bool) -> Given {
            return Given(method: .iequalTo__otherSample(otherSample), returns: willReturn, throws: nil)
        }
        static func value(of attribute: Parameter<Attribute>, willReturn: Any) -> Given {
            return Given(method: .ivalue__of_attribute(attribute), returns: willReturn, throws: nil)
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

        static func equalTo(otherSample: Parameter<Sample>) -> Verify {
            return Verify(method: .iequalTo__otherSample(otherSample))
        }
        static func value(of attribute: Parameter<Attribute>) -> Verify {
            return Verify(method: .ivalue__of_attribute(attribute))
        }
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any>) -> Verify {
            return Verify(method: .iset__attribute_attributeto_value(attribute, value))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func equalTo(otherSample: Parameter<Sample>, perform: (Sample) -> Void) -> Perform {
            return Perform(method: .iequalTo__otherSample(otherSample), performs: perform)
        }
        static func value(of attribute: Parameter<Attribute>, perform: (Attribute) -> Void) -> Perform {
            return Perform(method: .ivalue__of_attribute(attribute), performs: perform)
        }
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any>, perform: (Attribute, Any) -> Void) -> Perform {
            return Perform(method: .iset__attribute_attributeto_value(attribute, value), performs: perform)
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
