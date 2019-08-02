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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_xSampleType_get,.p_xSampleType_get): return true
			case (.p_xSampleType_set(let left),.p_xSampleType_set(let right)): return Parameter<Sample.Type?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_ySampleType_get,.p_ySampleType_get): return true
			case (.p_ySampleType_set(let left),.p_ySampleType_set(let right)): return Parameter<Sample.Type?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_navBarTitle_get,.p_navBarTitle_get): return true
			case (.p_navBarTitle_set(let left),.p_navBarTitle_set(let right)): return Parameter<String?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_xGrouper_get,.p_xGrouper_get): return true
			case (.p_xGrouper_set(let left),.p_xGrouper_set(let right)): return Parameter<SampleGrouper?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_yGrouper_get,.p_yGrouper_get): return true
			case (.p_yGrouper_set(let left),.p_yGrouper_set(let right)): return Parameter<SampleGrouper?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_currentAttributeType_get,.p_currentAttributeType_get): return true
			case (.p_currentAttributeType_set(let left),.p_currentAttributeType_set(let right)): return Parameter<String?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
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
