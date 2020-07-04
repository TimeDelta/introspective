//
//  MoodMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import XCTest
import SwiftyMocky
import CSV
@testable import Introspective
@testable import Attributes
@testable import Samples

// sourcery: mock = "Mood"
class MoodMock: Mood, Mock, StaticMock {
	private var _description: String!

	var description: String {
		get { return _description }
		set { _description = newValue }
	}

// sourcery:inline:auto:MoodMock.autoMocked
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
    static var matcher: Matcher = Matcher.default
    static var stubbingPolicy: StubbingPolicy = .wrap
    static var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst
    static private var invocations: [StaticMethodType] = []
    static private var methodReturnValues: [StaticGiven] = []
    static private var methodPerformValues: [StaticPerform] = []
    public typealias StaticPropertyStub = StaticGiven
    public typealias StaticMethodStub = StaticGiven
    
    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public static func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }


    public var minRating: Double {
		get {	invocations.append(.p_minRating_get); return __p_minRating ?? givenGetterValue(.p_minRating_get, "MoodMock - stub value for minRating was not defined") }
		set {	invocations.append(.p_minRating_set(.value(newValue))); __p_minRating = newValue }
	}
	private var __p_minRating: (Double)?


    public var maxRating: Double {
		get {	invocations.append(.p_maxRating_get); return __p_maxRating ?? givenGetterValue(.p_maxRating_get, "MoodMock - stub value for maxRating was not defined") }
		set {	invocations.append(.p_maxRating_set(.value(newValue))); __p_maxRating = newValue }
	}
	private var __p_maxRating: (Double)?


    public var rating: Double {
		get {	invocations.append(.p_rating_get); return __p_rating ?? givenGetterValue(.p_rating_get, "MoodMock - stub value for rating was not defined") }
		set {	invocations.append(.p_rating_set(.value(newValue))); __p_rating = newValue }
	}
	private var __p_rating: (Double)?


    public var note: String? {
		get {	invocations.append(.p_note_get); return __p_note ?? optionalGivenGetterValue(.p_note_get, "MoodMock - stub value for note was not defined") }
		set {	invocations.append(.p_note_set(.value(newValue))); __p_note = newValue }
	}
	private var __p_note: (String)?


    public var date: Date {
		get {	invocations.append(.p_date_get); return __p_date ?? givenGetterValue(.p_date_get, "MoodMock - stub value for date was not defined") }
		set {	invocations.append(.p_date_set(.value(newValue))); __p_date = newValue }
	}
	private var __p_date: (Date)?


    public var attributedName: String {
		get {	invocations.append(.p_attributedName_get); return __p_attributedName ?? givenGetterValue(.p_attributedName_get, "MoodMock - stub value for attributedName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_attributedName = newValue }
	}
	private var __p_attributedName: (String)?


    public var attributes: [Attribute] {
		get {	invocations.append(.p_attributes_get); return __p_attributes ?? givenGetterValue(.p_attributes_get, "MoodMock - stub value for attributes was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_attributes = newValue }
	}
	private var __p_attributes: ([Attribute])?


    public var debugDescription: String {
		get {	invocations.append(.p_debugDescription_get); return __p_debugDescription ?? givenGetterValue(.p_debugDescription_get, "MoodMock - stub value for debugDescription was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_debugDescription = newValue }
	}
	private var __p_debugDescription: (String)?



    public static var rating: DoubleAttribute {
		get {	MoodMock.invocations.append(.p_rating_get); return MoodMock.__p_rating ?? givenGetterValue(.p_rating_get, "MoodMock - stub value for rating was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_rating = newValue }
	}
	private static var __p_rating: (DoubleAttribute)?


    public static var maxRating: DoubleAttribute {
		get {	MoodMock.invocations.append(.p_maxRating_get); return MoodMock.__p_maxRating ?? givenGetterValue(.p_maxRating_get, "MoodMock - stub value for maxRating was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_maxRating = newValue }
	}
	private static var __p_maxRating: (DoubleAttribute)?


    public static var note: TextAttribute {
		get {	MoodMock.invocations.append(.p_note_get); return MoodMock.__p_note ?? givenGetterValue(.p_note_get, "MoodMock - stub value for note was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_note = newValue }
	}
	private static var __p_note: (TextAttribute)?


    public static var entityName: String {
		get {	MoodMock.invocations.append(.p_entityName_get); return MoodMock.__p_entityName ?? givenGetterValue(.p_entityName_get, "MoodMock - stub value for entityName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_entityName = newValue }
	}
	private static var __p_entityName: (String)?


    public static var exportFileDescription: String {
		get {	MoodMock.invocations.append(.p_exportFileDescription_get); return MoodMock.__p_exportFileDescription ?? givenGetterValue(.p_exportFileDescription_get, "MoodMock - stub value for exportFileDescription was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_exportFileDescription = newValue }
	}
	private static var __p_exportFileDescription: (String)?


    public static var name: String {
		get {	MoodMock.invocations.append(.p_name_get); return MoodMock.__p_name ?? givenGetterValue(.p_name_get, "MoodMock - stub value for name was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_name = newValue }
	}
	private static var __p_name: (String)?


    public static var attributes: [Attribute] {
		get {	MoodMock.invocations.append(.p_attributes_get); return MoodMock.__p_attributes ?? givenGetterValue(.p_attributes_get, "MoodMock - stub value for attributes was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_attributes = newValue }
	}
	private static var __p_attributes: ([Attribute])?


    public static var defaultDependentAttribute: Attribute {
		get {	MoodMock.invocations.append(.p_defaultDependentAttribute_get); return MoodMock.__p_defaultDependentAttribute ?? givenGetterValue(.p_defaultDependentAttribute_get, "MoodMock - stub value for defaultDependentAttribute was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_defaultDependentAttribute = newValue }
	}
	private static var __p_defaultDependentAttribute: (Attribute)?


    public static var defaultIndependentAttribute: Attribute {
		get {	MoodMock.invocations.append(.p_defaultIndependentAttribute_get); return MoodMock.__p_defaultIndependentAttribute ?? givenGetterValue(.p_defaultIndependentAttribute_get, "MoodMock - stub value for defaultIndependentAttribute was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_defaultIndependentAttribute = newValue }
	}
	private static var __p_defaultIndependentAttribute: (Attribute)?





    public static func exportHeaderRow(to csv: CSVWriter) throws {
        addInvocation(.sm_exportHeaderRow__to_csv(Parameter<CSVWriter>.value(`csv`)))
		let perform = methodPerformValue(.sm_exportHeaderRow__to_csv(Parameter<CSVWriter>.value(`csv`))) as? (CSVWriter) -> Void
		perform?(`csv`)
		do {
		    _ = try methodReturnValue(.sm_exportHeaderRow__to_csv(Parameter<CSVWriter>.value(`csv`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func setSource(_ source: Sources.MoodSourceNum) {
        addInvocation(.m_setSource__source(Parameter<Sources.MoodSourceNum>.value(`source`)))
		let perform = methodPerformValue(.m_setSource__source(Parameter<Sources.MoodSourceNum>.value(`source`))) as? (Sources.MoodSourceNum) -> Void
		perform?(`source`)
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

    open func export(to csv: CSVWriter) throws {
        addInvocation(.m_export__to_csv(Parameter<CSVWriter>.value(`csv`)))
		let perform = methodPerformValue(.m_export__to_csv(Parameter<CSVWriter>.value(`csv`))) as? (CSVWriter) -> Void
		perform?(`csv`)
		do {
		    _ = try methodReturnValue(.m_export__to_csv(Parameter<CSVWriter>.value(`csv`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func graphableValue(of attribute: Attribute) throws -> Any? {
        addInvocation(.m_graphableValue__of_attribute(Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_graphableValue__of_attribute(Parameter<Attribute>.value(`attribute`))) as? (Attribute) -> Void
		perform?(`attribute`)
		var __value: Any? = nil
		do {
		    __value = try methodReturnValue(.m_graphableValue__of_attribute(Parameter<Attribute>.value(`attribute`))).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    open func dates() -> [DateType: Date] {
        addInvocation(.m_dates)
		let perform = methodPerformValue(.m_dates) as? () -> Void
		perform?()
		var __value: [DateType: Date]
		do {
		    __value = try methodReturnValue(.m_dates).casted()
		} catch {
			onFatalFailure("Stub return value not specified for dates(). Use given")
			Failure("Stub return value not specified for dates(). Use given")
		}
		return __value
    }

    open func equalTo(_ otherSample: Sample) -> Bool {
        addInvocation(.m_equalTo__otherSample(Parameter<Sample>.value(`otherSample`)))
		let perform = methodPerformValue(.m_equalTo__otherSample(Parameter<Sample>.value(`otherSample`))) as? (Sample) -> Void
		perform?(`otherSample`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherSample(Parameter<Sample>.value(`otherSample`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherSample: Sample). Use given")
			Failure("Stub return value not specified for equalTo(_ otherSample: Sample). Use given")
		}
		return __value
    }

    open func safeEqualityCheck<Type: Equatable>(		_ attribute: Attribute,		_ otherSample: Sample,		as: Type.Type	) -> Bool {
        addInvocation(.m_safeEqualityCheck__attribute_otherSampleas_as(Parameter<Attribute>.value(`attribute`), Parameter<Sample>.value(`otherSample`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_safeEqualityCheck__attribute_otherSampleas_as(Parameter<Attribute>.value(`attribute`), Parameter<Sample>.value(`otherSample`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (Attribute, Sample, Type.Type) -> Void
		perform?(`attribute`, `otherSample`, `as`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_safeEqualityCheck__attribute_otherSampleas_as(Parameter<Attribute>.value(`attribute`), Parameter<Sample>.value(`otherSample`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for safeEqualityCheck<Type: Equatable>(  _ attribute: Attribute,  _ otherSample: Sample,  as: Type.Type ). Use given")
			Failure("Stub return value not specified for safeEqualityCheck<Type: Equatable>(  _ attribute: Attribute,  _ otherSample: Sample,  as: Type.Type ). Use given")
		}
		return __value
    }

    open func matchesSearchString(_ searchString: String) -> Bool {
        addInvocation(.m_matchesSearchString__searchString(Parameter<String>.value(`searchString`)))
		let perform = methodPerformValue(.m_matchesSearchString__searchString(Parameter<String>.value(`searchString`))) as? (String) -> Void
		perform?(`searchString`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_matchesSearchString__searchString(Parameter<String>.value(`searchString`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for matchesSearchString(_ searchString: String). Use given")
			Failure("Stub return value not specified for matchesSearchString(_ searchString: String). Use given")
		}
		return __value
    }

    fileprivate enum StaticMethodType {
        case sm_exportHeaderRow__to_csv(Parameter<CSVWriter>)
        case p_rating_get
        case p_maxRating_get
        case p_note_get
        case p_entityName_get
        case p_exportFileDescription_get
        case p_name_get
        case p_attributes_get
        case p_defaultDependentAttribute_get
        case p_defaultIndependentAttribute_get

        static func compareParameters(lhs: StaticMethodType, rhs: StaticMethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.sm_exportHeaderRow__to_csv(let lhsCsv), .sm_exportHeaderRow__to_csv(let rhsCsv)):
                guard Parameter.compare(lhs: lhsCsv, rhs: rhsCsv, with: matcher) else { return false } 
                return true 
            case (.p_rating_get,.p_rating_get): return true
            case (.p_maxRating_get,.p_maxRating_get): return true
            case (.p_note_get,.p_note_get): return true
            case (.p_entityName_get,.p_entityName_get): return true
            case (.p_exportFileDescription_get,.p_exportFileDescription_get): return true
            case (.p_name_get,.p_name_get): return true
            case (.p_attributes_get,.p_attributes_get): return true
            case (.p_defaultDependentAttribute_get,.p_defaultDependentAttribute_get): return true
            case (.p_defaultIndependentAttribute_get,.p_defaultIndependentAttribute_get): return true
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .sm_exportHeaderRow__to_csv(p0): return p0.intValue
                case .p_rating_get: return 0
                case .p_maxRating_get: return 0
                case .p_note_get: return 0
                case .p_entityName_get: return 0
                case .p_exportFileDescription_get: return 0
                case .p_name_get: return 0
                case .p_attributes_get: return 0
                case .p_defaultDependentAttribute_get: return 0
                case .p_defaultIndependentAttribute_get: return 0
            }
        }
    }

    open class StaticGiven: StubbedMethod {
        fileprivate var method: StaticMethodType

        private init(method: StaticMethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func rating(getter defaultValue: DoubleAttribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_rating_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func maxRating(getter defaultValue: DoubleAttribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_maxRating_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func note(getter defaultValue: TextAttribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_note_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func entityName(getter defaultValue: String...) -> StaticPropertyStub {
            return StaticGiven(method: .p_entityName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func exportFileDescription(getter defaultValue: String...) -> StaticPropertyStub {
            return StaticGiven(method: .p_exportFileDescription_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func name(getter defaultValue: String...) -> StaticPropertyStub {
            return StaticGiven(method: .p_name_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func attributes(getter defaultValue: [Attribute]...) -> StaticPropertyStub {
            return StaticGiven(method: .p_attributes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func defaultDependentAttribute(getter defaultValue: Attribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_defaultDependentAttribute_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func defaultIndependentAttribute(getter defaultValue: Attribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_defaultIndependentAttribute_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func exportHeaderRow(to csv: Parameter<CSVWriter>, willThrow: Error...) -> StaticMethodStub {
            return StaticGiven(method: .sm_exportHeaderRow__to_csv(`csv`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func exportHeaderRow(to csv: Parameter<CSVWriter>, willProduce: (StubberThrows<Void>) -> Void) -> StaticMethodStub {
            let willThrow: [Error] = []
			let given: StaticGiven = { return StaticGiven(method: .sm_exportHeaderRow__to_csv(`csv`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct StaticVerify {
        fileprivate var method: StaticMethodType

        public static func exportHeaderRow(to csv: Parameter<CSVWriter>) -> StaticVerify { return StaticVerify(method: .sm_exportHeaderRow__to_csv(`csv`))}
        public static var rating: StaticVerify { return StaticVerify(method: .p_rating_get) }
        public static var maxRating: StaticVerify { return StaticVerify(method: .p_maxRating_get) }
        public static var note: StaticVerify { return StaticVerify(method: .p_note_get) }
        public static var entityName: StaticVerify { return StaticVerify(method: .p_entityName_get) }
        public static var exportFileDescription: StaticVerify { return StaticVerify(method: .p_exportFileDescription_get) }
        public static var name: StaticVerify { return StaticVerify(method: .p_name_get) }
        public static var attributes: StaticVerify { return StaticVerify(method: .p_attributes_get) }
        public static var defaultDependentAttribute: StaticVerify { return StaticVerify(method: .p_defaultDependentAttribute_get) }
        public static var defaultIndependentAttribute: StaticVerify { return StaticVerify(method: .p_defaultIndependentAttribute_get) }
    }

    public struct StaticPerform {
        fileprivate var method: StaticMethodType
        var performs: Any

        public static func exportHeaderRow(to csv: Parameter<CSVWriter>, perform: @escaping (CSVWriter) -> Void) -> StaticPerform {
            return StaticPerform(method: .sm_exportHeaderRow__to_csv(`csv`), performs: perform)
        }
    }

    
    fileprivate enum MethodType {
        case m_setSource__source(Parameter<Sources.MoodSourceNum>)
        case m_attributeValuesAreValid
        case m_value__of_attribute(Parameter<Attribute>)
        case m_set__attribute_attributeto_value(Parameter<Attribute>, Parameter<Any?>)
        case m_equalTo__otherAttributed(Parameter<Attributed>)
        case m_export__to_csv(Parameter<CSVWriter>)
        case m_graphableValue__of_attribute(Parameter<Attribute>)
        case m_dates
        case m_equalTo__otherSample(Parameter<Sample>)
        case m_safeEqualityCheck__attribute_otherSampleas_as(Parameter<Attribute>, Parameter<Sample>, Parameter<GenericAttribute>)
        case m_matchesSearchString__searchString(Parameter<String>)
        case p_minRating_get
		case p_minRating_set(Parameter<Double>)
        case p_maxRating_get
		case p_maxRating_set(Parameter<Double>)
        case p_rating_get
		case p_rating_set(Parameter<Double>)
        case p_note_get
		case p_note_set(Parameter<String?>)
        case p_date_get
		case p_date_set(Parameter<Date>)
        case p_attributedName_get
        case p_attributes_get
        case p_debugDescription_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_setSource__source(let lhsSource), .m_setSource__source(let rhsSource)):
                guard Parameter.compare(lhs: lhsSource, rhs: rhsSource, with: matcher) else { return false } 
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
            case (.m_export__to_csv(let lhsCsv), .m_export__to_csv(let rhsCsv)):
                guard Parameter.compare(lhs: lhsCsv, rhs: rhsCsv, with: matcher) else { return false } 
                return true 
            case (.m_graphableValue__of_attribute(let lhsAttribute), .m_graphableValue__of_attribute(let rhsAttribute)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                return true 
            case (.m_dates, .m_dates):
                return true 
            case (.m_equalTo__otherSample(let lhsOthersample), .m_equalTo__otherSample(let rhsOthersample)):
                guard Parameter.compare(lhs: lhsOthersample, rhs: rhsOthersample, with: matcher) else { return false } 
                return true 
            case (.m_safeEqualityCheck__attribute_otherSampleas_as(let lhsAttribute, let lhsOthersample, let lhsAs), .m_safeEqualityCheck__attribute_otherSampleas_as(let rhsAttribute, let rhsOthersample, let rhsAs)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsOthersample, rhs: rhsOthersample, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher) else { return false } 
                return true 
            case (.m_matchesSearchString__searchString(let lhsSearchstring), .m_matchesSearchString__searchString(let rhsSearchstring)):
                guard Parameter.compare(lhs: lhsSearchstring, rhs: rhsSearchstring, with: matcher) else { return false } 
                return true 
            case (.p_minRating_get,.p_minRating_get): return true
			case (.p_minRating_set(let left),.p_minRating_set(let right)): return Parameter<Double>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_maxRating_get,.p_maxRating_get): return true
			case (.p_maxRating_set(let left),.p_maxRating_set(let right)): return Parameter<Double>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_rating_get,.p_rating_get): return true
			case (.p_rating_set(let left),.p_rating_set(let right)): return Parameter<Double>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_note_get,.p_note_get): return true
			case (.p_note_set(let left),.p_note_set(let right)): return Parameter<String?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_date_get,.p_date_get): return true
			case (.p_date_set(let left),.p_date_set(let right)): return Parameter<Date>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_attributedName_get,.p_attributedName_get): return true
            case (.p_attributes_get,.p_attributes_get): return true
            case (.p_debugDescription_get,.p_debugDescription_get): return true
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_setSource__source(p0): return p0.intValue
            case .m_attributeValuesAreValid: return 0
            case let .m_value__of_attribute(p0): return p0.intValue
            case let .m_set__attribute_attributeto_value(p0, p1): return p0.intValue + p1.intValue
            case let .m_equalTo__otherAttributed(p0): return p0.intValue
            case let .m_export__to_csv(p0): return p0.intValue
            case let .m_graphableValue__of_attribute(p0): return p0.intValue
            case .m_dates: return 0
            case let .m_equalTo__otherSample(p0): return p0.intValue
            case let .m_safeEqualityCheck__attribute_otherSampleas_as(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_matchesSearchString__searchString(p0): return p0.intValue
            case .p_minRating_get: return 0
			case .p_minRating_set(let newValue): return newValue.intValue
            case .p_maxRating_get: return 0
			case .p_maxRating_set(let newValue): return newValue.intValue
            case .p_rating_get: return 0
			case .p_rating_set(let newValue): return newValue.intValue
            case .p_note_get: return 0
			case .p_note_set(let newValue): return newValue.intValue
            case .p_date_get: return 0
			case .p_date_set(let newValue): return newValue.intValue
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

        public static func minRating(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_minRating_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func maxRating(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_maxRating_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func rating(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_rating_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func note(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_note_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func date(getter defaultValue: Date...) -> PropertyStub {
            return Given(method: .p_date_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func attributeValuesAreValid(willReturn: Bool...) -> MethodStub {
            return Given(method: .m_attributeValuesAreValid, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func value(of attribute: Parameter<Attribute>, willReturn: Any?...) -> MethodStub {
            return Given(method: .m_value__of_attribute(`attribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherAttributed: Parameter<Attributed>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherAttributed(`otherAttributed`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func graphableValue(of attribute: Parameter<Attribute>, willReturn: Any?...) -> MethodStub {
            return Given(method: .m_graphableValue__of_attribute(`attribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func dates(willReturn: [DateType: Date]...) -> MethodStub {
            return Given(method: .m_dates, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherSample: Parameter<Sample>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherSample(`otherSample`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func safeEqualityCheck<Type: Equatable>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as: Parameter<Type.Type>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_safeEqualityCheck__attribute_otherSampleas_as(`attribute`, `otherSample`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func matchesSearchString(_ searchString: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_matchesSearchString__searchString(`searchString`), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func dates(willProduce: (Stubber<[DateType: Date]>) -> Void) -> MethodStub {
            let willReturn: [[DateType: Date]] = []
			let given: Given = { return Given(method: .m_dates, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([DateType: Date]).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ otherSample: Parameter<Sample>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherSample(`otherSample`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func safeEqualityCheck<Type: Equatable>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as: Parameter<Type.Type>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_safeEqualityCheck__attribute_otherSampleas_as(`attribute`, `otherSample`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func matchesSearchString(_ searchString: Parameter<String>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_matchesSearchString__searchString(`searchString`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
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
        public static func export(to csv: Parameter<CSVWriter>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_export__to_csv(`csv`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func export(to csv: Parameter<CSVWriter>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_export__to_csv(`csv`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func graphableValue(of attribute: Parameter<Attribute>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_graphableValue__of_attribute(`attribute`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func graphableValue(of attribute: Parameter<Attribute>, willProduce: (StubberThrows<Any?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_graphableValue__of_attribute(`attribute`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Any?).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func setSource(_ source: Parameter<Sources.MoodSourceNum>) -> Verify { return Verify(method: .m_setSource__source(`source`))}
        public static func attributeValuesAreValid() -> Verify { return Verify(method: .m_attributeValuesAreValid)}
        public static func value(of attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_value__of_attribute(`attribute`))}
        public static func set(attribute: Parameter<Attribute>, to value: Parameter<Any?>) -> Verify { return Verify(method: .m_set__attribute_attributeto_value(`attribute`, `value`))}
        public static func equalTo(_ otherAttributed: Parameter<Attributed>) -> Verify { return Verify(method: .m_equalTo__otherAttributed(`otherAttributed`))}
        public static func export(to csv: Parameter<CSVWriter>) -> Verify { return Verify(method: .m_export__to_csv(`csv`))}
        public static func graphableValue(of attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_graphableValue__of_attribute(`attribute`))}
        public static func dates() -> Verify { return Verify(method: .m_dates)}
        public static func equalTo(_ otherSample: Parameter<Sample>) -> Verify { return Verify(method: .m_equalTo__otherSample(`otherSample`))}
        public static func safeEqualityCheck<Type>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as: Parameter<Type.Type>) -> Verify where Type:Equatable { return Verify(method: .m_safeEqualityCheck__attribute_otherSampleas_as(`attribute`, `otherSample`, `as`.wrapAsGeneric()))}
        public static func matchesSearchString(_ searchString: Parameter<String>) -> Verify { return Verify(method: .m_matchesSearchString__searchString(`searchString`))}
        public static var minRating: Verify { return Verify(method: .p_minRating_get) }
		public static func minRating(set newValue: Parameter<Double>) -> Verify { return Verify(method: .p_minRating_set(newValue)) }
        public static var maxRating: Verify { return Verify(method: .p_maxRating_get) }
		public static func maxRating(set newValue: Parameter<Double>) -> Verify { return Verify(method: .p_maxRating_set(newValue)) }
        public static var rating: Verify { return Verify(method: .p_rating_get) }
		public static func rating(set newValue: Parameter<Double>) -> Verify { return Verify(method: .p_rating_set(newValue)) }
        public static var note: Verify { return Verify(method: .p_note_get) }
		public static func note(set newValue: Parameter<String?>) -> Verify { return Verify(method: .p_note_set(newValue)) }
        public static var date: Verify { return Verify(method: .p_date_get) }
		public static func date(set newValue: Parameter<Date>) -> Verify { return Verify(method: .p_date_set(newValue)) }
        public static var attributedName: Verify { return Verify(method: .p_attributedName_get) }
        public static var attributes: Verify { return Verify(method: .p_attributes_get) }
        public static var debugDescription: Verify { return Verify(method: .p_debugDescription_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func setSource(_ source: Parameter<Sources.MoodSourceNum>, perform: @escaping (Sources.MoodSourceNum) -> Void) -> Perform {
            return Perform(method: .m_setSource__source(`source`), performs: perform)
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
        public static func export(to csv: Parameter<CSVWriter>, perform: @escaping (CSVWriter) -> Void) -> Perform {
            return Perform(method: .m_export__to_csv(`csv`), performs: perform)
        }
        public static func graphableValue(of attribute: Parameter<Attribute>, perform: @escaping (Attribute) -> Void) -> Perform {
            return Perform(method: .m_graphableValue__of_attribute(`attribute`), performs: perform)
        }
        public static func dates(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_dates, performs: perform)
        }
        public static func equalTo(_ otherSample: Parameter<Sample>, perform: @escaping (Sample) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherSample(`otherSample`), performs: perform)
        }
        public static func safeEqualityCheck<Type>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as: Parameter<Type.Type>, perform: @escaping (Attribute, Sample, Type.Type) -> Void) -> Perform where Type:Equatable {
            return Perform(method: .m_safeEqualityCheck__attribute_otherSampleas_as(`attribute`, `otherSample`, `as`.wrapAsGeneric()), performs: perform)
        }
        public static func matchesSearchString(_ searchString: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_matchesSearchString__searchString(`searchString`), performs: perform)
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
