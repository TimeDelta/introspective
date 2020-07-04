//
//  MedicationDoseEditorViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/12/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective
@testable import Common
@testable import Samples

// sourcery: mock = "MedicationDoseEditorViewController"
public class MedicationDoseEditorViewControllerMock: UIViewController, MedicationDoseEditorViewController, Mock {

// sourcery:inline:auto:MedicationDoseEditorViewControllerMock.autoMocked
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


    public var medicationDose: MedicationDose? {
		get {	invocations.append(.p_medicationDose_get); return __p_medicationDose ?? optionalGivenGetterValue(.p_medicationDose_get, "MedicationDoseEditorViewControllerMock - stub value for medicationDose was not defined") }
		set {	invocations.append(.p_medicationDose_set(.value(newValue))); __p_medicationDose = newValue }
	}
	private var __p_medicationDose: (MedicationDose)?


    public var medication: Medication! {
		get {	invocations.append(.p_medication_get); return __p_medication ?? optionalGivenGetterValue(.p_medication_get, "MedicationDoseEditorViewControllerMock - stub value for medication was not defined") }
		set {	invocations.append(.p_medication_set(.value(newValue))); __p_medication = newValue }
	}
	private var __p_medication: (Medication)?


    public var notificationToSendOnAccept: Notification.Name! {
		get {	invocations.append(.p_notificationToSendOnAccept_get); return __p_notificationToSendOnAccept ?? optionalGivenGetterValue(.p_notificationToSendOnAccept_get, "MedicationDoseEditorViewControllerMock - stub value for notificationToSendOnAccept was not defined") }
		set {	invocations.append(.p_notificationToSendOnAccept_set(.value(newValue))); __p_notificationToSendOnAccept = newValue }
	}
	private var __p_notificationToSendOnAccept: (Notification.Name)?


    public var userInfoKey: UserInfoKey {
		get {	invocations.append(.p_userInfoKey_get); return __p_userInfoKey ?? givenGetterValue(.p_userInfoKey_get, "MedicationDoseEditorViewControllerMock - stub value for userInfoKey was not defined") }
		set {	invocations.append(.p_userInfoKey_set(.value(newValue))); __p_userInfoKey = newValue }
	}
	private var __p_userInfoKey: (UserInfoKey)?







    fileprivate enum MethodType {
        case p_medicationDose_get
		case p_medicationDose_set(Parameter<MedicationDose?>)
        case p_medication_get
		case p_medication_set(Parameter<Medication?>)
        case p_notificationToSendOnAccept_get
		case p_notificationToSendOnAccept_set(Parameter<Notification.Name?>)
        case p_userInfoKey_get
		case p_userInfoKey_set(Parameter<UserInfoKey>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_medicationDose_get,.p_medicationDose_get): return true
			case (.p_medicationDose_set(let left),.p_medicationDose_set(let right)): return Parameter<MedicationDose?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_medication_get,.p_medication_get): return true
			case (.p_medication_set(let left),.p_medication_set(let right)): return Parameter<Medication?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_notificationToSendOnAccept_get,.p_notificationToSendOnAccept_get): return true
			case (.p_notificationToSendOnAccept_set(let left),.p_notificationToSendOnAccept_set(let right)): return Parameter<Notification.Name?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_userInfoKey_get,.p_userInfoKey_get): return true
			case (.p_userInfoKey_set(let left),.p_userInfoKey_set(let right)): return Parameter<UserInfoKey>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_medicationDose_get: return 0
			case .p_medicationDose_set(let newValue): return newValue.intValue
            case .p_medication_get: return 0
			case .p_medication_set(let newValue): return newValue.intValue
            case .p_notificationToSendOnAccept_get: return 0
			case .p_notificationToSendOnAccept_set(let newValue): return newValue.intValue
            case .p_userInfoKey_get: return 0
			case .p_userInfoKey_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func medicationDose(getter defaultValue: MedicationDose?...) -> PropertyStub {
            return Given(method: .p_medicationDose_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func medication(getter defaultValue: Medication?...) -> PropertyStub {
            return Given(method: .p_medication_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func notificationToSendOnAccept(getter defaultValue: Notification.Name?...) -> PropertyStub {
            return Given(method: .p_notificationToSendOnAccept_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func userInfoKey(getter defaultValue: UserInfoKey...) -> PropertyStub {
            return Given(method: .p_userInfoKey_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var medicationDose: Verify { return Verify(method: .p_medicationDose_get) }
		public static func medicationDose(set newValue: Parameter<MedicationDose?>) -> Verify { return Verify(method: .p_medicationDose_set(newValue)) }
        public static var medication: Verify { return Verify(method: .p_medication_get) }
		public static func medication(set newValue: Parameter<Medication?>) -> Verify { return Verify(method: .p_medication_set(newValue)) }
        public static var notificationToSendOnAccept: Verify { return Verify(method: .p_notificationToSendOnAccept_get) }
		public static func notificationToSendOnAccept(set newValue: Parameter<Notification.Name?>) -> Verify { return Verify(method: .p_notificationToSendOnAccept_set(newValue)) }
        public static var userInfoKey: Verify { return Verify(method: .p_userInfoKey_get) }
		public static func userInfoKey(set newValue: Parameter<UserInfoKey>) -> Verify { return Verify(method: .p_userInfoKey_set(newValue)) }
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
