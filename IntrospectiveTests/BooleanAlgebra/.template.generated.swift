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


// MARK: - BooleanExpressionParser

open class BooleanExpressionParserMock: BooleanExpressionParser, Mock {
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






    open func parse(_ parts: [BooleanExpressionPart]) throws -> BooleanExpression {
        addInvocation(.m_parse__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_parse__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: BooleanExpression
		do {
		    __value = try methodReturnValue(.m_parse__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for parse(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for parse(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_parse__parts(Parameter<[BooleanExpressionPart]>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_parse__parts(let lhsParts), .m_parse__parts(let rhsParts)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsParts) && !isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				if isCapturing(lhsParts) || isCapturing(rhsParts) {
					comparison = Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsParts, rhsParts, "_ parts"))
				}

				return Matcher.ComparisonResult(results)
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_parse__parts(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_parse__parts: return ".parse(_:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func parse(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: BooleanExpression...) -> MethodStub {
            return Given(method: .m_parse__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func parse(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_parse__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func parse(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<BooleanExpression>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_parse__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (BooleanExpression).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func parse(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_parse__parts(`parts`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func parse(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_parse__parts(`parts`), performs: perform)
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

