//
//  ActivityEndDateTableViewCellMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective

// sourcery: mock = "ActivityEndDateTableViewCell"
class ActivityEndDateTableViewCellMock: UITableViewCell, ActivityEndDateTableViewCell, Mock {

// sourcery:inline:auto:ActivityEndDateTableViewCellMock.autoMocked
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




    public var notificationToSendOnDateChange: Notification.Name! {
		get {	invocations.append(.p_notificationToSendOnDateChange_get); return __p_notificationToSendOnDateChange ?? optionalGivenGetterValue(.p_notificationToSendOnDateChange_get, "ActivityEndDateTableViewCellMock - stub value for notificationToSendOnDateChange was not defined") }
		set {	invocations.append(.p_notificationToSendOnDateChange_set(.value(newValue))); __p_notificationToSendOnDateChange = newValue }
	}
	private var __p_notificationToSendOnDateChange: (Notification.Name)?


    public var endDate: Date? {
		get {	invocations.append(.p_endDate_get); return __p_endDate ?? optionalGivenGetterValue(.p_endDate_get, "ActivityEndDateTableViewCellMock - stub value for endDate was not defined") }
		set {	invocations.append(.p_endDate_set(.value(newValue))); __p_endDate = newValue }
	}
	private var __p_endDate: (Date)?







    fileprivate enum MethodType {
        case p_notificationToSendOnDateChange_get
		case p_notificationToSendOnDateChange_set(Parameter<Notification.Name?>)
        case p_endDate_get
		case p_endDate_set(Parameter<Date?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_notificationToSendOnDateChange_get,.p_notificationToSendOnDateChange_get): return Matcher.ComparisonResult.match
			case (.p_notificationToSendOnDateChange_set(let left),.p_notificationToSendOnDateChange_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Notification.Name?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_endDate_get,.p_endDate_get): return Matcher.ComparisonResult.match
			case (.p_endDate_set(let left),.p_endDate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_notificationToSendOnDateChange_get: return 0
			case .p_notificationToSendOnDateChange_set(let newValue): return newValue.intValue
            case .p_endDate_get: return 0
			case .p_endDate_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_notificationToSendOnDateChange_get: return "[get] .notificationToSendOnDateChange"
			case .p_notificationToSendOnDateChange_set: return "[set] .notificationToSendOnDateChange"
            case .p_endDate_get: return "[get] .endDate"
			case .p_endDate_set: return "[set] .endDate"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func notificationToSendOnDateChange(getter defaultValue: Notification.Name?...) -> PropertyStub {
            return Given(method: .p_notificationToSendOnDateChange_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func endDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_endDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var notificationToSendOnDateChange: Verify { return Verify(method: .p_notificationToSendOnDateChange_get) }
		public static func notificationToSendOnDateChange(set newValue: Parameter<Notification.Name?>) -> Verify { return Verify(method: .p_notificationToSendOnDateChange_set(newValue)) }
        public static var endDate: Verify { return Verify(method: .p_endDate_get) }
		public static func endDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_endDate_set(newValue)) }
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
