//
//  SubQueryMatcherMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective

// sourcery: mock = "SubQueryMatcher"
class SubQueryMatcherMock: SubQueryMatcher, Mock {
	fileprivate var _description: String!

	var description: String {
		get { return _description }
		set { _description = newValue }
	}

// sourcery:inline:auto:SubQueryMatcherMock.autoMocked
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    var mostRecentOnly: Bool { 
		get {	invocations.append(.mostRecentOnly_get)
				return __mostRecentOnly.orFail("SubQueryMatcherMock - value for mostRecentOnly was not defined") }
		set {	invocations.append(.mostRecentOnly_set(.value(newValue)))
				__mostRecentOnly = newValue }
	}
	private var __mostRecentOnly: (Bool)?


    var name: String { 
		get {	invocations.append(.name_get)
				return __name.orFail("SubQueryMatcherMock - value for name was not defined") }
		set {	invocations.append(.name_set(.value(newValue)))
				__name = newValue }
	}
	private var __name: (String)?


    var attributes: [Attribute] { 
		get {	invocations.append(.attributes_get)
				return __attributes.orFail("SubQueryMatcherMock - value for attributes was not defined") }
		set {	invocations.append(.attributes_set(.value(newValue)))
				__attributes = newValue }
	}
	private var __attributes: ([Attribute])?


    var debugDescription: String { 
		get {	invocations.append(.debugDescription_get)
				return __debugDescription.orFail("SubQueryMatcherMock - value for debugDescription was not defined") }
		set {	invocations.append(.debugDescription_set(.value(newValue)))
				__debugDescription = newValue }
	}
	private var __debugDescription: (String)?


    struct Property {
        fileprivate var method: MethodType
        static var mostRecentOnly: Property { return Property(method: .mostRecentOnly_get) }
		static func mostRecentOnly(set newValue: Parameter<Bool>) -> Property { return Property(method: .mostRecentOnly_set(newValue)) }
        static var name: Property { return Property(method: .name_get) }
		static func name(set newValue: Parameter<String>) -> Property { return Property(method: .name_set(newValue)) }
        static var attributes: Property { return Property(method: .attributes_get) }
		static func attributes(set newValue: Parameter<[Attribute]>) -> Property { return Property(method: .attributes_set(newValue)) }
        static var debugDescription: Property { return Property(method: .debugDescription_get) }
		static func debugDescription(set newValue: Parameter<String>) -> Property { return Property(method: .debugDescription_set(newValue)) }
    }




    required init() { }

