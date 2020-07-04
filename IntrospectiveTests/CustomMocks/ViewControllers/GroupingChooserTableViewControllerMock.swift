//
//  GroupingChooserTableViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/19/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
import UIKit
@testable import Introspective
@testable import Attributes
@testable import Common
@testable import SampleGroupers
@testable import Samples

// sourcery: mock = "GroupingChooserTableViewController"
class GroupingChooserTableViewControllerMock: UITableViewController, GroupingChooserTableViewController, Mock {

// sourcery:inline:auto:GroupingChooserTableViewControllerMock.autoMocked
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


    public var sampleType: Sample.Type! {
		get {	invocations.append(.p_sampleType_get); return __p_sampleType ?? optionalGivenGetterValue(.p_sampleType_get, "GroupingChooserTableViewControllerMock - stub value for sampleType was not defined") }
		set {	invocations.append(.p_sampleType_set(.value(newValue))); __p_sampleType = newValue }
	}
	private var __p_sampleType: (Sample.Type)?


    public var currentGrouper: SampleGrouper! {
		get {	invocations.append(.p_currentGrouper_get); return __p_currentGrouper ?? optionalGivenGetterValue(.p_currentGrouper_get, "GroupingChooserTableViewControllerMock - stub value for currentGrouper was not defined") }
		set {	invocations.append(.p_currentGrouper_set(.value(newValue))); __p_currentGrouper = newValue }
	}
	private var __p_currentGrouper: (SampleGrouper)?


    public var limitToAttributes: [Attribute]? {
		get {	invocations.append(.p_limitToAttributes_get); return __p_limitToAttributes ?? optionalGivenGetterValue(.p_limitToAttributes_get, "GroupingChooserTableViewControllerMock - stub value for limitToAttributes was not defined") }
		set {	invocations.append(.p_limitToAttributes_set(.value(newValue))); __p_limitToAttributes = newValue }
	}
	private var __p_limitToAttributes: ([Attribute])?


    public var allowUserToChangeGrouperType: Bool {
		get {	invocations.append(.p_allowUserToChangeGrouperType_get); return __p_allowUserToChangeGrouperType ?? givenGetterValue(.p_allowUserToChangeGrouperType_get, "GroupingChooserTableViewControllerMock - stub value for allowUserToChangeGrouperType was not defined") }
		set {	invocations.append(.p_allowUserToChangeGrouperType_set(.value(newValue))); __p_allowUserToChangeGrouperType = newValue }
	}
	private var __p_allowUserToChangeGrouperType: (Bool)?


    public var notificationToSendOnAccept: NotificationName {
		get {	invocations.append(.p_notificationToSendOnAccept_get); return __p_notificationToSendOnAccept ?? givenGetterValue(.p_notificationToSendOnAccept_get, "GroupingChooserTableViewControllerMock - stub value for notificationToSendOnAccept was not defined") }
		set {	invocations.append(.p_notificationToSendOnAccept_set(.value(newValue))); __p_notificationToSendOnAccept = newValue }
	}
	private var __p_notificationToSendOnAccept: (NotificationName)?







    fileprivate enum MethodType {
        case p_sampleType_get
		case p_sampleType_set(Parameter<Sample.Type?>)
        case p_currentGrouper_get
		case p_currentGrouper_set(Parameter<SampleGrouper?>)
        case p_limitToAttributes_get
		case p_limitToAttributes_set(Parameter<[Attribute]?>)
        case p_allowUserToChangeGrouperType_get
		case p_allowUserToChangeGrouperType_set(Parameter<Bool>)
        case p_notificationToSendOnAccept_get
		case p_notificationToSendOnAccept_set(Parameter<NotificationName>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_sampleType_get,.p_sampleType_get): return true
			case (.p_sampleType_set(let left),.p_sampleType_set(let right)): return Parameter<Sample.Type?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_currentGrouper_get,.p_currentGrouper_get): return true
			case (.p_currentGrouper_set(let left),.p_currentGrouper_set(let right)): return Parameter<SampleGrouper?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_limitToAttributes_get,.p_limitToAttributes_get): return true
			case (.p_limitToAttributes_set(let left),.p_limitToAttributes_set(let right)): return Parameter<[Attribute]?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_allowUserToChangeGrouperType_get,.p_allowUserToChangeGrouperType_get): return true
			case (.p_allowUserToChangeGrouperType_set(let left),.p_allowUserToChangeGrouperType_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_notificationToSendOnAccept_get,.p_notificationToSendOnAccept_get): return true
			case (.p_notificationToSendOnAccept_set(let left),.p_notificationToSendOnAccept_set(let right)): return Parameter<NotificationName>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_sampleType_get: return 0
			case .p_sampleType_set(let newValue): return newValue.intValue
            case .p_currentGrouper_get: return 0
			case .p_currentGrouper_set(let newValue): return newValue.intValue
            case .p_limitToAttributes_get: return 0
			case .p_limitToAttributes_set(let newValue): return newValue.intValue
            case .p_allowUserToChangeGrouperType_get: return 0
			case .p_allowUserToChangeGrouperType_set(let newValue): return newValue.intValue
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

        public static func sampleType(getter defaultValue: Sample.Type?...) -> PropertyStub {
            return Given(method: .p_sampleType_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func currentGrouper(getter defaultValue: SampleGrouper?...) -> PropertyStub {
            return Given(method: .p_currentGrouper_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func limitToAttributes(getter defaultValue: [Attribute]?...) -> PropertyStub {
            return Given(method: .p_limitToAttributes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func allowUserToChangeGrouperType(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_allowUserToChangeGrouperType_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func notificationToSendOnAccept(getter defaultValue: NotificationName...) -> PropertyStub {
            return Given(method: .p_notificationToSendOnAccept_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var sampleType: Verify { return Verify(method: .p_sampleType_get) }
		public static func sampleType(set newValue: Parameter<Sample.Type?>) -> Verify { return Verify(method: .p_sampleType_set(newValue)) }
        public static var currentGrouper: Verify { return Verify(method: .p_currentGrouper_get) }
		public static func currentGrouper(set newValue: Parameter<SampleGrouper?>) -> Verify { return Verify(method: .p_currentGrouper_set(newValue)) }
        public static var limitToAttributes: Verify { return Verify(method: .p_limitToAttributes_get) }
		public static func limitToAttributes(set newValue: Parameter<[Attribute]?>) -> Verify { return Verify(method: .p_limitToAttributes_set(newValue)) }
        public static var allowUserToChangeGrouperType: Verify { return Verify(method: .p_allowUserToChangeGrouperType_get) }
		public static func allowUserToChangeGrouperType(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_allowUserToChangeGrouperType_set(newValue)) }
        public static var notificationToSendOnAccept: Verify { return Verify(method: .p_notificationToSendOnAccept_get) }
		public static func notificationToSendOnAccept(set newValue: Parameter<NotificationName>) -> Verify { return Verify(method: .p_notificationToSendOnAccept_set(newValue)) }
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
