//
//  QueryViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/22/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective
@testable import Common
@testable import Queries
@testable import Samples

// sourcery: mock = "QueryViewController"
class QueryViewControllerMock: UITableViewController, QueryViewController, Mock {

// sourcery:inline:auto:QueryViewControllerMock.autoMocked
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




    public var finishedButtonTitle: String {
		get {	invocations.append(.p_finishedButtonTitle_get); return __p_finishedButtonTitle ?? givenGetterValue(.p_finishedButtonTitle_get, "QueryViewControllerMock - stub value for finishedButtonTitle was not defined") }
		set {	invocations.append(.p_finishedButtonTitle_set(.value(newValue))); __p_finishedButtonTitle = newValue }
	}
	private var __p_finishedButtonTitle: (String)?


    public var finishedButtonNotification: NotificationName {
		get {	invocations.append(.p_finishedButtonNotification_get); return __p_finishedButtonNotification ?? givenGetterValue(.p_finishedButtonNotification_get, "QueryViewControllerMock - stub value for finishedButtonNotification was not defined") }
		set {	invocations.append(.p_finishedButtonNotification_set(.value(newValue))); __p_finishedButtonNotification = newValue }
	}
	private var __p_finishedButtonNotification: (NotificationName)?


    public var topmostSampleType: Sample.Type? {
		get {	invocations.append(.p_topmostSampleType_get); return __p_topmostSampleType ?? optionalGivenGetterValue(.p_topmostSampleType_get, "QueryViewControllerMock - stub value for topmostSampleType was not defined") }
		set {	invocations.append(.p_topmostSampleType_set(.value(newValue))); __p_topmostSampleType = newValue }
	}
	private var __p_topmostSampleType: (Sample.Type)?


    public var initialQuery: Query? {
		get {	invocations.append(.p_initialQuery_get); return __p_initialQuery ?? optionalGivenGetterValue(.p_initialQuery_get, "QueryViewControllerMock - stub value for initialQuery was not defined") }
		set {	invocations.append(.p_initialQuery_set(.value(newValue))); __p_initialQuery = newValue }
	}
	private var __p_initialQuery: (Query)?







    fileprivate enum MethodType {
        case p_finishedButtonTitle_get
		case p_finishedButtonTitle_set(Parameter<String>)
        case p_finishedButtonNotification_get
		case p_finishedButtonNotification_set(Parameter<NotificationName>)
        case p_topmostSampleType_get
		case p_topmostSampleType_set(Parameter<Sample.Type?>)
        case p_initialQuery_get
		case p_initialQuery_set(Parameter<Query?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_finishedButtonTitle_get,.p_finishedButtonTitle_get): return Matcher.ComparisonResult.match
			case (.p_finishedButtonTitle_set(let left),.p_finishedButtonTitle_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<String>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_finishedButtonNotification_get,.p_finishedButtonNotification_get): return Matcher.ComparisonResult.match
			case (.p_finishedButtonNotification_set(let left),.p_finishedButtonNotification_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<NotificationName>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_topmostSampleType_get,.p_topmostSampleType_get): return Matcher.ComparisonResult.match
			case (.p_topmostSampleType_set(let left),.p_topmostSampleType_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Sample.Type?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_initialQuery_get,.p_initialQuery_get): return Matcher.ComparisonResult.match
			case (.p_initialQuery_set(let left),.p_initialQuery_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Query?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_finishedButtonTitle_get: return 0
			case .p_finishedButtonTitle_set(let newValue): return newValue.intValue
            case .p_finishedButtonNotification_get: return 0
			case .p_finishedButtonNotification_set(let newValue): return newValue.intValue
            case .p_topmostSampleType_get: return 0
			case .p_topmostSampleType_set(let newValue): return newValue.intValue
            case .p_initialQuery_get: return 0
			case .p_initialQuery_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_finishedButtonTitle_get: return "[get] .finishedButtonTitle"
			case .p_finishedButtonTitle_set: return "[set] .finishedButtonTitle"
            case .p_finishedButtonNotification_get: return "[get] .finishedButtonNotification"
			case .p_finishedButtonNotification_set: return "[set] .finishedButtonNotification"
            case .p_topmostSampleType_get: return "[get] .topmostSampleType"
			case .p_topmostSampleType_set: return "[set] .topmostSampleType"
            case .p_initialQuery_get: return "[get] .initialQuery"
			case .p_initialQuery_set: return "[set] .initialQuery"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func finishedButtonTitle(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_finishedButtonTitle_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func finishedButtonNotification(getter defaultValue: NotificationName...) -> PropertyStub {
            return Given(method: .p_finishedButtonNotification_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func topmostSampleType(getter defaultValue: Sample.Type?...) -> PropertyStub {
            return Given(method: .p_topmostSampleType_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func initialQuery(getter defaultValue: Query?...) -> PropertyStub {
            return Given(method: .p_initialQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var finishedButtonTitle: Verify { return Verify(method: .p_finishedButtonTitle_get) }
		public static func finishedButtonTitle(set newValue: Parameter<String>) -> Verify { return Verify(method: .p_finishedButtonTitle_set(newValue)) }
        public static var finishedButtonNotification: Verify { return Verify(method: .p_finishedButtonNotification_get) }
		public static func finishedButtonNotification(set newValue: Parameter<NotificationName>) -> Verify { return Verify(method: .p_finishedButtonNotification_set(newValue)) }
        public static var topmostSampleType: Verify { return Verify(method: .p_topmostSampleType_get) }
		public static func topmostSampleType(set newValue: Parameter<Sample.Type?>) -> Verify { return Verify(method: .p_topmostSampleType_set(newValue)) }
        public static var initialQuery: Verify { return Verify(method: .p_initialQuery_get) }
		public static func initialQuery(set newValue: Parameter<Query?>) -> Verify { return Verify(method: .p_initialQuery_set(newValue)) }
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
