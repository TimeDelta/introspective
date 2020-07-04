//
//  ActivityTagsTableViewCellMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective

// sourcery: mock = "ActivityTagsTableViewCell"
class ActivityTagsTableViewCellMock: UITableViewCell, ActivityTagsTableViewCell, Mock {

// sourcery:inline:auto:ActivityTagsTableViewCellMock.autoMocked
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


    public var notificationToSendOnChange: Notification.Name! {
		get {	invocations.append(.p_notificationToSendOnChange_get); return __p_notificationToSendOnChange ?? optionalGivenGetterValue(.p_notificationToSendOnChange_get, "ActivityTagsTableViewCellMock - stub value for notificationToSendOnChange was not defined") }
		set {	invocations.append(.p_notificationToSendOnChange_set(.value(newValue))); __p_notificationToSendOnChange = newValue }
	}
	private var __p_notificationToSendOnChange: (Notification.Name)?


    public var tagNames: Set<String> {
		get {	invocations.append(.p_tagNames_get); return __p_tagNames ?? givenGetterValue(.p_tagNames_get, "ActivityTagsTableViewCellMock - stub value for tagNames was not defined") }
		set {	invocations.append(.p_tagNames_set(.value(newValue))); __p_tagNames = newValue }
	}
	private var __p_tagNames: (Set<String>)?







    fileprivate enum MethodType {
        case p_notificationToSendOnChange_get
		case p_notificationToSendOnChange_set(Parameter<Notification.Name?>)
        case p_tagNames_get
		case p_tagNames_set(Parameter<Set<String>>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_notificationToSendOnChange_get,.p_notificationToSendOnChange_get): return true
			case (.p_notificationToSendOnChange_set(let left),.p_notificationToSendOnChange_set(let right)): return Parameter<Notification.Name?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_tagNames_get,.p_tagNames_get): return true
			case (.p_tagNames_set(let left),.p_tagNames_set(let right)): return Parameter<Set<String>>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_notificationToSendOnChange_get: return 0
			case .p_notificationToSendOnChange_set(let newValue): return newValue.intValue
            case .p_tagNames_get: return 0
			case .p_tagNames_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func notificationToSendOnChange(getter defaultValue: Notification.Name?...) -> PropertyStub {
            return Given(method: .p_notificationToSendOnChange_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func tagNames(getter defaultValue: Set<String>...) -> PropertyStub {
            return Given(method: .p_tagNames_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var notificationToSendOnChange: Verify { return Verify(method: .p_notificationToSendOnChange_get) }
		public static func notificationToSendOnChange(set newValue: Parameter<Notification.Name?>) -> Verify { return Verify(method: .p_notificationToSendOnChange_set(newValue)) }
        public static var tagNames: Verify { return Verify(method: .p_tagNames_get) }
		public static func tagNames(set newValue: Parameter<Set<String>>) -> Verify { return Verify(method: .p_tagNames_set(newValue)) }
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
