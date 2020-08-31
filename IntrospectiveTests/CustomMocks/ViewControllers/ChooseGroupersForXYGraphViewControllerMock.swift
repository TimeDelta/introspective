//
//  ChooseGroupersForXYGraphViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/22/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective
@testable import Common
@testable import SampleGroupers
@testable import Samples

// sourcery: mock = "ChooseGroupersForXYGraphViewController"
class ChooseGroupersForXYGraphViewControllerMock: UIViewController, ChooseGroupersForXYGraphViewController, Mock {

// sourcery:inline:auto:ChooseGroupersForXYGraphViewControllerMock.autoMocked
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




    public var xSampleType: Sample.Type! {
		get {	invocations.append(.p_xSampleType_get); return __p_xSampleType ?? optionalGivenGetterValue(.p_xSampleType_get, "ChooseGroupersForXYGraphViewControllerMock - stub value for xSampleType was not defined") }
		set {	invocations.append(.p_xSampleType_set(.value(newValue))); __p_xSampleType = newValue }
	}
	private var __p_xSampleType: (Sample.Type)?


    public var ySampleType: Sample.Type! {
		get {	invocations.append(.p_ySampleType_get); return __p_ySampleType ?? optionalGivenGetterValue(.p_ySampleType_get, "ChooseGroupersForXYGraphViewControllerMock - stub value for ySampleType was not defined") }
		set {	invocations.append(.p_ySampleType_set(.value(newValue))); __p_ySampleType = newValue }
	}
	private var __p_ySampleType: (Sample.Type)?


    public var navBarTitle: String! {
		get {	invocations.append(.p_navBarTitle_get); return __p_navBarTitle ?? optionalGivenGetterValue(.p_navBarTitle_get, "ChooseGroupersForXYGraphViewControllerMock - stub value for navBarTitle was not defined") }
		set {	invocations.append(.p_navBarTitle_set(.value(newValue))); __p_navBarTitle = newValue }
	}
	private var __p_navBarTitle: (String)?


    public var xGrouper: SampleGrouper! {
		get {	invocations.append(.p_xGrouper_get); return __p_xGrouper ?? optionalGivenGetterValue(.p_xGrouper_get, "ChooseGroupersForXYGraphViewControllerMock - stub value for xGrouper was not defined") }
		set {	invocations.append(.p_xGrouper_set(.value(newValue))); __p_xGrouper = newValue }
	}
	private var __p_xGrouper: (SampleGrouper)?


    public var yGrouper: SampleGrouper! {
		get {	invocations.append(.p_yGrouper_get); return __p_yGrouper ?? optionalGivenGetterValue(.p_yGrouper_get, "ChooseGroupersForXYGraphViewControllerMock - stub value for yGrouper was not defined") }
		set {	invocations.append(.p_yGrouper_set(.value(newValue))); __p_yGrouper = newValue }
	}
	private var __p_yGrouper: (SampleGrouper)?


    public var currentAttributeType: String! {
		get {	invocations.append(.p_currentAttributeType_get); return __p_currentAttributeType ?? optionalGivenGetterValue(.p_currentAttributeType_get, "ChooseGroupersForXYGraphViewControllerMock - stub value for currentAttributeType was not defined") }
		set {	invocations.append(.p_currentAttributeType_set(.value(newValue))); __p_currentAttributeType = newValue }
	}
	private var __p_currentAttributeType: (String)?


    public var notificationToSendOnAccept: NotificationName! {
		get {	invocations.append(.p_notificationToSendOnAccept_get); return __p_notificationToSendOnAccept ?? optionalGivenGetterValue(.p_notificationToSendOnAccept_get, "ChooseGroupersForXYGraphViewControllerMock - stub value for notificationToSendOnAccept was not defined") }
		set {	invocations.append(.p_notificationToSendOnAccept_set(.value(newValue))); __p_notificationToSendOnAccept = newValue }
	}
	private var __p_notificationToSendOnAccept: (NotificationName)?







