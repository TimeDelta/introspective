//
//  AttributeRestrictionMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import BooleanAlgebra
@testable import Common
@testable import Samples

// sourcery: mock = "AttributeRestriction"
class AttributeRestrictionMock: AttributeRestriction, Mock {
	fileprivate var _description: String = "attribute restriction mock"

	var description: String {
		get { return _description }
		set { _description = newValue }
	}

// sourcery:inline:auto:AttributeRestrictionMock.autoMocked
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



    public var restrictedAttribute: Attribute {
		get {	invocations.append(.p_restrictedAttribute_get); return __p_restrictedAttribute ?? givenGetterValue(.p_restrictedAttribute_get, "AttributeRestrictionMock - stub value for restrictedAttribute was not defined") }
		set {	invocations.append(.p_restrictedAttribute_set(.value(newValue))); __p_restrictedAttribute = newValue }
	}
	private var __p_restrictedAttribute: (Attribute)?


    public var attributedName: String {
		get {	invocations.append(.p_attributedName_get); return __p_attributedName ?? givenGetterValue(.p_attributedName_get, "AttributeRestrictionMock - stub value for attributedName was not defined") }
	}
	private var __p_attributedName: (String)?


    public var attributes: [Attribute] {
		get {	invocations.append(.p_attributes_get); return __p_attributes ?? givenGetterValue(.p_attributes_get, "AttributeRestrictionMock - stub value for attributes was not defined") }
	}
	private var __p_attributes: ([Attribute])?


    public var debugDescription: String {
		get {	invocations.append(.p_debugDescription_get); return __p_debugDescription ?? givenGetterValue(.p_debugDescription_get, "AttributeRestrictionMock - stub value for debugDescription was not defined") }
	}
	private var __p_debugDescription: (String)?






    public required init(restrictedAttribute: Attribute) { }

