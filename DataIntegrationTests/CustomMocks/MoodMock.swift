//
//  MoodMock.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import XCTest
import SwiftyMocky
@testable import DataIntegration

// sourcery: mock = "Mood"
class MoodMock: Mood, Mock {
	fileprivate var _description: String!

	var description: String {
		get { return _description }
		set { _description = newValue }
	}

// sourcery:inline:auto:MoodMock.autoMocked
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default
    static private var invocations: [StaticMethodType] = []
    static private var methodReturnValues: [StaticGiven] = []
    static private var methodPerformValues: [StaticPerform] = []
    static var matcher: Matcher = Matcher.default
    static func clear() {
        invocations = []
        methodReturnValues = []
        methodPerformValues = []
    }


    var maxRating: Double { 
		get {	invocations.append(.maxRating_get)
				return __maxRating.orFail("MoodMock - value for maxRating was not defined") }
		set {	invocations.append(.maxRating_set(.value(newValue)))
				__maxRating = newValue }
	}
	private var __maxRating: (Double)?


    var rating: Double { 
		get {	invocations.append(.rating_get)
				return __rating.orFail("MoodMock - value for rating was not defined") }
		set {	invocations.append(.rating_set(.value(newValue)))
				__rating = newValue }
	}
	private var __rating: (Double)?


    var note: String? { 
		get {	invocations.append(.note_get)
				return __note }
		set {	invocations.append(.note_set(.value(newValue)))
				__note = newValue }
	}
	private var __note: (String)?


    var timestamp: Date { 
		get {	invocations.append(.timestamp_get)
				return __timestamp.orFail("MoodMock - value for timestamp was not defined") }
		set {	invocations.append(.timestamp_set(.value(newValue)))
				__timestamp = newValue }
	}
	private var __timestamp: (Date)?


    var dataType: DataTypes { 
		get {	invocations.append(.dataType_get)
				return __dataType.orFail("MoodMock - value for dataType was not defined") }
		set {	invocations.append(.dataType_set(.value(newValue)))
				__dataType = newValue }
	}
	private var __dataType: (DataTypes)?


    var name: String { 
		get {	invocations.append(.name_get)
				return __name.orFail("MoodMock - value for name was not defined") }
		set {	invocations.append(.name_set(.value(newValue)))
				__name = newValue }
	}
	private var __name: (String)?


    var attributes: [Attribute] { 
		get {	invocations.append(.attributes_get)
				return __attributes.orFail("MoodMock - value for attributes was not defined") }
		set {	invocations.append(.attributes_set(.value(newValue)))
				__attributes = newValue }
	}
	private var __attributes: ([Attribute])?


    var debugDescription: String { 
		get {	invocations.append(.debugDescription_get)
				return __debugDescription.orFail("MoodMock - value for debugDescription was not defined") }
		set {	invocations.append(.debugDescription_set(.value(newValue)))
				__debugDescription = newValue }
	}
	private var __debugDescription: (String)?


    struct Property {
        fileprivate var method: MethodType
        static var maxRating: Property { return Property(method: .maxRating_get) }
		static func maxRating(set newValue: Parameter<Double>) -> Property { return Property(method: .maxRating_set(newValue)) }
        static var rating: Property { return Property(method: .rating_get) }
		static func rating(set newValue: Parameter<Double>) -> Property { return Property(method: .rating_set(newValue)) }
        static var note: Property { return Property(method: .note_get) }
		static func note(set newValue: Parameter<String?>) -> Property { return Property(method: .note_set(newValue)) }
        static var timestamp: Property { return Property(method: .timestamp_get) }
		static func timestamp(set newValue: Parameter<Date>) -> Property { return Property(method: .timestamp_set(newValue)) }
        static var dataType: Property { return Property(method: .dataType_get) }
		static func dataType(set newValue: Parameter<DataTypes>) -> Property { return Property(method: .dataType_set(newValue)) }
        static var name: Property { return Property(method: .name_get) }
		static func name(set newValue: Parameter<String>) -> Property { return Property(method: .name_set(newValue)) }
        static var attributes: Property { return Property(method: .attributes_get) }
		static func attributes(set newValue: Parameter<[Attribute]>) -> Property { return Property(method: .attributes_set(newValue)) }
        static var debugDescription: Property { return Property(method: .debugDescription_get) }
		static func debugDescription(set newValue: Parameter<String>) -> Property { return Property(method: .debugDescription_set(newValue)) }
    }

