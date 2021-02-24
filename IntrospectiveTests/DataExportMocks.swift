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


// MARK: - Exporter

open class ExporterMock: Exporter, Mock {
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
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "ExporterMock - stub value for dataTypePluralName was not defined") }
	}
	private var __p_dataTypePluralName: (String)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "ExporterMock - stub value for isPaused was not defined") }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "ExporterMock - stub value for isCancelled was not defined") }
	}
	private var __p_isCancelled: (Bool)?

    public var url: URL {
		get {	invocations.append(.p_url_get); return __p_url ?? givenGetterValue(.p_url_get, "ExporterMock - stub value for url was not defined") }
	}
	private var __p_url: (URL)?





    open func exportData() throws {
        addInvocation(.m_exportData)
		let perform = methodPerformValue(.m_exportData) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_exportData).casted() as Void
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

    open func equalTo(_ other: Exporter) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<Exporter>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<Exporter>.value(`other`))) as? (Exporter) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<Exporter>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: Exporter). Use given")
			Failure("Stub return value not specified for equalTo(_ other: Exporter). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_exportData
        case m_percentComplete
        case m_cancel
        case m_pause
        case m_resume
        case m_equalTo__other(Parameter<Exporter>)
        case p_dataTypePluralName_get
        case p_isPaused_get
        case p_isCancelled_get
        case p_url_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_exportData, .m_exportData): return .match

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
            case (.p_isPaused_get,.p_isPaused_get): return Matcher.ComparisonResult.match
            case (.p_isCancelled_get,.p_isCancelled_get): return Matcher.ComparisonResult.match
            case (.p_url_get,.p_url_get): return Matcher.ComparisonResult.match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_exportData: return 0
            case .m_percentComplete: return 0
            case .m_cancel: return 0
            case .m_pause: return 0
            case .m_resume: return 0
            case let .m_equalTo__other(p0): return p0.intValue
            case .p_dataTypePluralName_get: return 0
            case .p_isPaused_get: return 0
            case .p_isCancelled_get: return 0
            case .p_url_get: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_exportData: return ".exportData()"
            case .m_percentComplete: return ".percentComplete()"
            case .m_cancel: return ".cancel()"
            case .m_pause: return ".pause()"
            case .m_resume: return ".resume()"
            case .m_equalTo__other: return ".equalTo(_:)"
            case .p_dataTypePluralName_get: return "[get] .dataTypePluralName"
            case .p_isPaused_get: return "[get] .isPaused"
            case .p_isCancelled_get: return "[get] .isCancelled"
            case .p_url_get: return "[get] .url"
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
        public static func isPaused(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isPaused_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isCancelled(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isCancelled_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func url(getter defaultValue: URL...) -> PropertyStub {
            return Given(method: .p_url_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func percentComplete(willReturn: Double...) -> MethodStub {
            return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<Exporter>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func percentComplete(willProduce: (Stubber<Double>) -> Void) -> MethodStub {
            let willReturn: [Double] = []
			let given: Given = { return Given(method: .m_percentComplete, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Double).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ other: Parameter<Exporter>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func exportData(willThrow: Error...) -> MethodStub {
            return Given(method: .m_exportData, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func exportData(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_exportData, products: willThrow.map({ StubProduct.throw($0) })) }()
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

        public static func exportData() -> Verify { return Verify(method: .m_exportData)}
        public static func percentComplete() -> Verify { return Verify(method: .m_percentComplete)}
        public static func cancel() -> Verify { return Verify(method: .m_cancel)}
        public static func pause() -> Verify { return Verify(method: .m_pause)}
        public static func resume() -> Verify { return Verify(method: .m_resume)}
        public static func equalTo(_ other: Parameter<Exporter>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
        public static var dataTypePluralName: Verify { return Verify(method: .p_dataTypePluralName_get) }
        public static var isPaused: Verify { return Verify(method: .p_isPaused_get) }
        public static var isCancelled: Verify { return Verify(method: .p_isCancelled_get) }
        public static var url: Verify { return Verify(method: .p_url_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func exportData(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_exportData, performs: perform)
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
        public static func equalTo(_ other: Parameter<Exporter>, perform: @escaping (Exporter) -> Void) -> Perform {
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

// MARK: - ExporterUtil

open class ExporterUtilMock: ExporterUtil, Mock {
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






    open func urlOfExportFile(for sampleType: Exportable.Type, in directory: URL) -> URL {
        addInvocation(.m_urlOfExportFile__for_sampleTypein_directory(Parameter<Exportable.Type>.value(`sampleType`), Parameter<URL>.value(`directory`)))
		let perform = methodPerformValue(.m_urlOfExportFile__for_sampleTypein_directory(Parameter<Exportable.Type>.value(`sampleType`), Parameter<URL>.value(`directory`))) as? (Exportable.Type, URL) -> Void
		perform?(`sampleType`, `directory`)
		var __value: URL
		do {
		    __value = try methodReturnValue(.m_urlOfExportFile__for_sampleTypein_directory(Parameter<Exportable.Type>.value(`sampleType`), Parameter<URL>.value(`directory`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for urlOfExportFile(for sampleType: Exportable.Type, in directory: URL). Use given")
			Failure("Stub return value not specified for urlOfExportFile(for sampleType: Exportable.Type, in directory: URL). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_urlOfExportFile__for_sampleTypein_directory(Parameter<Exportable.Type>, Parameter<URL>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_urlOfExportFile__for_sampleTypein_directory(let lhsSampletype, let lhsDirectory), .m_urlOfExportFile__for_sampleTypein_directory(let rhsSampletype, let rhsDirectory)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSampletype) && !isCapturing(rhsSampletype) {
					comparison = Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSampletype, rhsSampletype, "for sampleType"))
				}


				if !isCapturing(lhsDirectory) && !isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "in directory"))
				}

				if isCapturing(lhsSampletype) || isCapturing(rhsSampletype) {
					comparison = Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSampletype, rhsSampletype, "for sampleType"))
				}


				if isCapturing(lhsDirectory) || isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "in directory"))
				}

				return Matcher.ComparisonResult(results)
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_urlOfExportFile__for_sampleTypein_directory(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_urlOfExportFile__for_sampleTypein_directory: return ".urlOfExportFile(for:in:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func urlOfExportFile(for sampleType: Parameter<Exportable.Type>, in directory: Parameter<URL>, willReturn: URL...) -> MethodStub {
            return Given(method: .m_urlOfExportFile__for_sampleTypein_directory(`sampleType`, `directory`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func urlOfExportFile(for sampleType: Parameter<Exportable.Type>, in directory: Parameter<URL>, willProduce: (Stubber<URL>) -> Void) -> MethodStub {
            let willReturn: [URL] = []
			let given: Given = { return Given(method: .m_urlOfExportFile__for_sampleTypein_directory(`sampleType`, `directory`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (URL).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func urlOfExportFile(for sampleType: Parameter<Exportable.Type>, in directory: Parameter<URL>) -> Verify { return Verify(method: .m_urlOfExportFile__for_sampleTypein_directory(`sampleType`, `directory`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func urlOfExportFile(for sampleType: Parameter<Exportable.Type>, in directory: Parameter<URL>, perform: @escaping (Exportable.Type, URL) -> Void) -> Perform {
            return Perform(method: .m_urlOfExportFile__for_sampleTypein_directory(`sampleType`, `directory`), performs: perform)
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

