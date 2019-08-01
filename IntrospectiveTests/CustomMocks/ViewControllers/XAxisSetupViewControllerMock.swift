//
//  XAxisSetupViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/31/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective

// sourcery: mock = "XAxisSetupViewController"
public class XAxisSetupViewControllerMock: UIViewController, XAxisSetupViewController, Mock {

// sourcery:inline:auto:XAxisSetupViewControllerMock.autoMocked
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


    public var usePointGroupValue: Bool {
		get {	invocations.append(.p_usePointGroupValue_get); return __p_usePointGroupValue ?? givenGetterValue(.p_usePointGroupValue_get, "XAxisSetupViewControllerMock - stub value for usePointGroupValue was not defined") }
		set {	invocations.append(.p_usePointGroupValue_set(.value(newValue))); __p_usePointGroupValue = newValue }
	}
	private var __p_usePointGroupValue: (Bool)?


    public var grouped: Bool {
		get {	invocations.append(.p_grouped_get); return __p_grouped ?? givenGetterValue(.p_grouped_get, "XAxisSetupViewControllerMock - stub value for grouped was not defined") }
		set {	invocations.append(.p_grouped_set(.value(newValue))); __p_grouped = newValue }
	}
	private var __p_grouped: (Bool)?


    public var attributes: [Attribute]! {
		get {	invocations.append(.p_attributes_get); return __p_attributes ?? optionalGivenGetterValue(.p_attributes_get, "XAxisSetupViewControllerMock - stub value for attributes was not defined") }
		set {	invocations.append(.p_attributes_set(.value(newValue))); __p_attributes = newValue }
	}
	private var __p_attributes: ([Attribute])?


    public var selectedAttribute: Attribute! {
		get {	invocations.append(.p_selectedAttribute_get); return __p_selectedAttribute ?? optionalGivenGetterValue(.p_selectedAttribute_get, "XAxisSetupViewControllerMock - stub value for selectedAttribute was not defined") }
		set {	invocations.append(.p_selectedAttribute_set(.value(newValue))); __p_selectedAttribute = newValue }
	}
	private var __p_selectedAttribute: (Attribute)?


    public var selectedInformation: ExtraInformation! {
		get {	invocations.append(.p_selectedInformation_get); return __p_selectedInformation ?? optionalGivenGetterValue(.p_selectedInformation_get, "XAxisSetupViewControllerMock - stub value for selectedInformation was not defined") }
		set {	invocations.append(.p_selectedInformation_set(.value(newValue))); __p_selectedInformation = newValue }
	}
	private var __p_selectedInformation: (ExtraInformation)?


    public var notificationToSendWhenFinished: NotificationName! {
		get {	invocations.append(.p_notificationToSendWhenFinished_get); return __p_notificationToSendWhenFinished ?? optionalGivenGetterValue(.p_notificationToSendWhenFinished_get, "XAxisSetupViewControllerMock - stub value for notificationToSendWhenFinished was not defined") }
		set {	invocations.append(.p_notificationToSendWhenFinished_set(.value(newValue))); __p_notificationToSendWhenFinished = newValue }
	}
	private var __p_notificationToSendWhenFinished: (NotificationName)?







    fileprivate enum MethodType {
        case p_usePointGroupValue_get
		case p_usePointGroupValue_set(Parameter<Bool>)
        case p_grouped_get
		case p_grouped_set(Parameter<Bool>)
        case p_attributes_get
		case p_attributes_set(Parameter<[Attribute]?>)
        case p_selectedAttribute_get
		case p_selectedAttribute_set(Parameter<Attribute?>)
        case p_selectedInformation_get
		case p_selectedInformation_set(Parameter<ExtraInformation?>)
        case p_notificationToSendWhenFinished_get
		case p_notificationToSendWhenFinished_set(Parameter<NotificationName?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_usePointGroupValue_get,.p_usePointGroupValue_get): return true
			case (.p_usePointGroupValue_set(let left),.p_usePointGroupValue_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_grouped_get,.p_grouped_get): return true
			case (.p_grouped_set(let left),.p_grouped_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_attributes_get,.p_attributes_get): return true
			case (.p_attributes_set(let left),.p_attributes_set(let right)): return Parameter<[Attribute]?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_selectedAttribute_get,.p_selectedAttribute_get): return true
			case (.p_selectedAttribute_set(let left),.p_selectedAttribute_set(let right)): return Parameter<Attribute?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_selectedInformation_get,.p_selectedInformation_get): return true
			case (.p_selectedInformation_set(let left),.p_selectedInformation_set(let right)): return Parameter<ExtraInformation?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_notificationToSendWhenFinished_get,.p_notificationToSendWhenFinished_get): return true
			case (.p_notificationToSendWhenFinished_set(let left),.p_notificationToSendWhenFinished_set(let right)): return Parameter<NotificationName?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_usePointGroupValue_get: return 0
			case .p_usePointGroupValue_set(let newValue): return newValue.intValue
            case .p_grouped_get: return 0
			case .p_grouped_set(let newValue): return newValue.intValue
            case .p_attributes_get: return 0
			case .p_attributes_set(let newValue): return newValue.intValue
            case .p_selectedAttribute_get: return 0
			case .p_selectedAttribute_set(let newValue): return newValue.intValue
            case .p_selectedInformation_get: return 0
			case .p_selectedInformation_set(let newValue): return newValue.intValue
            case .p_notificationToSendWhenFinished_get: return 0
			case .p_notificationToSendWhenFinished_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func usePointGroupValue(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_usePointGroupValue_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func grouped(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_grouped_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func attributes(getter defaultValue: [Attribute]?...) -> PropertyStub {
            return Given(method: .p_attributes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func selectedAttribute(getter defaultValue: Attribute?...) -> PropertyStub {
            return Given(method: .p_selectedAttribute_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func selectedInformation(getter defaultValue: ExtraInformation?...) -> PropertyStub {
            return Given(method: .p_selectedInformation_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func notificationToSendWhenFinished(getter defaultValue: NotificationName?...) -> PropertyStub {
            return Given(method: .p_notificationToSendWhenFinished_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var usePointGroupValue: Verify { return Verify(method: .p_usePointGroupValue_get) }
		public static func usePointGroupValue(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_usePointGroupValue_set(newValue)) }
        public static var grouped: Verify { return Verify(method: .p_grouped_get) }
		public static func grouped(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_grouped_set(newValue)) }
        public static var attributes: Verify { return Verify(method: .p_attributes_get) }
		public static func attributes(set newValue: Parameter<[Attribute]?>) -> Verify { return Verify(method: .p_attributes_set(newValue)) }
        public static var selectedAttribute: Verify { return Verify(method: .p_selectedAttribute_get) }
		public static func selectedAttribute(set newValue: Parameter<Attribute?>) -> Verify { return Verify(method: .p_selectedAttribute_set(newValue)) }
        public static var selectedInformation: Verify { return Verify(method: .p_selectedInformation_get) }
		public static func selectedInformation(set newValue: Parameter<ExtraInformation?>) -> Verify { return Verify(method: .p_selectedInformation_set(newValue)) }
        public static var notificationToSendWhenFinished: Verify { return Verify(method: .p_notificationToSendWhenFinished_get) }
		public static func notificationToSendWhenFinished(set newValue: Parameter<NotificationName?>) -> Verify { return Verify(method: .p_notificationToSendWhenFinished_set(newValue)) }
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