    static var maxRating: Double { 
		get {	MoodMock.invocations.append(.maxRating_get)
				return MoodMock.__maxRating.orFail("MoodMock - value for maxRating was not defined") }
		set {	MoodMock.invocations.append(.maxRating_set(.value(newValue)))
				MoodMock.__maxRating = newValue }
	}
	private static var __maxRating: (Double)?


    static var notRated: Double { 
		get {	MoodMock.invocations.append(.notRated_get)
				return MoodMock.__notRated.orFail("MoodMock - value for notRated was not defined") }
		set {	MoodMock.invocations.append(.notRated_set(.value(newValue)))
				MoodMock.__notRated = newValue }
	}
	private static var __notRated: (Double)?


    static var rating: DoubleAttribute { 
		get {	MoodMock.invocations.append(.rating_get)
				return MoodMock.__rating.orFail("MoodMock - value for rating was not defined") }
		set {	MoodMock.invocations.append(.rating_set(.value(newValue)))
				MoodMock.__rating = newValue }
	}
	private static var __rating: (DoubleAttribute)?


    static var note: TextAttribute { 
		get {	MoodMock.invocations.append(.note_get)
				return MoodMock.__note.orFail("MoodMock - value for note was not defined") }
		set {	MoodMock.invocations.append(.note_set(.value(newValue)))
				MoodMock.__note = newValue }
	}
	private static var __note: (TextAttribute)?


    static var entityName: String { 
		get {	MoodMock.invocations.append(.entityName_get)
				return MoodMock.__entityName.orFail("MoodMock - value for entityName was not defined") }
		set {	MoodMock.invocations.append(.entityName_set(.value(newValue)))
				MoodMock.__entityName = newValue }
	}
	private static var __entityName: (String)?


    struct StaticProperty {
        fileprivate var method: StaticMethodType
        static var maxRating: StaticProperty { return StaticProperty(method: .maxRating_get) }
		static func maxRating(set newValue: Parameter<Double>) -> StaticProperty { return StaticProperty(method: .maxRating_set(newValue)) }
        static var notRated: StaticProperty { return StaticProperty(method: .notRated_get) }
		static func notRated(set newValue: Parameter<Double>) -> StaticProperty { return StaticProperty(method: .notRated_set(newValue)) }
        static var rating: StaticProperty { return StaticProperty(method: .rating_get) }
		static func rating(set newValue: Parameter<DoubleAttribute>) -> StaticProperty { return StaticProperty(method: .rating_set(newValue)) }
        static var note: StaticProperty { return StaticProperty(method: .note_get) }
		static func note(set newValue: Parameter<TextAttribute>) -> StaticProperty { return StaticProperty(method: .note_set(newValue)) }
        static var entityName: StaticProperty { return StaticProperty(method: .entityName_get) }
		static func entityName(set newValue: Parameter<String>) -> StaticProperty { return StaticProperty(method: .entityName_set(newValue)) }
    }