    open func samplePasses(_ sample: Sample) throws -> Bool {
        addInvocation(.m_samplePasses__sample(Parameter<Sample>.value(`sample`)))
		let perform = methodPerformValue(.m_samplePasses__sample(Parameter<Sample>.value(`sample`))) as? (Sample) -> Void
		perform?(`sample`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_samplePasses__sample(Parameter<Sample>.value(`sample`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for samplePasses(_ sample: Sample). Use given")
			Failure("Stub return value not specified for samplePasses(_ sample: Sample). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func copy() -> AttributeRestriction {
        addInvocation(.m_copy_1)
		let perform = methodPerformValue(.m_copy_1) as? () -> Void
		perform?()
		var __value: AttributeRestriction
		do {
		    __value = try methodReturnValue(.m_copy_1).casted()
		} catch {
			onFatalFailure("Stub return value not specified for copy(). Use given")
			Failure("Stub return value not specified for copy(). Use given")
		}
		return __value
    }

    open func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
        addInvocation(.m_equalTo__otherRestriction(Parameter<AttributeRestriction>.value(`otherRestriction`)))
		let perform = methodPerformValue(.m_equalTo__otherRestriction(Parameter<AttributeRestriction>.value(`otherRestriction`))) as? (AttributeRestriction) -> Void
		perform?(`otherRestriction`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherRestriction(Parameter<AttributeRestriction>.value(`otherRestriction`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherRestriction: AttributeRestriction). Use given")
			Failure("Stub return value not specified for equalTo(_ otherRestriction: AttributeRestriction). Use given")
		}
		return __value
    }

    open func evaluate(_ parameters: [UserInfoKey: Any]?) throws -> Bool {
        addInvocation(.m_evaluate__parameters(Parameter<[UserInfoKey: Any]?>.value(`parameters`)))
		let perform = methodPerformValue(.m_evaluate__parameters(Parameter<[UserInfoKey: Any]?>.value(`parameters`))) as? ([UserInfoKey: Any]?) -> Void
		perform?(`parameters`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_evaluate__parameters(Parameter<[UserInfoKey: Any]?>.value(`parameters`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for evaluate(_ parameters: [UserInfoKey: Any]?). Use given")
			Failure("Stub return value not specified for evaluate(_ parameters: [UserInfoKey: Any]?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func isValid() -> Bool {
        addInvocation(.m_isValid)
		let perform = methodPerformValue(.m_isValid) as? () -> Void
		perform?()
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isValid).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isValid(). Use given")
			Failure("Stub return value not specified for isValid(). Use given")
		}
		return __value
    }

    open func copy() -> BooleanExpression {
        addInvocation(.m_copy_2)
		let perform = methodPerformValue(.m_copy_2) as? () -> Void
		perform?()
		var __value: BooleanExpression
		do {
		    __value = try methodReturnValue(.m_copy_2).casted()
		} catch {
			onFatalFailure("Stub return value not specified for copy(). Use given")
			Failure("Stub return value not specified for copy(). Use given")
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

    open func equalTo(_ other: BooleanExpression) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<BooleanExpression>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<BooleanExpression>.value(`other`))) as? (BooleanExpression) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<BooleanExpression>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: BooleanExpression). Use given")
			Failure("Stub return value not specified for equalTo(_ other: BooleanExpression). Use given")
		}
		return __value
    }

    open func predicate() -> NSPredicate? {
        addInvocation(.m_predicate)
		let perform = methodPerformValue(.m_predicate) as? () -> Void
		perform?()
		var __value: NSPredicate? = nil
		do {
		    __value = try methodReturnValue(.m_predicate).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func evaluate() throws -> Bool {
        addInvocation(.m_evaluate)
		let perform = methodPerformValue(.m_evaluate) as? () -> Void
		perform?()
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_evaluate).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for evaluate(). Use given")
			Failure("Stub return value not specified for evaluate(). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_samplePasses__sample(Parameter<Sample>)
        case m_copy_1
        case m_equalTo__otherRestriction(Parameter<AttributeRestriction>)
        case m_evaluate__parameters(Parameter<[UserInfoKey: Any]?>)
        case m_isValid
        case m_copy_2
        case m_attributeValuesAreValid
        case m_value__of_attribute(Parameter<Attribute>)
        case m_set__attribute_attributeto_value(Parameter<Attribute>, Parameter<Any?>)
        case m_equalTo__otherAttributed(Parameter<Attributed>)
        case m_equalTo__other(Parameter<BooleanExpression>)
        case m_predicate
        case m_evaluate
        case p_restrictedAttribute_get
		case p_restrictedAttribute_set(Parameter<Attribute>)
        case p_attributedName_get
        case p_attributes_get
        case p_debugDescription_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_samplePasses__sample(let lhsSample), .m_samplePasses__sample(let rhsSample)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSample) && !isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "_ sample"))
				}

				if isCapturing(lhsSample) || isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "_ sample"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_copy_1, .m_copy_1): return .match

            case (.m_equalTo__otherRestriction(let lhsOtherrestriction), .m_equalTo__otherRestriction(let rhsOtherrestriction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsOtherrestriction) && !isCapturing(rhsOtherrestriction) {
					comparison = Parameter.compare(lhs: lhsOtherrestriction, rhs: rhsOtherrestriction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOtherrestriction, rhsOtherrestriction, "_ otherRestriction"))
				}

				if isCapturing(lhsOtherrestriction) || isCapturing(rhsOtherrestriction) {
					comparison = Parameter.compare(lhs: lhsOtherrestriction, rhs: rhsOtherrestriction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOtherrestriction, rhsOtherrestriction, "_ otherRestriction"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_evaluate__parameters(let lhsParameters), .m_evaluate__parameters(let rhsParameters)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParameters) && !isCapturing(rhsParameters) {
					comparison = Parameter.compare(lhs: lhsParameters, rhs: rhsParameters, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParameters, rhsParameters, "_ parameters"))
				}

				if isCapturing(lhsParameters) || isCapturing(rhsParameters) {
					comparison = Parameter.compare(lhs: lhsParameters, rhs: rhsParameters, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParameters, rhsParameters, "_ parameters"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_isValid, .m_isValid): return .match

            case (.m_copy_2, .m_copy_2): return .match

            case (.m_attributeValuesAreValid, .m_attributeValuesAreValid): return .match

            case (.m_value__of_attribute(let lhsAttribute), .m_value__of_attribute(let rhsAttribute)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "of attribute"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "of attribute"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_set__attribute_attributeto_value(let lhsAttribute, let lhsValue), .m_set__attribute_attributeto_value(let rhsAttribute, let rhsValue)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "attribute"))
				}


