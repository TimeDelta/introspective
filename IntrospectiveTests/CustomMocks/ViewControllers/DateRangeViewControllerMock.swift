//
//  DateRangeViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/12/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective

// sourcery: mock = "DateRangeViewController"
public class DateRangeViewControllerMock: UIViewController, DateRangeViewController, Mock {

// sourcery:inline:auto:DateRangeViewControllerMock.autoMocked
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


    public var datePickerMode: UIDatePicker.Mode {
		get {	invocations.append(.p_datePickerMode_get); return __p_datePickerMode ?? givenGetterValue(.p_datePickerMode_get, "DateRangeViewControllerMock - stub value for datePickerMode was not defined") }
		set {	invocations.append(.p_datePickerMode_set(.value(newValue))); __p_datePickerMode = newValue }
	}
	private var __p_datePickerMode: (UIDatePicker.Mode)?


    public var initialFromDate: Date? {
		get {	invocations.append(.p_initialFromDate_get); return __p_initialFromDate ?? optionalGivenGetterValue(.p_initialFromDate_get, "DateRangeViewControllerMock - stub value for initialFromDate was not defined") }
		set {	invocations.append(.p_initialFromDate_set(.value(newValue))); __p_initialFromDate = newValue }
	}
	private var __p_initialFromDate: (Date)?


    public var minFromDate: Date? {
		get {	invocations.append(.p_minFromDate_get); return __p_minFromDate ?? optionalGivenGetterValue(.p_minFromDate_get, "DateRangeViewControllerMock - stub value for minFromDate was not defined") }
		set {	invocations.append(.p_minFromDate_set(.value(newValue))); __p_minFromDate = newValue }
	}
	private var __p_minFromDate: (Date)?


    public var maxFromDate: Date? {
		get {	invocations.append(.p_maxFromDate_get); return __p_maxFromDate ?? optionalGivenGetterValue(.p_maxFromDate_get, "DateRangeViewControllerMock - stub value for maxFromDate was not defined") }
		set {	invocations.append(.p_maxFromDate_set(.value(newValue))); __p_maxFromDate = newValue }
	}
	private var __p_maxFromDate: (Date)?


    public var initialToDate: Date? {
		get {	invocations.append(.p_initialToDate_get); return __p_initialToDate ?? optionalGivenGetterValue(.p_initialToDate_get, "DateRangeViewControllerMock - stub value for initialToDate was not defined") }
		set {	invocations.append(.p_initialToDate_set(.value(newValue))); __p_initialToDate = newValue }
	}
	private var __p_initialToDate: (Date)?


    public var minToDate: Date? {
		get {	invocations.append(.p_minToDate_get); return __p_minToDate ?? optionalGivenGetterValue(.p_minToDate_get, "DateRangeViewControllerMock - stub value for minToDate was not defined") }
		set {	invocations.append(.p_minToDate_set(.value(newValue))); __p_minToDate = newValue }
	}
	private var __p_minToDate: (Date)?


    public var maxToDate: Date? {
		get {	invocations.append(.p_maxToDate_get); return __p_maxToDate ?? optionalGivenGetterValue(.p_maxToDate_get, "DateRangeViewControllerMock - stub value for maxToDate was not defined") }
		set {	invocations.append(.p_maxToDate_set(.value(newValue))); __p_maxToDate = newValue }
	}
	private var __p_maxToDate: (Date)?


    public var notificationToSendOnAccept: Notification.Name! {
		get {	invocations.append(.p_notificationToSendOnAccept_get); return __p_notificationToSendOnAccept ?? optionalGivenGetterValue(.p_notificationToSendOnAccept_get, "DateRangeViewControllerMock - stub value for notificationToSendOnAccept was not defined") }
		set {	invocations.append(.p_notificationToSendOnAccept_set(.value(newValue))); __p_notificationToSendOnAccept = newValue }
	}
	private var __p_notificationToSendOnAccept: (Notification.Name)?