    fileprivate enum MethodType {
        case p_xSampleType_get
		case p_xSampleType_set(Parameter<Sample.Type?>)
        case p_ySampleType_get
		case p_ySampleType_set(Parameter<Sample.Type?>)
        case p_navBarTitle_get
		case p_navBarTitle_set(Parameter<String?>)
        case p_xGrouper_get
		case p_xGrouper_set(Parameter<SampleGrouper?>)
        case p_yGrouper_get
		case p_yGrouper_set(Parameter<SampleGrouper?>)
        case p_currentAttributeType_get
		case p_currentAttributeType_set(Parameter<String?>)
        case p_notificationToSendOnAccept_get
		case p_notificationToSendOnAccept_set(Parameter<NotificationName?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_xSampleType_get,.p_xSampleType_get): return Matcher.ComparisonResult.match
			case (.p_xSampleType_set(let left),.p_xSampleType_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Sample.Type?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_ySampleType_get,.p_ySampleType_get): return Matcher.ComparisonResult.match
			case (.p_ySampleType_set(let left),.p_ySampleType_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Sample.Type?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_navBarTitle_get,.p_navBarTitle_get): return Matcher.ComparisonResult.match
			case (.p_navBarTitle_set(let left),.p_navBarTitle_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<String?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_xGrouper_get,.p_xGrouper_get): return Matcher.ComparisonResult.match
			case (.p_xGrouper_set(let left),.p_xGrouper_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<SampleGrouper?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_yGrouper_get,.p_yGrouper_get): return Matcher.ComparisonResult.match
			case (.p_yGrouper_set(let left),.p_yGrouper_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<SampleGrouper?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_currentAttributeType_get,.p_currentAttributeType_get): return Matcher.ComparisonResult.match
			case (.p_currentAttributeType_set(let left),.p_currentAttributeType_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<String?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_notificationToSendOnAccept_get,.p_notificationToSendOnAccept_get): return Matcher.ComparisonResult.match
			case (.p_notificationToSendOnAccept_set(let left),.p_notificationToSendOnAccept_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<NotificationName?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_xSampleType_get: return 0
			case .p_xSampleType_set(let newValue): return newValue.intValue
            case .p_ySampleType_get: return 0
			case .p_ySampleType_set(let newValue): return newValue.intValue
            case .p_navBarTitle_get: return 0
			case .p_navBarTitle_set(let newValue): return newValue.intValue
            case .p_xGrouper_get: return 0
			case .p_xGrouper_set(let newValue): return newValue.intValue
            case .p_yGrouper_get: return 0
			case .p_yGrouper_set(let newValue): return newValue.intValue
            case .p_currentAttributeType_get: return 0
			case .p_currentAttributeType_set(let newValue): return newValue.intValue
            case .p_notificationToSendOnAccept_get: return 0
			case .p_notificationToSendOnAccept_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_xSampleType_get: return "[get] .xSampleType"
			case .p_xSampleType_set: return "[set] .xSampleType"
            case .p_ySampleType_get: return "[get] .ySampleType"
			case .p_ySampleType_set: return "[set] .ySampleType"
            case .p_navBarTitle_get: return "[get] .navBarTitle"
			case .p_navBarTitle_set: return "[set] .navBarTitle"
            case .p_xGrouper_get: return "[get] .xGrouper"
			case .p_xGrouper_set: return "[set] .xGrouper"
            case .p_yGrouper_get: return "[get] .yGrouper"
			case .p_yGrouper_set: return "[set] .yGrouper"
            case .p_currentAttributeType_get: return "[get] .currentAttributeType"
			case .p_currentAttributeType_set: return "[set] .currentAttributeType"
            case .p_notificationToSendOnAccept_get: return "[get] .notificationToSendOnAccept"
			case .p_notificationToSendOnAccept_set: return "[set] .notificationToSendOnAccept"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func xSampleType(getter defaultValue: Sample.Type?...) -> PropertyStub {
            return Given(method: .p_xSampleType_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func ySampleType(getter defaultValue: Sample.Type?...) -> PropertyStub {
            return Given(method: .p_ySampleType_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func navBarTitle(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_navBarTitle_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func xGrouper(getter defaultValue: SampleGrouper?...) -> PropertyStub {
            return Given(method: .p_xGrouper_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func yGrouper(getter defaultValue: SampleGrouper?...) -> PropertyStub {
            return Given(method: .p_yGrouper_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func currentAttributeType(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_currentAttributeType_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func notificationToSendOnAccept(getter defaultValue: NotificationName?...) -> PropertyStub {
            return Given(method: .p_notificationToSendOnAccept_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var xSampleType: Verify { return Verify(method: .p_xSampleType_get) }
		public static func xSampleType(set newValue: Parameter<Sample.Type?>) -> Verify { return Verify(method: .p_xSampleType_set(newValue)) }
        public static var ySampleType: Verify { return Verify(method: .p_ySampleType_get) }
		public static func ySampleType(set newValue: Parameter<Sample.Type?>) -> Verify { return Verify(method: .p_ySampleType_set(newValue)) }
        public static var navBarTitle: Verify { return Verify(method: .p_navBarTitle_get) }
		public static func navBarTitle(set newValue: Parameter<String?>) -> Verify { return Verify(method: .p_navBarTitle_set(newValue)) }
        public static var xGrouper: Verify { return Verify(method: .p_xGrouper_get) }
		public static func xGrouper(set newValue: Parameter<SampleGrouper?>) -> Verify { return Verify(method: .p_xGrouper_set(newValue)) }
        public static var yGrouper: Verify { return Verify(method: .p_yGrouper_get) }
		public static func yGrouper(set newValue: Parameter<SampleGrouper?>) -> Verify { return Verify(method: .p_yGrouper_set(newValue)) }
        public static var currentAttributeType: Verify { return Verify(method: .p_currentAttributeType_get) }
		public static func currentAttributeType(set newValue: Parameter<String?>) -> Verify { return Verify(method: .p_currentAttributeType_set(newValue)) }
        public static var notificationToSendOnAccept: Verify { return Verify(method: .p_notificationToSendOnAccept_get) }
		public static func notificationToSendOnAccept(set newValue: Parameter<NotificationName?>) -> Verify { return Verify(method: .p_notificationToSendOnAccept_set(newValue)) }
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
