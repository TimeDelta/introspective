//
//  EditGrouperViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/19/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
import UIKit
@testable import Introspective
@testable import Common
@testable import SampleGroupers

// sourcery: mock = "EditGrouperViewController"
class EditGrouperViewControllerMock: UIViewController, EditGrouperViewController, Mock {

// sourcery:inline:auto:EditGrouperViewControllerMock.autoMocked
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


    public var currentGrouper: SampleGrouper! {
		get {	invocations.append(.p_currentGrouper_get); return __p_currentGrouper ?? optionalGivenGetterValue(.p_currentGrouper_get, "EditGrouperViewControllerMock - stub value for currentGrouper was not defined") }
		set {	invocations.append(.p_currentGrouper_set(.value(newValue))); __p_currentGrouper = newValue }
	}
	private var __p_currentGrouper: (SampleGrouper)?


    public var availableGroupers: [SampleGrouper]! {
		get {	invocations.append(.p_availableGroupers_get); return __p_availableGroupers ?? optionalGivenGetterValue(.p_availableGroupers_get, "EditGrouperViewControllerMock - stub value for availableGroupers was not defined") }
		set {	invocations.append(.p_availableGroupers_set(.value(newValue))); __p_availableGroupers = newValue }
	}
	private var __p_availableGroupers: ([SampleGrouper])?


    public var notificationToSendWhenAccepted: NotificationName! {
		get {	invocations.append(.p_notificationToSendWhenAccepted_get); return __p_notificationToSendWhenAccepted ?? optionalGivenGetterValue(.p_notificationToSendWhenAccepted_get, "EditGrouperViewControllerMock - stub value for notificationToSendWhenAccepted was not defined") }
		set {	invocations.append(.p_notificationToSendWhenAccepted_set(.value(newValue))); __p_notificationToSendWhenAccepted = newValue }
	}
	private var __p_notificationToSendWhenAccepted: (NotificationName)?







    fileprivate enum MethodType {
        case p_currentGrouper_get
		case p_currentGrouper_set(Parameter<SampleGrouper?>)
        case p_availableGroupers_get
		case p_availableGroupers_set(Parameter<[SampleGrouper]?>)
        case p_notificationToSendWhenAccepted_get
		case p_notificationToSendWhenAccepted_set(Parameter<NotificationName?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_currentGrouper_get,.p_currentGrouper_get): return true
			case (.p_currentGrouper_set(let left),.p_currentGrouper_set(let right)): return Parameter<SampleGrouper?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_availableGroupers_get,.p_availableGroupers_get): return true
			case (.p_availableGroupers_set(let left),.p_availableGroupers_set(let right)): return Parameter<[SampleGrouper]?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_notificationToSendWhenAccepted_get,.p_notificationToSendWhenAccepted_get): return true
			case (.p_notificationToSendWhenAccepted_set(let left),.p_notificationToSendWhenAccepted_set(let right)): return Parameter<NotificationName?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_currentGrouper_get: return 0
			case .p_currentGrouper_set(let newValue): return newValue.intValue
            case .p_availableGroupers_get: return 0
			case .p_availableGroupers_set(let newValue): return newValue.intValue
            case .p_notificationToSendWhenAccepted_get: return 0
			case .p_notificationToSendWhenAccepted_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func currentGrouper(getter defaultValue: SampleGrouper?...) -> PropertyStub {
            return Given(method: .p_currentGrouper_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func availableGroupers(getter defaultValue: [SampleGrouper]?...) -> PropertyStub {
            return Given(method: .p_availableGroupers_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func notificationToSendWhenAccepted(getter defaultValue: NotificationName?...) -> PropertyStub {
            return Given(method: .p_notificationToSendWhenAccepted_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var currentGrouper: Verify { return Verify(method: .p_currentGrouper_get) }
		public static func currentGrouper(set newValue: Parameter<SampleGrouper?>) -> Verify { return Verify(method: .p_currentGrouper_set(newValue)) }
        public static var availableGroupers: Verify { return Verify(method: .p_availableGroupers_get) }
		public static func availableGroupers(set newValue: Parameter<[SampleGrouper]?>) -> Verify { return Verify(method: .p_availableGroupers_set(newValue)) }
        public static var notificationToSendWhenAccepted: Verify { return Verify(method: .p_notificationToSendWhenAccepted_get) }
		public static func notificationToSendWhenAccepted(set newValue: Parameter<NotificationName?>) -> Verify { return Verify(method: .p_notificationToSendWhenAccepted_set(newValue)) }
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
