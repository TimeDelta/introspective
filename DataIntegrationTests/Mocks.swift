// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



//swiftlint:disable force_cast
//swiftlint:disable function_body_length
//swiftlint:disable line_length
//swiftlint:disable vertical_whitespace

#if MockyCustom
import SwiftyMocky
import HealthKit
@testable import DataIntegration

    public final class MockyAssertion {
        public static var handler: ((Bool, String, StaticString, UInt) -> Void)?
    }

    func MockyAssert(_ expression: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "Verification failed", file: StaticString = #file, line: UInt = #line) {
        guard let handler = MockyAssertion.handler else {
            assert(expression, message, file: file, line: line)
            return
        }

        handler(expression(), message(), file, line)
    }
#else
import SwiftyMocky
import XCTest
import HealthKit
@testable import DataIntegration

    func MockyAssert(_ expression: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "Verification failed", file: StaticString = #file, line: UInt = #line) {
        XCTAssert(expression(), message(), file: file, line: line)
    }
#endif

// MARK: - Attribute
class AttributeMock: Attribute, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default

    var name: String { 
		get {	invocations.append(.name_get)
				return __name.orFail("AttributeMock - value for name was not defined") }
		set {	invocations.append(.name_set(.value(newValue)))
				__name = newValue }
	}
	private var __name: (String)?
    var pluralName: String { 
		get {	invocations.append(.pluralName_get)
				return __pluralName.orFail("AttributeMock - value for pluralName was not defined") }
		set {	invocations.append(.pluralName_set(.value(newValue)))
				__pluralName = newValue }
	}
	private var __pluralName: (String)?
    var variableName: String { 
		get {	invocations.append(.variableName_get)
				return __variableName.orFail("AttributeMock - value for variableName was not defined") }
		set {	invocations.append(.variableName_set(.value(newValue)))
				__variableName = newValue }
	}
	private var __variableName: (String)?
    var extendedDescription: String? { 
		get {	invocations.append(.extendedDescription_get)
				return __extendedDescription }
		set {	invocations.append(.extendedDescription_set(.value(newValue)))
				__extendedDescription = newValue }
	}
	private var __extendedDescription: (String)?

    struct Property {
        fileprivate var method: MethodType
        static var name: Property { return Property(method: .name_get) }
		static func name(set newValue: Parameter<String>) -> Property { return Property(method: .name_set(newValue)) }
        static var pluralName: Property { return Property(method: .pluralName_get) }
		static func pluralName(set newValue: Parameter<String>) -> Property { return Property(method: .pluralName_set(newValue)) }
        static var variableName: Property { return Property(method: .variableName_get) }
		static func variableName(set newValue: Parameter<String>) -> Property { return Property(method: .variableName_set(newValue)) }
        static var extendedDescription: Property { return Property(method: .extendedDescription_get) }
		static func extendedDescription(set newValue: Parameter<String?>) -> Property { return Property(method: .extendedDescription_set(newValue)) }
    }


    required init(name: String, pluralName: String?, description: String?, variableName: String?) { }

    func isValid(value: String) -> Bool {
        addInvocation(.iisValid__value_value(Parameter<String>.value(value)))
		let perform = methodPerformValue(.iisValid__value_value(Parameter<String>.value(value))) as? (String) -> Void
		perform?(value)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iisValid__value_value(Parameter<String>.value(value)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for isValid(value: String). Use given")
    }

    func errorMessageFor(invalidValue: String) -> String {
        addInvocation(.ierrorMessageFor__invalidValue_invalidValue(Parameter<String>.value(invalidValue)))
		let perform = methodPerformValue(.ierrorMessageFor__invalidValue_invalidValue(Parameter<String>.value(invalidValue))) as? (String) -> Void
		perform?(invalidValue)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.ierrorMessageFor__invalidValue_invalidValue(Parameter<String>.value(invalidValue)))
		let value = givenValue.value as? String
		return value.orFail("stub return value not specified for errorMessageFor(invalidValue: String). Use given")
    }

    func convertToValue(from strValue: String) throws -> Any {
        addInvocation(.iconvertToValue__from_strValue(Parameter<String>.value(strValue)))
		let perform = methodPerformValue(.iconvertToValue__from_strValue(Parameter<String>.value(strValue))) as? (String) -> Void
		perform?(strValue)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iconvertToValue__from_strValue(Parameter<String>.value(strValue)))
		if let error = givenValue.error { throw error }
		let value = givenValue.value as? Any
		return value.orFail("stub return value not specified for convertToValue(from strValue: String). Use given")
    }

    func convertToString(from value: Any) throws -> String {
        addInvocation(.iconvertToString__from_value(Parameter<Any>.value(value)))
		let perform = methodPerformValue(.iconvertToString__from_value(Parameter<Any>.value(value))) as? (Any) -> Void
		perform?(value)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iconvertToString__from_value(Parameter<Any>.value(value)))
		if let error = givenValue.error { throw error }
		let value = givenValue.value as? String
		return value.orFail("stub return value not specified for convertToString(from value: Any). Use given")
    }

    func convertToDisplayableString(from value: Any) throws -> String {
        addInvocation(.iconvertToDisplayableString__from_value(Parameter<Any>.value(value)))
		let perform = methodPerformValue(.iconvertToDisplayableString__from_value(Parameter<Any>.value(value))) as? (Any) -> Void
		perform?(value)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iconvertToDisplayableString__from_value(Parameter<Any>.value(value)))
		if let error = givenValue.error { throw error }
		let value = givenValue.value as? String
		return value.orFail("stub return value not specified for convertToDisplayableString(from value: Any). Use given")
    }

    func equalTo(_ otherAttribute: Attribute) -> Bool {
        addInvocation(.iequalTo__otherAttribute(Parameter<Attribute>.value(otherAttribute)))
		let perform = methodPerformValue(.iequalTo__otherAttribute(Parameter<Attribute>.value(otherAttribute))) as? (Attribute) -> Void
		perform?(otherAttribute)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iequalTo__otherAttribute(Parameter<Attribute>.value(otherAttribute)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for equalTo(_ otherAttribute: Attribute). Use given")
    }

    fileprivate enum MethodType {
        case iisValid__value_value(Parameter<String>)
        case ierrorMessageFor__invalidValue_invalidValue(Parameter<String>)
        case iconvertToValue__from_strValue(Parameter<String>)
        case iconvertToString__from_value(Parameter<Any>)
        case iconvertToDisplayableString__from_value(Parameter<Any>)
        case iequalTo__otherAttribute(Parameter<Attribute>)
        case name_get
		case name_set(Parameter<String>)
        case pluralName_get
		case pluralName_set(Parameter<String>)
        case variableName_get
		case variableName_set(Parameter<String>)
        case extendedDescription_get
		case extendedDescription_set(Parameter<String?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.iisValid__value_value(let lhsValue), .iisValid__value_value(let rhsValue)):
                    guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                    return true 
                case (.ierrorMessageFor__invalidValue_invalidValue(let lhsInvalidvalue), .ierrorMessageFor__invalidValue_invalidValue(let rhsInvalidvalue)):
                    guard Parameter.compare(lhs: lhsInvalidvalue, rhs: rhsInvalidvalue, with: matcher) else { return false } 
                    return true 
                case (.iconvertToValue__from_strValue(let lhsStrvalue), .iconvertToValue__from_strValue(let rhsStrvalue)):
                    guard Parameter.compare(lhs: lhsStrvalue, rhs: rhsStrvalue, with: matcher) else { return false } 
                    return true 
                case (.iconvertToString__from_value(let lhsValue), .iconvertToString__from_value(let rhsValue)):
                    guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                    return true 
                case (.iconvertToDisplayableString__from_value(let lhsValue), .iconvertToDisplayableString__from_value(let rhsValue)):
                    guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                    return true 
                case (.iequalTo__otherAttribute(let lhsOtherattribute), .iequalTo__otherAttribute(let rhsOtherattribute)):
                    guard Parameter.compare(lhs: lhsOtherattribute, rhs: rhsOtherattribute, with: matcher) else { return false } 
                    return true 
                case (.name_get,.name_get): return true
				case (.name_set(let left),.name_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
                case (.pluralName_get,.pluralName_get): return true
				case (.pluralName_set(let left),.pluralName_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
                case (.variableName_get,.variableName_get): return true
				case (.variableName_set(let left),.variableName_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
                case (.extendedDescription_get,.extendedDescription_get): return true
				case (.extendedDescription_set(let left),.extendedDescription_set(let right)): return Parameter<String?>.compare(lhs: left, rhs: right, with: matcher)
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .iisValid__value_value(p0): return p0.intValue
                case let .ierrorMessageFor__invalidValue_invalidValue(p0): return p0.intValue
                case let .iconvertToValue__from_strValue(p0): return p0.intValue
                case let .iconvertToString__from_value(p0): return p0.intValue
                case let .iconvertToDisplayableString__from_value(p0): return p0.intValue
                case let .iequalTo__otherAttribute(p0): return p0.intValue
                case .name_get: return 0
				case .name_set(let newValue): return newValue.intValue
                case .pluralName_get: return 0
				case .pluralName_set(let newValue): return newValue.intValue
                case .variableName_get: return 0
				case .variableName_set(let newValue): return newValue.intValue
                case .extendedDescription_get: return 0
				case .extendedDescription_set(let newValue): return newValue.intValue
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

        static func isValid(value: Parameter<String>, willReturn: Bool) -> Given {
            return Given(method: .iisValid__value_value(value), returns: willReturn, throws: nil)
        }
        static func errorMessageFor(invalidValue: Parameter<String>, willReturn: String) -> Given {
            return Given(method: .ierrorMessageFor__invalidValue_invalidValue(invalidValue), returns: willReturn, throws: nil)
        }
        static func convertToValue(from strValue: Parameter<String>, willReturn: Any) -> Given {
            return Given(method: .iconvertToValue__from_strValue(strValue), returns: willReturn, throws: nil)
        }
        static func convertToString(from value: Parameter<Any>, willReturn: String) -> Given {
            return Given(method: .iconvertToString__from_value(value), returns: willReturn, throws: nil)
        }
        static func convertToDisplayableString(from value: Parameter<Any>, willReturn: String) -> Given {
            return Given(method: .iconvertToDisplayableString__from_value(value), returns: willReturn, throws: nil)
        }
        static func equalTo(otherAttribute: Parameter<Attribute>, willReturn: Bool) -> Given {
            return Given(method: .iequalTo__otherAttribute(otherAttribute), returns: willReturn, throws: nil)
        }
        static func convertToValue(from strValue: Parameter<String>, willThrow: Error) -> Given {
            return Given(method: .iconvertToValue__from_strValue(strValue), returns: nil, throws: willThrow)
        }
        static func convertToString(from value: Parameter<Any>, willThrow: Error) -> Given {
            return Given(method: .iconvertToString__from_value(value), returns: nil, throws: willThrow)
        }
        static func convertToDisplayableString(from value: Parameter<Any>, willThrow: Error) -> Given {
            return Given(method: .iconvertToDisplayableString__from_value(value), returns: nil, throws: willThrow)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func isValid(value: Parameter<String>) -> Verify {
            return Verify(method: .iisValid__value_value(value))
        }
        static func errorMessageFor(invalidValue: Parameter<String>) -> Verify {
            return Verify(method: .ierrorMessageFor__invalidValue_invalidValue(invalidValue))
        }
        static func convertToValue(from strValue: Parameter<String>) -> Verify {
            return Verify(method: .iconvertToValue__from_strValue(strValue))
        }
        static func convertToString(from value: Parameter<Any>) -> Verify {
            return Verify(method: .iconvertToString__from_value(value))
        }
        static func convertToDisplayableString(from value: Parameter<Any>) -> Verify {
            return Verify(method: .iconvertToDisplayableString__from_value(value))
        }
        static func equalTo(otherAttribute: Parameter<Attribute>) -> Verify {
            return Verify(method: .iequalTo__otherAttribute(otherAttribute))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func isValid(value: Parameter<String>, perform: (String) -> Void) -> Perform {
            return Perform(method: .iisValid__value_value(value), performs: perform)
        }
        static func errorMessageFor(invalidValue: Parameter<String>, perform: (String) -> Void) -> Perform {
            return Perform(method: .ierrorMessageFor__invalidValue_invalidValue(invalidValue), performs: perform)
        }
        static func convertToValue(from strValue: Parameter<String>, perform: (String) -> Void) -> Perform {
            return Perform(method: .iconvertToValue__from_strValue(strValue), performs: perform)
        }
        static func convertToString(from value: Parameter<Any>, perform: (Any) -> Void) -> Perform {
            return Perform(method: .iconvertToString__from_value(value), performs: perform)
        }
        static func convertToDisplayableString(from value: Parameter<Any>, perform: (Any) -> Void) -> Perform {
            return Perform(method: .iconvertToDisplayableString__from_value(value), performs: perform)
        }
        static func equalTo(otherAttribute: Parameter<Attribute>, perform: (Attribute) -> Void) -> Perform {
            return Perform(method: .iequalTo__otherAttribute(otherAttribute), performs: perform)
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
}

// MARK: - AttributeFactory
class AttributeFactoryMock: AttributeFactory, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never



    fileprivate struct MethodType {
        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool { return true }
        func intValue() -> Int { return 0 }
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

    }

    struct Verify {
        fileprivate var method: MethodType

    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - AttributeRestrictionFactory
class AttributeRestrictionFactoryMock: AttributeRestrictionFactory, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func initialize(type: AttributeRestriction.Type, forAttribute attribute: Attribute) -> AttributeRestriction {
        addInvocation(.iinitialize__type_typeforAttribute_attribute(Parameter<AttributeRestriction.Type>.value(type), Parameter<Attribute>.value(attribute)))
		let perform = methodPerformValue(.iinitialize__type_typeforAttribute_attribute(Parameter<AttributeRestriction.Type>.value(type), Parameter<Attribute>.value(attribute))) as? (AttributeRestriction.Type, Attribute) -> Void
		perform?(type, attribute)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iinitialize__type_typeforAttribute_attribute(Parameter<AttributeRestriction.Type>.value(type), Parameter<Attribute>.value(attribute)))
		let value = givenValue.value as? AttributeRestriction
		return value.orFail("stub return value not specified for initialize(type: AttributeRestriction.Type, forAttribute attribute: Attribute). Use given")
    }

    fileprivate enum MethodType {
        case iinitialize__type_typeforAttribute_attribute(Parameter<AttributeRestriction.Type>, Parameter<Attribute>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.iinitialize__type_typeforAttribute_attribute(let lhsType, let lhsAttribute), .iinitialize__type_typeforAttribute_attribute(let rhsType, let rhsAttribute)):
                    guard Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    return true 
            }
        }

        func intValue() -> Int {
            switch self {
                case let .iinitialize__type_typeforAttribute_attribute(p0, p1): return p0.intValue + p1.intValue
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

        static func initialize(type: Parameter<AttributeRestriction.Type>, forAttribute attribute: Parameter<Attribute>, willReturn: AttributeRestriction) -> Given {
            return Given(method: .iinitialize__type_typeforAttribute_attribute(type, attribute), returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func initialize(type: Parameter<AttributeRestriction.Type>, forAttribute attribute: Parameter<Attribute>) -> Verify {
            return Verify(method: .iinitialize__type_typeforAttribute_attribute(type, attribute))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func initialize(type: Parameter<AttributeRestriction.Type>, forAttribute attribute: Parameter<Attribute>, perform: (AttributeRestriction.Type, Attribute) -> Void) -> Perform {
            return Perform(method: .iinitialize__type_typeforAttribute_attribute(type, attribute), performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - AttributeRestrictionUtil
class AttributeRestrictionUtilMock: AttributeRestrictionUtil, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func getMostRestrictiveStartAndEndDates(from attributeRestrictions: [AttributeRestriction]) -> (start: Date?, end: Date?) {
        addInvocation(.igetMostRestrictiveStartAndEndDates__from_attributeRestrictions(Parameter<[AttributeRestriction]>.value(attributeRestrictions)))
		let perform = methodPerformValue(.igetMostRestrictiveStartAndEndDates__from_attributeRestrictions(Parameter<[AttributeRestriction]>.value(attributeRestrictions))) as? ([AttributeRestriction]) -> Void
		perform?(attributeRestrictions)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.igetMostRestrictiveStartAndEndDates__from_attributeRestrictions(Parameter<[AttributeRestriction]>.value(attributeRestrictions)))
		let value = givenValue.value as? (start: Date?, end: Date?)
		return value.orFail("stub return value not specified for getMostRestrictiveStartAndEndDates(from attributeRestrictions: [AttributeRestriction]). Use given")
    }

    func getDaysOfWeekFrom(attributeRestrictions: [AttributeRestriction]) -> Set<DayOfWeek> {
        addInvocation(.igetDaysOfWeekFrom__attributeRestrictions_attributeRestrictions(Parameter<[AttributeRestriction]>.value(attributeRestrictions)))
		let perform = methodPerformValue(.igetDaysOfWeekFrom__attributeRestrictions_attributeRestrictions(Parameter<[AttributeRestriction]>.value(attributeRestrictions))) as? ([AttributeRestriction]) -> Void
		perform?(attributeRestrictions)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.igetDaysOfWeekFrom__attributeRestrictions_attributeRestrictions(Parameter<[AttributeRestriction]>.value(attributeRestrictions)))
		let value = givenValue.value as? Set<DayOfWeek>
		return value.orFail("stub return value not specified for getDaysOfWeekFrom(attributeRestrictions: [AttributeRestriction]). Use given")
    }

    fileprivate enum MethodType {
        case igetMostRestrictiveStartAndEndDates__from_attributeRestrictions(Parameter<[AttributeRestriction]>)
        case igetDaysOfWeekFrom__attributeRestrictions_attributeRestrictions(Parameter<[AttributeRestriction]>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.igetMostRestrictiveStartAndEndDates__from_attributeRestrictions(let lhsAttributerestrictions), .igetMostRestrictiveStartAndEndDates__from_attributeRestrictions(let rhsAttributerestrictions)):
                    guard Parameter.compare(lhs: lhsAttributerestrictions, rhs: rhsAttributerestrictions, with: matcher) else { return false } 
                    return true 
                case (.igetDaysOfWeekFrom__attributeRestrictions_attributeRestrictions(let lhsAttributerestrictions), .igetDaysOfWeekFrom__attributeRestrictions_attributeRestrictions(let rhsAttributerestrictions)):
                    guard Parameter.compare(lhs: lhsAttributerestrictions, rhs: rhsAttributerestrictions, with: matcher) else { return false } 
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .igetMostRestrictiveStartAndEndDates__from_attributeRestrictions(p0): return p0.intValue
                case let .igetDaysOfWeekFrom__attributeRestrictions_attributeRestrictions(p0): return p0.intValue
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

        static func getMostRestrictiveStartAndEndDates(from attributeRestrictions: Parameter<[AttributeRestriction]>, willReturn: (start: Date?, end: Date?)) -> Given {
            return Given(method: .igetMostRestrictiveStartAndEndDates__from_attributeRestrictions(attributeRestrictions), returns: willReturn, throws: nil)
        }
        static func getDaysOfWeekFrom(attributeRestrictions: Parameter<[AttributeRestriction]>, willReturn: Set<DayOfWeek>) -> Given {
            return Given(method: .igetDaysOfWeekFrom__attributeRestrictions_attributeRestrictions(attributeRestrictions), returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func getMostRestrictiveStartAndEndDates(from attributeRestrictions: Parameter<[AttributeRestriction]>) -> Verify {
            return Verify(method: .igetMostRestrictiveStartAndEndDates__from_attributeRestrictions(attributeRestrictions))
        }
        static func getDaysOfWeekFrom(attributeRestrictions: Parameter<[AttributeRestriction]>) -> Verify {
            return Verify(method: .igetDaysOfWeekFrom__attributeRestrictions_attributeRestrictions(attributeRestrictions))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func getMostRestrictiveStartAndEndDates(from attributeRestrictions: Parameter<[AttributeRestriction]>, perform: ([AttributeRestriction]) -> Void) -> Perform {
            return Perform(method: .igetMostRestrictiveStartAndEndDates__from_attributeRestrictions(attributeRestrictions), performs: perform)
        }
        static func getDaysOfWeekFrom(attributeRestrictions: Parameter<[AttributeRestriction]>, perform: ([AttributeRestriction]) -> Void) -> Perform {
            return Perform(method: .igetDaysOfWeekFrom__attributeRestrictions_attributeRestrictions(attributeRestrictions), performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - CalendarUtil
class CalendarUtilMock: CalendarUtil, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func start(of component: Calendar.Component, in date: Date) -> Date {
        addInvocation(.istart__of_componentin_date(Parameter<Calendar.Component>.value(component), Parameter<Date>.value(date)))
		let perform = methodPerformValue(.istart__of_componentin_date(Parameter<Calendar.Component>.value(component), Parameter<Date>.value(date))) as? (Calendar.Component, Date) -> Void
		perform?(component, date)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.istart__of_componentin_date(Parameter<Calendar.Component>.value(component), Parameter<Date>.value(date)))
		let value = givenValue.value as? Date
		return value.orFail("stub return value not specified for start(of component: Calendar.Component, in date: Date). Use given")
    }

    func end(of component: Calendar.Component, in date: Date) -> Date {
        addInvocation(.iend__of_componentin_date(Parameter<Calendar.Component>.value(component), Parameter<Date>.value(date)))
		let perform = methodPerformValue(.iend__of_componentin_date(Parameter<Calendar.Component>.value(component), Parameter<Date>.value(date))) as? (Calendar.Component, Date) -> Void
		perform?(component, date)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iend__of_componentin_date(Parameter<Calendar.Component>.value(component), Parameter<Date>.value(date)))
		let value = givenValue.value as? Date
		return value.orFail("stub return value not specified for end(of component: Calendar.Component, in date: Date). Use given")
    }

    func string(for date: Date, inFormat format: String) -> String {
        addInvocation(.istring__for_dateinFormat_format(Parameter<Date>.value(date), Parameter<String>.value(format)))
		let perform = methodPerformValue(.istring__for_dateinFormat_format(Parameter<Date>.value(date), Parameter<String>.value(format))) as? (Date, String) -> Void
		perform?(date, format)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.istring__for_dateinFormat_format(Parameter<Date>.value(date), Parameter<String>.value(format)))
		let value = givenValue.value as? String
		return value.orFail("stub return value not specified for string(for date: Date, inFormat format: String). Use given")
    }

    func date(_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date) -> Bool {
        addInvocation(.idate__date1occursOnSame_componentas_date2(Parameter<Date>.value(date1), Parameter<Calendar.Component>.value(component), Parameter<Date>.value(date2)))
		let perform = methodPerformValue(.idate__date1occursOnSame_componentas_date2(Parameter<Date>.value(date1), Parameter<Calendar.Component>.value(component), Parameter<Date>.value(date2))) as? (Date, Calendar.Component, Date) -> Void
		perform?(date1, component, date2)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.idate__date1occursOnSame_componentas_date2(Parameter<Date>.value(date1), Parameter<Calendar.Component>.value(component), Parameter<Date>.value(date2)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for date(_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date). Use given")
    }

    func compare(_ date1: Date?, _ date2: Date?) -> ComparisonResult {
        addInvocation(.icompare__date1_date2(Parameter<Date?>.value(date1), Parameter<Date?>.value(date2)))
		let perform = methodPerformValue(.icompare__date1_date2(Parameter<Date?>.value(date1), Parameter<Date?>.value(date2))) as? (Date?, Date?) -> Void
		perform?(date1, date2)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.icompare__date1_date2(Parameter<Date?>.value(date1), Parameter<Date?>.value(date2)))
		let value = givenValue.value as? ComparisonResult
		return value.orFail("stub return value not specified for compare(_ date1: Date?, _ date2: Date?). Use given")
    }

    func date<CollectionType: Collection>(_ date: Date, isOnOneOf daysOfWeek: CollectionType) -> Bool where CollectionType.Element == DayOfWeek {
        addInvocation(.idate__dateisOnOneOf_daysOfWeek(Parameter<Date>.value(date), Parameter<CollectionType>.value(daysOfWeek).wrapAsGeneric()))
		let perform = methodPerformValue(.idate__dateisOnOneOf_daysOfWeek(Parameter<Date>.value(date), Parameter<CollectionType>.value(daysOfWeek).wrapAsGeneric())) as? (Date, CollectionType) -> Void
		perform?(date, daysOfWeek)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.idate__dateisOnOneOf_daysOfWeek(Parameter<Date>.value(date), Parameter<CollectionType>.value(daysOfWeek).wrapAsGeneric()))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for date<CollectionType: Collection>(_ date: Date, isOnOneOf daysOfWeek: CollectionType). Use given")
    }

    func date(_ date: Date, isOnA dayOfWeek: DayOfWeek) -> Bool {
        addInvocation(.idate__dateisOnA_dayOfWeek(Parameter<Date>.value(date), Parameter<DayOfWeek>.value(dayOfWeek)))
		let perform = methodPerformValue(.idate__dateisOnA_dayOfWeek(Parameter<Date>.value(date), Parameter<DayOfWeek>.value(dayOfWeek))) as? (Date, DayOfWeek) -> Void
		perform?(date, dayOfWeek)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.idate__dateisOnA_dayOfWeek(Parameter<Date>.value(date), Parameter<DayOfWeek>.value(dayOfWeek)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for date(_ date: Date, isOnA dayOfWeek: DayOfWeek). Use given")
    }

    func date(from dateStr: String, format: String) -> Date? {
        addInvocation(.idate__from_dateStrformat_format(Parameter<String>.value(dateStr), Parameter<String>.value(format)))
		let perform = methodPerformValue(.idate__from_dateStrformat_format(Parameter<String>.value(dateStr), Parameter<String>.value(format))) as? (String, String) -> Void
		perform?(dateStr, format)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.idate__from_dateStrformat_format(Parameter<String>.value(dateStr), Parameter<String>.value(format)))
		let value = givenValue.value as? Date?
		return value.orFail("stub return value not specified for date(from dateStr: String, format: String). Use given")
    }

    fileprivate enum MethodType {
        case istart__of_componentin_date(Parameter<Calendar.Component>, Parameter<Date>)
        case iend__of_componentin_date(Parameter<Calendar.Component>, Parameter<Date>)
        case istring__for_dateinFormat_format(Parameter<Date>, Parameter<String>)
        case idate__date1occursOnSame_componentas_date2(Parameter<Date>, Parameter<Calendar.Component>, Parameter<Date>)
        case icompare__date1_date2(Parameter<Date?>, Parameter<Date?>)
        case idate__dateisOnOneOf_daysOfWeek(Parameter<Date>, Parameter<GenericAttribute>)
        case idate__dateisOnA_dayOfWeek(Parameter<Date>, Parameter<DayOfWeek>)
        case idate__from_dateStrformat_format(Parameter<String>, Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.istart__of_componentin_date(let lhsComponent, let lhsDate), .istart__of_componentin_date(let rhsComponent, let rhsDate)):
                    guard Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                    return true 
                case (.iend__of_componentin_date(let lhsComponent, let lhsDate), .iend__of_componentin_date(let rhsComponent, let rhsDate)):
                    guard Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                    return true 
                case (.istring__for_dateinFormat_format(let lhsDate, let lhsFormat), .istring__for_dateinFormat_format(let rhsDate, let rhsFormat)):
                    guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsFormat, rhs: rhsFormat, with: matcher) else { return false } 
                    return true 
                case (.idate__date1occursOnSame_componentas_date2(let lhsDate1, let lhsComponent, let lhsDate2), .idate__date1occursOnSame_componentas_date2(let rhsDate1, let rhsComponent, let rhsDate2)):
                    guard Parameter.compare(lhs: lhsDate1, rhs: rhsDate1, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDate2, rhs: rhsDate2, with: matcher) else { return false } 
                    return true 
                case (.icompare__date1_date2(let lhsDate1, let lhsDate2), .icompare__date1_date2(let rhsDate1, let rhsDate2)):
                    guard Parameter.compare(lhs: lhsDate1, rhs: rhsDate1, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDate2, rhs: rhsDate2, with: matcher) else { return false } 
                    return true 
                case (.idate__dateisOnOneOf_daysOfWeek(let lhsDate, let lhsDaysofweek), .idate__dateisOnOneOf_daysOfWeek(let rhsDate, let rhsDaysofweek)):
                    guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDaysofweek, rhs: rhsDaysofweek, with: matcher) else { return false } 
                    return true 
                case (.idate__dateisOnA_dayOfWeek(let lhsDate, let lhsDayofweek), .idate__dateisOnA_dayOfWeek(let rhsDate, let rhsDayofweek)):
                    guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDayofweek, rhs: rhsDayofweek, with: matcher) else { return false } 
                    return true 
                case (.idate__from_dateStrformat_format(let lhsDatestr, let lhsFormat), .idate__from_dateStrformat_format(let rhsDatestr, let rhsFormat)):
                    guard Parameter.compare(lhs: lhsDatestr, rhs: rhsDatestr, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsFormat, rhs: rhsFormat, with: matcher) else { return false } 
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .istart__of_componentin_date(p0, p1): return p0.intValue + p1.intValue
                case let .iend__of_componentin_date(p0, p1): return p0.intValue + p1.intValue
                case let .istring__for_dateinFormat_format(p0, p1): return p0.intValue + p1.intValue
                case let .idate__date1occursOnSame_componentas_date2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .icompare__date1_date2(p0, p1): return p0.intValue + p1.intValue
                case let .idate__dateisOnOneOf_daysOfWeek(p0, p1): return p0.intValue + p1.intValue
                case let .idate__dateisOnA_dayOfWeek(p0, p1): return p0.intValue + p1.intValue
                case let .idate__from_dateStrformat_format(p0, p1): return p0.intValue + p1.intValue
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

        static func start(of component: Parameter<Calendar.Component>, in date: Parameter<Date>, willReturn: Date) -> Given {
            return Given(method: .istart__of_componentin_date(component, date), returns: willReturn, throws: nil)
        }
        static func end(of component: Parameter<Calendar.Component>, in date: Parameter<Date>, willReturn: Date) -> Given {
            return Given(method: .iend__of_componentin_date(component, date), returns: willReturn, throws: nil)
        }
        static func string(for date: Parameter<Date>, inFormat format: Parameter<String>, willReturn: String) -> Given {
            return Given(method: .istring__for_dateinFormat_format(date, format), returns: willReturn, throws: nil)
        }
        static func date(date1: Parameter<Date>, occursOnSame component: Parameter<Calendar.Component>, as date2: Parameter<Date>, willReturn: Bool) -> Given {
            return Given(method: .idate__date1occursOnSame_componentas_date2(date1, component, date2), returns: willReturn, throws: nil)
        }
        static func compare(date1: Parameter<Date?>, date2: Parameter<Date?>, willReturn: ComparisonResult) -> Given {
            return Given(method: .icompare__date1_date2(date1, date2), returns: willReturn, throws: nil)
        }
        static func date<CollectionType: Collection>(date: Parameter<Date>, isOnOneOf daysOfWeek: Parameter<CollectionType>, willReturn: Bool) -> Given {
            return Given(method: .idate__dateisOnOneOf_daysOfWeek(date, daysOfWeek.wrapAsGeneric()), returns: willReturn, throws: nil)
        }
        static func date(date: Parameter<Date>, isOnA dayOfWeek: Parameter<DayOfWeek>, willReturn: Bool) -> Given {
            return Given(method: .idate__dateisOnA_dayOfWeek(date, dayOfWeek), returns: willReturn, throws: nil)
        }
        static func date(from dateStr: Parameter<String>, format: Parameter<String>, willReturn: Date?) -> Given {
            return Given(method: .idate__from_dateStrformat_format(dateStr, format), returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func start(of component: Parameter<Calendar.Component>, in date: Parameter<Date>) -> Verify {
            return Verify(method: .istart__of_componentin_date(component, date))
        }
        static func end(of component: Parameter<Calendar.Component>, in date: Parameter<Date>) -> Verify {
            return Verify(method: .iend__of_componentin_date(component, date))
        }
        static func string(for date: Parameter<Date>, inFormat format: Parameter<String>) -> Verify {
            return Verify(method: .istring__for_dateinFormat_format(date, format))
        }
        static func date(date1: Parameter<Date>, occursOnSame component: Parameter<Calendar.Component>, as date2: Parameter<Date>) -> Verify {
            return Verify(method: .idate__date1occursOnSame_componentas_date2(date1, component, date2))
        }
        static func compare(date1: Parameter<Date?>, date2: Parameter<Date?>) -> Verify {
            return Verify(method: .icompare__date1_date2(date1, date2))
        }
        static func date<CollectionType>(date: Parameter<Date>, isOnOneOf daysOfWeek: Parameter<CollectionType>) -> Verify {
            return Verify(method: .idate__dateisOnOneOf_daysOfWeek(date, daysOfWeek.wrapAsGeneric()))
        }
        static func date(date: Parameter<Date>, isOnA dayOfWeek: Parameter<DayOfWeek>) -> Verify {
            return Verify(method: .idate__dateisOnA_dayOfWeek(date, dayOfWeek))
        }
        static func date(from dateStr: Parameter<String>, format: Parameter<String>) -> Verify {
            return Verify(method: .idate__from_dateStrformat_format(dateStr, format))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func start(of component: Parameter<Calendar.Component>, in date: Parameter<Date>, perform: (Calendar.Component, Date) -> Void) -> Perform {
            return Perform(method: .istart__of_componentin_date(component, date), performs: perform)
        }
        static func end(of component: Parameter<Calendar.Component>, in date: Parameter<Date>, perform: (Calendar.Component, Date) -> Void) -> Perform {
            return Perform(method: .iend__of_componentin_date(component, date), performs: perform)
        }
        static func string(for date: Parameter<Date>, inFormat format: Parameter<String>, perform: (Date, String) -> Void) -> Perform {
            return Perform(method: .istring__for_dateinFormat_format(date, format), performs: perform)
        }
        static func date(date1: Parameter<Date>, occursOnSame component: Parameter<Calendar.Component>, as date2: Parameter<Date>, perform: (Date, Calendar.Component, Date) -> Void) -> Perform {
            return Perform(method: .idate__date1occursOnSame_componentas_date2(date1, component, date2), performs: perform)
        }
        static func compare(date1: Parameter<Date?>, date2: Parameter<Date?>, perform: (Date?, Date?) -> Void) -> Perform {
            return Perform(method: .icompare__date1_date2(date1, date2), performs: perform)
        }
        static func date<CollectionType>(date: Parameter<Date>, isOnOneOf daysOfWeek: Parameter<CollectionType>, perform: (Date, CollectionType) -> Void) -> Perform {
            return Perform(method: .idate__dateisOnOneOf_daysOfWeek(date, daysOfWeek.wrapAsGeneric()), performs: perform)
        }
        static func date(date: Parameter<Date>, isOnA dayOfWeek: Parameter<DayOfWeek>, perform: (Date, DayOfWeek) -> Void) -> Perform {
            return Perform(method: .idate__dateisOnA_dayOfWeek(date, dayOfWeek), performs: perform)
        }
        static func date(from dateStr: Parameter<String>, format: Parameter<String>, perform: (String, String) -> Void) -> Perform {
            return Perform(method: .idate__from_dateStrformat_format(dateStr, format), performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - DataTypeFactory
class DataTypeFactoryMock: DataTypeFactory, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func activity() -> Activity {
        addInvocation(.iactivity)
		let perform = methodPerformValue(.iactivity) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iactivity)
		let value = givenValue.value as? Activity
		return value.orFail("stub return value not specified for activity(). Use given")
    }

    func activityInstance(activity: Activity) -> ActivityInstance {
        addInvocation(.iactivityInstance__activity_activity(Parameter<Activity>.value(activity)))
		let perform = methodPerformValue(.iactivityInstance__activity_activity(Parameter<Activity>.value(activity))) as? (Activity) -> Void
		perform?(activity)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iactivityInstance__activity_activity(Parameter<Activity>.value(activity)))
		let value = givenValue.value as? ActivityInstance
		return value.orFail("stub return value not specified for activityInstance(activity: Activity). Use given")
    }

    func heartRate(value: Double) -> HeartRate {
        addInvocation(.iheartRate__value_value(Parameter<Double>.value(value)))
		let perform = methodPerformValue(.iheartRate__value_value(Parameter<Double>.value(value))) as? (Double) -> Void
		perform?(value)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iheartRate__value_value(Parameter<Double>.value(value)))
		let value = givenValue.value as? HeartRate
		return value.orFail("stub return value not specified for heartRate(value: Double). Use given")
    }

    func heartRate(_ sample: HKQuantitySample) -> HeartRate {
        addInvocation(.iheartRate__sample(Parameter<HKQuantitySample>.value(sample)))
		let perform = methodPerformValue(.iheartRate__sample(Parameter<HKQuantitySample>.value(sample))) as? (HKQuantitySample) -> Void
		perform?(sample)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iheartRate__sample(Parameter<HKQuantitySample>.value(sample)))
		let value = givenValue.value as? HeartRate
		return value.orFail("stub return value not specified for heartRate(_ sample: HKQuantitySample). Use given")
    }

    func mood() -> Mood {
        addInvocation(.imood)
		let perform = methodPerformValue(.imood) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.imood)
		let value = givenValue.value as? Mood
		return value.orFail("stub return value not specified for mood(). Use given")
    }

    fileprivate enum MethodType {
        case iactivity
        case iactivityInstance__activity_activity(Parameter<Activity>)
        case iheartRate__value_value(Parameter<Double>)
        case iheartRate__sample(Parameter<HKQuantitySample>)
        case imood

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.iactivity, .iactivity):
                    return true 
                case (.iactivityInstance__activity_activity(let lhsActivity), .iactivityInstance__activity_activity(let rhsActivity)):
                    guard Parameter.compare(lhs: lhsActivity, rhs: rhsActivity, with: matcher) else { return false } 
                    return true 
                case (.iheartRate__value_value(let lhsValue), .iheartRate__value_value(let rhsValue)):
                    guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                    return true 
                case (.iheartRate__sample(let lhsSample), .iheartRate__sample(let rhsSample)):
                    guard Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher) else { return false } 
                    return true 
                case (.imood, .imood):
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case .iactivity: return 0
                case let .iactivityInstance__activity_activity(p0): return p0.intValue
                case let .iheartRate__value_value(p0): return p0.intValue
                case let .iheartRate__sample(p0): return p0.intValue
                case .imood: return 0
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

        static func activity(willReturn: Activity) -> Given {
            return Given(method: .iactivity, returns: willReturn, throws: nil)
        }
        static func activityInstance(activity: Parameter<Activity>, willReturn: ActivityInstance) -> Given {
            return Given(method: .iactivityInstance__activity_activity(activity), returns: willReturn, throws: nil)
        }
        static func heartRate(value: Parameter<Double>, willReturn: HeartRate) -> Given {
            return Given(method: .iheartRate__value_value(value), returns: willReturn, throws: nil)
        }
        static func heartRate(sample: Parameter<HKQuantitySample>, willReturn: HeartRate) -> Given {
            return Given(method: .iheartRate__sample(sample), returns: willReturn, throws: nil)
        }
        static func mood(willReturn: Mood) -> Given {
            return Given(method: .imood, returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func activity() -> Verify {
            return Verify(method: .iactivity)
        }
        static func activityInstance(activity: Parameter<Activity>) -> Verify {
            return Verify(method: .iactivityInstance__activity_activity(activity))
        }
        static func heartRate(value: Parameter<Double>) -> Verify {
            return Verify(method: .iheartRate__value_value(value))
        }
        static func heartRate(sample: Parameter<HKQuantitySample>) -> Verify {
            return Verify(method: .iheartRate__sample(sample))
        }
        static func mood() -> Verify {
            return Verify(method: .imood)
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func activity(perform: () -> Void) -> Perform {
            return Perform(method: .iactivity, performs: perform)
        }
        static func activityInstance(activity: Parameter<Activity>, perform: (Activity) -> Void) -> Perform {
            return Perform(method: .iactivityInstance__activity_activity(activity), performs: perform)
        }
        static func heartRate(value: Parameter<Double>, perform: (Double) -> Void) -> Perform {
            return Perform(method: .iheartRate__value_value(value), performs: perform)
        }
        static func heartRate(sample: Parameter<HKQuantitySample>, perform: (HKQuantitySample) -> Void) -> Perform {
            return Perform(method: .iheartRate__sample(sample), performs: perform)
        }
        static func mood(perform: () -> Void) -> Perform {
            return Perform(method: .imood, performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - InjectionProvider
class InjectionProviderMock: InjectionProvider, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func database() -> Database {
        addInvocation(.idatabase)
		let perform = methodPerformValue(.idatabase) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.idatabase)
		let value = givenValue.value as? Database
		return value.orFail("stub return value not specified for database(). Use given")
    }

    func queryFactory() -> QueryFactory {
        addInvocation(.iqueryFactory)
		let perform = methodPerformValue(.iqueryFactory) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iqueryFactory)
		let value = givenValue.value as? QueryFactory
		return value.orFail("stub return value not specified for queryFactory(). Use given")
    }

    func querierFactory() -> QuerierFactory {
        addInvocation(.iquerierFactory)
		let perform = methodPerformValue(.iquerierFactory) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iquerierFactory)
		let value = givenValue.value as? QuerierFactory
		return value.orFail("stub return value not specified for querierFactory(). Use given")
    }

    func questionFactory() -> QuestionFactory {
        addInvocation(.iquestionFactory)
		let perform = methodPerformValue(.iquestionFactory) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iquestionFactory)
		let value = givenValue.value as? QuestionFactory
		return value.orFail("stub return value not specified for questionFactory(). Use given")
    }

    func dataTypeFactory() -> DataTypeFactory {
        addInvocation(.idataTypeFactory)
		let perform = methodPerformValue(.idataTypeFactory) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.idataTypeFactory)
		let value = givenValue.value as? DataTypeFactory
		return value.orFail("stub return value not specified for dataTypeFactory(). Use given")
    }

    func utilFactory() -> UtilFactory {
        addInvocation(.iutilFactory)
		let perform = methodPerformValue(.iutilFactory) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iutilFactory)
		let value = givenValue.value as? UtilFactory
		return value.orFail("stub return value not specified for utilFactory(). Use given")
    }

    func restrictionParserFactory() -> RestrictionParserFactory {
        addInvocation(.irestrictionParserFactory)
		let perform = methodPerformValue(.irestrictionParserFactory) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.irestrictionParserFactory)
		let value = givenValue.value as? RestrictionParserFactory
		return value.orFail("stub return value not specified for restrictionParserFactory(). Use given")
    }

    func subQueryMatcherFactory() -> SubQueryMatcherFactory {
        addInvocation(.isubQueryMatcherFactory)
		let perform = methodPerformValue(.isubQueryMatcherFactory) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isubQueryMatcherFactory)
		let value = givenValue.value as? SubQueryMatcherFactory
		return value.orFail("stub return value not specified for subQueryMatcherFactory(). Use given")
    }

    func extraInformationFactory() -> ExtraInformationFactory {
        addInvocation(.iextraInformationFactory)
		let perform = methodPerformValue(.iextraInformationFactory) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iextraInformationFactory)
		let value = givenValue.value as? ExtraInformationFactory
		return value.orFail("stub return value not specified for extraInformationFactory(). Use given")
    }

    func sampleGrouperFactory() -> SampleGrouperFactory {
        addInvocation(.isampleGrouperFactory)
		let perform = methodPerformValue(.isampleGrouperFactory) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isampleGrouperFactory)
		let value = givenValue.value as? SampleGrouperFactory
		return value.orFail("stub return value not specified for sampleGrouperFactory(). Use given")
    }

    func sampleGroupCombinerFactory() -> SampleGroupCombinerFactory {
        addInvocation(.isampleGroupCombinerFactory)
		let perform = methodPerformValue(.isampleGroupCombinerFactory) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isampleGroupCombinerFactory)
		let value = givenValue.value as? SampleGroupCombinerFactory
		return value.orFail("stub return value not specified for sampleGroupCombinerFactory(). Use given")
    }

    fileprivate enum MethodType {
        case idatabase
        case iqueryFactory
        case iquerierFactory
        case iquestionFactory
        case idataTypeFactory
        case iutilFactory
        case irestrictionParserFactory
        case isubQueryMatcherFactory
        case iextraInformationFactory
        case isampleGrouperFactory
        case isampleGroupCombinerFactory

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.idatabase, .idatabase):
                    return true 
                case (.iqueryFactory, .iqueryFactory):
                    return true 
                case (.iquerierFactory, .iquerierFactory):
                    return true 
                case (.iquestionFactory, .iquestionFactory):
                    return true 
                case (.idataTypeFactory, .idataTypeFactory):
                    return true 
                case (.iutilFactory, .iutilFactory):
                    return true 
                case (.irestrictionParserFactory, .irestrictionParserFactory):
                    return true 
                case (.isubQueryMatcherFactory, .isubQueryMatcherFactory):
                    return true 
                case (.iextraInformationFactory, .iextraInformationFactory):
                    return true 
                case (.isampleGrouperFactory, .isampleGrouperFactory):
                    return true 
                case (.isampleGroupCombinerFactory, .isampleGroupCombinerFactory):
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case .idatabase: return 0
                case .iqueryFactory: return 0
                case .iquerierFactory: return 0
                case .iquestionFactory: return 0
                case .idataTypeFactory: return 0
                case .iutilFactory: return 0
                case .irestrictionParserFactory: return 0
                case .isubQueryMatcherFactory: return 0
                case .iextraInformationFactory: return 0
                case .isampleGrouperFactory: return 0
                case .isampleGroupCombinerFactory: return 0
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

        static func database(willReturn: Database) -> Given {
            return Given(method: .idatabase, returns: willReturn, throws: nil)
        }
        static func queryFactory(willReturn: QueryFactory) -> Given {
            return Given(method: .iqueryFactory, returns: willReturn, throws: nil)
        }
        static func querierFactory(willReturn: QuerierFactory) -> Given {
            return Given(method: .iquerierFactory, returns: willReturn, throws: nil)
        }
        static func questionFactory(willReturn: QuestionFactory) -> Given {
            return Given(method: .iquestionFactory, returns: willReturn, throws: nil)
        }
        static func dataTypeFactory(willReturn: DataTypeFactory) -> Given {
            return Given(method: .idataTypeFactory, returns: willReturn, throws: nil)
        }
        static func utilFactory(willReturn: UtilFactory) -> Given {
            return Given(method: .iutilFactory, returns: willReturn, throws: nil)
        }
        static func restrictionParserFactory(willReturn: RestrictionParserFactory) -> Given {
            return Given(method: .irestrictionParserFactory, returns: willReturn, throws: nil)
        }
        static func subQueryMatcherFactory(willReturn: SubQueryMatcherFactory) -> Given {
            return Given(method: .isubQueryMatcherFactory, returns: willReturn, throws: nil)
        }
        static func extraInformationFactory(willReturn: ExtraInformationFactory) -> Given {
            return Given(method: .iextraInformationFactory, returns: willReturn, throws: nil)
        }
        static func sampleGrouperFactory(willReturn: SampleGrouperFactory) -> Given {
            return Given(method: .isampleGrouperFactory, returns: willReturn, throws: nil)
        }
        static func sampleGroupCombinerFactory(willReturn: SampleGroupCombinerFactory) -> Given {
            return Given(method: .isampleGroupCombinerFactory, returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func database() -> Verify {
            return Verify(method: .idatabase)
        }
        static func queryFactory() -> Verify {
            return Verify(method: .iqueryFactory)
        }
        static func querierFactory() -> Verify {
            return Verify(method: .iquerierFactory)
        }
        static func questionFactory() -> Verify {
            return Verify(method: .iquestionFactory)
        }
        static func dataTypeFactory() -> Verify {
            return Verify(method: .idataTypeFactory)
        }
        static func utilFactory() -> Verify {
            return Verify(method: .iutilFactory)
        }
        static func restrictionParserFactory() -> Verify {
            return Verify(method: .irestrictionParserFactory)
        }
        static func subQueryMatcherFactory() -> Verify {
            return Verify(method: .isubQueryMatcherFactory)
        }
        static func extraInformationFactory() -> Verify {
            return Verify(method: .iextraInformationFactory)
        }
        static func sampleGrouperFactory() -> Verify {
            return Verify(method: .isampleGrouperFactory)
        }
        static func sampleGroupCombinerFactory() -> Verify {
            return Verify(method: .isampleGroupCombinerFactory)
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func database(perform: () -> Void) -> Perform {
            return Perform(method: .idatabase, performs: perform)
        }
        static func queryFactory(perform: () -> Void) -> Perform {
            return Perform(method: .iqueryFactory, performs: perform)
        }
        static func querierFactory(perform: () -> Void) -> Perform {
            return Perform(method: .iquerierFactory, performs: perform)
        }
        static func questionFactory(perform: () -> Void) -> Perform {
            return Perform(method: .iquestionFactory, performs: perform)
        }
        static func dataTypeFactory(perform: () -> Void) -> Perform {
            return Perform(method: .idataTypeFactory, performs: perform)
        }
        static func utilFactory(perform: () -> Void) -> Perform {
            return Perform(method: .iutilFactory, performs: perform)
        }
        static func restrictionParserFactory(perform: () -> Void) -> Perform {
            return Perform(method: .irestrictionParserFactory, performs: perform)
        }
        static func subQueryMatcherFactory(perform: () -> Void) -> Perform {
            return Perform(method: .isubQueryMatcherFactory, performs: perform)
        }
        static func extraInformationFactory(perform: () -> Void) -> Perform {
            return Perform(method: .iextraInformationFactory, performs: perform)
        }
        static func sampleGrouperFactory(perform: () -> Void) -> Perform {
            return Perform(method: .isampleGrouperFactory, performs: perform)
        }
        static func sampleGroupCombinerFactory(perform: () -> Void) -> Perform {
            return Perform(method: .isampleGroupCombinerFactory, performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - NumericSampleUtil
class NumericSampleUtilMock: NumericSampleUtil, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func average(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Double)] {
        addInvocation(.iaverage__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit)))
		let perform = methodPerformValue(.iaverage__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit))) as? (Attribute, [Sample], Calendar.Component?) -> Void
		perform?(attribute, samples, aggregationUnit)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iaverage__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit)))
		let value = givenValue.value as? [(date: Date?, value: Double)]
		return value.orFail("stub return value not specified for average(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?). Use given")
    }

    func average(for attribute: Attribute, over samples: [Sample]) -> Double {
        addInvocation(.iaverage__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples)))
		let perform = methodPerformValue(.iaverage__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples))) as? (Attribute, [Sample]) -> Void
		perform?(attribute, samples)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iaverage__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples)))
		let value = givenValue.value as? Double
		return value.orFail("stub return value not specified for average(for attribute: Attribute, over samples: [Sample]). Use given")
    }

    func count(over samples: [Sample], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Int)] {
        addInvocation(.icount__over_samplesper_aggregationUnit(Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit)))
		let perform = methodPerformValue(.icount__over_samplesper_aggregationUnit(Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit))) as? ([Sample], Calendar.Component?) -> Void
		perform?(samples, aggregationUnit)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.icount__over_samplesper_aggregationUnit(Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit)))
		let value = givenValue.value as? [(date: Date?, value: Int)]
		return value.orFail("stub return value not specified for count(over samples: [Sample], per aggregationUnit: Calendar.Component?). Use given")
    }

    func max<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Type)] {
        addInvocation(.imax__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit)))
		let perform = methodPerformValue(.imax__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit))) as? (Attribute, [Sample], Calendar.Component?) -> Void
		perform?(attribute, samples, aggregationUnit)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.imax__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit)))
		let value = givenValue.value as? [(date: Date?, value: Type)]
		return value.orFail("stub return value not specified for max<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?). Use given")
    }

    func max<Type: Comparable>(for attribute: Attribute, over samples: [Sample]) -> Type {
        addInvocation(.imax__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples)))
		let perform = methodPerformValue(.imax__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples))) as? (Attribute, [Sample]) -> Void
		perform?(attribute, samples)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.imax__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples)))
		let value = givenValue.value as? Type
		return value.orFail("stub return value not specified for max<Type: Comparable>(for attribute: Attribute, over samples: [Sample]). Use given")
    }

    func min<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Type)] {
        addInvocation(.imin__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit)))
		let perform = methodPerformValue(.imin__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit))) as? (Attribute, [Sample], Calendar.Component?) -> Void
		perform?(attribute, samples, aggregationUnit)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.imin__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit)))
		let value = givenValue.value as? [(date: Date?, value: Type)]
		return value.orFail("stub return value not specified for min<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?). Use given")
    }

    func min<Type: Comparable>(for attribute: Attribute, over samples: [Sample]) -> Type {
        addInvocation(.imin__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples)))
		let perform = methodPerformValue(.imin__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples))) as? (Attribute, [Sample]) -> Void
		perform?(attribute, samples)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.imin__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples)))
		let value = givenValue.value as? Type
		return value.orFail("stub return value not specified for min<Type: Comparable>(for attribute: Attribute, over samples: [Sample]). Use given")
    }

    func sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?) -> [(date: Date?, value: Type)] {
        addInvocation(.isum__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit)))
		let perform = methodPerformValue(.isum__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit))) as? (Attribute, [Sample], Calendar.Component?) -> Void
		perform?(attribute, samples, aggregationUnit)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isum__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples), Parameter<Calendar.Component?>.value(aggregationUnit)))
		let value = givenValue.value as? [(date: Date?, value: Type)]
		return value.orFail("stub return value not specified for sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?). Use given")
    }

    func sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample]) -> Type {
        addInvocation(.isum__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples)))
		let perform = methodPerformValue(.isum__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples))) as? (Attribute, [Sample]) -> Void
		perform?(attribute, samples)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isum__for_attributeover_samples(Parameter<Attribute>.value(attribute), Parameter<[Sample]>.value(samples)))
		let value = givenValue.value as? Type
		return value.orFail("stub return value not specified for sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample]). Use given")
    }

    fileprivate enum MethodType {
        case iaverage__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>, Parameter<[Sample]>, Parameter<Calendar.Component?>)
        case iaverage__for_attributeover_samples(Parameter<Attribute>, Parameter<[Sample]>)
        case icount__over_samplesper_aggregationUnit(Parameter<[Sample]>, Parameter<Calendar.Component?>)
        case imax__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>, Parameter<[Sample]>, Parameter<Calendar.Component?>)
        case imax__for_attributeover_samples(Parameter<Attribute>, Parameter<[Sample]>)
        case imin__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>, Parameter<[Sample]>, Parameter<Calendar.Component?>)
        case imin__for_attributeover_samples(Parameter<Attribute>, Parameter<[Sample]>)
        case isum__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>, Parameter<[Sample]>, Parameter<Calendar.Component?>)
        case isum__for_attributeover_samples(Parameter<Attribute>, Parameter<[Sample]>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.iaverage__for_attributeover_samplesper_aggregationUnit(let lhsAttribute, let lhsSamples, let lhsAggregationunit), .iaverage__for_attributeover_samplesper_aggregationUnit(let rhsAttribute, let rhsSamples, let rhsAggregationunit)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                    return true 
                case (.iaverage__for_attributeover_samples(let lhsAttribute, let lhsSamples), .iaverage__for_attributeover_samples(let rhsAttribute, let rhsSamples)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    return true 
                case (.icount__over_samplesper_aggregationUnit(let lhsSamples, let lhsAggregationunit), .icount__over_samplesper_aggregationUnit(let rhsSamples, let rhsAggregationunit)):
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                    return true 
                case (.imax__for_attributeover_samplesper_aggregationUnit(let lhsAttribute, let lhsSamples, let lhsAggregationunit), .imax__for_attributeover_samplesper_aggregationUnit(let rhsAttribute, let rhsSamples, let rhsAggregationunit)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                    return true 
                case (.imax__for_attributeover_samples(let lhsAttribute, let lhsSamples), .imax__for_attributeover_samples(let rhsAttribute, let rhsSamples)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    return true 
                case (.imin__for_attributeover_samplesper_aggregationUnit(let lhsAttribute, let lhsSamples, let lhsAggregationunit), .imin__for_attributeover_samplesper_aggregationUnit(let rhsAttribute, let rhsSamples, let rhsAggregationunit)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                    return true 
                case (.imin__for_attributeover_samples(let lhsAttribute, let lhsSamples), .imin__for_attributeover_samples(let rhsAttribute, let rhsSamples)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    return true 
                case (.isum__for_attributeover_samplesper_aggregationUnit(let lhsAttribute, let lhsSamples, let lhsAggregationunit), .isum__for_attributeover_samplesper_aggregationUnit(let rhsAttribute, let rhsSamples, let rhsAggregationunit)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                    return true 
                case (.isum__for_attributeover_samples(let lhsAttribute, let lhsSamples), .isum__for_attributeover_samples(let rhsAttribute, let rhsSamples)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .iaverage__for_attributeover_samplesper_aggregationUnit(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .iaverage__for_attributeover_samples(p0, p1): return p0.intValue + p1.intValue
                case let .icount__over_samplesper_aggregationUnit(p0, p1): return p0.intValue + p1.intValue
                case let .imax__for_attributeover_samplesper_aggregationUnit(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .imax__for_attributeover_samples(p0, p1): return p0.intValue + p1.intValue
                case let .imin__for_attributeover_samplesper_aggregationUnit(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .imin__for_attributeover_samples(p0, p1): return p0.intValue + p1.intValue
                case let .isum__for_attributeover_samplesper_aggregationUnit(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .isum__for_attributeover_samples(p0, p1): return p0.intValue + p1.intValue
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

        static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, willReturn: [(date: Date?, value: Double)]) -> Given {
            return Given(method: .iaverage__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit), returns: willReturn, throws: nil)
        }
        static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, willReturn: Double) -> Given {
            return Given(method: .iaverage__for_attributeover_samples(attribute, samples), returns: willReturn, throws: nil)
        }
        static func count(over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, willReturn: [(date: Date?, value: Int)]) -> Given {
            return Given(method: .icount__over_samplesper_aggregationUnit(samples, aggregationUnit), returns: willReturn, throws: nil)
        }
        static func max<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, willReturn: [(date: Date?, value: Type)]) -> Given {
            return Given(method: .imax__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit), returns: willReturn, throws: nil)
        }
        static func max<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, willReturn: Type) -> Given {
            return Given(method: .imax__for_attributeover_samples(attribute, samples), returns: willReturn, throws: nil)
        }
        static func min<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, willReturn: [(date: Date?, value: Type)]) -> Given {
            return Given(method: .imin__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit), returns: willReturn, throws: nil)
        }
        static func min<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, willReturn: Type) -> Given {
            return Given(method: .imin__for_attributeover_samples(attribute, samples), returns: willReturn, throws: nil)
        }
        static func sum<Type: Numeric>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, willReturn: [(date: Date?, value: Type)]) -> Given {
            return Given(method: .isum__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit), returns: willReturn, throws: nil)
        }
        static func sum<Type: Numeric>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, willReturn: Type) -> Given {
            return Given(method: .isum__for_attributeover_samples(attribute, samples), returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>) -> Verify {
            return Verify(method: .iaverage__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit))
        }
        static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>) -> Verify {
            return Verify(method: .iaverage__for_attributeover_samples(attribute, samples))
        }
        static func count(over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>) -> Verify {
            return Verify(method: .icount__over_samplesper_aggregationUnit(samples, aggregationUnit))
        }
        static func max(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>) -> Verify {
            return Verify(method: .imax__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit))
        }
        static func max(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>) -> Verify {
            return Verify(method: .imax__for_attributeover_samples(attribute, samples))
        }
        static func min(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>) -> Verify {
            return Verify(method: .imin__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit))
        }
        static func min(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>) -> Verify {
            return Verify(method: .imin__for_attributeover_samples(attribute, samples))
        }
        static func sum(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>) -> Verify {
            return Verify(method: .isum__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit))
        }
        static func sum(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>) -> Verify {
            return Verify(method: .isum__for_attributeover_samples(attribute, samples))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, perform: (Attribute, [Sample], Calendar.Component?) -> Void) -> Perform {
            return Perform(method: .iaverage__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit), performs: perform)
        }
        static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, perform: (Attribute, [Sample]) -> Void) -> Perform {
            return Perform(method: .iaverage__for_attributeover_samples(attribute, samples), performs: perform)
        }
        static func count(over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, perform: ([Sample], Calendar.Component?) -> Void) -> Perform {
            return Perform(method: .icount__over_samplesper_aggregationUnit(samples, aggregationUnit), performs: perform)
        }
        static func max(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, perform: (Attribute, [Sample], Calendar.Component?) -> Void) -> Perform {
            return Perform(method: .imax__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit), performs: perform)
        }
        static func max(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, perform: (Attribute, [Sample]) -> Void) -> Perform {
            return Perform(method: .imax__for_attributeover_samples(attribute, samples), performs: perform)
        }
        static func min(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, perform: (Attribute, [Sample], Calendar.Component?) -> Void) -> Perform {
            return Perform(method: .imin__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit), performs: perform)
        }
        static func min(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, perform: (Attribute, [Sample]) -> Void) -> Perform {
            return Perform(method: .imin__for_attributeover_samples(attribute, samples), performs: perform)
        }
        static func sum(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, perform: (Attribute, [Sample], Calendar.Component?) -> Void) -> Perform {
            return Perform(method: .isum__for_attributeover_samplesper_aggregationUnit(attribute, samples, aggregationUnit), performs: perform)
        }
        static func sum(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, perform: (Attribute, [Sample]) -> Void) -> Perform {
            return Perform(method: .isum__for_attributeover_samples(attribute, samples), performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - QuerierFactory
class QuerierFactoryMock: QuerierFactory, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default

    var heartRateQuerier: HeartRateQuerier { 
		get {	invocations.append(.heartRateQuerier_get)
				return __heartRateQuerier.orFail("QuerierFactoryMock - value for heartRateQuerier was not defined") }
		set {	invocations.append(.heartRateQuerier_set(.value(newValue)))
				__heartRateQuerier = newValue }
	}
	private var __heartRateQuerier: (HeartRateQuerier)?

    struct Property {
        fileprivate var method: MethodType
        static var heartRateQuerier: Property { return Property(method: .heartRateQuerier_get) }
		static func heartRateQuerier(set newValue: Parameter<HeartRateQuerier>) -> Property { return Property(method: .heartRateQuerier_set(newValue)) }
    }


    fileprivate enum MethodType {
        case heartRateQuerier_get
		case heartRateQuerier_set(Parameter<HeartRateQuerier>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.heartRateQuerier_get,.heartRateQuerier_get): return true
				case (.heartRateQuerier_set(let left),.heartRateQuerier_set(let right)): return Parameter<HeartRateQuerier>.compare(lhs: left, rhs: right, with: matcher)
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case .heartRateQuerier_get: return 0
				case .heartRateQuerier_set(let newValue): return newValue.intValue
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

    }

    struct Verify {
        fileprivate var method: MethodType

    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

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
}

// MARK: - Query
class QueryMock: Query, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default

    var attributeRestrictions: [AttributeRestriction] { 
		get {	invocations.append(.attributeRestrictions_get)
				return __attributeRestrictions.orFail("QueryMock - value for attributeRestrictions was not defined") }
		set {	invocations.append(.attributeRestrictions_set(.value(newValue)))
				__attributeRestrictions = newValue }
	}
	private var __attributeRestrictions: ([AttributeRestriction])?
    var mostRecentEntryOnly: Bool { 
		get {	invocations.append(.mostRecentEntryOnly_get)
				return __mostRecentEntryOnly.orFail("QueryMock - value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.mostRecentEntryOnly_set(.value(newValue)))
				__mostRecentEntryOnly = newValue }
	}
	private var __mostRecentEntryOnly: (Bool)?
    var numberOfDatesPerSample: Int { 
		get {	invocations.append(.numberOfDatesPerSample_get)
				return __numberOfDatesPerSample.orFail("QueryMock - value for numberOfDatesPerSample was not defined") }
		set {	invocations.append(.numberOfDatesPerSample_set(.value(newValue)))
				__numberOfDatesPerSample = newValue }
	}
	private var __numberOfDatesPerSample: (Int)?
    var subQuery: (matcher: SubQueryMatcher, query: Query)? { 
		get {	invocations.append(.subQuery_get)
				return __subQuery }
		set {	invocations.append(.subQuery_set(.value(newValue)))
				__subQuery = newValue }
	}
	private var __subQuery: ((matcher: SubQueryMatcher, query: Query))?

    struct Property {
        fileprivate var method: MethodType
        static var attributeRestrictions: Property { return Property(method: .attributeRestrictions_get) }
		static func attributeRestrictions(set newValue: Parameter<[AttributeRestriction]>) -> Property { return Property(method: .attributeRestrictions_set(newValue)) }
        static var mostRecentEntryOnly: Property { return Property(method: .mostRecentEntryOnly_get) }
		static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Property { return Property(method: .mostRecentEntryOnly_set(newValue)) }
        static var numberOfDatesPerSample: Property { return Property(method: .numberOfDatesPerSample_get) }
		static func numberOfDatesPerSample(set newValue: Parameter<Int>) -> Property { return Property(method: .numberOfDatesPerSample_set(newValue)) }
        static var subQuery: Property { return Property(method: .subQuery_get) }
		static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Property { return Property(method: .subQuery_set(newValue)) }
    }


    func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.irunQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(callback)))
		let perform = methodPerformValue(.irunQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(callback))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(callback)
    }

    fileprivate enum MethodType {
        case irunQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case attributeRestrictions_get
		case attributeRestrictions_set(Parameter<[AttributeRestriction]>)
        case mostRecentEntryOnly_get
		case mostRecentEntryOnly_set(Parameter<Bool>)
        case numberOfDatesPerSample_get
		case numberOfDatesPerSample_set(Parameter<Int>)
        case subQuery_get
		case subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.irunQuery__callback_callback(let lhsCallback), .irunQuery__callback_callback(let rhsCallback)):
                    guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                    return true 
                case (.attributeRestrictions_get,.attributeRestrictions_get): return true
				case (.attributeRestrictions_set(let left),.attributeRestrictions_set(let right)): return Parameter<[AttributeRestriction]>.compare(lhs: left, rhs: right, with: matcher)
                case (.mostRecentEntryOnly_get,.mostRecentEntryOnly_get): return true
				case (.mostRecentEntryOnly_set(let left),.mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
                case (.numberOfDatesPerSample_get,.numberOfDatesPerSample_get): return true
				case (.numberOfDatesPerSample_set(let left),.numberOfDatesPerSample_set(let right)): return Parameter<Int>.compare(lhs: left, rhs: right, with: matcher)
                case (.subQuery_get,.subQuery_get): return true
				case (.subQuery_set(let left),.subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .irunQuery__callback_callback(p0): return p0.intValue
                case .attributeRestrictions_get: return 0
				case .attributeRestrictions_set(let newValue): return newValue.intValue
                case .mostRecentEntryOnly_get: return 0
				case .mostRecentEntryOnly_set(let newValue): return newValue.intValue
                case .numberOfDatesPerSample_get: return 0
				case .numberOfDatesPerSample_set(let newValue): return newValue.intValue
                case .subQuery_get: return 0
				case .subQuery_set(let newValue): return newValue.intValue
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

    }

    struct Verify {
        fileprivate var method: MethodType

        static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify {
            return Verify(method: .irunQuery__callback_callback(callback))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .irunQuery__callback_callback(callback), performs: perform)
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
}

// MARK: - QueryFactory
class QueryFactoryMock: QueryFactory, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func heartRateQuery() -> HeartRateQuery {
        addInvocation(.iheartRateQuery)
		let perform = methodPerformValue(.iheartRateQuery) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iheartRateQuery)
		let value = givenValue.value as? HeartRateQuery
		return value.orFail("stub return value not specified for heartRateQuery(). Use given")
    }

    func queryFor<SampleType: Sample>(sampleType: SampleType.Type) throws -> SampleQuery<SampleType> {
        addInvocation(.iqueryFor__sampleType_sampleType(Parameter<SampleType.Type>.value(sampleType).wrapAsGeneric()))
		let perform = methodPerformValue(.iqueryFor__sampleType_sampleType(Parameter<SampleType.Type>.value(sampleType).wrapAsGeneric())) as? (SampleType.Type) -> Void
		perform?(sampleType)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iqueryFor__sampleType_sampleType(Parameter<SampleType.Type>.value(sampleType).wrapAsGeneric()))
		if let error = givenValue.error { throw error }
		let value = givenValue.value as? SampleQuery<SampleType>
		return value.orFail("stub return value not specified for queryFor<SampleType: Sample>(sampleType: SampleType.Type). Use given")
    }

    fileprivate enum MethodType {
        case iheartRateQuery
        case iqueryFor__sampleType_sampleType(Parameter<GenericAttribute>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.iheartRateQuery, .iheartRateQuery):
                    return true 
                case (.iqueryFor__sampleType_sampleType(let lhsSampletype), .iqueryFor__sampleType_sampleType(let rhsSampletype)):
                    guard Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher) else { return false } 
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case .iheartRateQuery: return 0
                case let .iqueryFor__sampleType_sampleType(p0): return p0.intValue
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

        static func heartRateQuery(willReturn: HeartRateQuery) -> Given {
            return Given(method: .iheartRateQuery, returns: willReturn, throws: nil)
        }
        static func queryFor<SampleType: Sample>(sampleType: Parameter<SampleType.Type>, willReturn: SampleQuery<SampleType>) -> Given {
            return Given(method: .iqueryFor__sampleType_sampleType(sampleType.wrapAsGeneric()), returns: willReturn, throws: nil)
        }
        static func queryFor<SampleType: Sample>(sampleType: Parameter<SampleType.Type>, willThrow: Error) -> Given {
            return Given(method: .iqueryFor__sampleType_sampleType(sampleType.wrapAsGeneric()), returns: nil, throws: willThrow)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func heartRateQuery() -> Verify {
            return Verify(method: .iheartRateQuery)
        }
        static func queryFor<SampleType>(sampleType: Parameter<SampleType.Type>) -> Verify {
            return Verify(method: .iqueryFor__sampleType_sampleType(sampleType.wrapAsGeneric()))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func heartRateQuery(perform: () -> Void) -> Perform {
            return Perform(method: .iheartRateQuery, performs: perform)
        }
        static func queryFor<SampleType>(sampleType: Parameter<SampleType.Type>, perform: (SampleType.Type) -> Void) -> Perform {
            return Perform(method: .iqueryFor__sampleType_sampleType(sampleType.wrapAsGeneric()), performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - SampleGroupCombinerFactory
class SampleGroupCombinerFactoryMock: SampleGroupCombinerFactory, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func typesFor(attribute: Attribute) -> [SampleGroupCombiner.Type] {
        addInvocation(.itypesFor__attribute_attribute(Parameter<Attribute>.value(attribute)))
		let perform = methodPerformValue(.itypesFor__attribute_attribute(Parameter<Attribute>.value(attribute))) as? (Attribute) -> Void
		perform?(attribute)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.itypesFor__attribute_attribute(Parameter<Attribute>.value(attribute)))
		let value = givenValue.value as? [SampleGroupCombiner.Type]
		return value.orFail("stub return value not specified for typesFor(attribute: Attribute). Use given")
    }

    func initialize(type: SampleGroupCombiner.Type) -> SampleGroupCombiner {
        addInvocation(.iinitialize__type_type(Parameter<SampleGroupCombiner.Type>.value(type)))
		let perform = methodPerformValue(.iinitialize__type_type(Parameter<SampleGroupCombiner.Type>.value(type))) as? (SampleGroupCombiner.Type) -> Void
		perform?(type)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iinitialize__type_type(Parameter<SampleGroupCombiner.Type>.value(type)))
		let value = givenValue.value as? SampleGroupCombiner
		return value.orFail("stub return value not specified for initialize(type: SampleGroupCombiner.Type). Use given")
    }

    fileprivate enum MethodType {
        case itypesFor__attribute_attribute(Parameter<Attribute>)
        case iinitialize__type_type(Parameter<SampleGroupCombiner.Type>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.itypesFor__attribute_attribute(let lhsAttribute), .itypesFor__attribute_attribute(let rhsAttribute)):
                    guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                    return true 
                case (.iinitialize__type_type(let lhsType), .iinitialize__type_type(let rhsType)):
                    guard Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher) else { return false } 
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .itypesFor__attribute_attribute(p0): return p0.intValue
                case let .iinitialize__type_type(p0): return p0.intValue
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

        static func typesFor(attribute: Parameter<Attribute>, willReturn: [SampleGroupCombiner.Type]) -> Given {
            return Given(method: .itypesFor__attribute_attribute(attribute), returns: willReturn, throws: nil)
        }
        static func initialize(type: Parameter<SampleGroupCombiner.Type>, willReturn: SampleGroupCombiner) -> Given {
            return Given(method: .iinitialize__type_type(type), returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func typesFor(attribute: Parameter<Attribute>) -> Verify {
            return Verify(method: .itypesFor__attribute_attribute(attribute))
        }
        static func initialize(type: Parameter<SampleGroupCombiner.Type>) -> Verify {
            return Verify(method: .iinitialize__type_type(type))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func typesFor(attribute: Parameter<Attribute>, perform: (Attribute) -> Void) -> Perform {
            return Perform(method: .itypesFor__attribute_attribute(attribute), performs: perform)
        }
        static func initialize(type: Parameter<SampleGroupCombiner.Type>, perform: (SampleGroupCombiner.Type) -> Void) -> Perform {
            return Perform(method: .iinitialize__type_type(type), performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - SampleUtil
class SampleUtilMock: SampleUtil, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func getOnly(samples: [Sample], from startDate: Date?, to endDate: Date?) -> [Sample] {
        addInvocation(.igetOnly__samples_samplesfrom_startDateto_endDate_1(Parameter<[Sample]>.value(samples), Parameter<Date?>.value(startDate), Parameter<Date?>.value(endDate)))
		let perform = methodPerformValue(.igetOnly__samples_samplesfrom_startDateto_endDate_1(Parameter<[Sample]>.value(samples), Parameter<Date?>.value(startDate), Parameter<Date?>.value(endDate))) as? ([Sample], Date?, Date?) -> Void
		perform?(samples, startDate, endDate)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.igetOnly__samples_samplesfrom_startDateto_endDate_1(Parameter<[Sample]>.value(samples), Parameter<Date?>.value(startDate), Parameter<Date?>.value(endDate)))
		let value = givenValue.value as? [Sample]
		return value.orFail("stub return value not specified for getOnly(samples: [Sample], from startDate: Date?, to endDate: Date?). Use given")
    }

    func getOnly<SampleType: Sample>(samples: [SampleType], from startDate: Date?, to endDate: Date?) -> [SampleType] {
        addInvocation(.igetOnly__samples_samplesfrom_startDateto_endDate_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<Date?>.value(startDate), Parameter<Date?>.value(endDate)))
		let perform = methodPerformValue(.igetOnly__samples_samplesfrom_startDateto_endDate_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<Date?>.value(startDate), Parameter<Date?>.value(endDate))) as? ([SampleType], Date?, Date?) -> Void
		perform?(samples, startDate, endDate)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.igetOnly__samples_samplesfrom_startDateto_endDate_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<Date?>.value(startDate), Parameter<Date?>.value(endDate)))
		let value = givenValue.value as? [SampleType]
		return value.orFail("stub return value not specified for getOnly<SampleType: Sample>(samples: [SampleType], from startDate: Date?, to endDate: Date?). Use given")
    }

    func sample(_ sample: Sample, occursOnOneOf daysOfWeek: Set<DayOfWeek>) -> Bool {
        addInvocation(.isample__sampleoccursOnOneOf_daysOfWeek(Parameter<Sample>.value(sample), Parameter<Set<DayOfWeek>>.value(daysOfWeek)))
		let perform = methodPerformValue(.isample__sampleoccursOnOneOf_daysOfWeek(Parameter<Sample>.value(sample), Parameter<Set<DayOfWeek>>.value(daysOfWeek))) as? (Sample, Set<DayOfWeek>) -> Void
		perform?(sample, daysOfWeek)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isample__sampleoccursOnOneOf_daysOfWeek(Parameter<Sample>.value(sample), Parameter<Set<DayOfWeek>>.value(daysOfWeek)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for sample(_ sample: Sample, occursOnOneOf daysOfWeek: Set<DayOfWeek>). Use given")
    }

    func aggregate(samples: [Sample], by aggregationUnit: Calendar.Component, dateType: DateType) -> [Date: [Sample]] {
        addInvocation(.iaggregate__samples_samplesby_aggregationUnitdateType_dateType_1(Parameter<[Sample]>.value(samples), Parameter<Calendar.Component>.value(aggregationUnit), Parameter<DateType>.value(dateType)))
		let perform = methodPerformValue(.iaggregate__samples_samplesby_aggregationUnitdateType_dateType_1(Parameter<[Sample]>.value(samples), Parameter<Calendar.Component>.value(aggregationUnit), Parameter<DateType>.value(dateType))) as? ([Sample], Calendar.Component, DateType) -> Void
		perform?(samples, aggregationUnit, dateType)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iaggregate__samples_samplesby_aggregationUnitdateType_dateType_1(Parameter<[Sample]>.value(samples), Parameter<Calendar.Component>.value(aggregationUnit), Parameter<DateType>.value(dateType)))
		let value = givenValue.value as? [Date: [Sample]]
		return value.orFail("stub return value not specified for aggregate(samples: [Sample], by aggregationUnit: Calendar.Component, dateType: DateType). Use given")
    }

    func aggregate<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component, dateType: DateType) -> [Date: [SampleType]] {
        addInvocation(.iaggregate__samples_samplesby_aggregationUnitdateType_dateType_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<Calendar.Component>.value(aggregationUnit), Parameter<DateType>.value(dateType)))
		let perform = methodPerformValue(.iaggregate__samples_samplesby_aggregationUnitdateType_dateType_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<Calendar.Component>.value(aggregationUnit), Parameter<DateType>.value(dateType))) as? ([SampleType], Calendar.Component, DateType) -> Void
		perform?(samples, aggregationUnit, dateType)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iaggregate__samples_samplesby_aggregationUnitdateType_dateType_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<Calendar.Component>.value(aggregationUnit), Parameter<DateType>.value(dateType)))
		let value = givenValue.value as? [Date: [SampleType]]
		return value.orFail("stub return value not specified for aggregate<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component, dateType: DateType). Use given")
    }

    func sort(samples: [Sample], by aggregationUnit: Calendar.Component) -> [(date: Date, samples: [Sample])] {
        addInvocation(.isort__samples_samplesby_aggregationUnit_1(Parameter<[Sample]>.value(samples), Parameter<Calendar.Component>.value(aggregationUnit)))
		let perform = methodPerformValue(.isort__samples_samplesby_aggregationUnit_1(Parameter<[Sample]>.value(samples), Parameter<Calendar.Component>.value(aggregationUnit))) as? ([Sample], Calendar.Component) -> Void
		perform?(samples, aggregationUnit)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isort__samples_samplesby_aggregationUnit_1(Parameter<[Sample]>.value(samples), Parameter<Calendar.Component>.value(aggregationUnit)))
		let value = givenValue.value as? [(date: Date, samples: [Sample])]
		return value.orFail("stub return value not specified for sort(samples: [Sample], by aggregationUnit: Calendar.Component). Use given")
    }

    func sort<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component) -> [(date: Date, samples: [SampleType])] {
        addInvocation(.isort__samples_samplesby_aggregationUnit_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<Calendar.Component>.value(aggregationUnit)))
		let perform = methodPerformValue(.isort__samples_samplesby_aggregationUnit_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<Calendar.Component>.value(aggregationUnit))) as? ([SampleType], Calendar.Component) -> Void
		perform?(samples, aggregationUnit)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isort__samples_samplesby_aggregationUnit_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<Calendar.Component>.value(aggregationUnit)))
		let value = givenValue.value as? [(date: Date, samples: [SampleType])]
		return value.orFail("stub return value not specified for sort<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component). Use given")
    }

    func sort(samples: [Sample], by dateType: DateType, in order: ComparisonResult) -> [Sample] {
        addInvocation(.isort__samples_samplesby_dateTypein_order_1(Parameter<[Sample]>.value(samples), Parameter<DateType>.value(dateType), Parameter<ComparisonResult>.value(order)))
		let perform = methodPerformValue(.isort__samples_samplesby_dateTypein_order_1(Parameter<[Sample]>.value(samples), Parameter<DateType>.value(dateType), Parameter<ComparisonResult>.value(order))) as? ([Sample], DateType, ComparisonResult) -> Void
		perform?(samples, dateType, order)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isort__samples_samplesby_dateTypein_order_1(Parameter<[Sample]>.value(samples), Parameter<DateType>.value(dateType), Parameter<ComparisonResult>.value(order)))
		let value = givenValue.value as? [Sample]
		return value.orFail("stub return value not specified for sort(samples: [Sample], by dateType: DateType, in order: ComparisonResult). Use given")
    }

    func sort<SampleType: Sample>(samples: [SampleType], by dateType: DateType, in order: ComparisonResult) -> [SampleType] {
        addInvocation(.isort__samples_samplesby_dateTypein_order_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<DateType>.value(dateType), Parameter<ComparisonResult>.value(order)))
		let perform = methodPerformValue(.isort__samples_samplesby_dateTypein_order_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<DateType>.value(dateType), Parameter<ComparisonResult>.value(order))) as? ([SampleType], DateType, ComparisonResult) -> Void
		perform?(samples, dateType, order)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isort__samples_samplesby_dateTypein_order_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<DateType>.value(dateType), Parameter<ComparisonResult>.value(order)))
		let value = givenValue.value as? [SampleType]
		return value.orFail("stub return value not specified for sort<SampleType: Sample>(samples: [SampleType], by dateType: DateType, in order: ComparisonResult). Use given")
    }

    func convertOneDateSamplesToTwoDateSamples(_ samples: [Sample], samplesShouldNotBeJoined: (Sample, Sample) -> Bool, joinSamples: ([Sample], Date, Date) -> Sample) -> [Sample] {
        addInvocation(.iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(Parameter<[Sample]>.value(samples), Parameter<(Sample, Sample) -> Bool>.any, Parameter<([Sample], Date, Date) -> Sample>.any))
		let perform = methodPerformValue(.iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(Parameter<[Sample]>.value(samples), Parameter<(Sample, Sample) -> Bool>.any, Parameter<([Sample], Date, Date) -> Sample>.any)) as? ([Sample], (Sample, Sample) -> Bool, ([Sample], Date, Date) -> Sample) -> Void
		perform?(samples, samplesShouldNotBeJoined, joinSamples)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(Parameter<[Sample]>.value(samples), Parameter<(Sample, Sample) -> Bool>.any, Parameter<([Sample], Date, Date) -> Sample>.any))
		let value = givenValue.value as? [Sample]
		return value.orFail("stub return value not specified for convertOneDateSamplesToTwoDateSamples(_ samples: [Sample], samplesShouldNotBeJoined: (Sample, Sample) -> Bool, joinSamples: ([Sample], Date, Date) -> Sample). Use given")
    }

    func convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(_ samples: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType) -> [SampleType] {
        addInvocation(.iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<(SampleType, SampleType) -> Bool>.any.wrapAsGeneric(), Parameter<([SampleType], Date, Date) -> SampleType>.any.wrapAsGeneric()))
		let perform = methodPerformValue(.iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<(SampleType, SampleType) -> Bool>.any.wrapAsGeneric(), Parameter<([SampleType], Date, Date) -> SampleType>.any.wrapAsGeneric())) as? ([SampleType], (SampleType, SampleType) -> Bool, ([SampleType], Date, Date) -> SampleType) -> Void
		perform?(samples, samplesShouldNotBeJoined, joinSamples)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(Parameter<[SampleType]>.value(samples).wrapAsGeneric(), Parameter<(SampleType, SampleType) -> Bool>.any.wrapAsGeneric(), Parameter<([SampleType], Date, Date) -> SampleType>.any.wrapAsGeneric()))
		let value = givenValue.value as? [SampleType]
		return value.orFail("stub return value not specified for convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(_ samples: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType). Use given")
    }

    func closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(sample: SampleType1, in samples: [SampleType2]) -> SampleType2 {
        addInvocation(.iclosestInTimeTo__sample_samplein_samples_1(Parameter<SampleType1>.value(sample).wrapAsGeneric(), Parameter<[SampleType2]>.value(samples).wrapAsGeneric()))
		let perform = methodPerformValue(.iclosestInTimeTo__sample_samplein_samples_1(Parameter<SampleType1>.value(sample).wrapAsGeneric(), Parameter<[SampleType2]>.value(samples).wrapAsGeneric())) as? (SampleType1, [SampleType2]) -> Void
		perform?(sample, samples)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iclosestInTimeTo__sample_samplein_samples_1(Parameter<SampleType1>.value(sample).wrapAsGeneric(), Parameter<[SampleType2]>.value(samples).wrapAsGeneric()))
		let value = givenValue.value as? SampleType2
		return value.orFail("stub return value not specified for closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(sample: SampleType1, in samples: [SampleType2]). Use given")
    }

    func closestInTimeTo(sample: Sample, in samples: [Sample]) -> Sample {
        addInvocation(.iclosestInTimeTo__sample_samplein_samples_2(Parameter<Sample>.value(sample), Parameter<[Sample]>.value(samples)))
		let perform = methodPerformValue(.iclosestInTimeTo__sample_samplein_samples_2(Parameter<Sample>.value(sample), Parameter<[Sample]>.value(samples))) as? (Sample, [Sample]) -> Void
		perform?(sample, samples)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iclosestInTimeTo__sample_samplein_samples_2(Parameter<Sample>.value(sample), Parameter<[Sample]>.value(samples)))
		let value = givenValue.value as? Sample
		return value.orFail("stub return value not specified for closestInTimeTo(sample: Sample, in samples: [Sample]). Use given")
    }

    func distance(between sample1: Sample, and sample2: Sample, in unit: Calendar.Component) -> Int {
        addInvocation(.idistance__between_sample1and_sample2in_unit(Parameter<Sample>.value(sample1), Parameter<Sample>.value(sample2), Parameter<Calendar.Component>.value(unit)))
		let perform = methodPerformValue(.idistance__between_sample1and_sample2in_unit(Parameter<Sample>.value(sample1), Parameter<Sample>.value(sample2), Parameter<Calendar.Component>.value(unit))) as? (Sample, Sample, Calendar.Component) -> Void
		perform?(sample1, sample2, unit)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.idistance__between_sample1and_sample2in_unit(Parameter<Sample>.value(sample1), Parameter<Sample>.value(sample2), Parameter<Calendar.Component>.value(unit)))
		let value = givenValue.value as? Int
		return value.orFail("stub return value not specified for distance(between sample1: Sample, and sample2: Sample, in unit: Calendar.Component). Use given")
    }

    fileprivate enum MethodType {
        case igetOnly__samples_samplesfrom_startDateto_endDate_1(Parameter<[Sample]>, Parameter<Date?>, Parameter<Date?>)
        case igetOnly__samples_samplesfrom_startDateto_endDate_2(Parameter<GenericAttribute>, Parameter<Date?>, Parameter<Date?>)
        case isample__sampleoccursOnOneOf_daysOfWeek(Parameter<Sample>, Parameter<Set<DayOfWeek>>)
        case iaggregate__samples_samplesby_aggregationUnitdateType_dateType_1(Parameter<[Sample]>, Parameter<Calendar.Component>, Parameter<DateType>)
        case iaggregate__samples_samplesby_aggregationUnitdateType_dateType_2(Parameter<GenericAttribute>, Parameter<Calendar.Component>, Parameter<DateType>)
        case isort__samples_samplesby_aggregationUnit_1(Parameter<[Sample]>, Parameter<Calendar.Component>)
        case isort__samples_samplesby_aggregationUnit_2(Parameter<GenericAttribute>, Parameter<Calendar.Component>)
        case isort__samples_samplesby_dateTypein_order_1(Parameter<[Sample]>, Parameter<DateType>, Parameter<ComparisonResult>)
        case isort__samples_samplesby_dateTypein_order_2(Parameter<GenericAttribute>, Parameter<DateType>, Parameter<ComparisonResult>)
        case iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(Parameter<[Sample]>, Parameter<(Sample, Sample) -> Bool>, Parameter<([Sample], Date, Date) -> Sample>)
        case iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(Parameter<GenericAttribute>, Parameter<GenericAttribute>, Parameter<GenericAttribute>)
        case iclosestInTimeTo__sample_samplein_samples_1(Parameter<GenericAttribute>, Parameter<GenericAttribute>)
        case iclosestInTimeTo__sample_samplein_samples_2(Parameter<Sample>, Parameter<[Sample]>)
        case idistance__between_sample1and_sample2in_unit(Parameter<Sample>, Parameter<Sample>, Parameter<Calendar.Component>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.igetOnly__samples_samplesfrom_startDateto_endDate_1(let lhsSamples, let lhsStartdate, let lhsEnddate), .igetOnly__samples_samplesfrom_startDateto_endDate_1(let rhsSamples, let rhsStartdate, let rhsEnddate)):
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher) else { return false } 
                    return true 
                case (.igetOnly__samples_samplesfrom_startDateto_endDate_2(let lhsSamples, let lhsStartdate, let lhsEnddate), .igetOnly__samples_samplesfrom_startDateto_endDate_2(let rhsSamples, let rhsStartdate, let rhsEnddate)):
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher) else { return false } 
                    return true 
                case (.isample__sampleoccursOnOneOf_daysOfWeek(let lhsSample, let lhsDaysofweek), .isample__sampleoccursOnOneOf_daysOfWeek(let rhsSample, let rhsDaysofweek)):
                    guard Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDaysofweek, rhs: rhsDaysofweek, with: matcher) else { return false } 
                    return true 
                case (.iaggregate__samples_samplesby_aggregationUnitdateType_dateType_1(let lhsSamples, let lhsAggregationunit, let lhsDatetype), .iaggregate__samples_samplesby_aggregationUnitdateType_dateType_1(let rhsSamples, let rhsAggregationunit, let rhsDatetype)):
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDatetype, rhs: rhsDatetype, with: matcher) else { return false } 
                    return true 
                case (.iaggregate__samples_samplesby_aggregationUnitdateType_dateType_2(let lhsSamples, let lhsAggregationunit, let lhsDatetype), .iaggregate__samples_samplesby_aggregationUnitdateType_dateType_2(let rhsSamples, let rhsAggregationunit, let rhsDatetype)):
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDatetype, rhs: rhsDatetype, with: matcher) else { return false } 
                    return true 
                case (.isort__samples_samplesby_aggregationUnit_1(let lhsSamples, let lhsAggregationunit), .isort__samples_samplesby_aggregationUnit_1(let rhsSamples, let rhsAggregationunit)):
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                    return true 
                case (.isort__samples_samplesby_aggregationUnit_2(let lhsSamples, let lhsAggregationunit), .isort__samples_samplesby_aggregationUnit_2(let rhsSamples, let rhsAggregationunit)):
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                    return true 
                case (.isort__samples_samplesby_dateTypein_order_1(let lhsSamples, let lhsDatetype, let lhsOrder), .isort__samples_samplesby_dateTypein_order_1(let rhsSamples, let rhsDatetype, let rhsOrder)):
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDatetype, rhs: rhsDatetype, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsOrder, rhs: rhsOrder, with: matcher) else { return false } 
                    return true 
                case (.isort__samples_samplesby_dateTypein_order_2(let lhsSamples, let lhsDatetype, let lhsOrder), .isort__samples_samplesby_dateTypein_order_2(let rhsSamples, let rhsDatetype, let rhsOrder)):
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDatetype, rhs: rhsDatetype, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsOrder, rhs: rhsOrder, with: matcher) else { return false } 
                    return true 
                case (.iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(let lhsSamples, let lhsSamplesshouldnotbejoined, let lhsJoinsamples), .iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(let rhsSamples, let rhsSamplesshouldnotbejoined, let rhsJoinsamples)):
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamplesshouldnotbejoined, rhs: rhsSamplesshouldnotbejoined, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsJoinsamples, rhs: rhsJoinsamples, with: matcher) else { return false } 
                    return true 
                case (.iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(let lhsSamples, let lhsSamplesshouldnotbejoined, let lhsJoinsamples), .iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(let rhsSamples, let rhsSamplesshouldnotbejoined, let rhsJoinsamples)):
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamplesshouldnotbejoined, rhs: rhsSamplesshouldnotbejoined, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsJoinsamples, rhs: rhsJoinsamples, with: matcher) else { return false } 
                    return true 
                case (.iclosestInTimeTo__sample_samplein_samples_1(let lhsSample, let lhsSamples), .iclosestInTimeTo__sample_samplein_samples_1(let rhsSample, let rhsSamples)):
                    guard Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    return true 
                case (.iclosestInTimeTo__sample_samplein_samples_2(let lhsSample, let lhsSamples), .iclosestInTimeTo__sample_samplein_samples_2(let rhsSample, let rhsSamples)):
                    guard Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                    return true 
                case (.idistance__between_sample1and_sample2in_unit(let lhsSample1, let lhsSample2, let lhsUnit), .idistance__between_sample1and_sample2in_unit(let rhsSample1, let rhsSample2, let rhsUnit)):
                    guard Parameter.compare(lhs: lhsSample1, rhs: rhsSample1, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsSample2, rhs: rhsSample2, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsUnit, rhs: rhsUnit, with: matcher) else { return false } 
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .igetOnly__samples_samplesfrom_startDateto_endDate_1(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .igetOnly__samples_samplesfrom_startDateto_endDate_2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .isample__sampleoccursOnOneOf_daysOfWeek(p0, p1): return p0.intValue + p1.intValue
                case let .iaggregate__samples_samplesby_aggregationUnitdateType_dateType_1(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .iaggregate__samples_samplesby_aggregationUnitdateType_dateType_2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .isort__samples_samplesby_aggregationUnit_1(p0, p1): return p0.intValue + p1.intValue
                case let .isort__samples_samplesby_aggregationUnit_2(p0, p1): return p0.intValue + p1.intValue
                case let .isort__samples_samplesby_dateTypein_order_1(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .isort__samples_samplesby_dateTypein_order_2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .iclosestInTimeTo__sample_samplein_samples_1(p0, p1): return p0.intValue + p1.intValue
                case let .iclosestInTimeTo__sample_samplein_samples_2(p0, p1): return p0.intValue + p1.intValue
                case let .idistance__between_sample1and_sample2in_unit(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
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

        static func getOnly(samples: Parameter<[Sample]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, willReturn: [Sample]) -> Given {
            return Given(method: .igetOnly__samples_samplesfrom_startDateto_endDate_1(samples, startDate, endDate), returns: willReturn, throws: nil)
        }
        static func getOnly<SampleType: Sample>(samples: Parameter<[SampleType]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, willReturn: [SampleType]) -> Given {
            return Given(method: .igetOnly__samples_samplesfrom_startDateto_endDate_2(samples.wrapAsGeneric(), startDate, endDate), returns: willReturn, throws: nil)
        }
        static func sample(sample: Parameter<Sample>, occursOnOneOf daysOfWeek: Parameter<Set<DayOfWeek>>, willReturn: Bool) -> Given {
            return Given(method: .isample__sampleoccursOnOneOf_daysOfWeek(sample, daysOfWeek), returns: willReturn, throws: nil)
        }
        static func aggregate(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, dateType: Parameter<DateType>, willReturn: [Date: [Sample]]) -> Given {
            return Given(method: .iaggregate__samples_samplesby_aggregationUnitdateType_dateType_1(samples, aggregationUnit, dateType), returns: willReturn, throws: nil)
        }
        static func aggregate<SampleType: Sample>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, dateType: Parameter<DateType>, willReturn: [Date: [SampleType]]) -> Given {
            return Given(method: .iaggregate__samples_samplesby_aggregationUnitdateType_dateType_2(samples.wrapAsGeneric(), aggregationUnit, dateType), returns: willReturn, throws: nil)
        }
        static func sort(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, willReturn: [(date: Date, samples: [Sample])]) -> Given {
            return Given(method: .isort__samples_samplesby_aggregationUnit_1(samples, aggregationUnit), returns: willReturn, throws: nil)
        }
        static func sort<SampleType: Sample>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, willReturn: [(date: Date, samples: [SampleType])]) -> Given {
            return Given(method: .isort__samples_samplesby_aggregationUnit_2(samples.wrapAsGeneric(), aggregationUnit), returns: willReturn, throws: nil)
        }
        static func sort(samples: Parameter<[Sample]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>, willReturn: [Sample]) -> Given {
            return Given(method: .isort__samples_samplesby_dateTypein_order_1(samples, dateType, order), returns: willReturn, throws: nil)
        }
        static func sort<SampleType: Sample>(samples: Parameter<[SampleType]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>, willReturn: [SampleType]) -> Given {
            return Given(method: .isort__samples_samplesby_dateTypein_order_2(samples.wrapAsGeneric(), dateType, order), returns: willReturn, throws: nil)
        }
        static func convertOneDateSamplesToTwoDateSamples(samples: Parameter<[Sample]>, samplesShouldNotBeJoined: Parameter<(Sample, Sample) -> Bool>, joinSamples: Parameter<([Sample], Date, Date) -> Sample>, willReturn: [Sample]) -> Given {
            return Given(method: .iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(samples, samplesShouldNotBeJoined, joinSamples), returns: willReturn, throws: nil)
        }
        static func convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(samples: Parameter<[SampleType]>, samplesShouldNotBeJoined: Parameter<(SampleType, SampleType) -> Bool>, joinSamples: Parameter<([SampleType], Date, Date) -> SampleType>, willReturn: [SampleType]) -> Given {
            return Given(method: .iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(samples.wrapAsGeneric(), samplesShouldNotBeJoined.wrapAsGeneric(), joinSamples.wrapAsGeneric()), returns: willReturn, throws: nil)
        }
        static func closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(sample: Parameter<SampleType1>, in samples: Parameter<[SampleType2]>, willReturn: SampleType2) -> Given {
            return Given(method: .iclosestInTimeTo__sample_samplein_samples_1(sample.wrapAsGeneric(), samples.wrapAsGeneric()), returns: willReturn, throws: nil)
        }
        static func closestInTimeTo(sample: Parameter<Sample>, in samples: Parameter<[Sample]>, willReturn: Sample) -> Given {
            return Given(method: .iclosestInTimeTo__sample_samplein_samples_2(sample, samples), returns: willReturn, throws: nil)
        }
        static func distance(between sample1: Parameter<Sample>, and sample2: Parameter<Sample>, in unit: Parameter<Calendar.Component>, willReturn: Int) -> Given {
            return Given(method: .idistance__between_sample1and_sample2in_unit(sample1, sample2, unit), returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func getOnly(samples: Parameter<[Sample]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>) -> Verify {
            return Verify(method: .igetOnly__samples_samplesfrom_startDateto_endDate_1(samples, startDate, endDate))
        }
        static func getOnly<SampleType>(samples: Parameter<[SampleType]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>) -> Verify {
            return Verify(method: .igetOnly__samples_samplesfrom_startDateto_endDate_2(samples.wrapAsGeneric(), startDate, endDate))
        }
        static func sample(sample: Parameter<Sample>, occursOnOneOf daysOfWeek: Parameter<Set<DayOfWeek>>) -> Verify {
            return Verify(method: .isample__sampleoccursOnOneOf_daysOfWeek(sample, daysOfWeek))
        }
        static func aggregate(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, dateType: Parameter<DateType>) -> Verify {
            return Verify(method: .iaggregate__samples_samplesby_aggregationUnitdateType_dateType_1(samples, aggregationUnit, dateType))
        }
        static func aggregate<SampleType>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, dateType: Parameter<DateType>) -> Verify {
            return Verify(method: .iaggregate__samples_samplesby_aggregationUnitdateType_dateType_2(samples.wrapAsGeneric(), aggregationUnit, dateType))
        }
        static func sort(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>) -> Verify {
            return Verify(method: .isort__samples_samplesby_aggregationUnit_1(samples, aggregationUnit))
        }
        static func sort<SampleType>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>) -> Verify {
            return Verify(method: .isort__samples_samplesby_aggregationUnit_2(samples.wrapAsGeneric(), aggregationUnit))
        }
        static func sort(samples: Parameter<[Sample]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>) -> Verify {
            return Verify(method: .isort__samples_samplesby_dateTypein_order_1(samples, dateType, order))
        }
        static func sort<SampleType>(samples: Parameter<[SampleType]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>) -> Verify {
            return Verify(method: .isort__samples_samplesby_dateTypein_order_2(samples.wrapAsGeneric(), dateType, order))
        }
        static func convertOneDateSamplesToTwoDateSamples(samples: Parameter<[Sample]>, samplesShouldNotBeJoined: Parameter<(Sample, Sample) -> Bool>, joinSamples: Parameter<([Sample], Date, Date) -> Sample>) -> Verify {
            return Verify(method: .iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(samples, samplesShouldNotBeJoined, joinSamples))
        }
        static func convertOneDateSamplesToTwoDateSamples<SampleType>(samples: Parameter<[SampleType]>, samplesShouldNotBeJoined: Parameter<(SampleType, SampleType) -> Bool>, joinSamples: Parameter<([SampleType], Date, Date) -> SampleType>) -> Verify {
            return Verify(method: .iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(samples.wrapAsGeneric(), samplesShouldNotBeJoined.wrapAsGeneric(), joinSamples.wrapAsGeneric()))
        }
        static func closestInTimeTo<SampleType1,SampleType2>(sample: Parameter<SampleType1>, in samples: Parameter<[SampleType2]>) -> Verify {
            return Verify(method: .iclosestInTimeTo__sample_samplein_samples_1(sample.wrapAsGeneric(), samples.wrapAsGeneric()))
        }
        static func closestInTimeTo(sample: Parameter<Sample>, in samples: Parameter<[Sample]>) -> Verify {
            return Verify(method: .iclosestInTimeTo__sample_samplein_samples_2(sample, samples))
        }
        static func distance(between sample1: Parameter<Sample>, and sample2: Parameter<Sample>, in unit: Parameter<Calendar.Component>) -> Verify {
            return Verify(method: .idistance__between_sample1and_sample2in_unit(sample1, sample2, unit))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func getOnly(samples: Parameter<[Sample]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, perform: ([Sample], Date?, Date?) -> Void) -> Perform {
            return Perform(method: .igetOnly__samples_samplesfrom_startDateto_endDate_1(samples, startDate, endDate), performs: perform)
        }
        static func getOnly<SampleType>(samples: Parameter<[SampleType]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, perform: ([SampleType], Date?, Date?) -> Void) -> Perform {
            return Perform(method: .igetOnly__samples_samplesfrom_startDateto_endDate_2(samples.wrapAsGeneric(), startDate, endDate), performs: perform)
        }
        static func sample(sample: Parameter<Sample>, occursOnOneOf daysOfWeek: Parameter<Set<DayOfWeek>>, perform: (Sample, Set<DayOfWeek>) -> Void) -> Perform {
            return Perform(method: .isample__sampleoccursOnOneOf_daysOfWeek(sample, daysOfWeek), performs: perform)
        }
        static func aggregate(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, dateType: Parameter<DateType>, perform: ([Sample], Calendar.Component, DateType) -> Void) -> Perform {
            return Perform(method: .iaggregate__samples_samplesby_aggregationUnitdateType_dateType_1(samples, aggregationUnit, dateType), performs: perform)
        }
        static func aggregate<SampleType>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, dateType: Parameter<DateType>, perform: ([SampleType], Calendar.Component, DateType) -> Void) -> Perform {
            return Perform(method: .iaggregate__samples_samplesby_aggregationUnitdateType_dateType_2(samples.wrapAsGeneric(), aggregationUnit, dateType), performs: perform)
        }
        static func sort(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, perform: ([Sample], Calendar.Component) -> Void) -> Perform {
            return Perform(method: .isort__samples_samplesby_aggregationUnit_1(samples, aggregationUnit), performs: perform)
        }
        static func sort<SampleType>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, perform: ([SampleType], Calendar.Component) -> Void) -> Perform {
            return Perform(method: .isort__samples_samplesby_aggregationUnit_2(samples.wrapAsGeneric(), aggregationUnit), performs: perform)
        }
        static func sort(samples: Parameter<[Sample]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>, perform: ([Sample], DateType, ComparisonResult) -> Void) -> Perform {
            return Perform(method: .isort__samples_samplesby_dateTypein_order_1(samples, dateType, order), performs: perform)
        }
        static func sort<SampleType>(samples: Parameter<[SampleType]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>, perform: ([SampleType], DateType, ComparisonResult) -> Void) -> Perform {
            return Perform(method: .isort__samples_samplesby_dateTypein_order_2(samples.wrapAsGeneric(), dateType, order), performs: perform)
        }
        static func convertOneDateSamplesToTwoDateSamples(samples: Parameter<[Sample]>, samplesShouldNotBeJoined: Parameter<(Sample, Sample) -> Bool>, joinSamples: Parameter<([Sample], Date, Date) -> Sample>, perform: ([Sample], (Sample, Sample) -> Bool, ([Sample], Date, Date) -> Sample) -> Void) -> Perform {
            return Perform(method: .iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(samples, samplesShouldNotBeJoined, joinSamples), performs: perform)
        }
        static func convertOneDateSamplesToTwoDateSamples<SampleType>(samples: Parameter<[SampleType]>, samplesShouldNotBeJoined: Parameter<(SampleType, SampleType) -> Bool>, joinSamples: Parameter<([SampleType], Date, Date) -> SampleType>, perform: ([SampleType], (SampleType, SampleType) -> Bool, ([SampleType], Date, Date) -> SampleType) -> Void) -> Perform {
            return Perform(method: .iconvertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(samples.wrapAsGeneric(), samplesShouldNotBeJoined.wrapAsGeneric(), joinSamples.wrapAsGeneric()), performs: perform)
        }
        static func closestInTimeTo<SampleType1,SampleType2>(sample: Parameter<SampleType1>, in samples: Parameter<[SampleType2]>, perform: (SampleType1, [SampleType2]) -> Void) -> Perform {
            return Perform(method: .iclosestInTimeTo__sample_samplein_samples_1(sample.wrapAsGeneric(), samples.wrapAsGeneric()), performs: perform)
        }
        static func closestInTimeTo(sample: Parameter<Sample>, in samples: Parameter<[Sample]>, perform: (Sample, [Sample]) -> Void) -> Perform {
            return Perform(method: .iclosestInTimeTo__sample_samplein_samples_2(sample, samples), performs: perform)
        }
        static func distance(between sample1: Parameter<Sample>, and sample2: Parameter<Sample>, in unit: Parameter<Calendar.Component>, perform: (Sample, Sample, Calendar.Component) -> Void) -> Perform {
            return Perform(method: .idistance__between_sample1and_sample2in_unit(sample1, sample2, unit), performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - SearchUtil
class SearchUtilMock: SearchUtil, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func binarySearch<T:Comparable>(for targetItem: T, in items: Array<T>) -> Int? {
        addInvocation(.ibinarySearch__for_targetItemin_items(Parameter<T>.value(targetItem).wrapAsGeneric(), Parameter<Array<T>>.value(items).wrapAsGeneric()))
		let perform = methodPerformValue(.ibinarySearch__for_targetItemin_items(Parameter<T>.value(targetItem).wrapAsGeneric(), Parameter<Array<T>>.value(items).wrapAsGeneric())) as? (T, Array<T>) -> Void
		perform?(targetItem, items)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.ibinarySearch__for_targetItemin_items(Parameter<T>.value(targetItem).wrapAsGeneric(), Parameter<Array<T>>.value(items).wrapAsGeneric()))
		let value = givenValue.value as? Int?
		return value.orFail("stub return value not specified for binarySearch<T:Comparable>(for targetItem: T, in items: Array<T>). Use given")
    }

    func binarySearch<T>(for targetItem: T, in items: Array<T>, compare: (T, T) -> ComparisonResult) -> Int? {
        addInvocation(.ibinarySearch__for_targetItemin_itemscompare_compare(Parameter<T>.value(targetItem).wrapAsGeneric(), Parameter<Array<T>>.value(items).wrapAsGeneric(), Parameter<(T, T) -> ComparisonResult>.any.wrapAsGeneric()))
		let perform = methodPerformValue(.ibinarySearch__for_targetItemin_itemscompare_compare(Parameter<T>.value(targetItem).wrapAsGeneric(), Parameter<Array<T>>.value(items).wrapAsGeneric(), Parameter<(T, T) -> ComparisonResult>.any.wrapAsGeneric())) as? (T, Array<T>, (T, T) -> ComparisonResult) -> Void
		perform?(targetItem, items, compare)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.ibinarySearch__for_targetItemin_itemscompare_compare(Parameter<T>.value(targetItem).wrapAsGeneric(), Parameter<Array<T>>.value(items).wrapAsGeneric(), Parameter<(T, T) -> ComparisonResult>.any.wrapAsGeneric()))
		let value = givenValue.value as? Int?
		return value.orFail("stub return value not specified for binarySearch<T>(for targetItem: T, in items: Array<T>, compare: (T, T) -> ComparisonResult). Use given")
    }

    func closestItem<T>(to targetItem: T, in items: Array<T>, distance: (T, T) -> Int) -> T {
        addInvocation(.iclosestItem__to_targetItemin_itemsdistance_distance(Parameter<T>.value(targetItem).wrapAsGeneric(), Parameter<Array<T>>.value(items).wrapAsGeneric(), Parameter<(T, T) -> Int>.any.wrapAsGeneric()))
		let perform = methodPerformValue(.iclosestItem__to_targetItemin_itemsdistance_distance(Parameter<T>.value(targetItem).wrapAsGeneric(), Parameter<Array<T>>.value(items).wrapAsGeneric(), Parameter<(T, T) -> Int>.any.wrapAsGeneric())) as? (T, Array<T>, (T, T) -> Int) -> Void
		perform?(targetItem, items, distance)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iclosestItem__to_targetItemin_itemsdistance_distance(Parameter<T>.value(targetItem).wrapAsGeneric(), Parameter<Array<T>>.value(items).wrapAsGeneric(), Parameter<(T, T) -> Int>.any.wrapAsGeneric()))
		let value = givenValue.value as? T
		return value.orFail("stub return value not specified for closestItem<T>(to targetItem: T, in items: Array<T>, distance: (T, T) -> Int). Use given")
    }

    fileprivate enum MethodType {
        case ibinarySearch__for_targetItemin_items(Parameter<GenericAttribute>, Parameter<GenericAttribute>)
        case ibinarySearch__for_targetItemin_itemscompare_compare(Parameter<GenericAttribute>, Parameter<GenericAttribute>, Parameter<GenericAttribute>)
        case iclosestItem__to_targetItemin_itemsdistance_distance(Parameter<GenericAttribute>, Parameter<GenericAttribute>, Parameter<GenericAttribute>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.ibinarySearch__for_targetItemin_items(let lhsTargetitem, let lhsItems), .ibinarySearch__for_targetItemin_items(let rhsTargetitem, let rhsItems)):
                    guard Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher) else { return false } 
                    return true 
                case (.ibinarySearch__for_targetItemin_itemscompare_compare(let lhsTargetitem, let lhsItems, let lhsCompare), .ibinarySearch__for_targetItemin_itemscompare_compare(let rhsTargetitem, let rhsItems, let rhsCompare)):
                    guard Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsCompare, rhs: rhsCompare, with: matcher) else { return false } 
                    return true 
                case (.iclosestItem__to_targetItemin_itemsdistance_distance(let lhsTargetitem, let lhsItems, let lhsDistance), .iclosestItem__to_targetItemin_itemsdistance_distance(let rhsTargetitem, let rhsItems, let rhsDistance)):
                    guard Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher) else { return false } 
                    guard Parameter.compare(lhs: lhsDistance, rhs: rhsDistance, with: matcher) else { return false } 
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .ibinarySearch__for_targetItemin_items(p0, p1): return p0.intValue + p1.intValue
                case let .ibinarySearch__for_targetItemin_itemscompare_compare(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
                case let .iclosestItem__to_targetItemin_itemsdistance_distance(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
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

        static func binarySearch<T:Comparable>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, willReturn: Int?) -> Given {
            return Given(method: .ibinarySearch__for_targetItemin_items(targetItem.wrapAsGeneric(), items.wrapAsGeneric()), returns: willReturn, throws: nil)
        }
        static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, compare: Parameter<(T, T) -> ComparisonResult>, willReturn: Int?) -> Given {
            return Given(method: .ibinarySearch__for_targetItemin_itemscompare_compare(targetItem.wrapAsGeneric(), items.wrapAsGeneric(), compare.wrapAsGeneric()), returns: willReturn, throws: nil)
        }
        static func closestItem<T>(to targetItem: Parameter<T>, in items: Parameter<Array<T>>, distance: Parameter<(T, T) -> Int>, willReturn: T) -> Given {
            return Given(method: .iclosestItem__to_targetItemin_itemsdistance_distance(targetItem.wrapAsGeneric(), items.wrapAsGeneric(), distance.wrapAsGeneric()), returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>) -> Verify {
            return Verify(method: .ibinarySearch__for_targetItemin_items(targetItem.wrapAsGeneric(), items.wrapAsGeneric()))
        }
        static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, compare: Parameter<(T, T) -> ComparisonResult>) -> Verify {
            return Verify(method: .ibinarySearch__for_targetItemin_itemscompare_compare(targetItem.wrapAsGeneric(), items.wrapAsGeneric(), compare.wrapAsGeneric()))
        }
        static func closestItem<T>(to targetItem: Parameter<T>, in items: Parameter<Array<T>>, distance: Parameter<(T, T) -> Int>) -> Verify {
            return Verify(method: .iclosestItem__to_targetItemin_itemsdistance_distance(targetItem.wrapAsGeneric(), items.wrapAsGeneric(), distance.wrapAsGeneric()))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, perform: (T, Array<T>) -> Void) -> Perform {
            return Perform(method: .ibinarySearch__for_targetItemin_items(targetItem.wrapAsGeneric(), items.wrapAsGeneric()), performs: perform)
        }
        static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, compare: Parameter<(T, T) -> ComparisonResult>, perform: (T, Array<T>, (T, T) -> ComparisonResult) -> Void) -> Perform {
            return Perform(method: .ibinarySearch__for_targetItemin_itemscompare_compare(targetItem.wrapAsGeneric(), items.wrapAsGeneric(), compare.wrapAsGeneric()), performs: perform)
        }
        static func closestItem<T>(to targetItem: Parameter<T>, in items: Parameter<Array<T>>, distance: Parameter<(T, T) -> Int>, perform: (T, Array<T>, (T, T) -> Int) -> Void) -> Perform {
            return Perform(method: .iclosestItem__to_targetItemin_itemsdistance_distance(targetItem.wrapAsGeneric(), items.wrapAsGeneric(), distance.wrapAsGeneric()), performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - StringUtil
class StringUtilMock: StringUtil, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func isNumber(_ str: String) -> Bool {
        addInvocation(.iisNumber__str(Parameter<String>.value(str)))
		let perform = methodPerformValue(.iisNumber__str(Parameter<String>.value(str))) as? (String) -> Void
		perform?(str)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iisNumber__str(Parameter<String>.value(str)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for isNumber(_ str: String). Use given")
    }

    func isInteger(_ str: String) -> Bool {
        addInvocation(.iisInteger__str(Parameter<String>.value(str)))
		let perform = methodPerformValue(.iisInteger__str(Parameter<String>.value(str))) as? (String) -> Void
		perform?(str)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iisInteger__str(Parameter<String>.value(str)))
		let value = givenValue.value as? Bool
		return value.orFail("stub return value not specified for isInteger(_ str: String). Use given")
    }

    fileprivate enum MethodType {
        case iisNumber__str(Parameter<String>)
        case iisInteger__str(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.iisNumber__str(let lhsStr), .iisNumber__str(let rhsStr)):
                    guard Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher) else { return false } 
                    return true 
                case (.iisInteger__str(let lhsStr), .iisInteger__str(let rhsStr)):
                    guard Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher) else { return false } 
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .iisNumber__str(p0): return p0.intValue
                case let .iisInteger__str(p0): return p0.intValue
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

        static func isNumber(str: Parameter<String>, willReturn: Bool) -> Given {
            return Given(method: .iisNumber__str(str), returns: willReturn, throws: nil)
        }
        static func isInteger(str: Parameter<String>, willReturn: Bool) -> Given {
            return Given(method: .iisInteger__str(str), returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func isNumber(str: Parameter<String>) -> Verify {
            return Verify(method: .iisNumber__str(str))
        }
        static func isInteger(str: Parameter<String>) -> Verify {
            return Verify(method: .iisInteger__str(str))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func isNumber(str: Parameter<String>, perform: (String) -> Void) -> Perform {
            return Perform(method: .iisNumber__str(str), performs: perform)
        }
        static func isInteger(str: Parameter<String>, perform: (String) -> Void) -> Perform {
            return Perform(method: .iisInteger__str(str), performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - SubQueryMatcherFactory
class SubQueryMatcherFactoryMock: SubQueryMatcherFactory, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func withinXCalendarUnitsSubQueryMatcher() -> WithinXCalendarUnitsSubQueryMatcher {
        addInvocation(.iwithinXCalendarUnitsSubQueryMatcher)
		let perform = methodPerformValue(.iwithinXCalendarUnitsSubQueryMatcher) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iwithinXCalendarUnitsSubQueryMatcher)
		let value = givenValue.value as? WithinXCalendarUnitsSubQueryMatcher
		return value.orFail("stub return value not specified for withinXCalendarUnitsSubQueryMatcher(). Use given")
    }

    func inSameCalendarUnitSubQueryMatcher() -> InSameCalendarUnitSubQueryMatcher {
        addInvocation(.iinSameCalendarUnitSubQueryMatcher)
		let perform = methodPerformValue(.iinSameCalendarUnitSubQueryMatcher) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iinSameCalendarUnitSubQueryMatcher)
		let value = givenValue.value as? InSameCalendarUnitSubQueryMatcher
		return value.orFail("stub return value not specified for inSameCalendarUnitSubQueryMatcher(). Use given")
    }

    func sameDatesSubQueryMatcher() -> SameDatesSubQueryMatcher {
        addInvocation(.isameDatesSubQueryMatcher)
		let perform = methodPerformValue(.isameDatesSubQueryMatcher) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isameDatesSubQueryMatcher)
		let value = givenValue.value as? SameDatesSubQueryMatcher
		return value.orFail("stub return value not specified for sameDatesSubQueryMatcher(). Use given")
    }

    func sameStartDatesSubQueryMatcher() -> SameStartDatesSubQueryMatcher {
        addInvocation(.isameStartDatesSubQueryMatcher)
		let perform = methodPerformValue(.isameStartDatesSubQueryMatcher) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isameStartDatesSubQueryMatcher)
		let value = givenValue.value as? SameStartDatesSubQueryMatcher
		return value.orFail("stub return value not specified for sameStartDatesSubQueryMatcher(). Use given")
    }

    func sameEndDatesSubQueryMatcher() -> SameEndDatesSubQueryMatcher {
        addInvocation(.isameEndDatesSubQueryMatcher)
		let perform = methodPerformValue(.isameEndDatesSubQueryMatcher) as? () -> Void
		perform?()
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.isameEndDatesSubQueryMatcher)
		let value = givenValue.value as? SameEndDatesSubQueryMatcher
		return value.orFail("stub return value not specified for sameEndDatesSubQueryMatcher(). Use given")
    }

    fileprivate enum MethodType {
        case iwithinXCalendarUnitsSubQueryMatcher
        case iinSameCalendarUnitSubQueryMatcher
        case isameDatesSubQueryMatcher
        case isameStartDatesSubQueryMatcher
        case isameEndDatesSubQueryMatcher

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.iwithinXCalendarUnitsSubQueryMatcher, .iwithinXCalendarUnitsSubQueryMatcher):
                    return true 
                case (.iinSameCalendarUnitSubQueryMatcher, .iinSameCalendarUnitSubQueryMatcher):
                    return true 
                case (.isameDatesSubQueryMatcher, .isameDatesSubQueryMatcher):
                    return true 
                case (.isameStartDatesSubQueryMatcher, .isameStartDatesSubQueryMatcher):
                    return true 
                case (.isameEndDatesSubQueryMatcher, .isameEndDatesSubQueryMatcher):
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case .iwithinXCalendarUnitsSubQueryMatcher: return 0
                case .iinSameCalendarUnitSubQueryMatcher: return 0
                case .isameDatesSubQueryMatcher: return 0
                case .isameStartDatesSubQueryMatcher: return 0
                case .isameEndDatesSubQueryMatcher: return 0
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

        static func withinXCalendarUnitsSubQueryMatcher(willReturn: WithinXCalendarUnitsSubQueryMatcher) -> Given {
            return Given(method: .iwithinXCalendarUnitsSubQueryMatcher, returns: willReturn, throws: nil)
        }
        static func inSameCalendarUnitSubQueryMatcher(willReturn: InSameCalendarUnitSubQueryMatcher) -> Given {
            return Given(method: .iinSameCalendarUnitSubQueryMatcher, returns: willReturn, throws: nil)
        }
        static func sameDatesSubQueryMatcher(willReturn: SameDatesSubQueryMatcher) -> Given {
            return Given(method: .isameDatesSubQueryMatcher, returns: willReturn, throws: nil)
        }
        static func sameStartDatesSubQueryMatcher(willReturn: SameStartDatesSubQueryMatcher) -> Given {
            return Given(method: .isameStartDatesSubQueryMatcher, returns: willReturn, throws: nil)
        }
        static func sameEndDatesSubQueryMatcher(willReturn: SameEndDatesSubQueryMatcher) -> Given {
            return Given(method: .isameEndDatesSubQueryMatcher, returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func withinXCalendarUnitsSubQueryMatcher() -> Verify {
            return Verify(method: .iwithinXCalendarUnitsSubQueryMatcher)
        }
        static func inSameCalendarUnitSubQueryMatcher() -> Verify {
            return Verify(method: .iinSameCalendarUnitSubQueryMatcher)
        }
        static func sameDatesSubQueryMatcher() -> Verify {
            return Verify(method: .isameDatesSubQueryMatcher)
        }
        static func sameStartDatesSubQueryMatcher() -> Verify {
            return Verify(method: .isameStartDatesSubQueryMatcher)
        }
        static func sameEndDatesSubQueryMatcher() -> Verify {
            return Verify(method: .isameEndDatesSubQueryMatcher)
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func withinXCalendarUnitsSubQueryMatcher(perform: () -> Void) -> Perform {
            return Perform(method: .iwithinXCalendarUnitsSubQueryMatcher, performs: perform)
        }
        static func inSameCalendarUnitSubQueryMatcher(perform: () -> Void) -> Perform {
            return Perform(method: .iinSameCalendarUnitSubQueryMatcher, performs: perform)
        }
        static func sameDatesSubQueryMatcher(perform: () -> Void) -> Perform {
            return Perform(method: .isameDatesSubQueryMatcher, performs: perform)
        }
        static func sameStartDatesSubQueryMatcher(perform: () -> Void) -> Perform {
            return Perform(method: .isameStartDatesSubQueryMatcher, performs: perform)
        }
        static func sameEndDatesSubQueryMatcher(perform: () -> Void) -> Perform {
            return Perform(method: .isameEndDatesSubQueryMatcher, performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

// MARK: - TextNormalizationUtil
class TextNormalizationUtilMock: TextNormalizationUtil, Mock {
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    var matcher: Matcher = Matcher.default


    typealias Property = Swift.Never


    func expandContractions(_ text: String) -> String {
        addInvocation(.iexpandContractions__text(Parameter<String>.value(text)))
		let perform = methodPerformValue(.iexpandContractions__text(Parameter<String>.value(text))) as? (String) -> Void
		perform?(text)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iexpandContractions__text(Parameter<String>.value(text)))
		let value = givenValue.value as? String
		return value.orFail("stub return value not specified for expandContractions(_ text: String). Use given")
    }

    func normalizeNumbers(_ text: String) -> String {
        addInvocation(.inormalizeNumbers__text(Parameter<String>.value(text)))
		let perform = methodPerformValue(.inormalizeNumbers__text(Parameter<String>.value(text))) as? (String) -> Void
		perform?(text)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.inormalizeNumbers__text(Parameter<String>.value(text)))
		let value = givenValue.value as? String
		return value.orFail("stub return value not specified for normalizeNumbers(_ text: String). Use given")
    }

    func removePunctuation(_ text: String) -> String {
        addInvocation(.iremovePunctuation__text(Parameter<String>.value(text)))
		let perform = methodPerformValue(.iremovePunctuation__text(Parameter<String>.value(text))) as? (String) -> Void
		perform?(text)
		let givenValue: (value: Any?, error: Error?) = methodReturnValue(.iremovePunctuation__text(Parameter<String>.value(text)))
		let value = givenValue.value as? String
		return value.orFail("stub return value not specified for removePunctuation(_ text: String). Use given")
    }

    fileprivate enum MethodType {
        case iexpandContractions__text(Parameter<String>)
        case inormalizeNumbers__text(Parameter<String>)
        case iremovePunctuation__text(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
                case (.iexpandContractions__text(let lhsText), .iexpandContractions__text(let rhsText)):
                    guard Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher) else { return false } 
                    return true 
                case (.inormalizeNumbers__text(let lhsText), .inormalizeNumbers__text(let rhsText)):
                    guard Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher) else { return false } 
                    return true 
                case (.iremovePunctuation__text(let lhsText), .iremovePunctuation__text(let rhsText)):
                    guard Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher) else { return false } 
                    return true 
                default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case let .iexpandContractions__text(p0): return p0.intValue
                case let .inormalizeNumbers__text(p0): return p0.intValue
                case let .iremovePunctuation__text(p0): return p0.intValue
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

        static func expandContractions(text: Parameter<String>, willReturn: String) -> Given {
            return Given(method: .iexpandContractions__text(text), returns: willReturn, throws: nil)
        }
        static func normalizeNumbers(text: Parameter<String>, willReturn: String) -> Given {
            return Given(method: .inormalizeNumbers__text(text), returns: willReturn, throws: nil)
        }
        static func removePunctuation(text: Parameter<String>, willReturn: String) -> Given {
            return Given(method: .iremovePunctuation__text(text), returns: willReturn, throws: nil)
        }
    }

    struct Verify {
        fileprivate var method: MethodType

        static func expandContractions(text: Parameter<String>) -> Verify {
            return Verify(method: .iexpandContractions__text(text))
        }
        static func normalizeNumbers(text: Parameter<String>) -> Verify {
            return Verify(method: .inormalizeNumbers__text(text))
        }
        static func removePunctuation(text: Parameter<String>) -> Verify {
            return Verify(method: .iremovePunctuation__text(text))
        }
    }

    struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        static func expandContractions(text: Parameter<String>, perform: (String) -> Void) -> Perform {
            return Perform(method: .iexpandContractions__text(text), performs: perform)
        }
        static func normalizeNumbers(text: Parameter<String>, perform: (String) -> Void) -> Perform {
            return Perform(method: .inormalizeNumbers__text(text), performs: perform)
        }
        static func removePunctuation(text: Parameter<String>, perform: (String) -> Void) -> Perform {
            return Perform(method: .iremovePunctuation__text(text), performs: perform)
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
    public func verify(property: Property, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) { }

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
}

