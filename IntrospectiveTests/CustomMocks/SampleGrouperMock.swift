//
//  SampleGrouperMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/31/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective
@testable import Attributes
@testable import SampleGroupers
@testable import Samples

// sourcery: mock = "SampleGrouper"
class SampleGrouperMock: SampleGrouper, Mock {

	public final var description: String = ""

// sourcery:inline:auto:SampleGrouperMock.autoMocked
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
    static var matcher: Matcher = Matcher.default
    static var stubbingPolicy: StubbingPolicy = .wrap
    static var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst
    static private var invocations: [StaticMethodType] = []
    static private var methodReturnValues: [StaticGiven] = []
    static private var methodPerformValues: [StaticPerform] = []
    public typealias StaticPropertyStub = StaticGiven
    public typealias StaticMethodStub = StaticGiven
    public static func clear() {
        invocations = []
        methodReturnValues = []
        methodPerformValues = []
    }


    public var attributedName: String {
		get {	invocations.append(.p_attributedName_get); return __p_attributedName ?? givenGetterValue(.p_attributedName_get, "SampleGrouperMock - stub value for attributedName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_attributedName = newValue }
	}
	private var __p_attributedName: (String)?


    public var attributes: [Attribute] {
		get {	invocations.append(.p_attributes_get); return __p_attributes ?? givenGetterValue(.p_attributes_get, "SampleGrouperMock - stub value for attributes was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_attributes = newValue }
	}
	private var __p_attributes: ([Attribute])?


    public var debugDescription: String {
		get {	invocations.append(.p_debugDescription_get); return __p_debugDescription ?? givenGetterValue(.p_debugDescription_get, "SampleGrouperMock - stub value for debugDescription was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_debugDescription = newValue }
	}
	private var __p_debugDescription: (String)?



    public static var userVisibleDescription: String {
		get {	SampleGrouperMock.invocations.append(.p_userVisibleDescription_get); return SampleGrouperMock.__p_userVisibleDescription ?? givenGetterValue(.p_userVisibleDescription_get, "SampleGrouperMock - stub value for userVisibleDescription was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	SampleGrouperMock.__p_userVisibleDescription = newValue }
	}
	private static var __p_userVisibleDescription: (String)?





    public required init(sampleType: Sample.Type) { }

    public required init(attributes: [Attribute]) { }

    open func group(samples: [Sample]) throws -> [(Any, [Sample])] {
        addInvocation(.m_group__samples_samples(Parameter<[Sample]>.value(`samples`)))
		let perform = methodPerformValue(.m_group__samples_samples(Parameter<[Sample]>.value(`samples`))) as? ([Sample]) -> Void
		perform?(`samples`)
		var __value: [(Any, [Sample])]
		do {
		    __value = try methodReturnValue(.m_group__samples_samples(Parameter<[Sample]>.value(`samples`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for group(samples: [Sample]). Use given")
			Failure("Stub return value not specified for group(samples: [Sample]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func groupNameFor(value: Any) throws -> String {
        addInvocation(.m_groupNameFor__value_value(Parameter<Any>.value(`value`)))
		let perform = methodPerformValue(.m_groupNameFor__value_value(Parameter<Any>.value(`value`))) as? (Any) -> Void
		perform?(`value`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_groupNameFor__value_value(Parameter<Any>.value(`value`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for groupNameFor(value: Any). Use given")
			Failure("Stub return value not specified for groupNameFor(value: Any). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func groupValuesAreEqual(_ first: Any, _ second: Any) throws -> Bool {
        addInvocation(.m_groupValuesAreEqual__first_second(Parameter<Any>.value(`first`), Parameter<Any>.value(`second`)))
		let perform = methodPerformValue(.m_groupValuesAreEqual__first_second(Parameter<Any>.value(`first`), Parameter<Any>.value(`second`))) as? (Any, Any) -> Void
		perform?(`first`, `second`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_groupValuesAreEqual__first_second(Parameter<Any>.value(`first`), Parameter<Any>.value(`second`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for groupValuesAreEqual(_ first: Any, _ second: Any). Use given")
			Failure("Stub return value not specified for groupValuesAreEqual(_ first: Any, _ second: Any). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func copy() -> SampleGrouper {
        addInvocation(.m_copy)
		let perform = methodPerformValue(.m_copy) as? () -> Void
		perform?()
		var __value: SampleGrouper
		do {
		    __value = try methodReturnValue(.m_copy).casted()
		} catch {
			onFatalFailure("Stub return value not specified for copy(). Use given")
			Failure("Stub return value not specified for copy(). Use given")
		}
		return __value
    }

    open func equalTo(_ otherGrouper: SampleGrouper) -> Bool {
        addInvocation(.m_equalTo__otherGrouper(Parameter<SampleGrouper>.value(`otherGrouper`)))
		let perform = methodPerformValue(.m_equalTo__otherGrouper(Parameter<SampleGrouper>.value(`otherGrouper`))) as? (SampleGrouper) -> Void
		perform?(`otherGrouper`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherGrouper(Parameter<SampleGrouper>.value(`otherGrouper`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherGrouper: SampleGrouper). Use given")
			Failure("Stub return value not specified for equalTo(_ otherGrouper: SampleGrouper). Use given")
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

    fileprivate enum StaticMethodType {
        case p_userVisibleDescription_get

        static func compareParameters(lhs: StaticMethodType, rhs: StaticMethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_userVisibleDescription_get,.p_userVisibleDescription_get): return true
            }
        }

        func intValue() -> Int {
            switch self {
                case .p_userVisibleDescription_get: return 0
            }
        }
    }

    open class StaticGiven: StubbedMethod {
        fileprivate var method: StaticMethodType

        private init(method: StaticMethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func userVisibleDescription(getter defaultValue: String...) -> StaticPropertyStub {
            return StaticGiven(method: .p_userVisibleDescription_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct StaticVerify {
        fileprivate var method: StaticMethodType

        public static var userVisibleDescription: StaticVerify { return StaticVerify(method: .p_userVisibleDescription_get) }
    }

    public struct StaticPerform {
        fileprivate var method: StaticMethodType
        var performs: Any

    }

    
    fileprivate enum MethodType {
        case m_group__samples_samples(Parameter<[Sample]>)
        case m_groupNameFor__value_value(Parameter<Any>)
        case m_groupValuesAreEqual__first_second(Parameter<Any>, Parameter<Any>)
        case m_copy
        case m_equalTo__otherGrouper(Parameter<SampleGrouper>)
        case m_attributeValuesAreValid
        case m_value__of_attribute(Parameter<Attribute>)
        case m_set__attribute_attributeto_value(Parameter<Attribute>, Parameter<Any?>)
        case m_equalTo__otherAttributed(Parameter<Attributed>)
        case p_attributedName_get
        case p_attributes_get
        case p_debugDescription_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_group__samples_samples(let lhsSamples), .m_group__samples_samples(let rhsSamples)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                return true 
            case (.m_groupNameFor__value_value(let lhsValue), .m_groupNameFor__value_value(let rhsValue)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_groupValuesAreEqual__first_second(let lhsFirst, let lhsSecond), .m_groupValuesAreEqual__first_second(let rhsFirst, let rhsSecond)):
                guard Parameter.compare(lhs: lhsFirst, rhs: rhsFirst, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSecond, rhs: rhsSecond, with: matcher) else { return false } 
                return true 
            case (.m_copy, .m_copy):
                return true 
            case (.m_equalTo__otherGrouper(let lhsOthergrouper), .m_equalTo__otherGrouper(let rhsOthergrouper)):
                guard Parameter.compare(lhs: lhsOthergrouper, rhs: rhsOthergrouper, with: matcher) else { return false } 
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
            case (.p_attributedName_get,.p_attributedName_get): return true
            case (.p_attributes_get,.p_attributes_get): return true
            case (.p_debugDescription_get,.p_debugDescription_get): return true
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_group__samples_samples(p0): return p0.intValue
            case let .m_groupNameFor__value_value(p0): return p0.intValue
            case let .m_groupValuesAreEqual__first_second(p0, p1): return p0.intValue + p1.intValue
            case .m_copy: return 0
            case let .m_equalTo__otherGrouper(p0): return p0.intValue
            case .m_attributeValuesAreValid: return 0
            case let .m_value__of_attribute(p0): return p0.intValue
            case let .m_set__attribute_attributeto_value(p0, p1): return p0.intValue + p1.intValue
            case let .m_equalTo__otherAttributed(p0): return p0.intValue
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

        public static func attributedName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_attributedName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func attributes(getter defaultValue: [Attribute]...) -> PropertyStub {
            return Given(method: .p_attributes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func debugDescription(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_debugDescription_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func group(samples: Parameter<[Sample]>, willReturn: [(Any, [Sample])]...) -> MethodStub {
            return Given(method: .m_group__samples_samples(`samples`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func groupNameFor(value: Parameter<Any>, willReturn: String...) -> MethodStub {
            return Given(method: .m_groupNameFor__value_value(`value`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func groupValuesAreEqual(_ first: Parameter<Any>, _ second: Parameter<Any>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_groupValuesAreEqual__first_second(`first`, `second`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func copy(willReturn: SampleGrouper...) -> MethodStub {
            return Given(method: .m_copy, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherGrouper: Parameter<SampleGrouper>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherGrouper(`otherGrouper`), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func copy(willProduce: (Stubber<SampleGrouper>) -> Void) -> MethodStub {
            let willReturn: [SampleGrouper] = []
			let given: Given = { return Given(method: .m_copy, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SampleGrouper).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ otherGrouper: Parameter<SampleGrouper>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherGrouper(`otherGrouper`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
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
        public static func group(samples: Parameter<[Sample]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_group__samples_samples(`samples`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func group(samples: Parameter<[Sample]>, willProduce: (StubberThrows<[(Any, [Sample])]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_group__samples_samples(`samples`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(Any, [Sample])]).self)
			willProduce(stubber)
			return given
        }
        public static func groupNameFor(value: Parameter<Any>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_groupNameFor__value_value(`value`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func groupNameFor(value: Parameter<Any>, willProduce: (StubberThrows<String>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_groupNameFor__value_value(`value`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func groupValuesAreEqual(_ first: Parameter<Any>, _ second: Parameter<Any>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_groupValuesAreEqual__first_second(`first`, `second`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func groupValuesAreEqual(_ first: Parameter<Any>, _ second: Parameter<Any>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_groupValuesAreEqual__first_second(`first`, `second`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
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

        public static func group(samples: Parameter<[Sample]>) -> Verify { return Verify(method: .m_group__samples_samples(`samples`))}
        public static func groupNameFor(value: Parameter<Any>) -> Verify { return Verify(method: .m_groupNameFor__value_value(`value`))}
        public static func groupValuesAreEqual(_ first: Parameter<Any>, _ second: Parameter<Any>) -> Verify { return Verify(method: .m_groupValuesAreEqual__first_second(`first`, `second`))}
        public static func copy() -> Verify { return Verify(method: .m_copy)}
        public static func equalTo(_ otherGrouper: Parameter<SampleGrouper>) -> Verify { return Verify(method: .m_equalTo__otherGrouper(`otherGrouper`))}
        public static func attributeValuesAreValid() -> Verify { return Verify(method: .m_attributeValuesAreValid)}
        public static func value(of attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_value__of_attribute(`attribute`))}
        public static func set(attribute: Parameter<Attribute>, to value: Parameter<Any?>) -> Verify { return Verify(method: .m_set__attribute_attributeto_value(`attribute`, `value`))}
        public static func equalTo(_ otherAttributed: Parameter<Attributed>) -> Verify { return Verify(method: .m_equalTo__otherAttributed(`otherAttributed`))}
        public static var attributedName: Verify { return Verify(method: .p_attributedName_get) }
        public static var attributes: Verify { return Verify(method: .p_attributes_get) }
        public static var debugDescription: Verify { return Verify(method: .p_debugDescription_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func group(samples: Parameter<[Sample]>, perform: @escaping ([Sample]) -> Void) -> Perform {
            return Perform(method: .m_group__samples_samples(`samples`), performs: perform)
        }
        public static func groupNameFor(value: Parameter<Any>, perform: @escaping (Any) -> Void) -> Perform {
            return Perform(method: .m_groupNameFor__value_value(`value`), performs: perform)
        }
        public static func groupValuesAreEqual(_ first: Parameter<Any>, _ second: Parameter<Any>, perform: @escaping (Any, Any) -> Void) -> Perform {
            return Perform(method: .m_groupValuesAreEqual__first_second(`first`, `second`), performs: perform)
        }
        public static func copy(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_copy, performs: perform)
        }
        public static func equalTo(_ otherGrouper: Parameter<SampleGrouper>, perform: @escaping (SampleGrouper) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherGrouper(`otherGrouper`), performs: perform)
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

    static public func given(_ method: StaticGiven) {
        methodReturnValues.append(method)
    }

    static public func perform(_ method: StaticPerform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    static public func verify(_ method: StaticVerify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    static private func addInvocation(_ call: StaticMethodType) {
        invocations.append(call)
    }
    static private func methodReturnValue(_ method: StaticMethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    static private func methodPerformValue(_ method: StaticMethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    static private func matchingCalls(_ method: StaticMethodType) -> [StaticMethodType] {
        return invocations.filter { StaticMethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    static private func matchingCalls(_ method: StaticVerify) -> Int {
        return matchingCalls(method.method).count
    }
    static private func givenGetterValue<T>(_ method: StaticMethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            Failure(message)
        }
    }
    static private func optionalGivenGetterValue<T>(_ method: StaticMethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
// sourcery:end
}
