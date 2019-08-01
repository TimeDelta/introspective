//
//  ChooseAttributesToGraphTableViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/31/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective

// sourcery: mock = "ChooseAttributesToGraphTableViewController"
public class ChooseAttributesToGraphTableViewControllerMock: UITableViewController, ChooseAttributesToGraphTableViewController, Mock {

// sourcery:inline:auto:ChooseAttributesToGraphTableViewControllerMock.autoMocked
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


    public var notificationToSendWhenFinished: NotificationName! {
		get {	invocations.append(.p_notificationToSendWhenFinished_get); return __p_notificationToSendWhenFinished ?? optionalGivenGetterValue(.p_notificationToSendWhenFinished_get, "ChooseAttributesToGraphTableViewControllerMock - stub value for notificationToSendWhenFinished was not defined") }
		set {	invocations.append(.p_notificationToSendWhenFinished_set(.value(newValue))); __p_notificationToSendWhenFinished = newValue }
	}
	private var __p_notificationToSendWhenFinished: (NotificationName)?


    public var allowedAttributes: [Attribute]! {
		get {	invocations.append(.p_allowedAttributes_get); return __p_allowedAttributes ?? optionalGivenGetterValue(.p_allowedAttributes_get, "ChooseAttributesToGraphTableViewControllerMock - stub value for allowedAttributes was not defined") }
		set {	invocations.append(.p_allowedAttributes_set(.value(newValue))); __p_allowedAttributes = newValue }
	}
	private var __p_allowedAttributes: ([Attribute])?


    public var selectedAttributes: [Attribute]! {
		get {	invocations.append(.p_selectedAttributes_get); return __p_selectedAttributes ?? optionalGivenGetterValue(.p_selectedAttributes_get, "ChooseAttributesToGraphTableViewControllerMock - stub value for selectedAttributes was not defined") }
		set {	invocations.append(.p_selectedAttributes_set(.value(newValue))); __p_selectedAttributes = newValue }
	}
	private var __p_selectedAttributes: ([Attribute])?







    fileprivate enum MethodType {
        case p_notificationToSendWhenFinished_get
		case p_notificationToSendWhenFinished_set(Parameter<NotificationName?>)
        case p_allowedAttributes_get
		case p_allowedAttributes_set(Parameter<[Attribute]?>)
        case p_selectedAttributes_get
		case p_selectedAttributes_set(Parameter<[Attribute]?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_notificationToSendWhenFinished_get,.p_notificationToSendWhenFinished_get): return true
			case (.p_notificationToSendWhenFinished_set(let left),.p_notificationToSendWhenFinished_set(let right)): return Parameter<NotificationName?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_allowedAttributes_get,.p_allowedAttributes_get): return true
			case (.p_allowedAttributes_set(let left),.p_allowedAttributes_set(let right)): return Parameter<[Attribute]?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_selectedAttributes_get,.p_selectedAttributes_get): return true
			case (.p_selectedAttributes_set(let left),.p_selectedAttributes_set(let right)): return Parameter<[Attribute]?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_notificationToSendWhenFinished_get: return 0
			case .p_notificationToSendWhenFinished_set(let newValue): return newValue.intValue
            case .p_allowedAttributes_get: return 0
			case .p_allowedAttributes_set(let newValue): return newValue.intValue
            case .p_selectedAttributes_get: return 0
			case .p_selectedAttributes_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func notificationToSendWhenFinished(getter defaultValue: NotificationName?...) -> PropertyStub {
            return Given(method: .p_notificationToSendWhenFinished_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func allowedAttributes(getter defaultValue: [Attribute]?...) -> PropertyStub {
            return Given(method: .p_allowedAttributes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func selectedAttributes(getter defaultValue: [Attribute]?...) -> PropertyStub {
            return Given(method: .p_selectedAttributes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var notificationToSendWhenFinished: Verify { return Verify(method: .p_notificationToSendWhenFinished_get) }
		public static func notificationToSendWhenFinished(set newValue: Parameter<NotificationName?>) -> Verify { return Verify(method: .p_notificationToSendWhenFinished_set(newValue)) }
        public static var allowedAttributes: Verify { return Verify(method: .p_allowedAttributes_get) }
		public static func allowedAttributes(set newValue: Parameter<[Attribute]?>) -> Verify { return Verify(method: .p_allowedAttributes_set(newValue)) }
        public static var selectedAttributes: Verify { return Verify(method: .p_selectedAttributes_get) }
		public static func selectedAttributes(set newValue: Parameter<[Attribute]?>) -> Verify { return Verify(method: .p_selectedAttributes_set(newValue)) }
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
