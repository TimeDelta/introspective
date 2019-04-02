//
//  SubQueryMatcherMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective

// sourcery: mock = "SubQueryMatcher"
class SubQueryMatcherMock: SubQueryMatcher, Mock {
	fileprivate var _description: String!

	var description: String {
		get { return _description }
		set { _description = newValue }
	}

// sourcery:inline:auto:SubQueryMatcherMock.autoMocked
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


    public var mostRecentOnly: Bool {
		get {	invocations.append(.p_mostRecentOnly_get); return __p_mostRecentOnly ?? givenGetterValue(.p_mostRecentOnly_get, "SubQueryMatcherMock - stub value for mostRecentOnly was not defined") }
		set {	invocations.append(.p_mostRecentOnly_set(.value(newValue))); __p_mostRecentOnly = newValue }
	}
	private var __p_mostRecentOnly: (Bool)?


    public var attributedName: String {
		get {	invocations.append(.p_attributedName_get); return __p_attributedName ?? givenGetterValue(.p_attributedName_get, "SubQueryMatcherMock - stub value for attributedName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_attributedName = newValue }
	}
	private var __p_attributedName: (String)?


    public var attributes: [Attribute] {
		get {	invocations.append(.p_attributes_get); return __p_attributes ?? givenGetterValue(.p_attributes_get, "SubQueryMatcherMock - stub value for attributes was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_attributes = newValue }
	}
	private var __p_attributes: ([Attribute])?


    public var debugDescription: String {
		get {	invocations.append(.p_debugDescription_get); return __p_debugDescription ?? givenGetterValue(.p_debugDescription_get, "SubQueryMatcherMock - stub value for debugDescription was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_debugDescription = newValue }
	}
	private var __p_debugDescription: (String)?






    public required init() { }

    open func getSamples<QuerySampleType: Sample>(from querySamples: [QuerySampleType], matching subQuerySamples: [Sample]) throws -> [QuerySampleType] {
        addInvocation(.m_getSamples__from_querySamplesmatching_subQuerySamples(Parameter<[QuerySampleType]>.value(`querySamples`).wrapAsGeneric(), Parameter<[Sample]>.value(`subQuerySamples`)))
		let perform = methodPerformValue(.m_getSamples__from_querySamplesmatching_subQuerySamples(Parameter<[QuerySampleType]>.value(`querySamples`).wrapAsGeneric(), Parameter<[Sample]>.value(`subQuerySamples`))) as? ([QuerySampleType], [Sample]) -> Void
		perform?(`querySamples`, `subQuerySamples`)
		var __value: [QuerySampleType]
		do {
		    __value = try methodReturnValue(.m_getSamples__from_querySamplesmatching_subQuerySamples(Parameter<[QuerySampleType]>.value(`querySamples`).wrapAsGeneric(), Parameter<[Sample]>.value(`subQuerySamples`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getSamples<QuerySampleType: Sample>(from querySamples: [QuerySampleType], matching subQuerySamples: [Sample]). Use given")
			Failure("Stub return value not specified for getSamples<QuerySampleType: Sample>(from querySamples: [QuerySampleType], matching subQuerySamples: [Sample]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
        addInvocation(.m_equalTo__otherMatcher(Parameter<SubQueryMatcher>.value(`otherMatcher`)))
		let perform = methodPerformValue(.m_equalTo__otherMatcher(Parameter<SubQueryMatcher>.value(`otherMatcher`))) as? (SubQueryMatcher) -> Void
		perform?(`otherMatcher`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherMatcher(Parameter<SubQueryMatcher>.value(`otherMatcher`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherMatcher: SubQueryMatcher). Use given")
			Failure("Stub return value not specified for equalTo(_ otherMatcher: SubQueryMatcher). Use given")
		}
		return __value
    }

    open func attributeValuesAreValid() -> Bool {
        addInvocation(.m_attributeValuesAreValid)
		let perform = methodPerformValue(.m_attributeValuesAreValid) as? () -> Void
		perform?()
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_attributeValuesAreValid).casted()
		} catch {
			onFatalFailure("Stub return value not specified for attributeValuesAreValid(). Use given")
			Failure("Stub return value not specified for attributeValuesAreValid(). Use given")
		}
		return __value
    }

    open func value(of attribute: Attribute) throws -> Any? {
        addInvocation(.m_value__of_attribute(Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_value__of_attribute(Parameter<Attribute>.value(`attribute`))) as? (Attribute) -> Void
		perform?(`attribute`)
		var __value: Any? = nil
		do {
		    __value = try methodReturnValue(.m_value__of_attribute(Parameter<Attribute>.value(`attribute`))).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    open func set(attribute: Attribute, to value: Any?) throws {
        addInvocation(.m_set__attribute_attributeto_value(Parameter<Attribute>.value(`attribute`), Parameter<Any?>.value(`value`)))
		let perform = methodPerformValue(.m_set__attribute_attributeto_value(Parameter<Attribute>.value(`attribute`), Parameter<Any?>.value(`value`))) as? (Attribute, Any?) -> Void
		perform?(`attribute`, `value`)
		do {
		    _ = try methodReturnValue(.m_set__attribute_attributeto_value(Parameter<Attribute>.value(`attribute`), Parameter<Any?>.value(`value`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func equalTo(_ otherAttributed: Attributed) -> Bool {
        addInvocation(.m_equalTo__otherAttributed(Parameter<Attributed>.value(`otherAttributed`)))
		let perform = methodPerformValue(.m_equalTo__otherAttributed(Parameter<Attributed>.value(`otherAttributed`))) as? (Attributed) -> Void
		perform?(`otherAttributed`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherAttributed(Parameter<Attributed>.value(`otherAttributed`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherAttributed: Attributed). Use given")
			Failure("Stub return value not specified for equalTo(_ otherAttributed: Attributed). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getSamples__from_querySamplesmatching_subQuerySamples(Parameter<GenericAttribute>, Parameter<[Sample]>)
        case m_equalTo__otherMatcher(Parameter<SubQueryMatcher>)
        case m_attributeValuesAreValid
        case m_value__of_attribute(Parameter<Attribute>)
        case m_set__attribute_attributeto_value(Parameter<Attribute>, Parameter<Any?>)
        case m_equalTo__otherAttributed(Parameter<Attributed>)
        case p_mostRecentOnly_get
		case p_mostRecentOnly_set(Parameter<Bool>)
        case p_attributedName_get
        case p_attributes_get
        case p_debugDescription_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_getSamples__from_querySamplesmatching_subQuerySamples(let lhsQuerysamples, let lhsSubquerysamples), .m_getSamples__from_querySamplesmatching_subQuerySamples(let rhsQuerysamples, let rhsSubquerysamples)):
                guard Parameter.compare(lhs: lhsQuerysamples, rhs: rhsQuerysamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSubquerysamples, rhs: rhsSubquerysamples, with: matcher) else { return false } 
                return true 
            case (.m_equalTo__otherMatcher(let lhsOthermatcher), .m_equalTo__otherMatcher(let rhsOthermatcher)):
                guard Parameter.compare(lhs: lhsOthermatcher, rhs: rhsOthermatcher, with: matcher) else { return false } 
                return true 
            case (.m_attributeValuesAreValid, .m_attributeValuesAreValid):
                return true 
            case (.m_value__of_attribute(let lhsAttribute), .m_value__of_attribute(let rhsAttribute)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                return true 
            case (.m_set__attribute_attributeto_value(let lhsAttribute, let lhsValue), .m_set__attribute_attributeto_value(let rhsAttribute, let rhsValue)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_equalTo__otherAttributed(let lhsOtherattributed), .m_equalTo__otherAttributed(let rhsOtherattributed)):
                guard Parameter.compare(lhs: lhsOtherattributed, rhs: rhsOtherattributed, with: matcher) else { return false } 
                return true 
            case (.p_mostRecentOnly_get,.p_mostRecentOnly_get): return true
			case (.p_mostRecentOnly_set(let left),.p_mostRecentOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_attributedName_get,.p_attributedName_get): return true
            case (.p_attributes_get,.p_attributes_get): return true
            case (.p_debugDescription_get,.p_debugDescription_get): return true
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getSamples__from_querySamplesmatching_subQuerySamples(p0, p1): return p0.intValue + p1.intValue
            case let .m_equalTo__otherMatcher(p0): return p0.intValue
            case .m_attributeValuesAreValid: return 0
            case let .m_value__of_attribute(p0): return p0.intValue
            case let .m_set__attribute_attributeto_value(p0, p1): return p0.intValue + p1.intValue
            case let .m_equalTo__otherAttributed(p0): return p0.intValue
            case .p_mostRecentOnly_get: return 0
			case .p_mostRecentOnly_set(let newValue): return newValue.intValue
            case .p_attributedName_get: return 0
            case .p_attributes_get: return 0
            case .p_debugDescription_get: return 0
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func mostRecentOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func attributedName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_attributedName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func attributes(getter defaultValue: [Attribute]...) -> PropertyStub {
            return Given(method: .p_attributes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func debugDescription(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_debugDescription_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func getSamples<QuerySampleType: Sample>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>, willReturn: [QuerySampleType]...) -> MethodStub {
            return Given(method: .m_getSamples__from_querySamplesmatching_subQuerySamples(`querySamples`.wrapAsGeneric(), `subQuerySamples`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherMatcher: Parameter<SubQueryMatcher>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherMatcher(`otherMatcher`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func attributeValuesAreValid(willReturn: Bool...) -> MethodStub {
            return Given(method: .m_attributeValuesAreValid, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func value(of attribute: Parameter<Attribute>, willReturn: Any?...) -> MethodStub {
            return Given(method: .m_value__of_attribute(`attribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherAttributed: Parameter<Attributed>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherAttributed(`otherAttributed`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherMatcher: Parameter<SubQueryMatcher>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherMatcher(`otherMatcher`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func attributeValuesAreValid(willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_attributeValuesAreValid, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ otherAttributed: Parameter<Attributed>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherAttributed(`otherAttributed`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func getSamples<QuerySampleType: Sample>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getSamples__from_querySamplesmatching_subQuerySamples(`querySamples`.wrapAsGeneric(), `subQuerySamples`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getSamples<QuerySampleType: Sample>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>, willProduce: (StubberThrows<[QuerySampleType]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getSamples__from_querySamplesmatching_subQuerySamples(`querySamples`.wrapAsGeneric(), `subQuerySamples`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([QuerySampleType]).self)
			willProduce(stubber)
			return given
        }
        public static func value(of attribute: Parameter<Attribute>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_value__of_attribute(`attribute`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func value(of attribute: Parameter<Attribute>, willProduce: (StubberThrows<Any?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_value__of_attribute(`attribute`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Any?).self)
			willProduce(stubber)
			return given
        }
        public static func set(attribute: Parameter<Attribute>, to value: Parameter<Any?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_set__attribute_attributeto_value(`attribute`, `value`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func set(attribute: Parameter<Attribute>, to value: Parameter<Any?>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_set__attribute_attributeto_value(`attribute`, `value`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getSamples<QuerySampleType>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>) -> Verify where QuerySampleType:Sample { return Verify(method: .m_getSamples__from_querySamplesmatching_subQuerySamples(`querySamples`.wrapAsGeneric(), `subQuerySamples`))}
        public static func equalTo(_ otherMatcher: Parameter<SubQueryMatcher>) -> Verify { return Verify(method: .m_equalTo__otherMatcher(`otherMatcher`))}
        public static func attributeValuesAreValid() -> Verify { return Verify(method: .m_attributeValuesAreValid)}
        public static func value(of attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_value__of_attribute(`attribute`))}
        public static func set(attribute: Parameter<Attribute>, to value: Parameter<Any?>) -> Verify { return Verify(method: .m_set__attribute_attributeto_value(`attribute`, `value`))}
        public static func equalTo(_ otherAttributed: Parameter<Attributed>) -> Verify { return Verify(method: .m_equalTo__otherAttributed(`otherAttributed`))}
        public static var mostRecentOnly: Verify { return Verify(method: .p_mostRecentOnly_get) }
		public static func mostRecentOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentOnly_set(newValue)) }
        public static var attributedName: Verify { return Verify(method: .p_attributedName_get) }
        public static var attributes: Verify { return Verify(method: .p_attributes_get) }
        public static var debugDescription: Verify { return Verify(method: .p_debugDescription_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getSamples<QuerySampleType>(from querySamples: Parameter<[QuerySampleType]>, matching subQuerySamples: Parameter<[Sample]>, perform: @escaping ([QuerySampleType], [Sample]) -> Void) -> Perform where QuerySampleType:Sample {
            return Perform(method: .m_getSamples__from_querySamplesmatching_subQuerySamples(`querySamples`.wrapAsGeneric(), `subQuerySamples`), performs: perform)
        }
        public static func equalTo(_ otherMatcher: Parameter<SubQueryMatcher>, perform: @escaping (SubQueryMatcher) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherMatcher(`otherMatcher`), performs: perform)
        }
        public static func attributeValuesAreValid(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_attributeValuesAreValid, performs: perform)
        }
        public static func value(of attribute: Parameter<Attribute>, perform: @escaping (Attribute) -> Void) -> Perform {
            return Perform(method: .m_value__of_attribute(`attribute`), performs: perform)
        }
        public static func set(attribute: Parameter<Attribute>, to value: Parameter<Any?>, perform: @escaping (Attribute, Any?) -> Void) -> Perform {
            return Perform(method: .m_set__attribute_attributeto_value(`attribute`, `value`), performs: perform)
        }
        public static func equalTo(_ otherAttributed: Parameter<Attributed>, perform: @escaping (Attributed) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherAttributed(`otherAttributed`), performs: perform)
        }
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
