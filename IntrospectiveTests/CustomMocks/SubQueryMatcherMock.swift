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
@testable import Attributes
@testable import Queries
@testable import Samples

// sourcery: mock = "SubQueryMatcher"
class SubQueryMatcherMock: SubQueryMatcher, Mock {
	fileprivate var _description: String!

	var description: String {
		get { return _description }
		set { _description = newValue }
	}

// sourcery:inline:auto:SubQueryMatcherMock.autoMocked
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



    public var mostRecentOnly: Bool {
		get {	invocations.append(.p_mostRecentOnly_get); return __p_mostRecentOnly ?? givenGetterValue(.p_mostRecentOnly_get, "SubQueryMatcherMock - stub value for mostRecentOnly was not defined") }
		set {	invocations.append(.p_mostRecentOnly_set(.value(newValue))); __p_mostRecentOnly = newValue }
	}
	private var __p_mostRecentOnly: (Bool)?






    public required init() { }

    open func getSamples<QuerySampleType: Sample>(		from querySamples: [QuerySampleType],		matching subQuerySamples: [Sample]	) throws -> [QuerySampleType] {
        addInvocation(.m_getSamples__from_querySamplesmatching_subQuerySamples(Parameter<[QuerySampleType]>.value(`querySamples`).wrapAsGeneric(), Parameter<[Sample]>.value(`subQuerySamples`)))
		let perform = methodPerformValue(.m_getSamples__from_querySamplesmatching_subQuerySamples(Parameter<[QuerySampleType]>.value(`querySamples`).wrapAsGeneric(), Parameter<[Sample]>.value(`subQuerySamples`))) as? ([QuerySampleType], [Sample]) -> Void
		perform?(`querySamples`, `subQuerySamples`)
		var __value: [QuerySampleType]
		do {
		    __value = try methodReturnValue(.m_getSamples__from_querySamplesmatching_subQuerySamples(Parameter<[QuerySampleType]>.value(`querySamples`).wrapAsGeneric(), Parameter<[Sample]>.value(`subQuerySamples`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getSamples<QuerySampleType: Sample>(  from querySamples: [QuerySampleType],  matching subQuerySamples: [Sample] ). Use given")
			Failure("Stub return value not specified for getSamples<QuerySampleType: Sample>(  from querySamples: [QuerySampleType],  matching subQuerySamples: [Sample] ). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
        addInvocation(.m_equalTo__otherMatcher(Parameter<SubQueryMatcher>.value(`otherMatcher`)))
		let perform = methodPerformValue(.m_equalTo__otherMatcher(Parameter<SubQueryMatcher>.value(`otherMatcher`))) as? (SubQueryMatcher) -> Void
		perform?(`otherMatcher`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherMatcher(Parameter<SubQueryMatcher>.value(`otherMatcher`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherMatcher: SubQueryMatcher). Use given")
			Failure("Stub return value not specified for equalTo(_ otherMatcher: SubQueryMatcher). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getSamples__from_querySamplesmatching_subQuerySamples(Parameter<GenericAttribute>, Parameter<[Sample]>)
        case m_equalTo__otherMatcher(Parameter<SubQueryMatcher>)
        case p_mostRecentOnly_get
		case p_mostRecentOnly_set(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getSamples__from_querySamplesmatching_subQuerySamples(let lhsQuerysamples, let lhsSubquerysamples), .m_getSamples__from_querySamplesmatching_subQuerySamples(let rhsQuerysamples, let rhsSubquerysamples)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsQuerysamples) && !isCapturing(rhsQuerysamples) {
					comparison = Parameter.compare(lhs: lhsQuerysamples, rhs: rhsQuerysamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsQuerysamples, rhsQuerysamples, "from querySamples"))
				}


				if !isCapturing(lhsSubquerysamples) && !isCapturing(rhsSubquerysamples) {
					comparison = Parameter.compare(lhs: lhsSubquerysamples, rhs: rhsSubquerysamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSubquerysamples, rhsSubquerysamples, "matching subQuerySamples"))
				}

				if isCapturing(lhsQuerysamples) || isCapturing(rhsQuerysamples) {
					comparison = Parameter.compare(lhs: lhsQuerysamples, rhs: rhsQuerysamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsQuerysamples, rhsQuerysamples, "from querySamples"))
				}


				if isCapturing(lhsSubquerysamples) || isCapturing(rhsSubquerysamples) {
					comparison = Parameter.compare(lhs: lhsSubquerysamples, rhs: rhsSubquerysamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSubquerysamples, rhsSubquerysamples, "matching subQuerySamples"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_equalTo__otherMatcher(let lhsOthermatcher), .m_equalTo__otherMatcher(let rhsOthermatcher)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsOthermatcher) && !isCapturing(rhsOthermatcher) {
					comparison = Parameter.compare(lhs: lhsOthermatcher, rhs: rhsOthermatcher, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOthermatcher, rhsOthermatcher, "_ otherMatcher"))
				}

				if isCapturing(lhsOthermatcher) || isCapturing(rhsOthermatcher) {
					comparison = Parameter.compare(lhs: lhsOthermatcher, rhs: rhsOthermatcher, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOthermatcher, rhsOthermatcher, "_ otherMatcher"))
				}

				return Matcher.ComparisonResult(results)
            case (.p_mostRecentOnly_get,.p_mostRecentOnly_get): return Matcher.ComparisonResult.match
			case (.p_mostRecentOnly_set(let left),.p_mostRecentOnly_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getSamples__from_querySamplesmatching_subQuerySamples(p0, p1): return p0.intValue + p1.intValue
            case let .m_equalTo__otherMatcher(p0): return p0.intValue
            case .p_mostRecentOnly_get: return 0
			case .p_mostRecentOnly_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getSamples__from_querySamplesmatching_subQuerySamples: return ".getSamples(from:matching:)"
            case .m_equalTo__otherMatcher: return ".equalTo(_:)"
            case .p_mostRecentOnly_get: return "[get] .mostRecentOnly"
			case .p_mostRecentOnly_set: return "[set] .mostRecentOnly"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func mostRecentOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func getSamples<QuerySampleType: Sample>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>, willReturn: [QuerySampleType]...) -> MethodStub {
            return Given(method: .m_getSamples__from_querySamplesmatching_subQuerySamples(`querySamples`.wrapAsGeneric(), `subQuerySamples`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherMatcher: Parameter<SubQueryMatcher>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherMatcher(`otherMatcher`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherMatcher: Parameter<SubQueryMatcher>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherMatcher(`otherMatcher`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func getSamples<QuerySampleType:Sample>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getSamples__from_querySamplesmatching_subQuerySamples(`querySamples`.wrapAsGeneric(), `subQuerySamples`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getSamples<QuerySampleType: Sample>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>, willProduce: (StubberThrows<[QuerySampleType]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getSamples__from_querySamplesmatching_subQuerySamples(`querySamples`.wrapAsGeneric(), `subQuerySamples`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([QuerySampleType]).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getSamples<QuerySampleType>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>) -> Verify where QuerySampleType:Sample { return Verify(method: .m_getSamples__from_querySamplesmatching_subQuerySamples(`querySamples`.wrapAsGeneric(), `subQuerySamples`))}
        public static func equalTo(_ otherMatcher: Parameter<SubQueryMatcher>) -> Verify { return Verify(method: .m_equalTo__otherMatcher(`otherMatcher`))}
        public static var mostRecentOnly: Verify { return Verify(method: .p_mostRecentOnly_get) }
		public static func mostRecentOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentOnly_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getSamples<QuerySampleType>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>, perform: @escaping ([QuerySampleType], [Sample]) -> Void) -> Perform where QuerySampleType:Sample {
            return Perform(method: .m_getSamples__from_querySamplesmatching_subQuerySamples(`querySamples`.wrapAsGeneric(), `subQuerySamples`), performs: perform)
        }
        public static func equalTo(_ otherMatcher: Parameter<SubQueryMatcher>, perform: @escaping (SubQueryMatcher) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherMatcher(`otherMatcher`), performs: perform)
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
