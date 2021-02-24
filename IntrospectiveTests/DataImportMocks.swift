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


// MARK: - ATrackerActivityImporter

open class ATrackerActivityImporterMock: ATrackerActivityImporter, Mock {
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


    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "ATrackerActivityImporterMock - stub value for dataTypePluralName was not defined") }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "ATrackerActivityImporterMock - stub value for sourceName was not defined") }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "ATrackerActivityImporterMock - stub value for customImportMessage was not defined") }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "ATrackerActivityImporterMock - stub value for lastImport was not defined") }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "ATrackerActivityImporterMock - stub value for isPaused was not defined") }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "ATrackerActivityImporterMock - stub value for isCancelled was not defined") }
	}
	private var __p_isCancelled: (Bool)?

    public var importOnlyNewData: Bool {
		get {	invocations.append(.p_importOnlyNewData_get); return __p_importOnlyNewData ?? givenGetterValue(.p_importOnlyNewData_get, "ATrackerActivityImporterMock - stub value for importOnlyNewData was not defined") }
		set {	invocations.append(.p_importOnlyNewData_set(.value(newValue))); __p_importOnlyNewData = newValue }
	}
	private var __p_importOnlyNewData: (Bool)?





    open func importData(from url: URL) throws {
        addInvocation(.m_importData__from_url(Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_importData__from_url(Parameter<URL>.value(`url`))) as? (URL) -> Void
		perform?(`url`)
		do {
		    _ = try methodReturnValue(.m_importData__from_url(Parameter<URL>.value(`url`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func resetLastImportDate() throws {
        addInvocation(.m_resetLastImportDate)
		let perform = methodPerformValue(.m_resetLastImportDate) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resetLastImportDate).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func percentComplete() -> Double {
        addInvocation(.m_percentComplete)
		let perform = methodPerformValue(.m_percentComplete) as? () -> Void
		perform?()
		var __value: Double
		do {
		    __value = try methodReturnValue(.m_percentComplete).casted()
		} catch {
			onFatalFailure("Stub return value not specified for percentComplete(). Use given")
			Failure("Stub return value not specified for percentComplete(). Use given")
		}
		return __value
    }

    open func cancel() {
        addInvocation(.m_cancel)
		let perform = methodPerformValue(.m_cancel) as? () -> Void
		perform?()
    }

    open func pause() {
        addInvocation(.m_pause)
		let perform = methodPerformValue(.m_pause) as? () -> Void
		perform?()
    }

    open func resume() throws {
        addInvocation(.m_resume)
		let perform = methodPerformValue(.m_resume) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resume).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func equalTo(_ other: Importer) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<Importer>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<Importer>.value(`other`))) as? (Importer) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<Importer>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: Importer). Use given")
			Failure("Stub return value not specified for equalTo(_ other: Importer). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_importData__from_url(Parameter<URL>)
        case m_resetLastImportDate
        case m_percentComplete
        case m_cancel
        case m_pause
        case m_resume
        case m_equalTo__other(Parameter<Importer>)
        case p_dataTypePluralName_get
        case p_sourceName_get
        case p_customImportMessage_get
        case p_lastImport_get
        case p_isPaused_get
        case p_isCancelled_get
        case p_importOnlyNewData_get
		case p_importOnlyNewData_set(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsUrl) && !isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				if isCapturing(lhsUrl) || isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_resetLastImportDate, .m_resetLastImportDate): return .match

            case (.m_percentComplete, .m_percentComplete): return .match

            case (.m_cancel, .m_cancel): return .match

            case (.m_pause, .m_pause): return .match

            case (.m_resume, .m_resume): return .match

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
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return Matcher.ComparisonResult.match
            case (.p_sourceName_get,.p_sourceName_get): return Matcher.ComparisonResult.match
            case (.p_customImportMessage_get,.p_customImportMessage_get): return Matcher.ComparisonResult.match
            case (.p_lastImport_get,.p_lastImport_get): return Matcher.ComparisonResult.match
            case (.p_isPaused_get,.p_isPaused_get): return Matcher.ComparisonResult.match
            case (.p_isCancelled_get,.p_isCancelled_get): return Matcher.ComparisonResult.match
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return Matcher.ComparisonResult.match
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_importData__from_url(p0): return p0.intValue
            case .m_resetLastImportDate: return 0
            case .m_percentComplete: return 0
            case .m_cancel: return 0
            case .m_pause: return 0
            case .m_resume: return 0
            case let .m_equalTo__other(p0): return p0.intValue
            case .p_dataTypePluralName_get: return 0
            case .p_sourceName_get: return 0
            case .p_customImportMessage_get: return 0
            case .p_lastImport_get: return 0
            case .p_isPaused_get: return 0
            case .p_isCancelled_get: return 0
            case .p_importOnlyNewData_get: return 0
			case .p_importOnlyNewData_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_importData__from_url: return ".importData(from:)"
            case .m_resetLastImportDate: return ".resetLastImportDate()"
            case .m_percentComplete: return ".percentComplete()"
            case .m_cancel: return ".cancel()"
            case .m_pause: return ".pause()"
            case .m_resume: return ".resume()"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .p_dataTypePluralName_get: return "[get] .dataTypePluralName"
            case .p_sourceName_get: return "[get] .sourceName"
            case .p_customImportMessage_get: return "[get] .customImportMessage"
            case .p_lastImport_get: return "[get] .lastImport"
            case .p_isPaused_get: return "[get] .isPaused"
            case .p_isCancelled_get: return "[get] .isCancelled"
            case .p_importOnlyNewData_get: return "[get] .importOnlyNewData"
			case .p_importOnlyNewData_set: return "[set] .importOnlyNewData"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func dataTypePluralName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_dataTypePluralName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func sourceName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_sourceName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func customImportMessage(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_customImportMessage_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastImport(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_lastImport_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isPaused(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isPaused_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isCancelled(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isCancelled_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func importOnlyNewData(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_importOnlyNewData_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func percentComplete(willReturn: Double...) -> MethodStub {
            return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<Importer>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func percentComplete(willProduce: (Stubber<Double>) -> Void) -> MethodStub {
            let willReturn: [Double] = []
			let given: Given = { return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Double).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ other: Parameter<Importer>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func importData(from url: Parameter<URL>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func importData(from url: Parameter<URL>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resetLastImportDate(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resetLastImportDate(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resume(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resume(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func importData(from url: Parameter<URL>) -> Verify { return Verify(method: .m_importData__from_url(`url`))}
        public static func resetLastImportDate() -> Verify { return Verify(method: .m_resetLastImportDate)}
        public static func percentComplete() -> Verify { return Verify(method: .m_percentComplete)}
        public static func cancel() -> Verify { return Verify(method: .m_cancel)}
        public static func pause() -> Verify { return Verify(method: .m_pause)}
        public static func resume() -> Verify { return Verify(method: .m_resume)}
        public static func equalTo(_ other: Parameter<Importer>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static var dataTypePluralName: Verify { return Verify(method: .p_dataTypePluralName_get) }
        public static var sourceName: Verify { return Verify(method: .p_sourceName_get) }
        public static var customImportMessage: Verify { return Verify(method: .p_customImportMessage_get) }
        public static var lastImport: Verify { return Verify(method: .p_lastImport_get) }
        public static var isPaused: Verify { return Verify(method: .p_isPaused_get) }
        public static var isCancelled: Verify { return Verify(method: .p_isCancelled_get) }
        public static var importOnlyNewData: Verify { return Verify(method: .p_importOnlyNewData_get) }
		public static func importOnlyNewData(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_importOnlyNewData_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func importData(from url: Parameter<URL>, perform: @escaping (URL) -> Void) -> Perform {
            return Perform(method: .m_importData__from_url(`url`), performs: perform)
        }
        public static func resetLastImportDate(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetLastImportDate, performs: perform)
        }
        public static func percentComplete(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_percentComplete, performs: perform)
        }
        public static func cancel(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_cancel, performs: perform)
        }
        public static func pause(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_pause, performs: perform)
        }
        public static func resume(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resume, performs: perform)
        }
        public static func equalTo(_ other: Parameter<Importer>, perform: @escaping (Importer) -> Void) -> Perform {
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

// MARK: - EasyPillMedicationDoseImporter

open class EasyPillMedicationDoseImporterMock: EasyPillMedicationDoseImporter, Mock {
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


    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "EasyPillMedicationDoseImporterMock - stub value for dataTypePluralName was not defined") }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "EasyPillMedicationDoseImporterMock - stub value for sourceName was not defined") }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "EasyPillMedicationDoseImporterMock - stub value for customImportMessage was not defined") }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "EasyPillMedicationDoseImporterMock - stub value for lastImport was not defined") }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "EasyPillMedicationDoseImporterMock - stub value for isPaused was not defined") }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "EasyPillMedicationDoseImporterMock - stub value for isCancelled was not defined") }
	}
	private var __p_isCancelled: (Bool)?

    public var importOnlyNewData: Bool {
		get {	invocations.append(.p_importOnlyNewData_get); return __p_importOnlyNewData ?? givenGetterValue(.p_importOnlyNewData_get, "EasyPillMedicationDoseImporterMock - stub value for importOnlyNewData was not defined") }
		set {	invocations.append(.p_importOnlyNewData_set(.value(newValue))); __p_importOnlyNewData = newValue }
	}
	private var __p_importOnlyNewData: (Bool)?





    open func importData(from url: URL) throws {
        addInvocation(.m_importData__from_url(Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_importData__from_url(Parameter<URL>.value(`url`))) as? (URL) -> Void
		perform?(`url`)
		do {
		    _ = try methodReturnValue(.m_importData__from_url(Parameter<URL>.value(`url`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func resetLastImportDate() throws {
        addInvocation(.m_resetLastImportDate)
		let perform = methodPerformValue(.m_resetLastImportDate) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resetLastImportDate).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func percentComplete() -> Double {
        addInvocation(.m_percentComplete)
		let perform = methodPerformValue(.m_percentComplete) as? () -> Void
		perform?()
		var __value: Double
		do {
		    __value = try methodReturnValue(.m_percentComplete).casted()
		} catch {
			onFatalFailure("Stub return value not specified for percentComplete(). Use given")
			Failure("Stub return value not specified for percentComplete(). Use given")
		}
		return __value
    }

    open func cancel() {
        addInvocation(.m_cancel)
		let perform = methodPerformValue(.m_cancel) as? () -> Void
		perform?()
    }

    open func pause() {
        addInvocation(.m_pause)
		let perform = methodPerformValue(.m_pause) as? () -> Void
		perform?()
    }

    open func resume() throws {
        addInvocation(.m_resume)
		let perform = methodPerformValue(.m_resume) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resume).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func equalTo(_ other: Importer) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<Importer>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<Importer>.value(`other`))) as? (Importer) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<Importer>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: Importer). Use given")
			Failure("Stub return value not specified for equalTo(_ other: Importer). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_importData__from_url(Parameter<URL>)
        case m_resetLastImportDate
        case m_percentComplete
        case m_cancel
        case m_pause
        case m_resume
        case m_equalTo__other(Parameter<Importer>)
        case p_dataTypePluralName_get
        case p_sourceName_get
        case p_customImportMessage_get
        case p_lastImport_get
        case p_isPaused_get
        case p_isCancelled_get
        case p_importOnlyNewData_get
		case p_importOnlyNewData_set(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsUrl) && !isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				if isCapturing(lhsUrl) || isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_resetLastImportDate, .m_resetLastImportDate): return .match

            case (.m_percentComplete, .m_percentComplete): return .match

            case (.m_cancel, .m_cancel): return .match

            case (.m_pause, .m_pause): return .match

            case (.m_resume, .m_resume): return .match

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
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return Matcher.ComparisonResult.match
            case (.p_sourceName_get,.p_sourceName_get): return Matcher.ComparisonResult.match
            case (.p_customImportMessage_get,.p_customImportMessage_get): return Matcher.ComparisonResult.match
            case (.p_lastImport_get,.p_lastImport_get): return Matcher.ComparisonResult.match
            case (.p_isPaused_get,.p_isPaused_get): return Matcher.ComparisonResult.match
            case (.p_isCancelled_get,.p_isCancelled_get): return Matcher.ComparisonResult.match
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return Matcher.ComparisonResult.match
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_importData__from_url(p0): return p0.intValue
            case .m_resetLastImportDate: return 0
            case .m_percentComplete: return 0
            case .m_cancel: return 0
            case .m_pause: return 0
            case .m_resume: return 0
            case let .m_equalTo__other(p0): return p0.intValue
            case .p_dataTypePluralName_get: return 0
            case .p_sourceName_get: return 0
            case .p_customImportMessage_get: return 0
            case .p_lastImport_get: return 0
            case .p_isPaused_get: return 0
            case .p_isCancelled_get: return 0
            case .p_importOnlyNewData_get: return 0
			case .p_importOnlyNewData_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_importData__from_url: return ".importData(from:)"
            case .m_resetLastImportDate: return ".resetLastImportDate()"
            case .m_percentComplete: return ".percentComplete()"
            case .m_cancel: return ".cancel()"
            case .m_pause: return ".pause()"
            case .m_resume: return ".resume()"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .p_dataTypePluralName_get: return "[get] .dataTypePluralName"
            case .p_sourceName_get: return "[get] .sourceName"
            case .p_customImportMessage_get: return "[get] .customImportMessage"
            case .p_lastImport_get: return "[get] .lastImport"
            case .p_isPaused_get: return "[get] .isPaused"
            case .p_isCancelled_get: return "[get] .isCancelled"
            case .p_importOnlyNewData_get: return "[get] .importOnlyNewData"
			case .p_importOnlyNewData_set: return "[set] .importOnlyNewData"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func dataTypePluralName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_dataTypePluralName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func sourceName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_sourceName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func customImportMessage(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_customImportMessage_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastImport(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_lastImport_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isPaused(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isPaused_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isCancelled(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isCancelled_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func importOnlyNewData(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_importOnlyNewData_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func percentComplete(willReturn: Double...) -> MethodStub {
            return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<Importer>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func percentComplete(willProduce: (Stubber<Double>) -> Void) -> MethodStub {
            let willReturn: [Double] = []
			let given: Given = { return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Double).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ other: Parameter<Importer>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func importData(from url: Parameter<URL>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func importData(from url: Parameter<URL>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resetLastImportDate(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resetLastImportDate(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resume(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resume(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func importData(from url: Parameter<URL>) -> Verify { return Verify(method: .m_importData__from_url(`url`))}
        public static func resetLastImportDate() -> Verify { return Verify(method: .m_resetLastImportDate)}
        public static func percentComplete() -> Verify { return Verify(method: .m_percentComplete)}
        public static func cancel() -> Verify { return Verify(method: .m_cancel)}
        public static func pause() -> Verify { return Verify(method: .m_pause)}
        public static func resume() -> Verify { return Verify(method: .m_resume)}
        public static func equalTo(_ other: Parameter<Importer>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static var dataTypePluralName: Verify { return Verify(method: .p_dataTypePluralName_get) }
        public static var sourceName: Verify { return Verify(method: .p_sourceName_get) }
        public static var customImportMessage: Verify { return Verify(method: .p_customImportMessage_get) }
        public static var lastImport: Verify { return Verify(method: .p_lastImport_get) }
        public static var isPaused: Verify { return Verify(method: .p_isPaused_get) }
        public static var isCancelled: Verify { return Verify(method: .p_isCancelled_get) }
        public static var importOnlyNewData: Verify { return Verify(method: .p_importOnlyNewData_get) }
		public static func importOnlyNewData(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_importOnlyNewData_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func importData(from url: Parameter<URL>, perform: @escaping (URL) -> Void) -> Perform {
            return Perform(method: .m_importData__from_url(`url`), performs: perform)
        }
        public static func resetLastImportDate(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetLastImportDate, performs: perform)
        }
        public static func percentComplete(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_percentComplete, performs: perform)
        }
        public static func cancel(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_cancel, performs: perform)
        }
        public static func pause(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_pause, performs: perform)
        }
        public static func resume(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resume, performs: perform)
        }
        public static func equalTo(_ other: Parameter<Importer>, perform: @escaping (Importer) -> Void) -> Perform {
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

// MARK: - EasyPillMedicationImporter

open class EasyPillMedicationImporterMock: EasyPillMedicationImporter, Mock {
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


    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "EasyPillMedicationImporterMock - stub value for dataTypePluralName was not defined") }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "EasyPillMedicationImporterMock - stub value for sourceName was not defined") }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "EasyPillMedicationImporterMock - stub value for customImportMessage was not defined") }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "EasyPillMedicationImporterMock - stub value for lastImport was not defined") }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "EasyPillMedicationImporterMock - stub value for isPaused was not defined") }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "EasyPillMedicationImporterMock - stub value for isCancelled was not defined") }
	}
	private var __p_isCancelled: (Bool)?

    public var importOnlyNewData: Bool {
		get {	invocations.append(.p_importOnlyNewData_get); return __p_importOnlyNewData ?? givenGetterValue(.p_importOnlyNewData_get, "EasyPillMedicationImporterMock - stub value for importOnlyNewData was not defined") }
		set {	invocations.append(.p_importOnlyNewData_set(.value(newValue))); __p_importOnlyNewData = newValue }
	}
	private var __p_importOnlyNewData: (Bool)?





    open func importData(from url: URL) throws {
        addInvocation(.m_importData__from_url(Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_importData__from_url(Parameter<URL>.value(`url`))) as? (URL) -> Void
		perform?(`url`)
		do {
		    _ = try methodReturnValue(.m_importData__from_url(Parameter<URL>.value(`url`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func resetLastImportDate() throws {
        addInvocation(.m_resetLastImportDate)
		let perform = methodPerformValue(.m_resetLastImportDate) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resetLastImportDate).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func percentComplete() -> Double {
        addInvocation(.m_percentComplete)
		let perform = methodPerformValue(.m_percentComplete) as? () -> Void
		perform?()
		var __value: Double
		do {
		    __value = try methodReturnValue(.m_percentComplete).casted()
		} catch {
			onFatalFailure("Stub return value not specified for percentComplete(). Use given")
			Failure("Stub return value not specified for percentComplete(). Use given")
		}
		return __value
    }

    open func cancel() {
        addInvocation(.m_cancel)
		let perform = methodPerformValue(.m_cancel) as? () -> Void
		perform?()
    }

    open func pause() {
        addInvocation(.m_pause)
		let perform = methodPerformValue(.m_pause) as? () -> Void
		perform?()
    }

    open func resume() throws {
        addInvocation(.m_resume)
		let perform = methodPerformValue(.m_resume) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resume).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func equalTo(_ other: Importer) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<Importer>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<Importer>.value(`other`))) as? (Importer) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<Importer>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: Importer). Use given")
			Failure("Stub return value not specified for equalTo(_ other: Importer). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_importData__from_url(Parameter<URL>)
        case m_resetLastImportDate
        case m_percentComplete
        case m_cancel
        case m_pause
        case m_resume
        case m_equalTo__other(Parameter<Importer>)
        case p_dataTypePluralName_get
        case p_sourceName_get
        case p_customImportMessage_get
        case p_lastImport_get
        case p_isPaused_get
        case p_isCancelled_get
        case p_importOnlyNewData_get
		case p_importOnlyNewData_set(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsUrl) && !isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				if isCapturing(lhsUrl) || isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_resetLastImportDate, .m_resetLastImportDate): return .match

            case (.m_percentComplete, .m_percentComplete): return .match

            case (.m_cancel, .m_cancel): return .match

            case (.m_pause, .m_pause): return .match

            case (.m_resume, .m_resume): return .match

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
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return Matcher.ComparisonResult.match
            case (.p_sourceName_get,.p_sourceName_get): return Matcher.ComparisonResult.match
            case (.p_customImportMessage_get,.p_customImportMessage_get): return Matcher.ComparisonResult.match
            case (.p_lastImport_get,.p_lastImport_get): return Matcher.ComparisonResult.match
            case (.p_isPaused_get,.p_isPaused_get): return Matcher.ComparisonResult.match
            case (.p_isCancelled_get,.p_isCancelled_get): return Matcher.ComparisonResult.match
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return Matcher.ComparisonResult.match
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_importData__from_url(p0): return p0.intValue
            case .m_resetLastImportDate: return 0
            case .m_percentComplete: return 0
            case .m_cancel: return 0
            case .m_pause: return 0
            case .m_resume: return 0
            case let .m_equalTo__other(p0): return p0.intValue
            case .p_dataTypePluralName_get: return 0
            case .p_sourceName_get: return 0
            case .p_customImportMessage_get: return 0
            case .p_lastImport_get: return 0
            case .p_isPaused_get: return 0
            case .p_isCancelled_get: return 0
            case .p_importOnlyNewData_get: return 0
			case .p_importOnlyNewData_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_importData__from_url: return ".importData(from:)"
            case .m_resetLastImportDate: return ".resetLastImportDate()"
            case .m_percentComplete: return ".percentComplete()"
            case .m_cancel: return ".cancel()"
            case .m_pause: return ".pause()"
            case .m_resume: return ".resume()"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .p_dataTypePluralName_get: return "[get] .dataTypePluralName"
            case .p_sourceName_get: return "[get] .sourceName"
            case .p_customImportMessage_get: return "[get] .customImportMessage"
            case .p_lastImport_get: return "[get] .lastImport"
            case .p_isPaused_get: return "[get] .isPaused"
            case .p_isCancelled_get: return "[get] .isCancelled"
            case .p_importOnlyNewData_get: return "[get] .importOnlyNewData"
			case .p_importOnlyNewData_set: return "[set] .importOnlyNewData"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func dataTypePluralName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_dataTypePluralName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func sourceName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_sourceName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func customImportMessage(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_customImportMessage_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastImport(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_lastImport_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isPaused(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isPaused_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isCancelled(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isCancelled_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func importOnlyNewData(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_importOnlyNewData_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func percentComplete(willReturn: Double...) -> MethodStub {
            return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<Importer>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func percentComplete(willProduce: (Stubber<Double>) -> Void) -> MethodStub {
            let willReturn: [Double] = []
			let given: Given = { return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Double).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ other: Parameter<Importer>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func importData(from url: Parameter<URL>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func importData(from url: Parameter<URL>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resetLastImportDate(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resetLastImportDate(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resume(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resume(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func importData(from url: Parameter<URL>) -> Verify { return Verify(method: .m_importData__from_url(`url`))}
        public static func resetLastImportDate() -> Verify { return Verify(method: .m_resetLastImportDate)}
        public static func percentComplete() -> Verify { return Verify(method: .m_percentComplete)}
        public static func cancel() -> Verify { return Verify(method: .m_cancel)}
        public static func pause() -> Verify { return Verify(method: .m_pause)}
        public static func resume() -> Verify { return Verify(method: .m_resume)}
        public static func equalTo(_ other: Parameter<Importer>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static var dataTypePluralName: Verify { return Verify(method: .p_dataTypePluralName_get) }
        public static var sourceName: Verify { return Verify(method: .p_sourceName_get) }
        public static var customImportMessage: Verify { return Verify(method: .p_customImportMessage_get) }
        public static var lastImport: Verify { return Verify(method: .p_lastImport_get) }
        public static var isPaused: Verify { return Verify(method: .p_isPaused_get) }
        public static var isCancelled: Verify { return Verify(method: .p_isCancelled_get) }
        public static var importOnlyNewData: Verify { return Verify(method: .p_importOnlyNewData_get) }
		public static func importOnlyNewData(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_importOnlyNewData_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func importData(from url: Parameter<URL>, perform: @escaping (URL) -> Void) -> Perform {
            return Perform(method: .m_importData__from_url(`url`), performs: perform)
        }
        public static func resetLastImportDate(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetLastImportDate, performs: perform)
        }
        public static func percentComplete(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_percentComplete, performs: perform)
        }
        public static func cancel(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_cancel, performs: perform)
        }
        public static func pause(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_pause, performs: perform)
        }
        public static func resume(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resume, performs: perform)
        }
        public static func equalTo(_ other: Parameter<Importer>, perform: @escaping (Importer) -> Void) -> Perform {
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

// MARK: - Importer

open class ImporterMock: Importer, Mock {
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


    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "ImporterMock - stub value for dataTypePluralName was not defined") }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "ImporterMock - stub value for sourceName was not defined") }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "ImporterMock - stub value for customImportMessage was not defined") }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "ImporterMock - stub value for lastImport was not defined") }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "ImporterMock - stub value for isPaused was not defined") }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "ImporterMock - stub value for isCancelled was not defined") }
	}
	private var __p_isCancelled: (Bool)?

    public var importOnlyNewData: Bool {
		get {	invocations.append(.p_importOnlyNewData_get); return __p_importOnlyNewData ?? givenGetterValue(.p_importOnlyNewData_get, "ImporterMock - stub value for importOnlyNewData was not defined") }
		set {	invocations.append(.p_importOnlyNewData_set(.value(newValue))); __p_importOnlyNewData = newValue }
	}
	private var __p_importOnlyNewData: (Bool)?





    open func importData(from url: URL) throws {
        addInvocation(.m_importData__from_url(Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_importData__from_url(Parameter<URL>.value(`url`))) as? (URL) -> Void
		perform?(`url`)
		do {
		    _ = try methodReturnValue(.m_importData__from_url(Parameter<URL>.value(`url`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func resetLastImportDate() throws {
        addInvocation(.m_resetLastImportDate)
		let perform = methodPerformValue(.m_resetLastImportDate) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resetLastImportDate).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func percentComplete() -> Double {
        addInvocation(.m_percentComplete)
		let perform = methodPerformValue(.m_percentComplete) as? () -> Void
		perform?()
		var __value: Double
		do {
		    __value = try methodReturnValue(.m_percentComplete).casted()
		} catch {
			onFatalFailure("Stub return value not specified for percentComplete(). Use given")
			Failure("Stub return value not specified for percentComplete(). Use given")
		}
		return __value
    }

    open func cancel() {
        addInvocation(.m_cancel)
		let perform = methodPerformValue(.m_cancel) as? () -> Void
		perform?()
    }

    open func pause() {
        addInvocation(.m_pause)
		let perform = methodPerformValue(.m_pause) as? () -> Void
		perform?()
    }

    open func resume() throws {
        addInvocation(.m_resume)
		let perform = methodPerformValue(.m_resume) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resume).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func equalTo(_ other: Importer) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<Importer>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<Importer>.value(`other`))) as? (Importer) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<Importer>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: Importer). Use given")
			Failure("Stub return value not specified for equalTo(_ other: Importer). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_importData__from_url(Parameter<URL>)
        case m_resetLastImportDate
        case m_percentComplete
        case m_cancel
        case m_pause
        case m_resume
        case m_equalTo__other(Parameter<Importer>)
        case p_dataTypePluralName_get
        case p_sourceName_get
        case p_customImportMessage_get
        case p_lastImport_get
        case p_isPaused_get
        case p_isCancelled_get
        case p_importOnlyNewData_get
		case p_importOnlyNewData_set(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsUrl) && !isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				if isCapturing(lhsUrl) || isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_resetLastImportDate, .m_resetLastImportDate): return .match

            case (.m_percentComplete, .m_percentComplete): return .match

            case (.m_cancel, .m_cancel): return .match

            case (.m_pause, .m_pause): return .match

            case (.m_resume, .m_resume): return .match

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
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return Matcher.ComparisonResult.match
            case (.p_sourceName_get,.p_sourceName_get): return Matcher.ComparisonResult.match
            case (.p_customImportMessage_get,.p_customImportMessage_get): return Matcher.ComparisonResult.match
            case (.p_lastImport_get,.p_lastImport_get): return Matcher.ComparisonResult.match
            case (.p_isPaused_get,.p_isPaused_get): return Matcher.ComparisonResult.match
            case (.p_isCancelled_get,.p_isCancelled_get): return Matcher.ComparisonResult.match
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return Matcher.ComparisonResult.match
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_importData__from_url(p0): return p0.intValue
            case .m_resetLastImportDate: return 0
            case .m_percentComplete: return 0
            case .m_cancel: return 0
            case .m_pause: return 0
            case .m_resume: return 0
            case let .m_equalTo__other(p0): return p0.intValue
            case .p_dataTypePluralName_get: return 0
            case .p_sourceName_get: return 0
            case .p_customImportMessage_get: return 0
            case .p_lastImport_get: return 0
            case .p_isPaused_get: return 0
            case .p_isCancelled_get: return 0
            case .p_importOnlyNewData_get: return 0
			case .p_importOnlyNewData_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_importData__from_url: return ".importData(from:)"
            case .m_resetLastImportDate: return ".resetLastImportDate()"
            case .m_percentComplete: return ".percentComplete()"
            case .m_cancel: return ".cancel()"
            case .m_pause: return ".pause()"
            case .m_resume: return ".resume()"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .p_dataTypePluralName_get: return "[get] .dataTypePluralName"
            case .p_sourceName_get: return "[get] .sourceName"
            case .p_customImportMessage_get: return "[get] .customImportMessage"
            case .p_lastImport_get: return "[get] .lastImport"
            case .p_isPaused_get: return "[get] .isPaused"
            case .p_isCancelled_get: return "[get] .isCancelled"
            case .p_importOnlyNewData_get: return "[get] .importOnlyNewData"
			case .p_importOnlyNewData_set: return "[set] .importOnlyNewData"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func dataTypePluralName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_dataTypePluralName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func sourceName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_sourceName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func customImportMessage(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_customImportMessage_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastImport(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_lastImport_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isPaused(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isPaused_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isCancelled(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isCancelled_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func importOnlyNewData(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_importOnlyNewData_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func percentComplete(willReturn: Double...) -> MethodStub {
            return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<Importer>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func percentComplete(willProduce: (Stubber<Double>) -> Void) -> MethodStub {
            let willReturn: [Double] = []
			let given: Given = { return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Double).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ other: Parameter<Importer>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func importData(from url: Parameter<URL>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func importData(from url: Parameter<URL>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resetLastImportDate(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resetLastImportDate(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resume(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resume(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func importData(from url: Parameter<URL>) -> Verify { return Verify(method: .m_importData__from_url(`url`))}
        public static func resetLastImportDate() -> Verify { return Verify(method: .m_resetLastImportDate)}
        public static func percentComplete() -> Verify { return Verify(method: .m_percentComplete)}
        public static func cancel() -> Verify { return Verify(method: .m_cancel)}
        public static func pause() -> Verify { return Verify(method: .m_pause)}
        public static func resume() -> Verify { return Verify(method: .m_resume)}
        public static func equalTo(_ other: Parameter<Importer>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static var dataTypePluralName: Verify { return Verify(method: .p_dataTypePluralName_get) }
        public static var sourceName: Verify { return Verify(method: .p_sourceName_get) }
        public static var customImportMessage: Verify { return Verify(method: .p_customImportMessage_get) }
        public static var lastImport: Verify { return Verify(method: .p_lastImport_get) }
        public static var isPaused: Verify { return Verify(method: .p_isPaused_get) }
        public static var isCancelled: Verify { return Verify(method: .p_isCancelled_get) }
        public static var importOnlyNewData: Verify { return Verify(method: .p_importOnlyNewData_get) }
		public static func importOnlyNewData(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_importOnlyNewData_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func importData(from url: Parameter<URL>, perform: @escaping (URL) -> Void) -> Perform {
            return Perform(method: .m_importData__from_url(`url`), performs: perform)
        }
        public static func resetLastImportDate(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetLastImportDate, performs: perform)
        }
        public static func percentComplete(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_percentComplete, performs: perform)
        }
        public static func cancel(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_cancel, performs: perform)
        }
        public static func pause(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_pause, performs: perform)
        }
        public static func resume(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resume, performs: perform)
        }
        public static func equalTo(_ other: Parameter<Importer>, perform: @escaping (Importer) -> Void) -> Perform {
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

// MARK: - ImporterFactory

open class ImporterFactoryMock: ImporterFactory, Mock {
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






    open func wellnessMoodImporter() throws -> WellnessMoodImporter {
        addInvocation(.m_wellnessMoodImporter)
		let perform = methodPerformValue(.m_wellnessMoodImporter) as? () -> Void
		perform?()
		var __value: WellnessMoodImporter
		do {
		    __value = try methodReturnValue(.m_wellnessMoodImporter).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for wellnessMoodImporter(). Use given")
			Failure("Stub return value not specified for wellnessMoodImporter(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func introspectiveMoodImporter() throws -> IntrospectiveMoodImporter {
        addInvocation(.m_introspectiveMoodImporter)
		let perform = methodPerformValue(.m_introspectiveMoodImporter) as? () -> Void
		perform?()
		var __value: IntrospectiveMoodImporter
		do {
		    __value = try methodReturnValue(.m_introspectiveMoodImporter).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for introspectiveMoodImporter(). Use given")
			Failure("Stub return value not specified for introspectiveMoodImporter(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func easyPillMedicationImporter() throws -> EasyPillMedicationImporter {
        addInvocation(.m_easyPillMedicationImporter)
		let perform = methodPerformValue(.m_easyPillMedicationImporter) as? () -> Void
		perform?()
		var __value: EasyPillMedicationImporter
		do {
		    __value = try methodReturnValue(.m_easyPillMedicationImporter).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for easyPillMedicationImporter(). Use given")
			Failure("Stub return value not specified for easyPillMedicationImporter(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func easyPillMedicationDoseImporter() throws -> EasyPillMedicationDoseImporter {
        addInvocation(.m_easyPillMedicationDoseImporter)
		let perform = methodPerformValue(.m_easyPillMedicationDoseImporter) as? () -> Void
		perform?()
		var __value: EasyPillMedicationDoseImporter
		do {
		    __value = try methodReturnValue(.m_easyPillMedicationDoseImporter).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for easyPillMedicationDoseImporter(). Use given")
			Failure("Stub return value not specified for easyPillMedicationDoseImporter(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func introspectiveMedicationImporter() throws -> IntrospectiveMedicationImporter {
        addInvocation(.m_introspectiveMedicationImporter)
		let perform = methodPerformValue(.m_introspectiveMedicationImporter) as? () -> Void
		perform?()
		var __value: IntrospectiveMedicationImporter
		do {
		    __value = try methodReturnValue(.m_introspectiveMedicationImporter).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for introspectiveMedicationImporter(). Use given")
			Failure("Stub return value not specified for introspectiveMedicationImporter(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func aTrackerActivityImporter() throws -> ATrackerActivityImporter {
        addInvocation(.m_aTrackerActivityImporter)
		let perform = methodPerformValue(.m_aTrackerActivityImporter) as? () -> Void
		perform?()
		var __value: ATrackerActivityImporter
		do {
		    __value = try methodReturnValue(.m_aTrackerActivityImporter).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for aTrackerActivityImporter(). Use given")
			Failure("Stub return value not specified for aTrackerActivityImporter(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func introspectiveActivityImporter() throws -> IntrospectiveActivityImporter {
        addInvocation(.m_introspectiveActivityImporter)
		let perform = methodPerformValue(.m_introspectiveActivityImporter) as? () -> Void
		perform?()
		var __value: IntrospectiveActivityImporter
		do {
		    __value = try methodReturnValue(.m_introspectiveActivityImporter).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for introspectiveActivityImporter(). Use given")
			Failure("Stub return value not specified for introspectiveActivityImporter(). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_wellnessMoodImporter
        case m_introspectiveMoodImporter
        case m_easyPillMedicationImporter
        case m_easyPillMedicationDoseImporter
        case m_introspectiveMedicationImporter
        case m_aTrackerActivityImporter
        case m_introspectiveActivityImporter

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_wellnessMoodImporter, .m_wellnessMoodImporter): return .match

            case (.m_introspectiveMoodImporter, .m_introspectiveMoodImporter): return .match

            case (.m_easyPillMedicationImporter, .m_easyPillMedicationImporter): return .match

            case (.m_easyPillMedicationDoseImporter, .m_easyPillMedicationDoseImporter): return .match

            case (.m_introspectiveMedicationImporter, .m_introspectiveMedicationImporter): return .match

            case (.m_aTrackerActivityImporter, .m_aTrackerActivityImporter): return .match

            case (.m_introspectiveActivityImporter, .m_introspectiveActivityImporter): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_wellnessMoodImporter: return 0
            case .m_introspectiveMoodImporter: return 0
            case .m_easyPillMedicationImporter: return 0
            case .m_easyPillMedicationDoseImporter: return 0
            case .m_introspectiveMedicationImporter: return 0
            case .m_aTrackerActivityImporter: return 0
            case .m_introspectiveActivityImporter: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_wellnessMoodImporter: return ".wellnessMoodImporter()"
            case .m_introspectiveMoodImporter: return ".introspectiveMoodImporter()"
            case .m_easyPillMedicationImporter: return ".easyPillMedicationImporter()"
            case .m_easyPillMedicationDoseImporter: return ".easyPillMedicationDoseImporter()"
            case .m_introspectiveMedicationImporter: return ".introspectiveMedicationImporter()"
            case .m_aTrackerActivityImporter: return ".aTrackerActivityImporter()"
            case .m_introspectiveActivityImporter: return ".introspectiveActivityImporter()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func wellnessMoodImporter(willReturn: WellnessMoodImporter...) -> MethodStub {
            return Given(method: .m_wellnessMoodImporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func introspectiveMoodImporter(willReturn: IntrospectiveMoodImporter...) -> MethodStub {
            return Given(method: .m_introspectiveMoodImporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func easyPillMedicationImporter(willReturn: EasyPillMedicationImporter...) -> MethodStub {
            return Given(method: .m_easyPillMedicationImporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func easyPillMedicationDoseImporter(willReturn: EasyPillMedicationDoseImporter...) -> MethodStub {
            return Given(method: .m_easyPillMedicationDoseImporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func introspectiveMedicationImporter(willReturn: IntrospectiveMedicationImporter...) -> MethodStub {
            return Given(method: .m_introspectiveMedicationImporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func aTrackerActivityImporter(willReturn: ATrackerActivityImporter...) -> MethodStub {
            return Given(method: .m_aTrackerActivityImporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func introspectiveActivityImporter(willReturn: IntrospectiveActivityImporter...) -> MethodStub {
            return Given(method: .m_introspectiveActivityImporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func wellnessMoodImporter(willThrow: Error...) -> MethodStub {
            return Given(method: .m_wellnessMoodImporter, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func wellnessMoodImporter(willProduce: (StubberThrows<WellnessMoodImporter>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_wellnessMoodImporter, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (WellnessMoodImporter).self)
			willProduce(stubber)
			return given
        }
        public static func introspectiveMoodImporter(willThrow: Error...) -> MethodStub {
            return Given(method: .m_introspectiveMoodImporter, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func introspectiveMoodImporter(willProduce: (StubberThrows<IntrospectiveMoodImporter>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_introspectiveMoodImporter, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (IntrospectiveMoodImporter).self)
			willProduce(stubber)
			return given
        }
        public static func easyPillMedicationImporter(willThrow: Error...) -> MethodStub {
            return Given(method: .m_easyPillMedicationImporter, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func easyPillMedicationImporter(willProduce: (StubberThrows<EasyPillMedicationImporter>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_easyPillMedicationImporter, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (EasyPillMedicationImporter).self)
			willProduce(stubber)
			return given
        }
        public static func easyPillMedicationDoseImporter(willThrow: Error...) -> MethodStub {
            return Given(method: .m_easyPillMedicationDoseImporter, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func easyPillMedicationDoseImporter(willProduce: (StubberThrows<EasyPillMedicationDoseImporter>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_easyPillMedicationDoseImporter, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (EasyPillMedicationDoseImporter).self)
			willProduce(stubber)
			return given
        }
        public static func introspectiveMedicationImporter(willThrow: Error...) -> MethodStub {
            return Given(method: .m_introspectiveMedicationImporter, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func introspectiveMedicationImporter(willProduce: (StubberThrows<IntrospectiveMedicationImporter>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_introspectiveMedicationImporter, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (IntrospectiveMedicationImporter).self)
			willProduce(stubber)
			return given
        }
        public static func aTrackerActivityImporter(willThrow: Error...) -> MethodStub {
            return Given(method: .m_aTrackerActivityImporter, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func aTrackerActivityImporter(willProduce: (StubberThrows<ATrackerActivityImporter>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_aTrackerActivityImporter, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ATrackerActivityImporter).self)
			willProduce(stubber)
			return given
        }
        public static func introspectiveActivityImporter(willThrow: Error...) -> MethodStub {
            return Given(method: .m_introspectiveActivityImporter, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func introspectiveActivityImporter(willProduce: (StubberThrows<IntrospectiveActivityImporter>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_introspectiveActivityImporter, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (IntrospectiveActivityImporter).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func wellnessMoodImporter() -> Verify { return Verify(method: .m_wellnessMoodImporter)}
        public static func introspectiveMoodImporter() -> Verify { return Verify(method: .m_introspectiveMoodImporter)}
        public static func easyPillMedicationImporter() -> Verify { return Verify(method: .m_easyPillMedicationImporter)}
        public static func easyPillMedicationDoseImporter() -> Verify { return Verify(method: .m_easyPillMedicationDoseImporter)}
        public static func introspectiveMedicationImporter() -> Verify { return Verify(method: .m_introspectiveMedicationImporter)}
        public static func aTrackerActivityImporter() -> Verify { return Verify(method: .m_aTrackerActivityImporter)}
        public static func introspectiveActivityImporter() -> Verify { return Verify(method: .m_introspectiveActivityImporter)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func wellnessMoodImporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_wellnessMoodImporter, performs: perform)
        }
        public static func introspectiveMoodImporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_introspectiveMoodImporter, performs: perform)
        }
        public static func easyPillMedicationImporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_easyPillMedicationImporter, performs: perform)
        }
        public static func easyPillMedicationDoseImporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_easyPillMedicationDoseImporter, performs: perform)
        }
        public static func introspectiveMedicationImporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_introspectiveMedicationImporter, performs: perform)
        }
        public static func aTrackerActivityImporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_aTrackerActivityImporter, performs: perform)
        }
        public static func introspectiveActivityImporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_introspectiveActivityImporter, performs: perform)
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

// MARK: - IntrospectiveActivityImporter

open class IntrospectiveActivityImporterMock: IntrospectiveActivityImporter, Mock {
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


    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "IntrospectiveActivityImporterMock - stub value for dataTypePluralName was not defined") }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "IntrospectiveActivityImporterMock - stub value for sourceName was not defined") }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "IntrospectiveActivityImporterMock - stub value for customImportMessage was not defined") }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "IntrospectiveActivityImporterMock - stub value for lastImport was not defined") }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "IntrospectiveActivityImporterMock - stub value for isPaused was not defined") }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "IntrospectiveActivityImporterMock - stub value for isCancelled was not defined") }
	}
	private var __p_isCancelled: (Bool)?

    public var importOnlyNewData: Bool {
		get {	invocations.append(.p_importOnlyNewData_get); return __p_importOnlyNewData ?? givenGetterValue(.p_importOnlyNewData_get, "IntrospectiveActivityImporterMock - stub value for importOnlyNewData was not defined") }
		set {	invocations.append(.p_importOnlyNewData_set(.value(newValue))); __p_importOnlyNewData = newValue }
	}
	private var __p_importOnlyNewData: (Bool)?





    open func importData(from url: URL) throws {
        addInvocation(.m_importData__from_url(Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_importData__from_url(Parameter<URL>.value(`url`))) as? (URL) -> Void
		perform?(`url`)
		do {
		    _ = try methodReturnValue(.m_importData__from_url(Parameter<URL>.value(`url`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func resetLastImportDate() throws {
        addInvocation(.m_resetLastImportDate)
		let perform = methodPerformValue(.m_resetLastImportDate) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resetLastImportDate).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func percentComplete() -> Double {
        addInvocation(.m_percentComplete)
		let perform = methodPerformValue(.m_percentComplete) as? () -> Void
		perform?()
		var __value: Double
		do {
		    __value = try methodReturnValue(.m_percentComplete).casted()
		} catch {
			onFatalFailure("Stub return value not specified for percentComplete(). Use given")
			Failure("Stub return value not specified for percentComplete(). Use given")
		}
		return __value
    }

    open func cancel() {
        addInvocation(.m_cancel)
		let perform = methodPerformValue(.m_cancel) as? () -> Void
		perform?()
    }

    open func pause() {
        addInvocation(.m_pause)
		let perform = methodPerformValue(.m_pause) as? () -> Void
		perform?()
    }

    open func resume() throws {
        addInvocation(.m_resume)
		let perform = methodPerformValue(.m_resume) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resume).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func equalTo(_ other: Importer) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<Importer>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<Importer>.value(`other`))) as? (Importer) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<Importer>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: Importer). Use given")
			Failure("Stub return value not specified for equalTo(_ other: Importer). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_importData__from_url(Parameter<URL>)
        case m_resetLastImportDate
        case m_percentComplete
        case m_cancel
        case m_pause
        case m_resume
        case m_equalTo__other(Parameter<Importer>)
        case p_dataTypePluralName_get
        case p_sourceName_get
        case p_customImportMessage_get
        case p_lastImport_get
        case p_isPaused_get
        case p_isCancelled_get
        case p_importOnlyNewData_get
		case p_importOnlyNewData_set(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsUrl) && !isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				if isCapturing(lhsUrl) || isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_resetLastImportDate, .m_resetLastImportDate): return .match

            case (.m_percentComplete, .m_percentComplete): return .match

            case (.m_cancel, .m_cancel): return .match

            case (.m_pause, .m_pause): return .match

            case (.m_resume, .m_resume): return .match

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
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return Matcher.ComparisonResult.match
            case (.p_sourceName_get,.p_sourceName_get): return Matcher.ComparisonResult.match
            case (.p_customImportMessage_get,.p_customImportMessage_get): return Matcher.ComparisonResult.match
            case (.p_lastImport_get,.p_lastImport_get): return Matcher.ComparisonResult.match
            case (.p_isPaused_get,.p_isPaused_get): return Matcher.ComparisonResult.match
            case (.p_isCancelled_get,.p_isCancelled_get): return Matcher.ComparisonResult.match
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return Matcher.ComparisonResult.match
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_importData__from_url(p0): return p0.intValue
            case .m_resetLastImportDate: return 0
            case .m_percentComplete: return 0
            case .m_cancel: return 0
            case .m_pause: return 0
            case .m_resume: return 0
            case let .m_equalTo__other(p0): return p0.intValue
            case .p_dataTypePluralName_get: return 0
            case .p_sourceName_get: return 0
            case .p_customImportMessage_get: return 0
            case .p_lastImport_get: return 0
            case .p_isPaused_get: return 0
            case .p_isCancelled_get: return 0
            case .p_importOnlyNewData_get: return 0
			case .p_importOnlyNewData_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_importData__from_url: return ".importData(from:)"
            case .m_resetLastImportDate: return ".resetLastImportDate()"
            case .m_percentComplete: return ".percentComplete()"
            case .m_cancel: return ".cancel()"
            case .m_pause: return ".pause()"
            case .m_resume: return ".resume()"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .p_dataTypePluralName_get: return "[get] .dataTypePluralName"
            case .p_sourceName_get: return "[get] .sourceName"
            case .p_customImportMessage_get: return "[get] .customImportMessage"
            case .p_lastImport_get: return "[get] .lastImport"
            case .p_isPaused_get: return "[get] .isPaused"
            case .p_isCancelled_get: return "[get] .isCancelled"
            case .p_importOnlyNewData_get: return "[get] .importOnlyNewData"
			case .p_importOnlyNewData_set: return "[set] .importOnlyNewData"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func dataTypePluralName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_dataTypePluralName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func sourceName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_sourceName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func customImportMessage(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_customImportMessage_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastImport(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_lastImport_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isPaused(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isPaused_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isCancelled(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isCancelled_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func importOnlyNewData(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_importOnlyNewData_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func percentComplete(willReturn: Double...) -> MethodStub {
            return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<Importer>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func percentComplete(willProduce: (Stubber<Double>) -> Void) -> MethodStub {
            let willReturn: [Double] = []
			let given: Given = { return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Double).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ other: Parameter<Importer>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func importData(from url: Parameter<URL>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func importData(from url: Parameter<URL>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resetLastImportDate(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resetLastImportDate(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resume(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resume(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func importData(from url: Parameter<URL>) -> Verify { return Verify(method: .m_importData__from_url(`url`))}
        public static func resetLastImportDate() -> Verify { return Verify(method: .m_resetLastImportDate)}
        public static func percentComplete() -> Verify { return Verify(method: .m_percentComplete)}
        public static func cancel() -> Verify { return Verify(method: .m_cancel)}
        public static func pause() -> Verify { return Verify(method: .m_pause)}
        public static func resume() -> Verify { return Verify(method: .m_resume)}
        public static func equalTo(_ other: Parameter<Importer>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static var dataTypePluralName: Verify { return Verify(method: .p_dataTypePluralName_get) }
        public static var sourceName: Verify { return Verify(method: .p_sourceName_get) }
        public static var customImportMessage: Verify { return Verify(method: .p_customImportMessage_get) }
        public static var lastImport: Verify { return Verify(method: .p_lastImport_get) }
        public static var isPaused: Verify { return Verify(method: .p_isPaused_get) }
        public static var isCancelled: Verify { return Verify(method: .p_isCancelled_get) }
        public static var importOnlyNewData: Verify { return Verify(method: .p_importOnlyNewData_get) }
		public static func importOnlyNewData(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_importOnlyNewData_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func importData(from url: Parameter<URL>, perform: @escaping (URL) -> Void) -> Perform {
            return Perform(method: .m_importData__from_url(`url`), performs: perform)
        }
        public static func resetLastImportDate(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetLastImportDate, performs: perform)
        }
        public static func percentComplete(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_percentComplete, performs: perform)
        }
        public static func cancel(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_cancel, performs: perform)
        }
        public static func pause(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_pause, performs: perform)
        }
        public static func resume(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resume, performs: perform)
        }
        public static func equalTo(_ other: Parameter<Importer>, perform: @escaping (Importer) -> Void) -> Perform {
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

// MARK: - IntrospectiveMedicationImporter

open class IntrospectiveMedicationImporterMock: IntrospectiveMedicationImporter, Mock {
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


    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "IntrospectiveMedicationImporterMock - stub value for dataTypePluralName was not defined") }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "IntrospectiveMedicationImporterMock - stub value for sourceName was not defined") }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "IntrospectiveMedicationImporterMock - stub value for customImportMessage was not defined") }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "IntrospectiveMedicationImporterMock - stub value for lastImport was not defined") }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "IntrospectiveMedicationImporterMock - stub value for isPaused was not defined") }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "IntrospectiveMedicationImporterMock - stub value for isCancelled was not defined") }
	}
	private var __p_isCancelled: (Bool)?

    public var importOnlyNewData: Bool {
		get {	invocations.append(.p_importOnlyNewData_get); return __p_importOnlyNewData ?? givenGetterValue(.p_importOnlyNewData_get, "IntrospectiveMedicationImporterMock - stub value for importOnlyNewData was not defined") }
		set {	invocations.append(.p_importOnlyNewData_set(.value(newValue))); __p_importOnlyNewData = newValue }
	}
	private var __p_importOnlyNewData: (Bool)?





    open func importData(from url: URL) throws {
        addInvocation(.m_importData__from_url(Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_importData__from_url(Parameter<URL>.value(`url`))) as? (URL) -> Void
		perform?(`url`)
		do {
		    _ = try methodReturnValue(.m_importData__from_url(Parameter<URL>.value(`url`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func resetLastImportDate() throws {
        addInvocation(.m_resetLastImportDate)
		let perform = methodPerformValue(.m_resetLastImportDate) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resetLastImportDate).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func percentComplete() -> Double {
        addInvocation(.m_percentComplete)
		let perform = methodPerformValue(.m_percentComplete) as? () -> Void
		perform?()
		var __value: Double
		do {
		    __value = try methodReturnValue(.m_percentComplete).casted()
		} catch {
			onFatalFailure("Stub return value not specified for percentComplete(). Use given")
			Failure("Stub return value not specified for percentComplete(). Use given")
		}
		return __value
    }

    open func cancel() {
        addInvocation(.m_cancel)
		let perform = methodPerformValue(.m_cancel) as? () -> Void
		perform?()
    }

    open func pause() {
        addInvocation(.m_pause)
		let perform = methodPerformValue(.m_pause) as? () -> Void
		perform?()
    }

    open func resume() throws {
        addInvocation(.m_resume)
		let perform = methodPerformValue(.m_resume) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resume).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func equalTo(_ other: Importer) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<Importer>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<Importer>.value(`other`))) as? (Importer) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<Importer>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: Importer). Use given")
			Failure("Stub return value not specified for equalTo(_ other: Importer). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_importData__from_url(Parameter<URL>)
        case m_resetLastImportDate
        case m_percentComplete
        case m_cancel
        case m_pause
        case m_resume
        case m_equalTo__other(Parameter<Importer>)
        case p_dataTypePluralName_get
        case p_sourceName_get
        case p_customImportMessage_get
        case p_lastImport_get
        case p_isPaused_get
        case p_isCancelled_get
        case p_importOnlyNewData_get
		case p_importOnlyNewData_set(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsUrl) && !isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				if isCapturing(lhsUrl) || isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_resetLastImportDate, .m_resetLastImportDate): return .match

            case (.m_percentComplete, .m_percentComplete): return .match

            case (.m_cancel, .m_cancel): return .match

            case (.m_pause, .m_pause): return .match

            case (.m_resume, .m_resume): return .match

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
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return Matcher.ComparisonResult.match
            case (.p_sourceName_get,.p_sourceName_get): return Matcher.ComparisonResult.match
            case (.p_customImportMessage_get,.p_customImportMessage_get): return Matcher.ComparisonResult.match
            case (.p_lastImport_get,.p_lastImport_get): return Matcher.ComparisonResult.match
            case (.p_isPaused_get,.p_isPaused_get): return Matcher.ComparisonResult.match
            case (.p_isCancelled_get,.p_isCancelled_get): return Matcher.ComparisonResult.match
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return Matcher.ComparisonResult.match
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_importData__from_url(p0): return p0.intValue
            case .m_resetLastImportDate: return 0
            case .m_percentComplete: return 0
            case .m_cancel: return 0
            case .m_pause: return 0
            case .m_resume: return 0
            case let .m_equalTo__other(p0): return p0.intValue
            case .p_dataTypePluralName_get: return 0
            case .p_sourceName_get: return 0
            case .p_customImportMessage_get: return 0
            case .p_lastImport_get: return 0
            case .p_isPaused_get: return 0
            case .p_isCancelled_get: return 0
            case .p_importOnlyNewData_get: return 0
			case .p_importOnlyNewData_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_importData__from_url: return ".importData(from:)"
            case .m_resetLastImportDate: return ".resetLastImportDate()"
            case .m_percentComplete: return ".percentComplete()"
            case .m_cancel: return ".cancel()"
            case .m_pause: return ".pause()"
            case .m_resume: return ".resume()"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .p_dataTypePluralName_get: return "[get] .dataTypePluralName"
            case .p_sourceName_get: return "[get] .sourceName"
            case .p_customImportMessage_get: return "[get] .customImportMessage"
            case .p_lastImport_get: return "[get] .lastImport"
            case .p_isPaused_get: return "[get] .isPaused"
            case .p_isCancelled_get: return "[get] .isCancelled"
            case .p_importOnlyNewData_get: return "[get] .importOnlyNewData"
			case .p_importOnlyNewData_set: return "[set] .importOnlyNewData"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func dataTypePluralName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_dataTypePluralName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func sourceName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_sourceName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func customImportMessage(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_customImportMessage_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastImport(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_lastImport_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isPaused(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isPaused_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isCancelled(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isCancelled_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func importOnlyNewData(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_importOnlyNewData_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func percentComplete(willReturn: Double...) -> MethodStub {
            return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<Importer>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func percentComplete(willProduce: (Stubber<Double>) -> Void) -> MethodStub {
            let willReturn: [Double] = []
			let given: Given = { return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Double).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ other: Parameter<Importer>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func importData(from url: Parameter<URL>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func importData(from url: Parameter<URL>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resetLastImportDate(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resetLastImportDate(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resume(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resume(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func importData(from url: Parameter<URL>) -> Verify { return Verify(method: .m_importData__from_url(`url`))}
        public static func resetLastImportDate() -> Verify { return Verify(method: .m_resetLastImportDate)}
        public static func percentComplete() -> Verify { return Verify(method: .m_percentComplete)}
        public static func cancel() -> Verify { return Verify(method: .m_cancel)}
        public static func pause() -> Verify { return Verify(method: .m_pause)}
        public static func resume() -> Verify { return Verify(method: .m_resume)}
        public static func equalTo(_ other: Parameter<Importer>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static var dataTypePluralName: Verify { return Verify(method: .p_dataTypePluralName_get) }
        public static var sourceName: Verify { return Verify(method: .p_sourceName_get) }
        public static var customImportMessage: Verify { return Verify(method: .p_customImportMessage_get) }
        public static var lastImport: Verify { return Verify(method: .p_lastImport_get) }
        public static var isPaused: Verify { return Verify(method: .p_isPaused_get) }
        public static var isCancelled: Verify { return Verify(method: .p_isCancelled_get) }
        public static var importOnlyNewData: Verify { return Verify(method: .p_importOnlyNewData_get) }
		public static func importOnlyNewData(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_importOnlyNewData_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func importData(from url: Parameter<URL>, perform: @escaping (URL) -> Void) -> Perform {
            return Perform(method: .m_importData__from_url(`url`), performs: perform)
        }
        public static func resetLastImportDate(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetLastImportDate, performs: perform)
        }
        public static func percentComplete(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_percentComplete, performs: perform)
        }
        public static func cancel(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_cancel, performs: perform)
        }
        public static func pause(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_pause, performs: perform)
        }
        public static func resume(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resume, performs: perform)
        }
        public static func equalTo(_ other: Parameter<Importer>, perform: @escaping (Importer) -> Void) -> Perform {
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

// MARK: - IntrospectiveMoodImporter

open class IntrospectiveMoodImporterMock: IntrospectiveMoodImporter, Mock {
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


    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "IntrospectiveMoodImporterMock - stub value for dataTypePluralName was not defined") }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "IntrospectiveMoodImporterMock - stub value for sourceName was not defined") }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "IntrospectiveMoodImporterMock - stub value for customImportMessage was not defined") }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "IntrospectiveMoodImporterMock - stub value for lastImport was not defined") }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "IntrospectiveMoodImporterMock - stub value for isPaused was not defined") }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "IntrospectiveMoodImporterMock - stub value for isCancelled was not defined") }
	}
	private var __p_isCancelled: (Bool)?

    public var importOnlyNewData: Bool {
		get {	invocations.append(.p_importOnlyNewData_get); return __p_importOnlyNewData ?? givenGetterValue(.p_importOnlyNewData_get, "IntrospectiveMoodImporterMock - stub value for importOnlyNewData was not defined") }
		set {	invocations.append(.p_importOnlyNewData_set(.value(newValue))); __p_importOnlyNewData = newValue }
	}
	private var __p_importOnlyNewData: (Bool)?





    open func importData(from url: URL) throws {
        addInvocation(.m_importData__from_url(Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_importData__from_url(Parameter<URL>.value(`url`))) as? (URL) -> Void
		perform?(`url`)
		do {
		    _ = try methodReturnValue(.m_importData__from_url(Parameter<URL>.value(`url`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func resetLastImportDate() throws {
        addInvocation(.m_resetLastImportDate)
		let perform = methodPerformValue(.m_resetLastImportDate) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resetLastImportDate).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func percentComplete() -> Double {
        addInvocation(.m_percentComplete)
		let perform = methodPerformValue(.m_percentComplete) as? () -> Void
		perform?()
		var __value: Double
		do {
		    __value = try methodReturnValue(.m_percentComplete).casted()
		} catch {
			onFatalFailure("Stub return value not specified for percentComplete(). Use given")
			Failure("Stub return value not specified for percentComplete(). Use given")
		}
		return __value
    }

    open func cancel() {
        addInvocation(.m_cancel)
		let perform = methodPerformValue(.m_cancel) as? () -> Void
		perform?()
    }

    open func pause() {
        addInvocation(.m_pause)
		let perform = methodPerformValue(.m_pause) as? () -> Void
		perform?()
    }

    open func resume() throws {
        addInvocation(.m_resume)
		let perform = methodPerformValue(.m_resume) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resume).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func equalTo(_ other: Importer) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<Importer>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<Importer>.value(`other`))) as? (Importer) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<Importer>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: Importer). Use given")
			Failure("Stub return value not specified for equalTo(_ other: Importer). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_importData__from_url(Parameter<URL>)
        case m_resetLastImportDate
        case m_percentComplete
        case m_cancel
        case m_pause
        case m_resume
        case m_equalTo__other(Parameter<Importer>)
        case p_dataTypePluralName_get
        case p_sourceName_get
        case p_customImportMessage_get
        case p_lastImport_get
        case p_isPaused_get
        case p_isCancelled_get
        case p_importOnlyNewData_get
		case p_importOnlyNewData_set(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsUrl) && !isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				if isCapturing(lhsUrl) || isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_resetLastImportDate, .m_resetLastImportDate): return .match

            case (.m_percentComplete, .m_percentComplete): return .match

            case (.m_cancel, .m_cancel): return .match

            case (.m_pause, .m_pause): return .match

            case (.m_resume, .m_resume): return .match

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
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return Matcher.ComparisonResult.match
            case (.p_sourceName_get,.p_sourceName_get): return Matcher.ComparisonResult.match
            case (.p_customImportMessage_get,.p_customImportMessage_get): return Matcher.ComparisonResult.match
            case (.p_lastImport_get,.p_lastImport_get): return Matcher.ComparisonResult.match
            case (.p_isPaused_get,.p_isPaused_get): return Matcher.ComparisonResult.match
            case (.p_isCancelled_get,.p_isCancelled_get): return Matcher.ComparisonResult.match
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return Matcher.ComparisonResult.match
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_importData__from_url(p0): return p0.intValue
            case .m_resetLastImportDate: return 0
            case .m_percentComplete: return 0
            case .m_cancel: return 0
            case .m_pause: return 0
            case .m_resume: return 0
            case let .m_equalTo__other(p0): return p0.intValue
            case .p_dataTypePluralName_get: return 0
            case .p_sourceName_get: return 0
            case .p_customImportMessage_get: return 0
            case .p_lastImport_get: return 0
            case .p_isPaused_get: return 0
            case .p_isCancelled_get: return 0
            case .p_importOnlyNewData_get: return 0
			case .p_importOnlyNewData_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_importData__from_url: return ".importData(from:)"
            case .m_resetLastImportDate: return ".resetLastImportDate()"
            case .m_percentComplete: return ".percentComplete()"
            case .m_cancel: return ".cancel()"
            case .m_pause: return ".pause()"
            case .m_resume: return ".resume()"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .p_dataTypePluralName_get: return "[get] .dataTypePluralName"
            case .p_sourceName_get: return "[get] .sourceName"
            case .p_customImportMessage_get: return "[get] .customImportMessage"
            case .p_lastImport_get: return "[get] .lastImport"
            case .p_isPaused_get: return "[get] .isPaused"
            case .p_isCancelled_get: return "[get] .isCancelled"
            case .p_importOnlyNewData_get: return "[get] .importOnlyNewData"
			case .p_importOnlyNewData_set: return "[set] .importOnlyNewData"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func dataTypePluralName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_dataTypePluralName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func sourceName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_sourceName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func customImportMessage(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_customImportMessage_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastImport(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_lastImport_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isPaused(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isPaused_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isCancelled(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isCancelled_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func importOnlyNewData(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_importOnlyNewData_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func percentComplete(willReturn: Double...) -> MethodStub {
            return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<Importer>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func percentComplete(willProduce: (Stubber<Double>) -> Void) -> MethodStub {
            let willReturn: [Double] = []
			let given: Given = { return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Double).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ other: Parameter<Importer>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func importData(from url: Parameter<URL>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func importData(from url: Parameter<URL>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resetLastImportDate(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resetLastImportDate(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resume(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resume(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func importData(from url: Parameter<URL>) -> Verify { return Verify(method: .m_importData__from_url(`url`))}
        public static func resetLastImportDate() -> Verify { return Verify(method: .m_resetLastImportDate)}
        public static func percentComplete() -> Verify { return Verify(method: .m_percentComplete)}
        public static func cancel() -> Verify { return Verify(method: .m_cancel)}
        public static func pause() -> Verify { return Verify(method: .m_pause)}
        public static func resume() -> Verify { return Verify(method: .m_resume)}
        public static func equalTo(_ other: Parameter<Importer>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static var dataTypePluralName: Verify { return Verify(method: .p_dataTypePluralName_get) }
        public static var sourceName: Verify { return Verify(method: .p_sourceName_get) }
        public static var customImportMessage: Verify { return Verify(method: .p_customImportMessage_get) }
        public static var lastImport: Verify { return Verify(method: .p_lastImport_get) }
        public static var isPaused: Verify { return Verify(method: .p_isPaused_get) }
        public static var isCancelled: Verify { return Verify(method: .p_isCancelled_get) }
        public static var importOnlyNewData: Verify { return Verify(method: .p_importOnlyNewData_get) }
		public static func importOnlyNewData(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_importOnlyNewData_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func importData(from url: Parameter<URL>, perform: @escaping (URL) -> Void) -> Perform {
            return Perform(method: .m_importData__from_url(`url`), performs: perform)
        }
        public static func resetLastImportDate(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetLastImportDate, performs: perform)
        }
        public static func percentComplete(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_percentComplete, performs: perform)
        }
        public static func cancel(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_cancel, performs: perform)
        }
        public static func pause(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_pause, performs: perform)
        }
        public static func resume(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resume, performs: perform)
        }
        public static func equalTo(_ other: Parameter<Importer>, perform: @escaping (Importer) -> Void) -> Perform {
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

// MARK: - WellnessMoodImporter

open class WellnessMoodImporterMock: WellnessMoodImporter, Mock {
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


    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "WellnessMoodImporterMock - stub value for dataTypePluralName was not defined") }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "WellnessMoodImporterMock - stub value for sourceName was not defined") }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "WellnessMoodImporterMock - stub value for customImportMessage was not defined") }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "WellnessMoodImporterMock - stub value for lastImport was not defined") }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "WellnessMoodImporterMock - stub value for isPaused was not defined") }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "WellnessMoodImporterMock - stub value for isCancelled was not defined") }
	}
	private var __p_isCancelled: (Bool)?

    public var importOnlyNewData: Bool {
		get {	invocations.append(.p_importOnlyNewData_get); return __p_importOnlyNewData ?? givenGetterValue(.p_importOnlyNewData_get, "WellnessMoodImporterMock - stub value for importOnlyNewData was not defined") }
		set {	invocations.append(.p_importOnlyNewData_set(.value(newValue))); __p_importOnlyNewData = newValue }
	}
	private var __p_importOnlyNewData: (Bool)?





    open func importData(from url: URL) throws {
        addInvocation(.m_importData__from_url(Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_importData__from_url(Parameter<URL>.value(`url`))) as? (URL) -> Void
		perform?(`url`)
		do {
		    _ = try methodReturnValue(.m_importData__from_url(Parameter<URL>.value(`url`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func resetLastImportDate() throws {
        addInvocation(.m_resetLastImportDate)
		let perform = methodPerformValue(.m_resetLastImportDate) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resetLastImportDate).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func percentComplete() -> Double {
        addInvocation(.m_percentComplete)
		let perform = methodPerformValue(.m_percentComplete) as? () -> Void
		perform?()
		var __value: Double
		do {
		    __value = try methodReturnValue(.m_percentComplete).casted()
		} catch {
			onFatalFailure("Stub return value not specified for percentComplete(). Use given")
			Failure("Stub return value not specified for percentComplete(). Use given")
		}
		return __value
    }

    open func cancel() {
        addInvocation(.m_cancel)
		let perform = methodPerformValue(.m_cancel) as? () -> Void
		perform?()
    }

    open func pause() {
        addInvocation(.m_pause)
		let perform = methodPerformValue(.m_pause) as? () -> Void
		perform?()
    }

    open func resume() throws {
        addInvocation(.m_resume)
		let perform = methodPerformValue(.m_resume) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resume).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func equalTo(_ other: Importer) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<Importer>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<Importer>.value(`other`))) as? (Importer) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<Importer>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: Importer). Use given")
			Failure("Stub return value not specified for equalTo(_ other: Importer). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_importData__from_url(Parameter<URL>)
        case m_resetLastImportDate
        case m_percentComplete
        case m_cancel
        case m_pause
        case m_resume
        case m_equalTo__other(Parameter<Importer>)
        case p_dataTypePluralName_get
        case p_sourceName_get
        case p_customImportMessage_get
        case p_lastImport_get
        case p_isPaused_get
        case p_isCancelled_get
        case p_importOnlyNewData_get
		case p_importOnlyNewData_set(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsUrl) && !isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				if isCapturing(lhsUrl) || isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "from url"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_resetLastImportDate, .m_resetLastImportDate): return .match

            case (.m_percentComplete, .m_percentComplete): return .match

            case (.m_cancel, .m_cancel): return .match

            case (.m_pause, .m_pause): return .match

            case (.m_resume, .m_resume): return .match

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
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return Matcher.ComparisonResult.match
            case (.p_sourceName_get,.p_sourceName_get): return Matcher.ComparisonResult.match
            case (.p_customImportMessage_get,.p_customImportMessage_get): return Matcher.ComparisonResult.match
            case (.p_lastImport_get,.p_lastImport_get): return Matcher.ComparisonResult.match
            case (.p_isPaused_get,.p_isPaused_get): return Matcher.ComparisonResult.match
            case (.p_isCancelled_get,.p_isCancelled_get): return Matcher.ComparisonResult.match
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return Matcher.ComparisonResult.match
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_importData__from_url(p0): return p0.intValue
            case .m_resetLastImportDate: return 0
            case .m_percentComplete: return 0
            case .m_cancel: return 0
            case .m_pause: return 0
            case .m_resume: return 0
            case let .m_equalTo__other(p0): return p0.intValue
            case .p_dataTypePluralName_get: return 0
            case .p_sourceName_get: return 0
            case .p_customImportMessage_get: return 0
            case .p_lastImport_get: return 0
            case .p_isPaused_get: return 0
            case .p_isCancelled_get: return 0
            case .p_importOnlyNewData_get: return 0
			case .p_importOnlyNewData_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_importData__from_url: return ".importData(from:)"
            case .m_resetLastImportDate: return ".resetLastImportDate()"
            case .m_percentComplete: return ".percentComplete()"
            case .m_cancel: return ".cancel()"
            case .m_pause: return ".pause()"
            case .m_resume: return ".resume()"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .p_dataTypePluralName_get: return "[get] .dataTypePluralName"
            case .p_sourceName_get: return "[get] .sourceName"
            case .p_customImportMessage_get: return "[get] .customImportMessage"
            case .p_lastImport_get: return "[get] .lastImport"
            case .p_isPaused_get: return "[get] .isPaused"
            case .p_isCancelled_get: return "[get] .isCancelled"
            case .p_importOnlyNewData_get: return "[get] .importOnlyNewData"
			case .p_importOnlyNewData_set: return "[set] .importOnlyNewData"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func dataTypePluralName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_dataTypePluralName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func sourceName(getter defaultValue: String...) -> PropertyStub {
            return Given(method: .p_sourceName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func customImportMessage(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_customImportMessage_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastImport(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_lastImport_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isPaused(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isPaused_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isCancelled(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isCancelled_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func importOnlyNewData(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_importOnlyNewData_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func percentComplete(willReturn: Double...) -> MethodStub {
            return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<Importer>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func percentComplete(willProduce: (Stubber<Double>) -> Void) -> MethodStub {
            let willReturn: [Double] = []
			let given: Given = { return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Double).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ other: Parameter<Importer>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func importData(from url: Parameter<URL>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func importData(from url: Parameter<URL>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_importData__from_url(`url`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resetLastImportDate(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resetLastImportDate(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resetLastImportDate, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resume(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resume(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resume, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func importData(from url: Parameter<URL>) -> Verify { return Verify(method: .m_importData__from_url(`url`))}
        public static func resetLastImportDate() -> Verify { return Verify(method: .m_resetLastImportDate)}
        public static func percentComplete() -> Verify { return Verify(method: .m_percentComplete)}
        public static func cancel() -> Verify { return Verify(method: .m_cancel)}
        public static func pause() -> Verify { return Verify(method: .m_pause)}
        public static func resume() -> Verify { return Verify(method: .m_resume)}
        public static func equalTo(_ other: Parameter<Importer>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static var dataTypePluralName: Verify { return Verify(method: .p_dataTypePluralName_get) }
        public static var sourceName: Verify { return Verify(method: .p_sourceName_get) }
        public static var customImportMessage: Verify { return Verify(method: .p_customImportMessage_get) }
        public static var lastImport: Verify { return Verify(method: .p_lastImport_get) }
        public static var isPaused: Verify { return Verify(method: .p_isPaused_get) }
        public static var isCancelled: Verify { return Verify(method: .p_isCancelled_get) }
        public static var importOnlyNewData: Verify { return Verify(method: .p_importOnlyNewData_get) }
		public static func importOnlyNewData(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_importOnlyNewData_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func importData(from url: Parameter<URL>, perform: @escaping (URL) -> Void) -> Perform {
            return Perform(method: .m_importData__from_url(`url`), performs: perform)
        }
        public static func resetLastImportDate(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetLastImportDate, performs: perform)
        }
        public static func percentComplete(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_percentComplete, performs: perform)
        }
        public static func cancel(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_cancel, performs: perform)
        }
        public static func pause(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_pause, performs: perform)
        }
        public static func resume(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resume, performs: perform)
        }
        public static func equalTo(_ other: Parameter<Importer>, perform: @escaping (Importer) -> Void) -> Perform {
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

