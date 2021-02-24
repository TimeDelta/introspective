// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



// Generated with SwiftyMocky 4.0.0

import SwiftyMocky
import XCTest
import HealthKit
import CoreData
import Presentr
import CSV
import SwiftDate
import UserNotifications
import Instructions
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import BooleanAlgebra
@testable import Common
@testable import DataExport
@testable import DataImport
@testable import DependencyInjection
@testable import Notifications
@testable import Persistence
@testable import Queries
@testable import SampleGroupers
@testable import SampleGroupInformation
@testable import Samples
@testable import Settings
@testable import UIExtensions


// MARK: - ActivityQuery

open class ActivityQueryMock: ActivityQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "ActivityQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "ActivityQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "ActivityQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - BloodPressureQuery

open class BloodPressureQueryMock: BloodPressureQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "BloodPressureQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "BloodPressureQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "BloodPressureQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - BodyMassIndexQuery

open class BodyMassIndexQueryMock: BodyMassIndexQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "BodyMassIndexQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "BodyMassIndexQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "BodyMassIndexQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - FatigueQuery

open class FatigueQueryMock: FatigueQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "FatigueQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "FatigueQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "FatigueQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - HeartRateQuery

open class HeartRateQueryMock: HeartRateQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "HeartRateQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "HeartRateQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "HeartRateQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - LeanBodyMassQuery

open class LeanBodyMassQueryMock: LeanBodyMassQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "LeanBodyMassQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "LeanBodyMassQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "LeanBodyMassQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - MedicationDoseQuery

open class MedicationDoseQueryMock: MedicationDoseQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "MedicationDoseQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "MedicationDoseQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "MedicationDoseQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - MoodQuery

open class MoodQueryMock: MoodQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "MoodQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "MoodQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "MoodQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - Query

open class QueryMock: Query, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "QueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "QueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "QueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - QueryFactory

