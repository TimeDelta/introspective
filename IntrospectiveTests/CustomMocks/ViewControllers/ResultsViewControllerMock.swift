//
//  ResultsViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/9/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective
@testable import Queries
@testable import Samples

// sourcery: mock = "ResultsViewController"
public class ResultsViewControllerMock: UITableViewController, ResultsViewController, Mock {

// sourcery:inline:auto:ResultsViewControllerMock.autoMocked
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




    public var query: Query? {
		get {	invocations.append(.p_query_get); return __p_query ?? optionalGivenGetterValue(.p_query_get, "ResultsViewControllerMock - stub value for query was not defined") }
		set {	invocations.append(.p_query_set(.value(newValue))); __p_query = newValue }
	}
	private var __p_query: (Query)?


    public var samples: [Sample]! {
		get {	invocations.append(.p_samples_get); return __p_samples ?? optionalGivenGetterValue(.p_samples_get, "ResultsViewControllerMock - stub value for samples was not defined") }
		set {	invocations.append(.p_samples_set(.value(newValue))); __p_samples = newValue }
	}
	private var __p_samples: ([Sample])?


    public var backButtonTitle: String? {
		get {	invocations.append(.p_backButtonTitle_get); return __p_backButtonTitle ?? optionalGivenGetterValue(.p_backButtonTitle_get, "ResultsViewControllerMock - stub value for backButtonTitle was not defined") }
		set {	invocations.append(.p_backButtonTitle_set(.value(newValue))); __p_backButtonTitle = newValue }
	}
	private var __p_backButtonTitle: (String)?







    fileprivate enum MethodType {
        case p_query_get
		case p_query_set(Parameter<Query?>)
        case p_samples_get
		case p_samples_set(Parameter<[Sample]?>)
        case p_backButtonTitle_get
		case p_backButtonTitle_set(Parameter<String?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_query_get,.p_query_get): return Matcher.ComparisonResult.match
			case (.p_query_set(let left),.p_query_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Query?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_samples_get,.p_samples_get): return Matcher.ComparisonResult.match
			case (.p_samples_set(let left),.p_samples_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<[Sample]?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_backButtonTitle_get,.p_backButtonTitle_get): return Matcher.ComparisonResult.match
			case (.p_backButtonTitle_set(let left),.p_backButtonTitle_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<String?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_query_get: return 0
			case .p_query_set(let newValue): return newValue.intValue
            case .p_samples_get: return 0
			case .p_samples_set(let newValue): return newValue.intValue
            case .p_backButtonTitle_get: return 0
			case .p_backButtonTitle_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_query_get: return "[get] .query"
			case .p_query_set: return "[set] .query"
            case .p_samples_get: return "[get] .samples"
			case .p_samples_set: return "[set] .samples"
            case .p_backButtonTitle_get: return "[get] .backButtonTitle"
			case .p_backButtonTitle_set: return "[set] .backButtonTitle"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func query(getter defaultValue: Query?...) -> PropertyStub {
            return Given(method: .p_query_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func samples(getter defaultValue: [Sample]?...) -> PropertyStub {
            return Given(method: .p_samples_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func backButtonTitle(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_backButtonTitle_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var query: Verify { return Verify(method: .p_query_get) }
		public static func query(set newValue: Parameter<Query?>) -> Verify { return Verify(method: .p_query_set(newValue)) }
        public static var samples: Verify { return Verify(method: .p_samples_get) }
		public static func samples(set newValue: Parameter<[Sample]?>) -> Verify { return Verify(method: .p_samples_set(newValue)) }
        public static var backButtonTitle: Verify { return Verify(method: .p_backButtonTitle_get) }
		public static func backButtonTitle(set newValue: Parameter<String?>) -> Verify { return Verify(method: .p_backButtonTitle_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

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
