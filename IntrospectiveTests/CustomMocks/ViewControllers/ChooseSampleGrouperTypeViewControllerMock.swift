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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_grouperTypes_get,.p_grouperTypes_get): return true
			case (.p_grouperTypes_set(let left),.p_grouperTypes_set(let right)): return Parameter<[SampleGrouper.Type]?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_selectedGrouperType_get,.p_selectedGrouperType_get): return true
			case (.p_selectedGrouperType_set(let left),.p_selectedGrouperType_set(let right)): return Parameter<SampleGrouper.Type?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
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
