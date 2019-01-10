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
@testable import Introspective

// sourcery: mock = "Mood"
class MoodMock: Mood, Mock {
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

    typealias PropertyStub = Given
    typealias MethodStub = Given
    typealias SubscriptStub = Given

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
    typealias StaticPropertyStub = StaticGiven
    typealias StaticMethodStub = StaticGiven
    static func clear() {
        invocations = []
        methodReturnValues = []
        methodPerformValues = []
    }


    var minRating: Double {
		get {	invocations.append(.p_minRating_get); return __p_minRating ?? givenGetterValue(.p_minRating_get, "MoodMock - stub value for minRating was not defined") }
		set {	invocations.append(.p_minRating_set(.value(newValue))); __p_minRating = newValue }
	}
	private var __p_minRating: (Double)?


    var maxRating: Double {
		get {	invocations.append(.p_maxRating_get); return __p_maxRating ?? givenGetterValue(.p_maxRating_get, "MoodMock - stub value for maxRating was not defined") }
		set {	invocations.append(.p_maxRating_set(.value(newValue))); __p_maxRating = newValue }
	}
	private var __p_maxRating: (Double)?


    var rating: Double {
		get {	invocations.append(.p_rating_get); return __p_rating ?? givenGetterValue(.p_rating_get, "MoodMock - stub value for rating was not defined") }
		set {	invocations.append(.p_rating_set(.value(newValue))); __p_rating = newValue }
	}
	private var __p_rating: (Double)?


    var note: String? {
		get {	invocations.append(.p_note_get); return __p_note ?? optionalGivenGetterValue(.p_note_get, "MoodMock - stub value for note was not defined") }
		set {	invocations.append(.p_note_set(.value(newValue))); __p_note = newValue }
	}
	private var __p_note: (String)?


    var timestamp: Date {
		get {	invocations.append(.p_timestamp_get); return __p_timestamp ?? givenGetterValue(.p_timestamp_get, "MoodMock - stub value for timestamp was not defined") }
		set {	invocations.append(.p_timestamp_set(.value(newValue))); __p_timestamp = newValue }
	}
	private var __p_timestamp: (Date)?


    var partOfCurrentImport: Bool {
		get {	invocations.append(.p_partOfCurrentImport_get); return __p_partOfCurrentImport ?? givenGetterValue(.p_partOfCurrentImport_get, "MoodMock - stub value for partOfCurrentImport was not defined") }
		set {	invocations.append(.p_partOfCurrentImport_set(.value(newValue))); __p_partOfCurrentImport = newValue }
	}
	private var __p_partOfCurrentImport: (Bool)?


