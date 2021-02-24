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

// MARK: - AttributeRestrictionFactory

open class AttributeRestrictionFactoryMock: AttributeRestrictionFactory, Mock {
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






    open func typesFor(_ attribute: Attribute) -> [AttributeRestriction.Type] {
        addInvocation(.m_typesFor__attribute(Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_typesFor__attribute(Parameter<Attribute>.value(`attribute`))) as? (Attribute) -> Void
		perform?(`attribute`)
		var __value: [AttributeRestriction.Type]
		do {
		    __value = try methodReturnValue(.m_typesFor__attribute(Parameter<Attribute>.value(`attribute`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for typesFor(_ attribute: Attribute). Use given")
			Failure("Stub return value not specified for typesFor(_ attribute: Attribute). Use given")
		}
		return __value
    }

    open func initialize(type: AttributeRestriction.Type, forAttribute attribute: Attribute) -> AttributeRestriction {
        addInvocation(.m_initialize__type_typeforAttribute_attribute(Parameter<AttributeRestriction.Type>.value(`type`), Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_initialize__type_typeforAttribute_attribute(Parameter<AttributeRestriction.Type>.value(`type`), Parameter<Attribute>.value(`attribute`))) as? (AttributeRestriction.Type, Attribute) -> Void
		perform?(`type`, `attribute`)
		var __value: AttributeRestriction
		do {
		    __value = try methodReturnValue(.m_initialize__type_typeforAttribute_attribute(Parameter<AttributeRestriction.Type>.value(`type`), Parameter<Attribute>.value(`attribute`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for initialize(type: AttributeRestriction.Type, forAttribute attribute: Attribute). Use given")
			Failure("Stub return value not specified for initialize(type: AttributeRestriction.Type, forAttribute attribute: Attribute). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_typesFor__attribute(Parameter<Attribute>)
        case m_initialize__type_typeforAttribute_attribute(Parameter<AttributeRestriction.Type>, Parameter<Attribute>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_typesFor__attribute(let lhsAttribute), .m_typesFor__attribute(let rhsAttribute)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "_ attribute"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "_ attribute"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_initialize__type_typeforAttribute_attribute(let lhsType, let lhsAttribute), .m_initialize__type_typeforAttribute_attribute(let rhsType, let rhsAttribute)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsType) && !isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "type"))
				}


				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "forAttribute attribute"))
				}

				if isCapturing(lhsType) || isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "type"))
				}


				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "forAttribute attribute"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_typesFor__attribute(p0): return p0.intValue
            case let .m_initialize__type_typeforAttribute_attribute(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_typesFor__attribute: return ".typesFor(_:)"
            case .m_initialize__type_typeforAttribute_attribute: return ".initialize(type:forAttribute:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func typesFor(_ attribute: Parameter<Attribute>, willReturn: [AttributeRestriction.Type]...) -> MethodStub {
            return Given(method: .m_typesFor__attribute(`attribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func initialize(type: Parameter<AttributeRestriction.Type>, forAttribute attribute: Parameter<Attribute>, willReturn: AttributeRestriction...) -> MethodStub {
            return Given(method: .m_initialize__type_typeforAttribute_attribute(`type`, `attribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func typesFor(_ attribute: Parameter<Attribute>, willProduce: (Stubber<[AttributeRestriction.Type]>) -> Void) -> MethodStub {
            let willReturn: [[AttributeRestriction.Type]] = []
			let given: Given = { return Given(method: .m_typesFor__attribute(`attribute`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([AttributeRestriction.Type]).self)
			willProduce(stubber)
			return given
        }
        public static func initialize(type: Parameter<AttributeRestriction.Type>, forAttribute attribute: Parameter<Attribute>, willProduce: (Stubber<AttributeRestriction>) -> Void) -> MethodStub {
            let willReturn: [AttributeRestriction] = []
			let given: Given = { return Given(method: .m_initialize__type_typeforAttribute_attribute(`type`, `attribute`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (AttributeRestriction).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func typesFor(_ attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_typesFor__attribute(`attribute`))}
        public static func initialize(type: Parameter<AttributeRestriction.Type>, forAttribute attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_initialize__type_typeforAttribute_attribute(`type`, `attribute`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func typesFor(_ attribute: Parameter<Attribute>, perform: @escaping (Attribute) -> Void) -> Perform {
            return Perform(method: .m_typesFor__attribute(`attribute`), performs: perform)
        }
        public static func initialize(type: Parameter<AttributeRestriction.Type>, forAttribute attribute: Parameter<Attribute>, perform: @escaping (AttributeRestriction.Type, Attribute) -> Void) -> Perform {
            return Perform(method: .m_initialize__type_typeforAttribute_attribute(`type`, `attribute`), performs: perform)
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

