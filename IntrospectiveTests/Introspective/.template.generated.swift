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
























// MARK: - CoachMarkFactory

open class CoachMarkFactoryMock: CoachMarkFactory, Mock {
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






    open func controller() -> CoachMarksControllerProtocol {
        addInvocation(.m_controller)
		let perform = methodPerformValue(.m_controller) as? () -> Void
		perform?()
		var __value: CoachMarksControllerProtocol
		do {
		    __value = try methodReturnValue(.m_controller).casted()
		} catch {
			onFatalFailure("Stub return value not specified for controller(). Use given")
			Failure("Stub return value not specified for controller(). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_controller

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_controller, .m_controller): return .match
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_controller: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_controller: return ".controller()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func controller(willReturn: CoachMarksControllerProtocol...) -> MethodStub {
            return Given(method: .m_controller, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func controller(willProduce: (Stubber<CoachMarksControllerProtocol>) -> Void) -> MethodStub {
            let willReturn: [CoachMarksControllerProtocol] = []
			let given: Given = { return Given(method: .m_controller, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (CoachMarksControllerProtocol).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func controller() -> Verify { return Verify(method: .m_controller)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func controller(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_controller, performs: perform)
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

// MARK: - CoachMarksControllerProtocol

open class CoachMarksControllerProtocolMock: CoachMarksControllerProtocol, Mock {
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


    public var dataSource: CoachMarksControllerDataSource? {
		get {	invocations.append(.p_dataSource_get); return __p_dataSource ?? optionalGivenGetterValue(.p_dataSource_get, "CoachMarksControllerProtocolMock - stub value for dataSource was not defined") }
		set {	invocations.append(.p_dataSource_set(.value(newValue))); __p_dataSource = newValue }
	}
	private var __p_dataSource: (CoachMarksControllerDataSource)?

    public var delegate: CoachMarksControllerDelegate? {
		get {	invocations.append(.p_delegate_get); return __p_delegate ?? optionalGivenGetterValue(.p_delegate_get, "CoachMarksControllerProtocolMock - stub value for delegate was not defined") }
		set {	invocations.append(.p_delegate_set(.value(newValue))); __p_delegate = newValue }
	}
	private var __p_delegate: (CoachMarksControllerDelegate)?

    public var animationDelegate: CoachMarksControllerAnimationDelegate? {
		get {	invocations.append(.p_animationDelegate_get); return __p_animationDelegate ?? optionalGivenGetterValue(.p_animationDelegate_get, "CoachMarksControllerProtocolMock - stub value for animationDelegate was not defined") }
		set {	invocations.append(.p_animationDelegate_set(.value(newValue))); __p_animationDelegate = newValue }
	}
	private var __p_animationDelegate: (CoachMarksControllerAnimationDelegate)?

    public var statusBarStyle: UIStatusBarStyle? {
		get {	invocations.append(.p_statusBarStyle_get); return __p_statusBarStyle ?? optionalGivenGetterValue(.p_statusBarStyle_get, "CoachMarksControllerProtocolMock - stub value for statusBarStyle was not defined") }
		set {	invocations.append(.p_statusBarStyle_set(.value(newValue))); __p_statusBarStyle = newValue }
	}
	private var __p_statusBarStyle: (UIStatusBarStyle)?

    public var rotationStyle: RotationStyle {
		get {	invocations.append(.p_rotationStyle_get); return __p_rotationStyle ?? givenGetterValue(.p_rotationStyle_get, "CoachMarksControllerProtocolMock - stub value for rotationStyle was not defined") }
		set {	invocations.append(.p_rotationStyle_set(.value(newValue))); __p_rotationStyle = newValue }
	}
	private var __p_rotationStyle: (RotationStyle)?

    public var statusBarVisibility: StatusBarVisibility {
		get {	invocations.append(.p_statusBarVisibility_get); return __p_statusBarVisibility ?? givenGetterValue(.p_statusBarVisibility_get, "CoachMarksControllerProtocolMock - stub value for statusBarVisibility was not defined") }
		set {	invocations.append(.p_statusBarVisibility_set(.value(newValue))); __p_statusBarVisibility = newValue }
	}
	private var __p_statusBarVisibility: (StatusBarVisibility)?

    public var interfaceOrientations: InterfaceOrientations {
		get {	invocations.append(.p_interfaceOrientations_get); return __p_interfaceOrientations ?? givenGetterValue(.p_interfaceOrientations_get, "CoachMarksControllerProtocolMock - stub value for interfaceOrientations was not defined") }
		set {	invocations.append(.p_interfaceOrientations_set(.value(newValue))); __p_interfaceOrientations = newValue }
	}
	private var __p_interfaceOrientations: (InterfaceOrientations)?

    public var skipView: CoachMarkSkipView? {
		get {	invocations.append(.p_skipView_get); return __p_skipView ?? optionalGivenGetterValue(.p_skipView_get, "CoachMarksControllerProtocolMock - stub value for skipView was not defined") }
		set {	invocations.append(.p_skipView_set(.value(newValue))); __p_skipView = newValue }
	}
	private var __p_skipView: (CoachMarkSkipView)?





    open func start(in presentationContext: PresentationContext) {
        addInvocation(.m_start__in_presentationContext(Parameter<PresentationContext>.value(`presentationContext`)))
		let perform = methodPerformValue(.m_start__in_presentationContext(Parameter<PresentationContext>.value(`presentationContext`))) as? (PresentationContext) -> Void
		perform?(`presentationContext`)
    }

    open func stop(immediately: Bool) {
        addInvocation(.m_stop__immediately_immediately(Parameter<Bool>.value(`immediately`)))
		let perform = methodPerformValue(.m_stop__immediately_immediately(Parameter<Bool>.value(`immediately`))) as? (Bool) -> Void
		perform?(`immediately`)
    }

    open func prepareForChange() {
        addInvocation(.m_prepareForChange)
		let perform = methodPerformValue(.m_prepareForChange) as? () -> Void
		perform?()
    }

    open func restoreAfterChangeDidComplete() {
        addInvocation(.m_restoreAfterChangeDidComplete)
		let perform = methodPerformValue(.m_restoreAfterChangeDidComplete) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_start__in_presentationContext(Parameter<PresentationContext>)
        case m_stop__immediately_immediately(Parameter<Bool>)
        case m_prepareForChange
        case m_restoreAfterChangeDidComplete
        case p_dataSource_get
		case p_dataSource_set(Parameter<CoachMarksControllerDataSource?>)
        case p_delegate_get
		case p_delegate_set(Parameter<CoachMarksControllerDelegate?>)
        case p_animationDelegate_get
		case p_animationDelegate_set(Parameter<CoachMarksControllerAnimationDelegate?>)
        case p_statusBarStyle_get
		case p_statusBarStyle_set(Parameter<UIStatusBarStyle?>)
        case p_rotationStyle_get
		case p_rotationStyle_set(Parameter<RotationStyle>)
        case p_statusBarVisibility_get
		case p_statusBarVisibility_set(Parameter<StatusBarVisibility>)
        case p_interfaceOrientations_get
		case p_interfaceOrientations_set(Parameter<InterfaceOrientations>)
        case p_skipView_get
		case p_skipView_set(Parameter<CoachMarkSkipView?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_start__in_presentationContext(let lhsPresentationcontext), .m_start__in_presentationContext(let rhsPresentationcontext)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsPresentationcontext) && !isCapturing(rhsPresentationcontext) {
					comparison = Parameter.compare(lhs: lhsPresentationcontext, rhs: rhsPresentationcontext, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPresentationcontext, rhsPresentationcontext, "in presentationContext"))
				}

				if isCapturing(lhsPresentationcontext) || isCapturing(rhsPresentationcontext) {
					comparison = Parameter.compare(lhs: lhsPresentationcontext, rhs: rhsPresentationcontext, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPresentationcontext, rhsPresentationcontext, "in presentationContext"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_stop__immediately_immediately(let lhsImmediately), .m_stop__immediately_immediately(let rhsImmediately)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsImmediately) && !isCapturing(rhsImmediately) {
					comparison = Parameter.compare(lhs: lhsImmediately, rhs: rhsImmediately, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsImmediately, rhsImmediately, "immediately"))
				}

				if isCapturing(lhsImmediately) || isCapturing(rhsImmediately) {
					comparison = Parameter.compare(lhs: lhsImmediately, rhs: rhsImmediately, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsImmediately, rhsImmediately, "immediately"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_prepareForChange, .m_prepareForChange): return .match

            case (.m_restoreAfterChangeDidComplete, .m_restoreAfterChangeDidComplete): return .match
            case (.p_dataSource_get,.p_dataSource_get): return Matcher.ComparisonResult.match
			case (.p_dataSource_set(let left),.p_dataSource_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<CoachMarksControllerDataSource?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_delegate_get,.p_delegate_get): return Matcher.ComparisonResult.match
			case (.p_delegate_set(let left),.p_delegate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<CoachMarksControllerDelegate?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_animationDelegate_get,.p_animationDelegate_get): return Matcher.ComparisonResult.match
			case (.p_animationDelegate_set(let left),.p_animationDelegate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<CoachMarksControllerAnimationDelegate?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_statusBarStyle_get,.p_statusBarStyle_get): return Matcher.ComparisonResult.match
			case (.p_statusBarStyle_set(let left),.p_statusBarStyle_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<UIStatusBarStyle?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_rotationStyle_get,.p_rotationStyle_get): return Matcher.ComparisonResult.match
			case (.p_rotationStyle_set(let left),.p_rotationStyle_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<RotationStyle>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_statusBarVisibility_get,.p_statusBarVisibility_get): return Matcher.ComparisonResult.match
			case (.p_statusBarVisibility_set(let left),.p_statusBarVisibility_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<StatusBarVisibility>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_interfaceOrientations_get,.p_interfaceOrientations_get): return Matcher.ComparisonResult.match
			case (.p_interfaceOrientations_set(let left),.p_interfaceOrientations_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<InterfaceOrientations>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_skipView_get,.p_skipView_get): return Matcher.ComparisonResult.match
			case (.p_skipView_set(let left),.p_skipView_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<CoachMarkSkipView?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_start__in_presentationContext(p0): return p0.intValue
            case let .m_stop__immediately_immediately(p0): return p0.intValue
            case .m_prepareForChange: return 0
            case .m_restoreAfterChangeDidComplete: return 0
            case .p_dataSource_get: return 0
			case .p_dataSource_set(let newValue): return newValue.intValue
            case .p_delegate_get: return 0
			case .p_delegate_set(let newValue): return newValue.intValue
            case .p_animationDelegate_get: return 0
			case .p_animationDelegate_set(let newValue): return newValue.intValue
            case .p_statusBarStyle_get: return 0
			case .p_statusBarStyle_set(let newValue): return newValue.intValue
            case .p_rotationStyle_get: return 0
			case .p_rotationStyle_set(let newValue): return newValue.intValue
            case .p_statusBarVisibility_get: return 0
			case .p_statusBarVisibility_set(let newValue): return newValue.intValue
            case .p_interfaceOrientations_get: return 0
			case .p_interfaceOrientations_set(let newValue): return newValue.intValue
            case .p_skipView_get: return 0
			case .p_skipView_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_start__in_presentationContext: return ".start(in:)"
            case .m_stop__immediately_immediately: return ".stop(immediately:)"
            case .m_prepareForChange: return ".prepareForChange()"
            case .m_restoreAfterChangeDidComplete: return ".restoreAfterChangeDidComplete()"
            case .p_dataSource_get: return "[get] .dataSource"
			case .p_dataSource_set: return "[set] .dataSource"
            case .p_delegate_get: return "[get] .delegate"
			case .p_delegate_set: return "[set] .delegate"
            case .p_animationDelegate_get: return "[get] .animationDelegate"
			case .p_animationDelegate_set: return "[set] .animationDelegate"
            case .p_statusBarStyle_get: return "[get] .statusBarStyle"
			case .p_statusBarStyle_set: return "[set] .statusBarStyle"
            case .p_rotationStyle_get: return "[get] .rotationStyle"
			case .p_rotationStyle_set: return "[set] .rotationStyle"
            case .p_statusBarVisibility_get: return "[get] .statusBarVisibility"
			case .p_statusBarVisibility_set: return "[set] .statusBarVisibility"
            case .p_interfaceOrientations_get: return "[get] .interfaceOrientations"
			case .p_interfaceOrientations_set: return "[set] .interfaceOrientations"
            case .p_skipView_get: return "[get] .skipView"
			case .p_skipView_set: return "[set] .skipView"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func dataSource(getter defaultValue: CoachMarksControllerDataSource?...) -> PropertyStub {
            return Given(method: .p_dataSource_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func delegate(getter defaultValue: CoachMarksControllerDelegate?...) -> PropertyStub {
            return Given(method: .p_delegate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func animationDelegate(getter defaultValue: CoachMarksControllerAnimationDelegate?...) -> PropertyStub {
            return Given(method: .p_animationDelegate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func statusBarStyle(getter defaultValue: UIStatusBarStyle?...) -> PropertyStub {
            return Given(method: .p_statusBarStyle_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func rotationStyle(getter defaultValue: RotationStyle...) -> PropertyStub {
            return Given(method: .p_rotationStyle_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func statusBarVisibility(getter defaultValue: StatusBarVisibility...) -> PropertyStub {
            return Given(method: .p_statusBarVisibility_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func interfaceOrientations(getter defaultValue: InterfaceOrientations...) -> PropertyStub {
            return Given(method: .p_interfaceOrientations_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func skipView(getter defaultValue: CoachMarkSkipView?...) -> PropertyStub {
            return Given(method: .p_skipView_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func start(in presentationContext: Parameter<PresentationContext>) -> Verify { return Verify(method: .m_start__in_presentationContext(`presentationContext`))}
        public static func stop(immediately: Parameter<Bool>) -> Verify { return Verify(method: .m_stop__immediately_immediately(`immediately`))}
        public static func prepareForChange() -> Verify { return Verify(method: .m_prepareForChange)}
        public static func restoreAfterChangeDidComplete() -> Verify { return Verify(method: .m_restoreAfterChangeDidComplete)}
        public static var dataSource: Verify { return Verify(method: .p_dataSource_get) }
		public static func dataSource(set newValue: Parameter<CoachMarksControllerDataSource?>) -> Verify { return Verify(method: .p_dataSource_set(newValue)) }
        public static var delegate: Verify { return Verify(method: .p_delegate_get) }
		public static func delegate(set newValue: Parameter<CoachMarksControllerDelegate?>) -> Verify { return Verify(method: .p_delegate_set(newValue)) }
        public static var animationDelegate: Verify { return Verify(method: .p_animationDelegate_get) }
		public static func animationDelegate(set newValue: Parameter<CoachMarksControllerAnimationDelegate?>) -> Verify { return Verify(method: .p_animationDelegate_set(newValue)) }
        public static var statusBarStyle: Verify { return Verify(method: .p_statusBarStyle_get) }
		public static func statusBarStyle(set newValue: Parameter<UIStatusBarStyle?>) -> Verify { return Verify(method: .p_statusBarStyle_set(newValue)) }
        public static var rotationStyle: Verify { return Verify(method: .p_rotationStyle_get) }
		public static func rotationStyle(set newValue: Parameter<RotationStyle>) -> Verify { return Verify(method: .p_rotationStyle_set(newValue)) }
        public static var statusBarVisibility: Verify { return Verify(method: .p_statusBarVisibility_get) }
		public static func statusBarVisibility(set newValue: Parameter<StatusBarVisibility>) -> Verify { return Verify(method: .p_statusBarVisibility_set(newValue)) }
        public static var interfaceOrientations: Verify { return Verify(method: .p_interfaceOrientations_get) }
		public static func interfaceOrientations(set newValue: Parameter<InterfaceOrientations>) -> Verify { return Verify(method: .p_interfaceOrientations_set(newValue)) }
        public static var skipView: Verify { return Verify(method: .p_skipView_get) }
		public static func skipView(set newValue: Parameter<CoachMarkSkipView?>) -> Verify { return Verify(method: .p_skipView_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func start(in presentationContext: Parameter<PresentationContext>, perform: @escaping (PresentationContext) -> Void) -> Perform {
            return Perform(method: .m_start__in_presentationContext(`presentationContext`), performs: perform)
        }
        public static func stop(immediately: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_stop__immediately_immediately(`immediately`), performs: perform)
        }
        public static func prepareForChange(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_prepareForChange, performs: perform)
        }
        public static func restoreAfterChangeDidComplete(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_restoreAfterChangeDidComplete, performs: perform)
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

