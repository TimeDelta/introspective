//
//  SelectSampleGroupInformationViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/23/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective
@testable import Attributes
@testable import Common
@testable import SampleGroupInformation

// sourcery: mock = "SelectSampleGroupInformationViewController"
class SelectSampleGroupInformationViewControllerMock: UIViewController, SelectSampleGroupInformationViewController, Mock {

// sourcery:inline:auto:SelectSampleGroupInformationViewControllerMock.autoMocked
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




    public var attributes: [Attribute]! {
		get {	invocations.append(.p_attributes_get); return __p_attributes ?? optionalGivenGetterValue(.p_attributes_get, "SelectSampleGroupInformationViewControllerMock - stub value for attributes was not defined") }
		set {	invocations.append(.p_attributes_set(.value(newValue))); __p_attributes = newValue }
	}
	private var __p_attributes: ([Attribute])?


    public var selectedAttribute: Attribute! {
		get {	invocations.append(.p_selectedAttribute_get); return __p_selectedAttribute ?? optionalGivenGetterValue(.p_selectedAttribute_get, "SelectSampleGroupInformationViewControllerMock - stub value for selectedAttribute was not defined") }
		set {	invocations.append(.p_selectedAttribute_set(.value(newValue))); __p_selectedAttribute = newValue }
	}
	private var __p_selectedAttribute: (Attribute)?


    public var selectedInformation: SampleGroupInformation! {
		get {	invocations.append(.p_selectedInformation_get); return __p_selectedInformation ?? optionalGivenGetterValue(.p_selectedInformation_get, "SelectSampleGroupInformationViewControllerMock - stub value for selectedInformation was not defined") }
		set {	invocations.append(.p_selectedInformation_set(.value(newValue))); __p_selectedInformation = newValue }
	}
	private var __p_selectedInformation: (SampleGroupInformation)?


    public var limitToNumericInformation: Bool {
		get {	invocations.append(.p_limitToNumericInformation_get); return __p_limitToNumericInformation ?? givenGetterValue(.p_limitToNumericInformation_get, "SelectSampleGroupInformationViewControllerMock - stub value for limitToNumericInformation was not defined") }
		set {	invocations.append(.p_limitToNumericInformation_set(.value(newValue))); __p_limitToNumericInformation = newValue }
	}
	private var __p_limitToNumericInformation: (Bool)?


    public var notificationToSendWhenFinished: NotificationName! {
		get {	invocations.append(.p_notificationToSendWhenFinished_get); return __p_notificationToSendWhenFinished ?? optionalGivenGetterValue(.p_notificationToSendWhenFinished_get, "SelectSampleGroupInformationViewControllerMock - stub value for notificationToSendWhenFinished was not defined") }
		set {	invocations.append(.p_notificationToSendWhenFinished_set(.value(newValue))); __p_notificationToSendWhenFinished = newValue }
	}
	private var __p_notificationToSendWhenFinished: (NotificationName)?


    public var notificationFilter: Any? {
		get {	invocations.append(.p_notificationFilter_get); return __p_notificationFilter ?? optionalGivenGetterValue(.p_notificationFilter_get, "SelectSampleGroupInformationViewControllerMock - stub value for notificationFilter was not defined") }
		set {	invocations.append(.p_notificationFilter_set(.value(newValue))); __p_notificationFilter = newValue }
	}
	private var __p_notificationFilter: (Any)?