    func dates() -> [DateType: Date] {
        addInvocation(.idates)
		let perform = methodPerformValue(.idates) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.idates)
		let value = givenValue.value as? [DateType: Date]
		return value.orFail("stub return value not specified for dates(). Use given")
    }

    func equalTo(_ otherSample: Sample) -> Bool {
        addInvocation(.iequalTo__otherSample(Parameter<Sample>.value(otherSample)))
		let perform = methodPerformValue(.iequalTo__otherSample(Parameter<Sample>.value(otherSample))) as? (Sample) -> Void
		perform?(otherSample)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iequalTo__otherSample(Parameter<Sample>.value(otherSample)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for equalTo(_ otherSample: Sample). Use given")
    }

    func value(of attribute: Attribute) throws -> Any {
        addInvocation(.ivalue__of_attribute(Parameter<Attribute>.value(attribute)))
		let perform = methodPerformValue(.ivalue__of_attribute(Parameter<Attribute>.value(attribute))) as? (Attribute) -> Void
		perform?(attribute)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.ivalue__of_attribute(Parameter<Attribute>.value(attribute)))
		if let error = givenValue.error { throw error }
		let value = givenValue.value as? Any
		return value.orFail("stub return value not specified for value(of attribute: Attribute). Use given")
    }

    func set(attribute: Attribute, to value: Any) throws {
        addInvocation(.iset__attribute_attributeto_value(Parameter<Attribute>.value(attribute), Parameter<Any>.value(value)))
		let perform = methodPerformValue(.iset__attribute_attributeto_value(Parameter<Attribute>.value(attribute), Parameter<Any>.value(value))) as? (Attribute, Any) -> Void
		perform?(attribute, value)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iset__attribute_attributeto_value(Parameter<Attribute>.value(attribute), Parameter<Any>.value(value)))
		if let error = givenValue.error { throw error }
    }

    func equalTo(_ otherAttributed: Attributed) -> Bool {
        addInvocation(.iequalTo__otherAttributed(Parameter<Attributed>.value(otherAttributed)))
		let perform = methodPerformValue(.iequalTo__otherAttributed(Parameter<Attributed>.value(otherAttributed))) as? (Attributed) -> Void
		perform?(otherAttributed)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iequalTo__otherAttributed(Parameter<Attributed>.value(otherAttributed)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for equalTo(_ otherAttributed: Attributed). Use given")
    }

    fileprivate enum StaticMethodType {

        case maxRating_get
		case maxRating_set(Parameter<Double>)
        case notRated_get
		case notRated_set(Parameter<Double>)
        case rating_get
		case rating_set(Parameter<DoubleAttribute>)
        case note_get
		case note_set(Parameter<TextAttribute>)
        case entityName_get
		case entityName_set(Parameter<String>)

        static func compareParameters(lhs: StaticMethodType, rhs: StaticMethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.maxRating_get,.maxRating_get): return true
				case (.maxRating_set(let left),.maxRating_set(let right)): return Parameter<Double>.compare(lhs: left, rhs: right, with: matcher)
                case (.notRated_get,.notRated_get): return true
				case (.notRated_set(let left),.notRated_set(let right)): return Parameter<Double>.compare(lhs: left, rhs: right, with: matcher)
                case (.rating_get,.rating_get): return true
				case (.rating_set(let left),.rating_set(let right)): return Parameter<DoubleAttribute>.compare(lhs: left, rhs: right, with: matcher)
                case (.note_get,.note_get): return true
				case (.note_set(let left),.note_set(let right)): return Parameter<TextAttribute>.compare(lhs: left, rhs: right, with: matcher)
                case (.entityName_get,.entityName_get): return true
				case (.entityName_set(let left),.entityName_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case .maxRating_get: return 0
				case .maxRating_set(let newValue): return newValue.intValue
                case .notRated_get: return 0
				case .notRated_set(let newValue): return newValue.intValue
                case .rating_get: return 0
				case .rating_set(let newValue): return newValue.intValue
                case .note_get: return 0
				case .note_set(let newValue): return newValue.intValue
                case .entityName_get: return 0
				case .entityName_set(let newValue): return newValue.intValue
            }
        }
    }

    struct StaticGiven {
        fileprivate var method: StaticMethodType
        var returns: Any?
        var `throws`: Error?

        private init(method: StaticMethodType, returns: Any?, throws: Error?) {
            self.method = method
            self.returns = returns
            self.`throws` = `throws`
        }

    }

    struct StaticVerify {
        fileprivate var method: StaticMethodType

    }

    struct StaticPerform {
        fileprivate var method: StaticMethodType
        var performs: Any

    }

        fileprivate enum MethodType {
        case idates
        case iequalTo__otherSample(Parameter<Sample>)
        case ivalue__of_attribute(Parameter<Attribute>)
        case iset__attribute_attributeto_value(Parameter<Attribute>, Parameter<Any>)
        case iequalTo__otherAttributed(Parameter<Attributed>)
        case maxRating_get
		case maxRating_set(Parameter<Double>)
        case rating_get
		case rating_set(Parameter<Double>)
        case note_get
		case note_set(Parameter<String?>)
        case timestamp_get
		case timestamp_set(Parameter<Date>)
        case dataType_get
		case dataType_set(Parameter<DataTypes>)
        case name_get
		case name_set(Parameter<String>)
        case attributes_get
		case attributes_set(Parameter<[Attribute]>)
        case debugDescription_get
		case debugDescription_set(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.idates, .idates):
                    return true 
                case (.iequalTo__otherSample(let lhsOthersample), .iequalTo__otherSample(let rhsOthersample)):
                    guard Parameter.compare(lhs: lhsOthersample, rhs: rhsOthersample, with: matcher) else { return false } 
                    return true 
                case (.ivalue__of_attribute(let lhsAttribute), .ivalue__of_attribute(let rhsAttribute)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    return true 
                case (.iset__attribute_attributeto_value(let lhsAttribute, let lhsValue), .iset__attribute_attributeto_value(let rhsAttribute, let rhsValue)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                    return true 
                case (.iequalTo__otherAttributed(let lhsOtherattributed), .iequalTo__otherAttributed(let rhsOtherattributed)):
                    guard Parameter.compare(lhs: lhsOtherattributed, rhs: rhsOtherattributed, with: matcher) else { return false } 
                    return true 
                case (.maxRating_get,.maxRating_get): return true
				case (.maxRating_set(let left),.maxRating_set(let right)): return Parameter<Double>.compare(lhs: left, rhs: right, with: matcher)
                case (.rating_get,.rating_get): return true
				case (.rating_set(let left),.rating_set(let right)): return Parameter<Double>.compare(lhs: left, rhs: right, with: matcher)
                case (.note_get,.note_get): return true
				case (.note_set(let left),.note_set(let right)): return Parameter<String?>.compare(lhs: left, rhs: right, with: matcher)
                case (.timestamp_get,.timestamp_get): return true
				case (.timestamp_set(let left),.timestamp_set(let right)): return Parameter<Date>.compare(lhs: left, rhs: right, with: matcher)
                case (.dataType_get,.dataType_get): return true
				case (.dataType_set(let left),.dataType_set(let right)): return Parameter<DataTypes>.compare(lhs: left, rhs: right, with: matcher)
                case (.name_get,.name_get): return true
				case (.name_set(let left),.name_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
                case (.attributes_get,.attributes_get): return true
				case (.attributes_set(let left),.attributes_set(let right)): return Parameter<[Attribute]>.compare(lhs: left, rhs: right, with: matcher)
                case (.debugDescription_get,.debugDescription_get): return true
				case (.debugDescription_set(let left),.debugDescription_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case .idates: return 0
                case let .iequalTo__otherSample(p0): return p0.intValue
                case let .ivalue__of_attribute(p0): return p0.intValue
                case let .iset__attribute_attributeto_value(p0, p1): return p0.intValue + p1.intValue
                case let .iequalTo__otherAttributed(p0): return p0.intValue
                case .maxRating_get: return 0
				case .maxRating_set(let newValue): return newValue.intValue
                case .rating_get: return 0
				case .rating_set(let newValue): return newValue.intValue
                case .note_get: return 0
				case .note_set(let newValue): return newValue.intValue
                case .timestamp_get: return 0
				case .timestamp_set(let newValue): return newValue.intValue
                case .dataType_get: return 0
				case .dataType_set(let newValue): return newValue.intValue
                case .name_get: return 0
				case .name_set(let newValue): return newValue.intValue
                case .attributes_get: return 0
				case .attributes_set(let newValue): return newValue.intValue
                case .debugDescription_get: return 0
				case .debugDescription_set(let newValue): return newValue.intValue
            }
        }
    }

    struct Given {
        fileprivate var method: MethodType
        var returns: Any?
        var `throws`: Error?

        private init(method: MethodType, returns: Any?, throws: Error?) {
            self.method = method
            self.returns = returns
            self.`throws` = `throws`
        }

        static func dates(willReturn: [DateType: Date]) -> Given {
            return Given(method: .idates, returns: willReturn, throws: nil)
        }
        static func equalTo(otherSample: Parameter<Sample>, willReturn: Bool) -> Given {
            return Given(method: .iequalTo__otherSample(otherSample), returns: willReturn, throws: nil)
        }
        static func value(of attribute: Parameter<Attribute>, willReturn: Any) -> Given {
            return Given(method: .ivalue__of_attribute(attribute), returns: willReturn, throws: nil)
        }
        static func equalTo(otherAttributed: Parameter<Attributed>, willReturn: Bool) -> Given {
            return Given(method: .iequalTo__otherAttributed(otherAttributed), returns: willReturn, throws: nil)
        }
        static func value(of attribute: Parameter<Attribute>, willThrow: Error) -> Given {
            return Given(method: .ivalue__of_attribute(attribute), returns: nil, throws: willThrow)
        }
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any>, willThrow: Error) -> Given {
            return Given(method: .iset__attribute_attributeto_value(attribute, value), returns: nil, throws: willThrow)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func dates() -> Verify {
            return Verify(method: .idates)
        }
        static func equalTo(otherSample: Parameter<Sample>) -> Verify {
            return Verify(method: .iequalTo__otherSample(otherSample))
        }
        static func value(of attribute: Parameter<Attribute>) -> Verify {
            return Verify(method: .ivalue__of_attribute(attribute))
        }
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any>) -> Verify {
            return Verify(method: .iset__attribute_attributeto_value(attribute, value))
        }
        static func equalTo(otherAttributed: Parameter<Attributed>) -> Verify {
            return Verify(method: .iequalTo__otherAttributed(otherAttributed))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func dates(perform: () -> Void) -> Perform {
            return Perform(method: .idates, performs: perform)
        }
        static func equalTo(otherSample: Parameter<Sample>, perform: (Sample) -> Void) -> Perform {
            return Perform(method: .iequalTo__otherSample(otherSample), performs: perform)
        }
        static func value(of attribute: Parameter<Attribute>, perform: (Attribute) -> Void) -> Perform {
            return Perform(method: .ivalue__of_attribute(attribute), performs: perform)
        }
        static func set(attribute: Parameter<Attribute>, to value: Parameter<Any>, perform: (Attribute, Any) -> Void) -> Perform {
            return Perform(method: .iset__attribute_attributeto_value(attribute, value), performs: perform)
        }
        static func equalTo(otherAttributed: Parameter<Attributed>, perform: (Attributed) -> Void) -> Perform {
            return Perform(method: .iequalTo__otherAttributed(otherAttributed), performs: perform)
        }
    }

    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
        methodReturnValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expeced: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(property.method)
        MockyAssert(count.matches(invocations.count), "Expeced: \(count) invocations of `\(property.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }

    private func methodReturnValue(_ method: MethodType) -> (value: Any?, error: Error?) {
        let matched = methodReturnValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher)  }
        return (value: matched?.returns, error: matched?.`throws`)
    }

    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }

    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }

    static private func matchingCalls(_ method: StaticVerify) -> Int {
        return matchingCalls(method.method).count
    }

    static public func given(_ method: StaticGiven) {
        methodReturnValues.append(method)
        methodReturnValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    static public func perform(_ method: StaticPerform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    static public func verify(_ method: StaticVerify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expeced: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    static public func verify(property: StaticProperty, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(property.method)
        MockyAssert(count.matches(invocations.count), "Expeced: \(count) invocations of `\(property.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    static private func addInvocation(_ call: StaticMethodType) {
        invocations.append(call)
    }

    static private func methodReturnValue(_ method: StaticMethodType) -> (value: Any?, error: Error?) {
        let matched = methodReturnValues.reversed().first { StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher)  }
        return (value: matched?.returns, error: matched?.`throws`)
    }

    static private func methodPerformValue(_ method: StaticMethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }

    static private func matchingCalls(_ method: StaticMethodType) -> [StaticMethodType] {
        return invocations.filter { StaticMethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
// sourcery:end
}