    func getSamples<QuerySampleType: Sample>(from querySamples: [QuerySampleType], matching subQuerySamples: [Sample]) -> [QuerySampleType] {
        addInvocation(.igetSamples__from_querySamplesmatching_subQuerySamples(Parameter<[QuerySampleType]>.value(querySamples).wrapAsGeneric(), Parameter<[Sample]>.value(subQuerySamples)))
		let perform = methodPerformValue(.igetSamples__from_querySamplesmatching_subQuerySamples(Parameter<[QuerySampleType]>.value(querySamples).wrapAsGeneric(), Parameter<[Sample]>.value(subQuerySamples))) as? ([QuerySampleType], [Sample]) -> Void
		perform?(querySamples, subQuerySamples)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.igetSamples__from_querySamplesmatching_subQuerySamples(Parameter<[QuerySampleType]>.value(querySamples).wrapAsGeneric(), Parameter<[Sample]>.value(subQuerySamples)))
		let value = givenValue.value as? [QuerySampleType]
		return value.orFail("stub return value not specified for getSamples<QuerySampleType: Sample>(from querySamples: [QuerySampleType], matching subQuerySamples: [Sample]). Use given")
    }

    func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
        addInvocation(.iequalTo__otherMatcher(Parameter<SubQueryMatcher>.value(otherMatcher)))
		let perform = methodPerformValue(.iequalTo__otherMatcher(Parameter<SubQueryMatcher>.value(otherMatcher))) as? (SubQueryMatcher) -> Void
		perform?(otherMatcher)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iequalTo__otherMatcher(Parameter<SubQueryMatcher>.value(otherMatcher)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for equalTo(_ otherMatcher: SubQueryMatcher). Use given")
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
        case igetSamples__from_querySamplesmatching_subQuerySamples(Parameter<GenericAttribute>, Parameter<[Sample]>)
        case iequalTo__otherMatcher(Parameter<SubQueryMatcher>)
        case ivalue__of_attribute(Parameter<Attribute>)
        case iset__attribute_attributeto_value(Parameter<Attribute>, Parameter<Any>)
        case iequalTo__otherAttributed(Parameter<Attributed>)
        case mostRecentOnly_get
		case mostRecentOnly_set(Parameter<Bool>)
        case name_get
		case name_set(Parameter<String>)
        case attributes_get
		case attributes_set(Parameter<[Attribute]>)
        case debugDescription_get
		case debugDescription_set(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.igetSamples__from_querySamplesmatching_subQuerySamples(let lhsQuerysamples, let lhsSubquerysamples), .igetSamples__from_querySamplesmatching_subQuerySamples(let rhsQuerysamples, let rhsSubquerysamples)):
                    guard Parameter.compare(lhs: lhsQuerysamples, rhs: rhsQuerysamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSubquerysamples, rhs: rhsSubquerysamples, with: matcher) else { return false } 
                    return true 
                case (.iequalTo__otherMatcher(let lhsOthermatcher), .iequalTo__otherMatcher(let rhsOthermatcher)):
                    guard Parameter.compare(lhs: lhsOthermatcher, rhs: rhsOthermatcher, with: matcher) else { return false } 
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
                case (.mostRecentOnly_get,.mostRecentOnly_get): return true
				case (.mostRecentOnly_set(let left),.mostRecentOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
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
                case let .igetSamples__from_querySamplesmatching_subQuerySamples(p0, p1): return p0.intValue + p1.intValue
                case let .iequalTo__otherMatcher(p0): return p0.intValue
                case let .ivalue__of_attribute(p0): return p0.intValue
                case let .iset__attribute_attributeto_value(p0, p1): return p0.intValue + p1.intValue
                case let .iequalTo__otherAttributed(p0): return p0.intValue
                case .mostRecentOnly_get: return 0
				case .mostRecentOnly_set(let newValue): return newValue.intValue
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

        static func getSamples<QuerySampleType: Sample>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>, willReturn: [QuerySampleType]) -> Given {
            return Given(method: .igetSamples__from_querySamplesmatching_subQuerySamples(querySamples.wrapAsGeneric(), subQuerySamples), returns: willReturn, throws: nil)
        }
        static func equalTo(otherMatcher: Parameter<SubQueryMatcher>, willReturn: Bool) -> Given {
            return Given(method: .iequalTo__otherMatcher(otherMatcher), returns: willReturn, throws: nil)
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

        static func getSamples<QuerySampleType>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>) -> Verify {
            return Verify(method: .igetSamples__from_querySamplesmatching_subQuerySamples(querySamples.wrapAsGeneric(), subQuerySamples))
        }
        static func equalTo(otherMatcher: Parameter<SubQueryMatcher>) -> Verify {
            return Verify(method: .iequalTo__otherMatcher(otherMatcher))
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

        static func getSamples<QuerySampleType>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>, perform: ([QuerySampleType], [Sample]) -> Void) -> Perform {
            return Perform(method: .igetSamples__from_querySamplesmatching_subQuerySamples(querySamples.wrapAsGeneric(), subQuerySamples), performs: perform)
        }
        static func equalTo(otherMatcher: Parameter<SubQueryMatcher>, perform: (SubQueryMatcher) -> Void) -> Perform {
            return Perform(method: .iequalTo__otherMatcher(otherMatcher), performs: perform)
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
