//
//  SampleQueryMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective

// sourcery: mock = "SampleQuery"
class SampleQueryMock<SampleType: Sample>: SampleQuery, Mock {
// sourcery:inline:auto:SampleQueryMock.autoMocked
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    var attributeRestrictions: [AttributeRestriction] { 
		get {	invocations.append(.attributeRestrictions_get)
				return __attributeRestrictions.orFail("SampleQueryMock - value for attributeRestrictions was not defined") }
		set {	invocations.append(.attributeRestrictions_set(.value(newValue)))
				__attributeRestrictions = newValue }
	}
	private var __attributeRestrictions: ([AttributeRestriction])?


    var mostRecentEntryOnly: Bool { 
		get {	invocations.append(.mostRecentEntryOnly_get)
				return __mostRecentEntryOnly.orFail("SampleQueryMock - value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.mostRecentEntryOnly_set(.value(newValue)))
				__mostRecentEntryOnly = newValue }
	}
	private var __mostRecentEntryOnly: (Bool)?


    var subQuery: (matcher: SubQueryMatcher, query: Query)? { 
		get {	invocations.append(.subQuery_get)
				return __subQuery }
		set {	invocations.append(.subQuery_set(.value(newValue)))
				__subQuery = newValue }
	}
	private var __subQuery: ((matcher: SubQueryMatcher, query: Query))?


    struct Property {
        fileprivate var method: MethodType
        static var attributeRestrictions: Property { return Property(method: .attributeRestrictions_get) }
		static func attributeRestrictions(set newValue: Parameter<[AttributeRestriction]>) -> Property { return Property(method: .attributeRestrictions_set(newValue)) }
        static var mostRecentEntryOnly: Property { return Property(method: .mostRecentEntryOnly_get) }
		static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Property { return Property(method: .mostRecentEntryOnly_set(newValue)) }
        static var subQuery: Property { return Property(method: .subQuery_get) }
		static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Property { return Property(method: .subQuery_set(newValue)) }
    }




    func runQuery(callback: @escaping (SampleQueryResult<SampleType>?, Error?) -> ()) {
        addInvocation(.irunQuery__callback_callback_1(Parameter<(SampleQueryResult<SampleType>?, Error?) -> ()>.value(callback)))
		let perform = methodPerformValue(.irunQuery__callback_callback_1(Parameter<(SampleQueryResult<SampleType>?, Error?) -> ()>.value(callback))) as? (@escaping (SampleQueryResult<SampleType>?, Error?) -> ()) -> Void
		perform?(callback)
    }

    func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.irunQuery__callback_callback_2(Parameter<(QueryResult?, Error?) -> ()>.value(callback)))
		let perform = methodPerformValue(.irunQuery__callback_callback_2(Parameter<(QueryResult?, Error?) -> ()>.value(callback))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(callback)
    }

    func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.iequalTo__otherQuery(Parameter<Query>.value(otherQuery)))
		let perform = methodPerformValue(.iequalTo__otherQuery(Parameter<Query>.value(otherQuery))) as? (Query) -> Void
		perform?(otherQuery)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iequalTo__otherQuery(Parameter<Query>.value(otherQuery)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for equalTo(_ otherQuery: Query). Use given")
    }

    fileprivate enum MethodType {
        case irunQuery__callback_callback_1(Parameter<(SampleQueryResult<SampleType>?, Error?) -> ()>)
        case irunQuery__callback_callback_2(Parameter<(QueryResult?, Error?) -> ()>)
        case iequalTo__otherQuery(Parameter<Query>)
        case attributeRestrictions_get
		case attributeRestrictions_set(Parameter<[AttributeRestriction]>)
        case mostRecentEntryOnly_get
		case mostRecentEntryOnly_set(Parameter<Bool>)
        case subQuery_get
		case subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.irunQuery__callback_callback_1(let lhsCallback), .irunQuery__callback_callback_1(let rhsCallback)):
                    guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                    return true 
                case (.irunQuery__callback_callback_2(let lhsCallback), .irunQuery__callback_callback_2(let rhsCallback)):
                    guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                    return true 
                case (.iequalTo__otherQuery(let lhsOtherquery), .iequalTo__otherQuery(let rhsOtherquery)):
                    guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                    return true 
                case (.attributeRestrictions_get,.attributeRestrictions_get): return true
				case (.attributeRestrictions_set(let left),.attributeRestrictions_set(let right)): return Parameter<[AttributeRestriction]>.compare(lhs: left, rhs: right, with: matcher)
                case (.mostRecentEntryOnly_get,.mostRecentEntryOnly_get): return true
				case (.mostRecentEntryOnly_set(let left),.mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
                case (.subQuery_get,.subQuery_get): return true
				case (.subQuery_set(let left),.subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .irunQuery__callback_callback_1(p0): return p0.intValue
                case let .irunQuery__callback_callback_2(p0): return p0.intValue
                case let .iequalTo__otherQuery(p0): return p0.intValue
                case .attributeRestrictions_get: return 0
				case .attributeRestrictions_set(let newValue): return newValue.intValue
                case .mostRecentEntryOnly_get: return 0
				case .mostRecentEntryOnly_set(let newValue): return newValue.intValue
                case .subQuery_get: return 0
				case .subQuery_set(let newValue): return newValue.intValue
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

        static func equalTo(otherQuery: Parameter<Query>, willReturn: Bool) -> Given {
            return Given(method: .iequalTo__otherQuery(otherQuery), returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func runQuery(callback: Parameter<(SampleQueryResult<SampleType>?, Error?) -> ()>) -> Verify {
            return Verify(method: .irunQuery__callback_callback_1(callback))
        }
        static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify {
            return Verify(method: .irunQuery__callback_callback_2(callback))
        }
        static func equalTo(otherQuery: Parameter<Query>) -> Verify {
            return Verify(method: .iequalTo__otherQuery(otherQuery))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func runQuery(callback: Parameter<(SampleQueryResult<SampleType>?, Error?) -> ()>, perform: (@escaping (SampleQueryResult<SampleType>?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .irunQuery__callback_callback_1(callback), performs: perform)
        }
        static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .irunQuery__callback_callback_2(callback), performs: perform)
        }
        static func equalTo(otherQuery: Parameter<Query>, perform: (Query) -> Void) -> Perform {
            return Perform(method: .iequalTo__otherQuery(otherQuery), performs: perform)
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
