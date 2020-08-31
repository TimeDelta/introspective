//
//  ChooseSampleGrouperTypeViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 5/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
import UIKit
@testable import Introspective
@testable import SampleGroupers

// sourcery: mock = "ChooseSampleGrouperTypeViewController"
class ChooseSampleGrouperTypeViewControllerMock: UIViewController, ChooseSampleGrouperTypeViewController, Mock {

// sourcery:inline:auto:ChooseSampleGrouperTypeViewControllerMock.autoMocked
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




    public var grouperTypes: [SampleGrouper.Type]! {
		get {	invocations.append(.p_grouperTypes_get); return __p_grouperTypes ?? optionalGivenGetterValue(.p_grouperTypes_get, "ChooseSampleGrouperTypeViewControllerMock - stub value for grouperTypes was not defined") }
		set {	invocations.append(.p_grouperTypes_set(.value(newValue))); __p_grouperTypes = newValue }
	}
	private var __p_grouperTypes: ([SampleGrouper.Type])?


    public var selectedGrouperType: SampleGrouper.Type? {
		get {	invocations.append(.p_selectedGrouperType_get); return __p_selectedGrouperType ?? optionalGivenGetterValue(.p_selectedGrouperType_get, "ChooseSampleGrouperTypeViewControllerMock - stub value for selectedGrouperType was not defined") }
		set {	invocations.append(.p_selectedGrouperType_set(.value(newValue))); __p_selectedGrouperType = newValue }
	}
	private var __p_selectedGrouperType: (SampleGrouper.Type)?







    fileprivate enum MethodType {
        case p_grouperTypes_get
		case p_grouperTypes_set(Parameter<[SampleGrouper.Type]?>)
        case p_selectedGrouperType_get
		case p_selectedGrouperType_set(Parameter<SampleGrouper.Type?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_grouperTypes_get,.p_grouperTypes_get): return Matcher.ComparisonResult.match
			case (.p_grouperTypes_set(let left),.p_grouperTypes_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<[SampleGrouper.Type]?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_selectedGrouperType_get,.p_selectedGrouperType_get): return Matcher.ComparisonResult.match
			case (.p_selectedGrouperType_set(let left),.p_selectedGrouperType_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<SampleGrouper.Type?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_grouperTypes_get: return 0
			case .p_grouperTypes_set(let newValue): return newValue.intValue
            case .p_selectedGrouperType_get: return 0
			case .p_selectedGrouperType_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_grouperTypes_get: return "[get] .grouperTypes"
			case .p_grouperTypes_set: return "[set] .grouperTypes"
            case .p_selectedGrouperType_get: return "[get] .selectedGrouperType"
			case .p_selectedGrouperType_set: return "[set] .selectedGrouperType"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func grouperTypes(getter defaultValue: [SampleGrouper.Type]?...) -> PropertyStub {
            return Given(method: .p_grouperTypes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func selectedGrouperType(getter defaultValue: SampleGrouper.Type?...) -> PropertyStub {
            return Given(method: .p_selectedGrouperType_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var grouperTypes: Verify { return Verify(method: .p_grouperTypes_get) }
		public static func grouperTypes(set newValue: Parameter<[SampleGrouper.Type]?>) -> Verify { return Verify(method: .p_grouperTypes_set(newValue)) }
        public static var selectedGrouperType: Verify { return Verify(method: .p_selectedGrouperType_get) }
		public static func selectedGrouperType(set newValue: Parameter<SampleGrouper.Type?>) -> Verify { return Verify(method: .p_selectedGrouperType_set(newValue)) }
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
