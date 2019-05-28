//
//  QueryViewControllerMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/22/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective

// sourcery: mock = "QueryViewController"
class QueryViewControllerMock: UITableViewController, QueryViewController, Mock {

// sourcery:inline:auto:QueryViewControllerMock.autoMocked
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


    public var finishedButtonTitle: String! {
		get {	invocations.append(.p_finishedButtonTitle_get); return __p_finishedButtonTitle ?? optionalGivenGetterValue(.p_finishedButtonTitle_get, "QueryViewControllerMock - stub value for finishedButtonTitle was not defined") }
		set {	invocations.append(.p_finishedButtonTitle_set(.value(newValue))); __p_finishedButtonTitle = newValue }
	}
	private var __p_finishedButtonTitle: (String)?


    public var finishedButtonNotification: NotificationName! {
		get {	invocations.append(.p_finishedButtonNotification_get); return __p_finishedButtonNotification ?? optionalGivenGetterValue(.p_finishedButtonNotification_get, "QueryViewControllerMock - stub value for finishedButtonNotification was not defined") }
		set {	invocations.append(.p_finishedButtonNotification_set(.value(newValue))); __p_finishedButtonNotification = newValue }
	}
	private var __p_finishedButtonNotification: (NotificationName)?


    public var topmostSampleType: Sample.Type? {
		get {	invocations.append(.p_topmostSampleType_get); return __p_topmostSampleType ?? optionalGivenGetterValue(.p_topmostSampleType_get, "QueryViewControllerMock - stub value for topmostSampleType was not defined") }
		set {	invocations.append(.p_topmostSampleType_set(.value(newValue))); __p_topmostSampleType = newValue }
	}
	private var __p_topmostSampleType: (Sample.Type)?


    public var initialQuery: Query? {
		get {	invocations.append(.p_initialQuery_get); return __p_initialQuery ?? optionalGivenGetterValue(.p_initialQuery_get, "QueryViewControllerMock - stub value for initialQuery was not defined") }
		set {	invocations.append(.p_initialQuery_set(.value(newValue))); __p_initialQuery = newValue }
	}
	private var __p_initialQuery: (Query)?







    fileprivate enum MethodType {
        case p_finishedButtonTitle_get
		case p_finishedButtonTitle_set(Parameter<String?>)
        case p_finishedButtonNotification_get
		case p_finishedButtonNotification_set(Parameter<NotificationName?>)
        case p_topmostSampleType_get
		case p_topmostSampleType_set(Parameter<Sample.Type?>)
        case p_initialQuery_get
		case p_initialQuery_set(Parameter<Query?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_finishedButtonTitle_get,.p_finishedButtonTitle_get): return true
			case (.p_finishedButtonTitle_set(let left),.p_finishedButtonTitle_set(let right)): return Parameter<String?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_finishedButtonNotification_get,.p_finishedButtonNotification_get): return true
			case (.p_finishedButtonNotification_set(let left),.p_finishedButtonNotification_set(let right)): return Parameter<NotificationName?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_topmostSampleType_get,.p_topmostSampleType_get): return true
			case (.p_topmostSampleType_set(let left),.p_topmostSampleType_set(let right)): return Parameter<Sample.Type?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_initialQuery_get,.p_initialQuery_get): return true
			case (.p_initialQuery_set(let left),.p_initialQuery_set(let right)): return Parameter<Query?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_finishedButtonTitle_get: return 0
			case .p_finishedButtonTitle_set(let newValue): return newValue.intValue
            case .p_finishedButtonNotification_get: return 0
			case .p_finishedButtonNotification_set(let newValue): return newValue.intValue
            case .p_topmostSampleType_get: return 0
			case .p_topmostSampleType_set(let newValue): return newValue.intValue
            case .p_initialQuery_get: return 0
			case .p_initialQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func finishedButtonTitle(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_finishedButtonTitle_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func finishedButtonNotification(getter defaultValue: NotificationName?...) -> PropertyStub {
            return Given(method: .p_finishedButtonNotification_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func topmostSampleType(getter defaultValue: Sample.Type?...) -> PropertyStub {
            return Given(method: .p_topmostSampleType_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func initialQuery(getter defaultValue: Query?...) -> PropertyStub {
            return Given(method: .p_initialQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var finishedButtonTitle: Verify { return Verify(method: .p_finishedButtonTitle_get) }
		public static func finishedButtonTitle(set newValue: Parameter<String?>) -> Verify { return Verify(method: .p_finishedButtonTitle_set(newValue)) }
        public static var finishedButtonNotification: Verify { return Verify(method: .p_finishedButtonNotification_get) }
		public static func finishedButtonNotification(set newValue: Parameter<NotificationName?>) -> Verify { return Verify(method: .p_finishedButtonNotification_set(newValue)) }
        public static var topmostSampleType: Verify { return Verify(method: .p_topmostSampleType_get) }
		public static func topmostSampleType(set newValue: Parameter<Sample.Type?>) -> Verify { return Verify(method: .p_topmostSampleType_set(newValue)) }
        public static var initialQuery: Verify { return Verify(method: .p_initialQuery_get) }
		public static func initialQuery(set newValue: Parameter<Query?>) -> Verify { return Verify(method: .p_initialQuery_set(newValue)) }
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
