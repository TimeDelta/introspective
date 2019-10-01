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


    public var query: Query! {
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_query_get,.p_query_get): return true
			case (.p_query_set(let left),.p_query_set(let right)): return Parameter<Query?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_samples_get,.p_samples_get): return true
			case (.p_samples_set(let left),.p_samples_set(let right)): return Parameter<[Sample]?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_backButtonTitle_get,.p_backButtonTitle_get): return true
			case (.p_backButtonTitle_set(let left),.p_backButtonTitle_set(let right)): return Parameter<String?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
// sourcery:end
}
