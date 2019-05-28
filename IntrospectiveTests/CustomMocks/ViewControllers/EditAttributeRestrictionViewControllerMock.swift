//
//  EditAttributeRestrictionViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective

// sourcery: mock = "EditAttributeRestrictionViewController"
class EditAttributeRestrictionViewControllerMock: UIViewController, EditAttributeRestrictionViewController, Mock {

// sourcery:inline:auto:EditAttributeRestrictionViewControllerMock.autoMocked
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


    public var sampleType: Sample.Type! {
		get {	invocations.append(.p_sampleType_get); return __p_sampleType ?? optionalGivenGetterValue(.p_sampleType_get, "EditAttributeRestrictionViewControllerMock - stub value for sampleType was not defined") }
		set {	invocations.append(.p_sampleType_set(.value(newValue))); __p_sampleType = newValue }
	}
	private var __p_sampleType: (Sample.Type)?


    public var attributeRestriction: AttributeRestriction? {
		get {	invocations.append(.p_attributeRestriction_get); return __p_attributeRestriction ?? optionalGivenGetterValue(.p_attributeRestriction_get, "EditAttributeRestrictionViewControllerMock - stub value for attributeRestriction was not defined") }
		set {	invocations.append(.p_attributeRestriction_set(.value(newValue))); __p_attributeRestriction = newValue }
	}
	private var __p_attributeRestriction: (AttributeRestriction)?







    fileprivate enum MethodType {
        case p_sampleType_get
		case p_sampleType_set(Parameter<Sample.Type?>)
        case p_attributeRestriction_get
		case p_attributeRestriction_set(Parameter<AttributeRestriction?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_sampleType_get,.p_sampleType_get): return true
			case (.p_sampleType_set(let left),.p_sampleType_set(let right)): return Parameter<Sample.Type?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_attributeRestriction_get,.p_attributeRestriction_get): return true
			case (.p_attributeRestriction_set(let left),.p_attributeRestriction_set(let right)): return Parameter<AttributeRestriction?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_sampleType_get: return 0
			case .p_sampleType_set(let newValue): return newValue.intValue
            case .p_attributeRestriction_get: return 0
			case .p_attributeRestriction_set(let newValue): return newValue.intValue
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
        public static func attributeRestriction(getter defaultValue: AttributeRestriction?...) -> PropertyStub {
            return Given(method: .p_attributeRestriction_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var sampleType: Verify { return Verify(method: .p_sampleType_get) }
		public static func sampleType(set newValue: Parameter<Sample.Type?>) -> Verify { return Verify(method: .p_sampleType_set(newValue)) }
        public static var attributeRestriction: Verify { return Verify(method: .p_attributeRestriction_get) }
		public static func attributeRestriction(set newValue: Parameter<AttributeRestriction?>) -> Verify { return Verify(method: .p_attributeRestriction_set(newValue)) }
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
