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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_initialDate_get,.p_initialDate_get): return true
			case (.p_initialDate_set(let left),.p_initialDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_earliestPossibleDate_get,.p_earliestPossibleDate_get): return true
			case (.p_earliestPossibleDate_set(let left),.p_earliestPossibleDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_latestPossibleDate_get,.p_latestPossibleDate_get): return true
			case (.p_latestPossibleDate_set(let left),.p_latestPossibleDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_datePickerMode_get,.p_datePickerMode_get): return true
			case (.p_datePickerMode_set(let left),.p_datePickerMode_set(let right)): return Parameter<UIDatePicker.Mode>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_lastDate_get,.p_lastDate_get): return true
			case (.p_lastDate_set(let left),.p_lastDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_notificationToSendOnAccept_get,.p_notificationToSendOnAccept_get): return true
			case (.p_notificationToSendOnAccept_set(let left),.p_notificationToSendOnAccept_set(let right)): return Parameter<Notification.Name?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
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
