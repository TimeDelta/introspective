//
//  SampleGrouperMock.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/31/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftyMocky
@testable import Introspective
@testable import Attributes
@testable import SampleGroupers
@testable import Samples

// sourcery: mock = "SampleGrouper"
class SampleGrouperMock: SampleGrouper, Mock {

	public final var description: String = ""

// sourcery:inline:auto:SampleGrouperMock.autoMocked
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



    public static var userVisibleDescription: String {
		get {	SampleGrouperMock.invocations.append(.p_userVisibleDescription_get); return SampleGrouperMock.__p_userVisibleDescription ?? givenGetterValue(.p_userVisibleDescription_get, "SampleGrouperMock - stub value for userVisibleDescription was not defined") }
	}
	private static var __p_userVisibleDescription: (String)?





    public required init(sampleType: Sample.Type) { }

    public required init(attributes: [Attribute]) { }

    open func group(samples: [Sample]) throws -> [(Any, [Sample])] {
        addInvocation(.m_group__samples_samples(Parameter<[Sample]>.value(`samples`)))
		let perform = methodPerformValue(.m_group__samples_samples(Parameter<[Sample]>.value(`samples`))) as? ([Sample]) -> Void
		perform?(`samples`)
		var __value: [(Any, [Sample])]
		do {
		    __value = try methodReturnValue(.m_group__samples_samples(Parameter<[Sample]>.value(`samples`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for group(samples: [Sample]). Use given")
			Failure("Stub return value not specified for group(samples: [Sample]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func groupNameFor(value: Any) throws -> String {
        addInvocation(.m_groupNameFor__value_value(Parameter<Any>.value(`value`)))
		let perform = methodPerformValue(.m_groupNameFor__value_value(Parameter<Any>.value(`value`))) as? (Any) -> Void
		perform?(`value`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_groupNameFor__value_value(Parameter<Any>.value(`value`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for groupNameFor(value: Any). Use given")
			Failure("Stub return value not specified for groupNameFor(value: Any). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func groupValuesAreEqual(_ first: Any, _ second: Any) throws -> Bool {
        addInvocation(.m_groupValuesAreEqual__first_second(Parameter<Any>.value(`first`), Parameter<Any>.value(`second`)))
		let perform = methodPerformValue(.m_groupValuesAreEqual__first_second(Parameter<Any>.value(`first`), Parameter<Any>.value(`second`))) as? (Any, Any) -> Void
		perform?(`first`, `second`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_groupValuesAreEqual__first_second(Parameter<Any>.value(`first`), Parameter<Any>.value(`second`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for groupValuesAreEqual(_ first: Any, _ second: Any). Use given")
			Failure("Stub return value not specified for groupValuesAreEqual(_ first: Any, _ second: Any). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func copy() -> SampleGrouper {
        addInvocation(.m_copy)
		let perform = methodPerformValue(.m_copy) as? () -> Void
		perform?()
		var __value: SampleGrouper
		do {
		    __value = try methodReturnValue(.m_copy).casted()
		} catch {
			onFatalFailure("Stub return value not specified for copy(). Use given")
			Failure("Stub return value not specified for copy(). Use given")
		}
		return __value
    }

    open func equalTo(_ otherGrouper: SampleGrouper) -> Bool {
        addInvocation(.m_equalTo__otherGrouper(Parameter<SampleGrouper>.value(`otherGrouper`)))
		let perform = methodPerformValue(.m_equalTo__otherGrouper(Parameter<SampleGrouper>.value(`otherGrouper`))) as? (SampleGrouper) -> Void
		perform?(`otherGrouper`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherGrouper(Parameter<SampleGrouper>.value(`otherGrouper`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherGrouper: SampleGrouper). Use given")
			Failure("Stub return value not specified for equalTo(_ otherGrouper: SampleGrouper). Use given")
		}
		return __value
    }

    fileprivate enum StaticMethodType {
        case p_userVisibleDescription_get

        static func compareParameters(lhs: StaticMethodType, rhs: StaticMethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_userVisibleDescription_get,.p_userVisibleDescription_get): return Matcher.ComparisonResult.match
            }
        }

        func intValue() -> Int {
            switch self {
                case .p_userVisibleDescription_get: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_userVisibleDescription_get: return "[get] .userVisibleDescription"

            }
        }
    }

    open class StaticGiven: StubbedMethod {
        fileprivate var method: StaticMethodType

        private init(method: StaticMethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func userVisibleDescription(getter defaultValue: String...) -> StaticPropertyStub {
            return StaticGiven(method: .p_userVisibleDescription_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct StaticVerify {
        fileprivate var method: StaticMethodType

        public static var userVisibleDescription: StaticVerify { return StaticVerify(method: .p_userVisibleDescription_get) }
    }

    public struct StaticPerform {
        fileprivate var method: StaticMethodType
        var performs: Any

    }

    
    fileprivate enum MethodType {
        case m_group__samples_samples(Parameter<[Sample]>)
        case m_groupNameFor__value_value(Parameter<Any>)
        case m_groupValuesAreEqual__first_second(Parameter<Any>, Parameter<Any>)
        case m_copy
        case m_equalTo__otherGrouper(Parameter<SampleGrouper>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_group__samples_samples(let lhsSamples), .m_group__samples_samples(let rhsSamples)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_groupNameFor__value_value(let lhsValue), .m_groupNameFor__value_value(let rhsValue)):
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

            case (.m_groupValuesAreEqual__first_second(let lhsFirst, let lhsSecond), .m_groupValuesAreEqual__first_second(let rhsFirst, let rhsSecond)):
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

            case (.m_copy, .m_copy): return .match

            case (.m_equalTo__otherGrouper(let lhsOthergrouper), .m_equalTo__otherGrouper(let rhsOthergrouper)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsOthergrouper) && !isCapturing(rhsOthergrouper) {
					comparison = Parameter.compare(lhs: lhsOthergrouper, rhs: rhsOthergrouper, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOthergrouper, rhsOthergrouper, "_ otherGrouper"))
				}

				if isCapturing(lhsOthergrouper) || isCapturing(rhsOthergrouper) {
					comparison = Parameter.compare(lhs: lhsOthergrouper, rhs: rhsOthergrouper, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOthergrouper, rhsOthergrouper, "_ otherGrouper"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_group__samples_samples(p0): return p0.intValue
            case let .m_groupNameFor__value_value(p0): return p0.intValue
            case let .m_groupValuesAreEqual__first_second(p0, p1): return p0.intValue + p1.intValue
            case .m_copy: return 0
            case let .m_equalTo__otherGrouper(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_group__samples_samples: return ".group(samples:)"
            case .m_groupNameFor__value_value: return ".groupNameFor(value:)"
            case .m_groupValuesAreEqual__first_second: return ".groupValuesAreEqual(_:_:)"
            case .m_copy: return ".copy()"
            case .m_equalTo__otherGrouper: return ".equalTo(_:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func group(samples: Parameter<[Sample]>, willReturn: [(Any, [Sample])]...) -> MethodStub {
            return Given(method: .m_group__samples_samples(`samples`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func groupNameFor(value: Parameter<Any>, willReturn: String...) -> MethodStub {
            return Given(method: .m_groupNameFor__value_value(`value`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func groupValuesAreEqual(_ first: Parameter<Any>, _ second: Parameter<Any>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_groupValuesAreEqual__first_second(`first`, `second`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func copy(willReturn: SampleGrouper...) -> MethodStub {
            return Given(method: .m_copy, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherGrouper: Parameter<SampleGrouper>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherGrouper(`otherGrouper`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func copy(willProduce: (Stubber<SampleGrouper>) -> Void) -> MethodStub {
            let willReturn: [SampleGrouper] = []
			let given: Given = { return Given(method: .m_copy, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SampleGrouper).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ otherGrouper: Parameter<SampleGrouper>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherGrouper(`otherGrouper`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func group(samples: Parameter<[Sample]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_group__samples_samples(`samples`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func group(samples: Parameter<[Sample]>, willProduce: (StubberThrows<[(Any, [Sample])]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_group__samples_samples(`samples`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(Any, [Sample])]).self)
			willProduce(stubber)
			return given
        }
        public static func groupNameFor(value: Parameter<Any>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_groupNameFor__value_value(`value`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func groupNameFor(value: Parameter<Any>, willProduce: (StubberThrows<String>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_groupNameFor__value_value(`value`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func groupValuesAreEqual(_ first: Parameter<Any>, _ second: Parameter<Any>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_groupValuesAreEqual__first_second(`first`, `second`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func groupValuesAreEqual(_ first: Parameter<Any>, _ second: Parameter<Any>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_groupValuesAreEqual__first_second(`first`, `second`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func group(samples: Parameter<[Sample]>) -> Verify { return Verify(method: .m_group__samples_samples(`samples`))}
        public static func groupNameFor(value: Parameter<Any>) -> Verify { return Verify(method: .m_groupNameFor__value_value(`value`))}
        public static func groupValuesAreEqual(_ first: Parameter<Any>, _ second: Parameter<Any>) -> Verify { return Verify(method: .m_groupValuesAreEqual__first_second(`first`, `second`))}
        public static func copy() -> Verify { return Verify(method: .m_copy)}
        public static func equalTo(_ otherGrouper: Parameter<SampleGrouper>) -> Verify { return Verify(method: .m_equalTo__otherGrouper(`otherGrouper`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func group(samples: Parameter<[Sample]>, perform: @escaping ([Sample]) -> Void) -> Perform {
            return Perform(method: .m_group__samples_samples(`samples`), performs: perform)
        }
        public static func groupNameFor(value: Parameter<Any>, perform: @escaping (Any) -> Void) -> Perform {
            return Perform(method: .m_groupNameFor__value_value(`value`), performs: perform)
        }
        public static func groupValuesAreEqual(_ first: Parameter<Any>, _ second: Parameter<Any>, perform: @escaping (Any, Any) -> Void) -> Perform {
            return Perform(method: .m_groupValuesAreEqual__first_second(`first`, `second`), performs: perform)
        }
        public static func copy(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_copy, performs: perform)
        }
        public static func equalTo(_ otherGrouper: Parameter<SampleGrouper>, perform: @escaping (SampleGrouper) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherGrouper(`otherGrouper`), performs: perform)
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

    static public func given(_ method: StaticGiven) {
        methodReturnValues.append(method)
    }

    static public func perform(_ method: StaticPerform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    static public func verify(_ method: StaticVerify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return StaticMethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    static private func addInvocation(_ call: StaticMethodType) {
        invocations.append(call)
    }
    static private func methodReturnValue(_ method: StaticMethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    static private func methodPerformValue(_ method: StaticMethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    static private func matchingCalls(_ method: StaticMethodType, file: StaticString?, line: UInt?) -> [StaticMethodType] {
        matcher.set(file: file, line: line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { StaticMethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    static private func matchingCalls(_ method: StaticVerify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
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
