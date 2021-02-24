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


// MARK: - SampleGroupInformation

open class SampleGroupInformationMock: SampleGroupInformation, Mock {
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
		get {	invocations.append(.p_name_get); return __p_name ?? givenGetterValue(.p_name_get, "SampleGroupInformationMock - stub value for name was not defined") }
	}
	private var __p_name: (String)?

    public var startDate: Date? {
		get {	invocations.append(.p_startDate_get); return __p_startDate ?? optionalGivenGetterValue(.p_startDate_get, "SampleGroupInformationMock - stub value for startDate was not defined") }
		set {	invocations.append(.p_startDate_set(.value(newValue))); __p_startDate = newValue }
	}
	private var __p_startDate: (Date)?

    public var endDate: Date? {
		get {	invocations.append(.p_endDate_get); return __p_endDate ?? optionalGivenGetterValue(.p_endDate_get, "SampleGroupInformationMock - stub value for endDate was not defined") }
		set {	invocations.append(.p_endDate_set(.value(newValue))); __p_endDate = newValue }
	}
	private var __p_endDate: (Date)?

    public var attribute: Attribute {
		get {	invocations.append(.p_attribute_get); return __p_attribute ?? givenGetterValue(.p_attribute_get, "SampleGroupInformationMock - stub value for attribute was not defined") }
		set {	invocations.append(.p_attribute_set(.value(newValue))); __p_attribute = newValue }
	}
	private var __p_attribute: (Attribute)?

    public var description: String {
		get {	invocations.append(.p_description_get); return __p_description ?? givenGetterValue(.p_description_get, "SampleGroupInformationMock - stub value for description was not defined") }
	}
	private var __p_description: (String)?





    public required init(_ attribute: Attribute) { }

    open func compute(forSamples samples: [Sample]) throws -> String {
        addInvocation(.m_compute__forSamples_samples(Parameter<[Sample]>.value(`samples`)))
		let perform = methodPerformValue(.m_compute__forSamples_samples(Parameter<[Sample]>.value(`samples`))) as? ([Sample]) -> Void
		perform?(`samples`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_compute__forSamples_samples(Parameter<[Sample]>.value(`samples`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for compute(forSamples samples: [Sample]). Use given")
			Failure("Stub return value not specified for compute(forSamples samples: [Sample]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func computeGraphable(forSamples samples: [Sample]) throws -> String {
        addInvocation(.m_computeGraphable__forSamples_samples(Parameter<[Sample]>.value(`samples`)))
		let perform = methodPerformValue(.m_computeGraphable__forSamples_samples(Parameter<[Sample]>.value(`samples`))) as? ([Sample]) -> Void
		perform?(`samples`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_computeGraphable__forSamples_samples(Parameter<[Sample]>.value(`samples`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for computeGraphable(forSamples samples: [Sample]). Use given")
			Failure("Stub return value not specified for computeGraphable(forSamples samples: [Sample]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func equalTo(_ other: SampleGroupInformation) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<SampleGroupInformation>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<SampleGroupInformation>.value(`other`))) as? (SampleGroupInformation) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<SampleGroupInformation>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: SampleGroupInformation). Use given")
			Failure("Stub return value not specified for equalTo(_ other: SampleGroupInformation). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_compute__forSamples_samples(Parameter<[Sample]>)
        case m_computeGraphable__forSamples_samples(Parameter<[Sample]>)
        case m_equalTo__other(Parameter<SampleGroupInformation>)
        case p_name_get
        case p_startDate_get
		case p_startDate_set(Parameter<Date?>)
        case p_endDate_get
		case p_endDate_set(Parameter<Date?>)
        case p_attribute_get
		case p_attribute_set(Parameter<Attribute>)
        case p_description_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_compute__forSamples_samples(let lhsSamples), .m_compute__forSamples_samples(let rhsSamples)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "forSamples samples"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "forSamples samples"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_computeGraphable__forSamples_samples(let lhsSamples), .m_computeGraphable__forSamples_samples(let rhsSamples)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "forSamples samples"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "forSamples samples"))
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
            case (.p_name_get,.p_name_get): return Matcher.ComparisonResult.match
            case (.p_startDate_get,.p_startDate_get): return Matcher.ComparisonResult.match
			case (.p_startDate_set(let left),.p_startDate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_endDate_get,.p_endDate_get): return Matcher.ComparisonResult.match
			case (.p_endDate_set(let left),.p_endDate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_attribute_get,.p_attribute_get): return Matcher.ComparisonResult.match
			case (.p_attribute_set(let left),.p_attribute_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Attribute>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_description_get,.p_description_get): return Matcher.ComparisonResult.match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_compute__forSamples_samples(p0): return p0.intValue
            case let .m_computeGraphable__forSamples_samples(p0): return p0.intValue
            case let .m_equalTo__other(p0): return p0.intValue
            case .p_name_get: return 0
            case .p_startDate_get: return 0
			case .p_startDate_set(let newValue): return newValue.intValue
            case .p_endDate_get: return 0
			case .p_endDate_set(let newValue): return newValue.intValue
            case .p_attribute_get: return 0
			case .p_attribute_set(let newValue): return newValue.intValue
            case .p_description_get: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_compute__forSamples_samples: return ".compute(forSamples:)"
            case .m_computeGraphable__forSamples_samples: return ".computeGraphable(forSamples:)"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .p_name_get: return "[get] .name"
            case .p_startDate_get: return "[get] .startDate"
			case .p_startDate_set: return "[set] .startDate"
            case .p_endDate_get: return "[get] .endDate"
			case .p_endDate_set: return "[set] .endDate"
            case .p_attribute_get: return "[get] .attribute"
			case .p_attribute_set: return "[set] .attribute"
            case .p_description_get: return "[get] .description"
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
        public static func startDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_startDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func endDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_endDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func attribute(getter defaultValue: Attribute...) -> PropertyStub {
            return Given(method: .p_attribute_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func description(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_description_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func compute(forSamples samples: Parameter<[Sample]>, willReturn: String...) -> MethodStub {
            return Given(method: .m_compute__forSamples_samples(`samples`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func computeGraphable(forSamples samples: Parameter<[Sample]>, willReturn: String...) -> MethodStub {
            return Given(method: .m_computeGraphable__forSamples_samples(`samples`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<SampleGroupInformation>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<SampleGroupInformation>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func compute(forSamples samples: Parameter<[Sample]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_compute__forSamples_samples(`samples`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func compute(forSamples samples: Parameter<[Sample]>, willProduce: (StubberThrows<String>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_compute__forSamples_samples(`samples`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func computeGraphable(forSamples samples: Parameter<[Sample]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_computeGraphable__forSamples_samples(`samples`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func computeGraphable(forSamples samples: Parameter<[Sample]>, willProduce: (StubberThrows<String>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_computeGraphable__forSamples_samples(`samples`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (String).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func compute(forSamples samples: Parameter<[Sample]>) -> Verify { return Verify(method: .m_compute__forSamples_samples(`samples`))}
        public static func computeGraphable(forSamples samples: Parameter<[Sample]>) -> Verify { return Verify(method: .m_computeGraphable__forSamples_samples(`samples`))}
        public static func equalTo(_ other: Parameter<SampleGroupInformation>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static var name: Verify { return Verify(method: .p_name_get) }
        public static var startDate: Verify { return Verify(method: .p_startDate_get) }
		public static func startDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_startDate_set(newValue)) }
        public static var endDate: Verify { return Verify(method: .p_endDate_get) }
		public static func endDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_endDate_set(newValue)) }
        public static var attribute: Verify { return Verify(method: .p_attribute_get) }
		public static func attribute(set newValue: Parameter<Attribute>) -> Verify { return Verify(method: .p_attribute_set(newValue)) }
        public static var description: Verify { return Verify(method: .p_description_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func compute(forSamples samples: Parameter<[Sample]>, perform: @escaping ([Sample]) -> Void) -> Perform {
            return Perform(method: .m_compute__forSamples_samples(`samples`), performs: perform)
        }
        public static func computeGraphable(forSamples samples: Parameter<[Sample]>, perform: @escaping ([Sample]) -> Void) -> Perform {
            return Perform(method: .m_computeGraphable__forSamples_samples(`samples`), performs: perform)
        }
        public static func equalTo(_ other: Parameter<SampleGroupInformation>, perform: @escaping (SampleGroupInformation) -> Void) -> Perform {
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

// MARK: - SampleGroupInformationFactory

open class SampleGroupInformationFactoryMock: SampleGroupInformationFactory, Mock {
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






    open func getApplicableInformationTypes(forAttribute attribute: Attribute) -> [SampleGroupInformation.Type] {
        addInvocation(.m_getApplicableInformationTypes__forAttribute_attribute(Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_getApplicableInformationTypes__forAttribute_attribute(Parameter<Attribute>.value(`attribute`))) as? (Attribute) -> Void
		perform?(`attribute`)
		var __value: [SampleGroupInformation.Type]
		do {
		    __value = try methodReturnValue(.m_getApplicableInformationTypes__forAttribute_attribute(Parameter<Attribute>.value(`attribute`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getApplicableInformationTypes(forAttribute attribute: Attribute). Use given")
			Failure("Stub return value not specified for getApplicableInformationTypes(forAttribute attribute: Attribute). Use given")
		}
		return __value
    }

    open func getApplicableNumericInformationTypes(forAttribute attribute: Attribute) -> [SampleGroupInformation.Type] {
        addInvocation(.m_getApplicableNumericInformationTypes__forAttribute_attribute(Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_getApplicableNumericInformationTypes__forAttribute_attribute(Parameter<Attribute>.value(`attribute`))) as? (Attribute) -> Void
		perform?(`attribute`)
		var __value: [SampleGroupInformation.Type]
		do {
		    __value = try methodReturnValue(.m_getApplicableNumericInformationTypes__forAttribute_attribute(Parameter<Attribute>.value(`attribute`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getApplicableNumericInformationTypes(forAttribute attribute: Attribute). Use given")
			Failure("Stub return value not specified for getApplicableNumericInformationTypes(forAttribute attribute: Attribute). Use given")
		}
		return __value
    }

    open func initInformation(		_ informationType: SampleGroupInformation.Type,		_ attribute: Attribute	) -> SampleGroupInformation {
        addInvocation(.m_initInformation__informationType_attribute(Parameter<SampleGroupInformation.Type>.value(`informationType`), Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_initInformation__informationType_attribute(Parameter<SampleGroupInformation.Type>.value(`informationType`), Parameter<Attribute>.value(`attribute`))) as? (SampleGroupInformation.Type, Attribute) -> Void
		perform?(`informationType`, `attribute`)
		var __value: SampleGroupInformation
		do {
		    __value = try methodReturnValue(.m_initInformation__informationType_attribute(Parameter<SampleGroupInformation.Type>.value(`informationType`), Parameter<Attribute>.value(`attribute`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for initInformation(  _ informationType: SampleGroupInformation.Type,  _ attribute: Attribute ). Use given")
			Failure("Stub return value not specified for initInformation(  _ informationType: SampleGroupInformation.Type,  _ attribute: Attribute ). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getApplicableInformationTypes__forAttribute_attribute(Parameter<Attribute>)
        case m_getApplicableNumericInformationTypes__forAttribute_attribute(Parameter<Attribute>)
        case m_initInformation__informationType_attribute(Parameter<SampleGroupInformation.Type>, Parameter<Attribute>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getApplicableInformationTypes__forAttribute_attribute(let lhsAttribute), .m_getApplicableInformationTypes__forAttribute_attribute(let rhsAttribute)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "forAttribute attribute"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "forAttribute attribute"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getApplicableNumericInformationTypes__forAttribute_attribute(let lhsAttribute), .m_getApplicableNumericInformationTypes__forAttribute_attribute(let rhsAttribute)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "forAttribute attribute"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "forAttribute attribute"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_initInformation__informationType_attribute(let lhsInformationtype, let lhsAttribute), .m_initInformation__informationType_attribute(let rhsInformationtype, let rhsAttribute)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsInformationtype) && !isCapturing(rhsInformationtype) {
					comparison = Parameter.compare(lhs: lhsInformationtype, rhs: rhsInformationtype, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsInformationtype, rhsInformationtype, "_ informationType"))
				}


				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "_ attribute"))
				}

				if isCapturing(lhsInformationtype) || isCapturing(rhsInformationtype) {
					comparison = Parameter.compare(lhs: lhsInformationtype, rhs: rhsInformationtype, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsInformationtype, rhsInformationtype, "_ informationType"))
				}


				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "_ attribute"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getApplicableInformationTypes__forAttribute_attribute(p0): return p0.intValue
            case let .m_getApplicableNumericInformationTypes__forAttribute_attribute(p0): return p0.intValue
            case let .m_initInformation__informationType_attribute(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getApplicableInformationTypes__forAttribute_attribute: return ".getApplicableInformationTypes(forAttribute:)"
            case .m_getApplicableNumericInformationTypes__forAttribute_attribute: return ".getApplicableNumericInformationTypes(forAttribute:)"
            case .m_initInformation__informationType_attribute: return ".initInformation(_:_:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getApplicableInformationTypes(forAttribute attribute: Parameter<Attribute>, willReturn: [SampleGroupInformation.Type]...) -> MethodStub {
            return Given(method: .m_getApplicableInformationTypes__forAttribute_attribute(`attribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getApplicableNumericInformationTypes(forAttribute attribute: Parameter<Attribute>, willReturn: [SampleGroupInformation.Type]...) -> MethodStub {
            return Given(method: .m_getApplicableNumericInformationTypes__forAttribute_attribute(`attribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func initInformation(_ informationType: Parameter<SampleGroupInformation.Type>, _ attribute: Parameter<Attribute>, willReturn: SampleGroupInformation...) -> MethodStub {
            return Given(method: .m_initInformation__informationType_attribute(`informationType`, `attribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getApplicableInformationTypes(forAttribute attribute: Parameter<Attribute>, willProduce: (Stubber<[SampleGroupInformation.Type]>) -> Void) -> MethodStub {
            let willReturn: [[SampleGroupInformation.Type]] = []
			let given: Given = { return Given(method: .m_getApplicableInformationTypes__forAttribute_attribute(`attribute`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([SampleGroupInformation.Type]).self)
			willProduce(stubber)
			return given
        }
        public static func getApplicableNumericInformationTypes(forAttribute attribute: Parameter<Attribute>, willProduce: (Stubber<[SampleGroupInformation.Type]>) -> Void) -> MethodStub {
            let willReturn: [[SampleGroupInformation.Type]] = []
			let given: Given = { return Given(method: .m_getApplicableNumericInformationTypes__forAttribute_attribute(`attribute`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([SampleGroupInformation.Type]).self)
			willProduce(stubber)
			return given
        }
        public static func initInformation(_ informationType: Parameter<SampleGroupInformation.Type>, _ attribute: Parameter<Attribute>, willProduce: (Stubber<SampleGroupInformation>) -> Void) -> MethodStub {
            let willReturn: [SampleGroupInformation] = []
			let given: Given = { return Given(method: .m_initInformation__informationType_attribute(`informationType`, `attribute`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SampleGroupInformation).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getApplicableInformationTypes(forAttribute attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_getApplicableInformationTypes__forAttribute_attribute(`attribute`))}
        public static func getApplicableNumericInformationTypes(forAttribute attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_getApplicableNumericInformationTypes__forAttribute_attribute(`attribute`))}
        public static func initInformation(_ informationType: Parameter<SampleGroupInformation.Type>, _ attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_initInformation__informationType_attribute(`informationType`, `attribute`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getApplicableInformationTypes(forAttribute attribute: Parameter<Attribute>, perform: @escaping (Attribute) -> Void) -> Perform {
            return Perform(method: .m_getApplicableInformationTypes__forAttribute_attribute(`attribute`), performs: perform)
        }
        public static func getApplicableNumericInformationTypes(forAttribute attribute: Parameter<Attribute>, perform: @escaping (Attribute) -> Void) -> Perform {
            return Perform(method: .m_getApplicableNumericInformationTypes__forAttribute_attribute(`attribute`), performs: perform)
        }
        public static func initInformation(_ informationType: Parameter<SampleGroupInformation.Type>, _ attribute: Parameter<Attribute>, perform: @escaping (SampleGroupInformation.Type, Attribute) -> Void) -> Perform {
            return Perform(method: .m_initInformation__informationType_attribute(`informationType`, `attribute`), performs: perform)
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

