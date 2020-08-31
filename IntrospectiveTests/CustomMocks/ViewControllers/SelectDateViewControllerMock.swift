//
//  SelectDateViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective

// sourcery: mock = "SelectDateViewController"
class SelectDateViewControllerMock: UIViewController, SelectDateViewController, Mock {

// sourcery:inline:auto:SelectDateViewControllerMock.autoMocked
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




    public var initialDate: Date? {
		get {	invocations.append(.p_initialDate_get); return __p_initialDate ?? optionalGivenGetterValue(.p_initialDate_get, "SelectDateViewControllerMock - stub value for initialDate was not defined") }
		set {	invocations.append(.p_initialDate_set(.value(newValue))); __p_initialDate = newValue }
	}
	private var __p_initialDate: (Date)?


    public var earliestPossibleDate: Date? {
		get {	invocations.append(.p_earliestPossibleDate_get); return __p_earliestPossibleDate ?? optionalGivenGetterValue(.p_earliestPossibleDate_get, "SelectDateViewControllerMock - stub value for earliestPossibleDate was not defined") }
		set {	invocations.append(.p_earliestPossibleDate_set(.value(newValue))); __p_earliestPossibleDate = newValue }
	}
	private var __p_earliestPossibleDate: (Date)?


    public var latestPossibleDate: Date? {
		get {	invocations.append(.p_latestPossibleDate_get); return __p_latestPossibleDate ?? optionalGivenGetterValue(.p_latestPossibleDate_get, "SelectDateViewControllerMock - stub value for latestPossibleDate was not defined") }
		set {	invocations.append(.p_latestPossibleDate_set(.value(newValue))); __p_latestPossibleDate = newValue }
	}
	private var __p_latestPossibleDate: (Date)?


    public var datePickerMode: UIDatePicker.Mode {
		get {	invocations.append(.p_datePickerMode_get); return __p_datePickerMode ?? givenGetterValue(.p_datePickerMode_get, "SelectDateViewControllerMock - stub value for datePickerMode was not defined") }
		set {	invocations.append(.p_datePickerMode_set(.value(newValue))); __p_datePickerMode = newValue }
	}
	private var __p_datePickerMode: (UIDatePicker.Mode)?


    public var lastDate: Date? {
		get {	invocations.append(.p_lastDate_get); return __p_lastDate ?? optionalGivenGetterValue(.p_lastDate_get, "SelectDateViewControllerMock - stub value for lastDate was not defined") }
		set {	invocations.append(.p_lastDate_set(.value(newValue))); __p_lastDate = newValue }
	}
	private var __p_lastDate: (Date)?


    public var notificationToSendOnAccept: Notification.Name! {
		get {	invocations.append(.p_notificationToSendOnAccept_get); return __p_notificationToSendOnAccept ?? optionalGivenGetterValue(.p_notificationToSendOnAccept_get, "SelectDateViewControllerMock - stub value for notificationToSendOnAccept was not defined") }
		set {	invocations.append(.p_notificationToSendOnAccept_set(.value(newValue))); __p_notificationToSendOnAccept = newValue }
	}
	private var __p_notificationToSendOnAccept: (Notification.Name)?