open class QueryFactoryMock: QueryFactory, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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






    open func activityQuery() -> ActivityQuery {
        addInvocation(.m_activityQuery)
		let perform = methodPerformValue(.m_activityQuery) as? () -> Void
		perform?()
		var __value: ActivityQuery
		do {
		    __value = try methodReturnValue(.m_activityQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for activityQuery(). Use given")
			Failure("Stub return value not specified for activityQuery(). Use given")
		}
		return __value
    }

    open func activityQuery(_ parts: [BooleanExpressionPart]) throws -> ActivityQuery {
        addInvocation(.m_activityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_activityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: ActivityQuery
		do {
		    __value = try methodReturnValue(.m_activityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for activityQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for activityQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func bloodPressureQuery() -> BloodPressureQuery {
        addInvocation(.m_bloodPressureQuery)
		let perform = methodPerformValue(.m_bloodPressureQuery) as? () -> Void
		perform?()
		var __value: BloodPressureQuery
		do {
		    __value = try methodReturnValue(.m_bloodPressureQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for bloodPressureQuery(). Use given")
			Failure("Stub return value not specified for bloodPressureQuery(). Use given")
		}
		return __value
    }

    open func bloodPressureQuery(_ parts: [BooleanExpressionPart]) throws -> BloodPressureQuery {
        addInvocation(.m_bloodPressureQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_bloodPressureQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: BloodPressureQuery
		do {
		    __value = try methodReturnValue(.m_bloodPressureQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for bloodPressureQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for bloodPressureQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func bmiQuery() -> BodyMassIndexQuery {
        addInvocation(.m_bmiQuery)
		let perform = methodPerformValue(.m_bmiQuery) as? () -> Void
		perform?()
		var __value: BodyMassIndexQuery
		do {
		    __value = try methodReturnValue(.m_bmiQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for bmiQuery(). Use given")
			Failure("Stub return value not specified for bmiQuery(). Use given")
		}
		return __value
    }

    open func bmiQuery(_ parts: [BooleanExpressionPart]) throws -> BodyMassIndexQuery {
        addInvocation(.m_bmiQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_bmiQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: BodyMassIndexQuery
		do {
		    __value = try methodReturnValue(.m_bmiQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for bmiQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for bmiQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func fatigueQuery() -> FatigueQuery {
        addInvocation(.m_fatigueQuery)
		let perform = methodPerformValue(.m_fatigueQuery) as? () -> Void
		perform?()
		var __value: FatigueQuery
		do {
		    __value = try methodReturnValue(.m_fatigueQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for fatigueQuery(). Use given")
			Failure("Stub return value not specified for fatigueQuery(). Use given")
		}
		return __value
    }

    open func fatigueQuery(_ parts: [BooleanExpressionPart]) throws -> FatigueQuery {
        addInvocation(.m_fatigueQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_fatigueQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: FatigueQuery
		do {
		    __value = try methodReturnValue(.m_fatigueQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for fatigueQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for fatigueQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func heartRateQuery() -> HeartRateQuery {
        addInvocation(.m_heartRateQuery)
		let perform = methodPerformValue(.m_heartRateQuery) as? () -> Void
		perform?()
		var __value: HeartRateQuery
		do {
		    __value = try methodReturnValue(.m_heartRateQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for heartRateQuery(). Use given")
			Failure("Stub return value not specified for heartRateQuery(). Use given")
		}
		return __value
    }

    open func heartRateQuery(_ parts: [BooleanExpressionPart]) throws -> HeartRateQuery {
        addInvocation(.m_heartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_heartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: HeartRateQuery
		do {
		    __value = try methodReturnValue(.m_heartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for heartRateQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for heartRateQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func leanBodyMassQuery() -> LeanBodyMassQuery {
        addInvocation(.m_leanBodyMassQuery)
		let perform = methodPerformValue(.m_leanBodyMassQuery) as? () -> Void
		perform?()
		var __value: LeanBodyMassQuery
		do {
		    __value = try methodReturnValue(.m_leanBodyMassQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for leanBodyMassQuery(). Use given")
			Failure("Stub return value not specified for leanBodyMassQuery(). Use given")
		}
		return __value
    }

    open func leanBodyMassQuery(_ parts: [BooleanExpressionPart]) throws -> LeanBodyMassQuery {
        addInvocation(.m_leanBodyMassQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_leanBodyMassQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: LeanBodyMassQuery
		do {
		    __value = try methodReturnValue(.m_leanBodyMassQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for leanBodyMassQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for leanBodyMassQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func medicationDoseQuery() -> MedicationDoseQuery {
        addInvocation(.m_medicationDoseQuery)
		let perform = methodPerformValue(.m_medicationDoseQuery) as? () -> Void
		perform?()
		var __value: MedicationDoseQuery
		do {
		    __value = try methodReturnValue(.m_medicationDoseQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for medicationDoseQuery(). Use given")
			Failure("Stub return value not specified for medicationDoseQuery(). Use given")
		}
		return __value
    }

    open func medicationDoseQuery(_ parts: [BooleanExpressionPart]) throws -> MedicationDoseQuery {
        addInvocation(.m_medicationDoseQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_medicationDoseQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: MedicationDoseQuery
		do {
		    __value = try methodReturnValue(.m_medicationDoseQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for medicationDoseQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for medicationDoseQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func moodQuery() -> MoodQuery {
        addInvocation(.m_moodQuery)
		let perform = methodPerformValue(.m_moodQuery) as? () -> Void
		perform?()
		var __value: MoodQuery
		do {
		    __value = try methodReturnValue(.m_moodQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for moodQuery(). Use given")
			Failure("Stub return value not specified for moodQuery(). Use given")
		}
		return __value
    }

    open func moodQuery(_ parts: [BooleanExpressionPart]) throws -> MoodQuery {
        addInvocation(.m_moodQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_moodQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: MoodQuery
		do {
		    __value = try methodReturnValue(.m_moodQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for moodQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for moodQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func restingHeartRateQuery() -> RestingHeartRateQuery {
        addInvocation(.m_restingHeartRateQuery)
		let perform = methodPerformValue(.m_restingHeartRateQuery) as? () -> Void
		perform?()
		var __value: RestingHeartRateQuery
		do {
		    __value = try methodReturnValue(.m_restingHeartRateQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for restingHeartRateQuery(). Use given")
			Failure("Stub return value not specified for restingHeartRateQuery(). Use given")
		}
		return __value
    }

    open func restingHeartRateQuery(_ parts: [BooleanExpressionPart]) throws -> RestingHeartRateQuery {
        addInvocation(.m_restingHeartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_restingHeartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: RestingHeartRateQuery
		do {
		    __value = try methodReturnValue(.m_restingHeartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for restingHeartRateQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for restingHeartRateQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func sexualActivityQuery() -> SexualActivityQuery {
        addInvocation(.m_sexualActivityQuery)
		let perform = methodPerformValue(.m_sexualActivityQuery) as? () -> Void
		perform?()
		var __value: SexualActivityQuery
		do {
		    __value = try methodReturnValue(.m_sexualActivityQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sexualActivityQuery(). Use given")
			Failure("Stub return value not specified for sexualActivityQuery(). Use given")
		}
		return __value
    }

    open func sexualActivityQuery(_ parts: [BooleanExpressionPart]) throws -> SexualActivityQuery {
        addInvocation(.m_sexualActivityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_sexualActivityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: SexualActivityQuery
		do {
		    __value = try methodReturnValue(.m_sexualActivityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for sexualActivityQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for sexualActivityQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func sleepQuery() -> SleepQuery {
        addInvocation(.m_sleepQuery)
		let perform = methodPerformValue(.m_sleepQuery) as? () -> Void
		perform?()
		var __value: SleepQuery
		do {
		    __value = try methodReturnValue(.m_sleepQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sleepQuery(). Use given")
			Failure("Stub return value not specified for sleepQuery(). Use given")
		}
		return __value
    }

    open func sleepQuery(_ parts: [BooleanExpressionPart]) throws -> SleepQuery {
        addInvocation(.m_sleepQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_sleepQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: SleepQuery
		do {
		    __value = try methodReturnValue(.m_sleepQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for sleepQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for sleepQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func weightQuery() -> WeightQuery {
        addInvocation(.m_weightQuery)
		let perform = methodPerformValue(.m_weightQuery) as? () -> Void
		perform?()
		var __value: WeightQuery
		do {
		    __value = try methodReturnValue(.m_weightQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for weightQuery(). Use given")
			Failure("Stub return value not specified for weightQuery(). Use given")
		}
		return __value
    }

    open func weightQuery(_ parts: [BooleanExpressionPart]) throws -> WeightQuery {
        addInvocation(.m_weightQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_weightQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: WeightQuery
		do {
		    __value = try methodReturnValue(.m_weightQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for weightQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for weightQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func queryFor(_ sampleType: Sample.Type) throws -> Query {
        addInvocation(.m_queryFor__sampleType(Parameter<Sample.Type>.value(`sampleType`)))
		let perform = methodPerformValue(.m_queryFor__sampleType(Parameter<Sample.Type>.value(`sampleType`))) as? (Sample.Type) -> Void
		perform?(`sampleType`)
		var __value: Query
		do {
		    __value = try methodReturnValue(.m_queryFor__sampleType(Parameter<Sample.Type>.value(`sampleType`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for queryFor(_ sampleType: Sample.Type). Use given")
			Failure("Stub return value not specified for queryFor(_ sampleType: Sample.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_activityQuery
        case m_activityQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_bloodPressureQuery
        case m_bloodPressureQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_bmiQuery
        case m_bmiQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_fatigueQuery
        case m_fatigueQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_heartRateQuery
        case m_heartRateQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_leanBodyMassQuery
        case m_leanBodyMassQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_medicationDoseQuery
        case m_medicationDoseQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_moodQuery
        case m_moodQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_restingHeartRateQuery
        case m_restingHeartRateQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_sexualActivityQuery
        case m_sexualActivityQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_sleepQuery
        case m_sleepQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_weightQuery
        case m_weightQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_queryFor__sampleType(Parameter<Sample.Type>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_activityQuery, .m_activityQuery): return .match

            case (.m_activityQuery__parts(let lhsParts), .m_activityQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_bloodPressureQuery, .m_bloodPressureQuery): return .match

            case (.m_bloodPressureQuery__parts(let lhsParts), .m_bloodPressureQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_bmiQuery, .m_bmiQuery): return .match

            case (.m_bmiQuery__parts(let lhsParts), .m_bmiQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_fatigueQuery, .m_fatigueQuery): return .match

            case (.m_fatigueQuery__parts(let lhsParts), .m_fatigueQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_heartRateQuery, .m_heartRateQuery): return .match

            case (.m_heartRateQuery__parts(let lhsParts), .m_heartRateQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_leanBodyMassQuery, .m_leanBodyMassQuery): return .match

            case (.m_leanBodyMassQuery__parts(let lhsParts), .m_leanBodyMassQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_medicationDoseQuery, .m_medicationDoseQuery): return .match

            case (.m_medicationDoseQuery__parts(let lhsParts), .m_medicationDoseQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_moodQuery, .m_moodQuery): return .match

            case (.m_moodQuery__parts(let lhsParts), .m_moodQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_restingHeartRateQuery, .m_restingHeartRateQuery): return .match

            case (.m_restingHeartRateQuery__parts(let lhsParts), .m_restingHeartRateQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_sexualActivityQuery, .m_sexualActivityQuery): return .match

            case (.m_sexualActivityQuery__parts(let lhsParts), .m_sexualActivityQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_sleepQuery, .m_sleepQuery): return .match

            case (.m_sleepQuery__parts(let lhsParts), .m_sleepQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_weightQuery, .m_weightQuery): return .match

            case (.m_weightQuery__parts(let lhsParts), .m_weightQuery__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_queryFor__sampleType(let lhsSampletype), .m_queryFor__sampleType(let rhsSampletype)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSampletype) && !isCapturing(rhsSampletype) {
					comparison = Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSampletype, rhsSampletype, "_ sampleType"))
				}

				if isCapturing(lhsSampletype) || isCapturing(rhsSampletype) {
					comparison = Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSampletype, rhsSampletype, "_ sampleType"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_activityQuery: return 0
            case let .m_activityQuery__parts(p0): return p0.intValue
            case .m_bloodPressureQuery: return 0
            case let .m_bloodPressureQuery__parts(p0): return p0.intValue
            case .m_bmiQuery: return 0
            case let .m_bmiQuery__parts(p0): return p0.intValue
            case .m_fatigueQuery: return 0
            case let .m_fatigueQuery__parts(p0): return p0.intValue
            case .m_heartRateQuery: return 0
            case let .m_heartRateQuery__parts(p0): return p0.intValue
            case .m_leanBodyMassQuery: return 0
            case let .m_leanBodyMassQuery__parts(p0): return p0.intValue
            case .m_medicationDoseQuery: return 0
            case let .m_medicationDoseQuery__parts(p0): return p0.intValue
            case .m_moodQuery: return 0
            case let .m_moodQuery__parts(p0): return p0.intValue
            case .m_restingHeartRateQuery: return 0
            case let .m_restingHeartRateQuery__parts(p0): return p0.intValue
            case .m_sexualActivityQuery: return 0
            case let .m_sexualActivityQuery__parts(p0): return p0.intValue
            case .m_sleepQuery: return 0
            case let .m_sleepQuery__parts(p0): return p0.intValue
            case .m_weightQuery: return 0
            case let .m_weightQuery__parts(p0): return p0.intValue
            case let .m_queryFor__sampleType(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_activityQuery: return ".activityQuery()"
            case .m_activityQuery__parts: return ".activityQuery(_:)"
            case .m_bloodPressureQuery: return ".bloodPressureQuery()"
            case .m_bloodPressureQuery__parts: return ".bloodPressureQuery(_:)"
            case .m_bmiQuery: return ".bmiQuery()"
            case .m_bmiQuery__parts: return ".bmiQuery(_:)"
            case .m_fatigueQuery: return ".fatigueQuery()"
            case .m_fatigueQuery__parts: return ".fatigueQuery(_:)"
            case .m_heartRateQuery: return ".heartRateQuery()"
            case .m_heartRateQuery__parts: return ".heartRateQuery(_:)"
            case .m_leanBodyMassQuery: return ".leanBodyMassQuery()"
            case .m_leanBodyMassQuery__parts: return ".leanBodyMassQuery(_:)"
            case .m_medicationDoseQuery: return ".medicationDoseQuery()"
            case .m_medicationDoseQuery__parts: return ".medicationDoseQuery(_:)"
            case .m_moodQuery: return ".moodQuery()"
            case .m_moodQuery__parts: return ".moodQuery(_:)"
            case .m_restingHeartRateQuery: return ".restingHeartRateQuery()"
            case .m_restingHeartRateQuery__parts: return ".restingHeartRateQuery(_:)"
            case .m_sexualActivityQuery: return ".sexualActivityQuery()"
            case .m_sexualActivityQuery__parts: return ".sexualActivityQuery(_:)"
            case .m_sleepQuery: return ".sleepQuery()"
            case .m_sleepQuery__parts: return ".sleepQuery(_:)"
            case .m_weightQuery: return ".weightQuery()"
            case .m_weightQuery__parts: return ".weightQuery(_:)"
            case .m_queryFor__sampleType: return ".queryFor(_:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func activityQuery(willReturn: ActivityQuery...) -> MethodStub {
            return Given(method: .m_activityQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func activityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: ActivityQuery...) -> MethodStub {
            return Given(method: .m_activityQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func bloodPressureQuery(willReturn: BloodPressureQuery...) -> MethodStub {
            return Given(method: .m_bloodPressureQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func bloodPressureQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: BloodPressureQuery...) -> MethodStub {
            return Given(method: .m_bloodPressureQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func bmiQuery(willReturn: BodyMassIndexQuery...) -> MethodStub {
            return Given(method: .m_bmiQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func bmiQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: BodyMassIndexQuery...) -> MethodStub {
            return Given(method: .m_bmiQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func fatigueQuery(willReturn: FatigueQuery...) -> MethodStub {
            return Given(method: .m_fatigueQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func fatigueQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: FatigueQuery...) -> MethodStub {
            return Given(method: .m_fatigueQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func heartRateQuery(willReturn: HeartRateQuery...) -> MethodStub {
            return Given(method: .m_heartRateQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func heartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: HeartRateQuery...) -> MethodStub {
            return Given(method: .m_heartRateQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func leanBodyMassQuery(willReturn: LeanBodyMassQuery...) -> MethodStub {
            return Given(method: .m_leanBodyMassQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func leanBodyMassQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: LeanBodyMassQuery...) -> MethodStub {
            return Given(method: .m_leanBodyMassQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func medicationDoseQuery(willReturn: MedicationDoseQuery...) -> MethodStub {
            return Given(method: .m_medicationDoseQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func medicationDoseQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: MedicationDoseQuery...) -> MethodStub {
            return Given(method: .m_medicationDoseQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func moodQuery(willReturn: MoodQuery...) -> MethodStub {
            return Given(method: .m_moodQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func moodQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: MoodQuery...) -> MethodStub {
            return Given(method: .m_moodQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func restingHeartRateQuery(willReturn: RestingHeartRateQuery...) -> MethodStub {
            return Given(method: .m_restingHeartRateQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func restingHeartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: RestingHeartRateQuery...) -> MethodStub {
            return Given(method: .m_restingHeartRateQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sexualActivityQuery(willReturn: SexualActivityQuery...) -> MethodStub {
            return Given(method: .m_sexualActivityQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sexualActivityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: SexualActivityQuery...) -> MethodStub {
            return Given(method: .m_sexualActivityQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sleepQuery(willReturn: SleepQuery...) -> MethodStub {
            return Given(method: .m_sleepQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sleepQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: SleepQuery...) -> MethodStub {
            return Given(method: .m_sleepQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func weightQuery(willReturn: WeightQuery...) -> MethodStub {
            return Given(method: .m_weightQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func weightQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: WeightQuery...) -> MethodStub {
            return Given(method: .m_weightQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func queryFor(_ sampleType: Parameter<Sample.Type>, willReturn: Query...) -> MethodStub {
            return Given(method: .m_queryFor__sampleType(`sampleType`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func activityQuery(willProduce: (Stubber<ActivityQuery>) -> Void) -> MethodStub {
            let willReturn: [ActivityQuery] = []
			let given: Given = { return Given(method: .m_activityQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (ActivityQuery).self)
			willProduce(stubber)
			return given
        }
        public static func bloodPressureQuery(willProduce: (Stubber<BloodPressureQuery>) -> Void) -> MethodStub {
            let willReturn: [BloodPressureQuery] = []
			let given: Given = { return Given(method: .m_bloodPressureQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (BloodPressureQuery).self)
			willProduce(stubber)
			return given
        }
        public static func bmiQuery(willProduce: (Stubber<BodyMassIndexQuery>) -> Void) -> MethodStub {
            let willReturn: [BodyMassIndexQuery] = []
			let given: Given = { return Given(method: .m_bmiQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (BodyMassIndexQuery).self)
			willProduce(stubber)
			return given
        }
        public static func fatigueQuery(willProduce: (Stubber<FatigueQuery>) -> Void) -> MethodStub {
            let willReturn: [FatigueQuery] = []
			let given: Given = { return Given(method: .m_fatigueQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (FatigueQuery).self)
			willProduce(stubber)
			return given
        }
        public static func heartRateQuery(willProduce: (Stubber<HeartRateQuery>) -> Void) -> MethodStub {
            let willReturn: [HeartRateQuery] = []
			let given: Given = { return Given(method: .m_heartRateQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (HeartRateQuery).self)
			willProduce(stubber)
			return given
        }
        public static func leanBodyMassQuery(willProduce: (Stubber<LeanBodyMassQuery>) -> Void) -> MethodStub {
            let willReturn: [LeanBodyMassQuery] = []
			let given: Given = { return Given(method: .m_leanBodyMassQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (LeanBodyMassQuery).self)
			willProduce(stubber)
			return given
        }
        public static func medicationDoseQuery(willProduce: (Stubber<MedicationDoseQuery>) -> Void) -> MethodStub {
            let willReturn: [MedicationDoseQuery] = []
			let given: Given = { return Given(method: .m_medicationDoseQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (MedicationDoseQuery).self)
			willProduce(stubber)
			return given
        }
        public static func moodQuery(willProduce: (Stubber<MoodQuery>) -> Void) -> MethodStub {
            let willReturn: [MoodQuery] = []
			let given: Given = { return Given(method: .m_moodQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (MoodQuery).self)
			willProduce(stubber)
			return given
        }
        public static func restingHeartRateQuery(willProduce: (Stubber<RestingHeartRateQuery>) -> Void) -> MethodStub {
            let willReturn: [RestingHeartRateQuery] = []
			let given: Given = { return Given(method: .m_restingHeartRateQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (RestingHeartRateQuery).self)
			willProduce(stubber)
			return given
        }
        public static func sexualActivityQuery(willProduce: (Stubber<SexualActivityQuery>) -> Void) -> MethodStub {
            let willReturn: [SexualActivityQuery] = []
			let given: Given = { return Given(method: .m_sexualActivityQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SexualActivityQuery).self)
			willProduce(stubber)
			return given
        }
        public static func sleepQuery(willProduce: (Stubber<SleepQuery>) -> Void) -> MethodStub {
            let willReturn: [SleepQuery] = []
			let given: Given = { return Given(method: .m_sleepQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SleepQuery).self)
			willProduce(stubber)
			return given
        }
        public static func weightQuery(willProduce: (Stubber<WeightQuery>) -> Void) -> MethodStub {
            let willReturn: [WeightQuery] = []
			let given: Given = { return Given(method: .m_weightQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (WeightQuery).self)
			willProduce(stubber)
			return given
        }
        public static func activityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_activityQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func activityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<ActivityQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_activityQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ActivityQuery).self)
			willProduce(stubber)
			return given
        }
        public static func bloodPressureQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_bloodPressureQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func bloodPressureQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<BloodPressureQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_bloodPressureQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (BloodPressureQuery).self)
			willProduce(stubber)
			return given
        }
        public static func bmiQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_bmiQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func bmiQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<BodyMassIndexQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_bmiQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (BodyMassIndexQuery).self)
			willProduce(stubber)
			return given
        }
        public static func fatigueQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_fatigueQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func fatigueQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<FatigueQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_fatigueQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (FatigueQuery).self)
			willProduce(stubber)
			return given
        }
        public static func heartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_heartRateQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func heartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<HeartRateQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_heartRateQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (HeartRateQuery).self)
			willProduce(stubber)
			return given
        }
        public static func leanBodyMassQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_leanBodyMassQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func leanBodyMassQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<LeanBodyMassQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_leanBodyMassQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (LeanBodyMassQuery).self)
			willProduce(stubber)
			return given
        }
        public static func medicationDoseQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_medicationDoseQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func medicationDoseQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<MedicationDoseQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_medicationDoseQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (MedicationDoseQuery).self)
			willProduce(stubber)
			return given
        }
        public static func moodQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_moodQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func moodQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<MoodQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_moodQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (MoodQuery).self)
			willProduce(stubber)
			return given
        }
        public static func restingHeartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_restingHeartRateQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func restingHeartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<RestingHeartRateQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_restingHeartRateQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (RestingHeartRateQuery).self)
			willProduce(stubber)
			return given
        }
        public static func sexualActivityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_sexualActivityQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func sexualActivityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<SexualActivityQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_sexualActivityQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (SexualActivityQuery).self)
			willProduce(stubber)
			return given
        }
        public static func sleepQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_sleepQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func sleepQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<SleepQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_sleepQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (SleepQuery).self)
			willProduce(stubber)
			return given
        }
        public static func weightQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_weightQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func weightQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<WeightQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_weightQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (WeightQuery).self)
			willProduce(stubber)
			return given
        }
        public static func queryFor(_ sampleType: Parameter<Sample.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_queryFor__sampleType(`sampleType`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func queryFor(_ sampleType: Parameter<Sample.Type>, willProduce: (StubberThrows<Query>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_queryFor__sampleType(`sampleType`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Query).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func activityQuery() -> Verify { return Verify(method: .m_activityQuery)}
        public static func activityQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_activityQuery__parts(`parts`))}
        public static func bloodPressureQuery() -> Verify { return Verify(method: .m_bloodPressureQuery)}
        public static func bloodPressureQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_bloodPressureQuery__parts(`parts`))}
        public static func bmiQuery() -> Verify { return Verify(method: .m_bmiQuery)}
        public static func bmiQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_bmiQuery__parts(`parts`))}
        public static func fatigueQuery() -> Verify { return Verify(method: .m_fatigueQuery)}
        public static func fatigueQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_fatigueQuery__parts(`parts`))}
        public static func heartRateQuery() -> Verify { return Verify(method: .m_heartRateQuery)}
        public static func heartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_heartRateQuery__parts(`parts`))}
        public static func leanBodyMassQuery() -> Verify { return Verify(method: .m_leanBodyMassQuery)}
        public static func leanBodyMassQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_leanBodyMassQuery__parts(`parts`))}
        public static func medicationDoseQuery() -> Verify { return Verify(method: .m_medicationDoseQuery)}
        public static func medicationDoseQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_medicationDoseQuery__parts(`parts`))}
        public static func moodQuery() -> Verify { return Verify(method: .m_moodQuery)}
        public static func moodQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_moodQuery__parts(`parts`))}
        public static func restingHeartRateQuery() -> Verify { return Verify(method: .m_restingHeartRateQuery)}
        public static func restingHeartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_restingHeartRateQuery__parts(`parts`))}
        public static func sexualActivityQuery() -> Verify { return Verify(method: .m_sexualActivityQuery)}
        public static func sexualActivityQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_sexualActivityQuery__parts(`parts`))}
        public static func sleepQuery() -> Verify { return Verify(method: .m_sleepQuery)}
        public static func sleepQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_sleepQuery__parts(`parts`))}
        public static func weightQuery() -> Verify { return Verify(method: .m_weightQuery)}
        public static func weightQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_weightQuery__parts(`parts`))}
        public static func queryFor(_ sampleType: Parameter<Sample.Type>) -> Verify { return Verify(method: .m_queryFor__sampleType(`sampleType`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func activityQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_activityQuery, performs: perform)
        }
        public static func activityQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_activityQuery__parts(`parts`), performs: perform)
        }
        public static func bloodPressureQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_bloodPressureQuery, performs: perform)
        }
        public static func bloodPressureQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_bloodPressureQuery__parts(`parts`), performs: perform)
        }
        public static func bmiQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_bmiQuery, performs: perform)
        }
        public static func bmiQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_bmiQuery__parts(`parts`), performs: perform)
        }
        public static func fatigueQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_fatigueQuery, performs: perform)
        }
        public static func fatigueQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_fatigueQuery__parts(`parts`), performs: perform)
        }
        public static func heartRateQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_heartRateQuery, performs: perform)
        }
        public static func heartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_heartRateQuery__parts(`parts`), performs: perform)
        }
        public static func leanBodyMassQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_leanBodyMassQuery, performs: perform)
        }
        public static func leanBodyMassQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_leanBodyMassQuery__parts(`parts`), performs: perform)
        }
        public static func medicationDoseQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_medicationDoseQuery, performs: perform)
        }
        public static func medicationDoseQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_medicationDoseQuery__parts(`parts`), performs: perform)
        }
        public static func moodQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_moodQuery, performs: perform)
        }
        public static func moodQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_moodQuery__parts(`parts`), performs: perform)
        }
        public static func restingHeartRateQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_restingHeartRateQuery, performs: perform)
        }
        public static func restingHeartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_restingHeartRateQuery__parts(`parts`), performs: perform)
        }
        public static func sexualActivityQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sexualActivityQuery, performs: perform)
        }
        public static func sexualActivityQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_sexualActivityQuery__parts(`parts`), performs: perform)
        }
        public static func sleepQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sleepQuery, performs: perform)
        }
        public static func sleepQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_sleepQuery__parts(`parts`), performs: perform)
        }
        public static func weightQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_weightQuery, performs: perform)
        }
        public static func weightQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_weightQuery__parts(`parts`), performs: perform)
        }
        public static func queryFor(_ sampleType: Parameter<Sample.Type>, perform: @escaping (Sample.Type) -> Void) -> Perform {
            return Perform(method: .m_queryFor__sampleType(`sampleType`), performs: perform)
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
}

// MARK: - RestingHeartRateQuery

open class RestingHeartRateQueryMock: RestingHeartRateQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "RestingHeartRateQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "RestingHeartRateQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "RestingHeartRateQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - SexualActivityQuery

open class SexualActivityQueryMock: SexualActivityQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "SexualActivityQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "SexualActivityQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "SexualActivityQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - SleepQuery

open class SleepQueryMock: SleepQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "SleepQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "SleepQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "SleepQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

// MARK: - SubQueryMatcherFactory

open class SubQueryMatcherFactoryMock: SubQueryMatcherFactory, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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






    open func withinXCalendarUnitsSubQueryMatcher() -> WithinXCalendarUnitsSubQueryMatcher {
        addInvocation(.m_withinXCalendarUnitsSubQueryMatcher)
		let perform = methodPerformValue(.m_withinXCalendarUnitsSubQueryMatcher) as? () -> Void
		perform?()
		var __value: WithinXCalendarUnitsSubQueryMatcher
		do {
		    __value = try methodReturnValue(.m_withinXCalendarUnitsSubQueryMatcher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for withinXCalendarUnitsSubQueryMatcher(). Use given")
			Failure("Stub return value not specified for withinXCalendarUnitsSubQueryMatcher(). Use given")
		}
		return __value
    }

    open func inSameCalendarUnitSubQueryMatcher() -> InSameCalendarUnitSubQueryMatcher {
        addInvocation(.m_inSameCalendarUnitSubQueryMatcher)
		let perform = methodPerformValue(.m_inSameCalendarUnitSubQueryMatcher) as? () -> Void
		perform?()
		var __value: InSameCalendarUnitSubQueryMatcher
		do {
		    __value = try methodReturnValue(.m_inSameCalendarUnitSubQueryMatcher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for inSameCalendarUnitSubQueryMatcher(). Use given")
			Failure("Stub return value not specified for inSameCalendarUnitSubQueryMatcher(). Use given")
		}
		return __value
    }

    open func sameDatesSubQueryMatcher() -> SameDatesSubQueryMatcher {
        addInvocation(.m_sameDatesSubQueryMatcher)
		let perform = methodPerformValue(.m_sameDatesSubQueryMatcher) as? () -> Void
		perform?()
		var __value: SameDatesSubQueryMatcher
		do {
		    __value = try methodReturnValue(.m_sameDatesSubQueryMatcher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sameDatesSubQueryMatcher(). Use given")
			Failure("Stub return value not specified for sameDatesSubQueryMatcher(). Use given")
		}
		return __value
    }

    open func sameStartDatesSubQueryMatcher() -> SameStartDatesSubQueryMatcher {
        addInvocation(.m_sameStartDatesSubQueryMatcher)
		let perform = methodPerformValue(.m_sameStartDatesSubQueryMatcher) as? () -> Void
		perform?()
		var __value: SameStartDatesSubQueryMatcher
		do {
		    __value = try methodReturnValue(.m_sameStartDatesSubQueryMatcher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sameStartDatesSubQueryMatcher(). Use given")
			Failure("Stub return value not specified for sameStartDatesSubQueryMatcher(). Use given")
		}
		return __value
    }

    open func sameEndDatesSubQueryMatcher() -> SameEndDatesSubQueryMatcher {
        addInvocation(.m_sameEndDatesSubQueryMatcher)
		let perform = methodPerformValue(.m_sameEndDatesSubQueryMatcher) as? () -> Void
		perform?()
		var __value: SameEndDatesSubQueryMatcher
		do {
		    __value = try methodReturnValue(.m_sameEndDatesSubQueryMatcher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sameEndDatesSubQueryMatcher(). Use given")
			Failure("Stub return value not specified for sameEndDatesSubQueryMatcher(). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_withinXCalendarUnitsSubQueryMatcher
        case m_inSameCalendarUnitSubQueryMatcher
        case m_sameDatesSubQueryMatcher
        case m_sameStartDatesSubQueryMatcher
        case m_sameEndDatesSubQueryMatcher

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_withinXCalendarUnitsSubQueryMatcher, .m_withinXCalendarUnitsSubQueryMatcher): return .match

            case (.m_inSameCalendarUnitSubQueryMatcher, .m_inSameCalendarUnitSubQueryMatcher): return .match

            case (.m_sameDatesSubQueryMatcher, .m_sameDatesSubQueryMatcher): return .match

            case (.m_sameStartDatesSubQueryMatcher, .m_sameStartDatesSubQueryMatcher): return .match

            case (.m_sameEndDatesSubQueryMatcher, .m_sameEndDatesSubQueryMatcher): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_withinXCalendarUnitsSubQueryMatcher: return 0
            case .m_inSameCalendarUnitSubQueryMatcher: return 0
            case .m_sameDatesSubQueryMatcher: return 0
            case .m_sameStartDatesSubQueryMatcher: return 0
            case .m_sameEndDatesSubQueryMatcher: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_withinXCalendarUnitsSubQueryMatcher: return ".withinXCalendarUnitsSubQueryMatcher()"
            case .m_inSameCalendarUnitSubQueryMatcher: return ".inSameCalendarUnitSubQueryMatcher()"
            case .m_sameDatesSubQueryMatcher: return ".sameDatesSubQueryMatcher()"
            case .m_sameStartDatesSubQueryMatcher: return ".sameStartDatesSubQueryMatcher()"
            case .m_sameEndDatesSubQueryMatcher: return ".sameEndDatesSubQueryMatcher()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func withinXCalendarUnitsSubQueryMatcher(willReturn: WithinXCalendarUnitsSubQueryMatcher...) -> MethodStub {
            return Given(method: .m_withinXCalendarUnitsSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func inSameCalendarUnitSubQueryMatcher(willReturn: InSameCalendarUnitSubQueryMatcher...) -> MethodStub {
            return Given(method: .m_inSameCalendarUnitSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sameDatesSubQueryMatcher(willReturn: SameDatesSubQueryMatcher...) -> MethodStub {
            return Given(method: .m_sameDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sameStartDatesSubQueryMatcher(willReturn: SameStartDatesSubQueryMatcher...) -> MethodStub {
            return Given(method: .m_sameStartDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sameEndDatesSubQueryMatcher(willReturn: SameEndDatesSubQueryMatcher...) -> MethodStub {
            return Given(method: .m_sameEndDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func withinXCalendarUnitsSubQueryMatcher(willProduce: (Stubber<WithinXCalendarUnitsSubQueryMatcher>) -> Void) -> MethodStub {
            let willReturn: [WithinXCalendarUnitsSubQueryMatcher] = []
			let given: Given = { return Given(method: .m_withinXCalendarUnitsSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (WithinXCalendarUnitsSubQueryMatcher).self)
			willProduce(stubber)
			return given
        }
        public static func inSameCalendarUnitSubQueryMatcher(willProduce: (Stubber<InSameCalendarUnitSubQueryMatcher>) -> Void) -> MethodStub {
            let willReturn: [InSameCalendarUnitSubQueryMatcher] = []
			let given: Given = { return Given(method: .m_inSameCalendarUnitSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (InSameCalendarUnitSubQueryMatcher).self)
			willProduce(stubber)
			return given
        }
        public static func sameDatesSubQueryMatcher(willProduce: (Stubber<SameDatesSubQueryMatcher>) -> Void) -> MethodStub {
            let willReturn: [SameDatesSubQueryMatcher] = []
			let given: Given = { return Given(method: .m_sameDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SameDatesSubQueryMatcher).self)
			willProduce(stubber)
			return given
        }
        public static func sameStartDatesSubQueryMatcher(willProduce: (Stubber<SameStartDatesSubQueryMatcher>) -> Void) -> MethodStub {
            let willReturn: [SameStartDatesSubQueryMatcher] = []
			let given: Given = { return Given(method: .m_sameStartDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SameStartDatesSubQueryMatcher).self)
			willProduce(stubber)
			return given
        }
        public static func sameEndDatesSubQueryMatcher(willProduce: (Stubber<SameEndDatesSubQueryMatcher>) -> Void) -> MethodStub {
            let willReturn: [SameEndDatesSubQueryMatcher] = []
			let given: Given = { return Given(method: .m_sameEndDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SameEndDatesSubQueryMatcher).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func withinXCalendarUnitsSubQueryMatcher() -> Verify { return Verify(method: .m_withinXCalendarUnitsSubQueryMatcher)}
        public static func inSameCalendarUnitSubQueryMatcher() -> Verify { return Verify(method: .m_inSameCalendarUnitSubQueryMatcher)}
        public static func sameDatesSubQueryMatcher() -> Verify { return Verify(method: .m_sameDatesSubQueryMatcher)}
        public static func sameStartDatesSubQueryMatcher() -> Verify { return Verify(method: .m_sameStartDatesSubQueryMatcher)}
        public static func sameEndDatesSubQueryMatcher() -> Verify { return Verify(method: .m_sameEndDatesSubQueryMatcher)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func withinXCalendarUnitsSubQueryMatcher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_withinXCalendarUnitsSubQueryMatcher, performs: perform)
        }
        public static func inSameCalendarUnitSubQueryMatcher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_inSameCalendarUnitSubQueryMatcher, performs: perform)
        }
        public static func sameDatesSubQueryMatcher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sameDatesSubQueryMatcher, performs: perform)
        }
        public static func sameStartDatesSubQueryMatcher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sameStartDatesSubQueryMatcher, performs: perform)
        }
        public static func sameEndDatesSubQueryMatcher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sameEndDatesSubQueryMatcher, performs: perform)
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
}

// MARK: - WeightQuery

open class WeightQueryMock: WeightQuery, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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


    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "WeightQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "WeightQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "WeightQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> Void) -> Void
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
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> Void>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
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
            case (.p_expression_get,.p_expression_get): return Matcher.ComparisonResult.match
			case (.p_expression_set(let left),.p_expression_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_subQuery_get,.p_subQuery_get): return Matcher.ComparisonResult.match
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_runQuery__callback_callback: return ".runQuery(callback:)"
            case .m_stop: return ".stop()"
            case .m_resetStoppedState: return ".resetStoppedState()"
            case .m_equalTo__otherQuery: return ".equalTo(_:)"
            case .p_expression_get: return "[get] .expression"
			case .p_expression_set: return "[set] .expression"
            case .p_mostRecentEntryOnly_get: return "[get] .mostRecentEntryOnly"
			case .p_mostRecentEntryOnly_set: return "[set] .mostRecentEntryOnly"
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

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> Void>, perform: @escaping (@escaping (QueryResult?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
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
}