    fileprivate enum MethodType {
        case p_datePickerMode_get
		case p_datePickerMode_set(Parameter<UIDatePicker.Mode>)
        case p_initialFromDate_get
		case p_initialFromDate_set(Parameter<Date?>)
        case p_minFromDate_get
		case p_minFromDate_set(Parameter<Date?>)
        case p_maxFromDate_get
		case p_maxFromDate_set(Parameter<Date?>)
        case p_initialToDate_get
		case p_initialToDate_set(Parameter<Date?>)
        case p_minToDate_get
		case p_minToDate_set(Parameter<Date?>)
        case p_maxToDate_get
		case p_maxToDate_set(Parameter<Date?>)
        case p_notificationToSendOnAccept_get
		case p_notificationToSendOnAccept_set(Parameter<Notification.Name?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_datePickerMode_get,.p_datePickerMode_get): return true
			case (.p_datePickerMode_set(let left),.p_datePickerMode_set(let right)): return Parameter<UIDatePicker.Mode>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_initialFromDate_get,.p_initialFromDate_get): return true
			case (.p_initialFromDate_set(let left),.p_initialFromDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_minFromDate_get,.p_minFromDate_get): return true
			case (.p_minFromDate_set(let left),.p_minFromDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_maxFromDate_get,.p_maxFromDate_get): return true
			case (.p_maxFromDate_set(let left),.p_maxFromDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_initialToDate_get,.p_initialToDate_get): return true
			case (.p_initialToDate_set(let left),.p_initialToDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_minToDate_get,.p_minToDate_get): return true
			case (.p_minToDate_set(let left),.p_minToDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_maxToDate_get,.p_maxToDate_get): return true
			case (.p_maxToDate_set(let left),.p_maxToDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_notificationToSendOnAccept_get,.p_notificationToSendOnAccept_get): return true
			case (.p_notificationToSendOnAccept_set(let left),.p_notificationToSendOnAccept_set(let right)): return Parameter<Notification.Name?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_datePickerMode_get: return 0
			case .p_datePickerMode_set(let newValue): return newValue.intValue
            case .p_initialFromDate_get: return 0
			case .p_initialFromDate_set(let newValue): return newValue.intValue
            case .p_minFromDate_get: return 0
			case .p_minFromDate_set(let newValue): return newValue.intValue
            case .p_maxFromDate_get: return 0
			case .p_maxFromDate_set(let newValue): return newValue.intValue
            case .p_initialToDate_get: return 0
			case .p_initialToDate_set(let newValue): return newValue.intValue
            case .p_minToDate_get: return 0
			case .p_minToDate_set(let newValue): return newValue.intValue
            case .p_maxToDate_get: return 0
			case .p_maxToDate_set(let newValue): return newValue.intValue
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

        public static func datePickerMode(getter defaultValue: UIDatePicker.Mode...) -> PropertyStub {
            return Given(method: .p_datePickerMode_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func initialFromDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_initialFromDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func minFromDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_minFromDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func maxFromDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_maxFromDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func initialToDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_initialToDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func minToDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_minToDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func maxToDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_maxToDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func notificationToSendOnAccept(getter defaultValue: Notification.Name?...) -> PropertyStub {
            return Given(method: .p_notificationToSendOnAccept_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var datePickerMode: Verify { return Verify(method: .p_datePickerMode_get) }
		public static func datePickerMode(set newValue: Parameter<UIDatePicker.Mode>) -> Verify { return Verify(method: .p_datePickerMode_set(newValue)) }
        public static var initialFromDate: Verify { return Verify(method: .p_initialFromDate_get) }
		public static func initialFromDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_initialFromDate_set(newValue)) }
        public static var minFromDate: Verify { return Verify(method: .p_minFromDate_get) }
		public static func minFromDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_minFromDate_set(newValue)) }
        public static var maxFromDate: Verify { return Verify(method: .p_maxFromDate_get) }
		public static func maxFromDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_maxFromDate_set(newValue)) }
        public static var initialToDate: Verify { return Verify(method: .p_initialToDate_get) }
		public static func initialToDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_initialToDate_set(newValue)) }
        public static var minToDate: Verify { return Verify(method: .p_minToDate_get) }
		public static func minToDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_minToDate_set(newValue)) }
        public static var maxToDate: Verify { return Verify(method: .p_maxToDate_get) }
		public static func maxToDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_maxToDate_set(newValue)) }
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