    fileprivate enum MethodType {
        case p_initialDate_get
		case p_initialDate_set(Parameter<Date?>)
        case p_earliestPossibleDate_get
		case p_earliestPossibleDate_set(Parameter<Date?>)
        case p_latestPossibleDate_get
		case p_latestPossibleDate_set(Parameter<Date?>)
        case p_datePickerMode_get
		case p_datePickerMode_set(Parameter<UIDatePicker.Mode>)
        case p_lastDate_get
		case p_lastDate_set(Parameter<Date?>)
        case p_notificationToSendOnAccept_get
		case p_notificationToSendOnAccept_set(Parameter<Notification.Name?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_initialDate_get,.p_initialDate_get): return Matcher.ComparisonResult.match
			case (.p_initialDate_set(let left),.p_initialDate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_earliestPossibleDate_get,.p_earliestPossibleDate_get): return Matcher.ComparisonResult.match
			case (.p_earliestPossibleDate_set(let left),.p_earliestPossibleDate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_latestPossibleDate_get,.p_latestPossibleDate_get): return Matcher.ComparisonResult.match
			case (.p_latestPossibleDate_set(let left),.p_latestPossibleDate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_datePickerMode_get,.p_datePickerMode_get): return Matcher.ComparisonResult.match
			case (.p_datePickerMode_set(let left),.p_datePickerMode_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<UIDatePicker.Mode>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_lastDate_get,.p_lastDate_get): return Matcher.ComparisonResult.match
			case (.p_lastDate_set(let left),.p_lastDate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_notificationToSendOnAccept_get,.p_notificationToSendOnAccept_get): return Matcher.ComparisonResult.match
			case (.p_notificationToSendOnAccept_set(let left),.p_notificationToSendOnAccept_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Notification.Name?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_initialDate_get: return 0
			case .p_initialDate_set(let newValue): return newValue.intValue
            case .p_earliestPossibleDate_get: return 0
			case .p_earliestPossibleDate_set(let newValue): return newValue.intValue
            case .p_latestPossibleDate_get: return 0
			case .p_latestPossibleDate_set(let newValue): return newValue.intValue
            case .p_datePickerMode_get: return 0
			case .p_datePickerMode_set(let newValue): return newValue.intValue
            case .p_lastDate_get: return 0
			case .p_lastDate_set(let newValue): return newValue.intValue
            case .p_notificationToSendOnAccept_get: return 0
			case .p_notificationToSendOnAccept_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_initialDate_get: return "[get] .initialDate"
			case .p_initialDate_set: return "[set] .initialDate"
            case .p_earliestPossibleDate_get: return "[get] .earliestPossibleDate"
			case .p_earliestPossibleDate_set: return "[set] .earliestPossibleDate"
            case .p_latestPossibleDate_get: return "[get] .latestPossibleDate"
			case .p_latestPossibleDate_set: return "[set] .latestPossibleDate"
            case .p_datePickerMode_get: return "[get] .datePickerMode"
			case .p_datePickerMode_set: return "[set] .datePickerMode"
            case .p_lastDate_get: return "[get] .lastDate"
			case .p_lastDate_set: return "[set] .lastDate"
            case .p_notificationToSendOnAccept_get: return "[get] .notificationToSendOnAccept"
			case .p_notificationToSendOnAccept_set: return "[set] .notificationToSendOnAccept"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func initialDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_initialDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func earliestPossibleDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_earliestPossibleDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func latestPossibleDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_latestPossibleDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func datePickerMode(getter defaultValue: UIDatePicker.Mode...) -> PropertyStub {
            return Given(method: .p_datePickerMode_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_lastDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func notificationToSendOnAccept(getter defaultValue: Notification.Name?...) -> PropertyStub {
            return Given(method: .p_notificationToSendOnAccept_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var initialDate: Verify { return Verify(method: .p_initialDate_get) }
		public static func initialDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_initialDate_set(newValue)) }
        public static var earliestPossibleDate: Verify { return Verify(method: .p_earliestPossibleDate_get) }
		public static func earliestPossibleDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_earliestPossibleDate_set(newValue)) }
        public static var latestPossibleDate: Verify { return Verify(method: .p_latestPossibleDate_get) }
		public static func latestPossibleDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_latestPossibleDate_set(newValue)) }
        public static var datePickerMode: Verify { return Verify(method: .p_datePickerMode_get) }
		public static func datePickerMode(set newValue: Parameter<UIDatePicker.Mode>) -> Verify { return Verify(method: .p_datePickerMode_set(newValue)) }
        public static var lastDate: Verify { return Verify(method: .p_lastDate_get) }
		public static func lastDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_lastDate_set(newValue)) }
        public static var notificationToSendOnAccept: Verify { return Verify(method: .p_notificationToSendOnAccept_get) }
		public static func notificationToSendOnAccept(set newValue: Parameter<Notification.Name?>) -> Verify { return Verify(method: .p_notificationToSendOnAccept_set(newValue)) }
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
