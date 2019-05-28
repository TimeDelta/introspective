//
//  BasicXYChartViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/23/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
import AAInfographics
@testable import Introspective

// sourcery: mock = "BasicXYChartViewController"
class BasicXYChartViewControllerMock: UIViewController, BasicXYChartViewController, Mock {

// sourcery:inline:auto:BasicXYChartViewControllerMock.autoMocked
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


    public var queries: [Query]? {
		get {	invocations.append(.p_queries_get); return __p_queries ?? optionalGivenGetterValue(.p_queries_get, "BasicXYChartViewControllerMock - stub value for queries was not defined") }
		set {	invocations.append(.p_queries_set(.value(newValue))); __p_queries = newValue }
	}
	private var __p_queries: ([Query])?


    public var dataSeries: [Dictionary<String, Any>]! {
		get {	invocations.append(.p_dataSeries_get); return __p_dataSeries ?? optionalGivenGetterValue(.p_dataSeries_get, "BasicXYChartViewControllerMock - stub value for dataSeries was not defined") }
		set {	invocations.append(.p_dataSeries_set(.value(newValue))); __p_dataSeries = newValue }
	}
	private var __p_dataSeries: ([Dictionary<String, Any>])?


    public var displayXAxisValueLabels: Bool {
		get {	invocations.append(.p_displayXAxisValueLabels_get); return __p_displayXAxisValueLabels ?? givenGetterValue(.p_displayXAxisValueLabels_get, "BasicXYChartViewControllerMock - stub value for displayXAxisValueLabels was not defined") }
		set {	invocations.append(.p_displayXAxisValueLabels_set(.value(newValue))); __p_displayXAxisValueLabels = newValue }
	}
	private var __p_displayXAxisValueLabels: (Bool)?


    public var chartType: AAChartType! {
		get {	invocations.append(.p_chartType_get); return __p_chartType ?? optionalGivenGetterValue(.p_chartType_get, "BasicXYChartViewControllerMock - stub value for chartType was not defined") }
		set {	invocations.append(.p_chartType_set(.value(newValue))); __p_chartType = newValue }
	}
	private var __p_chartType: (AAChartType)?


    public var categories: [String]? {
		get {	invocations.append(.p_categories_get); return __p_categories ?? optionalGivenGetterValue(.p_categories_get, "BasicXYChartViewControllerMock - stub value for categories was not defined") }
		set {	invocations.append(.p_categories_set(.value(newValue))); __p_categories = newValue }
	}
	private var __p_categories: ([String])?







    fileprivate enum MethodType {
        case p_queries_get
		case p_queries_set(Parameter<[Query]?>)
        case p_dataSeries_get
		case p_dataSeries_set(Parameter<[Dictionary<String, Any>]?>)
        case p_displayXAxisValueLabels_get
		case p_displayXAxisValueLabels_set(Parameter<Bool>)
        case p_chartType_get
		case p_chartType_set(Parameter<AAChartType?>)
        case p_categories_get
		case p_categories_set(Parameter<[String]?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_queries_get,.p_queries_get): return true
			case (.p_queries_set(let left),.p_queries_set(let right)): return Parameter<[Query]?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_dataSeries_get,.p_dataSeries_get): return true
			case (.p_dataSeries_set(let left),.p_dataSeries_set(let right)): return Parameter<[Dictionary<String, Any>]?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_displayXAxisValueLabels_get,.p_displayXAxisValueLabels_get): return true
			case (.p_displayXAxisValueLabels_set(let left),.p_displayXAxisValueLabels_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_chartType_get,.p_chartType_get): return true
			case (.p_chartType_set(let left),.p_chartType_set(let right)): return Parameter<AAChartType?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_categories_get,.p_categories_get): return true
			case (.p_categories_set(let left),.p_categories_set(let right)): return Parameter<[String]?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_queries_get: return 0
			case .p_queries_set(let newValue): return newValue.intValue
            case .p_dataSeries_get: return 0
			case .p_dataSeries_set(let newValue): return newValue.intValue
            case .p_displayXAxisValueLabels_get: return 0
			case .p_displayXAxisValueLabels_set(let newValue): return newValue.intValue
            case .p_chartType_get: return 0
			case .p_chartType_set(let newValue): return newValue.intValue
            case .p_categories_get: return 0
			case .p_categories_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func queries(getter defaultValue: [Query]?...) -> PropertyStub {
            return Given(method: .p_queries_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func dataSeries(getter defaultValue: [Dictionary<String, Any>]?...) -> PropertyStub {
            return Given(method: .p_dataSeries_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func displayXAxisValueLabels(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_displayXAxisValueLabels_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func chartType(getter defaultValue: AAChartType?...) -> PropertyStub {
            return Given(method: .p_chartType_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func categories(getter defaultValue: [String]?...) -> PropertyStub {
            return Given(method: .p_categories_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var queries: Verify { return Verify(method: .p_queries_get) }
		public static func queries(set newValue: Parameter<[Query]?>) -> Verify { return Verify(method: .p_queries_set(newValue)) }
        public static var dataSeries: Verify { return Verify(method: .p_dataSeries_get) }
		public static func dataSeries(set newValue: Parameter<[Dictionary<String, Any>]?>) -> Verify { return Verify(method: .p_dataSeries_set(newValue)) }
        public static var displayXAxisValueLabels: Verify { return Verify(method: .p_displayXAxisValueLabels_get) }
		public static func displayXAxisValueLabels(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_displayXAxisValueLabels_set(newValue)) }
        public static var chartType: Verify { return Verify(method: .p_chartType_get) }
		public static func chartType(set newValue: Parameter<AAChartType?>) -> Verify { return Verify(method: .p_chartType_set(newValue)) }
        public static var categories: Verify { return Verify(method: .p_categories_get) }
		public static func categories(set newValue: Parameter<[String]?>) -> Verify { return Verify(method: .p_categories_set(newValue)) }
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
