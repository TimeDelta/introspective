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
@testable import Queries

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

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }




    public var queries: [Query]? {
		get {	invocations.append(.p_queries_get); return __p_queries ?? optionalGivenGetterValue(.p_queries_get, "BasicXYChartViewControllerMock - stub value for queries was not defined") }
		set {	invocations.append(.p_queries_set(.value(newValue))); __p_queries = newValue }
	}
	private var __p_queries: ([Query])?


    public var dataSeries: [AASeriesElement]! {
		get {	invocations.append(.p_dataSeries_get); return __p_dataSeries ?? optionalGivenGetterValue(.p_dataSeries_get, "BasicXYChartViewControllerMock - stub value for dataSeries was not defined") }
		set {	invocations.append(.p_dataSeries_set(.value(newValue))); __p_dataSeries = newValue }
	}
	private var __p_dataSeries: ([AASeriesElement])?


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
		case p_dataSeries_set(Parameter<[AASeriesElement]?>)
        case p_displayXAxisValueLabels_get
		case p_displayXAxisValueLabels_set(Parameter<Bool>)
        case p_chartType_get
		case p_chartType_set(Parameter<AAChartType?>)
        case p_categories_get
		case p_categories_set(Parameter<[String]?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_queries_get,.p_queries_get): return Matcher.ComparisonResult.match
			case (.p_queries_set(let left),.p_queries_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<[Query]?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_dataSeries_get,.p_dataSeries_get): return Matcher.ComparisonResult.match
			case (.p_dataSeries_set(let left),.p_dataSeries_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<[AASeriesElement]?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_displayXAxisValueLabels_get,.p_displayXAxisValueLabels_get): return Matcher.ComparisonResult.match
			case (.p_displayXAxisValueLabels_set(let left),.p_displayXAxisValueLabels_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_chartType_get,.p_chartType_get): return Matcher.ComparisonResult.match
			case (.p_chartType_set(let left),.p_chartType_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<AAChartType?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_categories_get,.p_categories_get): return Matcher.ComparisonResult.match
			case (.p_categories_set(let left),.p_categories_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<[String]?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
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
        func assertionName() -> String {
            switch self {
            case .p_queries_get: return "[get] .queries"
			case .p_queries_set: return "[set] .queries"
            case .p_dataSeries_get: return "[get] .dataSeries"
			case .p_dataSeries_set: return "[set] .dataSeries"
            case .p_displayXAxisValueLabels_get: return "[get] .displayXAxisValueLabels"
			case .p_displayXAxisValueLabels_set: return "[set] .displayXAxisValueLabels"
            case .p_chartType_get: return "[get] .chartType"
			case .p_chartType_set: return "[set] .chartType"
            case .p_categories_get: return "[get] .categories"
			case .p_categories_set: return "[set] .categories"
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
        public static func dataSeries(getter defaultValue: [AASeriesElement]?...) -> PropertyStub {
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
		public static func dataSeries(set newValue: Parameter<[AASeriesElement]?>) -> Verify { return Verify(method: .p_dataSeries_set(newValue)) }
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
