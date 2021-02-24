// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.0.0

import SwiftyMocky
import XCTest
import HealthKit
import CoreData
import Presentr
import CSV
import SwiftDate
import UserNotifications
import Instructions
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import BooleanAlgebra
@testable import Common
@testable import DataExport
@testable import DataImport
@testable import DependencyInjection
@testable import Notifications
@testable import Persistence
@testable import Queries
@testable import SampleGroupers
@testable import SampleGroupInformation
@testable import Samples
@testable import Settings
@testable import UIExtensions


// MARK: - Attribute

open class AttributeMock: Attribute, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

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

    private static func isCapturing<T>(_ param: Parameter<T>) -> Bool {
        switch param {
            // can't use `case .capturing(_, _):` here because it causes an EXC_BAD_ACCESS error
            case .value(_):
                return false
            case .matching(_):
                return false
            case ._:
                return false
            default:
                return true
        }
    }


    public var name: String {
		get {	invocations.append(.p_name_get); return __p_name ?? givenGetterValue(.p_name_get, "AttributeMock - stub value for name was not defined") }
	}
	private var __p_name: (String)?

    public var pluralName: String {
		get {	invocations.append(.p_pluralName_get); return __p_pluralName ?? givenGetterValue(.p_pluralName_get, "AttributeMock - stub value for pluralName was not defined") }
	}
	private var __p_pluralName: (String)?

    public var variableName: String? {
		get {	invocations.append(.p_variableName_get); return __p_variableName ?? optionalGivenGetterValue(.p_variableName_get, "AttributeMock - stub value for variableName was not defined") }
	}
	private var __p_variableName: (String)?

    public var extendedDescription: String? {
		get {	invocations.append(.p_extendedDescription_get); return __p_extendedDescription ?? optionalGivenGetterValue(.p_extendedDescription_get, "AttributeMock - stub value for extendedDescription was not defined") }
	}
	private var __p_extendedDescription: (String)?

    public var optional: Bool {
		get {	invocations.append(.p_optional_get); return __p_optional ?? givenGetterValue(.p_optional_get, "AttributeMock - stub value for optional was not defined") }
	}
	private var __p_optional: (Bool)?

    public var valueType: Any.Type {
		get {	invocations.append(.p_valueType_get); return __p_valueType ?? givenGetterValue(.p_valueType_get, "AttributeMock - stub value for valueType was not defined") }
	}
	private var __p_valueType: (Any.Type)?

    public var typeName: String {
		get {	invocations.append(.p_typeName_get); return __p_typeName ?? givenGetterValue(.p_typeName_get, "AttributeMock - stub value for typeName was not defined") }
	}
	private var __p_typeName: (String)?





    open func isValid(value: Any?) -> Bool {
        addInvocation(.m_isValid__value_value(Parameter<Any?>.value(`value`)))
		let perform = methodPerformValue(.m_isValid__value_value(Parameter<Any?>.value(`value`))) as? (Any?) -> Void
		perform?(`value`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isValid__value_value(Parameter<Any?>.value(`value`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isValid(value: Any?). Use given")
			Failure("Stub return value not specified for isValid(value: Any?). Use given")
		}
		return __value
    }

    open func equalTo(_ otherAttribute: Attribute) -> Bool {
        addInvocation(.m_equalTo__otherAttribute(Parameter<Attribute>.value(`otherAttribute`)))
		let perform = methodPerformValue(.m_equalTo__otherAttribute(Parameter<Attribute>.value(`otherAttribute`))) as? (Attribute) -> Void
		perform?(`otherAttribute`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherAttribute(Parameter<Attribute>.value(`otherAttribute`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherAttribute: Attribute). Use given")
			Failure("Stub return value not specified for equalTo(_ otherAttribute: Attribute). Use given")
		}
		return __value
    }

    open func convertToDisplayableString(from value: Any?) throws -> String {
        addInvocation(.m_convertToDisplayableString__from_value(Parameter<Any?>.value(`value`)))
		let perform = methodPerformValue(.m_convertToDisplayableString__from_value(Parameter<Any?>.value(`value`))) as? (Any?) -> Void
		perform?(`value`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_convertToDisplayableString__from_value(Parameter<Any?>.value(`value`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for convertToDisplayableString(from value: Any?). Use given")
			Failure("Stub return value not specified for convertToDisplayableString(from value: Any?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func valuesAreEqual(_ first: Any?, _ second: Any?) throws -> Bool {
        addInvocation(.m_valuesAreEqual__first_second(Parameter<Any?>.value(`first`), Parameter<Any?>.value(`second`)))
		let perform = methodPerformValue(.m_valuesAreEqual__first_second(Parameter<Any?>.value(`first`), Parameter<Any?>.value(`second`))) as? (Any?, Any?) -> Void
		perform?(`first`, `second`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_valuesAreEqual__first_second(Parameter<Any?>.value(`first`), Parameter<Any?>.value(`second`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for valuesAreEqual(_ first: Any?, _ second: Any?). Use given")
			Failure("Stub return value not specified for valuesAreEqual(_ first: Any?, _ second: Any?). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_isValid__value_value(Parameter<Any?>)
        case m_equalTo__otherAttribute(Parameter<Attribute>)
        case m_convertToDisplayableString__from_value(Parameter<Any?>)
        case m_valuesAreEqual__first_second(Parameter<Any?>, Parameter<Any?>)
        case p_name_get
        case p_pluralName_get
        case p_variableName_get
        case p_extendedDescription_get
        case p_optional_get
        case p_valueType_get
        case p_typeName_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_isValid__value_value(let lhsValue), .m_isValid__value_value(let rhsValue)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsValue) && !isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "value"))
				}

				if isCapturing(lhsValue) || isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "value"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_equalTo__otherAttribute(let lhsOtherattribute), .m_equalTo__otherAttribute(let rhsOtherattribute)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsOtherattribute) && !isCapturing(rhsOtherattribute) {
					comparison = Parameter.compare(lhs: lhsOtherattribute, rhs: rhsOtherattribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOtherattribute, rhsOtherattribute, "_ otherAttribute"))
				}

				if isCapturing(lhsOtherattribute) || isCapturing(rhsOtherattribute) {
					comparison = Parameter.compare(lhs: lhsOtherattribute, rhs: rhsOtherattribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOtherattribute, rhsOtherattribute, "_ otherAttribute"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_convertToDisplayableString__from_value(let lhsValue), .m_convertToDisplayableString__from_value(let rhsValue)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsValue) && !isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "from value"))
				}

				if isCapturing(lhsValue) || isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "from value"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_valuesAreEqual__first_second(let lhsFirst, let lhsSecond), .m_valuesAreEqual__first_second(let rhsFirst, let rhsSecond)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsFirst) && !isCapturing(rhsFirst) {
					comparison = Parameter.compare(lhs: lhsFirst, rhs: rhsFirst, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFirst, rhsFirst, "_ first"))
				}


				if !isCapturing(lhsSecond) && !isCapturing(rhsSecond) {
					comparison = Parameter.compare(lhs: lhsSecond, rhs: rhsSecond, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSecond, rhsSecond, "_ second"))
				}

				if isCapturing(lhsFirst) || isCapturing(rhsFirst) {
					comparison = Parameter.compare(lhs: lhsFirst, rhs: rhsFirst, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFirst, rhsFirst, "_ first"))
				}


				if isCapturing(lhsSecond) || isCapturing(rhsSecond) {
					comparison = Parameter.compare(lhs: lhsSecond, rhs: rhsSecond, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSecond, rhsSecond, "_ second"))
				}

				return Matcher.ComparisonResult(results)
            case (.p_name_get,.p_name_get): return Matcher.ComparisonResult.match
            case (.p_pluralName_get,.p_pluralName_get): return Matcher.ComparisonResult.match
            case (.p_variableName_get,.p_variableName_get): return Matcher.ComparisonResult.match
            case (.p_extendedDescription_get,.p_extendedDescription_get): return Matcher.ComparisonResult.match
            case (.p_optional_get,.p_optional_get): return Matcher.ComparisonResult.match
            case (.p_valueType_get,.p_valueType_get): return Matcher.ComparisonResult.match
            case (.p_typeName_get,.p_typeName_get): return Matcher.ComparisonResult.match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_isValid__value_value(p0): return p0.intValue
            case let .m_equalTo__otherAttribute(p0): return p0.intValue
            case let .m_convertToDisplayableString__from_value(p0): return p0.intValue
            case let .m_valuesAreEqual__first_second(p0, p1): return p0.intValue + p1.intValue
            case .p_name_get: return 0
            case .p_pluralName_get: return 0
            case .p_variableName_get: return 0
            case .p_extendedDescription_get: return 0
            case .p_optional_get: return 0
            case .p_valueType_get: return 0
            case .p_typeName_get: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_isValid__value_value: return ".isValid(value:)"
            case .m_equalTo__otherAttribute: return ".equalTo(_:)"
            case .m_convertToDisplayableString__from_value: return ".convertToDisplayableString(from:)"
            case .m_valuesAreEqual__first_second: return ".valuesAreEqual(_:_:)"
            case .p_name_get: return "[get] .name"
            case .p_pluralName_get: return "[get] .pluralName"
            case .p_variableName_get: return "[get] .variableName"
            case .p_extendedDescription_get: return "[get] .extendedDescription"
            case .p_optional_get: return "[get] .optional"
            case .p_valueType_get: return "[get] .valueType"
            case .p_typeName_get: return "[get] .typeName"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func name(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_name_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func pluralName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_pluralName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func variableName(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_variableName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func extendedDescription(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_extendedDescription_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func optional(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_optional_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func valueType(getter defaultValue: Any.Type...) -> PropertyStub {
            return Given(method: .p_valueType_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func typeName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_typeName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func isValid(value: Parameter<Any?>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isValid__value_value(`value`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherAttribute: Parameter<Attribute>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherAttribute(`otherAttribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func convertToDisplayableString(from value: Parameter<Any?>, willReturn: String...) -> MethodStub {
            return Given(method: .m_convertToDisplayableString__from_value(`value`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func valuesAreEqual(_ first: Parameter<Any?>, _ second: Parameter<Any?>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_valuesAreEqual__first_second(`first`, `second`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isValid(value: Parameter<Any?>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isValid__value_value(`value`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ otherAttribute: Parameter<Attribute>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherAttribute(`otherAttribute`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func convertToDisplayableString(from value: Parameter<Any?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_convertToDisplayableString__from_value(`value`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func convertToDisplayableString(from value: Parameter<Any?>, willProduce: (StubberThrows<String>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_convertToDisplayableString__from_value(`value`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func valuesAreEqual(_ first: Parameter<Any?>, _ second: Parameter<Any?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_valuesAreEqual__first_second(`first`, `second`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func valuesAreEqual(_ first: Parameter<Any?>, _ second: Parameter<Any?>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_valuesAreEqual__first_second(`first`, `second`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func isValid(value: Parameter<Any?>) -> Verify { return Verify(method: .m_isValid__value_value(`value`))}
        public static func equalTo(_ otherAttribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_equalTo__otherAttribute(`otherAttribute`))}
        public static func convertToDisplayableString(from value: Parameter<Any?>) -> Verify { return Verify(method: .m_convertToDisplayableString__from_value(`value`))}
        public static func valuesAreEqual(_ first: Parameter<Any?>, _ second: Parameter<Any?>) -> Verify { return Verify(method: .m_valuesAreEqual__first_second(`first`, `second`))}
        public static var name: Verify { return Verify(method: .p_name_get) }
        public static var pluralName: Verify { return Verify(method: .p_pluralName_get) }
        public static var variableName: Verify { return Verify(method: .p_variableName_get) }
        public static var extendedDescription: Verify { return Verify(method: .p_extendedDescription_get) }
        public static var optional: Verify { return Verify(method: .p_optional_get) }
        public static var valueType: Verify { return Verify(method: .p_valueType_get) }
        public static var typeName: Verify { return Verify(method: .p_typeName_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func isValid(value: Parameter<Any?>, perform: @escaping (Any?) -> Void) -> Perform {
            return Perform(method: .m_isValid__value_value(`value`), performs: perform)
        }
        public static func equalTo(_ otherAttribute: Parameter<Attribute>, perform: @escaping (Attribute) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherAttribute(`otherAttribute`), performs: perform)
        }
        public static func convertToDisplayableString(from value: Parameter<Any?>, perform: @escaping (Any?) -> Void) -> Perform {
            return Perform(method: .m_convertToDisplayableString__from_value(`value`), performs: perform)
        }
        public static func valuesAreEqual(_ first: Parameter<Any?>, _ second: Parameter<Any?>, perform: @escaping (Any?, Any?) -> Void) -> Perform {
            return Perform(method: .m_valuesAreEqual__first_second(`first`, `second`), performs: perform)
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
}