    fileprivate enum MethodType {
        case p_attributes_get
		case p_attributes_set(Parameter<[Attribute]?>)
        case p_selectedAttribute_get
		case p_selectedAttribute_set(Parameter<Attribute?>)
        case p_selectedInformation_get
		case p_selectedInformation_set(Parameter<SampleGroupInformation?>)
        case p_limitToNumericInformation_get
		case p_limitToNumericInformation_set(Parameter<Bool>)
        case p_notificationToSendWhenFinished_get
		case p_notificationToSendWhenFinished_set(Parameter<NotificationName?>)
        case p_notificationFilter_get
		case p_notificationFilter_set(Parameter<Any?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_attributes_get,.p_attributes_get): return Matcher.ComparisonResult.match
			case (.p_attributes_set(let left),.p_attributes_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<[Attribute]?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_selectedAttribute_get,.p_selectedAttribute_get): return Matcher.ComparisonResult.match
			case (.p_selectedAttribute_set(let left),.p_selectedAttribute_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Attribute?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_selectedInformation_get,.p_selectedInformation_get): return Matcher.ComparisonResult.match
			case (.p_selectedInformation_set(let left),.p_selectedInformation_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<SampleGroupInformation?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_limitToNumericInformation_get,.p_limitToNumericInformation_get): return Matcher.ComparisonResult.match
			case (.p_limitToNumericInformation_set(let left),.p_limitToNumericInformation_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_notificationToSendWhenFinished_get,.p_notificationToSendWhenFinished_get): return Matcher.ComparisonResult.match
			case (.p_notificationToSendWhenFinished_set(let left),.p_notificationToSendWhenFinished_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<NotificationName?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_notificationFilter_get,.p_notificationFilter_get): return Matcher.ComparisonResult.match
			case (.p_notificationFilter_set(let left),.p_notificationFilter_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Any?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_attributes_get: return 0
			case .p_attributes_set(let newValue): return newValue.intValue
            case .p_selectedAttribute_get: return 0
			case .p_selectedAttribute_set(let newValue): return newValue.intValue
            case .p_selectedInformation_get: return 0
			case .p_selectedInformation_set(let newValue): return newValue.intValue
            case .p_limitToNumericInformation_get: return 0
			case .p_limitToNumericInformation_set(let newValue): return newValue.intValue
            case .p_notificationToSendWhenFinished_get: return 0
			case .p_notificationToSendWhenFinished_set(let newValue): return newValue.intValue
            case .p_notificationFilter_get: return 0
			case .p_notificationFilter_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_attributes_get: return "[get] .attributes"
			case .p_attributes_set: return "[set] .attributes"
            case .p_selectedAttribute_get: return "[get] .selectedAttribute"
			case .p_selectedAttribute_set: return "[set] .selectedAttribute"
            case .p_selectedInformation_get: return "[get] .selectedInformation"
			case .p_selectedInformation_set: return "[set] .selectedInformation"
            case .p_limitToNumericInformation_get: return "[get] .limitToNumericInformation"
			case .p_limitToNumericInformation_set: return "[set] .limitToNumericInformation"
            case .p_notificationToSendWhenFinished_get: return "[get] .notificationToSendWhenFinished"
			case .p_notificationToSendWhenFinished_set: return "[set] .notificationToSendWhenFinished"
            case .p_notificationFilter_get: return "[get] .notificationFilter"
			case .p_notificationFilter_set: return "[set] .notificationFilter"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func attributes(getter defaultValue: [Attribute]?...) -> PropertyStub {
            return Given(method: .p_attributes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func selectedAttribute(getter defaultValue: Attribute?...) -> PropertyStub {
            return Given(method: .p_selectedAttribute_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func selectedInformation(getter defaultValue: SampleGroupInformation?...) -> PropertyStub {
            return Given(method: .p_selectedInformation_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func limitToNumericInformation(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_limitToNumericInformation_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func notificationToSendWhenFinished(getter defaultValue: NotificationName?...) -> PropertyStub {
            return Given(method: .p_notificationToSendWhenFinished_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func notificationFilter(getter defaultValue: Any?...) -> PropertyStub {
            return Given(method: .p_notificationFilter_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var attributes: Verify { return Verify(method: .p_attributes_get) }
		public static func attributes(set newValue: Parameter<[Attribute]?>) -> Verify { return Verify(method: .p_attributes_set(newValue)) }
        public static var selectedAttribute: Verify { return Verify(method: .p_selectedAttribute_get) }
		public static func selectedAttribute(set newValue: Parameter<Attribute?>) -> Verify { return Verify(method: .p_selectedAttribute_set(newValue)) }
        public static var selectedInformation: Verify { return Verify(method: .p_selectedInformation_get) }
		public static func selectedInformation(set newValue: Parameter<SampleGroupInformation?>) -> Verify { return Verify(method: .p_selectedInformation_set(newValue)) }
        public static var limitToNumericInformation: Verify { return Verify(method: .p_limitToNumericInformation_get) }
		public static func limitToNumericInformation(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_limitToNumericInformation_set(newValue)) }
        public static var notificationToSendWhenFinished: Verify { return Verify(method: .p_notificationToSendWhenFinished_get) }
		public static func notificationToSendWhenFinished(set newValue: Parameter<NotificationName?>) -> Verify { return Verify(method: .p_notificationToSendWhenFinished_set(newValue)) }
        public static var notificationFilter: Verify { return Verify(method: .p_notificationFilter_get) }
		public static func notificationFilter(set newValue: Parameter<Any?>) -> Verify { return Verify(method: .p_notificationFilter_set(newValue)) }
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
