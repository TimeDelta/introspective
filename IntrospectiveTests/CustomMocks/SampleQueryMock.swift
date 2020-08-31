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
@testable import BooleanAlgebra
@testable import Queries
@testable import Samples

// sourcery: mock = "SampleQuery"
class SampleQueryMock<SampleType: Sample>: SampleQuery, Mock {
// sourcery:inline:auto:SampleQueryMock.autoMocked
    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }

    private static func isCapturing<T>(_ param: Parameter<T>) -> Bool {
        switch param {
            // can't use `case .capturing(_, _):` here because it causes an EXC_BAD_ACCESS error
            case .value(_):
                return false
            case .matching(_):
                return false
            case ._:
                return false
            default:
                return true
        }
    }



    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "SampleQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "SampleQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?


    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "SampleQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?






    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (SampleQueryResult<SampleType>?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback_1(Parameter<(SampleQueryResult<SampleType>?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback_1(Parameter<(SampleQueryResult<SampleType>?, Error?) -> Void>.value(`callback`))) as? (@escaping (SampleQueryResult<SampleType>?, Error?) -> Void) -> Void
		perform?(`callback`)
    }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback_2(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback_2(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback_1(Parameter<(SampleQueryResult<SampleType>?, Error?) -> Void>)
        case m_runQuery__callback_callback_2(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback_1(let lhsCallback), .m_runQuery__callback_callback_1(let rhsCallback)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsCallback) && !isCapturing(rhsCallback) {
					comparison = Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCallback, rhsCallback, "callback"))
				}

				if isCapturing(lhsCallback) || isCapturing(rhsCallback) {
					comparison = Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCallback, rhsCallback, "callback"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_runQuery__callback_callback_2(let lhsCallback), .m_runQuery__callback_callback_2(let rhsCallback)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsCallback) && !isCapturing(rhsCallback) {
					comparison = Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCallback, rhsCallback, "callback"))
				}

				if isCapturing(lhsCallback) || isCapturing(rhsCallback) {
					comparison = Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCallback, rhsCallback, "callback"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_stop, .m_stop): return .match

            case (.m_resetStoppedState, .m_resetStoppedState): return .match

            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsOtherquery) && !isCapturing(rhsOtherquery) {
					comparison = Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOtherquery, rhsOtherquery, "_ otherQuery"))
				}

				if isCapturing(lhsOtherquery) || isCapturing(rhsOtherquery) {
					comparison = Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOtherquery, rhsOtherquery, "_ otherQuery"))
				}

				return Matcher.ComparisonResult(results)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback_1(p0): return p0.intValue
            case let .m_runQuery__callback_callback_2(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback_1: return ".runQuery(callback:)"
            case .m_runQuery__callback_callback_2: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_subQuery_get: return "[get] .subQuery"
			case .p_subQuery_set: return "[set] .subQuery"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(SampleQueryResult<SampleType>?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback_1(`callback`))}
        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback_2(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(SampleQueryResult<SampleType>?, Error?) -> Void>, perform: @escaping (@escaping (SampleQueryResult<SampleType>?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback_1(`callback`), performs: perform)
        }
        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback_2(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
// sourcery:end
}