    var attributedName: String {
		get {	invocations.append(.p_attributedName_get); return __p_attributedName ?? givenGetterValue(.p_attributedName_get, "MoodMock - stub value for attributedName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_attributedName = newValue }
	}
	private var __p_attributedName: (String)?


    var attributes: [Attribute] {
		get {	invocations.append(.p_attributes_get); return __p_attributes ?? givenGetterValue(.p_attributes_get, "MoodMock - stub value for attributes was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_attributes = newValue }
	}
	private var __p_attributes: ([Attribute])?


    var debugDescription: String {
		get {	invocations.append(.p_debugDescription_get); return __p_debugDescription ?? givenGetterValue(.p_debugDescription_get, "MoodMock - stub value for debugDescription was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_debugDescription = newValue }
	}
	private var __p_debugDescription: (String)?



    static var rating: DoubleAttribute {
		get {	MoodMock.invocations.append(.p_rating_get); return MoodMock.__p_rating ?? givenGetterValue(.p_rating_get, "MoodMock - stub value for rating was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_rating = newValue }
	}
	private static var __p_rating: (DoubleAttribute)?


    static var maxRating: DoubleAttribute {
		get {	MoodMock.invocations.append(.p_maxRating_get); return MoodMock.__p_maxRating ?? givenGetterValue(.p_maxRating_get, "MoodMock - stub value for maxRating was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_maxRating = newValue }
	}
	private static var __p_maxRating: (DoubleAttribute)?


    static var note: TextAttribute {
		get {	MoodMock.invocations.append(.p_note_get); return MoodMock.__p_note ?? givenGetterValue(.p_note_get, "MoodMock - stub value for note was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_note = newValue }
	}
	private static var __p_note: (TextAttribute)?


    static var entityName: String {
		get {	MoodMock.invocations.append(.p_entityName_get); return MoodMock.__p_entityName ?? givenGetterValue(.p_entityName_get, "MoodMock - stub value for entityName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_entityName = newValue }
	}
	private static var __p_entityName: (String)?


    static var name: String {
		get {	MoodMock.invocations.append(.p_name_get); return MoodMock.__p_name ?? givenGetterValue(.p_name_get, "MoodMock - stub value for name was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_name = newValue }
	}
	private static var __p_name: (String)?


    static var attributes: [Attribute] {
		get {	MoodMock.invocations.append(.p_attributes_get); return MoodMock.__p_attributes ?? givenGetterValue(.p_attributes_get, "MoodMock - stub value for attributes was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_attributes = newValue }
	}
	private static var __p_attributes: ([Attribute])?


    static var defaultDependentAttribute: Attribute {
		get {	MoodMock.invocations.append(.p_defaultDependentAttribute_get); return MoodMock.__p_defaultDependentAttribute ?? givenGetterValue(.p_defaultDependentAttribute_get, "MoodMock - stub value for defaultDependentAttribute was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_defaultDependentAttribute = newValue }
	}
	private static var __p_defaultDependentAttribute: (Attribute)?


    static var defaultIndependentAttribute: Attribute {
		get {	MoodMock.invocations.append(.p_defaultIndependentAttribute_get); return MoodMock.__p_defaultIndependentAttribute ?? givenGetterValue(.p_defaultIndependentAttribute_get, "MoodMock - stub value for defaultIndependentAttribute was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	MoodMock.__p_defaultIndependentAttribute = newValue }
	}
	private static var __p_defaultIndependentAttribute: (Attribute)?





    func setSource(_ source: Sources.MoodSourceNum) {
        addInvocation(.m_setSource__source(Parameter<Sources.MoodSourceNum>.value(`source`)))
		let perform = methodPerformValue(.m_setSource__source(Parameter<Sources.MoodSourceNum>.value(`source`))) as? (Sources.MoodSourceNum) -> Void
		perform?(`source`)
    }

    func value(of attribute: Attribute) throws -> Any? {
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

    func set(attribute: Attribute, to value: Any?) throws {
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

    func equalTo(_ otherAttributed: Attributed) -> Bool {
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

    func graphableValue(of attribute: Attribute) throws -> Any? {
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

    func dates() -> [DateType: Date] {
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

    func equalTo(_ otherSample: Sample) -> Bool {
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

    func safeEqualityCheck<Type: Equatable>(_ attribute: Attribute, _ otherSample: Sample, as type: Type.Type) -> Bool {
        addInvocation(.m_safeEqualityCheck__attribute_otherSampleas_type(Parameter<Attribute>.value(`attribute`), Parameter<Sample>.value(`otherSample`), Parameter<Type.Type>.value(`type`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_safeEqualityCheck__attribute_otherSampleas_type(Parameter<Attribute>.value(`attribute`), Parameter<Sample>.value(`otherSample`), Parameter<Type.Type>.value(`type`).wrapAsGeneric())) as? (Attribute, Sample, Type.Type) -> Void
		perform?(`attribute`, `otherSample`, `type`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_safeEqualityCheck__attribute_otherSampleas_type(Parameter<Attribute>.value(`attribute`), Parameter<Sample>.value(`otherSample`), Parameter<Type.Type>.value(`type`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for safeEqualityCheck<Type: Equatable>(_ attribute: Attribute, _ otherSample: Sample, as type: Type.Type). Use given")
			Failure("Stub return value not specified for safeEqualityCheck<Type: Equatable>(_ attribute: Attribute, _ otherSample: Sample, as type: Type.Type). Use given")
		}
		return __value
    }

    fileprivate enum StaticMethodType {
        case p_rating_get
        case p_maxRating_get
        case p_note_get
        case p_entityName_get
        case p_name_get
        case p_attributes_get
        case p_defaultDependentAttribute_get
        case p_defaultIndependentAttribute_get

        static func compareParameters(lhs: StaticMethodType, rhs: StaticMethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_rating_get,.p_rating_get): return true
            case (.p_maxRating_get,.p_maxRating_get): return true
            case (.p_note_get,.p_note_get): return true
            case (.p_entityName_get,.p_entityName_get): return true
            case (.p_name_get,.p_name_get): return true
            case (.p_attributes_get,.p_attributes_get): return true
            case (.p_defaultDependentAttribute_get,.p_defaultDependentAttribute_get): return true
            case (.p_defaultIndependentAttribute_get,.p_defaultIndependentAttribute_get): return true
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case .p_rating_get: return 0
                case .p_maxRating_get: return 0
                case .p_note_get: return 0
                case .p_entityName_get: return 0
                case .p_name_get: return 0
                case .p_attributes_get: return 0
                case .p_defaultDependentAttribute_get: return 0
                case .p_defaultIndependentAttribute_get: return 0
            }
        }
    }

    class StaticGiven: StubbedMethod {
        fileprivate var method: StaticMethodType

        private init(method: StaticMethodType, products: [Product]) {
            self.method = method
            super.init(products)
        }

        static func rating(getter defaultValue: DoubleAttribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_rating_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func maxRating(getter defaultValue: DoubleAttribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_maxRating_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func note(getter defaultValue: TextAttribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_note_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func entityName(getter defaultValue: String...) -> StaticPropertyStub {
            return StaticGiven(method: .p_entityName_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func name(getter defaultValue: String...) -> StaticPropertyStub {
            return StaticGiven(method: .p_name_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func attributes(getter defaultValue: [Attribute]...) -> StaticPropertyStub {
            return StaticGiven(method: .p_attributes_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func defaultDependentAttribute(getter defaultValue: Attribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_defaultDependentAttribute_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func defaultIndependentAttribute(getter defaultValue: Attribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_defaultIndependentAttribute_get, products: defaultValue.map({ Product.return($0) }))
        }

    }

    struct StaticVerify {
        fileprivate var method: StaticMethodType

        static var rating: StaticVerify { return StaticVerify(method: .p_rating_get) }
        static var maxRating: StaticVerify { return StaticVerify(method: .p_maxRating_get) }
        static var note: StaticVerify { return StaticVerify(method: .p_note_get) }
        static var entityName: StaticVerify { return StaticVerify(method: .p_entityName_get) }
        static var name: StaticVerify { return StaticVerify(method: .p_name_get) }
        static var attributes: StaticVerify { return StaticVerify(method: .p_attributes_get) }
        static var defaultDependentAttribute: StaticVerify { return StaticVerify(method: .p_defaultDependentAttribute_get) }
        static var defaultIndependentAttribute: StaticVerify { return StaticVerify(method: .p_defaultIndependentAttribute_get) }
    }

    struct StaticPerform {
        fileprivate var method: StaticMethodType
        var performs: Any

    }

    
    fileprivate enum MethodType {
        case m_setSource__source(Parameter<Sources.MoodSourceNum>)
        case m_value__of_attribute(Parameter<Attribute>)
        case m_set__attribute_attributeto_value(Parameter<Attribute>, Parameter<Any?>)
        case m_equalTo__otherAttributed(Parameter<Attributed>)
        case m_graphableValue__of_attribute(Parameter<Attribute>)
        case m_dates
        case m_equalTo__otherSample(Parameter<Sample>)
        case m_safeEqualityCheck__attribute_otherSampleas_type(Parameter<Attribute>, Parameter<Sample>, Parameter<GenericAttribute>)
        case p_minRating_get
		case p_minRating_set(Parameter<Double>)
        case p_maxRating_get
		case p_maxRating_set(Parameter<Double>)
        case p_rating_get
		case p_rating_set(Parameter<Double>)
        case p_note_get
		case p_note_set(Parameter<String?>)
        case p_timestamp_get
		case p_timestamp_set(Parameter<Date>)
        case p_partOfCurrentImport_get
		case p_partOfCurrentImport_set(Parameter<Bool>)
        case p_attributedName_get
        case p_attributes_get
        case p_debugDescription_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_setSource__source(let lhsSource), .m_setSource__source(let rhsSource)):
                guard Parameter.compare(lhs: lhsSource, rhs: rhsSource, with: matcher) else { return false } 
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
            case (.m_graphableValue__of_attribute(let lhsAttribute), .m_graphableValue__of_attribute(let rhsAttribute)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                return true 
            case (.m_dates, .m_dates):
                return true 
            case (.m_equalTo__otherSample(let lhsOthersample), .m_equalTo__otherSample(let rhsOthersample)):
                guard Parameter.compare(lhs: lhsOthersample, rhs: rhsOthersample, with: matcher) else { return false } 
                return true 
            case (.m_safeEqualityCheck__attribute_otherSampleas_type(let lhsAttribute, let lhsOthersample, let lhsType), .m_safeEqualityCheck__attribute_otherSampleas_type(let rhsAttribute, let rhsOthersample, let rhsType)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsOthersample, rhs: rhsOthersample, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher) else { return false } 
                return true 
            case (.p_minRating_get,.p_minRating_get): return true
			case (.p_minRating_set(let left),.p_minRating_set(let right)): return Parameter<Double>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_maxRating_get,.p_maxRating_get): return true
			case (.p_maxRating_set(let left),.p_maxRating_set(let right)): return Parameter<Double>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_rating_get,.p_rating_get): return true
			case (.p_rating_set(let left),.p_rating_set(let right)): return Parameter<Double>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_note_get,.p_note_get): return true
			case (.p_note_set(let left),.p_note_set(let right)): return Parameter<String?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_timestamp_get,.p_timestamp_get): return true
			case (.p_timestamp_set(let left),.p_timestamp_set(let right)): return Parameter<Date>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_partOfCurrentImport_get,.p_partOfCurrentImport_get): return true
			case (.p_partOfCurrentImport_set(let left),.p_partOfCurrentImport_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_attributedName_get,.p_attributedName_get): return true
            case (.p_attributes_get,.p_attributes_get): return true
            case (.p_debugDescription_get,.p_debugDescription_get): return true
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_setSource__source(p0): return p0.intValue
            case let .m_value__of_attribute(p0): return p0.intValue
            case let .m_set__attribute_attributeto_value(p0, p1): return p0.intValue + p1.intValue
            case let .m_equalTo__otherAttributed(p0): return p0.intValue
            case let .m_graphableValue__of_attribute(p0): return p0.intValue
            case .m_dates: return 0
            case let .m_equalTo__otherSample(p0): return p0.intValue
            case let .m_safeEqualityCheck__attribute_otherSampleas_type(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case .p_minRating_get: return 0
			case .p_minRating_set(let newValue): return newValue.intValue
            case .p_maxRating_get: return 0
			case .p_maxRating_set(let newValue): return newValue.intValue
            case .p_rating_get: return 0
			case .p_rating_set(let newValue): return newValue.intValue
            case .p_note_get: return 0
			case .p_note_set(let newValue): return newValue.intValue
            case .p_timestamp_get: return 0
			case .p_timestamp_set(let newValue): return newValue.intValue
            case .p_partOfCurrentImport_get: return 0
			case .p_partOfCurrentImport_set(let newValue): return newValue.intValue
            case .p_attributedName_get: return 0
            case .p_attributes_get: return 0
            case .p_debugDescription_get: return 0
            }
        }
    }

    class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [Product]) {
            self.method = method
            super.init(products)
        }

        static func minRating(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_minRating_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func maxRating(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_maxRating_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func rating(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_rating_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func note(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_note_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func timestamp(getter defaultValue: Date...) -> PropertyStub {
            return Given(method: .p_timestamp_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func partOfCurrentImport(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_partOfCurrentImport_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func attributedName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_attributedName_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func attributes(getter defaultValue: [Attribute]...) -> PropertyStub {
            return Given(method: .p_attributes_get, products: defaultValue.map({ Product.return($0) }))
        }
        static func debugDescription(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_debugDescription_get, products: defaultValue.map({ Product.return($0) }))
        }

        static func value(of attribute: Parameter<Attribute>, willReturn: Any?...) -> MethodStub {
            return Given(method: .m_value__of_attribute(`attribute`), products: willReturn.map({ Product.return($0) }))
        }
        static func equalTo(_ otherAttributed: Parameter<Attributed>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherAttributed(`otherAttributed`), products: willReturn.map({ Product.return($0) }))
        }
        @available(*, deprecated, message: "This constructor is deprecated, and will be removed in v3.1 Possible fix:  remove `otherAttributed` label")
		static func equalTo(otherAttributed: Parameter<Attributed>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherAttributed(`otherAttributed`), products: willReturn.map({ Product.return($0) }))
        }
        static func graphableValue(of attribute: Parameter<Attribute>, willReturn: Any?...) -> MethodStub {
            return Given(method: .m_graphableValue__of_attribute(`attribute`), products: willReturn.map({ Product.return($0) }))
        }
        static func dates(willReturn: [DateType: Date]...) -> MethodStub {
            return Given(method: .m_dates, products: willReturn.map({ Product.return($0) }))
        }
        static func equalTo(_ otherSample: Parameter<Sample>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherSample(`otherSample`), products: willReturn.map({ Product.return($0) }))
        }
        @available(*, deprecated, message: "This constructor is deprecated, and will be removed in v3.1 Possible fix:  remove `otherSample` label")
		static func equalTo(otherSample: Parameter<Sample>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherSample(`otherSample`), products: willReturn.map({ Product.return($0) }))
        }
        static func safeEqualityCheck<Type: Equatable>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as type: Parameter<Type.Type>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_safeEqualityCheck__attribute_otherSampleas_type(`attribute`, `otherSample`, `type`.wrapAsGeneric()), products: willReturn.map({ Product.return($0) }))
        }
        @available(*, deprecated, message: "This constructor is deprecated, and will be removed in v3.1 Possible fix:  remove `attribute` label, remove `otherSample` label")
		static func safeEqualityCheck<Type: Equatable>(attribute: Parameter<Attribute>, otherSample: Parameter<Sample>, as type: Parameter<Type.Type>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_safeEqualityCheck__attribute_otherSampleas_type(`attribute`, `otherSample`, `type`.wrapAsGeneric()), products: willReturn.map({ Product.return($0) }))
        }
        static func equalTo(_ otherAttributed: Parameter<Attributed>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherAttributed(`otherAttributed`), products: willReturn.map({ Product.return($0) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        static func dates(willProduce: (Stubber<[DateType: Date]>) -> Void) -> MethodStub {
            let willReturn: [[DateType: Date]] = []
			let given: Given = { return Given(method: .m_dates, products: willReturn.map({ Product.return($0) })) }()
			let stubber = given.stub(for: ([DateType: Date]).self)
			willProduce(stubber)
			return given
        }
        static func equalTo(_ otherSample: Parameter<Sample>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherSample(`otherSample`), products: willReturn.map({ Product.return($0) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        static func safeEqualityCheck<Type: Equatable>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as type: Parameter<Type.Type>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_safeEqualityCheck__attribute_otherSampleas_type(`attribute`, `otherSample`, `type`.wrapAsGeneric()), products: willReturn.map({ Product.return($0) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        static func value(of attribute: Parameter<Attribute>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_value__of_attribute(`attribute`), products: willThrow.map({ Product.throw($0) }))
        }
        static func value(of attribute: Parameter<Attribute>, willProduce: (StubberThrows<Any?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_value__of_attribute(`attribute`), products: willThrow.map({ Product.throw($0) })) }()
			let stubber = given.stubThrows(for: (Any?).self)
			willProduce(stubber)
			return given
        }
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_set__attribute_attributeto_value(`attribute`, `value`), products: willThrow.map({ Product.throw($0) }))
        }
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any?>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_set__attribute_attributeto_value(`attribute`, `value`), products: willThrow.map({ Product.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        static func graphableValue(of attribute: Parameter<Attribute>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_graphableValue__of_attribute(`attribute`), products: willThrow.map({ Product.throw($0) }))
        }
        static func graphableValue(of attribute: Parameter<Attribute>, willProduce: (StubberThrows<Any?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_graphableValue__of_attribute(`attribute`), products: willThrow.map({ Product.throw($0) })) }()
			let stubber = given.stubThrows(for: (Any?).self)
			willProduce(stubber)
			return given
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func setSource(_ source: Parameter<Sources.MoodSourceNum>) -> Verify { return Verify(method: .m_setSource__source(`source`))}
        @available(*, deprecated, message: "This constructor is deprecated, and will be removed in v3.1 Possible fix:  remove `source` label")
		static func setSource(source: Parameter<Sources.MoodSourceNum>) -> Verify { return Verify(method: .m_setSource__source(`source`))}
        static func value(of attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_value__of_attribute(`attribute`))}
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any?>) -> Verify { return Verify(method: .m_set__attribute_attributeto_value(`attribute`, `value`))}
        static func equalTo(_ otherAttributed: Parameter<Attributed>) -> Verify { return Verify(method: .m_equalTo__otherAttributed(`otherAttributed`))}
        @available(*, deprecated, message: "This constructor is deprecated, and will be removed in v3.1 Possible fix:  remove `otherAttributed` label")
		static func equalTo(otherAttributed: Parameter<Attributed>) -> Verify { return Verify(method: .m_equalTo__otherAttributed(`otherAttributed`))}
        static func graphableValue(of attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_graphableValue__of_attribute(`attribute`))}
        static func dates() -> Verify { return Verify(method: .m_dates)}
        static func equalTo(_ otherSample: Parameter<Sample>) -> Verify { return Verify(method: .m_equalTo__otherSample(`otherSample`))}
        @available(*, deprecated, message: "This constructor is deprecated, and will be removed in v3.1 Possible fix:  remove `otherSample` label")
		static func equalTo(otherSample: Parameter<Sample>) -> Verify { return Verify(method: .m_equalTo__otherSample(`otherSample`))}
        static func safeEqualityCheck<Type>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as type: Parameter<Type.Type>) -> Verify { return Verify(method: .m_safeEqualityCheck__attribute_otherSampleas_type(`attribute`, `otherSample`, `type`.wrapAsGeneric()))}
        @available(*, deprecated, message: "This constructor is deprecated, and will be removed in v3.1 Possible fix:  remove `attribute` label, remove `otherSample` label")
		static func safeEqualityCheck<Type>(attribute: Parameter<Attribute>, otherSample: Parameter<Sample>, as type: Parameter<Type.Type>) -> Verify { return Verify(method: .m_safeEqualityCheck__attribute_otherSampleas_type(`attribute`, `otherSample`, `type`.wrapAsGeneric()))}
        static var minRating: Verify { return Verify(method: .p_minRating_get) }
		static func minRating(set newValue: Parameter<Double>) -> Verify { return Verify(method: .p_minRating_set(newValue)) }
        static var maxRating: Verify { return Verify(method: .p_maxRating_get) }
		static func maxRating(set newValue: Parameter<Double>) -> Verify { return Verify(method: .p_maxRating_set(newValue)) }
        static var rating: Verify { return Verify(method: .p_rating_get) }
		static func rating(set newValue: Parameter<Double>) -> Verify { return Verify(method: .p_rating_set(newValue)) }
        static var note: Verify { return Verify(method: .p_note_get) }
		static func note(set newValue: Parameter<String?>) -> Verify { return Verify(method: .p_note_set(newValue)) }
        static var timestamp: Verify { return Verify(method: .p_timestamp_get) }
		static func timestamp(set newValue: Parameter<Date>) -> Verify { return Verify(method: .p_timestamp_set(newValue)) }
        static var partOfCurrentImport: Verify { return Verify(method: .p_partOfCurrentImport_get) }
		static func partOfCurrentImport(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_partOfCurrentImport_set(newValue)) }
        static var attributedName: Verify { return Verify(method: .p_attributedName_get) }
        static var attributes: Verify { return Verify(method: .p_attributes_get) }
        static var debugDescription: Verify { return Verify(method: .p_debugDescription_get) }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func setSource(_ source: Parameter<Sources.MoodSourceNum>, perform: @escaping (Sources.MoodSourceNum) -> Void) -> Perform {
            return Perform(method: .m_setSource__source(`source`), performs: perform)
        }
        @available(*, deprecated, message: "This constructor is deprecated, and will be removed in v3.1 Possible fix:  remove `source` label")
		static func setSource(source: Parameter<Sources.MoodSourceNum>, perform: @escaping (Sources.MoodSourceNum) -> Void) -> Perform {
            return Perform(method: .m_setSource__source(`source`), performs: perform)
        }
        static func value(of attribute: Parameter<Attribute>, perform: @escaping (Attribute) -> Void) -> Perform {
            return Perform(method: .m_value__of_attribute(`attribute`), performs: perform)
        }
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any?>, perform: @escaping (Attribute, Any?) -> Void) -> Perform {
            return Perform(method: .m_set__attribute_attributeto_value(`attribute`, `value`), performs: perform)
        }
        static func equalTo(_ otherAttributed: Parameter<Attributed>, perform: @escaping (Attributed) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherAttributed(`otherAttributed`), performs: perform)
        }
        @available(*, deprecated, message: "This constructor is deprecated, and will be removed in v3.1 Possible fix:  remove `otherAttributed` label")
		static func equalTo(otherAttributed: Parameter<Attributed>, perform: @escaping (Attributed) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherAttributed(`otherAttributed`), performs: perform)
        }
        static func graphableValue(of attribute: Parameter<Attribute>, perform: @escaping (Attribute) -> Void) -> Perform {
            return Perform(method: .m_graphableValue__of_attribute(`attribute`), performs: perform)
        }
        static func dates(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_dates, performs: perform)
        }
        static func equalTo(_ otherSample: Parameter<Sample>, perform: @escaping (Sample) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherSample(`otherSample`), performs: perform)
        }
        @available(*, deprecated, message: "This constructor is deprecated, and will be removed in v3.1 Possible fix:  remove `otherSample` label")
		static func equalTo(otherSample: Parameter<Sample>, perform: @escaping (Sample) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherSample(`otherSample`), performs: perform)
        }
        static func safeEqualityCheck<Type>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as type: Parameter<Type.Type>, perform: @escaping (Attribute, Sample, Type.Type) -> Void) -> Perform {
            return Perform(method: .m_safeEqualityCheck__attribute_otherSampleas_type(`attribute`, `otherSample`, `type`.wrapAsGeneric()), performs: perform)
        }
        @available(*, deprecated, message: "This constructor is deprecated, and will be removed in v3.1 Possible fix:  remove `attribute` label, remove `otherSample` label")
		static func safeEqualityCheck<Type>(attribute: Parameter<Attribute>, otherSample: Parameter<Sample>, as type: Parameter<Type.Type>, perform: @escaping (Attribute, Sample, Type.Type) -> Void) -> Perform {
            return Perform(method: .m_safeEqualityCheck__attribute_otherSampleas_type(`attribute`, `otherSample`, `type`.wrapAsGeneric()), performs: perform)
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
        MockyAssert(count.matches(invocations.count), "Expeced: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> Product {
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
        MockyAssert(count.matches(invocations.count), "Expeced: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    static private func addInvocation(_ call: StaticMethodType) {
        invocations.append(call)
    }
    static private func methodReturnValue(_ method: StaticMethodType) throws -> Product {
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
