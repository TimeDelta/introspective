//
//  ChooseActivityDefinitionViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective
@testable import Samples

// sourcery: mock = "ChooseActivityDefinitionViewController"
class ChooseActivityDefinitionViewControllerMock: UIViewController, ChooseActivityDefinitionViewController, Mock {

// sourcery:inline:auto:ChooseActivityDefinitionViewControllerMock.autoMocked
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




    public var notificationToSendOnAccept: Notification.Name! {
		get {	invocations.append(.p_notificationToSendOnAccept_get); return __p_notificationToSendOnAccept ?? optionalGivenGetterValue(.p_notificationToSendOnAccept_get, "ChooseActivityDefinitionViewControllerMock - stub value for notificationToSendOnAccept was not defined") }
		set {	invocations.append(.p_notificationToSendOnAccept_set(.value(newValue))); __p_notificationToSendOnAccept = newValue }
	}
	private var __p_notificationToSendOnAccept: (Notification.Name)?


    public var availableDefinitions: [ActivityDefinition]! {
		get {	invocations.append(.p_availableDefinitions_get); return __p_availableDefinitions ?? optionalGivenGetterValue(.p_availableDefinitions_get, "ChooseActivityDefinitionViewControllerMock - stub value for availableDefinitions was not defined") }
		set {	invocations.append(.p_availableDefinitions_set(.value(newValue))); __p_availableDefinitions = newValue }
	}
	private var __p_availableDefinitions: ([ActivityDefinition])?


    public var selectedDefinition: ActivityDefinition? {
		get {	invocations.append(.p_selectedDefinition_get); return __p_selectedDefinition ?? optionalGivenGetterValue(.p_selectedDefinition_get, "ChooseActivityDefinitionViewControllerMock - stub value for selectedDefinition was not defined") }
		set {	invocations.append(.p_selectedDefinition_set(.value(newValue))); __p_selectedDefinition = newValue }
	}
	private var __p_selectedDefinition: (ActivityDefinition)?







    fileprivate enum MethodType {
        case p_notificationToSendOnAccept_get
		case p_notificationToSendOnAccept_set(Parameter<Notification.Name?>)
        case p_availableDefinitions_get
		case p_availableDefinitions_set(Parameter<[ActivityDefinition]?>)
        case p_selectedDefinition_get
		case p_selectedDefinition_set(Parameter<ActivityDefinition?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_notificationToSendOnAccept_get,.p_notificationToSendOnAccept_get): return Matcher.ComparisonResult.match
			case (.p_notificationToSendOnAccept_set(let left),.p_notificationToSendOnAccept_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Notification.Name?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_availableDefinitions_get,.p_availableDefinitions_get): return Matcher.ComparisonResult.match
			case (.p_availableDefinitions_set(let left),.p_availableDefinitions_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<[ActivityDefinition]?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_selectedDefinition_get,.p_selectedDefinition_get): return Matcher.ComparisonResult.match
			case (.p_selectedDefinition_set(let left),.p_selectedDefinition_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<ActivityDefinition?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_notificationToSendOnAccept_get: return 0
			case .p_notificationToSendOnAccept_set(let newValue): return newValue.intValue
            case .p_availableDefinitions_get: return 0
			case .p_availableDefinitions_set(let newValue): return newValue.intValue
            case .p_selectedDefinition_get: return 0
			case .p_selectedDefinition_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_notificationToSendOnAccept_get: return "[get] .notificationToSendOnAccept"
			case .p_notificationToSendOnAccept_set: return "[set] .notificationToSendOnAccept"
            case .p_availableDefinitions_get: return "[get] .availableDefinitions"
			case .p_availableDefinitions_set: return "[set] .availableDefinitions"
            case .p_selectedDefinition_get: return "[get] .selectedDefinition"
			case .p_selectedDefinition_set: return "[set] .selectedDefinition"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func notificationToSendOnAccept(getter defaultValue: Notification.Name?...) -> PropertyStub {
            return Given(method: .p_notificationToSendOnAccept_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func availableDefinitions(getter defaultValue: [ActivityDefinition]?...) -> PropertyStub {
            return Given(method: .p_availableDefinitions_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func selectedDefinition(getter defaultValue: ActivityDefinition?...) -> PropertyStub {
            return Given(method: .p_selectedDefinition_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var notificationToSendOnAccept: Verify { return Verify(method: .p_notificationToSendOnAccept_get) }
		public static func notificationToSendOnAccept(set newValue: Parameter<Notification.Name?>) -> Verify { return Verify(method: .p_notificationToSendOnAccept_set(newValue)) }
        public static var availableDefinitions: Verify { return Verify(method: .p_availableDefinitions_get) }
		public static func availableDefinitions(set newValue: Parameter<[ActivityDefinition]?>) -> Verify { return Verify(method: .p_availableDefinitions_set(newValue)) }
        public static var selectedDefinition: Verify { return Verify(method: .p_selectedDefinition_get) }
		public static func selectedDefinition(set newValue: Parameter<ActivityDefinition?>) -> Verify { return Verify(method: .p_selectedDefinition_set(newValue)) }
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