				if !isCapturing(lhsValue) && !isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "to value"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "attribute"))
				}


				if isCapturing(lhsValue) || isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "to value"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_equalTo__otherAttributed(let lhsOtherattributed), .m_equalTo__otherAttributed(let rhsOtherattributed)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsOtherattributed) && !isCapturing(rhsOtherattributed) {
					comparison = Parameter.compare(lhs: lhsOtherattributed, rhs: rhsOtherattributed, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOtherattributed, rhsOtherattributed, "_ otherAttributed"))
				}

				if isCapturing(lhsOtherattributed) || isCapturing(rhsOtherattributed) {
					comparison = Parameter.compare(lhs: lhsOtherattributed, rhs: rhsOtherattributed, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOtherattributed, rhsOtherattributed, "_ otherAttributed"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_equalTo__other(let lhsOther), .m_equalTo__other(let rhsOther)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsOther) && !isCapturing(rhsOther) {
					comparison = Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOther, rhsOther, "_ other"))
				}

				if isCapturing(lhsOther) || isCapturing(rhsOther) {
					comparison = Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOther, rhsOther, "_ other"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_predicate, .m_predicate): return .match

            case (.m_evaluate, .m_evaluate): return .match
            case (.p_restrictedAttribute_get,.p_restrictedAttribute_get): return Matcher.ComparisonResult.match
			case (.p_restrictedAttribute_set(let left),.p_restrictedAttribute_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Attribute>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_attributedName_get,.p_attributedName_get): return Matcher.ComparisonResult.match
            case (.p_attributes_get,.p_attributes_get): return Matcher.ComparisonResult.match
            case (.p_debugDescription_get,.p_debugDescription_get): return Matcher.ComparisonResult.match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_samplePasses__sample(p0): return p0.intValue
            case .m_copy_1: return 0
            case let .m_equalTo__otherRestriction(p0): return p0.intValue
            case let .m_evaluate__parameters(p0): return p0.intValue
            case .m_isValid: return 0
            case .m_copy_2: return 0
            case .m_attributeValuesAreValid: return 0
            case let .m_value__of_attribute(p0): return p0.intValue
            case let .m_set__attribute_attributeto_value(p0, p1): return p0.intValue + p1.intValue
            case let .m_equalTo__otherAttributed(p0): return p0.intValue
            case let .m_equalTo__other(p0): return p0.intValue
            case .m_predicate: return 0
            case .m_evaluate: return 0
            case .p_restrictedAttribute_get: return 0
			case .p_restrictedAttribute_set(let newValue): return newValue.intValue
            case .p_attributedName_get: return 0
            case .p_attributes_get: return 0
            case .p_debugDescription_get: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_samplePasses__sample: return ".samplePasses(_:)"
            case .m_copy_1: return ".copy()"
            case .m_equalTo__otherRestriction: return ".equalTo(_:)"
            case .m_evaluate__parameters: return ".evaluate(_:)"
            case .m_isValid: return ".isValid()"
            case .m_copy_2: return ".copy()"
            case .m_attributeValuesAreValid: return ".attributeValuesAreValid()"
            case .m_value__of_attribute: return ".value(of:)"
            case .m_set__attribute_attributeto_value: return ".set(attribute:to:)"
            case .m_equalTo__otherAttributed: return ".equalTo(_:)"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .m_predicate: return ".predicate()"
            case .m_evaluate: return ".evaluate()"
            case .p_restrictedAttribute_get: return "[get] .restrictedAttribute"
			case .p_restrictedAttribute_set: return "[set] .restrictedAttribute"
            case .p_attributedName_get: return "[get] .attributedName"
            case .p_attributes_get: return "[get] .attributes"
            case .p_debugDescription_get: return "[get] .debugDescription"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func restrictedAttribute(getter defaultValue: Attribute...) -> PropertyStub {
            return Given(method: .p_restrictedAttribute_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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

        public static func samplePasses(_ sample: Parameter<Sample>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_samplePasses__sample(`sample`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func copy(willReturn: AttributeRestriction...) -> MethodStub {
            return Given(method: .m_copy_1, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherRestriction: Parameter<AttributeRestriction>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherRestriction(`otherRestriction`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func evaluate(_ parameters: Parameter<[UserInfoKey: Any]?>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_evaluate__parameters(`parameters`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isValid(willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isValid, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func copy(willReturn: BooleanExpression...) -> MethodStub {
            return Given(method: .m_copy_2, products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func equalTo(_ other: Parameter<BooleanExpression>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func predicate(willReturn: NSPredicate?...) -> MethodStub {
            return Given(method: .m_predicate, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func evaluate(willReturn: Bool...) -> MethodStub {
            return Given(method: .m_evaluate, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func copy(willProduce: (Stubber<AttributeRestriction>) -> Void) -> MethodStub {
            let willReturn: [AttributeRestriction] = []
			let given: Given = { return Given(method: .m_copy_1, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (AttributeRestriction).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ otherRestriction: Parameter<AttributeRestriction>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherRestriction(`otherRestriction`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func isValid(willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isValid, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func copy(willProduce: (Stubber<BooleanExpression>) -> Void) -> MethodStub {
            let willReturn: [BooleanExpression] = []
			let given: Given = { return Given(method: .m_copy_2, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (BooleanExpression).self)
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
        public static func equalTo(_ other: Parameter<BooleanExpression>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func predicate(willProduce: (Stubber<NSPredicate?>) -> Void) -> MethodStub {
            let willReturn: [NSPredicate?] = []
			let given: Given = { return Given(method: .m_predicate, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (NSPredicate?).self)
			willProduce(stubber)
			return given
        }
        public static func samplePasses(_ sample: Parameter<Sample>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_samplePasses__sample(`sample`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func samplePasses(_ sample: Parameter<Sample>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_samplePasses__sample(`sample`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func evaluate(_ parameters: Parameter<[UserInfoKey: Any]?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_evaluate__parameters(`parameters`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func evaluate(_ parameters: Parameter<[UserInfoKey: Any]?>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_evaluate__parameters(`parameters`), products: willThrow.map({ StubProduct.throw($0) })) }()
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
        public static func evaluate(willThrow: Error...) -> MethodStub {
            return Given(method: .m_evaluate, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func evaluate(willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_evaluate, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func samplePasses(_ sample: Parameter<Sample>) -> Verify { return Verify(method: .m_samplePasses__sample(`sample`))}
        public static func copy(returning: (AttributeRestriction).Type) -> Verify { return Verify(method: .m_copy_1)}
        public static func equalTo(_ otherRestriction: Parameter<AttributeRestriction>) -> Verify { return Verify(method: .m_equalTo__otherRestriction(`otherRestriction`))}
        public static func evaluate(_ parameters: Parameter<[UserInfoKey: Any]?>) -> Verify { return Verify(method: .m_evaluate__parameters(`parameters`))}
        public static func isValid() -> Verify { return Verify(method: .m_isValid)}
        public static func copy(returning: (BooleanExpression).Type) -> Verify { return Verify(method: .m_copy_2)}
        public static func attributeValuesAreValid() -> Verify { return Verify(method: .m_attributeValuesAreValid)}
        public static func value(of attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_value__of_attribute(`attribute`))}
        public static func set(attribute: Parameter<Attribute>, to value: Parameter<Any?>) -> Verify { return Verify(method: .m_set__attribute_attributeto_value(`attribute`, `value`))}
        public static func equalTo(_ otherAttributed: Parameter<Attributed>) -> Verify { return Verify(method: .m_equalTo__otherAttributed(`otherAttributed`))}
        public static func equalTo(_ other: Parameter<BooleanExpression>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static func predicate() -> Verify { return Verify(method: .m_predicate)}
        public static func evaluate() -> Verify { return Verify(method: .m_evaluate)}
        public static var restrictedAttribute: Verify { return Verify(method: .p_restrictedAttribute_get) }
		public static func restrictedAttribute(set newValue: Parameter<Attribute>) -> Verify { return Verify(method: .p_restrictedAttribute_set(newValue)) }
        public static var attributedName: Verify { return Verify(method: .p_attributedName_get) }
        public static var attributes: Verify { return Verify(method: .p_attributes_get) }
        public static var debugDescription: Verify { return Verify(method: .p_debugDescription_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func samplePasses(_ sample: Parameter<Sample>, perform: @escaping (Sample) -> Void) -> Perform {
            return Perform(method: .m_samplePasses__sample(`sample`), performs: perform)
        }
        public static func copy(returning: (AttributeRestriction).Type, perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_copy_1, performs: perform)
        }
        public static func equalTo(_ otherRestriction: Parameter<AttributeRestriction>, perform: @escaping (AttributeRestriction) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherRestriction(`otherRestriction`), performs: perform)
        }
        public static func evaluate(_ parameters: Parameter<[UserInfoKey: Any]?>, perform: @escaping ([UserInfoKey: Any]?) -> Void) -> Perform {
            return Perform(method: .m_evaluate__parameters(`parameters`), performs: perform)
        }
        public static func isValid(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_isValid, performs: perform)
        }
        public static func copy(returning: (BooleanExpression).Type, perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_copy_2, performs: perform)
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
        public static func equalTo(_ other: Parameter<BooleanExpression>, perform: @escaping (BooleanExpression) -> Void) -> Perform {
            return Perform(method: .m_equalTo__other(`other`), performs: perform)
        }
        public static func predicate(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_predicate, performs: perform)
        }
        public static func evaluate(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_evaluate, performs: perform)
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
// sourcery:end
}
