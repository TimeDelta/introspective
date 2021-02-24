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

// MARK: - GroupDefinition

open class GroupDefinitionMock: GroupDefinition, Mock {
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
		get {	invocations.append(.p_name_get); return __p_name ?? givenGetterValue(.p_name_get, "GroupDefinitionMock - stub value for name was not defined") }
		set {	invocations.append(.p_name_set(.value(newValue))); __p_name = newValue }
	}
	private var __p_name: (String)?

    public var description: String {
		get {	invocations.append(.p_description_get); return __p_description ?? givenGetterValue(.p_description_get, "GroupDefinitionMock - stub value for description was not defined") }
	}
	private var __p_description: (String)?

    public var sampleType: Sample.Type {
		get {	invocations.append(.p_sampleType_get); return __p_sampleType ?? givenGetterValue(.p_sampleType_get, "GroupDefinitionMock - stub value for sampleType was not defined") }
	}
	private var __p_sampleType: (Sample.Type)?

    public var attributeRestrictionExpression: BooleanExpression? {
		get {	invocations.append(.p_attributeRestrictionExpression_get); return __p_attributeRestrictionExpression ?? optionalGivenGetterValue(.p_attributeRestrictionExpression_get, "GroupDefinitionMock - stub value for attributeRestrictionExpression was not defined") }
	}
	private var __p_attributeRestrictionExpression: (BooleanExpression)?

    public var expressionParts: [BooleanExpressionPart] {
		get {	invocations.append(.p_expressionParts_get); return __p_expressionParts ?? givenGetterValue(.p_expressionParts_get, "GroupDefinitionMock - stub value for expressionParts was not defined") }
		set {	invocations.append(.p_expressionParts_set(.value(newValue))); __p_expressionParts = newValue }
	}
	private var __p_expressionParts: ([BooleanExpressionPart])?





    public required init(_ sampleType: Sample.Type) { }

    open func sampleBelongsInGroup(_ sample: Sample) throws -> Bool {
        addInvocation(.m_sampleBelongsInGroup__sample(Parameter<Sample>.value(`sample`)))
		let perform = methodPerformValue(.m_sampleBelongsInGroup__sample(Parameter<Sample>.value(`sample`))) as? (Sample) -> Void
		perform?(`sample`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_sampleBelongsInGroup__sample(Parameter<Sample>.value(`sample`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for sampleBelongsInGroup(_ sample: Sample). Use given")
			Failure("Stub return value not specified for sampleBelongsInGroup(_ sample: Sample). Use given")
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

    open func copy() -> GroupDefinition {
        addInvocation(.m_copy)
		let perform = methodPerformValue(.m_copy) as? () -> Void
		perform?()
		var __value: GroupDefinition
		do {
		    __value = try methodReturnValue(.m_copy).casted()
		} catch {
			onFatalFailure("Stub return value not specified for copy(). Use given")
			Failure("Stub return value not specified for copy(). Use given")
		}
		return __value
    }

    open func equalTo(_ other: GroupDefinition) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<GroupDefinition>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<GroupDefinition>.value(`other`))) as? (GroupDefinition) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<GroupDefinition>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: GroupDefinition). Use given")
			Failure("Stub return value not specified for equalTo(_ other: GroupDefinition). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_sampleBelongsInGroup__sample(Parameter<Sample>)
        case m_isValid
        case m_copy
        case m_equalTo__other(Parameter<GroupDefinition>)
        case p_name_get
		case p_name_set(Parameter<String>)
        case p_description_get
        case p_sampleType_get
        case p_attributeRestrictionExpression_get
        case p_expressionParts_get
		case p_expressionParts_set(Parameter<[BooleanExpressionPart]>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_sampleBelongsInGroup__sample(let lhsSample), .m_sampleBelongsInGroup__sample(let rhsSample)):
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

            case (.m_isValid, .m_isValid): return .match

            case (.m_copy, .m_copy): return .match

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
            case (.p_name_get,.p_name_get): return Matcher.ComparisonResult.match
			case (.p_name_set(let left),.p_name_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<String>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_description_get,.p_description_get): return Matcher.ComparisonResult.match
            case (.p_sampleType_get,.p_sampleType_get): return Matcher.ComparisonResult.match
            case (.p_attributeRestrictionExpression_get,.p_attributeRestrictionExpression_get): return Matcher.ComparisonResult.match
            case (.p_expressionParts_get,.p_expressionParts_get): return Matcher.ComparisonResult.match
			case (.p_expressionParts_set(let left),.p_expressionParts_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<[BooleanExpressionPart]>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_sampleBelongsInGroup__sample(p0): return p0.intValue
            case .m_isValid: return 0
            case .m_copy: return 0
            case let .m_equalTo__other(p0): return p0.intValue
            case .p_name_get: return 0
			case .p_name_set(let newValue): return newValue.intValue
            case .p_description_get: return 0
            case .p_sampleType_get: return 0
            case .p_attributeRestrictionExpression_get: return 0
            case .p_expressionParts_get: return 0
			case .p_expressionParts_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_sampleBelongsInGroup__sample: return ".sampleBelongsInGroup(_:)"
            case .m_isValid: return ".isValid()"
            case .m_copy: return ".copy()"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .p_name_get: return "[get] .name"
			case .p_name_set: return "[set] .name"
            case .p_description_get: return "[get] .description"
            case .p_sampleType_get: return "[get] .sampleType"
            case .p_attributeRestrictionExpression_get: return "[get] .attributeRestrictionExpression"
            case .p_expressionParts_get: return "[get] .expressionParts"
			case .p_expressionParts_set: return "[set] .expressionParts"
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
        public static func description(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_description_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func sampleType(getter defaultValue: Sample.Type...) -> PropertyStub {
            return Given(method: .p_sampleType_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func attributeRestrictionExpression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_attributeRestrictionExpression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func expressionParts(getter defaultValue: [BooleanExpressionPart]...) -> PropertyStub {
            return Given(method: .p_expressionParts_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func sampleBelongsInGroup(_ sample: Parameter<Sample>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_sampleBelongsInGroup__sample(`sample`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isValid(willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isValid, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func copy(willReturn: GroupDefinition...) -> MethodStub {
            return Given(method: .m_copy, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<GroupDefinition>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isValid(willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isValid, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func copy(willProduce: (Stubber<GroupDefinition>) -> Void) -> MethodStub {
            let willReturn: [GroupDefinition] = []
			let given: Given = { return Given(method: .m_copy, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (GroupDefinition).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ other: Parameter<GroupDefinition>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func sampleBelongsInGroup(_ sample: Parameter<Sample>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_sampleBelongsInGroup__sample(`sample`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func sampleBelongsInGroup(_ sample: Parameter<Sample>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_sampleBelongsInGroup__sample(`sample`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func sampleBelongsInGroup(_ sample: Parameter<Sample>) -> Verify { return Verify(method: .m_sampleBelongsInGroup__sample(`sample`))}
        public static func isValid() -> Verify { return Verify(method: .m_isValid)}
        public static func copy() -> Verify { return Verify(method: .m_copy)}
        public static func equalTo(_ other: Parameter<GroupDefinition>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static var name: Verify { return Verify(method: .p_name_get) }
		public static func name(set newValue: Parameter<String>) -> Verify { return Verify(method: .p_name_set(newValue)) }
        public static var description: Verify { return Verify(method: .p_description_get) }
        public static var sampleType: Verify { return Verify(method: .p_sampleType_get) }
        public static var attributeRestrictionExpression: Verify { return Verify(method: .p_attributeRestrictionExpression_get) }
        public static var expressionParts: Verify { return Verify(method: .p_expressionParts_get) }
		public static func expressionParts(set newValue: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .p_expressionParts_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func sampleBelongsInGroup(_ sample: Parameter<Sample>, perform: @escaping (Sample) -> Void) -> Perform {
            return Perform(method: .m_sampleBelongsInGroup__sample(`sample`), performs: perform)
        }
        public static func isValid(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_isValid, performs: perform)
        }
        public static func copy(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_copy, performs: perform)
        }
        public static func equalTo(_ other: Parameter<GroupDefinition>, perform: @escaping (GroupDefinition) -> Void) -> Perform {
            return Perform(method: .m_equalTo__other(`other`), performs: perform)
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

// MARK: - SampleGrouperFactory

open class SampleGrouperFactoryMock: SampleGrouperFactory, Mock {
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






    open func typesFor(sampleType: Sample.Type) -> [SampleGrouper.Type] {
        addInvocation(.m_typesFor__sampleType_sampleType(Parameter<Sample.Type>.value(`sampleType`)))
		let perform = methodPerformValue(.m_typesFor__sampleType_sampleType(Parameter<Sample.Type>.value(`sampleType`))) as? (Sample.Type) -> Void
		perform?(`sampleType`)
		var __value: [SampleGrouper.Type]
		do {
		    __value = try methodReturnValue(.m_typesFor__sampleType_sampleType(Parameter<Sample.Type>.value(`sampleType`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for typesFor(sampleType: Sample.Type). Use given")
			Failure("Stub return value not specified for typesFor(sampleType: Sample.Type). Use given")
		}
		return __value
    }

    open func typesFor(attributes: [Attribute]) -> [SampleGrouper.Type] {
        addInvocation(.m_typesFor__attributes_attributes(Parameter<[Attribute]>.value(`attributes`)))
		let perform = methodPerformValue(.m_typesFor__attributes_attributes(Parameter<[Attribute]>.value(`attributes`))) as? ([Attribute]) -> Void
		perform?(`attributes`)
		var __value: [SampleGrouper.Type]
		do {
		    __value = try methodReturnValue(.m_typesFor__attributes_attributes(Parameter<[Attribute]>.value(`attributes`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for typesFor(attributes: [Attribute]). Use given")
			Failure("Stub return value not specified for typesFor(attributes: [Attribute]). Use given")
		}
		return __value
    }

    open func groupersFor(sampleType: Sample.Type) -> [SampleGrouper] {
        addInvocation(.m_groupersFor__sampleType_sampleType(Parameter<Sample.Type>.value(`sampleType`)))
		let perform = methodPerformValue(.m_groupersFor__sampleType_sampleType(Parameter<Sample.Type>.value(`sampleType`))) as? (Sample.Type) -> Void
		perform?(`sampleType`)
		var __value: [SampleGrouper]
		do {
		    __value = try methodReturnValue(.m_groupersFor__sampleType_sampleType(Parameter<Sample.Type>.value(`sampleType`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for groupersFor(sampleType: Sample.Type). Use given")
			Failure("Stub return value not specified for groupersFor(sampleType: Sample.Type). Use given")
		}
		return __value
    }

    open func groupersFor(attributes: [Attribute]) -> [SampleGrouper] {
        addInvocation(.m_groupersFor__attributes_attributes(Parameter<[Attribute]>.value(`attributes`)))
		let perform = methodPerformValue(.m_groupersFor__attributes_attributes(Parameter<[Attribute]>.value(`attributes`))) as? ([Attribute]) -> Void
		perform?(`attributes`)
		var __value: [SampleGrouper]
		do {
		    __value = try methodReturnValue(.m_groupersFor__attributes_attributes(Parameter<[Attribute]>.value(`attributes`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for groupersFor(attributes: [Attribute]). Use given")
			Failure("Stub return value not specified for groupersFor(attributes: [Attribute]). Use given")
		}
		return __value
    }

    open func groupDefinition(_ sampleType: Sample.Type) -> GroupDefinition {
        addInvocation(.m_groupDefinition__sampleType(Parameter<Sample.Type>.value(`sampleType`)))
		let perform = methodPerformValue(.m_groupDefinition__sampleType(Parameter<Sample.Type>.value(`sampleType`))) as? (Sample.Type) -> Void
		perform?(`sampleType`)
		var __value: GroupDefinition
		do {
		    __value = try methodReturnValue(.m_groupDefinition__sampleType(Parameter<Sample.Type>.value(`sampleType`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for groupDefinition(_ sampleType: Sample.Type). Use given")
			Failure("Stub return value not specified for groupDefinition(_ sampleType: Sample.Type). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_typesFor__sampleType_sampleType(Parameter<Sample.Type>)
        case m_typesFor__attributes_attributes(Parameter<[Attribute]>)
        case m_groupersFor__sampleType_sampleType(Parameter<Sample.Type>)
        case m_groupersFor__attributes_attributes(Parameter<[Attribute]>)
        case m_groupDefinition__sampleType(Parameter<Sample.Type>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_typesFor__sampleType_sampleType(let lhsSampletype), .m_typesFor__sampleType_sampleType(let rhsSampletype)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSampletype) && !isCapturing(rhsSampletype) {
					comparison = Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSampletype, rhsSampletype, "sampleType"))
				}

				if isCapturing(lhsSampletype) || isCapturing(rhsSampletype) {
					comparison = Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSampletype, rhsSampletype, "sampleType"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_typesFor__attributes_attributes(let lhsAttributes), .m_typesFor__attributes_attributes(let rhsAttributes)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttributes) && !isCapturing(rhsAttributes) {
					comparison = Parameter.compare(lhs: lhsAttributes, rhs: rhsAttributes, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttributes, rhsAttributes, "attributes"))
				}

				if isCapturing(lhsAttributes) || isCapturing(rhsAttributes) {
					comparison = Parameter.compare(lhs: lhsAttributes, rhs: rhsAttributes, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttributes, rhsAttributes, "attributes"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_groupersFor__sampleType_sampleType(let lhsSampletype), .m_groupersFor__sampleType_sampleType(let rhsSampletype)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSampletype) && !isCapturing(rhsSampletype) {
					comparison = Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSampletype, rhsSampletype, "sampleType"))
				}

				if isCapturing(lhsSampletype) || isCapturing(rhsSampletype) {
					comparison = Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSampletype, rhsSampletype, "sampleType"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_groupersFor__attributes_attributes(let lhsAttributes), .m_groupersFor__attributes_attributes(let rhsAttributes)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttributes) && !isCapturing(rhsAttributes) {
					comparison = Parameter.compare(lhs: lhsAttributes, rhs: rhsAttributes, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttributes, rhsAttributes, "attributes"))
				}

				if isCapturing(lhsAttributes) || isCapturing(rhsAttributes) {
					comparison = Parameter.compare(lhs: lhsAttributes, rhs: rhsAttributes, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttributes, rhsAttributes, "attributes"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_groupDefinition__sampleType(let lhsSampletype), .m_groupDefinition__sampleType(let rhsSampletype)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSampletype) && !isCapturing(rhsSampletype) {
					comparison = Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSampletype, rhsSampletype, "_ sampleType"))
				}

				if isCapturing(lhsSampletype) || isCapturing(rhsSampletype) {
					comparison = Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSampletype, rhsSampletype, "_ sampleType"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_typesFor__sampleType_sampleType(p0): return p0.intValue
            case let .m_typesFor__attributes_attributes(p0): return p0.intValue
            case let .m_groupersFor__sampleType_sampleType(p0): return p0.intValue
            case let .m_groupersFor__attributes_attributes(p0): return p0.intValue
            case let .m_groupDefinition__sampleType(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_typesFor__sampleType_sampleType: return ".typesFor(sampleType:)"
            case .m_typesFor__attributes_attributes: return ".typesFor(attributes:)"
            case .m_groupersFor__sampleType_sampleType: return ".groupersFor(sampleType:)"
            case .m_groupersFor__attributes_attributes: return ".groupersFor(attributes:)"
            case .m_groupDefinition__sampleType: return ".groupDefinition(_:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func typesFor(sampleType: Parameter<Sample.Type>, willReturn: [SampleGrouper.Type]...) -> MethodStub {
            return Given(method: .m_typesFor__sampleType_sampleType(`sampleType`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func typesFor(attributes: Parameter<[Attribute]>, willReturn: [SampleGrouper.Type]...) -> MethodStub {
            return Given(method: .m_typesFor__attributes_attributes(`attributes`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func groupersFor(sampleType: Parameter<Sample.Type>, willReturn: [SampleGrouper]...) -> MethodStub {
            return Given(method: .m_groupersFor__sampleType_sampleType(`sampleType`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func groupersFor(attributes: Parameter<[Attribute]>, willReturn: [SampleGrouper]...) -> MethodStub {
            return Given(method: .m_groupersFor__attributes_attributes(`attributes`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func groupDefinition(_ sampleType: Parameter<Sample.Type>, willReturn: GroupDefinition...) -> MethodStub {
            return Given(method: .m_groupDefinition__sampleType(`sampleType`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func typesFor(sampleType: Parameter<Sample.Type>, willProduce: (Stubber<[SampleGrouper.Type]>) -> Void) -> MethodStub {
            let willReturn: [[SampleGrouper.Type]] = []
			let given: Given = { return Given(method: .m_typesFor__sampleType_sampleType(`sampleType`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([SampleGrouper.Type]).self)
			willProduce(stubber)
			return given
        }
        public static func typesFor(attributes: Parameter<[Attribute]>, willProduce: (Stubber<[SampleGrouper.Type]>) -> Void) -> MethodStub {
            let willReturn: [[SampleGrouper.Type]] = []
			let given: Given = { return Given(method: .m_typesFor__attributes_attributes(`attributes`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([SampleGrouper.Type]).self)
			willProduce(stubber)
			return given
        }
        public static func groupersFor(sampleType: Parameter<Sample.Type>, willProduce: (Stubber<[SampleGrouper]>) -> Void) -> MethodStub {
            let willReturn: [[SampleGrouper]] = []
			let given: Given = { return Given(method: .m_groupersFor__sampleType_sampleType(`sampleType`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([SampleGrouper]).self)
			willProduce(stubber)
			return given
        }
        public static func groupersFor(attributes: Parameter<[Attribute]>, willProduce: (Stubber<[SampleGrouper]>) -> Void) -> MethodStub {
            let willReturn: [[SampleGrouper]] = []
			let given: Given = { return Given(method: .m_groupersFor__attributes_attributes(`attributes`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([SampleGrouper]).self)
			willProduce(stubber)
			return given
        }
        public static func groupDefinition(_ sampleType: Parameter<Sample.Type>, willProduce: (Stubber<GroupDefinition>) -> Void) -> MethodStub {
            let willReturn: [GroupDefinition] = []
			let given: Given = { return Given(method: .m_groupDefinition__sampleType(`sampleType`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (GroupDefinition).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func typesFor(sampleType: Parameter<Sample.Type>) -> Verify { return Verify(method: .m_typesFor__sampleType_sampleType(`sampleType`))}
        public static func typesFor(attributes: Parameter<[Attribute]>) -> Verify { return Verify(method: .m_typesFor__attributes_attributes(`attributes`))}
        public static func groupersFor(sampleType: Parameter<Sample.Type>) -> Verify { return Verify(method: .m_groupersFor__sampleType_sampleType(`sampleType`))}
        public static func groupersFor(attributes: Parameter<[Attribute]>) -> Verify { return Verify(method: .m_groupersFor__attributes_attributes(`attributes`))}
        public static func groupDefinition(_ sampleType: Parameter<Sample.Type>) -> Verify { return Verify(method: .m_groupDefinition__sampleType(`sampleType`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func typesFor(sampleType: Parameter<Sample.Type>, perform: @escaping (Sample.Type) -> Void) -> Perform {
            return Perform(method: .m_typesFor__sampleType_sampleType(`sampleType`), performs: perform)
        }
        public static func typesFor(attributes: Parameter<[Attribute]>, perform: @escaping ([Attribute]) -> Void) -> Perform {
            return Perform(method: .m_typesFor__attributes_attributes(`attributes`), performs: perform)
        }
        public static func groupersFor(sampleType: Parameter<Sample.Type>, perform: @escaping (Sample.Type) -> Void) -> Perform {
            return Perform(method: .m_groupersFor__sampleType_sampleType(`sampleType`), performs: perform)
        }
        public static func groupersFor(attributes: Parameter<[Attribute]>, perform: @escaping ([Attribute]) -> Void) -> Perform {
            return Perform(method: .m_groupersFor__attributes_attributes(`attributes`), performs: perform)
        }
        public static func groupDefinition(_ sampleType: Parameter<Sample.Type>, perform: @escaping (Sample.Type) -> Void) -> Perform {
            return Perform(method: .m_groupDefinition__sampleType(`sampleType`), performs: perform)
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

