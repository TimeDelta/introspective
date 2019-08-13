// Generated using Sourcery 0.16.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



//swiftlint:disable force_cast
//swiftlint:disable function_body_length
//swiftlint:disable line_length
//swiftlint:disable vertical_whitespace

#if MockyCustom
import SwiftyMocky
import HealthKit
import CoreData
import Presentr
import CSV
import SwiftDate
import UserNotifications
import Instructions
@testable import Introspective

    public final class MockyAssertion {
        public static var handler: ((Bool, String, StaticString, UInt) -> Void)?
    }

    func MockyAssert(_ expression: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "Verification failed", file: StaticString = #file, line: UInt = #line) {
        guard let handler = MockyAssertion.handler else {
            assert(expression, message, file: file, line: line)
            return
        }

        handler(expression(), message(), file, line)
    }
#elseif Mocky
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

    func MockyAssert(_ expression: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "Verification failed", file: StaticString = #file, line: UInt = #line) {
        XCTAssert(expression(), message(), file: file, line: line)
    }
#else
import Sourcery
import SourceryRuntime
#endif






















// MARK: - ATrackerActivityImporter
open class ATrackerActivityImporterMock: ATrackerActivityImporter, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "ATrackerActivityImporterMock - stub value for dataTypePluralName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_dataTypePluralName = newValue }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "ATrackerActivityImporterMock - stub value for sourceName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_sourceName = newValue }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "ATrackerActivityImporterMock - stub value for customImportMessage was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_customImportMessage = newValue }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "ATrackerActivityImporterMock - stub value for lastImport was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_lastImport = newValue }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "ATrackerActivityImporterMock - stub value for isPaused was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isPaused = newValue }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "ATrackerActivityImporterMock - stub value for isCancelled was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isCancelled = newValue }
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
                guard Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher) else { return false } 
                return true 
            case (.m_resetLastImportDate, .m_resetLastImportDate):
                return true 
            case (.m_percentComplete, .m_percentComplete):
                return true 
            case (.m_cancel, .m_cancel):
                return true 
            case (.m_pause, .m_pause):
                return true 
            case (.m_resume, .m_resume):
                return true 
            case (.m_equalTo__other(let lhsOther), .m_equalTo__other(let rhsOther)):
                guard Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher) else { return false } 
                return true 
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return true
            case (.p_sourceName_get,.p_sourceName_get): return true
            case (.p_customImportMessage_get,.p_customImportMessage_get): return true
            case (.p_lastImport_get,.p_lastImport_get): return true
            case (.p_isPaused_get,.p_isPaused_get): return true
            case (.p_isCancelled_get,.p_isCancelled_get): return true
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return true
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - ActivityExporter
open class ActivityExporterMock: ActivityExporter, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "ActivityExporterMock - stub value for dataTypePluralName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_dataTypePluralName = newValue }
	}
	private var __p_dataTypePluralName: (String)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "ActivityExporterMock - stub value for isPaused was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isPaused = newValue }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "ActivityExporterMock - stub value for isCancelled was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isCancelled = newValue }
	}
	private var __p_isCancelled: (Bool)?

    public var url: URL {
		get {	invocations.append(.p_url_get); return __p_url ?? givenGetterValue(.p_url_get, "ActivityExporterMock - stub value for url was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_url = newValue }
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_exportData, .m_exportData):
                return true 
            case (.m_percentComplete, .m_percentComplete):
                return true 
            case (.m_cancel, .m_cancel):
                return true 
            case (.m_pause, .m_pause):
                return true 
            case (.m_resume, .m_resume):
                return true 
            case (.m_equalTo__other(let lhsOther), .m_equalTo__other(let rhsOther)):
                guard Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher) else { return false } 
                return true 
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return true
            case (.p_isPaused_get,.p_isPaused_get): return true
            case (.p_isCancelled_get,.p_isCancelled_get): return true
            case (.p_url_get,.p_url_get): return true
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - ActivityQuery
open class ActivityQueryMock: ActivityQuery, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "ActivityQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "ActivityQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "ActivityQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - Attribute
open class AttributeMock: Attribute, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var name: String {
		get {	invocations.append(.p_name_get); return __p_name ?? givenGetterValue(.p_name_get, "AttributeMock - stub value for name was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_name = newValue }
	}
	private var __p_name: (String)?

    public var pluralName: String {
		get {	invocations.append(.p_pluralName_get); return __p_pluralName ?? givenGetterValue(.p_pluralName_get, "AttributeMock - stub value for pluralName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_pluralName = newValue }
	}
	private var __p_pluralName: (String)?

    public var variableName: String? {
		get {	invocations.append(.p_variableName_get); return __p_variableName ?? optionalGivenGetterValue(.p_variableName_get, "AttributeMock - stub value for variableName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_variableName = newValue }
	}
	private var __p_variableName: (String)?

    public var extendedDescription: String? {
		get {	invocations.append(.p_extendedDescription_get); return __p_extendedDescription ?? optionalGivenGetterValue(.p_extendedDescription_get, "AttributeMock - stub value for extendedDescription was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_extendedDescription = newValue }
	}
	private var __p_extendedDescription: (String)?

    public var optional: Bool {
		get {	invocations.append(.p_optional_get); return __p_optional ?? givenGetterValue(.p_optional_get, "AttributeMock - stub value for optional was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_optional = newValue }
	}
	private var __p_optional: (Bool)?

    public var valueType: Any.Type {
		get {	invocations.append(.p_valueType_get); return __p_valueType ?? givenGetterValue(.p_valueType_get, "AttributeMock - stub value for valueType was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_valueType = newValue }
	}
	private var __p_valueType: (Any.Type)?

    public var typeName: String {
		get {	invocations.append(.p_typeName_get); return __p_typeName ?? givenGetterValue(.p_typeName_get, "AttributeMock - stub value for typeName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_typeName = newValue }
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_isValid__value_value(let lhsValue), .m_isValid__value_value(let rhsValue)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_equalTo__otherAttribute(let lhsOtherattribute), .m_equalTo__otherAttribute(let rhsOtherattribute)):
                guard Parameter.compare(lhs: lhsOtherattribute, rhs: rhsOtherattribute, with: matcher) else { return false } 
                return true 
            case (.m_convertToDisplayableString__from_value(let lhsValue), .m_convertToDisplayableString__from_value(let rhsValue)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_valuesAreEqual__first_second(let lhsFirst, let lhsSecond), .m_valuesAreEqual__first_second(let rhsFirst, let rhsSecond)):
                guard Parameter.compare(lhs: lhsFirst, rhs: rhsFirst, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSecond, rhs: rhsSecond, with: matcher) else { return false } 
                return true 
            case (.p_name_get,.p_name_get): return true
            case (.p_pluralName_get,.p_pluralName_get): return true
            case (.p_variableName_get,.p_variableName_get): return true
            case (.p_extendedDescription_get,.p_extendedDescription_get): return true
            case (.p_optional_get,.p_optional_get): return true
            case (.p_valueType_get,.p_valueType_get): return true
            case (.p_typeName_get,.p_typeName_get): return true
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - AttributeFactory
open class AttributeFactoryMock: AttributeFactory, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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






    fileprivate struct MethodType {
        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool { return true }
        func intValue() -> Int { return 0 }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - AttributeRestrictionFactory
open class AttributeRestrictionFactoryMock: AttributeRestrictionFactory, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_typesFor__attribute(let lhsAttribute), .m_typesFor__attribute(let rhsAttribute)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                return true 
            case (.m_initialize__type_typeforAttribute_attribute(let lhsType, let lhsAttribute), .m_initialize__type_typeforAttribute_attribute(let rhsType, let rhsAttribute)):
                guard Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_typesFor__attribute(p0): return p0.intValue
            case let .m_initialize__type_typeforAttribute_attribute(p0, p1): return p0.intValue + p1.intValue
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - BloodPressureQuery
open class BloodPressureQueryMock: BloodPressureQuery, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "BloodPressureQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "BloodPressureQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "BloodPressureQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - BodyMassIndexQuery
open class BodyMassIndexQueryMock: BodyMassIndexQuery, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "BodyMassIndexQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "BodyMassIndexQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "BodyMassIndexQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - BooleanAlgebraFactory
open class BooleanAlgebraFactoryMock: BooleanAlgebraFactory, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func parser() -> BooleanExpressionParser {
        addInvocation(.m_parser)
		let perform = methodPerformValue(.m_parser) as? () -> Void
		perform?()
		var __value: BooleanExpressionParser
		do {
		    __value = try methodReturnValue(.m_parser).casted()
		} catch {
			onFatalFailure("Stub return value not specified for parser(). Use given")
			Failure("Stub return value not specified for parser(). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_parser

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_parser, .m_parser):
                return true 
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_parser: return 0
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func parser(willReturn: BooleanExpressionParser...) -> MethodStub {
            return Given(method: .m_parser, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func parser(willProduce: (Stubber<BooleanExpressionParser>) -> Void) -> MethodStub {
            let willReturn: [BooleanExpressionParser] = []
			let given: Given = { return Given(method: .m_parser, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (BooleanExpressionParser).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func parser() -> Verify { return Verify(method: .m_parser)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func parser(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_parser, performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - BooleanExpressionParser
open class BooleanExpressionParserMock: BooleanExpressionParser, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_parse__parts(let lhsParts), .m_parse__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_parse__parts(p0): return p0.intValue
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - CalendarUtil
open class CalendarUtilMock: CalendarUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func convert(_ date: Date, from fromTimeZone: TimeZone, to toTimeZone: TimeZone) -> Date {
        addInvocation(.m_convert__datefrom_fromTimeZoneto_toTimeZone(Parameter<Date>.value(`date`), Parameter<TimeZone>.value(`fromTimeZone`), Parameter<TimeZone>.value(`toTimeZone`)))
		let perform = methodPerformValue(.m_convert__datefrom_fromTimeZoneto_toTimeZone(Parameter<Date>.value(`date`), Parameter<TimeZone>.value(`fromTimeZone`), Parameter<TimeZone>.value(`toTimeZone`))) as? (Date, TimeZone, TimeZone) -> Void
		perform?(`date`, `fromTimeZone`, `toTimeZone`)
		var __value: Date
		do {
		    __value = try methodReturnValue(.m_convert__datefrom_fromTimeZoneto_toTimeZone(Parameter<Date>.value(`date`), Parameter<TimeZone>.value(`fromTimeZone`), Parameter<TimeZone>.value(`toTimeZone`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for convert(_ date: Date, from fromTimeZone: TimeZone, to toTimeZone: TimeZone). Use given")
			Failure("Stub return value not specified for convert(_ date: Date, from fromTimeZone: TimeZone, to toTimeZone: TimeZone). Use given")
		}
		return __value
    }

    open func start(of component: Calendar.Component, in date: Date) -> Date {
        addInvocation(.m_start__of_componentin_date(Parameter<Calendar.Component>.value(`component`), Parameter<Date>.value(`date`)))
		let perform = methodPerformValue(.m_start__of_componentin_date(Parameter<Calendar.Component>.value(`component`), Parameter<Date>.value(`date`))) as? (Calendar.Component, Date) -> Void
		perform?(`component`, `date`)
		var __value: Date
		do {
		    __value = try methodReturnValue(.m_start__of_componentin_date(Parameter<Calendar.Component>.value(`component`), Parameter<Date>.value(`date`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for start(of component: Calendar.Component, in date: Date). Use given")
			Failure("Stub return value not specified for start(of component: Calendar.Component, in date: Date). Use given")
		}
		return __value
    }

    open func end(of component: Calendar.Component, in date: Date) -> Date {
        addInvocation(.m_end__of_componentin_date(Parameter<Calendar.Component>.value(`component`), Parameter<Date>.value(`date`)))
		let perform = methodPerformValue(.m_end__of_componentin_date(Parameter<Calendar.Component>.value(`component`), Parameter<Date>.value(`date`))) as? (Calendar.Component, Date) -> Void
		perform?(`component`, `date`)
		var __value: Date
		do {
		    __value = try methodReturnValue(.m_end__of_componentin_date(Parameter<Calendar.Component>.value(`component`), Parameter<Date>.value(`date`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for end(of component: Calendar.Component, in date: Date). Use given")
			Failure("Stub return value not specified for end(of component: Calendar.Component, in date: Date). Use given")
		}
		return __value
    }

    open func string(for date: Date, inFormat format: String) -> String {
        addInvocation(.m_string__for_dateinFormat_format(Parameter<Date>.value(`date`), Parameter<String>.value(`format`)))
		let perform = methodPerformValue(.m_string__for_dateinFormat_format(Parameter<Date>.value(`date`), Parameter<String>.value(`format`))) as? (Date, String) -> Void
		perform?(`date`, `format`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_string__for_dateinFormat_format(Parameter<Date>.value(`date`), Parameter<String>.value(`format`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for string(for date: Date, inFormat format: String). Use given")
			Failure("Stub return value not specified for string(for date: Date, inFormat format: String). Use given")
		}
		return __value
    }

    open func string(for date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        addInvocation(.m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(Parameter<Date>.value(`date`), Parameter<DateFormatter.Style>.value(`dateStyle`), Parameter<DateFormatter.Style>.value(`timeStyle`)))
		let perform = methodPerformValue(.m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(Parameter<Date>.value(`date`), Parameter<DateFormatter.Style>.value(`dateStyle`), Parameter<DateFormatter.Style>.value(`timeStyle`))) as? (Date, DateFormatter.Style, DateFormatter.Style) -> Void
		perform?(`date`, `dateStyle`, `timeStyle`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(Parameter<Date>.value(`date`), Parameter<DateFormatter.Style>.value(`dateStyle`), Parameter<DateFormatter.Style>.value(`timeStyle`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for string(for date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style). Use given")
			Failure("Stub return value not specified for string(for date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style). Use given")
		}
		return __value
    }

    open func date(_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date) -> Bool {
        addInvocation(.m_date__date1occursOnSame_componentas_date2(Parameter<Date>.value(`date1`), Parameter<Calendar.Component>.value(`component`), Parameter<Date>.value(`date2`)))
		let perform = methodPerformValue(.m_date__date1occursOnSame_componentas_date2(Parameter<Date>.value(`date1`), Parameter<Calendar.Component>.value(`component`), Parameter<Date>.value(`date2`))) as? (Date, Calendar.Component, Date) -> Void
		perform?(`date1`, `component`, `date2`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_date__date1occursOnSame_componentas_date2(Parameter<Date>.value(`date1`), Parameter<Calendar.Component>.value(`component`), Parameter<Date>.value(`date2`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for date(_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date). Use given")
			Failure("Stub return value not specified for date(_ date1: Date, occursOnSame component: Calendar.Component, as date2: Date). Use given")
		}
		return __value
    }

    open func compare(_ date1: Date?, _ date2: Date?) -> ComparisonResult {
        addInvocation(.m_compare__date1_date2(Parameter<Date?>.value(`date1`), Parameter<Date?>.value(`date2`)))
		let perform = methodPerformValue(.m_compare__date1_date2(Parameter<Date?>.value(`date1`), Parameter<Date?>.value(`date2`))) as? (Date?, Date?) -> Void
		perform?(`date1`, `date2`)
		var __value: ComparisonResult
		do {
		    __value = try methodReturnValue(.m_compare__date1_date2(Parameter<Date?>.value(`date1`), Parameter<Date?>.value(`date2`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for compare(_ date1: Date?, _ date2: Date?). Use given")
			Failure("Stub return value not specified for compare(_ date1: Date?, _ date2: Date?). Use given")
		}
		return __value
    }

    open func date<CollectionType: Collection>(_ date: Date, isOnOneOf daysOfWeek: CollectionType) -> Bool where CollectionType.Element == DayOfWeek {
        addInvocation(.m_date__dateisOnOneOf_daysOfWeek(Parameter<Date>.value(`date`), Parameter<CollectionType>.value(`daysOfWeek`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_date__dateisOnOneOf_daysOfWeek(Parameter<Date>.value(`date`), Parameter<CollectionType>.value(`daysOfWeek`).wrapAsGeneric())) as? (Date, CollectionType) -> Void
		perform?(`date`, `daysOfWeek`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_date__dateisOnOneOf_daysOfWeek(Parameter<Date>.value(`date`), Parameter<CollectionType>.value(`daysOfWeek`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for date<CollectionType: Collection>(_ date: Date, isOnOneOf daysOfWeek: CollectionType). Use given")
			Failure("Stub return value not specified for date<CollectionType: Collection>(_ date: Date, isOnOneOf daysOfWeek: CollectionType). Use given")
		}
		return __value
    }

    open func date(_ date: Date, isOnA dayOfWeek: DayOfWeek) -> Bool {
        addInvocation(.m_date__dateisOnA_dayOfWeek(Parameter<Date>.value(`date`), Parameter<DayOfWeek>.value(`dayOfWeek`)))
		let perform = methodPerformValue(.m_date__dateisOnA_dayOfWeek(Parameter<Date>.value(`date`), Parameter<DayOfWeek>.value(`dayOfWeek`))) as? (Date, DayOfWeek) -> Void
		perform?(`date`, `dayOfWeek`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_date__dateisOnA_dayOfWeek(Parameter<Date>.value(`date`), Parameter<DayOfWeek>.value(`dayOfWeek`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for date(_ date: Date, isOnA dayOfWeek: DayOfWeek). Use given")
			Failure("Stub return value not specified for date(_ date: Date, isOnA dayOfWeek: DayOfWeek). Use given")
		}
		return __value
    }

    open func date(from dateStr: String, format: String?) -> Date? {
        addInvocation(.m_date__from_dateStrformat_format(Parameter<String>.value(`dateStr`), Parameter<String?>.value(`format`)))
		let perform = methodPerformValue(.m_date__from_dateStrformat_format(Parameter<String>.value(`dateStr`), Parameter<String?>.value(`format`))) as? (String, String?) -> Void
		perform?(`dateStr`, `format`)
		var __value: Date? = nil
		do {
		    __value = try methodReturnValue(.m_date__from_dateStrformat_format(Parameter<String>.value(`dateStr`), Parameter<String?>.value(`format`))).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func dayOfWeek(forDate date: Date) -> DayOfWeek {
        addInvocation(.m_dayOfWeek__forDate_date(Parameter<Date>.value(`date`)))
		let perform = methodPerformValue(.m_dayOfWeek__forDate_date(Parameter<Date>.value(`date`))) as? (Date) -> Void
		perform?(`date`)
		var __value: DayOfWeek
		do {
		    __value = try methodReturnValue(.m_dayOfWeek__forDate_date(Parameter<Date>.value(`date`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for dayOfWeek(forDate date: Date). Use given")
			Failure("Stub return value not specified for dayOfWeek(forDate date: Date). Use given")
		}
		return __value
    }

    open func distance(from date1: Date, to date2: Date, in unit: Calendar.Component) throws -> Int {
        addInvocation(.m_distance__from_date1to_date2in_unit(Parameter<Date>.value(`date1`), Parameter<Date>.value(`date2`), Parameter<Calendar.Component>.value(`unit`)))
		let perform = methodPerformValue(.m_distance__from_date1to_date2in_unit(Parameter<Date>.value(`date1`), Parameter<Date>.value(`date2`), Parameter<Calendar.Component>.value(`unit`))) as? (Date, Date, Calendar.Component) -> Void
		perform?(`date1`, `date2`, `unit`)
		var __value: Int
		do {
		    __value = try methodReturnValue(.m_distance__from_date1to_date2in_unit(Parameter<Date>.value(`date1`), Parameter<Date>.value(`date2`), Parameter<Calendar.Component>.value(`unit`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for distance(from date1: Date, to date2: Date, in unit: Calendar.Component). Use given")
			Failure("Stub return value not specified for distance(from date1: Date, to date2: Date, in unit: Calendar.Component). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func currentTimeZone() -> TimeZone {
        addInvocation(.m_currentTimeZone)
		let perform = methodPerformValue(.m_currentTimeZone) as? () -> Void
		perform?()
		var __value: TimeZone
		do {
		    __value = try methodReturnValue(.m_currentTimeZone).casted()
		} catch {
			onFatalFailure("Stub return value not specified for currentTimeZone(). Use given")
			Failure("Stub return value not specified for currentTimeZone(). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_convert__datefrom_fromTimeZoneto_toTimeZone(Parameter<Date>, Parameter<TimeZone>, Parameter<TimeZone>)
        case m_start__of_componentin_date(Parameter<Calendar.Component>, Parameter<Date>)
        case m_end__of_componentin_date(Parameter<Calendar.Component>, Parameter<Date>)
        case m_string__for_dateinFormat_format(Parameter<Date>, Parameter<String>)
        case m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(Parameter<Date>, Parameter<DateFormatter.Style>, Parameter<DateFormatter.Style>)
        case m_date__date1occursOnSame_componentas_date2(Parameter<Date>, Parameter<Calendar.Component>, Parameter<Date>)
        case m_compare__date1_date2(Parameter<Date?>, Parameter<Date?>)
        case m_date__dateisOnOneOf_daysOfWeek(Parameter<Date>, Parameter<GenericAttribute>)
        case m_date__dateisOnA_dayOfWeek(Parameter<Date>, Parameter<DayOfWeek>)
        case m_date__from_dateStrformat_format(Parameter<String>, Parameter<String?>)
        case m_dayOfWeek__forDate_date(Parameter<Date>)
        case m_distance__from_date1to_date2in_unit(Parameter<Date>, Parameter<Date>, Parameter<Calendar.Component>)
        case m_currentTimeZone

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_convert__datefrom_fromTimeZoneto_toTimeZone(let lhsDate, let lhsFromtimezone, let lhsTotimezone), .m_convert__datefrom_fromTimeZoneto_toTimeZone(let rhsDate, let rhsFromtimezone, let rhsTotimezone)):
                guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsFromtimezone, rhs: rhsFromtimezone, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsTotimezone, rhs: rhsTotimezone, with: matcher) else { return false } 
                return true 
            case (.m_start__of_componentin_date(let lhsComponent, let lhsDate), .m_start__of_componentin_date(let rhsComponent, let rhsDate)):
                guard Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                return true 
            case (.m_end__of_componentin_date(let lhsComponent, let lhsDate), .m_end__of_componentin_date(let rhsComponent, let rhsDate)):
                guard Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                return true 
            case (.m_string__for_dateinFormat_format(let lhsDate, let lhsFormat), .m_string__for_dateinFormat_format(let rhsDate, let rhsFormat)):
                guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsFormat, rhs: rhsFormat, with: matcher) else { return false } 
                return true 
            case (.m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(let lhsDate, let lhsDatestyle, let lhsTimestyle), .m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(let rhsDate, let rhsDatestyle, let rhsTimestyle)):
                guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDatestyle, rhs: rhsDatestyle, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsTimestyle, rhs: rhsTimestyle, with: matcher) else { return false } 
                return true 
            case (.m_date__date1occursOnSame_componentas_date2(let lhsDate1, let lhsComponent, let lhsDate2), .m_date__date1occursOnSame_componentas_date2(let rhsDate1, let rhsComponent, let rhsDate2)):
                guard Parameter.compare(lhs: lhsDate1, rhs: rhsDate1, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDate2, rhs: rhsDate2, with: matcher) else { return false } 
                return true 
            case (.m_compare__date1_date2(let lhsDate1, let lhsDate2), .m_compare__date1_date2(let rhsDate1, let rhsDate2)):
                guard Parameter.compare(lhs: lhsDate1, rhs: rhsDate1, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDate2, rhs: rhsDate2, with: matcher) else { return false } 
                return true 
            case (.m_date__dateisOnOneOf_daysOfWeek(let lhsDate, let lhsDaysofweek), .m_date__dateisOnOneOf_daysOfWeek(let rhsDate, let rhsDaysofweek)):
                guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDaysofweek, rhs: rhsDaysofweek, with: matcher) else { return false } 
                return true 
            case (.m_date__dateisOnA_dayOfWeek(let lhsDate, let lhsDayofweek), .m_date__dateisOnA_dayOfWeek(let rhsDate, let rhsDayofweek)):
                guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDayofweek, rhs: rhsDayofweek, with: matcher) else { return false } 
                return true 
            case (.m_date__from_dateStrformat_format(let lhsDatestr, let lhsFormat), .m_date__from_dateStrformat_format(let rhsDatestr, let rhsFormat)):
                guard Parameter.compare(lhs: lhsDatestr, rhs: rhsDatestr, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsFormat, rhs: rhsFormat, with: matcher) else { return false } 
                return true 
            case (.m_dayOfWeek__forDate_date(let lhsDate), .m_dayOfWeek__forDate_date(let rhsDate)):
                guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                return true 
            case (.m_distance__from_date1to_date2in_unit(let lhsDate1, let lhsDate2, let lhsUnit), .m_distance__from_date1to_date2in_unit(let rhsDate1, let rhsDate2, let rhsUnit)):
                guard Parameter.compare(lhs: lhsDate1, rhs: rhsDate1, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDate2, rhs: rhsDate2, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsUnit, rhs: rhsUnit, with: matcher) else { return false } 
                return true 
            case (.m_currentTimeZone, .m_currentTimeZone):
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_convert__datefrom_fromTimeZoneto_toTimeZone(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_start__of_componentin_date(p0, p1): return p0.intValue + p1.intValue
            case let .m_end__of_componentin_date(p0, p1): return p0.intValue + p1.intValue
            case let .m_string__for_dateinFormat_format(p0, p1): return p0.intValue + p1.intValue
            case let .m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_date__date1occursOnSame_componentas_date2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_compare__date1_date2(p0, p1): return p0.intValue + p1.intValue
            case let .m_date__dateisOnOneOf_daysOfWeek(p0, p1): return p0.intValue + p1.intValue
            case let .m_date__dateisOnA_dayOfWeek(p0, p1): return p0.intValue + p1.intValue
            case let .m_date__from_dateStrformat_format(p0, p1): return p0.intValue + p1.intValue
            case let .m_dayOfWeek__forDate_date(p0): return p0.intValue
            case let .m_distance__from_date1to_date2in_unit(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case .m_currentTimeZone: return 0
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func convert(_ date: Parameter<Date>, from fromTimeZone: Parameter<TimeZone>, to toTimeZone: Parameter<TimeZone>, willReturn: Date...) -> MethodStub {
            return Given(method: .m_convert__datefrom_fromTimeZoneto_toTimeZone(`date`, `fromTimeZone`, `toTimeZone`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func start(of component: Parameter<Calendar.Component>, in date: Parameter<Date>, willReturn: Date...) -> MethodStub {
            return Given(method: .m_start__of_componentin_date(`component`, `date`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func end(of component: Parameter<Calendar.Component>, in date: Parameter<Date>, willReturn: Date...) -> MethodStub {
            return Given(method: .m_end__of_componentin_date(`component`, `date`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func string(for date: Parameter<Date>, inFormat format: Parameter<String>, willReturn: String...) -> MethodStub {
            return Given(method: .m_string__for_dateinFormat_format(`date`, `format`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func string(for date: Parameter<Date>, dateStyle: Parameter<DateFormatter.Style>, timeStyle: Parameter<DateFormatter.Style>, willReturn: String...) -> MethodStub {
            return Given(method: .m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(`date`, `dateStyle`, `timeStyle`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func date(_ date1: Parameter<Date>, occursOnSame component: Parameter<Calendar.Component>, as date2: Parameter<Date>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_date__date1occursOnSame_componentas_date2(`date1`, `component`, `date2`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func compare(_ date1: Parameter<Date?>, _ date2: Parameter<Date?>, willReturn: ComparisonResult...) -> MethodStub {
            return Given(method: .m_compare__date1_date2(`date1`, `date2`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func date<CollectionType: Collection>(_ date: Parameter<Date>, isOnOneOf daysOfWeek: Parameter<CollectionType>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_date__dateisOnOneOf_daysOfWeek(`date`, `daysOfWeek`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func date(_ date: Parameter<Date>, isOnA dayOfWeek: Parameter<DayOfWeek>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_date__dateisOnA_dayOfWeek(`date`, `dayOfWeek`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func date(from dateStr: Parameter<String>, format: Parameter<String?>, willReturn: Date?...) -> MethodStub {
            return Given(method: .m_date__from_dateStrformat_format(`dateStr`, `format`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func dayOfWeek(forDate date: Parameter<Date>, willReturn: DayOfWeek...) -> MethodStub {
            return Given(method: .m_dayOfWeek__forDate_date(`date`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func distance(from date1: Parameter<Date>, to date2: Parameter<Date>, in unit: Parameter<Calendar.Component>, willReturn: Int...) -> MethodStub {
            return Given(method: .m_distance__from_date1to_date2in_unit(`date1`, `date2`, `unit`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func currentTimeZone(willReturn: TimeZone...) -> MethodStub {
            return Given(method: .m_currentTimeZone, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func convert(_ date: Parameter<Date>, from fromTimeZone: Parameter<TimeZone>, to toTimeZone: Parameter<TimeZone>, willProduce: (Stubber<Date>) -> Void) -> MethodStub {
            let willReturn: [Date] = []
			let given: Given = { return Given(method: .m_convert__datefrom_fromTimeZoneto_toTimeZone(`date`, `fromTimeZone`, `toTimeZone`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Date).self)
			willProduce(stubber)
			return given
        }
        public static func start(of component: Parameter<Calendar.Component>, in date: Parameter<Date>, willProduce: (Stubber<Date>) -> Void) -> MethodStub {
            let willReturn: [Date] = []
			let given: Given = { return Given(method: .m_start__of_componentin_date(`component`, `date`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Date).self)
			willProduce(stubber)
			return given
        }
        public static func end(of component: Parameter<Calendar.Component>, in date: Parameter<Date>, willProduce: (Stubber<Date>) -> Void) -> MethodStub {
            let willReturn: [Date] = []
			let given: Given = { return Given(method: .m_end__of_componentin_date(`component`, `date`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Date).self)
			willProduce(stubber)
			return given
        }
        public static func string(for date: Parameter<Date>, inFormat format: Parameter<String>, willProduce: (Stubber<String>) -> Void) -> MethodStub {
            let willReturn: [String] = []
			let given: Given = { return Given(method: .m_string__for_dateinFormat_format(`date`, `format`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func string(for date: Parameter<Date>, dateStyle: Parameter<DateFormatter.Style>, timeStyle: Parameter<DateFormatter.Style>, willProduce: (Stubber<String>) -> Void) -> MethodStub {
            let willReturn: [String] = []
			let given: Given = { return Given(method: .m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(`date`, `dateStyle`, `timeStyle`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func date(_ date1: Parameter<Date>, occursOnSame component: Parameter<Calendar.Component>, as date2: Parameter<Date>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_date__date1occursOnSame_componentas_date2(`date1`, `component`, `date2`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func compare(_ date1: Parameter<Date?>, _ date2: Parameter<Date?>, willProduce: (Stubber<ComparisonResult>) -> Void) -> MethodStub {
            let willReturn: [ComparisonResult] = []
			let given: Given = { return Given(method: .m_compare__date1_date2(`date1`, `date2`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (ComparisonResult).self)
			willProduce(stubber)
			return given
        }
        public static func date<CollectionType: Collection>(_ date: Parameter<Date>, isOnOneOf daysOfWeek: Parameter<CollectionType>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_date__dateisOnOneOf_daysOfWeek(`date`, `daysOfWeek`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func date(_ date: Parameter<Date>, isOnA dayOfWeek: Parameter<DayOfWeek>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_date__dateisOnA_dayOfWeek(`date`, `dayOfWeek`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func date(from dateStr: Parameter<String>, format: Parameter<String?>, willProduce: (Stubber<Date?>) -> Void) -> MethodStub {
            let willReturn: [Date?] = []
			let given: Given = { return Given(method: .m_date__from_dateStrformat_format(`dateStr`, `format`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Date?).self)
			willProduce(stubber)
			return given
        }
        public static func dayOfWeek(forDate date: Parameter<Date>, willProduce: (Stubber<DayOfWeek>) -> Void) -> MethodStub {
            let willReturn: [DayOfWeek] = []
			let given: Given = { return Given(method: .m_dayOfWeek__forDate_date(`date`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (DayOfWeek).self)
			willProduce(stubber)
			return given
        }
        public static func currentTimeZone(willProduce: (Stubber<TimeZone>) -> Void) -> MethodStub {
            let willReturn: [TimeZone] = []
			let given: Given = { return Given(method: .m_currentTimeZone, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (TimeZone).self)
			willProduce(stubber)
			return given
        }
        public static func distance(from date1: Parameter<Date>, to date2: Parameter<Date>, in unit: Parameter<Calendar.Component>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_distance__from_date1to_date2in_unit(`date1`, `date2`, `unit`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func distance(from date1: Parameter<Date>, to date2: Parameter<Date>, in unit: Parameter<Calendar.Component>, willProduce: (StubberThrows<Int>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_distance__from_date1to_date2in_unit(`date1`, `date2`, `unit`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Int).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func convert(_ date: Parameter<Date>, from fromTimeZone: Parameter<TimeZone>, to toTimeZone: Parameter<TimeZone>) -> Verify { return Verify(method: .m_convert__datefrom_fromTimeZoneto_toTimeZone(`date`, `fromTimeZone`, `toTimeZone`))}
        public static func start(of component: Parameter<Calendar.Component>, in date: Parameter<Date>) -> Verify { return Verify(method: .m_start__of_componentin_date(`component`, `date`))}
        public static func end(of component: Parameter<Calendar.Component>, in date: Parameter<Date>) -> Verify { return Verify(method: .m_end__of_componentin_date(`component`, `date`))}
        public static func string(for date: Parameter<Date>, inFormat format: Parameter<String>) -> Verify { return Verify(method: .m_string__for_dateinFormat_format(`date`, `format`))}
        public static func string(for date: Parameter<Date>, dateStyle: Parameter<DateFormatter.Style>, timeStyle: Parameter<DateFormatter.Style>) -> Verify { return Verify(method: .m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(`date`, `dateStyle`, `timeStyle`))}
        public static func date(_ date1: Parameter<Date>, occursOnSame component: Parameter<Calendar.Component>, as date2: Parameter<Date>) -> Verify { return Verify(method: .m_date__date1occursOnSame_componentas_date2(`date1`, `component`, `date2`))}
        public static func compare(_ date1: Parameter<Date?>, _ date2: Parameter<Date?>) -> Verify { return Verify(method: .m_compare__date1_date2(`date1`, `date2`))}
        public static func date<CollectionType>(_ date: Parameter<Date>, isOnOneOf daysOfWeek: Parameter<CollectionType>) -> Verify where CollectionType:Collection { return Verify(method: .m_date__dateisOnOneOf_daysOfWeek(`date`, `daysOfWeek`.wrapAsGeneric()))}
        public static func date(_ date: Parameter<Date>, isOnA dayOfWeek: Parameter<DayOfWeek>) -> Verify { return Verify(method: .m_date__dateisOnA_dayOfWeek(`date`, `dayOfWeek`))}
        public static func date(from dateStr: Parameter<String>, format: Parameter<String?>) -> Verify { return Verify(method: .m_date__from_dateStrformat_format(`dateStr`, `format`))}
        public static func dayOfWeek(forDate date: Parameter<Date>) -> Verify { return Verify(method: .m_dayOfWeek__forDate_date(`date`))}
        public static func distance(from date1: Parameter<Date>, to date2: Parameter<Date>, in unit: Parameter<Calendar.Component>) -> Verify { return Verify(method: .m_distance__from_date1to_date2in_unit(`date1`, `date2`, `unit`))}
        public static func currentTimeZone() -> Verify { return Verify(method: .m_currentTimeZone)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func convert(_ date: Parameter<Date>, from fromTimeZone: Parameter<TimeZone>, to toTimeZone: Parameter<TimeZone>, perform: @escaping (Date, TimeZone, TimeZone) -> Void) -> Perform {
            return Perform(method: .m_convert__datefrom_fromTimeZoneto_toTimeZone(`date`, `fromTimeZone`, `toTimeZone`), performs: perform)
        }
        public static func start(of component: Parameter<Calendar.Component>, in date: Parameter<Date>, perform: @escaping (Calendar.Component, Date) -> Void) -> Perform {
            return Perform(method: .m_start__of_componentin_date(`component`, `date`), performs: perform)
        }
        public static func end(of component: Parameter<Calendar.Component>, in date: Parameter<Date>, perform: @escaping (Calendar.Component, Date) -> Void) -> Perform {
            return Perform(method: .m_end__of_componentin_date(`component`, `date`), performs: perform)
        }
        public static func string(for date: Parameter<Date>, inFormat format: Parameter<String>, perform: @escaping (Date, String) -> Void) -> Perform {
            return Perform(method: .m_string__for_dateinFormat_format(`date`, `format`), performs: perform)
        }
        public static func string(for date: Parameter<Date>, dateStyle: Parameter<DateFormatter.Style>, timeStyle: Parameter<DateFormatter.Style>, perform: @escaping (Date, DateFormatter.Style, DateFormatter.Style) -> Void) -> Perform {
            return Perform(method: .m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(`date`, `dateStyle`, `timeStyle`), performs: perform)
        }
        public static func date(_ date1: Parameter<Date>, occursOnSame component: Parameter<Calendar.Component>, as date2: Parameter<Date>, perform: @escaping (Date, Calendar.Component, Date) -> Void) -> Perform {
            return Perform(method: .m_date__date1occursOnSame_componentas_date2(`date1`, `component`, `date2`), performs: perform)
        }
        public static func compare(_ date1: Parameter<Date?>, _ date2: Parameter<Date?>, perform: @escaping (Date?, Date?) -> Void) -> Perform {
            return Perform(method: .m_compare__date1_date2(`date1`, `date2`), performs: perform)
        }
        public static func date<CollectionType>(_ date: Parameter<Date>, isOnOneOf daysOfWeek: Parameter<CollectionType>, perform: @escaping (Date, CollectionType) -> Void) -> Perform where CollectionType:Collection {
            return Perform(method: .m_date__dateisOnOneOf_daysOfWeek(`date`, `daysOfWeek`.wrapAsGeneric()), performs: perform)
        }
        public static func date(_ date: Parameter<Date>, isOnA dayOfWeek: Parameter<DayOfWeek>, perform: @escaping (Date, DayOfWeek) -> Void) -> Perform {
            return Perform(method: .m_date__dateisOnA_dayOfWeek(`date`, `dayOfWeek`), performs: perform)
        }
        public static func date(from dateStr: Parameter<String>, format: Parameter<String?>, perform: @escaping (String, String?) -> Void) -> Perform {
            return Perform(method: .m_date__from_dateStrformat_format(`dateStr`, `format`), performs: perform)
        }
        public static func dayOfWeek(forDate date: Parameter<Date>, perform: @escaping (Date) -> Void) -> Perform {
            return Perform(method: .m_dayOfWeek__forDate_date(`date`), performs: perform)
        }
        public static func distance(from date1: Parameter<Date>, to date2: Parameter<Date>, in unit: Parameter<Calendar.Component>, perform: @escaping (Date, Date, Calendar.Component) -> Void) -> Perform {
            return Perform(method: .m_distance__from_date1to_date2in_unit(`date1`, `date2`, `unit`), performs: perform)
        }
        public static func currentTimeZone(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_currentTimeZone, performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - CoachMarkFactory
open class CoachMarkFactoryMock: CoachMarkFactory, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_controller, .m_controller):
                return true 
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_controller: return 0
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - CoachMarksControllerProtocol
open class CoachMarksControllerProtocolMock: CoachMarksControllerProtocol, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_start__in_presentationContext(let lhsPresentationcontext), .m_start__in_presentationContext(let rhsPresentationcontext)):
                guard Parameter.compare(lhs: lhsPresentationcontext, rhs: rhsPresentationcontext, with: matcher) else { return false } 
                return true 
            case (.m_stop__immediately_immediately(let lhsImmediately), .m_stop__immediately_immediately(let rhsImmediately)):
                guard Parameter.compare(lhs: lhsImmediately, rhs: rhsImmediately, with: matcher) else { return false } 
                return true 
            case (.m_prepareForChange, .m_prepareForChange):
                return true 
            case (.m_restoreAfterChangeDidComplete, .m_restoreAfterChangeDidComplete):
                return true 
            case (.p_dataSource_get,.p_dataSource_get): return true
			case (.p_dataSource_set(let left),.p_dataSource_set(let right)): return Parameter<CoachMarksControllerDataSource?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_delegate_get,.p_delegate_get): return true
			case (.p_delegate_set(let left),.p_delegate_set(let right)): return Parameter<CoachMarksControllerDelegate?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_animationDelegate_get,.p_animationDelegate_get): return true
			case (.p_animationDelegate_set(let left),.p_animationDelegate_set(let right)): return Parameter<CoachMarksControllerAnimationDelegate?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_statusBarStyle_get,.p_statusBarStyle_get): return true
			case (.p_statusBarStyle_set(let left),.p_statusBarStyle_set(let right)): return Parameter<UIStatusBarStyle?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_rotationStyle_get,.p_rotationStyle_get): return true
			case (.p_rotationStyle_set(let left),.p_rotationStyle_set(let right)): return Parameter<RotationStyle>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_statusBarVisibility_get,.p_statusBarVisibility_get): return true
			case (.p_statusBarVisibility_set(let left),.p_statusBarVisibility_set(let right)): return Parameter<StatusBarVisibility>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_interfaceOrientations_get,.p_interfaceOrientations_get): return true
			case (.p_interfaceOrientations_set(let left),.p_interfaceOrientations_set(let right)): return Parameter<InterfaceOrientations>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_skipView_get,.p_skipView_get): return true
			case (.p_skipView_set(let left),.p_skipView_set(let right)): return Parameter<CoachMarkSkipView?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - CodableStorage
open class CodableStorageMock: CodableStorage, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func store<T: Encodable>(_ object: T, to directory: StorageDirectory, as fileName: String) throws {
        addInvocation(.m_store__objectto_directoryas_fileName(Parameter<T>.value(`object`).wrapAsGeneric(), Parameter<StorageDirectory>.value(`directory`), Parameter<String>.value(`fileName`)))
		let perform = methodPerformValue(.m_store__objectto_directoryas_fileName(Parameter<T>.value(`object`).wrapAsGeneric(), Parameter<StorageDirectory>.value(`directory`), Parameter<String>.value(`fileName`))) as? (T, StorageDirectory, String) -> Void
		perform?(`object`, `directory`, `fileName`)
		do {
		    _ = try methodReturnValue(.m_store__objectto_directoryas_fileName(Parameter<T>.value(`object`).wrapAsGeneric(), Parameter<StorageDirectory>.value(`directory`), Parameter<String>.value(`fileName`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func retrieve<T: Decodable>(_ fileName: String, from directory: StorageDirectory, as type: T.Type) throws -> T {
        addInvocation(.m_retrieve__fileNamefrom_directoryas_type(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`), Parameter<T.Type>.value(`type`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_retrieve__fileNamefrom_directoryas_type(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`), Parameter<T.Type>.value(`type`).wrapAsGeneric())) as? (String, StorageDirectory, T.Type) -> Void
		perform?(`fileName`, `directory`, `type`)
		var __value: T
		do {
		    __value = try methodReturnValue(.m_retrieve__fileNamefrom_directoryas_type(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`), Parameter<T.Type>.value(`type`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for retrieve<T: Decodable>(_ fileName: String, from directory: StorageDirectory, as type: T.Type). Use given")
			Failure("Stub return value not specified for retrieve<T: Decodable>(_ fileName: String, from directory: StorageDirectory, as type: T.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func clear(_ directory: StorageDirectory) throws {
        addInvocation(.m_clear__directory(Parameter<StorageDirectory>.value(`directory`)))
		let perform = methodPerformValue(.m_clear__directory(Parameter<StorageDirectory>.value(`directory`))) as? (StorageDirectory) -> Void
		perform?(`directory`)
		do {
		    _ = try methodReturnValue(.m_clear__directory(Parameter<StorageDirectory>.value(`directory`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func remove(_ fileName: String, from directory: StorageDirectory) throws {
        addInvocation(.m_remove__fileNamefrom_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`)))
		let perform = methodPerformValue(.m_remove__fileNamefrom_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`))) as? (String, StorageDirectory) -> Void
		perform?(`fileName`, `directory`)
		do {
		    _ = try methodReturnValue(.m_remove__fileNamefrom_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func fileExists(_ fileName: String, in directory: StorageDirectory) -> Bool {
        addInvocation(.m_fileExists__fileNamein_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`)))
		let perform = methodPerformValue(.m_fileExists__fileNamein_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`))) as? (String, StorageDirectory) -> Void
		perform?(`fileName`, `directory`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_fileExists__fileNamein_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for fileExists(_ fileName: String, in directory: StorageDirectory). Use given")
			Failure("Stub return value not specified for fileExists(_ fileName: String, in directory: StorageDirectory). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_store__objectto_directoryas_fileName(Parameter<GenericAttribute>, Parameter<StorageDirectory>, Parameter<String>)
        case m_retrieve__fileNamefrom_directoryas_type(Parameter<String>, Parameter<StorageDirectory>, Parameter<GenericAttribute>)
        case m_clear__directory(Parameter<StorageDirectory>)
        case m_remove__fileNamefrom_directory(Parameter<String>, Parameter<StorageDirectory>)
        case m_fileExists__fileNamein_directory(Parameter<String>, Parameter<StorageDirectory>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_store__objectto_directoryas_fileName(let lhsObject, let lhsDirectory, let lhsFilename), .m_store__objectto_directoryas_fileName(let rhsObject, let rhsDirectory, let rhsFilename)):
                guard Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher) else { return false } 
                return true 
            case (.m_retrieve__fileNamefrom_directoryas_type(let lhsFilename, let lhsDirectory, let lhsType), .m_retrieve__fileNamefrom_directoryas_type(let rhsFilename, let rhsDirectory, let rhsType)):
                guard Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher) else { return false } 
                return true 
            case (.m_clear__directory(let lhsDirectory), .m_clear__directory(let rhsDirectory)):
                guard Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher) else { return false } 
                return true 
            case (.m_remove__fileNamefrom_directory(let lhsFilename, let lhsDirectory), .m_remove__fileNamefrom_directory(let rhsFilename, let rhsDirectory)):
                guard Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher) else { return false } 
                return true 
            case (.m_fileExists__fileNamein_directory(let lhsFilename, let lhsDirectory), .m_fileExists__fileNamein_directory(let rhsFilename, let rhsDirectory)):
                guard Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_store__objectto_directoryas_fileName(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_retrieve__fileNamefrom_directoryas_type(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_clear__directory(p0): return p0.intValue
            case let .m_remove__fileNamefrom_directory(p0, p1): return p0.intValue + p1.intValue
            case let .m_fileExists__fileNamein_directory(p0, p1): return p0.intValue + p1.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func retrieve<T: Decodable>(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, as type: Parameter<T.Type>, willReturn: T...) -> MethodStub {
            return Given(method: .m_retrieve__fileNamefrom_directoryas_type(`fileName`, `directory`, `type`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func fileExists(_ fileName: Parameter<String>, in directory: Parameter<StorageDirectory>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_fileExists__fileNamein_directory(`fileName`, `directory`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func fileExists(_ fileName: Parameter<String>, in directory: Parameter<StorageDirectory>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_fileExists__fileNamein_directory(`fileName`, `directory`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func store<T: Encodable>(_ object: Parameter<T>, to directory: Parameter<StorageDirectory>, as fileName: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_store__objectto_directoryas_fileName(`object`.wrapAsGeneric(), `directory`, `fileName`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func store<T: Encodable>(_ object: Parameter<T>, to directory: Parameter<StorageDirectory>, as fileName: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_store__objectto_directoryas_fileName(`object`.wrapAsGeneric(), `directory`, `fileName`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func retrieve<T: Decodable>(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, as type: Parameter<T.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_retrieve__fileNamefrom_directoryas_type(`fileName`, `directory`, `type`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func retrieve<T: Decodable>(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, as type: Parameter<T.Type>, willProduce: (StubberThrows<T>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_retrieve__fileNamefrom_directoryas_type(`fileName`, `directory`, `type`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (T).self)
			willProduce(stubber)
			return given
        }
        public static func clear(_ directory: Parameter<StorageDirectory>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_clear__directory(`directory`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func clear(_ directory: Parameter<StorageDirectory>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_clear__directory(`directory`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func remove(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_remove__fileNamefrom_directory(`fileName`, `directory`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func remove(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_remove__fileNamefrom_directory(`fileName`, `directory`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func store<T>(_ object: Parameter<T>, to directory: Parameter<StorageDirectory>, as fileName: Parameter<String>) -> Verify where T:Encodable { return Verify(method: .m_store__objectto_directoryas_fileName(`object`.wrapAsGeneric(), `directory`, `fileName`))}
        public static func retrieve<T>(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, as type: Parameter<T.Type>) -> Verify where T:Decodable { return Verify(method: .m_retrieve__fileNamefrom_directoryas_type(`fileName`, `directory`, `type`.wrapAsGeneric()))}
        public static func clear(_ directory: Parameter<StorageDirectory>) -> Verify { return Verify(method: .m_clear__directory(`directory`))}
        public static func remove(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>) -> Verify { return Verify(method: .m_remove__fileNamefrom_directory(`fileName`, `directory`))}
        public static func fileExists(_ fileName: Parameter<String>, in directory: Parameter<StorageDirectory>) -> Verify { return Verify(method: .m_fileExists__fileNamein_directory(`fileName`, `directory`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func store<T>(_ object: Parameter<T>, to directory: Parameter<StorageDirectory>, as fileName: Parameter<String>, perform: @escaping (T, StorageDirectory, String) -> Void) -> Perform where T:Encodable {
            return Perform(method: .m_store__objectto_directoryas_fileName(`object`.wrapAsGeneric(), `directory`, `fileName`), performs: perform)
        }
        public static func retrieve<T>(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, as type: Parameter<T.Type>, perform: @escaping (String, StorageDirectory, T.Type) -> Void) -> Perform where T:Decodable {
            return Perform(method: .m_retrieve__fileNamefrom_directoryas_type(`fileName`, `directory`, `type`.wrapAsGeneric()), performs: perform)
        }
        public static func clear(_ directory: Parameter<StorageDirectory>, perform: @escaping (StorageDirectory) -> Void) -> Perform {
            return Perform(method: .m_clear__directory(`directory`), performs: perform)
        }
        public static func remove(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, perform: @escaping (String, StorageDirectory) -> Void) -> Perform {
            return Perform(method: .m_remove__fileNamefrom_directory(`fileName`, `directory`), performs: perform)
        }
        public static func fileExists(_ fileName: Parameter<String>, in directory: Parameter<StorageDirectory>, perform: @escaping (String, StorageDirectory) -> Void) -> Perform {
            return Perform(method: .m_fileExists__fileNamein_directory(`fileName`, `directory`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - Database
open class DatabaseMock: Database, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func transaction() -> Transaction {
        addInvocation(.m_transaction)
		let perform = methodPerformValue(.m_transaction) as? () -> Void
		perform?()
		var __value: Transaction
		do {
		    __value = try methodReturnValue(.m_transaction).casted()
		} catch {
			onFatalFailure("Stub return value not specified for transaction(). Use given")
			Failure("Stub return value not specified for transaction(). Use given")
		}
		return __value
    }

    open func fetchedResultsController<Type: NSManagedObject>(type: Type.Type, sortDescriptors: [NSSortDescriptor], cacheName: String?) -> NSFetchedResultsController<Type> {
        addInvocation(.m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(Parameter<Type.Type>.value(`type`).wrapAsGeneric(), Parameter<[NSSortDescriptor]>.value(`sortDescriptors`), Parameter<String?>.value(`cacheName`)))
		let perform = methodPerformValue(.m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(Parameter<Type.Type>.value(`type`).wrapAsGeneric(), Parameter<[NSSortDescriptor]>.value(`sortDescriptors`), Parameter<String?>.value(`cacheName`))) as? (Type.Type, [NSSortDescriptor], String?) -> Void
		perform?(`type`, `sortDescriptors`, `cacheName`)
		var __value: NSFetchedResultsController<Type>
		do {
		    __value = try methodReturnValue(.m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(Parameter<Type.Type>.value(`type`).wrapAsGeneric(), Parameter<[NSSortDescriptor]>.value(`sortDescriptors`), Parameter<String?>.value(`cacheName`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for fetchedResultsController<Type: NSManagedObject>(type: Type.Type, sortDescriptors: [NSSortDescriptor], cacheName: String?). Use given")
			Failure("Stub return value not specified for fetchedResultsController<Type: NSManagedObject>(type: Type.Type, sortDescriptors: [NSSortDescriptor], cacheName: String?). Use given")
		}
		return __value
    }

    open func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type] {
        addInvocation(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())) as? (NSFetchRequest<Type>) -> Void
		perform?(`fetchRequest`)
		var __value: [Type]
		do {
		    __value = try methodReturnValue(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>). Use given")
			Failure("Stub return value not specified for query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func pull<Type: NSManagedObject>(savedObject: Type) throws -> Type {
        addInvocation(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric())) as? (Type) -> Void
		perform?(`savedObject`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type). Use given")
			Failure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func pull<Type: NSManagedObject>(savedObject: Type, fromSameContextAs otherObject: NSManagedObject) throws -> Type {
        addInvocation(.m_pull__savedObject_savedObjectfromSameContextAs_otherObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObject>.value(`otherObject`)))
		let perform = methodPerformValue(.m_pull__savedObject_savedObjectfromSameContextAs_otherObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObject>.value(`otherObject`))) as? (Type, NSManagedObject) -> Void
		perform?(`savedObject`, `otherObject`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_pull__savedObject_savedObjectfromSameContextAs_otherObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObject>.value(`otherObject`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type, fromSameContextAs otherObject: NSManagedObject). Use given")
			Failure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type, fromSameContextAs otherObject: NSManagedObject). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func pull<Type: NSManagedObject>(savedObject: Type, fromContext context: NSManagedObjectContext) throws -> Type {
        addInvocation(.m_pull__savedObject_savedObjectfromContext_context(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObjectContext>.value(`context`)))
		let perform = methodPerformValue(.m_pull__savedObject_savedObjectfromContext_context(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObjectContext>.value(`context`))) as? (Type, NSManagedObjectContext) -> Void
		perform?(`savedObject`, `context`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_pull__savedObject_savedObjectfromContext_context(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObjectContext>.value(`context`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type, fromContext context: NSManagedObjectContext). Use given")
			Failure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type, fromContext context: NSManagedObjectContext). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func deleteEverything() throws {
        addInvocation(.m_deleteEverything)
		let perform = methodPerformValue(.m_deleteEverything) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_deleteEverything).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }


    fileprivate enum MethodType {
        case m_transaction
        case m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(Parameter<GenericAttribute>, Parameter<[NSSortDescriptor]>, Parameter<String?>)
        case m_query__fetchRequest(Parameter<GenericAttribute>)
        case m_pull__savedObject_savedObject(Parameter<GenericAttribute>)
        case m_pull__savedObject_savedObjectfromSameContextAs_otherObject(Parameter<GenericAttribute>, Parameter<NSManagedObject>)
        case m_pull__savedObject_savedObjectfromContext_context(Parameter<GenericAttribute>, Parameter<NSManagedObjectContext>)
        case m_deleteEverything

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_transaction, .m_transaction):
                return true 
            case (.m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(let lhsType, let lhsSortdescriptors, let lhsCachename), .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(let rhsType, let rhsSortdescriptors, let rhsCachename)):
                guard Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSortdescriptors, rhs: rhsSortdescriptors, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsCachename, rhs: rhsCachename, with: matcher) else { return false } 
                return true 
            case (.m_query__fetchRequest(let lhsFetchrequest), .m_query__fetchRequest(let rhsFetchrequest)):
                guard Parameter.compare(lhs: lhsFetchrequest, rhs: rhsFetchrequest, with: matcher) else { return false } 
                return true 
            case (.m_pull__savedObject_savedObject(let lhsSavedobject), .m_pull__savedObject_savedObject(let rhsSavedobject)):
                guard Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher) else { return false } 
                return true 
            case (.m_pull__savedObject_savedObjectfromSameContextAs_otherObject(let lhsSavedobject, let lhsOtherobject), .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(let rhsSavedobject, let rhsOtherobject)):
                guard Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsOtherobject, rhs: rhsOtherobject, with: matcher) else { return false } 
                return true 
            case (.m_pull__savedObject_savedObjectfromContext_context(let lhsSavedobject, let lhsContext), .m_pull__savedObject_savedObjectfromContext_context(let rhsSavedobject, let rhsContext)):
                guard Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsContext, rhs: rhsContext, with: matcher) else { return false } 
                return true 
            case (.m_deleteEverything, .m_deleteEverything):
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_transaction: return 0
            case let .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_query__fetchRequest(p0): return p0.intValue
            case let .m_pull__savedObject_savedObject(p0): return p0.intValue
            case let .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(p0, p1): return p0.intValue + p1.intValue
            case let .m_pull__savedObject_savedObjectfromContext_context(p0, p1): return p0.intValue + p1.intValue
            case .m_deleteEverything: return 0
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func transaction(willReturn: Transaction...) -> MethodStub {
            return Given(method: .m_transaction, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func fetchedResultsController<Type: NSManagedObject>(type: Parameter<Type.Type>, sortDescriptors: Parameter<[NSSortDescriptor]>, cacheName: Parameter<String?>, willReturn: NSFetchedResultsController<Type>...) -> MethodStub {
            return Given(method: .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(`type`.wrapAsGeneric(), `sortDescriptors`, `cacheName`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func query<Type: NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willReturn: [Type]...) -> MethodStub {
            return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, fromSameContextAs otherObject: Parameter<NSManagedObject>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(`savedObject`.wrapAsGeneric(), `otherObject`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, fromContext context: Parameter<NSManagedObjectContext>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObjectfromContext_context(`savedObject`.wrapAsGeneric(), `context`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func transaction(willProduce: (Stubber<Transaction>) -> Void) -> MethodStub {
            let willReturn: [Transaction] = []
			let given: Given = { return Given(method: .m_transaction, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Transaction).self)
			willProduce(stubber)
			return given
        }
        public static func fetchedResultsController<Type: NSManagedObject>(type: Parameter<Type.Type>, sortDescriptors: Parameter<[NSSortDescriptor]>, cacheName: Parameter<String?>, willProduce: (Stubber<NSFetchedResultsController<Type>>) -> Void) -> MethodStub {
            let willReturn: [NSFetchedResultsController<Type>] = []
			let given: Given = { return Given(method: .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(`type`.wrapAsGeneric(), `sortDescriptors`, `cacheName`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (NSFetchedResultsController<Type>).self)
			willProduce(stubber)
			return given
        }
        public static func query<Type: NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func query<Type: NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willProduce: (StubberThrows<[Type]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Type]).self)
			willProduce(stubber)
			return given
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, fromSameContextAs otherObject: Parameter<NSManagedObject>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(`savedObject`.wrapAsGeneric(), `otherObject`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, fromSameContextAs otherObject: Parameter<NSManagedObject>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(`savedObject`.wrapAsGeneric(), `otherObject`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, fromContext context: Parameter<NSManagedObjectContext>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObjectfromContext_context(`savedObject`.wrapAsGeneric(), `context`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, fromContext context: Parameter<NSManagedObjectContext>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_pull__savedObject_savedObjectfromContext_context(`savedObject`.wrapAsGeneric(), `context`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func deleteEverything(willThrow: Error...) -> MethodStub {
            return Given(method: .m_deleteEverything, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func deleteEverything(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_deleteEverything, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func transaction() -> Verify { return Verify(method: .m_transaction)}
        public static func fetchedResultsController<Type>(type: Parameter<Type.Type>, sortDescriptors: Parameter<[NSSortDescriptor]>, cacheName: Parameter<String?>) -> Verify where Type:NSManagedObject { return Verify(method: .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(`type`.wrapAsGeneric(), `sortDescriptors`, `cacheName`))}
        public static func query<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>) -> Verify where Type:NSManagedObject { return Verify(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()))}
        public static func pull<Type>(savedObject: Parameter<Type>) -> Verify where Type:NSManagedObject { return Verify(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()))}
        public static func pull<Type>(savedObject: Parameter<Type>, fromSameContextAs otherObject: Parameter<NSManagedObject>) -> Verify where Type:NSManagedObject { return Verify(method: .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(`savedObject`.wrapAsGeneric(), `otherObject`))}
        public static func pull<Type>(savedObject: Parameter<Type>, fromContext context: Parameter<NSManagedObjectContext>) -> Verify where Type:NSManagedObject { return Verify(method: .m_pull__savedObject_savedObjectfromContext_context(`savedObject`.wrapAsGeneric(), `context`))}
        public static func deleteEverything() -> Verify { return Verify(method: .m_deleteEverything)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func transaction(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_transaction, performs: perform)
        }
        public static func fetchedResultsController<Type>(type: Parameter<Type.Type>, sortDescriptors: Parameter<[NSSortDescriptor]>, cacheName: Parameter<String?>, perform: @escaping (Type.Type, [NSSortDescriptor], String?) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(`type`.wrapAsGeneric(), `sortDescriptors`, `cacheName`), performs: perform)
        }
        public static func query<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, perform: @escaping (NSFetchRequest<Type>) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), performs: perform)
        }
        public static func pull<Type>(savedObject: Parameter<Type>, perform: @escaping (Type) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), performs: perform)
        }
        public static func pull<Type>(savedObject: Parameter<Type>, fromSameContextAs otherObject: Parameter<NSManagedObject>, perform: @escaping (Type, NSManagedObject) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(`savedObject`.wrapAsGeneric(), `otherObject`), performs: perform)
        }
        public static func pull<Type>(savedObject: Parameter<Type>, fromContext context: Parameter<NSManagedObjectContext>, perform: @escaping (Type, NSManagedObjectContext) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_pull__savedObject_savedObjectfromContext_context(`savedObject`.wrapAsGeneric(), `context`), performs: perform)
        }
        public static func deleteEverything(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_deleteEverything, performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - EasyPillMedicationDoseImporter
open class EasyPillMedicationDoseImporterMock: EasyPillMedicationDoseImporter, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "EasyPillMedicationDoseImporterMock - stub value for dataTypePluralName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_dataTypePluralName = newValue }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "EasyPillMedicationDoseImporterMock - stub value for sourceName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_sourceName = newValue }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "EasyPillMedicationDoseImporterMock - stub value for customImportMessage was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_customImportMessage = newValue }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "EasyPillMedicationDoseImporterMock - stub value for lastImport was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_lastImport = newValue }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "EasyPillMedicationDoseImporterMock - stub value for isPaused was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isPaused = newValue }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "EasyPillMedicationDoseImporterMock - stub value for isCancelled was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isCancelled = newValue }
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
                guard Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher) else { return false } 
                return true 
            case (.m_resetLastImportDate, .m_resetLastImportDate):
                return true 
            case (.m_percentComplete, .m_percentComplete):
                return true 
            case (.m_cancel, .m_cancel):
                return true 
            case (.m_pause, .m_pause):
                return true 
            case (.m_resume, .m_resume):
                return true 
            case (.m_equalTo__other(let lhsOther), .m_equalTo__other(let rhsOther)):
                guard Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher) else { return false } 
                return true 
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return true
            case (.p_sourceName_get,.p_sourceName_get): return true
            case (.p_customImportMessage_get,.p_customImportMessage_get): return true
            case (.p_lastImport_get,.p_lastImport_get): return true
            case (.p_isPaused_get,.p_isPaused_get): return true
            case (.p_isCancelled_get,.p_isCancelled_get): return true
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return true
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - EasyPillMedicationImporter
open class EasyPillMedicationImporterMock: EasyPillMedicationImporter, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "EasyPillMedicationImporterMock - stub value for dataTypePluralName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_dataTypePluralName = newValue }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "EasyPillMedicationImporterMock - stub value for sourceName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_sourceName = newValue }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "EasyPillMedicationImporterMock - stub value for customImportMessage was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_customImportMessage = newValue }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "EasyPillMedicationImporterMock - stub value for lastImport was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_lastImport = newValue }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "EasyPillMedicationImporterMock - stub value for isPaused was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isPaused = newValue }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "EasyPillMedicationImporterMock - stub value for isCancelled was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isCancelled = newValue }
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
                guard Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher) else { return false } 
                return true 
            case (.m_resetLastImportDate, .m_resetLastImportDate):
                return true 
            case (.m_percentComplete, .m_percentComplete):
                return true 
            case (.m_cancel, .m_cancel):
                return true 
            case (.m_pause, .m_pause):
                return true 
            case (.m_resume, .m_resume):
                return true 
            case (.m_equalTo__other(let lhsOther), .m_equalTo__other(let rhsOther)):
                guard Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher) else { return false } 
                return true 
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return true
            case (.p_sourceName_get,.p_sourceName_get): return true
            case (.p_customImportMessage_get,.p_customImportMessage_get): return true
            case (.p_lastImport_get,.p_lastImport_get): return true
            case (.p_isPaused_get,.p_isPaused_get): return true
            case (.p_isCancelled_get,.p_isCancelled_get): return true
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return true
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - Exporter
open class ExporterMock: Exporter, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "ExporterMock - stub value for dataTypePluralName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_dataTypePluralName = newValue }
	}
	private var __p_dataTypePluralName: (String)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "ExporterMock - stub value for isPaused was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isPaused = newValue }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "ExporterMock - stub value for isCancelled was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isCancelled = newValue }
	}
	private var __p_isCancelled: (Bool)?

    public var url: URL {
		get {	invocations.append(.p_url_get); return __p_url ?? givenGetterValue(.p_url_get, "ExporterMock - stub value for url was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_url = newValue }
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_exportData, .m_exportData):
                return true 
            case (.m_percentComplete, .m_percentComplete):
                return true 
            case (.m_cancel, .m_cancel):
                return true 
            case (.m_pause, .m_pause):
                return true 
            case (.m_resume, .m_resume):
                return true 
            case (.m_equalTo__other(let lhsOther), .m_equalTo__other(let rhsOther)):
                guard Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher) else { return false } 
                return true 
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return true
            case (.p_isPaused_get,.p_isPaused_get): return true
            case (.p_isCancelled_get,.p_isCancelled_get): return true
            case (.p_url_get,.p_url_get): return true
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - ExporterFactory
open class ExporterFactoryMock: ExporterFactory, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func activityExporter() throws -> ActivityExporter {
        addInvocation(.m_activityExporter)
		let perform = methodPerformValue(.m_activityExporter) as? () -> Void
		perform?()
		var __value: ActivityExporter
		do {
		    __value = try methodReturnValue(.m_activityExporter).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for activityExporter(). Use given")
			Failure("Stub return value not specified for activityExporter(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func medicationExporter() throws -> MedicationExporter {
        addInvocation(.m_medicationExporter)
		let perform = methodPerformValue(.m_medicationExporter) as? () -> Void
		perform?()
		var __value: MedicationExporter
		do {
		    __value = try methodReturnValue(.m_medicationExporter).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for medicationExporter(). Use given")
			Failure("Stub return value not specified for medicationExporter(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func moodExporter() throws -> MoodExporter {
        addInvocation(.m_moodExporter)
		let perform = methodPerformValue(.m_moodExporter) as? () -> Void
		perform?()
		var __value: MoodExporter
		do {
		    __value = try methodReturnValue(.m_moodExporter).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for moodExporter(). Use given")
			Failure("Stub return value not specified for moodExporter(). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_activityExporter
        case m_medicationExporter
        case m_moodExporter

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_activityExporter, .m_activityExporter):
                return true 
            case (.m_medicationExporter, .m_medicationExporter):
                return true 
            case (.m_moodExporter, .m_moodExporter):
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_activityExporter: return 0
            case .m_medicationExporter: return 0
            case .m_moodExporter: return 0
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func activityExporter(willReturn: ActivityExporter...) -> MethodStub {
            return Given(method: .m_activityExporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func medicationExporter(willReturn: MedicationExporter...) -> MethodStub {
            return Given(method: .m_medicationExporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func moodExporter(willReturn: MoodExporter...) -> MethodStub {
            return Given(method: .m_moodExporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func activityExporter(willThrow: Error...) -> MethodStub {
            return Given(method: .m_activityExporter, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func activityExporter(willProduce: (StubberThrows<ActivityExporter>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_activityExporter, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ActivityExporter).self)
			willProduce(stubber)
			return given
        }
        public static func medicationExporter(willThrow: Error...) -> MethodStub {
            return Given(method: .m_medicationExporter, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func medicationExporter(willProduce: (StubberThrows<MedicationExporter>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_medicationExporter, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (MedicationExporter).self)
			willProduce(stubber)
			return given
        }
        public static func moodExporter(willThrow: Error...) -> MethodStub {
            return Given(method: .m_moodExporter, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func moodExporter(willProduce: (StubberThrows<MoodExporter>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_moodExporter, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (MoodExporter).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func activityExporter() -> Verify { return Verify(method: .m_activityExporter)}
        public static func medicationExporter() -> Verify { return Verify(method: .m_medicationExporter)}
        public static func moodExporter() -> Verify { return Verify(method: .m_moodExporter)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func activityExporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_activityExporter, performs: perform)
        }
        public static func medicationExporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_medicationExporter, performs: perform)
        }
        public static func moodExporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_moodExporter, performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - ExtraInformation
open class ExtraInformationMock: ExtraInformation, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var name: String {
		get {	invocations.append(.p_name_get); return __p_name ?? givenGetterValue(.p_name_get, "ExtraInformationMock - stub value for name was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_name = newValue }
	}
	private var __p_name: (String)?

    public var startDate: Date? {
		get {	invocations.append(.p_startDate_get); return __p_startDate ?? optionalGivenGetterValue(.p_startDate_get, "ExtraInformationMock - stub value for startDate was not defined") }
		set {	invocations.append(.p_startDate_set(.value(newValue))); __p_startDate = newValue }
	}
	private var __p_startDate: (Date)?

    public var endDate: Date? {
		get {	invocations.append(.p_endDate_get); return __p_endDate ?? optionalGivenGetterValue(.p_endDate_get, "ExtraInformationMock - stub value for endDate was not defined") }
		set {	invocations.append(.p_endDate_set(.value(newValue))); __p_endDate = newValue }
	}
	private var __p_endDate: (Date)?

    public var attribute: Attribute {
		get {	invocations.append(.p_attribute_get); return __p_attribute ?? givenGetterValue(.p_attribute_get, "ExtraInformationMock - stub value for attribute was not defined") }
		set {	invocations.append(.p_attribute_set(.value(newValue))); __p_attribute = newValue }
	}
	private var __p_attribute: (Attribute)?

    public var description: String {
		get {	invocations.append(.p_description_get); return __p_description ?? givenGetterValue(.p_description_get, "ExtraInformationMock - stub value for description was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_description = newValue }
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

    open func equalTo(_ other: ExtraInformation) -> Bool {
        addInvocation(.m_equalTo__other(Parameter<ExtraInformation>.value(`other`)))
		let perform = methodPerformValue(.m_equalTo__other(Parameter<ExtraInformation>.value(`other`))) as? (ExtraInformation) -> Void
		perform?(`other`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__other(Parameter<ExtraInformation>.value(`other`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ other: ExtraInformation). Use given")
			Failure("Stub return value not specified for equalTo(_ other: ExtraInformation). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_compute__forSamples_samples(Parameter<[Sample]>)
        case m_computeGraphable__forSamples_samples(Parameter<[Sample]>)
        case m_equalTo__other(Parameter<ExtraInformation>)
        case p_name_get
        case p_startDate_get
		case p_startDate_set(Parameter<Date?>)
        case p_endDate_get
		case p_endDate_set(Parameter<Date?>)
        case p_attribute_get
		case p_attribute_set(Parameter<Attribute>)
        case p_description_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_compute__forSamples_samples(let lhsSamples), .m_compute__forSamples_samples(let rhsSamples)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                return true 
            case (.m_computeGraphable__forSamples_samples(let lhsSamples), .m_computeGraphable__forSamples_samples(let rhsSamples)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                return true 
            case (.m_equalTo__other(let lhsOther), .m_equalTo__other(let rhsOther)):
                guard Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher) else { return false } 
                return true 
            case (.p_name_get,.p_name_get): return true
            case (.p_startDate_get,.p_startDate_get): return true
			case (.p_startDate_set(let left),.p_startDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_endDate_get,.p_endDate_get): return true
			case (.p_endDate_set(let left),.p_endDate_set(let right)): return Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_attribute_get,.p_attribute_get): return true
			case (.p_attribute_set(let left),.p_attribute_set(let right)): return Parameter<Attribute>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_description_get,.p_description_get): return true
            default: return false
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
        public static func equalTo(_ other: Parameter<ExtraInformation>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__other(`other`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ other: Parameter<ExtraInformation>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
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
        public static func equalTo(_ other: Parameter<ExtraInformation>) -> Verify { return Verify(method: .m_equalTo__other(`other`))}
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
        public static func equalTo(_ other: Parameter<ExtraInformation>, perform: @escaping (ExtraInformation) -> Void) -> Perform {
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - GroupDefinition
open class GroupDefinitionMock: GroupDefinition, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var name: String {
		get {	invocations.append(.p_name_get); return __p_name ?? givenGetterValue(.p_name_get, "GroupDefinitionMock - stub value for name was not defined") }
		set {	invocations.append(.p_name_set(.value(newValue))); __p_name = newValue }
	}
	private var __p_name: (String)?

    public var description: String {
		get {	invocations.append(.p_description_get); return __p_description ?? givenGetterValue(.p_description_get, "GroupDefinitionMock - stub value for description was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_description = newValue }
	}
	private var __p_description: (String)?

    public var sampleType: Sample.Type {
		get {	invocations.append(.p_sampleType_get); return __p_sampleType ?? givenGetterValue(.p_sampleType_get, "GroupDefinitionMock - stub value for sampleType was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_sampleType = newValue }
	}
	private var __p_sampleType: (Sample.Type)?

    public var attributeRestrictionExpression: BooleanExpression? {
		get {	invocations.append(.p_attributeRestrictionExpression_get); return __p_attributeRestrictionExpression ?? optionalGivenGetterValue(.p_attributeRestrictionExpression_get, "GroupDefinitionMock - stub value for attributeRestrictionExpression was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_attributeRestrictionExpression = newValue }
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_sampleBelongsInGroup__sample(let lhsSample), .m_sampleBelongsInGroup__sample(let rhsSample)):
                guard Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher) else { return false } 
                return true 
            case (.m_isValid, .m_isValid):
                return true 
            case (.m_copy, .m_copy):
                return true 
            case (.m_equalTo__other(let lhsOther), .m_equalTo__other(let rhsOther)):
                guard Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher) else { return false } 
                return true 
            case (.p_name_get,.p_name_get): return true
			case (.p_name_set(let left),.p_name_set(let right)): return Parameter<String>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_description_get,.p_description_get): return true
            case (.p_sampleType_get,.p_sampleType_get): return true
            case (.p_attributeRestrictionExpression_get,.p_attributeRestrictionExpression_get): return true
            case (.p_expressionParts_get,.p_expressionParts_get): return true
			case (.p_expressionParts_set(let left),.p_expressionParts_set(let right)): return Parameter<[BooleanExpressionPart]>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - HealthKitUtil
open class HealthKitUtilMock: HealthKitUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {
        addInvocation(.m_setTimeZoneIfApplicable__for_datefrom_sample(Parameter<Date>.value(`date`), Parameter<HKSample>.value(`sample`)))
		let perform = methodPerformValue(.m_setTimeZoneIfApplicable__for_datefrom_sample(Parameter<Date>.value(`date`), Parameter<HKSample>.value(`sample`))) as? (inout Date, HKSample) -> Void
		perform?(&`date`, `sample`)
    }

    open func calculate(_ calculation: HKStatisticsOptions, _ type: HealthKitQuantitySample.Type, from startDate: Date, to endDate: Date, callback: @escaping (Double?, Error?) -> Void) {
        addInvocation(.m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(Parameter<HKStatisticsOptions>.value(`calculation`), Parameter<HealthKitQuantitySample.Type>.value(`type`), Parameter<Date>.value(`startDate`), Parameter<Date>.value(`endDate`), Parameter<(Double?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(Parameter<HKStatisticsOptions>.value(`calculation`), Parameter<HealthKitQuantitySample.Type>.value(`type`), Parameter<Date>.value(`startDate`), Parameter<Date>.value(`endDate`), Parameter<(Double?, Error?) -> Void>.value(`callback`))) as? (HKStatisticsOptions, HealthKitQuantitySample.Type, Date, Date, @escaping (Double?, Error?) -> Void) -> Void
		perform?(`calculation`, `type`, `startDate`, `endDate`, `callback`)
    }

    open func getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?, predicate: NSPredicate?, callback: @escaping (Array<HKSample>?, Error?) -> Void) -> (() -> Void) {
        addInvocation(.m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(Parameter<HealthKitSample.Type>.value(`type`), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`), Parameter<NSPredicate?>.value(`predicate`), Parameter<(Array<HKSample>?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(Parameter<HealthKitSample.Type>.value(`type`), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`), Parameter<NSPredicate?>.value(`predicate`), Parameter<(Array<HKSample>?, Error?) -> Void>.value(`callback`))) as? (HealthKitSample.Type, Date?, Date?, NSPredicate?, @escaping (Array<HKSample>?, Error?) -> Void) -> Void
		perform?(`type`, `startDate`, `endDate`, `predicate`, `callback`)
		var __value: () -> Void
		do {
		    __value = try methodReturnValue(.m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(Parameter<HealthKitSample.Type>.value(`type`), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`), Parameter<NSPredicate?>.value(`predicate`), Parameter<(Array<HKSample>?, Error?) -> Void>.value(`callback`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?, predicate: NSPredicate?, callback: @escaping (Array<HKSample>?, Error?) -> Void). Use given")
			Failure("Stub return value not specified for getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?, predicate: NSPredicate?, callback: @escaping (Array<HKSample>?, Error?) -> Void). Use given")
		}
		return __value
    }

    open func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? {
        addInvocation(.m_preferredUnitFor__typeId(Parameter<HKQuantityTypeIdentifier>.value(`typeId`)))
		let perform = methodPerformValue(.m_preferredUnitFor__typeId(Parameter<HKQuantityTypeIdentifier>.value(`typeId`))) as? (HKQuantityTypeIdentifier) -> Void
		perform?(`typeId`)
		var __value: HKUnit? = nil
		do {
		    __value = try methodReturnValue(.m_preferredUnitFor__typeId(Parameter<HKQuantityTypeIdentifier>.value(`typeId`))).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func getAuthorization(callback: @escaping (Error?) -> Void) {
        addInvocation(.m_getAuthorization__callback_callback(Parameter<(Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_getAuthorization__callback_callback(Parameter<(Error?) -> Void>.value(`callback`))) as? (@escaping (Error?) -> Void) -> Void
		perform?(`callback`)
    }


    fileprivate enum MethodType {
        case m_setTimeZoneIfApplicable__for_datefrom_sample(Parameter<Date>, Parameter<HKSample>)
        case m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(Parameter<HKStatisticsOptions>, Parameter<HealthKitQuantitySample.Type>, Parameter<Date>, Parameter<Date>, Parameter<(Double?, Error?) -> Void>)
        case m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(Parameter<HealthKitSample.Type>, Parameter<Date?>, Parameter<Date?>, Parameter<NSPredicate?>, Parameter<(Array<HKSample>?, Error?) -> Void>)
        case m_preferredUnitFor__typeId(Parameter<HKQuantityTypeIdentifier>)
        case m_getAuthorization__callback_callback(Parameter<(Error?) -> Void>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_setTimeZoneIfApplicable__for_datefrom_sample(let lhsDate, let lhsSample), .m_setTimeZoneIfApplicable__for_datefrom_sample(let rhsDate, let rhsSample)):
                guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher) else { return false } 
                return true 
            case (.m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(let lhsCalculation, let lhsType, let lhsStartdate, let lhsEnddate, let lhsCallback), .m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(let rhsCalculation, let rhsType, let rhsStartdate, let rhsEnddate, let rhsCallback)):
                guard Parameter.compare(lhs: lhsCalculation, rhs: rhsCalculation, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(let lhsType, let lhsStartdate, let lhsEnddate, let lhsPredicate, let lhsCallback), .m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(let rhsType, let rhsStartdate, let rhsEnddate, let rhsPredicate, let rhsCallback)):
                guard Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsPredicate, rhs: rhsPredicate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_preferredUnitFor__typeId(let lhsTypeid), .m_preferredUnitFor__typeId(let rhsTypeid)):
                guard Parameter.compare(lhs: lhsTypeid, rhs: rhsTypeid, with: matcher) else { return false } 
                return true 
            case (.m_getAuthorization__callback_callback(let lhsCallback), .m_getAuthorization__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_setTimeZoneIfApplicable__for_datefrom_sample(p0, p1): return p0.intValue + p1.intValue
            case let .m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_preferredUnitFor__typeId(p0): return p0.intValue
            case let .m_getAuthorization__callback_callback(p0): return p0.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getSamples(for type: Parameter<HealthKitSample.Type>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, predicate: Parameter<NSPredicate?>, callback: Parameter<(Array<HKSample>?, Error?) -> Void>, willReturn: () -> Void...) -> MethodStub {
            return Given(method: .m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(`type`, `startDate`, `endDate`, `predicate`, `callback`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func preferredUnitFor(_ typeId: Parameter<HKQuantityTypeIdentifier>, willReturn: HKUnit?...) -> MethodStub {
            return Given(method: .m_preferredUnitFor__typeId(`typeId`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getSamples(for type: Parameter<HealthKitSample.Type>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, predicate: Parameter<NSPredicate?>, callback: Parameter<(Array<HKSample>?, Error?) -> Void>, willProduce: (Stubber<() -> Void>) -> Void) -> MethodStub {
            let willReturn: [() -> Void] = []
			let given: Given = { return Given(method: .m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(`type`, `startDate`, `endDate`, `predicate`, `callback`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (() -> Void).self)
			willProduce(stubber)
			return given
        }
        public static func preferredUnitFor(_ typeId: Parameter<HKQuantityTypeIdentifier>, willProduce: (Stubber<HKUnit?>) -> Void) -> MethodStub {
            let willReturn: [HKUnit?] = []
			let given: Given = { return Given(method: .m_preferredUnitFor__typeId(`typeId`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (HKUnit?).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func setTimeZoneIfApplicable(for date: Parameter<Date>, from sample: Parameter<HKSample>) -> Verify { return Verify(method: .m_setTimeZoneIfApplicable__for_datefrom_sample(`date`, `sample`))}
        public static func calculate(_ calculation: Parameter<HKStatisticsOptions>, _ type: Parameter<HealthKitQuantitySample.Type>, from startDate: Parameter<Date>, to endDate: Parameter<Date>, callback: Parameter<(Double?, Error?) -> Void>) -> Verify { return Verify(method: .m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(`calculation`, `type`, `startDate`, `endDate`, `callback`))}
        public static func getSamples(for type: Parameter<HealthKitSample.Type>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, predicate: Parameter<NSPredicate?>, callback: Parameter<(Array<HKSample>?, Error?) -> Void>) -> Verify { return Verify(method: .m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(`type`, `startDate`, `endDate`, `predicate`, `callback`))}
        public static func preferredUnitFor(_ typeId: Parameter<HKQuantityTypeIdentifier>) -> Verify { return Verify(method: .m_preferredUnitFor__typeId(`typeId`))}
        public static func getAuthorization(callback: Parameter<(Error?) -> Void>) -> Verify { return Verify(method: .m_getAuthorization__callback_callback(`callback`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func setTimeZoneIfApplicable(for date: Parameter<Date>, from sample: Parameter<HKSample>, perform: @escaping (inout Date, HKSample) -> Void) -> Perform {
            return Perform(method: .m_setTimeZoneIfApplicable__for_datefrom_sample(`date`, `sample`), performs: perform)
        }
        public static func calculate(_ calculation: Parameter<HKStatisticsOptions>, _ type: Parameter<HealthKitQuantitySample.Type>, from startDate: Parameter<Date>, to endDate: Parameter<Date>, callback: Parameter<(Double?, Error?) -> Void>, perform: @escaping (HKStatisticsOptions, HealthKitQuantitySample.Type, Date, Date, @escaping (Double?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(`calculation`, `type`, `startDate`, `endDate`, `callback`), performs: perform)
        }
        public static func getSamples(for type: Parameter<HealthKitSample.Type>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, predicate: Parameter<NSPredicate?>, callback: Parameter<(Array<HKSample>?, Error?) -> Void>, perform: @escaping (HealthKitSample.Type, Date?, Date?, NSPredicate?, @escaping (Array<HKSample>?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(`type`, `startDate`, `endDate`, `predicate`, `callback`), performs: perform)
        }
        public static func preferredUnitFor(_ typeId: Parameter<HKQuantityTypeIdentifier>, perform: @escaping (HKQuantityTypeIdentifier) -> Void) -> Perform {
            return Perform(method: .m_preferredUnitFor__typeId(`typeId`), performs: perform)
        }
        public static func getAuthorization(callback: Parameter<(Error?) -> Void>, perform: @escaping (@escaping (Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_getAuthorization__callback_callback(`callback`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - HeartRateQuery
open class HeartRateQueryMock: HeartRateQuery, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "HeartRateQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "HeartRateQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "HeartRateQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - IOUtil
open class IOUtilMock: IOUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func contentsOf(_ url: URL) throws -> String {
        addInvocation(.m_contentsOf__url(Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_contentsOf__url(Parameter<URL>.value(`url`))) as? (URL) -> Void
		perform?(`url`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_contentsOf__url(Parameter<URL>.value(`url`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for contentsOf(_ url: URL). Use given")
			Failure("Stub return value not specified for contentsOf(_ url: URL). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func csvReader(url: URL, hasHeaderRow: Bool) throws -> CSVReader {
        addInvocation(.m_csvReader__url_urlhasHeaderRow_hasHeaderRow(Parameter<URL>.value(`url`), Parameter<Bool>.value(`hasHeaderRow`)))
		let perform = methodPerformValue(.m_csvReader__url_urlhasHeaderRow_hasHeaderRow(Parameter<URL>.value(`url`), Parameter<Bool>.value(`hasHeaderRow`))) as? (URL, Bool) -> Void
		perform?(`url`, `hasHeaderRow`)
		var __value: CSVReader
		do {
		    __value = try methodReturnValue(.m_csvReader__url_urlhasHeaderRow_hasHeaderRow(Parameter<URL>.value(`url`), Parameter<Bool>.value(`hasHeaderRow`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for csvReader(url: URL, hasHeaderRow: Bool). Use given")
			Failure("Stub return value not specified for csvReader(url: URL, hasHeaderRow: Bool). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func csvWriter(url: URL) throws -> CSVWriter {
        addInvocation(.m_csvWriter__url_url(Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_csvWriter__url_url(Parameter<URL>.value(`url`))) as? (URL) -> Void
		perform?(`url`)
		var __value: CSVWriter
		do {
		    __value = try methodReturnValue(.m_csvWriter__url_url(Parameter<URL>.value(`url`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for csvWriter(url: URL). Use given")
			Failure("Stub return value not specified for csvWriter(url: URL). Use given")
		} catch {
		    throw error
		}
		return __value
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
        case m_contentsOf__url(Parameter<URL>)
        case m_csvReader__url_urlhasHeaderRow_hasHeaderRow(Parameter<URL>, Parameter<Bool>)
        case m_csvWriter__url_url(Parameter<URL>)
        case m_urlOfExportFile__for_sampleTypein_directory(Parameter<Exportable.Type>, Parameter<URL>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_contentsOf__url(let lhsUrl), .m_contentsOf__url(let rhsUrl)):
                guard Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher) else { return false } 
                return true 
            case (.m_csvReader__url_urlhasHeaderRow_hasHeaderRow(let lhsUrl, let lhsHasheaderrow), .m_csvReader__url_urlhasHeaderRow_hasHeaderRow(let rhsUrl, let rhsHasheaderrow)):
                guard Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsHasheaderrow, rhs: rhsHasheaderrow, with: matcher) else { return false } 
                return true 
            case (.m_csvWriter__url_url(let lhsUrl), .m_csvWriter__url_url(let rhsUrl)):
                guard Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher) else { return false } 
                return true 
            case (.m_urlOfExportFile__for_sampleTypein_directory(let lhsSampletype, let lhsDirectory), .m_urlOfExportFile__for_sampleTypein_directory(let rhsSampletype, let rhsDirectory)):
                guard Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_contentsOf__url(p0): return p0.intValue
            case let .m_csvReader__url_urlhasHeaderRow_hasHeaderRow(p0, p1): return p0.intValue + p1.intValue
            case let .m_csvWriter__url_url(p0): return p0.intValue
            case let .m_urlOfExportFile__for_sampleTypein_directory(p0, p1): return p0.intValue + p1.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func contentsOf(_ url: Parameter<URL>, willReturn: String...) -> MethodStub {
            return Given(method: .m_contentsOf__url(`url`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func csvReader(url: Parameter<URL>, hasHeaderRow: Parameter<Bool>, willReturn: CSVReader...) -> MethodStub {
            return Given(method: .m_csvReader__url_urlhasHeaderRow_hasHeaderRow(`url`, `hasHeaderRow`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func csvWriter(url: Parameter<URL>, willReturn: CSVWriter...) -> MethodStub {
            return Given(method: .m_csvWriter__url_url(`url`), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func contentsOf(_ url: Parameter<URL>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_contentsOf__url(`url`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func contentsOf(_ url: Parameter<URL>, willProduce: (StubberThrows<String>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_contentsOf__url(`url`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func csvReader(url: Parameter<URL>, hasHeaderRow: Parameter<Bool>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_csvReader__url_urlhasHeaderRow_hasHeaderRow(`url`, `hasHeaderRow`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func csvReader(url: Parameter<URL>, hasHeaderRow: Parameter<Bool>, willProduce: (StubberThrows<CSVReader>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_csvReader__url_urlhasHeaderRow_hasHeaderRow(`url`, `hasHeaderRow`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CSVReader).self)
			willProduce(stubber)
			return given
        }
        public static func csvWriter(url: Parameter<URL>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_csvWriter__url_url(`url`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func csvWriter(url: Parameter<URL>, willProduce: (StubberThrows<CSVWriter>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_csvWriter__url_url(`url`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CSVWriter).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func contentsOf(_ url: Parameter<URL>) -> Verify { return Verify(method: .m_contentsOf__url(`url`))}
        public static func csvReader(url: Parameter<URL>, hasHeaderRow: Parameter<Bool>) -> Verify { return Verify(method: .m_csvReader__url_urlhasHeaderRow_hasHeaderRow(`url`, `hasHeaderRow`))}
        public static func csvWriter(url: Parameter<URL>) -> Verify { return Verify(method: .m_csvWriter__url_url(`url`))}
        public static func urlOfExportFile(for sampleType: Parameter<Exportable.Type>, in directory: Parameter<URL>) -> Verify { return Verify(method: .m_urlOfExportFile__for_sampleTypein_directory(`sampleType`, `directory`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func contentsOf(_ url: Parameter<URL>, perform: @escaping (URL) -> Void) -> Perform {
            return Perform(method: .m_contentsOf__url(`url`), performs: perform)
        }
        public static func csvReader(url: Parameter<URL>, hasHeaderRow: Parameter<Bool>, perform: @escaping (URL, Bool) -> Void) -> Perform {
            return Perform(method: .m_csvReader__url_urlhasHeaderRow_hasHeaderRow(`url`, `hasHeaderRow`), performs: perform)
        }
        public static func csvWriter(url: Parameter<URL>, perform: @escaping (URL) -> Void) -> Perform {
            return Perform(method: .m_csvWriter__url_url(`url`), performs: perform)
        }
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - Importer
open class ImporterMock: Importer, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "ImporterMock - stub value for dataTypePluralName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_dataTypePluralName = newValue }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "ImporterMock - stub value for sourceName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_sourceName = newValue }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "ImporterMock - stub value for customImportMessage was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_customImportMessage = newValue }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "ImporterMock - stub value for lastImport was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_lastImport = newValue }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "ImporterMock - stub value for isPaused was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isPaused = newValue }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "ImporterMock - stub value for isCancelled was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isCancelled = newValue }
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
                guard Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher) else { return false } 
                return true 
            case (.m_resetLastImportDate, .m_resetLastImportDate):
                return true 
            case (.m_percentComplete, .m_percentComplete):
                return true 
            case (.m_cancel, .m_cancel):
                return true 
            case (.m_pause, .m_pause):
                return true 
            case (.m_resume, .m_resume):
                return true 
            case (.m_equalTo__other(let lhsOther), .m_equalTo__other(let rhsOther)):
                guard Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher) else { return false } 
                return true 
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return true
            case (.p_sourceName_get,.p_sourceName_get): return true
            case (.p_customImportMessage_get,.p_customImportMessage_get): return true
            case (.p_lastImport_get,.p_lastImport_get): return true
            case (.p_isPaused_get,.p_isPaused_get): return true
            case (.p_isCancelled_get,.p_isCancelled_get): return true
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return true
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - ImporterFactory
open class ImporterFactoryMock: ImporterFactory, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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


    fileprivate enum MethodType {
        case m_wellnessMoodImporter
        case m_easyPillMedicationImporter
        case m_easyPillMedicationDoseImporter
        case m_aTrackerActivityImporter

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_wellnessMoodImporter, .m_wellnessMoodImporter):
                return true 
            case (.m_easyPillMedicationImporter, .m_easyPillMedicationImporter):
                return true 
            case (.m_easyPillMedicationDoseImporter, .m_easyPillMedicationDoseImporter):
                return true 
            case (.m_aTrackerActivityImporter, .m_aTrackerActivityImporter):
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_wellnessMoodImporter: return 0
            case .m_easyPillMedicationImporter: return 0
            case .m_easyPillMedicationDoseImporter: return 0
            case .m_aTrackerActivityImporter: return 0
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
        public static func easyPillMedicationImporter(willReturn: EasyPillMedicationImporter...) -> MethodStub {
            return Given(method: .m_easyPillMedicationImporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func easyPillMedicationDoseImporter(willReturn: EasyPillMedicationDoseImporter...) -> MethodStub {
            return Given(method: .m_easyPillMedicationDoseImporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func aTrackerActivityImporter(willReturn: ATrackerActivityImporter...) -> MethodStub {
            return Given(method: .m_aTrackerActivityImporter, products: willReturn.map({ StubProduct.return($0 as Any) }))
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
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func wellnessMoodImporter() -> Verify { return Verify(method: .m_wellnessMoodImporter)}
        public static func easyPillMedicationImporter() -> Verify { return Verify(method: .m_easyPillMedicationImporter)}
        public static func easyPillMedicationDoseImporter() -> Verify { return Verify(method: .m_easyPillMedicationDoseImporter)}
        public static func aTrackerActivityImporter() -> Verify { return Verify(method: .m_aTrackerActivityImporter)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func wellnessMoodImporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_wellnessMoodImporter, performs: perform)
        }
        public static func easyPillMedicationImporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_easyPillMedicationImporter, performs: perform)
        }
        public static func easyPillMedicationDoseImporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_easyPillMedicationDoseImporter, performs: perform)
        }
        public static func aTrackerActivityImporter(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_aTrackerActivityImporter, performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - InjectionProvider
open class InjectionProviderMock: InjectionProvider, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func database() -> Database {
        addInvocation(.m_database)
		let perform = methodPerformValue(.m_database) as? () -> Void
		perform?()
		var __value: Database
		do {
		    __value = try methodReturnValue(.m_database).casted()
		} catch {
			onFatalFailure("Stub return value not specified for database(). Use given")
			Failure("Stub return value not specified for database(). Use given")
		}
		return __value
    }

    open func codableStorage() -> CodableStorage {
        addInvocation(.m_codableStorage)
		let perform = methodPerformValue(.m_codableStorage) as? () -> Void
		perform?()
		var __value: CodableStorage
		do {
		    __value = try methodReturnValue(.m_codableStorage).casted()
		} catch {
			onFatalFailure("Stub return value not specified for codableStorage(). Use given")
			Failure("Stub return value not specified for codableStorage(). Use given")
		}
		return __value
    }

    open func settings() -> Settings {
        addInvocation(.m_settings)
		let perform = methodPerformValue(.m_settings) as? () -> Void
		perform?()
		var __value: Settings
		do {
		    __value = try methodReturnValue(.m_settings).casted()
		} catch {
			onFatalFailure("Stub return value not specified for settings(). Use given")
			Failure("Stub return value not specified for settings(). Use given")
		}
		return __value
    }

    open func queryFactory() -> QueryFactory {
        addInvocation(.m_queryFactory)
		let perform = methodPerformValue(.m_queryFactory) as? () -> Void
		perform?()
		var __value: QueryFactory
		do {
		    __value = try methodReturnValue(.m_queryFactory).casted()
		} catch {
			onFatalFailure("Stub return value not specified for queryFactory(). Use given")
			Failure("Stub return value not specified for queryFactory(). Use given")
		}
		return __value
    }

    open func attributeRestrictionFactory() -> AttributeRestrictionFactory {
        addInvocation(.m_attributeRestrictionFactory)
		let perform = methodPerformValue(.m_attributeRestrictionFactory) as? () -> Void
		perform?()
		var __value: AttributeRestrictionFactory
		do {
		    __value = try methodReturnValue(.m_attributeRestrictionFactory).casted()
		} catch {
			onFatalFailure("Stub return value not specified for attributeRestrictionFactory(). Use given")
			Failure("Stub return value not specified for attributeRestrictionFactory(). Use given")
		}
		return __value
    }

    open func sampleFactory() -> SampleFactory {
        addInvocation(.m_sampleFactory)
		let perform = methodPerformValue(.m_sampleFactory) as? () -> Void
		perform?()
		var __value: SampleFactory
		do {
		    __value = try methodReturnValue(.m_sampleFactory).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sampleFactory(). Use given")
			Failure("Stub return value not specified for sampleFactory(). Use given")
		}
		return __value
    }

    open func utilFactory() -> UtilFactory {
        addInvocation(.m_utilFactory)
		let perform = methodPerformValue(.m_utilFactory) as? () -> Void
		perform?()
		var __value: UtilFactory
		do {
		    __value = try methodReturnValue(.m_utilFactory).casted()
		} catch {
			onFatalFailure("Stub return value not specified for utilFactory(). Use given")
			Failure("Stub return value not specified for utilFactory(). Use given")
		}
		return __value
    }

    open func subQueryMatcherFactory() -> SubQueryMatcherFactory {
        addInvocation(.m_subQueryMatcherFactory)
		let perform = methodPerformValue(.m_subQueryMatcherFactory) as? () -> Void
		perform?()
		var __value: SubQueryMatcherFactory
		do {
		    __value = try methodReturnValue(.m_subQueryMatcherFactory).casted()
		} catch {
			onFatalFailure("Stub return value not specified for subQueryMatcherFactory(). Use given")
			Failure("Stub return value not specified for subQueryMatcherFactory(). Use given")
		}
		return __value
    }

    open func extraInformationFactory() -> ExtraInformationFactory {
        addInvocation(.m_extraInformationFactory)
		let perform = methodPerformValue(.m_extraInformationFactory) as? () -> Void
		perform?()
		var __value: ExtraInformationFactory
		do {
		    __value = try methodReturnValue(.m_extraInformationFactory).casted()
		} catch {
			onFatalFailure("Stub return value not specified for extraInformationFactory(). Use given")
			Failure("Stub return value not specified for extraInformationFactory(). Use given")
		}
		return __value
    }

    open func sampleGrouperFactory() -> SampleGrouperFactory {
        addInvocation(.m_sampleGrouperFactory)
		let perform = methodPerformValue(.m_sampleGrouperFactory) as? () -> Void
		perform?()
		var __value: SampleGrouperFactory
		do {
		    __value = try methodReturnValue(.m_sampleGrouperFactory).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sampleGrouperFactory(). Use given")
			Failure("Stub return value not specified for sampleGrouperFactory(). Use given")
		}
		return __value
    }

    open func importerFactory() -> ImporterFactory {
        addInvocation(.m_importerFactory)
		let perform = methodPerformValue(.m_importerFactory) as? () -> Void
		perform?()
		var __value: ImporterFactory
		do {
		    __value = try methodReturnValue(.m_importerFactory).casted()
		} catch {
			onFatalFailure("Stub return value not specified for importerFactory(). Use given")
			Failure("Stub return value not specified for importerFactory(). Use given")
		}
		return __value
    }

    open func exporterFactory() -> ExporterFactory {
        addInvocation(.m_exporterFactory)
		let perform = methodPerformValue(.m_exporterFactory) as? () -> Void
		perform?()
		var __value: ExporterFactory
		do {
		    __value = try methodReturnValue(.m_exporterFactory).casted()
		} catch {
			onFatalFailure("Stub return value not specified for exporterFactory(). Use given")
			Failure("Stub return value not specified for exporterFactory(). Use given")
		}
		return __value
    }

    open func coachMarkFactory() -> CoachMarkFactory {
        addInvocation(.m_coachMarkFactory)
		let perform = methodPerformValue(.m_coachMarkFactory) as? () -> Void
		perform?()
		var __value: CoachMarkFactory
		do {
		    __value = try methodReturnValue(.m_coachMarkFactory).casted()
		} catch {
			onFatalFailure("Stub return value not specified for coachMarkFactory(). Use given")
			Failure("Stub return value not specified for coachMarkFactory(). Use given")
		}
		return __value
    }

    open func booleanAlgebraFactory() -> BooleanAlgebraFactory {
        addInvocation(.m_booleanAlgebraFactory)
		let perform = methodPerformValue(.m_booleanAlgebraFactory) as? () -> Void
		perform?()
		var __value: BooleanAlgebraFactory
		do {
		    __value = try methodReturnValue(.m_booleanAlgebraFactory).casted()
		} catch {
			onFatalFailure("Stub return value not specified for booleanAlgebraFactory(). Use given")
			Failure("Stub return value not specified for booleanAlgebraFactory(). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_database
        case m_codableStorage
        case m_settings
        case m_queryFactory
        case m_attributeRestrictionFactory
        case m_sampleFactory
        case m_utilFactory
        case m_subQueryMatcherFactory
        case m_extraInformationFactory
        case m_sampleGrouperFactory
        case m_importerFactory
        case m_exporterFactory
        case m_coachMarkFactory
        case m_booleanAlgebraFactory

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_database, .m_database):
                return true 
            case (.m_codableStorage, .m_codableStorage):
                return true 
            case (.m_settings, .m_settings):
                return true 
            case (.m_queryFactory, .m_queryFactory):
                return true 
            case (.m_attributeRestrictionFactory, .m_attributeRestrictionFactory):
                return true 
            case (.m_sampleFactory, .m_sampleFactory):
                return true 
            case (.m_utilFactory, .m_utilFactory):
                return true 
            case (.m_subQueryMatcherFactory, .m_subQueryMatcherFactory):
                return true 
            case (.m_extraInformationFactory, .m_extraInformationFactory):
                return true 
            case (.m_sampleGrouperFactory, .m_sampleGrouperFactory):
                return true 
            case (.m_importerFactory, .m_importerFactory):
                return true 
            case (.m_exporterFactory, .m_exporterFactory):
                return true 
            case (.m_coachMarkFactory, .m_coachMarkFactory):
                return true 
            case (.m_booleanAlgebraFactory, .m_booleanAlgebraFactory):
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_database: return 0
            case .m_codableStorage: return 0
            case .m_settings: return 0
            case .m_queryFactory: return 0
            case .m_attributeRestrictionFactory: return 0
            case .m_sampleFactory: return 0
            case .m_utilFactory: return 0
            case .m_subQueryMatcherFactory: return 0
            case .m_extraInformationFactory: return 0
            case .m_sampleGrouperFactory: return 0
            case .m_importerFactory: return 0
            case .m_exporterFactory: return 0
            case .m_coachMarkFactory: return 0
            case .m_booleanAlgebraFactory: return 0
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func database(willReturn: Database...) -> MethodStub {
            return Given(method: .m_database, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func codableStorage(willReturn: CodableStorage...) -> MethodStub {
            return Given(method: .m_codableStorage, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func settings(willReturn: Settings...) -> MethodStub {
            return Given(method: .m_settings, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func queryFactory(willReturn: QueryFactory...) -> MethodStub {
            return Given(method: .m_queryFactory, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func attributeRestrictionFactory(willReturn: AttributeRestrictionFactory...) -> MethodStub {
            return Given(method: .m_attributeRestrictionFactory, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sampleFactory(willReturn: SampleFactory...) -> MethodStub {
            return Given(method: .m_sampleFactory, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func utilFactory(willReturn: UtilFactory...) -> MethodStub {
            return Given(method: .m_utilFactory, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQueryMatcherFactory(willReturn: SubQueryMatcherFactory...) -> MethodStub {
            return Given(method: .m_subQueryMatcherFactory, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func extraInformationFactory(willReturn: ExtraInformationFactory...) -> MethodStub {
            return Given(method: .m_extraInformationFactory, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sampleGrouperFactory(willReturn: SampleGrouperFactory...) -> MethodStub {
            return Given(method: .m_sampleGrouperFactory, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func importerFactory(willReturn: ImporterFactory...) -> MethodStub {
            return Given(method: .m_importerFactory, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func exporterFactory(willReturn: ExporterFactory...) -> MethodStub {
            return Given(method: .m_exporterFactory, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func coachMarkFactory(willReturn: CoachMarkFactory...) -> MethodStub {
            return Given(method: .m_coachMarkFactory, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func booleanAlgebraFactory(willReturn: BooleanAlgebraFactory...) -> MethodStub {
            return Given(method: .m_booleanAlgebraFactory, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func database(willProduce: (Stubber<Database>) -> Void) -> MethodStub {
            let willReturn: [Database] = []
			let given: Given = { return Given(method: .m_database, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Database).self)
			willProduce(stubber)
			return given
        }
        public static func codableStorage(willProduce: (Stubber<CodableStorage>) -> Void) -> MethodStub {
            let willReturn: [CodableStorage] = []
			let given: Given = { return Given(method: .m_codableStorage, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (CodableStorage).self)
			willProduce(stubber)
			return given
        }
        public static func settings(willProduce: (Stubber<Settings>) -> Void) -> MethodStub {
            let willReturn: [Settings] = []
			let given: Given = { return Given(method: .m_settings, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Settings).self)
			willProduce(stubber)
			return given
        }
        public static func queryFactory(willProduce: (Stubber<QueryFactory>) -> Void) -> MethodStub {
            let willReturn: [QueryFactory] = []
			let given: Given = { return Given(method: .m_queryFactory, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (QueryFactory).self)
			willProduce(stubber)
			return given
        }
        public static func attributeRestrictionFactory(willProduce: (Stubber<AttributeRestrictionFactory>) -> Void) -> MethodStub {
            let willReturn: [AttributeRestrictionFactory] = []
			let given: Given = { return Given(method: .m_attributeRestrictionFactory, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (AttributeRestrictionFactory).self)
			willProduce(stubber)
			return given
        }
        public static func sampleFactory(willProduce: (Stubber<SampleFactory>) -> Void) -> MethodStub {
            let willReturn: [SampleFactory] = []
			let given: Given = { return Given(method: .m_sampleFactory, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SampleFactory).self)
			willProduce(stubber)
			return given
        }
        public static func utilFactory(willProduce: (Stubber<UtilFactory>) -> Void) -> MethodStub {
            let willReturn: [UtilFactory] = []
			let given: Given = { return Given(method: .m_utilFactory, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UtilFactory).self)
			willProduce(stubber)
			return given
        }
        public static func subQueryMatcherFactory(willProduce: (Stubber<SubQueryMatcherFactory>) -> Void) -> MethodStub {
            let willReturn: [SubQueryMatcherFactory] = []
			let given: Given = { return Given(method: .m_subQueryMatcherFactory, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SubQueryMatcherFactory).self)
			willProduce(stubber)
			return given
        }
        public static func extraInformationFactory(willProduce: (Stubber<ExtraInformationFactory>) -> Void) -> MethodStub {
            let willReturn: [ExtraInformationFactory] = []
			let given: Given = { return Given(method: .m_extraInformationFactory, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (ExtraInformationFactory).self)
			willProduce(stubber)
			return given
        }
        public static func sampleGrouperFactory(willProduce: (Stubber<SampleGrouperFactory>) -> Void) -> MethodStub {
            let willReturn: [SampleGrouperFactory] = []
			let given: Given = { return Given(method: .m_sampleGrouperFactory, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SampleGrouperFactory).self)
			willProduce(stubber)
			return given
        }
        public static func importerFactory(willProduce: (Stubber<ImporterFactory>) -> Void) -> MethodStub {
            let willReturn: [ImporterFactory] = []
			let given: Given = { return Given(method: .m_importerFactory, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (ImporterFactory).self)
			willProduce(stubber)
			return given
        }
        public static func exporterFactory(willProduce: (Stubber<ExporterFactory>) -> Void) -> MethodStub {
            let willReturn: [ExporterFactory] = []
			let given: Given = { return Given(method: .m_exporterFactory, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (ExporterFactory).self)
			willProduce(stubber)
			return given
        }
        public static func coachMarkFactory(willProduce: (Stubber<CoachMarkFactory>) -> Void) -> MethodStub {
            let willReturn: [CoachMarkFactory] = []
			let given: Given = { return Given(method: .m_coachMarkFactory, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (CoachMarkFactory).self)
			willProduce(stubber)
			return given
        }
        public static func booleanAlgebraFactory(willProduce: (Stubber<BooleanAlgebraFactory>) -> Void) -> MethodStub {
            let willReturn: [BooleanAlgebraFactory] = []
			let given: Given = { return Given(method: .m_booleanAlgebraFactory, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (BooleanAlgebraFactory).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func database() -> Verify { return Verify(method: .m_database)}
        public static func codableStorage() -> Verify { return Verify(method: .m_codableStorage)}
        public static func settings() -> Verify { return Verify(method: .m_settings)}
        public static func queryFactory() -> Verify { return Verify(method: .m_queryFactory)}
        public static func attributeRestrictionFactory() -> Verify { return Verify(method: .m_attributeRestrictionFactory)}
        public static func sampleFactory() -> Verify { return Verify(method: .m_sampleFactory)}
        public static func utilFactory() -> Verify { return Verify(method: .m_utilFactory)}
        public static func subQueryMatcherFactory() -> Verify { return Verify(method: .m_subQueryMatcherFactory)}
        public static func extraInformationFactory() -> Verify { return Verify(method: .m_extraInformationFactory)}
        public static func sampleGrouperFactory() -> Verify { return Verify(method: .m_sampleGrouperFactory)}
        public static func importerFactory() -> Verify { return Verify(method: .m_importerFactory)}
        public static func exporterFactory() -> Verify { return Verify(method: .m_exporterFactory)}
        public static func coachMarkFactory() -> Verify { return Verify(method: .m_coachMarkFactory)}
        public static func booleanAlgebraFactory() -> Verify { return Verify(method: .m_booleanAlgebraFactory)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func database(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_database, performs: perform)
        }
        public static func codableStorage(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_codableStorage, performs: perform)
        }
        public static func settings(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_settings, performs: perform)
        }
        public static func queryFactory(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_queryFactory, performs: perform)
        }
        public static func attributeRestrictionFactory(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_attributeRestrictionFactory, performs: perform)
        }
        public static func sampleFactory(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sampleFactory, performs: perform)
        }
        public static func utilFactory(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_utilFactory, performs: perform)
        }
        public static func subQueryMatcherFactory(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_subQueryMatcherFactory, performs: perform)
        }
        public static func extraInformationFactory(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_extraInformationFactory, performs: perform)
        }
        public static func sampleGrouperFactory(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sampleGrouperFactory, performs: perform)
        }
        public static func importerFactory(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_importerFactory, performs: perform)
        }
        public static func exporterFactory(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_exporterFactory, performs: perform)
        }
        public static func coachMarkFactory(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_coachMarkFactory, performs: perform)
        }
        public static func booleanAlgebraFactory(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_booleanAlgebraFactory, performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - LeanBodyMassQuery
open class LeanBodyMassQueryMock: LeanBodyMassQuery, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "LeanBodyMassQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "LeanBodyMassQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "LeanBodyMassQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - MedicationDoseQuery
open class MedicationDoseQueryMock: MedicationDoseQuery, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "MedicationDoseQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "MedicationDoseQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "MedicationDoseQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - MedicationExporter
open class MedicationExporterMock: MedicationExporter, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "MedicationExporterMock - stub value for dataTypePluralName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_dataTypePluralName = newValue }
	}
	private var __p_dataTypePluralName: (String)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "MedicationExporterMock - stub value for isPaused was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isPaused = newValue }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "MedicationExporterMock - stub value for isCancelled was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isCancelled = newValue }
	}
	private var __p_isCancelled: (Bool)?

    public var url: URL {
		get {	invocations.append(.p_url_get); return __p_url ?? givenGetterValue(.p_url_get, "MedicationExporterMock - stub value for url was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_url = newValue }
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_exportData, .m_exportData):
                return true 
            case (.m_percentComplete, .m_percentComplete):
                return true 
            case (.m_cancel, .m_cancel):
                return true 
            case (.m_pause, .m_pause):
                return true 
            case (.m_resume, .m_resume):
                return true 
            case (.m_equalTo__other(let lhsOther), .m_equalTo__other(let rhsOther)):
                guard Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher) else { return false } 
                return true 
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return true
            case (.p_isPaused_get,.p_isPaused_get): return true
            case (.p_isCancelled_get,.p_isCancelled_get): return true
            case (.p_url_get,.p_url_get): return true
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - MoodQuery
open class MoodQueryMock: MoodQuery, Mock, StaticMock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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
    static var matcher: Matcher = Matcher.default
    static var stubbingPolicy: StubbingPolicy = .wrap
    static var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst
    static private var invocations: [StaticMethodType] = []
    static private var methodReturnValues: [StaticGiven] = []
    static private var methodPerformValues: [StaticPerform] = []
    public typealias StaticPropertyStub = StaticGiven
    public typealias StaticMethodStub = StaticGiven
    public static func clear() {
        invocations = []
        methodReturnValues = []
        methodPerformValues = []
    }

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "MoodQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "MoodQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "MoodQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?


    public static var updatingMoodsInBackground: Bool {
		get {	MoodQueryMock.invocations.append(.p_updatingMoodsInBackground_get); return MoodQueryMock.__p_updatingMoodsInBackground ?? givenGetterValue(.p_updatingMoodsInBackground_get, "MoodQueryMock - stub value for updatingMoodsInBackground was not defined") }
		set {	MoodQueryMock.invocations.append(.p_updatingMoodsInBackground_set(.value(newValue))); MoodQueryMock.__p_updatingMoodsInBackground = newValue }
	}
	private static var __p_updatingMoodsInBackground: (Bool)?




    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }

    fileprivate enum StaticMethodType {
        case p_updatingMoodsInBackground_get
		case p_updatingMoodsInBackground_set(Parameter<Bool>)

        static func compareParameters(lhs: StaticMethodType, rhs: StaticMethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_updatingMoodsInBackground_get,.p_updatingMoodsInBackground_get): return true
			case (.p_updatingMoodsInBackground_set(let left),.p_updatingMoodsInBackground_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
                case .p_updatingMoodsInBackground_get: return 0
			case .p_updatingMoodsInBackground_set(let newValue): return newValue.intValue
            }
        }
    }

    open class StaticGiven: StubbedMethod {
        fileprivate var method: StaticMethodType

        private init(method: StaticMethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func updatingMoodsInBackground(getter defaultValue: Bool...) -> StaticPropertyStub {
            return StaticGiven(method: .p_updatingMoodsInBackground_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct StaticVerify {
        fileprivate var method: StaticMethodType

        public static var updatingMoodsInBackground: StaticVerify { return StaticVerify(method: .p_updatingMoodsInBackground_get) }
		public static func updatingMoodsInBackground(set newValue: Parameter<Bool>) -> StaticVerify { return StaticVerify(method: .p_updatingMoodsInBackground_set(newValue)) }
    }

    public struct StaticPerform {
        fileprivate var method: StaticMethodType
        var performs: Any

    }

    
    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }

    static public func given(_ method: StaticGiven) {
        methodReturnValues.append(method)
    }

    static public func perform(_ method: StaticPerform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    static public func verify(_ method: StaticVerify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    static private func addInvocation(_ call: StaticMethodType) {
        invocations.append(call)
    }
    static private func methodReturnValue(_ method: StaticMethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    static private func methodPerformValue(_ method: StaticMethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    static private func matchingCalls(_ method: StaticMethodType) -> [StaticMethodType] {
        return invocations.filter { StaticMethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    static private func matchingCalls(_ method: StaticVerify) -> Int {
        return matchingCalls(method.method).count
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
}

// MARK: - MoodUtil
open class MoodUtilMock: MoodUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func scaleMoods() throws {
        addInvocation(.m_scaleMoods)
		let perform = methodPerformValue(.m_scaleMoods) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_scaleMoods).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func scaleMood(_ mood: Mood) {
        addInvocation(.m_scaleMood__mood(Parameter<Mood>.value(`mood`)))
		let perform = methodPerformValue(.m_scaleMood__mood(Parameter<Mood>.value(`mood`))) as? (Mood) -> Void
		perform?(`mood`)
    }


    fileprivate enum MethodType {
        case m_scaleMoods
        case m_scaleMood__mood(Parameter<Mood>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_scaleMoods, .m_scaleMoods):
                return true 
            case (.m_scaleMood__mood(let lhsMood), .m_scaleMood__mood(let rhsMood)):
                guard Parameter.compare(lhs: lhsMood, rhs: rhsMood, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_scaleMoods: return 0
            case let .m_scaleMood__mood(p0): return p0.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func scaleMoods(willThrow: Error...) -> MethodStub {
            return Given(method: .m_scaleMoods, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func scaleMoods(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_scaleMoods, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func scaleMoods() -> Verify { return Verify(method: .m_scaleMoods)}
        public static func scaleMood(_ mood: Parameter<Mood>) -> Verify { return Verify(method: .m_scaleMood__mood(`mood`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func scaleMoods(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_scaleMoods, performs: perform)
        }
        public static func scaleMood(_ mood: Parameter<Mood>, perform: @escaping (Mood) -> Void) -> Perform {
            return Perform(method: .m_scaleMood__mood(`mood`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - NotificationUtil
open class NotificationUtilMock: NotificationUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func post(_ name: NotificationName, object: Any?, userInfo: [UserInfoKey: Any]?, qos: DispatchQoS.QoSClass?) {
        addInvocation(.m_post__nameobject_objectuserInfo_userInfoqos_qos(Parameter<NotificationName>.value(`name`), Parameter<Any?>.value(`object`), Parameter<[UserInfoKey: Any]?>.value(`userInfo`), Parameter<DispatchQoS.QoSClass?>.value(`qos`)))
		let perform = methodPerformValue(.m_post__nameobject_objectuserInfo_userInfoqos_qos(Parameter<NotificationName>.value(`name`), Parameter<Any?>.value(`object`), Parameter<[UserInfoKey: Any]?>.value(`userInfo`), Parameter<DispatchQoS.QoSClass?>.value(`qos`))) as? (NotificationName, Any?, [UserInfoKey: Any]?, DispatchQoS.QoSClass?) -> Void
		perform?(`name`, `object`, `userInfo`, `qos`)
    }


    fileprivate enum MethodType {
        case m_post__nameobject_objectuserInfo_userInfoqos_qos(Parameter<NotificationName>, Parameter<Any?>, Parameter<[UserInfoKey: Any]?>, Parameter<DispatchQoS.QoSClass?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_post__nameobject_objectuserInfo_userInfoqos_qos(let lhsName, let lhsObject, let lhsUserinfo, let lhsQos), .m_post__nameobject_objectuserInfo_userInfoqos_qos(let rhsName, let rhsObject, let rhsUserinfo, let rhsQos)):
                guard Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsUserinfo, rhs: rhsUserinfo, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsQos, rhs: rhsQos, with: matcher) else { return false } 
                return true 
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_post__nameobject_objectuserInfo_userInfoqos_qos(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func post(_ name: Parameter<NotificationName>, object: Parameter<Any?>, userInfo: Parameter<[UserInfoKey: Any]?>, qos: Parameter<DispatchQoS.QoSClass?>) -> Verify { return Verify(method: .m_post__nameobject_objectuserInfo_userInfoqos_qos(`name`, `object`, `userInfo`, `qos`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func post(_ name: Parameter<NotificationName>, object: Parameter<Any?>, userInfo: Parameter<[UserInfoKey: Any]?>, qos: Parameter<DispatchQoS.QoSClass?>, perform: @escaping (NotificationName, Any?, [UserInfoKey: Any]?, DispatchQoS.QoSClass?) -> Void) -> Perform {
            return Perform(method: .m_post__nameobject_objectuserInfo_userInfoqos_qos(`name`, `object`, `userInfo`, `qos`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - NumericSampleUtil
open class NumericSampleUtilMock: NumericSampleUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func average(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?) throws -> [(date: Date?, value: Double)] {
        addInvocation(.m_average__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`)))
		let perform = methodPerformValue(.m_average__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`))) as? (Attribute, [Sample], Calendar.Component?) -> Void
		perform?(`attribute`, `samples`, `aggregationUnit`)
		var __value: [(date: Date?, value: Double)]
		do {
		    __value = try methodReturnValue(.m_average__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for average(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?). Use given")
			Failure("Stub return value not specified for average(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func average(for attribute: Attribute, over samples: [Sample]) throws -> Double {
        addInvocation(.m_average__for_attributeover_samples(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`)))
		let perform = methodPerformValue(.m_average__for_attributeover_samples(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`))) as? (Attribute, [Sample]) -> Void
		perform?(`attribute`, `samples`)
		var __value: Double
		do {
		    __value = try methodReturnValue(.m_average__for_attributeover_samples(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for average(for attribute: Attribute, over samples: [Sample]). Use given")
			Failure("Stub return value not specified for average(for attribute: Attribute, over samples: [Sample]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func count(over samples: [Sample], per aggregationUnit: Calendar.Component?) throws -> [(date: Date?, value: Int)] {
        addInvocation(.m_count__over_samplesper_aggregationUnit(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`)))
		let perform = methodPerformValue(.m_count__over_samplesper_aggregationUnit(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`))) as? ([Sample], Calendar.Component?) -> Void
		perform?(`samples`, `aggregationUnit`)
		var __value: [(date: Date?, value: Int)]
		do {
		    __value = try methodReturnValue(.m_count__over_samplesper_aggregationUnit(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for count(over samples: [Sample], per aggregationUnit: Calendar.Component?). Use given")
			Failure("Stub return value not specified for count(over samples: [Sample], per aggregationUnit: Calendar.Component?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func max<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?, as: Type.Type) throws -> [(date: Date?, value: Type)] {
        addInvocation(.m_max__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_max__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (Attribute, [Sample], Calendar.Component?, Type.Type) -> Void
		perform?(`attribute`, `samples`, `aggregationUnit`, `as`)
		var __value: [(date: Date?, value: Type)]
		do {
		    __value = try methodReturnValue(.m_max__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for max<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?, as: Type.Type). Use given")
			Failure("Stub return value not specified for max<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?, as: Type.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func max<Type: Comparable>(for attribute: Attribute, over samples: [Sample], as: Type.Type) throws -> Type {
        addInvocation(.m_max__for_attributeover_samplesas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_max__for_attributeover_samplesas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (Attribute, [Sample], Type.Type) -> Void
		perform?(`attribute`, `samples`, `as`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_max__for_attributeover_samplesas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for max<Type: Comparable>(for attribute: Attribute, over samples: [Sample], as: Type.Type). Use given")
			Failure("Stub return value not specified for max<Type: Comparable>(for attribute: Attribute, over samples: [Sample], as: Type.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func min<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?, as: Type.Type) throws -> [(date: Date?, value: Type)] {
        addInvocation(.m_min__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_min__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (Attribute, [Sample], Calendar.Component?, Type.Type) -> Void
		perform?(`attribute`, `samples`, `aggregationUnit`, `as`)
		var __value: [(date: Date?, value: Type)]
		do {
		    __value = try methodReturnValue(.m_min__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for min<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?, as: Type.Type). Use given")
			Failure("Stub return value not specified for min<Type: Comparable>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?, as: Type.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func min<Type: Comparable>(for attribute: Attribute, over samples: [Sample], as: Type.Type) throws -> Type {
        addInvocation(.m_min__for_attributeover_samplesas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_min__for_attributeover_samplesas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (Attribute, [Sample], Type.Type) -> Void
		perform?(`attribute`, `samples`, `as`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_min__for_attributeover_samplesas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for min<Type: Comparable>(for attribute: Attribute, over samples: [Sample], as: Type.Type). Use given")
			Failure("Stub return value not specified for min<Type: Comparable>(for attribute: Attribute, over samples: [Sample], as: Type.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?, as: Type.Type) throws -> [(date: Date?, value: Type)] {
        addInvocation(.m_sum__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_sum__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (Attribute, [Sample], Calendar.Component?, Type.Type) -> Void
		perform?(`attribute`, `samples`, `aggregationUnit`, `as`)
		var __value: [(date: Date?, value: Type)]
		do {
		    __value = try methodReturnValue(.m_sum__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?, as: Type.Type). Use given")
			Failure("Stub return value not specified for sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample], per aggregationUnit: Calendar.Component?, as: Type.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample], as: Type.Type) throws -> Type {
        addInvocation(.m_sum__for_attributeover_samplesas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_sum__for_attributeover_samplesas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (Attribute, [Sample], Type.Type) -> Void
		perform?(`attribute`, `samples`, `as`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_sum__for_attributeover_samplesas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample], as: Type.Type). Use given")
			Failure("Stub return value not specified for sum<Type: Numeric>(for attribute: Attribute, over samples: [Sample], as: Type.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_average__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>, Parameter<[Sample]>, Parameter<Calendar.Component?>)
        case m_average__for_attributeover_samples(Parameter<Attribute>, Parameter<[Sample]>)
        case m_count__over_samplesper_aggregationUnit(Parameter<[Sample]>, Parameter<Calendar.Component?>)
        case m_max__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>, Parameter<[Sample]>, Parameter<Calendar.Component?>, Parameter<GenericAttribute>)
        case m_max__for_attributeover_samplesas_as(Parameter<Attribute>, Parameter<[Sample]>, Parameter<GenericAttribute>)
        case m_min__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>, Parameter<[Sample]>, Parameter<Calendar.Component?>, Parameter<GenericAttribute>)
        case m_min__for_attributeover_samplesas_as(Parameter<Attribute>, Parameter<[Sample]>, Parameter<GenericAttribute>)
        case m_sum__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>, Parameter<[Sample]>, Parameter<Calendar.Component?>, Parameter<GenericAttribute>)
        case m_sum__for_attributeover_samplesas_as(Parameter<Attribute>, Parameter<[Sample]>, Parameter<GenericAttribute>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_average__for_attributeover_samplesper_aggregationUnit(let lhsAttribute, let lhsSamples, let lhsAggregationunit), .m_average__for_attributeover_samplesper_aggregationUnit(let rhsAttribute, let rhsSamples, let rhsAggregationunit)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                return true 
            case (.m_average__for_attributeover_samples(let lhsAttribute, let lhsSamples), .m_average__for_attributeover_samples(let rhsAttribute, let rhsSamples)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                return true 
            case (.m_count__over_samplesper_aggregationUnit(let lhsSamples, let lhsAggregationunit), .m_count__over_samplesper_aggregationUnit(let rhsSamples, let rhsAggregationunit)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                return true 
            case (.m_max__for_attributeover_samplesper_aggregationUnitas_as(let lhsAttribute, let lhsSamples, let lhsAggregationunit, let lhsAs), .m_max__for_attributeover_samplesper_aggregationUnitas_as(let rhsAttribute, let rhsSamples, let rhsAggregationunit, let rhsAs)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher) else { return false } 
                return true 
            case (.m_max__for_attributeover_samplesas_as(let lhsAttribute, let lhsSamples, let lhsAs), .m_max__for_attributeover_samplesas_as(let rhsAttribute, let rhsSamples, let rhsAs)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher) else { return false } 
                return true 
            case (.m_min__for_attributeover_samplesper_aggregationUnitas_as(let lhsAttribute, let lhsSamples, let lhsAggregationunit, let lhsAs), .m_min__for_attributeover_samplesper_aggregationUnitas_as(let rhsAttribute, let rhsSamples, let rhsAggregationunit, let rhsAs)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher) else { return false } 
                return true 
            case (.m_min__for_attributeover_samplesas_as(let lhsAttribute, let lhsSamples, let lhsAs), .m_min__for_attributeover_samplesas_as(let rhsAttribute, let rhsSamples, let rhsAs)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher) else { return false } 
                return true 
            case (.m_sum__for_attributeover_samplesper_aggregationUnitas_as(let lhsAttribute, let lhsSamples, let lhsAggregationunit, let lhsAs), .m_sum__for_attributeover_samplesper_aggregationUnitas_as(let rhsAttribute, let rhsSamples, let rhsAggregationunit, let rhsAs)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher) else { return false } 
                return true 
            case (.m_sum__for_attributeover_samplesas_as(let lhsAttribute, let lhsSamples, let lhsAs), .m_sum__for_attributeover_samplesas_as(let rhsAttribute, let rhsSamples, let rhsAs)):
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_average__for_attributeover_samplesper_aggregationUnit(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_average__for_attributeover_samples(p0, p1): return p0.intValue + p1.intValue
            case let .m_count__over_samplesper_aggregationUnit(p0, p1): return p0.intValue + p1.intValue
            case let .m_max__for_attributeover_samplesper_aggregationUnitas_as(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_max__for_attributeover_samplesas_as(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_min__for_attributeover_samplesper_aggregationUnitas_as(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_min__for_attributeover_samplesas_as(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_sum__for_attributeover_samplesper_aggregationUnitas_as(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_sum__for_attributeover_samplesas_as(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, willReturn: [(date: Date?, value: Double)]...) -> MethodStub {
            return Given(method: .m_average__for_attributeover_samplesper_aggregationUnit(`attribute`, `samples`, `aggregationUnit`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, willReturn: Double...) -> MethodStub {
            return Given(method: .m_average__for_attributeover_samples(`attribute`, `samples`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func count(over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, willReturn: [(date: Date?, value: Int)]...) -> MethodStub {
            return Given(method: .m_count__over_samplesper_aggregationUnit(`samples`, `aggregationUnit`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func max<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willReturn: [(date: Date?, value: Type)]...) -> MethodStub {
            return Given(method: .m_max__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func max<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_max__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func min<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willReturn: [(date: Date?, value: Type)]...) -> MethodStub {
            return Given(method: .m_min__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func min<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_min__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sum<Type: Numeric>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willReturn: [(date: Date?, value: Type)]...) -> MethodStub {
            return Given(method: .m_sum__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sum<Type: Numeric>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_sum__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_average__for_attributeover_samplesper_aggregationUnit(`attribute`, `samples`, `aggregationUnit`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, willProduce: (StubberThrows<[(date: Date?, value: Double)]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_average__for_attributeover_samplesper_aggregationUnit(`attribute`, `samples`, `aggregationUnit`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(date: Date?, value: Double)]).self)
			willProduce(stubber)
			return given
        }
        public static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_average__for_attributeover_samples(`attribute`, `samples`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, willProduce: (StubberThrows<Double>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_average__for_attributeover_samples(`attribute`, `samples`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Double).self)
			willProduce(stubber)
			return given
        }
        public static func count(over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_count__over_samplesper_aggregationUnit(`samples`, `aggregationUnit`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func count(over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, willProduce: (StubberThrows<[(date: Date?, value: Int)]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_count__over_samplesper_aggregationUnit(`samples`, `aggregationUnit`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(date: Date?, value: Int)]).self)
			willProduce(stubber)
			return given
        }
        public static func max<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_max__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func max<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willProduce: (StubberThrows<[(date: Date?, value: Type)]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_max__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(date: Date?, value: Type)]).self)
			willProduce(stubber)
			return given
        }
        public static func max<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_max__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func max<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_max__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func min<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_min__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func min<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willProduce: (StubberThrows<[(date: Date?, value: Type)]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_min__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(date: Date?, value: Type)]).self)
			willProduce(stubber)
			return given
        }
        public static func min<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_min__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func min<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_min__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func sum<Type: Numeric>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_sum__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func sum<Type: Numeric>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willProduce: (StubberThrows<[(date: Date?, value: Type)]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_sum__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(date: Date?, value: Type)]).self)
			willProduce(stubber)
			return given
        }
        public static func sum<Type: Numeric>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_sum__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func sum<Type: Numeric>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_sum__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>) -> Verify { return Verify(method: .m_average__for_attributeover_samplesper_aggregationUnit(`attribute`, `samples`, `aggregationUnit`))}
        public static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>) -> Verify { return Verify(method: .m_average__for_attributeover_samples(`attribute`, `samples`))}
        public static func count(over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>) -> Verify { return Verify(method: .m_count__over_samplesper_aggregationUnit(`samples`, `aggregationUnit`))}
        public static func max<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>) -> Verify where Type:Comparable { return Verify(method: .m_max__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()))}
        public static func max<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>) -> Verify where Type:Comparable { return Verify(method: .m_max__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()))}
        public static func min<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>) -> Verify where Type:Comparable { return Verify(method: .m_min__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()))}
        public static func min<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>) -> Verify where Type:Comparable { return Verify(method: .m_min__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()))}
        public static func sum<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>) -> Verify where Type:Numeric { return Verify(method: .m_sum__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()))}
        public static func sum<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>) -> Verify where Type:Numeric { return Verify(method: .m_sum__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, perform: @escaping (Attribute, [Sample], Calendar.Component?) -> Void) -> Perform {
            return Perform(method: .m_average__for_attributeover_samplesper_aggregationUnit(`attribute`, `samples`, `aggregationUnit`), performs: perform)
        }
        public static func average(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, perform: @escaping (Attribute, [Sample]) -> Void) -> Perform {
            return Perform(method: .m_average__for_attributeover_samples(`attribute`, `samples`), performs: perform)
        }
        public static func count(over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, perform: @escaping ([Sample], Calendar.Component?) -> Void) -> Perform {
            return Perform(method: .m_count__over_samplesper_aggregationUnit(`samples`, `aggregationUnit`), performs: perform)
        }
        public static func max<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, perform: @escaping (Attribute, [Sample], Calendar.Component?, Type.Type) -> Void) -> Perform where Type:Comparable {
            return Perform(method: .m_max__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), performs: perform)
        }
        public static func max<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, perform: @escaping (Attribute, [Sample], Type.Type) -> Void) -> Perform where Type:Comparable {
            return Perform(method: .m_max__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), performs: perform)
        }
        public static func min<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, perform: @escaping (Attribute, [Sample], Calendar.Component?, Type.Type) -> Void) -> Perform where Type:Comparable {
            return Perform(method: .m_min__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), performs: perform)
        }
        public static func min<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, perform: @escaping (Attribute, [Sample], Type.Type) -> Void) -> Perform where Type:Comparable {
            return Perform(method: .m_min__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), performs: perform)
        }
        public static func sum<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, perform: @escaping (Attribute, [Sample], Calendar.Component?, Type.Type) -> Void) -> Perform where Type:Numeric {
            return Perform(method: .m_sum__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), performs: perform)
        }
        public static func sum<Type>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, perform: @escaping (Attribute, [Sample], Type.Type) -> Void) -> Perform where Type:Numeric {
            return Perform(method: .m_sum__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - Query
open class QueryMock: Query, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "QueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "QueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "QueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - QueryFactory
open class QueryFactoryMock: QueryFactory, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func activityQuery() -> ActivityQuery {
        addInvocation(.m_activityQuery)
		let perform = methodPerformValue(.m_activityQuery) as? () -> Void
		perform?()
		var __value: ActivityQuery
		do {
		    __value = try methodReturnValue(.m_activityQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for activityQuery(). Use given")
			Failure("Stub return value not specified for activityQuery(). Use given")
		}
		return __value
    }

    open func activityQuery(_ parts: [BooleanExpressionPart]) throws -> ActivityQuery {
        addInvocation(.m_activityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_activityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: ActivityQuery
		do {
		    __value = try methodReturnValue(.m_activityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for activityQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for activityQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func bloodPressureQuery() -> BloodPressureQuery {
        addInvocation(.m_bloodPressureQuery)
		let perform = methodPerformValue(.m_bloodPressureQuery) as? () -> Void
		perform?()
		var __value: BloodPressureQuery
		do {
		    __value = try methodReturnValue(.m_bloodPressureQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for bloodPressureQuery(). Use given")
			Failure("Stub return value not specified for bloodPressureQuery(). Use given")
		}
		return __value
    }

    open func bloodPressureQuery(_ parts: [BooleanExpressionPart]) throws -> BloodPressureQuery {
        addInvocation(.m_bloodPressureQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_bloodPressureQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: BloodPressureQuery
		do {
		    __value = try methodReturnValue(.m_bloodPressureQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for bloodPressureQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for bloodPressureQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func bmiQuery() -> BodyMassIndexQuery {
        addInvocation(.m_bmiQuery)
		let perform = methodPerformValue(.m_bmiQuery) as? () -> Void
		perform?()
		var __value: BodyMassIndexQuery
		do {
		    __value = try methodReturnValue(.m_bmiQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for bmiQuery(). Use given")
			Failure("Stub return value not specified for bmiQuery(). Use given")
		}
		return __value
    }

    open func bmiQuery(_ parts: [BooleanExpressionPart]) throws -> BodyMassIndexQuery {
        addInvocation(.m_bmiQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_bmiQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: BodyMassIndexQuery
		do {
		    __value = try methodReturnValue(.m_bmiQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for bmiQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for bmiQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func heartRateQuery() -> HeartRateQuery {
        addInvocation(.m_heartRateQuery)
		let perform = methodPerformValue(.m_heartRateQuery) as? () -> Void
		perform?()
		var __value: HeartRateQuery
		do {
		    __value = try methodReturnValue(.m_heartRateQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for heartRateQuery(). Use given")
			Failure("Stub return value not specified for heartRateQuery(). Use given")
		}
		return __value
    }

    open func heartRateQuery(_ parts: [BooleanExpressionPart]) throws -> HeartRateQuery {
        addInvocation(.m_heartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_heartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: HeartRateQuery
		do {
		    __value = try methodReturnValue(.m_heartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for heartRateQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for heartRateQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func leanBodyMassQuery() -> LeanBodyMassQuery {
        addInvocation(.m_leanBodyMassQuery)
		let perform = methodPerformValue(.m_leanBodyMassQuery) as? () -> Void
		perform?()
		var __value: LeanBodyMassQuery
		do {
		    __value = try methodReturnValue(.m_leanBodyMassQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for leanBodyMassQuery(). Use given")
			Failure("Stub return value not specified for leanBodyMassQuery(). Use given")
		}
		return __value
    }

    open func leanBodyMassQuery(_ parts: [BooleanExpressionPart]) throws -> LeanBodyMassQuery {
        addInvocation(.m_leanBodyMassQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_leanBodyMassQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: LeanBodyMassQuery
		do {
		    __value = try methodReturnValue(.m_leanBodyMassQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for leanBodyMassQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for leanBodyMassQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func medicationDoseQuery() -> MedicationDoseQuery {
        addInvocation(.m_medicationDoseQuery)
		let perform = methodPerformValue(.m_medicationDoseQuery) as? () -> Void
		perform?()
		var __value: MedicationDoseQuery
		do {
		    __value = try methodReturnValue(.m_medicationDoseQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for medicationDoseQuery(). Use given")
			Failure("Stub return value not specified for medicationDoseQuery(). Use given")
		}
		return __value
    }

    open func medicationDoseQuery(_ parts: [BooleanExpressionPart]) throws -> MedicationDoseQuery {
        addInvocation(.m_medicationDoseQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_medicationDoseQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: MedicationDoseQuery
		do {
		    __value = try methodReturnValue(.m_medicationDoseQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for medicationDoseQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for medicationDoseQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func moodQuery() -> MoodQuery {
        addInvocation(.m_moodQuery)
		let perform = methodPerformValue(.m_moodQuery) as? () -> Void
		perform?()
		var __value: MoodQuery
		do {
		    __value = try methodReturnValue(.m_moodQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for moodQuery(). Use given")
			Failure("Stub return value not specified for moodQuery(). Use given")
		}
		return __value
    }

    open func moodQuery(_ parts: [BooleanExpressionPart]) throws -> MoodQuery {
        addInvocation(.m_moodQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_moodQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: MoodQuery
		do {
		    __value = try methodReturnValue(.m_moodQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for moodQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for moodQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func restingHeartRateQuery() -> RestingHeartRateQuery {
        addInvocation(.m_restingHeartRateQuery)
		let perform = methodPerformValue(.m_restingHeartRateQuery) as? () -> Void
		perform?()
		var __value: RestingHeartRateQuery
		do {
		    __value = try methodReturnValue(.m_restingHeartRateQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for restingHeartRateQuery(). Use given")
			Failure("Stub return value not specified for restingHeartRateQuery(). Use given")
		}
		return __value
    }

    open func restingHeartRateQuery(_ parts: [BooleanExpressionPart]) throws -> RestingHeartRateQuery {
        addInvocation(.m_restingHeartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_restingHeartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: RestingHeartRateQuery
		do {
		    __value = try methodReturnValue(.m_restingHeartRateQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for restingHeartRateQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for restingHeartRateQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func sexualActivityQuery() -> SexualActivityQuery {
        addInvocation(.m_sexualActivityQuery)
		let perform = methodPerformValue(.m_sexualActivityQuery) as? () -> Void
		perform?()
		var __value: SexualActivityQuery
		do {
		    __value = try methodReturnValue(.m_sexualActivityQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sexualActivityQuery(). Use given")
			Failure("Stub return value not specified for sexualActivityQuery(). Use given")
		}
		return __value
    }

    open func sexualActivityQuery(_ parts: [BooleanExpressionPart]) throws -> SexualActivityQuery {
        addInvocation(.m_sexualActivityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_sexualActivityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: SexualActivityQuery
		do {
		    __value = try methodReturnValue(.m_sexualActivityQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for sexualActivityQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for sexualActivityQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func sleepQuery() -> SleepQuery {
        addInvocation(.m_sleepQuery)
		let perform = methodPerformValue(.m_sleepQuery) as? () -> Void
		perform?()
		var __value: SleepQuery
		do {
		    __value = try methodReturnValue(.m_sleepQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sleepQuery(). Use given")
			Failure("Stub return value not specified for sleepQuery(). Use given")
		}
		return __value
    }

    open func sleepQuery(_ parts: [BooleanExpressionPart]) throws -> SleepQuery {
        addInvocation(.m_sleepQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_sleepQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: SleepQuery
		do {
		    __value = try methodReturnValue(.m_sleepQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for sleepQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for sleepQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func weightQuery() -> WeightQuery {
        addInvocation(.m_weightQuery)
		let perform = methodPerformValue(.m_weightQuery) as? () -> Void
		perform?()
		var __value: WeightQuery
		do {
		    __value = try methodReturnValue(.m_weightQuery).casted()
		} catch {
			onFatalFailure("Stub return value not specified for weightQuery(). Use given")
			Failure("Stub return value not specified for weightQuery(). Use given")
		}
		return __value
    }

    open func weightQuery(_ parts: [BooleanExpressionPart]) throws -> WeightQuery {
        addInvocation(.m_weightQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`)))
		let perform = methodPerformValue(.m_weightQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))) as? ([BooleanExpressionPart]) -> Void
		perform?(`parts`)
		var __value: WeightQuery
		do {
		    __value = try methodReturnValue(.m_weightQuery__parts(Parameter<[BooleanExpressionPart]>.value(`parts`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for weightQuery(_ parts: [BooleanExpressionPart]). Use given")
			Failure("Stub return value not specified for weightQuery(_ parts: [BooleanExpressionPart]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func queryFor(_ sampleType: Sample.Type) throws -> Query {
        addInvocation(.m_queryFor__sampleType(Parameter<Sample.Type>.value(`sampleType`)))
		let perform = methodPerformValue(.m_queryFor__sampleType(Parameter<Sample.Type>.value(`sampleType`))) as? (Sample.Type) -> Void
		perform?(`sampleType`)
		var __value: Query
		do {
		    __value = try methodReturnValue(.m_queryFor__sampleType(Parameter<Sample.Type>.value(`sampleType`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for queryFor(_ sampleType: Sample.Type). Use given")
			Failure("Stub return value not specified for queryFor(_ sampleType: Sample.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_activityQuery
        case m_activityQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_bloodPressureQuery
        case m_bloodPressureQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_bmiQuery
        case m_bmiQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_heartRateQuery
        case m_heartRateQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_leanBodyMassQuery
        case m_leanBodyMassQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_medicationDoseQuery
        case m_medicationDoseQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_moodQuery
        case m_moodQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_restingHeartRateQuery
        case m_restingHeartRateQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_sexualActivityQuery
        case m_sexualActivityQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_sleepQuery
        case m_sleepQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_weightQuery
        case m_weightQuery__parts(Parameter<[BooleanExpressionPart]>)
        case m_queryFor__sampleType(Parameter<Sample.Type>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_activityQuery, .m_activityQuery):
                return true 
            case (.m_activityQuery__parts(let lhsParts), .m_activityQuery__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            case (.m_bloodPressureQuery, .m_bloodPressureQuery):
                return true 
            case (.m_bloodPressureQuery__parts(let lhsParts), .m_bloodPressureQuery__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            case (.m_bmiQuery, .m_bmiQuery):
                return true 
            case (.m_bmiQuery__parts(let lhsParts), .m_bmiQuery__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            case (.m_heartRateQuery, .m_heartRateQuery):
                return true 
            case (.m_heartRateQuery__parts(let lhsParts), .m_heartRateQuery__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            case (.m_leanBodyMassQuery, .m_leanBodyMassQuery):
                return true 
            case (.m_leanBodyMassQuery__parts(let lhsParts), .m_leanBodyMassQuery__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            case (.m_medicationDoseQuery, .m_medicationDoseQuery):
                return true 
            case (.m_medicationDoseQuery__parts(let lhsParts), .m_medicationDoseQuery__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            case (.m_moodQuery, .m_moodQuery):
                return true 
            case (.m_moodQuery__parts(let lhsParts), .m_moodQuery__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            case (.m_restingHeartRateQuery, .m_restingHeartRateQuery):
                return true 
            case (.m_restingHeartRateQuery__parts(let lhsParts), .m_restingHeartRateQuery__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            case (.m_sexualActivityQuery, .m_sexualActivityQuery):
                return true 
            case (.m_sexualActivityQuery__parts(let lhsParts), .m_sexualActivityQuery__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            case (.m_sleepQuery, .m_sleepQuery):
                return true 
            case (.m_sleepQuery__parts(let lhsParts), .m_sleepQuery__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            case (.m_weightQuery, .m_weightQuery):
                return true 
            case (.m_weightQuery__parts(let lhsParts), .m_weightQuery__parts(let rhsParts)):
                guard Parameter.compare(lhs: lhsParts, rhs: rhsParts, with: matcher) else { return false } 
                return true 
            case (.m_queryFor__sampleType(let lhsSampletype), .m_queryFor__sampleType(let rhsSampletype)):
                guard Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_activityQuery: return 0
            case let .m_activityQuery__parts(p0): return p0.intValue
            case .m_bloodPressureQuery: return 0
            case let .m_bloodPressureQuery__parts(p0): return p0.intValue
            case .m_bmiQuery: return 0
            case let .m_bmiQuery__parts(p0): return p0.intValue
            case .m_heartRateQuery: return 0
            case let .m_heartRateQuery__parts(p0): return p0.intValue
            case .m_leanBodyMassQuery: return 0
            case let .m_leanBodyMassQuery__parts(p0): return p0.intValue
            case .m_medicationDoseQuery: return 0
            case let .m_medicationDoseQuery__parts(p0): return p0.intValue
            case .m_moodQuery: return 0
            case let .m_moodQuery__parts(p0): return p0.intValue
            case .m_restingHeartRateQuery: return 0
            case let .m_restingHeartRateQuery__parts(p0): return p0.intValue
            case .m_sexualActivityQuery: return 0
            case let .m_sexualActivityQuery__parts(p0): return p0.intValue
            case .m_sleepQuery: return 0
            case let .m_sleepQuery__parts(p0): return p0.intValue
            case .m_weightQuery: return 0
            case let .m_weightQuery__parts(p0): return p0.intValue
            case let .m_queryFor__sampleType(p0): return p0.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func activityQuery(willReturn: ActivityQuery...) -> MethodStub {
            return Given(method: .m_activityQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func activityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: ActivityQuery...) -> MethodStub {
            return Given(method: .m_activityQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func bloodPressureQuery(willReturn: BloodPressureQuery...) -> MethodStub {
            return Given(method: .m_bloodPressureQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func bloodPressureQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: BloodPressureQuery...) -> MethodStub {
            return Given(method: .m_bloodPressureQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func bmiQuery(willReturn: BodyMassIndexQuery...) -> MethodStub {
            return Given(method: .m_bmiQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func bmiQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: BodyMassIndexQuery...) -> MethodStub {
            return Given(method: .m_bmiQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func heartRateQuery(willReturn: HeartRateQuery...) -> MethodStub {
            return Given(method: .m_heartRateQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func heartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: HeartRateQuery...) -> MethodStub {
            return Given(method: .m_heartRateQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func leanBodyMassQuery(willReturn: LeanBodyMassQuery...) -> MethodStub {
            return Given(method: .m_leanBodyMassQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func leanBodyMassQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: LeanBodyMassQuery...) -> MethodStub {
            return Given(method: .m_leanBodyMassQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func medicationDoseQuery(willReturn: MedicationDoseQuery...) -> MethodStub {
            return Given(method: .m_medicationDoseQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func medicationDoseQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: MedicationDoseQuery...) -> MethodStub {
            return Given(method: .m_medicationDoseQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func moodQuery(willReturn: MoodQuery...) -> MethodStub {
            return Given(method: .m_moodQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func moodQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: MoodQuery...) -> MethodStub {
            return Given(method: .m_moodQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func restingHeartRateQuery(willReturn: RestingHeartRateQuery...) -> MethodStub {
            return Given(method: .m_restingHeartRateQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func restingHeartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: RestingHeartRateQuery...) -> MethodStub {
            return Given(method: .m_restingHeartRateQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sexualActivityQuery(willReturn: SexualActivityQuery...) -> MethodStub {
            return Given(method: .m_sexualActivityQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sexualActivityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: SexualActivityQuery...) -> MethodStub {
            return Given(method: .m_sexualActivityQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sleepQuery(willReturn: SleepQuery...) -> MethodStub {
            return Given(method: .m_sleepQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sleepQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: SleepQuery...) -> MethodStub {
            return Given(method: .m_sleepQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func weightQuery(willReturn: WeightQuery...) -> MethodStub {
            return Given(method: .m_weightQuery, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func weightQuery(_ parts: Parameter<[BooleanExpressionPart]>, willReturn: WeightQuery...) -> MethodStub {
            return Given(method: .m_weightQuery__parts(`parts`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func queryFor(_ sampleType: Parameter<Sample.Type>, willReturn: Query...) -> MethodStub {
            return Given(method: .m_queryFor__sampleType(`sampleType`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func activityQuery(willProduce: (Stubber<ActivityQuery>) -> Void) -> MethodStub {
            let willReturn: [ActivityQuery] = []
			let given: Given = { return Given(method: .m_activityQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (ActivityQuery).self)
			willProduce(stubber)
			return given
        }
        public static func bloodPressureQuery(willProduce: (Stubber<BloodPressureQuery>) -> Void) -> MethodStub {
            let willReturn: [BloodPressureQuery] = []
			let given: Given = { return Given(method: .m_bloodPressureQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (BloodPressureQuery).self)
			willProduce(stubber)
			return given
        }
        public static func bmiQuery(willProduce: (Stubber<BodyMassIndexQuery>) -> Void) -> MethodStub {
            let willReturn: [BodyMassIndexQuery] = []
			let given: Given = { return Given(method: .m_bmiQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (BodyMassIndexQuery).self)
			willProduce(stubber)
			return given
        }
        public static func heartRateQuery(willProduce: (Stubber<HeartRateQuery>) -> Void) -> MethodStub {
            let willReturn: [HeartRateQuery] = []
			let given: Given = { return Given(method: .m_heartRateQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (HeartRateQuery).self)
			willProduce(stubber)
			return given
        }
        public static func leanBodyMassQuery(willProduce: (Stubber<LeanBodyMassQuery>) -> Void) -> MethodStub {
            let willReturn: [LeanBodyMassQuery] = []
			let given: Given = { return Given(method: .m_leanBodyMassQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (LeanBodyMassQuery).self)
			willProduce(stubber)
			return given
        }
        public static func medicationDoseQuery(willProduce: (Stubber<MedicationDoseQuery>) -> Void) -> MethodStub {
            let willReturn: [MedicationDoseQuery] = []
			let given: Given = { return Given(method: .m_medicationDoseQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (MedicationDoseQuery).self)
			willProduce(stubber)
			return given
        }
        public static func moodQuery(willProduce: (Stubber<MoodQuery>) -> Void) -> MethodStub {
            let willReturn: [MoodQuery] = []
			let given: Given = { return Given(method: .m_moodQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (MoodQuery).self)
			willProduce(stubber)
			return given
        }
        public static func restingHeartRateQuery(willProduce: (Stubber<RestingHeartRateQuery>) -> Void) -> MethodStub {
            let willReturn: [RestingHeartRateQuery] = []
			let given: Given = { return Given(method: .m_restingHeartRateQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (RestingHeartRateQuery).self)
			willProduce(stubber)
			return given
        }
        public static func sexualActivityQuery(willProduce: (Stubber<SexualActivityQuery>) -> Void) -> MethodStub {
            let willReturn: [SexualActivityQuery] = []
			let given: Given = { return Given(method: .m_sexualActivityQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SexualActivityQuery).self)
			willProduce(stubber)
			return given
        }
        public static func sleepQuery(willProduce: (Stubber<SleepQuery>) -> Void) -> MethodStub {
            let willReturn: [SleepQuery] = []
			let given: Given = { return Given(method: .m_sleepQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SleepQuery).self)
			willProduce(stubber)
			return given
        }
        public static func weightQuery(willProduce: (Stubber<WeightQuery>) -> Void) -> MethodStub {
            let willReturn: [WeightQuery] = []
			let given: Given = { return Given(method: .m_weightQuery, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (WeightQuery).self)
			willProduce(stubber)
			return given
        }
        public static func activityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_activityQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func activityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<ActivityQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_activityQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ActivityQuery).self)
			willProduce(stubber)
			return given
        }
        public static func bloodPressureQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_bloodPressureQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func bloodPressureQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<BloodPressureQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_bloodPressureQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (BloodPressureQuery).self)
			willProduce(stubber)
			return given
        }
        public static func bmiQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_bmiQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func bmiQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<BodyMassIndexQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_bmiQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (BodyMassIndexQuery).self)
			willProduce(stubber)
			return given
        }
        public static func heartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_heartRateQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func heartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<HeartRateQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_heartRateQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (HeartRateQuery).self)
			willProduce(stubber)
			return given
        }
        public static func leanBodyMassQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_leanBodyMassQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func leanBodyMassQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<LeanBodyMassQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_leanBodyMassQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (LeanBodyMassQuery).self)
			willProduce(stubber)
			return given
        }
        public static func medicationDoseQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_medicationDoseQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func medicationDoseQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<MedicationDoseQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_medicationDoseQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (MedicationDoseQuery).self)
			willProduce(stubber)
			return given
        }
        public static func moodQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_moodQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func moodQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<MoodQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_moodQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (MoodQuery).self)
			willProduce(stubber)
			return given
        }
        public static func restingHeartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_restingHeartRateQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func restingHeartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<RestingHeartRateQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_restingHeartRateQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (RestingHeartRateQuery).self)
			willProduce(stubber)
			return given
        }
        public static func sexualActivityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_sexualActivityQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func sexualActivityQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<SexualActivityQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_sexualActivityQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (SexualActivityQuery).self)
			willProduce(stubber)
			return given
        }
        public static func sleepQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_sleepQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func sleepQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<SleepQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_sleepQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (SleepQuery).self)
			willProduce(stubber)
			return given
        }
        public static func weightQuery(_ parts: Parameter<[BooleanExpressionPart]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_weightQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func weightQuery(_ parts: Parameter<[BooleanExpressionPart]>, willProduce: (StubberThrows<WeightQuery>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_weightQuery__parts(`parts`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (WeightQuery).self)
			willProduce(stubber)
			return given
        }
        public static func queryFor(_ sampleType: Parameter<Sample.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_queryFor__sampleType(`sampleType`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func queryFor(_ sampleType: Parameter<Sample.Type>, willProduce: (StubberThrows<Query>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_queryFor__sampleType(`sampleType`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Query).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func activityQuery() -> Verify { return Verify(method: .m_activityQuery)}
        public static func activityQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_activityQuery__parts(`parts`))}
        public static func bloodPressureQuery() -> Verify { return Verify(method: .m_bloodPressureQuery)}
        public static func bloodPressureQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_bloodPressureQuery__parts(`parts`))}
        public static func bmiQuery() -> Verify { return Verify(method: .m_bmiQuery)}
        public static func bmiQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_bmiQuery__parts(`parts`))}
        public static func heartRateQuery() -> Verify { return Verify(method: .m_heartRateQuery)}
        public static func heartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_heartRateQuery__parts(`parts`))}
        public static func leanBodyMassQuery() -> Verify { return Verify(method: .m_leanBodyMassQuery)}
        public static func leanBodyMassQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_leanBodyMassQuery__parts(`parts`))}
        public static func medicationDoseQuery() -> Verify { return Verify(method: .m_medicationDoseQuery)}
        public static func medicationDoseQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_medicationDoseQuery__parts(`parts`))}
        public static func moodQuery() -> Verify { return Verify(method: .m_moodQuery)}
        public static func moodQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_moodQuery__parts(`parts`))}
        public static func restingHeartRateQuery() -> Verify { return Verify(method: .m_restingHeartRateQuery)}
        public static func restingHeartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_restingHeartRateQuery__parts(`parts`))}
        public static func sexualActivityQuery() -> Verify { return Verify(method: .m_sexualActivityQuery)}
        public static func sexualActivityQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_sexualActivityQuery__parts(`parts`))}
        public static func sleepQuery() -> Verify { return Verify(method: .m_sleepQuery)}
        public static func sleepQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_sleepQuery__parts(`parts`))}
        public static func weightQuery() -> Verify { return Verify(method: .m_weightQuery)}
        public static func weightQuery(_ parts: Parameter<[BooleanExpressionPart]>) -> Verify { return Verify(method: .m_weightQuery__parts(`parts`))}
        public static func queryFor(_ sampleType: Parameter<Sample.Type>) -> Verify { return Verify(method: .m_queryFor__sampleType(`sampleType`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func activityQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_activityQuery, performs: perform)
        }
        public static func activityQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_activityQuery__parts(`parts`), performs: perform)
        }
        public static func bloodPressureQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_bloodPressureQuery, performs: perform)
        }
        public static func bloodPressureQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_bloodPressureQuery__parts(`parts`), performs: perform)
        }
        public static func bmiQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_bmiQuery, performs: perform)
        }
        public static func bmiQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_bmiQuery__parts(`parts`), performs: perform)
        }
        public static func heartRateQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_heartRateQuery, performs: perform)
        }
        public static func heartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_heartRateQuery__parts(`parts`), performs: perform)
        }
        public static func leanBodyMassQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_leanBodyMassQuery, performs: perform)
        }
        public static func leanBodyMassQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_leanBodyMassQuery__parts(`parts`), performs: perform)
        }
        public static func medicationDoseQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_medicationDoseQuery, performs: perform)
        }
        public static func medicationDoseQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_medicationDoseQuery__parts(`parts`), performs: perform)
        }
        public static func moodQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_moodQuery, performs: perform)
        }
        public static func moodQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_moodQuery__parts(`parts`), performs: perform)
        }
        public static func restingHeartRateQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_restingHeartRateQuery, performs: perform)
        }
        public static func restingHeartRateQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_restingHeartRateQuery__parts(`parts`), performs: perform)
        }
        public static func sexualActivityQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sexualActivityQuery, performs: perform)
        }
        public static func sexualActivityQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_sexualActivityQuery__parts(`parts`), performs: perform)
        }
        public static func sleepQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sleepQuery, performs: perform)
        }
        public static func sleepQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_sleepQuery__parts(`parts`), performs: perform)
        }
        public static func weightQuery(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_weightQuery, performs: perform)
        }
        public static func weightQuery(_ parts: Parameter<[BooleanExpressionPart]>, perform: @escaping ([BooleanExpressionPart]) -> Void) -> Perform {
            return Perform(method: .m_weightQuery__parts(`parts`), performs: perform)
        }
        public static func queryFor(_ sampleType: Parameter<Sample.Type>, perform: @escaping (Sample.Type) -> Void) -> Perform {
            return Perform(method: .m_queryFor__sampleType(`sampleType`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - RestingHeartRateQuery
open class RestingHeartRateQueryMock: RestingHeartRateQuery, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "RestingHeartRateQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "RestingHeartRateQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "RestingHeartRateQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - SampleFactory
open class SampleFactoryMock: SampleFactory, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func allTypes() -> [Sample.Type] {
        addInvocation(.m_allTypes)
		let perform = methodPerformValue(.m_allTypes) as? () -> Void
		perform?()
		var __value: [Sample.Type]
		do {
		    __value = try methodReturnValue(.m_allTypes).casted()
		} catch {
			onFatalFailure("Stub return value not specified for allTypes(). Use given")
			Failure("Stub return value not specified for allTypes(). Use given")
		}
		return __value
    }

    open func healthKitTypes() -> [HealthKitSample.Type] {
        addInvocation(.m_healthKitTypes)
		let perform = methodPerformValue(.m_healthKitTypes) as? () -> Void
		perform?()
		var __value: [HealthKitSample.Type]
		do {
		    __value = try methodReturnValue(.m_healthKitTypes).casted()
		} catch {
			onFatalFailure("Stub return value not specified for healthKitTypes(). Use given")
			Failure("Stub return value not specified for healthKitTypes(). Use given")
		}
		return __value
    }

    open func activity(using transaction: Transaction) throws -> Activity {
        addInvocation(.m_activity__using_transaction(Parameter<Transaction>.value(`transaction`)))
		let perform = methodPerformValue(.m_activity__using_transaction(Parameter<Transaction>.value(`transaction`))) as? (Transaction) -> Void
		perform?(`transaction`)
		var __value: Activity
		do {
		    __value = try methodReturnValue(.m_activity__using_transaction(Parameter<Transaction>.value(`transaction`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for activity(using transaction: Transaction). Use given")
			Failure("Stub return value not specified for activity(using transaction: Transaction). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func heartRate(_ value: Double, _ date: Date) -> HeartRate {
        addInvocation(.m_heartRate__value_date(Parameter<Double>.value(`value`), Parameter<Date>.value(`date`)))
		let perform = methodPerformValue(.m_heartRate__value_date(Parameter<Double>.value(`value`), Parameter<Date>.value(`date`))) as? (Double, Date) -> Void
		perform?(`value`, `date`)
		var __value: HeartRate
		do {
		    __value = try methodReturnValue(.m_heartRate__value_date(Parameter<Double>.value(`value`), Parameter<Date>.value(`date`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for heartRate(_ value: Double, _ date: Date). Use given")
			Failure("Stub return value not specified for heartRate(_ value: Double, _ date: Date). Use given")
		}
		return __value
    }

    open func heartRate(value: Double) -> HeartRate {
        addInvocation(.m_heartRate__value_value(Parameter<Double>.value(`value`)))
		let perform = methodPerformValue(.m_heartRate__value_value(Parameter<Double>.value(`value`))) as? (Double) -> Void
		perform?(`value`)
		var __value: HeartRate
		do {
		    __value = try methodReturnValue(.m_heartRate__value_value(Parameter<Double>.value(`value`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for heartRate(value: Double). Use given")
			Failure("Stub return value not specified for heartRate(value: Double). Use given")
		}
		return __value
    }

    open func heartRate(_ sample: HKQuantitySample) -> HeartRate {
        addInvocation(.m_heartRate__sample(Parameter<HKQuantitySample>.value(`sample`)))
		let perform = methodPerformValue(.m_heartRate__sample(Parameter<HKQuantitySample>.value(`sample`))) as? (HKQuantitySample) -> Void
		perform?(`sample`)
		var __value: HeartRate
		do {
		    __value = try methodReturnValue(.m_heartRate__sample(Parameter<HKQuantitySample>.value(`sample`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for heartRate(_ sample: HKQuantitySample). Use given")
			Failure("Stub return value not specified for heartRate(_ sample: HKQuantitySample). Use given")
		}
		return __value
    }

    open func medicationDose(using transaction: Transaction) throws -> MedicationDose {
        addInvocation(.m_medicationDose__using_transaction(Parameter<Transaction>.value(`transaction`)))
		let perform = methodPerformValue(.m_medicationDose__using_transaction(Parameter<Transaction>.value(`transaction`))) as? (Transaction) -> Void
		perform?(`transaction`)
		var __value: MedicationDose
		do {
		    __value = try methodReturnValue(.m_medicationDose__using_transaction(Parameter<Transaction>.value(`transaction`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for medicationDose(using transaction: Transaction). Use given")
			Failure("Stub return value not specified for medicationDose(using transaction: Transaction). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func mood(using transaction: Transaction) throws -> Mood {
        addInvocation(.m_mood__using_transaction(Parameter<Transaction>.value(`transaction`)))
		let perform = methodPerformValue(.m_mood__using_transaction(Parameter<Transaction>.value(`transaction`))) as? (Transaction) -> Void
		perform?(`transaction`)
		var __value: Mood
		do {
		    __value = try methodReturnValue(.m_mood__using_transaction(Parameter<Transaction>.value(`transaction`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for mood(using transaction: Transaction). Use given")
			Failure("Stub return value not specified for mood(using transaction: Transaction). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_allTypes
        case m_healthKitTypes
        case m_activity__using_transaction(Parameter<Transaction>)
        case m_heartRate__value_date(Parameter<Double>, Parameter<Date>)
        case m_heartRate__value_value(Parameter<Double>)
        case m_heartRate__sample(Parameter<HKQuantitySample>)
        case m_medicationDose__using_transaction(Parameter<Transaction>)
        case m_mood__using_transaction(Parameter<Transaction>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_allTypes, .m_allTypes):
                return true 
            case (.m_healthKitTypes, .m_healthKitTypes):
                return true 
            case (.m_activity__using_transaction(let lhsTransaction), .m_activity__using_transaction(let rhsTransaction)):
                guard Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher) else { return false } 
                return true 
            case (.m_heartRate__value_date(let lhsValue, let lhsDate), .m_heartRate__value_date(let rhsValue, let rhsDate)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher) else { return false } 
                return true 
            case (.m_heartRate__value_value(let lhsValue), .m_heartRate__value_value(let rhsValue)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_heartRate__sample(let lhsSample), .m_heartRate__sample(let rhsSample)):
                guard Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher) else { return false } 
                return true 
            case (.m_medicationDose__using_transaction(let lhsTransaction), .m_medicationDose__using_transaction(let rhsTransaction)):
                guard Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher) else { return false } 
                return true 
            case (.m_mood__using_transaction(let lhsTransaction), .m_mood__using_transaction(let rhsTransaction)):
                guard Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_allTypes: return 0
            case .m_healthKitTypes: return 0
            case let .m_activity__using_transaction(p0): return p0.intValue
            case let .m_heartRate__value_date(p0, p1): return p0.intValue + p1.intValue
            case let .m_heartRate__value_value(p0): return p0.intValue
            case let .m_heartRate__sample(p0): return p0.intValue
            case let .m_medicationDose__using_transaction(p0): return p0.intValue
            case let .m_mood__using_transaction(p0): return p0.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func allTypes(willReturn: [Sample.Type]...) -> MethodStub {
            return Given(method: .m_allTypes, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func healthKitTypes(willReturn: [HealthKitSample.Type]...) -> MethodStub {
            return Given(method: .m_healthKitTypes, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func activity(using transaction: Parameter<Transaction>, willReturn: Activity...) -> MethodStub {
            return Given(method: .m_activity__using_transaction(`transaction`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func heartRate(_ value: Parameter<Double>, _ date: Parameter<Date>, willReturn: HeartRate...) -> MethodStub {
            return Given(method: .m_heartRate__value_date(`value`, `date`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func heartRate(value: Parameter<Double>, willReturn: HeartRate...) -> MethodStub {
            return Given(method: .m_heartRate__value_value(`value`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func heartRate(_ sample: Parameter<HKQuantitySample>, willReturn: HeartRate...) -> MethodStub {
            return Given(method: .m_heartRate__sample(`sample`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func medicationDose(using transaction: Parameter<Transaction>, willReturn: MedicationDose...) -> MethodStub {
            return Given(method: .m_medicationDose__using_transaction(`transaction`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func mood(using transaction: Parameter<Transaction>, willReturn: Mood...) -> MethodStub {
            return Given(method: .m_mood__using_transaction(`transaction`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func allTypes(willProduce: (Stubber<[Sample.Type]>) -> Void) -> MethodStub {
            let willReturn: [[Sample.Type]] = []
			let given: Given = { return Given(method: .m_allTypes, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([Sample.Type]).self)
			willProduce(stubber)
			return given
        }
        public static func healthKitTypes(willProduce: (Stubber<[HealthKitSample.Type]>) -> Void) -> MethodStub {
            let willReturn: [[HealthKitSample.Type]] = []
			let given: Given = { return Given(method: .m_healthKitTypes, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([HealthKitSample.Type]).self)
			willProduce(stubber)
			return given
        }
        public static func heartRate(_ value: Parameter<Double>, _ date: Parameter<Date>, willProduce: (Stubber<HeartRate>) -> Void) -> MethodStub {
            let willReturn: [HeartRate] = []
			let given: Given = { return Given(method: .m_heartRate__value_date(`value`, `date`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (HeartRate).self)
			willProduce(stubber)
			return given
        }
        public static func heartRate(value: Parameter<Double>, willProduce: (Stubber<HeartRate>) -> Void) -> MethodStub {
            let willReturn: [HeartRate] = []
			let given: Given = { return Given(method: .m_heartRate__value_value(`value`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (HeartRate).self)
			willProduce(stubber)
			return given
        }
        public static func heartRate(_ sample: Parameter<HKQuantitySample>, willProduce: (Stubber<HeartRate>) -> Void) -> MethodStub {
            let willReturn: [HeartRate] = []
			let given: Given = { return Given(method: .m_heartRate__sample(`sample`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (HeartRate).self)
			willProduce(stubber)
			return given
        }
        public static func activity(using transaction: Parameter<Transaction>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_activity__using_transaction(`transaction`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func activity(using transaction: Parameter<Transaction>, willProduce: (StubberThrows<Activity>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_activity__using_transaction(`transaction`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Activity).self)
			willProduce(stubber)
			return given
        }
        public static func medicationDose(using transaction: Parameter<Transaction>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_medicationDose__using_transaction(`transaction`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func medicationDose(using transaction: Parameter<Transaction>, willProduce: (StubberThrows<MedicationDose>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_medicationDose__using_transaction(`transaction`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (MedicationDose).self)
			willProduce(stubber)
			return given
        }
        public static func mood(using transaction: Parameter<Transaction>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_mood__using_transaction(`transaction`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func mood(using transaction: Parameter<Transaction>, willProduce: (StubberThrows<Mood>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_mood__using_transaction(`transaction`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Mood).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func allTypes() -> Verify { return Verify(method: .m_allTypes)}
        public static func healthKitTypes() -> Verify { return Verify(method: .m_healthKitTypes)}
        public static func activity(using transaction: Parameter<Transaction>) -> Verify { return Verify(method: .m_activity__using_transaction(`transaction`))}
        public static func heartRate(_ value: Parameter<Double>, _ date: Parameter<Date>) -> Verify { return Verify(method: .m_heartRate__value_date(`value`, `date`))}
        public static func heartRate(value: Parameter<Double>) -> Verify { return Verify(method: .m_heartRate__value_value(`value`))}
        public static func heartRate(_ sample: Parameter<HKQuantitySample>) -> Verify { return Verify(method: .m_heartRate__sample(`sample`))}
        public static func medicationDose(using transaction: Parameter<Transaction>) -> Verify { return Verify(method: .m_medicationDose__using_transaction(`transaction`))}
        public static func mood(using transaction: Parameter<Transaction>) -> Verify { return Verify(method: .m_mood__using_transaction(`transaction`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func allTypes(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_allTypes, performs: perform)
        }
        public static func healthKitTypes(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_healthKitTypes, performs: perform)
        }
        public static func activity(using transaction: Parameter<Transaction>, perform: @escaping (Transaction) -> Void) -> Perform {
            return Perform(method: .m_activity__using_transaction(`transaction`), performs: perform)
        }
        public static func heartRate(_ value: Parameter<Double>, _ date: Parameter<Date>, perform: @escaping (Double, Date) -> Void) -> Perform {
            return Perform(method: .m_heartRate__value_date(`value`, `date`), performs: perform)
        }
        public static func heartRate(value: Parameter<Double>, perform: @escaping (Double) -> Void) -> Perform {
            return Perform(method: .m_heartRate__value_value(`value`), performs: perform)
        }
        public static func heartRate(_ sample: Parameter<HKQuantitySample>, perform: @escaping (HKQuantitySample) -> Void) -> Perform {
            return Perform(method: .m_heartRate__sample(`sample`), performs: perform)
        }
        public static func medicationDose(using transaction: Parameter<Transaction>, perform: @escaping (Transaction) -> Void) -> Perform {
            return Perform(method: .m_medicationDose__using_transaction(`transaction`), performs: perform)
        }
        public static func mood(using transaction: Parameter<Transaction>, perform: @escaping (Transaction) -> Void) -> Perform {
            return Perform(method: .m_mood__using_transaction(`transaction`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - SampleGrouperFactory
open class SampleGrouperFactoryMock: SampleGrouperFactory, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_typesFor__sampleType_sampleType(let lhsSampletype), .m_typesFor__sampleType_sampleType(let rhsSampletype)):
                guard Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher) else { return false } 
                return true 
            case (.m_typesFor__attributes_attributes(let lhsAttributes), .m_typesFor__attributes_attributes(let rhsAttributes)):
                guard Parameter.compare(lhs: lhsAttributes, rhs: rhsAttributes, with: matcher) else { return false } 
                return true 
            case (.m_groupersFor__sampleType_sampleType(let lhsSampletype), .m_groupersFor__sampleType_sampleType(let rhsSampletype)):
                guard Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher) else { return false } 
                return true 
            case (.m_groupersFor__attributes_attributes(let lhsAttributes), .m_groupersFor__attributes_attributes(let rhsAttributes)):
                guard Parameter.compare(lhs: lhsAttributes, rhs: rhsAttributes, with: matcher) else { return false } 
                return true 
            case (.m_groupDefinition__sampleType(let lhsSampletype), .m_groupDefinition__sampleType(let rhsSampletype)):
                guard Parameter.compare(lhs: lhsSampletype, rhs: rhsSampletype, with: matcher) else { return false } 
                return true 
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - SampleUtil
open class SampleUtilMock: SampleUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func getOnly(samples: [Sample], from startDate: Date?, to endDate: Date?) -> [Sample] {
        addInvocation(.m_getOnly__samples_samplesfrom_startDateto_endDate_1(Parameter<[Sample]>.value(`samples`), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`)))
		let perform = methodPerformValue(.m_getOnly__samples_samplesfrom_startDateto_endDate_1(Parameter<[Sample]>.value(`samples`), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`))) as? ([Sample], Date?, Date?) -> Void
		perform?(`samples`, `startDate`, `endDate`)
		var __value: [Sample]
		do {
		    __value = try methodReturnValue(.m_getOnly__samples_samplesfrom_startDateto_endDate_1(Parameter<[Sample]>.value(`samples`), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getOnly(samples: [Sample], from startDate: Date?, to endDate: Date?). Use given")
			Failure("Stub return value not specified for getOnly(samples: [Sample], from startDate: Date?, to endDate: Date?). Use given")
		}
		return __value
    }

    open func getOnly<SampleType: Sample>(samples: [SampleType], from startDate: Date?, to endDate: Date?) -> [SampleType] {
        addInvocation(.m_getOnly__samples_samplesfrom_startDateto_endDate_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`)))
		let perform = methodPerformValue(.m_getOnly__samples_samplesfrom_startDateto_endDate_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`))) as? ([SampleType], Date?, Date?) -> Void
		perform?(`samples`, `startDate`, `endDate`)
		var __value: [SampleType]
		do {
		    __value = try methodReturnValue(.m_getOnly__samples_samplesfrom_startDateto_endDate_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getOnly<SampleType: Sample>(samples: [SampleType], from startDate: Date?, to endDate: Date?). Use given")
			Failure("Stub return value not specified for getOnly<SampleType: Sample>(samples: [SampleType], from startDate: Date?, to endDate: Date?). Use given")
		}
		return __value
    }

    open func sample(_ sample: Sample, occursOnOneOf daysOfWeek: Set<DayOfWeek>) -> Bool {
        addInvocation(.m_sample__sampleoccursOnOneOf_daysOfWeek(Parameter<Sample>.value(`sample`), Parameter<Set<DayOfWeek>>.value(`daysOfWeek`)))
		let perform = methodPerformValue(.m_sample__sampleoccursOnOneOf_daysOfWeek(Parameter<Sample>.value(`sample`), Parameter<Set<DayOfWeek>>.value(`daysOfWeek`))) as? (Sample, Set<DayOfWeek>) -> Void
		perform?(`sample`, `daysOfWeek`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_sample__sampleoccursOnOneOf_daysOfWeek(Parameter<Sample>.value(`sample`), Parameter<Set<DayOfWeek>>.value(`daysOfWeek`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sample(_ sample: Sample, occursOnOneOf daysOfWeek: Set<DayOfWeek>). Use given")
			Failure("Stub return value not specified for sample(_ sample: Sample, occursOnOneOf daysOfWeek: Set<DayOfWeek>). Use given")
		}
		return __value
    }

    open func aggregate(samples: [Sample], by aggregationUnit: Calendar.Component, for attribute: Attribute) throws -> [Date: [Sample]] {
        addInvocation(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`))) as? ([Sample], Calendar.Component, Attribute) -> Void
		perform?(`samples`, `aggregationUnit`, `attribute`)
		var __value: [Date: [Sample]]
		do {
		    __value = try methodReturnValue(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for aggregate(samples: [Sample], by aggregationUnit: Calendar.Component, for attribute: Attribute). Use given")
			Failure("Stub return value not specified for aggregate(samples: [Sample], by aggregationUnit: Calendar.Component, for attribute: Attribute). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func aggregate<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component, for attribute: Attribute) throws -> [Date: [SampleType]] {
        addInvocation(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`))) as? ([SampleType], Calendar.Component, Attribute) -> Void
		perform?(`samples`, `aggregationUnit`, `attribute`)
		var __value: [Date: [SampleType]]
		do {
		    __value = try methodReturnValue(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for aggregate<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component, for attribute: Attribute). Use given")
			Failure("Stub return value not specified for aggregate<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component, for attribute: Attribute). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func sort(samples: [Sample], by aggregationUnit: Calendar.Component) throws -> [(date: Date, samples: [Sample])] {
        addInvocation(.m_sort__samples_samplesby_aggregationUnit_1(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component>.value(`aggregationUnit`)))
		let perform = methodPerformValue(.m_sort__samples_samplesby_aggregationUnit_1(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component>.value(`aggregationUnit`))) as? ([Sample], Calendar.Component) -> Void
		perform?(`samples`, `aggregationUnit`)
		var __value: [(date: Date, samples: [Sample])]
		do {
		    __value = try methodReturnValue(.m_sort__samples_samplesby_aggregationUnit_1(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component>.value(`aggregationUnit`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for sort(samples: [Sample], by aggregationUnit: Calendar.Component). Use given")
			Failure("Stub return value not specified for sort(samples: [Sample], by aggregationUnit: Calendar.Component). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func sort<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component) throws -> [(date: Date, samples: [SampleType])] {
        addInvocation(.m_sort__samples_samplesby_aggregationUnit_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`)))
		let perform = methodPerformValue(.m_sort__samples_samplesby_aggregationUnit_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`))) as? ([SampleType], Calendar.Component) -> Void
		perform?(`samples`, `aggregationUnit`)
		var __value: [(date: Date, samples: [SampleType])]
		do {
		    __value = try methodReturnValue(.m_sort__samples_samplesby_aggregationUnit_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for sort<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component). Use given")
			Failure("Stub return value not specified for sort<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func sort(samples: [Sample], by dateType: DateType, in order: ComparisonResult) -> [Sample] {
        addInvocation(.m_sort__samples_samplesby_dateTypein_order_1(Parameter<[Sample]>.value(`samples`), Parameter<DateType>.value(`dateType`), Parameter<ComparisonResult>.value(`order`)))
		let perform = methodPerformValue(.m_sort__samples_samplesby_dateTypein_order_1(Parameter<[Sample]>.value(`samples`), Parameter<DateType>.value(`dateType`), Parameter<ComparisonResult>.value(`order`))) as? ([Sample], DateType, ComparisonResult) -> Void
		perform?(`samples`, `dateType`, `order`)
		var __value: [Sample]
		do {
		    __value = try methodReturnValue(.m_sort__samples_samplesby_dateTypein_order_1(Parameter<[Sample]>.value(`samples`), Parameter<DateType>.value(`dateType`), Parameter<ComparisonResult>.value(`order`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sort(samples: [Sample], by dateType: DateType, in order: ComparisonResult). Use given")
			Failure("Stub return value not specified for sort(samples: [Sample], by dateType: DateType, in order: ComparisonResult). Use given")
		}
		return __value
    }

    open func sort<SampleType: Sample>(samples: [SampleType], by dateType: DateType, in order: ComparisonResult) -> [SampleType] {
        addInvocation(.m_sort__samples_samplesby_dateTypein_order_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<DateType>.value(`dateType`), Parameter<ComparisonResult>.value(`order`)))
		let perform = methodPerformValue(.m_sort__samples_samplesby_dateTypein_order_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<DateType>.value(`dateType`), Parameter<ComparisonResult>.value(`order`))) as? ([SampleType], DateType, ComparisonResult) -> Void
		perform?(`samples`, `dateType`, `order`)
		var __value: [SampleType]
		do {
		    __value = try methodReturnValue(.m_sort__samples_samplesby_dateTypein_order_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<DateType>.value(`dateType`), Parameter<ComparisonResult>.value(`order`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sort<SampleType: Sample>(samples: [SampleType], by dateType: DateType, in order: ComparisonResult). Use given")
			Failure("Stub return value not specified for sort<SampleType: Sample>(samples: [SampleType], by dateType: DateType, in order: ComparisonResult). Use given")
		}
		return __value
    }

    open func convertOneDateSamplesToTwoDateSamples(_ samples: [Sample], samplesShouldNotBeJoined: (Sample, Sample) -> Bool, joinSamples: ([Sample], Date, Date) -> Sample) -> [Sample] {
        addInvocation(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(Parameter<[Sample]>.value(`samples`), Parameter<(Sample, Sample) -> Bool>.any, Parameter<([Sample], Date, Date) -> Sample>.any))
		let perform = methodPerformValue(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(Parameter<[Sample]>.value(`samples`), Parameter<(Sample, Sample) -> Bool>.any, Parameter<([Sample], Date, Date) -> Sample>.any)) as? ([Sample], (Sample, Sample) -> Bool, ([Sample], Date, Date) -> Sample) -> Void
		perform?(`samples`, `samplesShouldNotBeJoined`, `joinSamples`)
		var __value: [Sample]
		do {
		    __value = try methodReturnValue(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(Parameter<[Sample]>.value(`samples`), Parameter<(Sample, Sample) -> Bool>.any, Parameter<([Sample], Date, Date) -> Sample>.any)).casted()
		} catch {
			onFatalFailure("Stub return value not specified for convertOneDateSamplesToTwoDateSamples(_ samples: [Sample], samplesShouldNotBeJoined: (Sample, Sample) -> Bool, joinSamples: ([Sample], Date, Date) -> Sample). Use given")
			Failure("Stub return value not specified for convertOneDateSamplesToTwoDateSamples(_ samples: [Sample], samplesShouldNotBeJoined: (Sample, Sample) -> Bool, joinSamples: ([Sample], Date, Date) -> Sample). Use given")
		}
		return __value
    }

    open func convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(_ samples: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType) -> [SampleType] {
        addInvocation(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<(SampleType, SampleType) -> Bool>.any.wrapAsGeneric(), Parameter<([SampleType], Date, Date) -> SampleType>.any.wrapAsGeneric()))
		let perform = methodPerformValue(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<(SampleType, SampleType) -> Bool>.any.wrapAsGeneric(), Parameter<([SampleType], Date, Date) -> SampleType>.any.wrapAsGeneric())) as? ([SampleType], (SampleType, SampleType) -> Bool, ([SampleType], Date, Date) -> SampleType) -> Void
		perform?(`samples`, `samplesShouldNotBeJoined`, `joinSamples`)
		var __value: [SampleType]
		do {
		    __value = try methodReturnValue(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<(SampleType, SampleType) -> Bool>.any.wrapAsGeneric(), Parameter<([SampleType], Date, Date) -> SampleType>.any.wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(_ samples: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType). Use given")
			Failure("Stub return value not specified for convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(_ samples: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType). Use given")
		}
		return __value
    }

    open func closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(sample: SampleType1, in samples: [SampleType2]) -> SampleType2 {
        addInvocation(.m_closestInTimeTo__sample_samplein_samples_1(Parameter<SampleType1>.value(`sample`).wrapAsGeneric(), Parameter<[SampleType2]>.value(`samples`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_closestInTimeTo__sample_samplein_samples_1(Parameter<SampleType1>.value(`sample`).wrapAsGeneric(), Parameter<[SampleType2]>.value(`samples`).wrapAsGeneric())) as? (SampleType1, [SampleType2]) -> Void
		perform?(`sample`, `samples`)
		var __value: SampleType2
		do {
		    __value = try methodReturnValue(.m_closestInTimeTo__sample_samplein_samples_1(Parameter<SampleType1>.value(`sample`).wrapAsGeneric(), Parameter<[SampleType2]>.value(`samples`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(sample: SampleType1, in samples: [SampleType2]). Use given")
			Failure("Stub return value not specified for closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(sample: SampleType1, in samples: [SampleType2]). Use given")
		}
		return __value
    }

    open func closestInTimeTo(sample: Sample, in samples: [Sample]) -> Sample {
        addInvocation(.m_closestInTimeTo__sample_samplein_samples_2(Parameter<Sample>.value(`sample`), Parameter<[Sample]>.value(`samples`)))
		let perform = methodPerformValue(.m_closestInTimeTo__sample_samplein_samples_2(Parameter<Sample>.value(`sample`), Parameter<[Sample]>.value(`samples`))) as? (Sample, [Sample]) -> Void
		perform?(`sample`, `samples`)
		var __value: Sample
		do {
		    __value = try methodReturnValue(.m_closestInTimeTo__sample_samplein_samples_2(Parameter<Sample>.value(`sample`), Parameter<[Sample]>.value(`samples`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for closestInTimeTo(sample: Sample, in samples: [Sample]). Use given")
			Failure("Stub return value not specified for closestInTimeTo(sample: Sample, in samples: [Sample]). Use given")
		}
		return __value
    }

    open func distance(between sample1: Sample, and sample2: Sample, in unit: Calendar.Component) -> Int {
        addInvocation(.m_distance__between_sample1and_sample2in_unit(Parameter<Sample>.value(`sample1`), Parameter<Sample>.value(`sample2`), Parameter<Calendar.Component>.value(`unit`)))
		let perform = methodPerformValue(.m_distance__between_sample1and_sample2in_unit(Parameter<Sample>.value(`sample1`), Parameter<Sample>.value(`sample2`), Parameter<Calendar.Component>.value(`unit`))) as? (Sample, Sample, Calendar.Component) -> Void
		perform?(`sample1`, `sample2`, `unit`)
		var __value: Int
		do {
		    __value = try methodReturnValue(.m_distance__between_sample1and_sample2in_unit(Parameter<Sample>.value(`sample1`), Parameter<Sample>.value(`sample2`), Parameter<Calendar.Component>.value(`unit`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for distance(between sample1: Sample, and sample2: Sample, in unit: Calendar.Component). Use given")
			Failure("Stub return value not specified for distance(between sample1: Sample, and sample2: Sample, in unit: Calendar.Component). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getOnly__samples_samplesfrom_startDateto_endDate_1(Parameter<[Sample]>, Parameter<Date?>, Parameter<Date?>)
        case m_getOnly__samples_samplesfrom_startDateto_endDate_2(Parameter<GenericAttribute>, Parameter<Date?>, Parameter<Date?>)
        case m_sample__sampleoccursOnOneOf_daysOfWeek(Parameter<Sample>, Parameter<Set<DayOfWeek>>)
        case m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(Parameter<[Sample]>, Parameter<Calendar.Component>, Parameter<Attribute>)
        case m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(Parameter<GenericAttribute>, Parameter<Calendar.Component>, Parameter<Attribute>)
        case m_sort__samples_samplesby_aggregationUnit_1(Parameter<[Sample]>, Parameter<Calendar.Component>)
        case m_sort__samples_samplesby_aggregationUnit_2(Parameter<GenericAttribute>, Parameter<Calendar.Component>)
        case m_sort__samples_samplesby_dateTypein_order_1(Parameter<[Sample]>, Parameter<DateType>, Parameter<ComparisonResult>)
        case m_sort__samples_samplesby_dateTypein_order_2(Parameter<GenericAttribute>, Parameter<DateType>, Parameter<ComparisonResult>)
        case m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(Parameter<[Sample]>, Parameter<(Sample, Sample) -> Bool>, Parameter<([Sample], Date, Date) -> Sample>)
        case m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(Parameter<GenericAttribute>, Parameter<GenericAttribute>, Parameter<GenericAttribute>)
        case m_closestInTimeTo__sample_samplein_samples_1(Parameter<GenericAttribute>, Parameter<GenericAttribute>)
        case m_closestInTimeTo__sample_samplein_samples_2(Parameter<Sample>, Parameter<[Sample]>)
        case m_distance__between_sample1and_sample2in_unit(Parameter<Sample>, Parameter<Sample>, Parameter<Calendar.Component>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_getOnly__samples_samplesfrom_startDateto_endDate_1(let lhsSamples, let lhsStartdate, let lhsEnddate), .m_getOnly__samples_samplesfrom_startDateto_endDate_1(let rhsSamples, let rhsStartdate, let rhsEnddate)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher) else { return false } 
                return true 
            case (.m_getOnly__samples_samplesfrom_startDateto_endDate_2(let lhsSamples, let lhsStartdate, let lhsEnddate), .m_getOnly__samples_samplesfrom_startDateto_endDate_2(let rhsSamples, let rhsStartdate, let rhsEnddate)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher) else { return false } 
                return true 
            case (.m_sample__sampleoccursOnOneOf_daysOfWeek(let lhsSample, let lhsDaysofweek), .m_sample__sampleoccursOnOneOf_daysOfWeek(let rhsSample, let rhsDaysofweek)):
                guard Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDaysofweek, rhs: rhsDaysofweek, with: matcher) else { return false } 
                return true 
            case (.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(let lhsSamples, let lhsAggregationunit, let lhsAttribute), .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(let rhsSamples, let rhsAggregationunit, let rhsAttribute)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                return true 
            case (.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(let lhsSamples, let lhsAggregationunit, let lhsAttribute), .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(let rhsSamples, let rhsAggregationunit, let rhsAttribute)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher) else { return false } 
                return true 
            case (.m_sort__samples_samplesby_aggregationUnit_1(let lhsSamples, let lhsAggregationunit), .m_sort__samples_samplesby_aggregationUnit_1(let rhsSamples, let rhsAggregationunit)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                return true 
            case (.m_sort__samples_samplesby_aggregationUnit_2(let lhsSamples, let lhsAggregationunit), .m_sort__samples_samplesby_aggregationUnit_2(let rhsSamples, let rhsAggregationunit)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher) else { return false } 
                return true 
            case (.m_sort__samples_samplesby_dateTypein_order_1(let lhsSamples, let lhsDatetype, let lhsOrder), .m_sort__samples_samplesby_dateTypein_order_1(let rhsSamples, let rhsDatetype, let rhsOrder)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDatetype, rhs: rhsDatetype, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsOrder, rhs: rhsOrder, with: matcher) else { return false } 
                return true 
            case (.m_sort__samples_samplesby_dateTypein_order_2(let lhsSamples, let lhsDatetype, let lhsOrder), .m_sort__samples_samplesby_dateTypein_order_2(let rhsSamples, let rhsDatetype, let rhsOrder)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDatetype, rhs: rhsDatetype, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsOrder, rhs: rhsOrder, with: matcher) else { return false } 
                return true 
            case (.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(let lhsSamples, let lhsSamplesshouldnotbejoined, let lhsJoinsamples), .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(let rhsSamples, let rhsSamplesshouldnotbejoined, let rhsJoinsamples)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamplesshouldnotbejoined, rhs: rhsSamplesshouldnotbejoined, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsJoinsamples, rhs: rhsJoinsamples, with: matcher) else { return false } 
                return true 
            case (.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(let lhsSamples, let lhsSamplesshouldnotbejoined, let lhsJoinsamples), .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(let rhsSamples, let rhsSamplesshouldnotbejoined, let rhsJoinsamples)):
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamplesshouldnotbejoined, rhs: rhsSamplesshouldnotbejoined, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsJoinsamples, rhs: rhsJoinsamples, with: matcher) else { return false } 
                return true 
            case (.m_closestInTimeTo__sample_samplein_samples_1(let lhsSample, let lhsSamples), .m_closestInTimeTo__sample_samplein_samples_1(let rhsSample, let rhsSamples)):
                guard Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                return true 
            case (.m_closestInTimeTo__sample_samplein_samples_2(let lhsSample, let lhsSamples), .m_closestInTimeTo__sample_samplein_samples_2(let rhsSample, let rhsSamples)):
                guard Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher) else { return false } 
                return true 
            case (.m_distance__between_sample1and_sample2in_unit(let lhsSample1, let lhsSample2, let lhsUnit), .m_distance__between_sample1and_sample2in_unit(let rhsSample1, let rhsSample2, let rhsUnit)):
                guard Parameter.compare(lhs: lhsSample1, rhs: rhsSample1, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSample2, rhs: rhsSample2, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsUnit, rhs: rhsUnit, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getOnly__samples_samplesfrom_startDateto_endDate_1(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_getOnly__samples_samplesfrom_startDateto_endDate_2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_sample__sampleoccursOnOneOf_daysOfWeek(p0, p1): return p0.intValue + p1.intValue
            case let .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_sort__samples_samplesby_aggregationUnit_1(p0, p1): return p0.intValue + p1.intValue
            case let .m_sort__samples_samplesby_aggregationUnit_2(p0, p1): return p0.intValue + p1.intValue
            case let .m_sort__samples_samplesby_dateTypein_order_1(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_sort__samples_samplesby_dateTypein_order_2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_closestInTimeTo__sample_samplein_samples_1(p0, p1): return p0.intValue + p1.intValue
            case let .m_closestInTimeTo__sample_samplein_samples_2(p0, p1): return p0.intValue + p1.intValue
            case let .m_distance__between_sample1and_sample2in_unit(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getOnly(samples: Parameter<[Sample]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, willReturn: [Sample]...) -> MethodStub {
            return Given(method: .m_getOnly__samples_samplesfrom_startDateto_endDate_1(`samples`, `startDate`, `endDate`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getOnly<SampleType: Sample>(samples: Parameter<[SampleType]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, willReturn: [SampleType]...) -> MethodStub {
            return Given(method: .m_getOnly__samples_samplesfrom_startDateto_endDate_2(`samples`.wrapAsGeneric(), `startDate`, `endDate`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sample(_ sample: Parameter<Sample>, occursOnOneOf daysOfWeek: Parameter<Set<DayOfWeek>>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_sample__sampleoccursOnOneOf_daysOfWeek(`sample`, `daysOfWeek`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func aggregate(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, for attribute: Parameter<Attribute>, willReturn: [Date: [Sample]]...) -> MethodStub {
            return Given(method: .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(`samples`, `aggregationUnit`, `attribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func aggregate<SampleType: Sample>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, for attribute: Parameter<Attribute>, willReturn: [Date: [SampleType]]...) -> MethodStub {
            return Given(method: .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(`samples`.wrapAsGeneric(), `aggregationUnit`, `attribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sort(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, willReturn: [(date: Date, samples: [Sample])]...) -> MethodStub {
            return Given(method: .m_sort__samples_samplesby_aggregationUnit_1(`samples`, `aggregationUnit`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sort<SampleType: Sample>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, willReturn: [(date: Date, samples: [SampleType])]...) -> MethodStub {
            return Given(method: .m_sort__samples_samplesby_aggregationUnit_2(`samples`.wrapAsGeneric(), `aggregationUnit`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sort(samples: Parameter<[Sample]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>, willReturn: [Sample]...) -> MethodStub {
            return Given(method: .m_sort__samples_samplesby_dateTypein_order_1(`samples`, `dateType`, `order`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sort<SampleType: Sample>(samples: Parameter<[SampleType]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>, willReturn: [SampleType]...) -> MethodStub {
            return Given(method: .m_sort__samples_samplesby_dateTypein_order_2(`samples`.wrapAsGeneric(), `dateType`, `order`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func convertOneDateSamplesToTwoDateSamples(_ samples: Parameter<[Sample]>, samplesShouldNotBeJoined: Parameter<(Sample, Sample) -> Bool>, joinSamples: Parameter<([Sample], Date, Date) -> Sample>, willReturn: [Sample]...) -> MethodStub {
            return Given(method: .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(`samples`, `samplesShouldNotBeJoined`, `joinSamples`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(_ samples: Parameter<[SampleType]>, samplesShouldNotBeJoined: Parameter<(SampleType, SampleType) -> Bool>, joinSamples: Parameter<([SampleType], Date, Date) -> SampleType>, willReturn: [SampleType]...) -> MethodStub {
            return Given(method: .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(`samples`.wrapAsGeneric(), `samplesShouldNotBeJoined`.wrapAsGeneric(), `joinSamples`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(sample: Parameter<SampleType1>, in samples: Parameter<[SampleType2]>, willReturn: SampleType2...) -> MethodStub {
            return Given(method: .m_closestInTimeTo__sample_samplein_samples_1(`sample`.wrapAsGeneric(), `samples`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func closestInTimeTo(sample: Parameter<Sample>, in samples: Parameter<[Sample]>, willReturn: Sample...) -> MethodStub {
            return Given(method: .m_closestInTimeTo__sample_samplein_samples_2(`sample`, `samples`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func distance(between sample1: Parameter<Sample>, and sample2: Parameter<Sample>, in unit: Parameter<Calendar.Component>, willReturn: Int...) -> MethodStub {
            return Given(method: .m_distance__between_sample1and_sample2in_unit(`sample1`, `sample2`, `unit`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getOnly(samples: Parameter<[Sample]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, willProduce: (Stubber<[Sample]>) -> Void) -> MethodStub {
            let willReturn: [[Sample]] = []
			let given: Given = { return Given(method: .m_getOnly__samples_samplesfrom_startDateto_endDate_1(`samples`, `startDate`, `endDate`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([Sample]).self)
			willProduce(stubber)
			return given
        }
        public static func getOnly<SampleType: Sample>(samples: Parameter<[SampleType]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, willProduce: (Stubber<[SampleType]>) -> Void) -> MethodStub {
            let willReturn: [[SampleType]] = []
			let given: Given = { return Given(method: .m_getOnly__samples_samplesfrom_startDateto_endDate_2(`samples`.wrapAsGeneric(), `startDate`, `endDate`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([SampleType]).self)
			willProduce(stubber)
			return given
        }
        public static func sample(_ sample: Parameter<Sample>, occursOnOneOf daysOfWeek: Parameter<Set<DayOfWeek>>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_sample__sampleoccursOnOneOf_daysOfWeek(`sample`, `daysOfWeek`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func sort(samples: Parameter<[Sample]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>, willProduce: (Stubber<[Sample]>) -> Void) -> MethodStub {
            let willReturn: [[Sample]] = []
			let given: Given = { return Given(method: .m_sort__samples_samplesby_dateTypein_order_1(`samples`, `dateType`, `order`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([Sample]).self)
			willProduce(stubber)
			return given
        }
        public static func sort<SampleType: Sample>(samples: Parameter<[SampleType]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>, willProduce: (Stubber<[SampleType]>) -> Void) -> MethodStub {
            let willReturn: [[SampleType]] = []
			let given: Given = { return Given(method: .m_sort__samples_samplesby_dateTypein_order_2(`samples`.wrapAsGeneric(), `dateType`, `order`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([SampleType]).self)
			willProduce(stubber)
			return given
        }
        public static func convertOneDateSamplesToTwoDateSamples(_ samples: Parameter<[Sample]>, samplesShouldNotBeJoined: Parameter<(Sample, Sample) -> Bool>, joinSamples: Parameter<([Sample], Date, Date) -> Sample>, willProduce: (Stubber<[Sample]>) -> Void) -> MethodStub {
            let willReturn: [[Sample]] = []
			let given: Given = { return Given(method: .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(`samples`, `samplesShouldNotBeJoined`, `joinSamples`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([Sample]).self)
			willProduce(stubber)
			return given
        }
        public static func convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(_ samples: Parameter<[SampleType]>, samplesShouldNotBeJoined: Parameter<(SampleType, SampleType) -> Bool>, joinSamples: Parameter<([SampleType], Date, Date) -> SampleType>, willProduce: (Stubber<[SampleType]>) -> Void) -> MethodStub {
            let willReturn: [[SampleType]] = []
			let given: Given = { return Given(method: .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(`samples`.wrapAsGeneric(), `samplesShouldNotBeJoined`.wrapAsGeneric(), `joinSamples`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([SampleType]).self)
			willProduce(stubber)
			return given
        }
        public static func closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(sample: Parameter<SampleType1>, in samples: Parameter<[SampleType2]>, willProduce: (Stubber<SampleType2>) -> Void) -> MethodStub {
            let willReturn: [SampleType2] = []
			let given: Given = { return Given(method: .m_closestInTimeTo__sample_samplein_samples_1(`sample`.wrapAsGeneric(), `samples`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SampleType2).self)
			willProduce(stubber)
			return given
        }
        public static func closestInTimeTo(sample: Parameter<Sample>, in samples: Parameter<[Sample]>, willProduce: (Stubber<Sample>) -> Void) -> MethodStub {
            let willReturn: [Sample] = []
			let given: Given = { return Given(method: .m_closestInTimeTo__sample_samplein_samples_2(`sample`, `samples`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Sample).self)
			willProduce(stubber)
			return given
        }
        public static func distance(between sample1: Parameter<Sample>, and sample2: Parameter<Sample>, in unit: Parameter<Calendar.Component>, willProduce: (Stubber<Int>) -> Void) -> MethodStub {
            let willReturn: [Int] = []
			let given: Given = { return Given(method: .m_distance__between_sample1and_sample2in_unit(`sample1`, `sample2`, `unit`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Int).self)
			willProduce(stubber)
			return given
        }
        public static func aggregate(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, for attribute: Parameter<Attribute>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(`samples`, `aggregationUnit`, `attribute`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func aggregate(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, for attribute: Parameter<Attribute>, willProduce: (StubberThrows<[Date: [Sample]]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(`samples`, `aggregationUnit`, `attribute`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Date: [Sample]]).self)
			willProduce(stubber)
			return given
        }
        public static func aggregate<SampleType: Sample>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, for attribute: Parameter<Attribute>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(`samples`.wrapAsGeneric(), `aggregationUnit`, `attribute`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func aggregate<SampleType: Sample>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, for attribute: Parameter<Attribute>, willProduce: (StubberThrows<[Date: [SampleType]]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(`samples`.wrapAsGeneric(), `aggregationUnit`, `attribute`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Date: [SampleType]]).self)
			willProduce(stubber)
			return given
        }
        public static func sort(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_sort__samples_samplesby_aggregationUnit_1(`samples`, `aggregationUnit`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func sort(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, willProduce: (StubberThrows<[(date: Date, samples: [Sample])]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_sort__samples_samplesby_aggregationUnit_1(`samples`, `aggregationUnit`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(date: Date, samples: [Sample])]).self)
			willProduce(stubber)
			return given
        }
        public static func sort<SampleType: Sample>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_sort__samples_samplesby_aggregationUnit_2(`samples`.wrapAsGeneric(), `aggregationUnit`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func sort<SampleType: Sample>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, willProduce: (StubberThrows<[(date: Date, samples: [SampleType])]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_sort__samples_samplesby_aggregationUnit_2(`samples`.wrapAsGeneric(), `aggregationUnit`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(date: Date, samples: [SampleType])]).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getOnly(samples: Parameter<[Sample]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>) -> Verify { return Verify(method: .m_getOnly__samples_samplesfrom_startDateto_endDate_1(`samples`, `startDate`, `endDate`))}
        public static func getOnly<SampleType>(samples: Parameter<[SampleType]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>) -> Verify where SampleType:Sample { return Verify(method: .m_getOnly__samples_samplesfrom_startDateto_endDate_2(`samples`.wrapAsGeneric(), `startDate`, `endDate`))}
        public static func sample(_ sample: Parameter<Sample>, occursOnOneOf daysOfWeek: Parameter<Set<DayOfWeek>>) -> Verify { return Verify(method: .m_sample__sampleoccursOnOneOf_daysOfWeek(`sample`, `daysOfWeek`))}
        public static func aggregate(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, for attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(`samples`, `aggregationUnit`, `attribute`))}
        public static func aggregate<SampleType>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, for attribute: Parameter<Attribute>) -> Verify where SampleType:Sample { return Verify(method: .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(`samples`.wrapAsGeneric(), `aggregationUnit`, `attribute`))}
        public static func sort(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>) -> Verify { return Verify(method: .m_sort__samples_samplesby_aggregationUnit_1(`samples`, `aggregationUnit`))}
        public static func sort<SampleType>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>) -> Verify where SampleType:Sample { return Verify(method: .m_sort__samples_samplesby_aggregationUnit_2(`samples`.wrapAsGeneric(), `aggregationUnit`))}
        public static func sort(samples: Parameter<[Sample]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>) -> Verify { return Verify(method: .m_sort__samples_samplesby_dateTypein_order_1(`samples`, `dateType`, `order`))}
        public static func sort<SampleType>(samples: Parameter<[SampleType]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>) -> Verify where SampleType:Sample { return Verify(method: .m_sort__samples_samplesby_dateTypein_order_2(`samples`.wrapAsGeneric(), `dateType`, `order`))}
        public static func convertOneDateSamplesToTwoDateSamples(_ samples: Parameter<[Sample]>, samplesShouldNotBeJoined: Parameter<(Sample, Sample) -> Bool>, joinSamples: Parameter<([Sample], Date, Date) -> Sample>) -> Verify { return Verify(method: .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(`samples`, `samplesShouldNotBeJoined`, `joinSamples`))}
        public static func convertOneDateSamplesToTwoDateSamples<SampleType>(_ samples: Parameter<[SampleType]>, samplesShouldNotBeJoined: Parameter<(SampleType, SampleType) -> Bool>, joinSamples: Parameter<([SampleType], Date, Date) -> SampleType>) -> Verify where SampleType:Sample { return Verify(method: .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(`samples`.wrapAsGeneric(), `samplesShouldNotBeJoined`.wrapAsGeneric(), `joinSamples`.wrapAsGeneric()))}
        public static func closestInTimeTo<SampleType1,SampleType2>(sample: Parameter<SampleType1>, in samples: Parameter<[SampleType2]>) -> Verify where SampleType1:Sample, SampleType2:Sample { return Verify(method: .m_closestInTimeTo__sample_samplein_samples_1(`sample`.wrapAsGeneric(), `samples`.wrapAsGeneric()))}
        public static func closestInTimeTo(sample: Parameter<Sample>, in samples: Parameter<[Sample]>) -> Verify { return Verify(method: .m_closestInTimeTo__sample_samplein_samples_2(`sample`, `samples`))}
        public static func distance(between sample1: Parameter<Sample>, and sample2: Parameter<Sample>, in unit: Parameter<Calendar.Component>) -> Verify { return Verify(method: .m_distance__between_sample1and_sample2in_unit(`sample1`, `sample2`, `unit`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getOnly(samples: Parameter<[Sample]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, perform: @escaping ([Sample], Date?, Date?) -> Void) -> Perform {
            return Perform(method: .m_getOnly__samples_samplesfrom_startDateto_endDate_1(`samples`, `startDate`, `endDate`), performs: perform)
        }
        public static func getOnly<SampleType>(samples: Parameter<[SampleType]>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, perform: @escaping ([SampleType], Date?, Date?) -> Void) -> Perform where SampleType:Sample {
            return Perform(method: .m_getOnly__samples_samplesfrom_startDateto_endDate_2(`samples`.wrapAsGeneric(), `startDate`, `endDate`), performs: perform)
        }
        public static func sample(_ sample: Parameter<Sample>, occursOnOneOf daysOfWeek: Parameter<Set<DayOfWeek>>, perform: @escaping (Sample, Set<DayOfWeek>) -> Void) -> Perform {
            return Perform(method: .m_sample__sampleoccursOnOneOf_daysOfWeek(`sample`, `daysOfWeek`), performs: perform)
        }
        public static func aggregate(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, for attribute: Parameter<Attribute>, perform: @escaping ([Sample], Calendar.Component, Attribute) -> Void) -> Perform {
            return Perform(method: .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(`samples`, `aggregationUnit`, `attribute`), performs: perform)
        }
        public static func aggregate<SampleType>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, for attribute: Parameter<Attribute>, perform: @escaping ([SampleType], Calendar.Component, Attribute) -> Void) -> Perform where SampleType:Sample {
            return Perform(method: .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(`samples`.wrapAsGeneric(), `aggregationUnit`, `attribute`), performs: perform)
        }
        public static func sort(samples: Parameter<[Sample]>, by aggregationUnit: Parameter<Calendar.Component>, perform: @escaping ([Sample], Calendar.Component) -> Void) -> Perform {
            return Perform(method: .m_sort__samples_samplesby_aggregationUnit_1(`samples`, `aggregationUnit`), performs: perform)
        }
        public static func sort<SampleType>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, perform: @escaping ([SampleType], Calendar.Component) -> Void) -> Perform where SampleType:Sample {
            return Perform(method: .m_sort__samples_samplesby_aggregationUnit_2(`samples`.wrapAsGeneric(), `aggregationUnit`), performs: perform)
        }
        public static func sort(samples: Parameter<[Sample]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>, perform: @escaping ([Sample], DateType, ComparisonResult) -> Void) -> Perform {
            return Perform(method: .m_sort__samples_samplesby_dateTypein_order_1(`samples`, `dateType`, `order`), performs: perform)
        }
        public static func sort<SampleType>(samples: Parameter<[SampleType]>, by dateType: Parameter<DateType>, in order: Parameter<ComparisonResult>, perform: @escaping ([SampleType], DateType, ComparisonResult) -> Void) -> Perform where SampleType:Sample {
            return Perform(method: .m_sort__samples_samplesby_dateTypein_order_2(`samples`.wrapAsGeneric(), `dateType`, `order`), performs: perform)
        }
        public static func convertOneDateSamplesToTwoDateSamples(_ samples: Parameter<[Sample]>, samplesShouldNotBeJoined: Parameter<(Sample, Sample) -> Bool>, joinSamples: Parameter<([Sample], Date, Date) -> Sample>, perform: @escaping ([Sample], (Sample, Sample) -> Bool, ([Sample], Date, Date) -> Sample) -> Void) -> Perform {
            return Perform(method: .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(`samples`, `samplesShouldNotBeJoined`, `joinSamples`), performs: perform)
        }
        public static func convertOneDateSamplesToTwoDateSamples<SampleType>(_ samples: Parameter<[SampleType]>, samplesShouldNotBeJoined: Parameter<(SampleType, SampleType) -> Bool>, joinSamples: Parameter<([SampleType], Date, Date) -> SampleType>, perform: @escaping ([SampleType], (SampleType, SampleType) -> Bool, ([SampleType], Date, Date) -> SampleType) -> Void) -> Perform where SampleType:Sample {
            return Perform(method: .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(`samples`.wrapAsGeneric(), `samplesShouldNotBeJoined`.wrapAsGeneric(), `joinSamples`.wrapAsGeneric()), performs: perform)
        }
        public static func closestInTimeTo<SampleType1,SampleType2>(sample: Parameter<SampleType1>, in samples: Parameter<[SampleType2]>, perform: @escaping (SampleType1, [SampleType2]) -> Void) -> Perform where SampleType1:Sample, SampleType2:Sample {
            return Perform(method: .m_closestInTimeTo__sample_samplein_samples_1(`sample`.wrapAsGeneric(), `samples`.wrapAsGeneric()), performs: perform)
        }
        public static func closestInTimeTo(sample: Parameter<Sample>, in samples: Parameter<[Sample]>, perform: @escaping (Sample, [Sample]) -> Void) -> Perform {
            return Perform(method: .m_closestInTimeTo__sample_samplein_samples_2(`sample`, `samples`), performs: perform)
        }
        public static func distance(between sample1: Parameter<Sample>, and sample2: Parameter<Sample>, in unit: Parameter<Calendar.Component>, perform: @escaping (Sample, Sample, Calendar.Component) -> Void) -> Perform {
            return Perform(method: .m_distance__between_sample1and_sample2in_unit(`sample1`, `sample2`, `unit`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - SearchUtil
open class SearchUtilMock: SearchUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func binarySearch<T:Comparable>(for targetItem: T, in items: Array<T>) -> Int? {
        addInvocation(.m_binarySearch__for_targetItemin_items(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<Array<T>>.value(`items`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_binarySearch__for_targetItemin_items(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<Array<T>>.value(`items`).wrapAsGeneric())) as? (T, Array<T>) -> Void
		perform?(`targetItem`, `items`)
		var __value: Int? = nil
		do {
		    __value = try methodReturnValue(.m_binarySearch__for_targetItemin_items(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<Array<T>>.value(`items`).wrapAsGeneric())).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func binarySearch<T>(for targetItem: T, in items: Array<T>, compare: (T, T) -> ComparisonResult) -> Int? {
        addInvocation(.m_binarySearch__for_targetItemin_itemscompare_compare(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<Array<T>>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> ComparisonResult>.any.wrapAsGeneric()))
		let perform = methodPerformValue(.m_binarySearch__for_targetItemin_itemscompare_compare(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<Array<T>>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> ComparisonResult>.any.wrapAsGeneric())) as? (T, Array<T>, (T, T) -> ComparisonResult) -> Void
		perform?(`targetItem`, `items`, `compare`)
		var __value: Int? = nil
		do {
		    __value = try methodReturnValue(.m_binarySearch__for_targetItemin_itemscompare_compare(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<Array<T>>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> ComparisonResult>.any.wrapAsGeneric())).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func closestItem<T>(to targetItem: T, in items: Array<T>, distance: (T, T) -> Int) -> T {
        addInvocation(.m_closestItem__to_targetItemin_itemsdistance_distance(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<Array<T>>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> Int>.any.wrapAsGeneric()))
		let perform = methodPerformValue(.m_closestItem__to_targetItemin_itemsdistance_distance(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<Array<T>>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> Int>.any.wrapAsGeneric())) as? (T, Array<T>, (T, T) -> Int) -> Void
		perform?(`targetItem`, `items`, `distance`)
		var __value: T
		do {
		    __value = try methodReturnValue(.m_closestItem__to_targetItemin_itemsdistance_distance(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<Array<T>>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> Int>.any.wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for closestItem<T>(to targetItem: T, in items: Array<T>, distance: (T, T) -> Int). Use given")
			Failure("Stub return value not specified for closestItem<T>(to targetItem: T, in items: Array<T>, distance: (T, T) -> Int). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_binarySearch__for_targetItemin_items(Parameter<GenericAttribute>, Parameter<GenericAttribute>)
        case m_binarySearch__for_targetItemin_itemscompare_compare(Parameter<GenericAttribute>, Parameter<GenericAttribute>, Parameter<GenericAttribute>)
        case m_closestItem__to_targetItemin_itemsdistance_distance(Parameter<GenericAttribute>, Parameter<GenericAttribute>, Parameter<GenericAttribute>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_binarySearch__for_targetItemin_items(let lhsTargetitem, let lhsItems), .m_binarySearch__for_targetItemin_items(let rhsTargetitem, let rhsItems)):
                guard Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher) else { return false } 
                return true 
            case (.m_binarySearch__for_targetItemin_itemscompare_compare(let lhsTargetitem, let lhsItems, let lhsCompare), .m_binarySearch__for_targetItemin_itemscompare_compare(let rhsTargetitem, let rhsItems, let rhsCompare)):
                guard Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsCompare, rhs: rhsCompare, with: matcher) else { return false } 
                return true 
            case (.m_closestItem__to_targetItemin_itemsdistance_distance(let lhsTargetitem, let lhsItems, let lhsDistance), .m_closestItem__to_targetItemin_itemsdistance_distance(let rhsTargetitem, let rhsItems, let rhsDistance)):
                guard Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsDistance, rhs: rhsDistance, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_binarySearch__for_targetItemin_items(p0, p1): return p0.intValue + p1.intValue
            case let .m_binarySearch__for_targetItemin_itemscompare_compare(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_closestItem__to_targetItemin_itemsdistance_distance(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func binarySearch<T:Comparable>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, willReturn: Int?...) -> MethodStub {
            return Given(method: .m_binarySearch__for_targetItemin_items(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, compare: Parameter<(T, T) -> ComparisonResult>, willReturn: Int?...) -> MethodStub {
            return Given(method: .m_binarySearch__for_targetItemin_itemscompare_compare(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `compare`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func closestItem<T>(to targetItem: Parameter<T>, in items: Parameter<Array<T>>, distance: Parameter<(T, T) -> Int>, willReturn: T...) -> MethodStub {
            return Given(method: .m_closestItem__to_targetItemin_itemsdistance_distance(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `distance`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func binarySearch<T:Comparable>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, willProduce: (Stubber<Int?>) -> Void) -> MethodStub {
            let willReturn: [Int?] = []
			let given: Given = { return Given(method: .m_binarySearch__for_targetItemin_items(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Int?).self)
			willProduce(stubber)
			return given
        }
        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, compare: Parameter<(T, T) -> ComparisonResult>, willProduce: (Stubber<Int?>) -> Void) -> MethodStub {
            let willReturn: [Int?] = []
			let given: Given = { return Given(method: .m_binarySearch__for_targetItemin_itemscompare_compare(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `compare`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Int?).self)
			willProduce(stubber)
			return given
        }
        public static func closestItem<T>(to targetItem: Parameter<T>, in items: Parameter<Array<T>>, distance: Parameter<(T, T) -> Int>, willProduce: (Stubber<T>) -> Void) -> MethodStub {
            let willReturn: [T] = []
			let given: Given = { return Given(method: .m_closestItem__to_targetItemin_itemsdistance_distance(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `distance`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (T).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>) -> Verify where T:Comparable { return Verify(method: .m_binarySearch__for_targetItemin_items(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric()))}
        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, compare: Parameter<(T, T) -> ComparisonResult>) -> Verify { return Verify(method: .m_binarySearch__for_targetItemin_itemscompare_compare(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `compare`.wrapAsGeneric()))}
        public static func closestItem<T>(to targetItem: Parameter<T>, in items: Parameter<Array<T>>, distance: Parameter<(T, T) -> Int>) -> Verify { return Verify(method: .m_closestItem__to_targetItemin_itemsdistance_distance(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `distance`.wrapAsGeneric()))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, perform: @escaping (T, Array<T>) -> Void) -> Perform where T:Comparable {
            return Perform(method: .m_binarySearch__for_targetItemin_items(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric()), performs: perform)
        }
        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<Array<T>>, compare: Parameter<(T, T) -> ComparisonResult>, perform: @escaping (T, Array<T>, (T, T) -> ComparisonResult) -> Void) -> Perform {
            return Perform(method: .m_binarySearch__for_targetItemin_itemscompare_compare(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `compare`.wrapAsGeneric()), performs: perform)
        }
        public static func closestItem<T>(to targetItem: Parameter<T>, in items: Parameter<Array<T>>, distance: Parameter<(T, T) -> Int>, perform: @escaping (T, Array<T>, (T, T) -> Int) -> Void) -> Perform {
            return Perform(method: .m_closestItem__to_targetItemin_itemsdistance_distance(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `distance`.wrapAsGeneric()), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - Settings
open class SettingsMock: Settings, Mock, StaticMock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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
    static var matcher: Matcher = Matcher.default
    static var stubbingPolicy: StubbingPolicy = .wrap
    static var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst
    static private var invocations: [StaticMethodType] = []
    static private var methodReturnValues: [StaticGiven] = []
    static private var methodPerformValues: [StaticPerform] = []
    public typealias StaticPropertyStub = StaticGiven
    public typealias StaticMethodStub = StaticGiven
    public static func clear() {
        invocations = []
        methodReturnValues = []
        methodPerformValues = []
    }

    public var minMood: Double {
		get {	invocations.append(.p_minMood_get); return __p_minMood ?? givenGetterValue(.p_minMood_get, "SettingsMock - stub value for minMood was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_minMood = newValue }
	}
	private var __p_minMood: (Double)?

    public var maxMood: Double {
		get {	invocations.append(.p_maxMood_get); return __p_maxMood ?? givenGetterValue(.p_maxMood_get, "SettingsMock - stub value for maxMood was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_maxMood = newValue }
	}
	private var __p_maxMood: (Double)?

    public var discreteMoods: Bool {
		get {	invocations.append(.p_discreteMoods_get); return __p_discreteMoods ?? givenGetterValue(.p_discreteMoods_get, "SettingsMock - stub value for discreteMoods was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_discreteMoods = newValue }
	}
	private var __p_discreteMoods: (Bool)?

    public var scaleMoodsOnImport: Bool {
		get {	invocations.append(.p_scaleMoodsOnImport_get); return __p_scaleMoodsOnImport ?? givenGetterValue(.p_scaleMoodsOnImport_get, "SettingsMock - stub value for scaleMoodsOnImport was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_scaleMoodsOnImport = newValue }
	}
	private var __p_scaleMoodsOnImport: (Bool)?

    public var autoIgnoreEnabled: Bool {
		get {	invocations.append(.p_autoIgnoreEnabled_get); return __p_autoIgnoreEnabled ?? givenGetterValue(.p_autoIgnoreEnabled_get, "SettingsMock - stub value for autoIgnoreEnabled was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_autoIgnoreEnabled = newValue }
	}
	private var __p_autoIgnoreEnabled: (Bool)?

    public var autoIgnoreSeconds: Int {
		get {	invocations.append(.p_autoIgnoreSeconds_get); return __p_autoIgnoreSeconds ?? givenGetterValue(.p_autoIgnoreSeconds_get, "SettingsMock - stub value for autoIgnoreSeconds was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_autoIgnoreSeconds = newValue }
	}
	private var __p_autoIgnoreSeconds: (Int)?

    public var convertTimeZones: Bool {
		get {	invocations.append(.p_convertTimeZones_get); return __p_convertTimeZones ?? givenGetterValue(.p_convertTimeZones_get, "SettingsMock - stub value for convertTimeZones was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_convertTimeZones = newValue }
	}
	private var __p_convertTimeZones: (Bool)?


    public static var entityName: String {
		get {	SettingsMock.invocations.append(.p_entityName_get); return SettingsMock.__p_entityName ?? givenGetterValue(.p_entityName_get, "SettingsMock - stub value for entityName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	SettingsMock.__p_entityName = newValue }
	}
	private static var __p_entityName: (String)?




    open func setMinMood(_ value: Double) {
        addInvocation(.m_setMinMood__value(Parameter<Double>.value(`value`)))
		let perform = methodPerformValue(.m_setMinMood__value(Parameter<Double>.value(`value`))) as? (Double) -> Void
		perform?(`value`)
    }

    open func setMaxMood(_ value: Double) {
        addInvocation(.m_setMaxMood__value(Parameter<Double>.value(`value`)))
		let perform = methodPerformValue(.m_setMaxMood__value(Parameter<Double>.value(`value`))) as? (Double) -> Void
		perform?(`value`)
    }

    open func setDiscreteMoods(_ value: Bool) {
        addInvocation(.m_setDiscreteMoods__value(Parameter<Bool>.value(`value`)))
		let perform = methodPerformValue(.m_setDiscreteMoods__value(Parameter<Bool>.value(`value`))) as? (Bool) -> Void
		perform?(`value`)
    }

    open func setScaleMoodsOnImport(_ value: Bool) {
        addInvocation(.m_setScaleMoodsOnImport__value(Parameter<Bool>.value(`value`)))
		let perform = methodPerformValue(.m_setScaleMoodsOnImport__value(Parameter<Bool>.value(`value`))) as? (Bool) -> Void
		perform?(`value`)
    }

    open func setAutoIgnoreEnabled(_ value: Bool) {
        addInvocation(.m_setAutoIgnoreEnabled__value(Parameter<Bool>.value(`value`)))
		let perform = methodPerformValue(.m_setAutoIgnoreEnabled__value(Parameter<Bool>.value(`value`))) as? (Bool) -> Void
		perform?(`value`)
    }

    open func setAutoIgnoreSeconds(_ value: Int) {
        addInvocation(.m_setAutoIgnoreSeconds__value(Parameter<Int>.value(`value`)))
		let perform = methodPerformValue(.m_setAutoIgnoreSeconds__value(Parameter<Int>.value(`value`))) as? (Int) -> Void
		perform?(`value`)
    }

    open func setConvertTimeZones(_ value: Bool) {
        addInvocation(.m_setConvertTimeZones__value(Parameter<Bool>.value(`value`)))
		let perform = methodPerformValue(.m_setConvertTimeZones__value(Parameter<Bool>.value(`value`))) as? (Bool) -> Void
		perform?(`value`)
    }

    open func changed(_ setting: Setting) -> Bool {
        addInvocation(.m_changed__setting(Parameter<Setting>.value(`setting`)))
		let perform = methodPerformValue(.m_changed__setting(Parameter<Setting>.value(`setting`))) as? (Setting) -> Void
		perform?(`setting`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_changed__setting(Parameter<Setting>.value(`setting`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for changed(_ setting: Setting). Use given")
			Failure("Stub return value not specified for changed(_ setting: Setting). Use given")
		}
		return __value
    }

    open func reset() {
        addInvocation(.m_reset)
		let perform = methodPerformValue(.m_reset) as? () -> Void
		perform?()
    }

    open func save() throws {
        addInvocation(.m_save)
		let perform = methodPerformValue(.m_save) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_save).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    fileprivate enum StaticMethodType {
        case p_entityName_get

        static func compareParameters(lhs: StaticMethodType, rhs: StaticMethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.p_entityName_get,.p_entityName_get): return true
            }
        }

        func intValue() -> Int {
            switch self {
                case .p_entityName_get: return 0
            }
        }
    }

    open class StaticGiven: StubbedMethod {
        fileprivate var method: StaticMethodType

        private init(method: StaticMethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func entityName(getter defaultValue: String...) -> StaticPropertyStub {
            return StaticGiven(method: .p_entityName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct StaticVerify {
        fileprivate var method: StaticMethodType

        public static var entityName: StaticVerify { return StaticVerify(method: .p_entityName_get) }
    }

    public struct StaticPerform {
        fileprivate var method: StaticMethodType
        var performs: Any

    }

    
    fileprivate enum MethodType {
        case m_setMinMood__value(Parameter<Double>)
        case m_setMaxMood__value(Parameter<Double>)
        case m_setDiscreteMoods__value(Parameter<Bool>)
        case m_setScaleMoodsOnImport__value(Parameter<Bool>)
        case m_setAutoIgnoreEnabled__value(Parameter<Bool>)
        case m_setAutoIgnoreSeconds__value(Parameter<Int>)
        case m_setConvertTimeZones__value(Parameter<Bool>)
        case m_changed__setting(Parameter<Setting>)
        case m_reset
        case m_save
        case p_minMood_get
        case p_maxMood_get
        case p_discreteMoods_get
        case p_scaleMoodsOnImport_get
        case p_autoIgnoreEnabled_get
        case p_autoIgnoreSeconds_get
        case p_convertTimeZones_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_setMinMood__value(let lhsValue), .m_setMinMood__value(let rhsValue)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_setMaxMood__value(let lhsValue), .m_setMaxMood__value(let rhsValue)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_setDiscreteMoods__value(let lhsValue), .m_setDiscreteMoods__value(let rhsValue)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_setScaleMoodsOnImport__value(let lhsValue), .m_setScaleMoodsOnImport__value(let rhsValue)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_setAutoIgnoreEnabled__value(let lhsValue), .m_setAutoIgnoreEnabled__value(let rhsValue)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_setAutoIgnoreSeconds__value(let lhsValue), .m_setAutoIgnoreSeconds__value(let rhsValue)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_setConvertTimeZones__value(let lhsValue), .m_setConvertTimeZones__value(let rhsValue)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                return true 
            case (.m_changed__setting(let lhsSetting), .m_changed__setting(let rhsSetting)):
                guard Parameter.compare(lhs: lhsSetting, rhs: rhsSetting, with: matcher) else { return false } 
                return true 
            case (.m_reset, .m_reset):
                return true 
            case (.m_save, .m_save):
                return true 
            case (.p_minMood_get,.p_minMood_get): return true
            case (.p_maxMood_get,.p_maxMood_get): return true
            case (.p_discreteMoods_get,.p_discreteMoods_get): return true
            case (.p_scaleMoodsOnImport_get,.p_scaleMoodsOnImport_get): return true
            case (.p_autoIgnoreEnabled_get,.p_autoIgnoreEnabled_get): return true
            case (.p_autoIgnoreSeconds_get,.p_autoIgnoreSeconds_get): return true
            case (.p_convertTimeZones_get,.p_convertTimeZones_get): return true
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_setMinMood__value(p0): return p0.intValue
            case let .m_setMaxMood__value(p0): return p0.intValue
            case let .m_setDiscreteMoods__value(p0): return p0.intValue
            case let .m_setScaleMoodsOnImport__value(p0): return p0.intValue
            case let .m_setAutoIgnoreEnabled__value(p0): return p0.intValue
            case let .m_setAutoIgnoreSeconds__value(p0): return p0.intValue
            case let .m_setConvertTimeZones__value(p0): return p0.intValue
            case let .m_changed__setting(p0): return p0.intValue
            case .m_reset: return 0
            case .m_save: return 0
            case .p_minMood_get: return 0
            case .p_maxMood_get: return 0
            case .p_discreteMoods_get: return 0
            case .p_scaleMoodsOnImport_get: return 0
            case .p_autoIgnoreEnabled_get: return 0
            case .p_autoIgnoreSeconds_get: return 0
            case .p_convertTimeZones_get: return 0
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func minMood(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_minMood_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func maxMood(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_maxMood_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func discreteMoods(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_discreteMoods_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func scaleMoodsOnImport(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_scaleMoodsOnImport_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func autoIgnoreEnabled(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_autoIgnoreEnabled_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func autoIgnoreSeconds(getter defaultValue: Int...) -> PropertyStub {
            return Given(method: .p_autoIgnoreSeconds_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func convertTimeZones(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_convertTimeZones_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func changed(_ setting: Parameter<Setting>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_changed__setting(`setting`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func changed(_ setting: Parameter<Setting>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_changed__setting(`setting`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func save(willThrow: Error...) -> MethodStub {
            return Given(method: .m_save, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func save(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_save, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func setMinMood(_ value: Parameter<Double>) -> Verify { return Verify(method: .m_setMinMood__value(`value`))}
        public static func setMaxMood(_ value: Parameter<Double>) -> Verify { return Verify(method: .m_setMaxMood__value(`value`))}
        public static func setDiscreteMoods(_ value: Parameter<Bool>) -> Verify { return Verify(method: .m_setDiscreteMoods__value(`value`))}
        public static func setScaleMoodsOnImport(_ value: Parameter<Bool>) -> Verify { return Verify(method: .m_setScaleMoodsOnImport__value(`value`))}
        public static func setAutoIgnoreEnabled(_ value: Parameter<Bool>) -> Verify { return Verify(method: .m_setAutoIgnoreEnabled__value(`value`))}
        public static func setAutoIgnoreSeconds(_ value: Parameter<Int>) -> Verify { return Verify(method: .m_setAutoIgnoreSeconds__value(`value`))}
        public static func setConvertTimeZones(_ value: Parameter<Bool>) -> Verify { return Verify(method: .m_setConvertTimeZones__value(`value`))}
        public static func changed(_ setting: Parameter<Setting>) -> Verify { return Verify(method: .m_changed__setting(`setting`))}
        public static func reset() -> Verify { return Verify(method: .m_reset)}
        public static func save() -> Verify { return Verify(method: .m_save)}
        public static var minMood: Verify { return Verify(method: .p_minMood_get) }
        public static var maxMood: Verify { return Verify(method: .p_maxMood_get) }
        public static var discreteMoods: Verify { return Verify(method: .p_discreteMoods_get) }
        public static var scaleMoodsOnImport: Verify { return Verify(method: .p_scaleMoodsOnImport_get) }
        public static var autoIgnoreEnabled: Verify { return Verify(method: .p_autoIgnoreEnabled_get) }
        public static var autoIgnoreSeconds: Verify { return Verify(method: .p_autoIgnoreSeconds_get) }
        public static var convertTimeZones: Verify { return Verify(method: .p_convertTimeZones_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func setMinMood(_ value: Parameter<Double>, perform: @escaping (Double) -> Void) -> Perform {
            return Perform(method: .m_setMinMood__value(`value`), performs: perform)
        }
        public static func setMaxMood(_ value: Parameter<Double>, perform: @escaping (Double) -> Void) -> Perform {
            return Perform(method: .m_setMaxMood__value(`value`), performs: perform)
        }
        public static func setDiscreteMoods(_ value: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_setDiscreteMoods__value(`value`), performs: perform)
        }
        public static func setScaleMoodsOnImport(_ value: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_setScaleMoodsOnImport__value(`value`), performs: perform)
        }
        public static func setAutoIgnoreEnabled(_ value: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_setAutoIgnoreEnabled__value(`value`), performs: perform)
        }
        public static func setAutoIgnoreSeconds(_ value: Parameter<Int>, perform: @escaping (Int) -> Void) -> Perform {
            return Perform(method: .m_setAutoIgnoreSeconds__value(`value`), performs: perform)
        }
        public static func setConvertTimeZones(_ value: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_setConvertTimeZones__value(`value`), performs: perform)
        }
        public static func changed(_ setting: Parameter<Setting>, perform: @escaping (Setting) -> Void) -> Perform {
            return Perform(method: .m_changed__setting(`setting`), performs: perform)
        }
        public static func reset(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_reset, performs: perform)
        }
        public static func save(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_save, performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }

    static public func given(_ method: StaticGiven) {
        methodReturnValues.append(method)
    }

    static public func perform(_ method: StaticPerform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    static public func verify(_ method: StaticVerify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    static private func addInvocation(_ call: StaticMethodType) {
        invocations.append(call)
    }
    static private func methodReturnValue(_ method: StaticMethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    static private func methodPerformValue(_ method: StaticMethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { StaticMethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    static private func matchingCalls(_ method: StaticMethodType) -> [StaticMethodType] {
        return invocations.filter { StaticMethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    static private func matchingCalls(_ method: StaticVerify) -> Int {
        return matchingCalls(method.method).count
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
}

// MARK: - SexualActivityQuery
open class SexualActivityQueryMock: SexualActivityQuery, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "SexualActivityQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "SexualActivityQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "SexualActivityQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - SleepQuery
open class SleepQueryMock: SleepQuery, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "SleepQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "SleepQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "SleepQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - StringUtil
open class StringUtilMock: StringUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func isNumber(_ str: String) -> Bool {
        addInvocation(.m_isNumber__str(Parameter<String>.value(`str`)))
		let perform = methodPerformValue(.m_isNumber__str(Parameter<String>.value(`str`))) as? (String) -> Void
		perform?(`str`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isNumber__str(Parameter<String>.value(`str`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isNumber(_ str: String). Use given")
			Failure("Stub return value not specified for isNumber(_ str: String). Use given")
		}
		return __value
    }

    open func isInteger(_ str: String) -> Bool {
        addInvocation(.m_isInteger__str(Parameter<String>.value(`str`)))
		let perform = methodPerformValue(.m_isInteger__str(Parameter<String>.value(`str`))) as? (String) -> Void
		perform?(`str`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isInteger__str(Parameter<String>.value(`str`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isInteger(_ str: String). Use given")
			Failure("Stub return value not specified for isInteger(_ str: String). Use given")
		}
		return __value
    }

    open func rangeOfNumberIn(_ str: String) -> Range<String.Index>? {
        addInvocation(.m_rangeOfNumberIn__str(Parameter<String>.value(`str`)))
		let perform = methodPerformValue(.m_rangeOfNumberIn__str(Parameter<String>.value(`str`))) as? (String) -> Void
		perform?(`str`)
		var __value: Range<String.Index>? = nil
		do {
		    __value = try methodReturnValue(.m_rangeOfNumberIn__str(Parameter<String>.value(`str`))).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func isDayOfWeek(_ str: String) -> Bool {
        addInvocation(.m_isDayOfWeek__str(Parameter<String>.value(`str`)))
		let perform = methodPerformValue(.m_isDayOfWeek__str(Parameter<String>.value(`str`))) as? (String) -> Void
		perform?(`str`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isDayOfWeek__str(Parameter<String>.value(`str`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isDayOfWeek(_ str: String). Use given")
			Failure("Stub return value not specified for isDayOfWeek(_ str: String). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_isNumber__str(Parameter<String>)
        case m_isInteger__str(Parameter<String>)
        case m_rangeOfNumberIn__str(Parameter<String>)
        case m_isDayOfWeek__str(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_isNumber__str(let lhsStr), .m_isNumber__str(let rhsStr)):
                guard Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher) else { return false } 
                return true 
            case (.m_isInteger__str(let lhsStr), .m_isInteger__str(let rhsStr)):
                guard Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher) else { return false } 
                return true 
            case (.m_rangeOfNumberIn__str(let lhsStr), .m_rangeOfNumberIn__str(let rhsStr)):
                guard Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher) else { return false } 
                return true 
            case (.m_isDayOfWeek__str(let lhsStr), .m_isDayOfWeek__str(let rhsStr)):
                guard Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_isNumber__str(p0): return p0.intValue
            case let .m_isInteger__str(p0): return p0.intValue
            case let .m_rangeOfNumberIn__str(p0): return p0.intValue
            case let .m_isDayOfWeek__str(p0): return p0.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func isNumber(_ str: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isNumber__str(`str`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isInteger(_ str: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isInteger__str(`str`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func rangeOfNumberIn(_ str: Parameter<String>, willReturn: Range<String.Index>?...) -> MethodStub {
            return Given(method: .m_rangeOfNumberIn__str(`str`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isDayOfWeek(_ str: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isDayOfWeek__str(`str`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isNumber(_ str: Parameter<String>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isNumber__str(`str`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func isInteger(_ str: Parameter<String>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isInteger__str(`str`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func rangeOfNumberIn(_ str: Parameter<String>, willProduce: (Stubber<Range<String.Index>?>) -> Void) -> MethodStub {
            let willReturn: [Range<String.Index>?] = []
			let given: Given = { return Given(method: .m_rangeOfNumberIn__str(`str`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Range<String.Index>?).self)
			willProduce(stubber)
			return given
        }
        public static func isDayOfWeek(_ str: Parameter<String>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isDayOfWeek__str(`str`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func isNumber(_ str: Parameter<String>) -> Verify { return Verify(method: .m_isNumber__str(`str`))}
        public static func isInteger(_ str: Parameter<String>) -> Verify { return Verify(method: .m_isInteger__str(`str`))}
        public static func rangeOfNumberIn(_ str: Parameter<String>) -> Verify { return Verify(method: .m_rangeOfNumberIn__str(`str`))}
        public static func isDayOfWeek(_ str: Parameter<String>) -> Verify { return Verify(method: .m_isDayOfWeek__str(`str`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func isNumber(_ str: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_isNumber__str(`str`), performs: perform)
        }
        public static func isInteger(_ str: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_isInteger__str(`str`), performs: perform)
        }
        public static func rangeOfNumberIn(_ str: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_rangeOfNumberIn__str(`str`), performs: perform)
        }
        public static func isDayOfWeek(_ str: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_isDayOfWeek__str(`str`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - SubQueryMatcherFactory
open class SubQueryMatcherFactoryMock: SubQueryMatcherFactory, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func withinXCalendarUnitsSubQueryMatcher() -> WithinXCalendarUnitsSubQueryMatcher {
        addInvocation(.m_withinXCalendarUnitsSubQueryMatcher)
		let perform = methodPerformValue(.m_withinXCalendarUnitsSubQueryMatcher) as? () -> Void
		perform?()
		var __value: WithinXCalendarUnitsSubQueryMatcher
		do {
		    __value = try methodReturnValue(.m_withinXCalendarUnitsSubQueryMatcher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for withinXCalendarUnitsSubQueryMatcher(). Use given")
			Failure("Stub return value not specified for withinXCalendarUnitsSubQueryMatcher(). Use given")
		}
		return __value
    }

    open func inSameCalendarUnitSubQueryMatcher() -> InSameCalendarUnitSubQueryMatcher {
        addInvocation(.m_inSameCalendarUnitSubQueryMatcher)
		let perform = methodPerformValue(.m_inSameCalendarUnitSubQueryMatcher) as? () -> Void
		perform?()
		var __value: InSameCalendarUnitSubQueryMatcher
		do {
		    __value = try methodReturnValue(.m_inSameCalendarUnitSubQueryMatcher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for inSameCalendarUnitSubQueryMatcher(). Use given")
			Failure("Stub return value not specified for inSameCalendarUnitSubQueryMatcher(). Use given")
		}
		return __value
    }

    open func sameDatesSubQueryMatcher() -> SameDatesSubQueryMatcher {
        addInvocation(.m_sameDatesSubQueryMatcher)
		let perform = methodPerformValue(.m_sameDatesSubQueryMatcher) as? () -> Void
		perform?()
		var __value: SameDatesSubQueryMatcher
		do {
		    __value = try methodReturnValue(.m_sameDatesSubQueryMatcher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sameDatesSubQueryMatcher(). Use given")
			Failure("Stub return value not specified for sameDatesSubQueryMatcher(). Use given")
		}
		return __value
    }

    open func sameStartDatesSubQueryMatcher() -> SameStartDatesSubQueryMatcher {
        addInvocation(.m_sameStartDatesSubQueryMatcher)
		let perform = methodPerformValue(.m_sameStartDatesSubQueryMatcher) as? () -> Void
		perform?()
		var __value: SameStartDatesSubQueryMatcher
		do {
		    __value = try methodReturnValue(.m_sameStartDatesSubQueryMatcher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sameStartDatesSubQueryMatcher(). Use given")
			Failure("Stub return value not specified for sameStartDatesSubQueryMatcher(). Use given")
		}
		return __value
    }

    open func sameEndDatesSubQueryMatcher() -> SameEndDatesSubQueryMatcher {
        addInvocation(.m_sameEndDatesSubQueryMatcher)
		let perform = methodPerformValue(.m_sameEndDatesSubQueryMatcher) as? () -> Void
		perform?()
		var __value: SameEndDatesSubQueryMatcher
		do {
		    __value = try methodReturnValue(.m_sameEndDatesSubQueryMatcher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sameEndDatesSubQueryMatcher(). Use given")
			Failure("Stub return value not specified for sameEndDatesSubQueryMatcher(). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_withinXCalendarUnitsSubQueryMatcher
        case m_inSameCalendarUnitSubQueryMatcher
        case m_sameDatesSubQueryMatcher
        case m_sameStartDatesSubQueryMatcher
        case m_sameEndDatesSubQueryMatcher

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_withinXCalendarUnitsSubQueryMatcher, .m_withinXCalendarUnitsSubQueryMatcher):
                return true 
            case (.m_inSameCalendarUnitSubQueryMatcher, .m_inSameCalendarUnitSubQueryMatcher):
                return true 
            case (.m_sameDatesSubQueryMatcher, .m_sameDatesSubQueryMatcher):
                return true 
            case (.m_sameStartDatesSubQueryMatcher, .m_sameStartDatesSubQueryMatcher):
                return true 
            case (.m_sameEndDatesSubQueryMatcher, .m_sameEndDatesSubQueryMatcher):
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_withinXCalendarUnitsSubQueryMatcher: return 0
            case .m_inSameCalendarUnitSubQueryMatcher: return 0
            case .m_sameDatesSubQueryMatcher: return 0
            case .m_sameStartDatesSubQueryMatcher: return 0
            case .m_sameEndDatesSubQueryMatcher: return 0
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func withinXCalendarUnitsSubQueryMatcher(willReturn: WithinXCalendarUnitsSubQueryMatcher...) -> MethodStub {
            return Given(method: .m_withinXCalendarUnitsSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func inSameCalendarUnitSubQueryMatcher(willReturn: InSameCalendarUnitSubQueryMatcher...) -> MethodStub {
            return Given(method: .m_inSameCalendarUnitSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sameDatesSubQueryMatcher(willReturn: SameDatesSubQueryMatcher...) -> MethodStub {
            return Given(method: .m_sameDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sameStartDatesSubQueryMatcher(willReturn: SameStartDatesSubQueryMatcher...) -> MethodStub {
            return Given(method: .m_sameStartDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func sameEndDatesSubQueryMatcher(willReturn: SameEndDatesSubQueryMatcher...) -> MethodStub {
            return Given(method: .m_sameEndDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func withinXCalendarUnitsSubQueryMatcher(willProduce: (Stubber<WithinXCalendarUnitsSubQueryMatcher>) -> Void) -> MethodStub {
            let willReturn: [WithinXCalendarUnitsSubQueryMatcher] = []
			let given: Given = { return Given(method: .m_withinXCalendarUnitsSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (WithinXCalendarUnitsSubQueryMatcher).self)
			willProduce(stubber)
			return given
        }
        public static func inSameCalendarUnitSubQueryMatcher(willProduce: (Stubber<InSameCalendarUnitSubQueryMatcher>) -> Void) -> MethodStub {
            let willReturn: [InSameCalendarUnitSubQueryMatcher] = []
			let given: Given = { return Given(method: .m_inSameCalendarUnitSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (InSameCalendarUnitSubQueryMatcher).self)
			willProduce(stubber)
			return given
        }
        public static func sameDatesSubQueryMatcher(willProduce: (Stubber<SameDatesSubQueryMatcher>) -> Void) -> MethodStub {
            let willReturn: [SameDatesSubQueryMatcher] = []
			let given: Given = { return Given(method: .m_sameDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SameDatesSubQueryMatcher).self)
			willProduce(stubber)
			return given
        }
        public static func sameStartDatesSubQueryMatcher(willProduce: (Stubber<SameStartDatesSubQueryMatcher>) -> Void) -> MethodStub {
            let willReturn: [SameStartDatesSubQueryMatcher] = []
			let given: Given = { return Given(method: .m_sameStartDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SameStartDatesSubQueryMatcher).self)
			willProduce(stubber)
			return given
        }
        public static func sameEndDatesSubQueryMatcher(willProduce: (Stubber<SameEndDatesSubQueryMatcher>) -> Void) -> MethodStub {
            let willReturn: [SameEndDatesSubQueryMatcher] = []
			let given: Given = { return Given(method: .m_sameEndDatesSubQueryMatcher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SameEndDatesSubQueryMatcher).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func withinXCalendarUnitsSubQueryMatcher() -> Verify { return Verify(method: .m_withinXCalendarUnitsSubQueryMatcher)}
        public static func inSameCalendarUnitSubQueryMatcher() -> Verify { return Verify(method: .m_inSameCalendarUnitSubQueryMatcher)}
        public static func sameDatesSubQueryMatcher() -> Verify { return Verify(method: .m_sameDatesSubQueryMatcher)}
        public static func sameStartDatesSubQueryMatcher() -> Verify { return Verify(method: .m_sameStartDatesSubQueryMatcher)}
        public static func sameEndDatesSubQueryMatcher() -> Verify { return Verify(method: .m_sameEndDatesSubQueryMatcher)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func withinXCalendarUnitsSubQueryMatcher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_withinXCalendarUnitsSubQueryMatcher, performs: perform)
        }
        public static func inSameCalendarUnitSubQueryMatcher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_inSameCalendarUnitSubQueryMatcher, performs: perform)
        }
        public static func sameDatesSubQueryMatcher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sameDatesSubQueryMatcher, performs: perform)
        }
        public static func sameStartDatesSubQueryMatcher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sameStartDatesSubQueryMatcher, performs: perform)
        }
        public static func sameEndDatesSubQueryMatcher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_sameEndDatesSubQueryMatcher, performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - TextNormalizationUtil
open class TextNormalizationUtilMock: TextNormalizationUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func expandContractions(_ text: String) -> String {
        addInvocation(.m_expandContractions__text(Parameter<String>.value(`text`)))
		let perform = methodPerformValue(.m_expandContractions__text(Parameter<String>.value(`text`))) as? (String) -> Void
		perform?(`text`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_expandContractions__text(Parameter<String>.value(`text`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for expandContractions(_ text: String). Use given")
			Failure("Stub return value not specified for expandContractions(_ text: String). Use given")
		}
		return __value
    }

    open func normalizeNumbers(_ text: String) -> String {
        addInvocation(.m_normalizeNumbers__text(Parameter<String>.value(`text`)))
		let perform = methodPerformValue(.m_normalizeNumbers__text(Parameter<String>.value(`text`))) as? (String) -> Void
		perform?(`text`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_normalizeNumbers__text(Parameter<String>.value(`text`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for normalizeNumbers(_ text: String). Use given")
			Failure("Stub return value not specified for normalizeNumbers(_ text: String). Use given")
		}
		return __value
    }

    open func removePunctuation(_ text: String) -> String {
        addInvocation(.m_removePunctuation__text(Parameter<String>.value(`text`)))
		let perform = methodPerformValue(.m_removePunctuation__text(Parameter<String>.value(`text`))) as? (String) -> Void
		perform?(`text`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_removePunctuation__text(Parameter<String>.value(`text`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for removePunctuation(_ text: String). Use given")
			Failure("Stub return value not specified for removePunctuation(_ text: String). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_expandContractions__text(Parameter<String>)
        case m_normalizeNumbers__text(Parameter<String>)
        case m_removePunctuation__text(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_expandContractions__text(let lhsText), .m_expandContractions__text(let rhsText)):
                guard Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher) else { return false } 
                return true 
            case (.m_normalizeNumbers__text(let lhsText), .m_normalizeNumbers__text(let rhsText)):
                guard Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher) else { return false } 
                return true 
            case (.m_removePunctuation__text(let lhsText), .m_removePunctuation__text(let rhsText)):
                guard Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_expandContractions__text(p0): return p0.intValue
            case let .m_normalizeNumbers__text(p0): return p0.intValue
            case let .m_removePunctuation__text(p0): return p0.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func expandContractions(_ text: Parameter<String>, willReturn: String...) -> MethodStub {
            return Given(method: .m_expandContractions__text(`text`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func normalizeNumbers(_ text: Parameter<String>, willReturn: String...) -> MethodStub {
            return Given(method: .m_normalizeNumbers__text(`text`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func removePunctuation(_ text: Parameter<String>, willReturn: String...) -> MethodStub {
            return Given(method: .m_removePunctuation__text(`text`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func expandContractions(_ text: Parameter<String>, willProduce: (Stubber<String>) -> Void) -> MethodStub {
            let willReturn: [String] = []
			let given: Given = { return Given(method: .m_expandContractions__text(`text`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func normalizeNumbers(_ text: Parameter<String>, willProduce: (Stubber<String>) -> Void) -> MethodStub {
            let willReturn: [String] = []
			let given: Given = { return Given(method: .m_normalizeNumbers__text(`text`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func removePunctuation(_ text: Parameter<String>, willProduce: (Stubber<String>) -> Void) -> MethodStub {
            let willReturn: [String] = []
			let given: Given = { return Given(method: .m_removePunctuation__text(`text`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (String).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func expandContractions(_ text: Parameter<String>) -> Verify { return Verify(method: .m_expandContractions__text(`text`))}
        public static func normalizeNumbers(_ text: Parameter<String>) -> Verify { return Verify(method: .m_normalizeNumbers__text(`text`))}
        public static func removePunctuation(_ text: Parameter<String>) -> Verify { return Verify(method: .m_removePunctuation__text(`text`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func expandContractions(_ text: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_expandContractions__text(`text`), performs: perform)
        }
        public static func normalizeNumbers(_ text: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_normalizeNumbers__text(`text`), performs: perform)
        }
        public static func removePunctuation(_ text: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_removePunctuation__text(`text`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - Transaction
open class TransactionMock: Transaction, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func childTransaction() -> Transaction {
        addInvocation(.m_childTransaction)
		let perform = methodPerformValue(.m_childTransaction) as? () -> Void
		perform?()
		var __value: Transaction
		do {
		    __value = try methodReturnValue(.m_childTransaction).casted()
		} catch {
			onFatalFailure("Stub return value not specified for childTransaction(). Use given")
			Failure("Stub return value not specified for childTransaction(). Use given")
		}
		return __value
    }

    open func commit() throws {
        addInvocation(.m_commit)
		let perform = methodPerformValue(.m_commit) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_commit).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func reset() {
        addInvocation(.m_reset)
		let perform = methodPerformValue(.m_reset) as? () -> Void
		perform?()
    }

    open func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type] {
        addInvocation(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())) as? (NSFetchRequest<Type>) -> Void
		perform?(`fetchRequest`)
		var __value: [Type]
		do {
		    __value = try methodReturnValue(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>). Use given")
			Failure("Stub return value not specified for query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type) throws -> Type {
        addInvocation(.m_new__objectType(Parameter<Type.Type>.value(`objectType`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_new__objectType(Parameter<Type.Type>.value(`objectType`).wrapAsGeneric())) as? (Type.Type) -> Void
		perform?(`objectType`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_new__objectType(Parameter<Type.Type>.value(`objectType`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type). Use given")
			Failure("Stub return value not specified for new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type) -> NSBatchUpdateRequest {
        addInvocation(.m_batchUpdateRequest__for_type(Parameter<Type.Type>.value(`type`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_batchUpdateRequest__for_type(Parameter<Type.Type>.value(`type`).wrapAsGeneric())) as? (Type.Type) -> Void
		perform?(`type`)
		var __value: NSBatchUpdateRequest
		do {
		    __value = try methodReturnValue(.m_batchUpdateRequest__for_type(Parameter<Type.Type>.value(`type`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type). Use given")
			Failure("Stub return value not specified for batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type). Use given")
		}
		return __value
    }

    open func batchUpdate(_ request: NSBatchUpdateRequest) throws -> NSBatchUpdateResult {
        addInvocation(.m_batchUpdate__request(Parameter<NSBatchUpdateRequest>.value(`request`)))
		let perform = methodPerformValue(.m_batchUpdate__request(Parameter<NSBatchUpdateRequest>.value(`request`))) as? (NSBatchUpdateRequest) -> Void
		perform?(`request`)
		var __value: NSBatchUpdateResult
		do {
		    __value = try methodReturnValue(.m_batchUpdate__request(Parameter<NSBatchUpdateRequest>.value(`request`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for batchUpdate(_ request: NSBatchUpdateRequest). Use given")
			Failure("Stub return value not specified for batchUpdate(_ request: NSBatchUpdateRequest). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func pull<Type: NSManagedObject>(savedObject: Type) throws -> Type {
        addInvocation(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric())) as? (Type) -> Void
		perform?(`savedObject`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type). Use given")
			Failure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func delete(_ object: NSManagedObject) throws {
        addInvocation(.m_delete__object(Parameter<NSManagedObject>.value(`object`)))
		let perform = methodPerformValue(.m_delete__object(Parameter<NSManagedObject>.value(`object`))) as? (NSManagedObject) -> Void
		perform?(`object`)
		do {
		    _ = try methodReturnValue(.m_delete__object(Parameter<NSManagedObject>.value(`object`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func deleteAll(_ objects: [NSManagedObject]) throws {
        addInvocation(.m_deleteAll__objects(Parameter<[NSManagedObject]>.value(`objects`)))
		let perform = methodPerformValue(.m_deleteAll__objects(Parameter<[NSManagedObject]>.value(`objects`))) as? ([NSManagedObject]) -> Void
		perform?(`objects`)
		do {
		    _ = try methodReturnValue(.m_deleteAll__objects(Parameter<[NSManagedObject]>.value(`objects`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func deleteAll(_ objectType: NSManagedObject.Type) throws {
        addInvocation(.m_deleteAll__objectType(Parameter<NSManagedObject.Type>.value(`objectType`)))
		let perform = methodPerformValue(.m_deleteAll__objectType(Parameter<NSManagedObject.Type>.value(`objectType`))) as? (NSManagedObject.Type) -> Void
		perform?(`objectType`)
		do {
		    _ = try methodReturnValue(.m_deleteAll__objectType(Parameter<NSManagedObject.Type>.value(`objectType`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func deleteAll(_ entityName: String) throws {
        addInvocation(.m_deleteAll__entityName(Parameter<String>.value(`entityName`)))
		let perform = methodPerformValue(.m_deleteAll__entityName(Parameter<String>.value(`entityName`))) as? (String) -> Void
		perform?(`entityName`)
		do {
		    _ = try methodReturnValue(.m_deleteAll__entityName(Parameter<String>.value(`entityName`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }


    fileprivate enum MethodType {
        case m_childTransaction
        case m_commit
        case m_reset
        case m_query__fetchRequest(Parameter<GenericAttribute>)
        case m_new__objectType(Parameter<GenericAttribute>)
        case m_batchUpdateRequest__for_type(Parameter<GenericAttribute>)
        case m_batchUpdate__request(Parameter<NSBatchUpdateRequest>)
        case m_pull__savedObject_savedObject(Parameter<GenericAttribute>)
        case m_delete__object(Parameter<NSManagedObject>)
        case m_deleteAll__objects(Parameter<[NSManagedObject]>)
        case m_deleteAll__objectType(Parameter<NSManagedObject.Type>)
        case m_deleteAll__entityName(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_childTransaction, .m_childTransaction):
                return true 
            case (.m_commit, .m_commit):
                return true 
            case (.m_reset, .m_reset):
                return true 
            case (.m_query__fetchRequest(let lhsFetchrequest), .m_query__fetchRequest(let rhsFetchrequest)):
                guard Parameter.compare(lhs: lhsFetchrequest, rhs: rhsFetchrequest, with: matcher) else { return false } 
                return true 
            case (.m_new__objectType(let lhsObjecttype), .m_new__objectType(let rhsObjecttype)):
                guard Parameter.compare(lhs: lhsObjecttype, rhs: rhsObjecttype, with: matcher) else { return false } 
                return true 
            case (.m_batchUpdateRequest__for_type(let lhsType), .m_batchUpdateRequest__for_type(let rhsType)):
                guard Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher) else { return false } 
                return true 
            case (.m_batchUpdate__request(let lhsRequest), .m_batchUpdate__request(let rhsRequest)):
                guard Parameter.compare(lhs: lhsRequest, rhs: rhsRequest, with: matcher) else { return false } 
                return true 
            case (.m_pull__savedObject_savedObject(let lhsSavedobject), .m_pull__savedObject_savedObject(let rhsSavedobject)):
                guard Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher) else { return false } 
                return true 
            case (.m_delete__object(let lhsObject), .m_delete__object(let rhsObject)):
                guard Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher) else { return false } 
                return true 
            case (.m_deleteAll__objects(let lhsObjects), .m_deleteAll__objects(let rhsObjects)):
                guard Parameter.compare(lhs: lhsObjects, rhs: rhsObjects, with: matcher) else { return false } 
                return true 
            case (.m_deleteAll__objectType(let lhsObjecttype), .m_deleteAll__objectType(let rhsObjecttype)):
                guard Parameter.compare(lhs: lhsObjecttype, rhs: rhsObjecttype, with: matcher) else { return false } 
                return true 
            case (.m_deleteAll__entityName(let lhsEntityname), .m_deleteAll__entityName(let rhsEntityname)):
                guard Parameter.compare(lhs: lhsEntityname, rhs: rhsEntityname, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_childTransaction: return 0
            case .m_commit: return 0
            case .m_reset: return 0
            case let .m_query__fetchRequest(p0): return p0.intValue
            case let .m_new__objectType(p0): return p0.intValue
            case let .m_batchUpdateRequest__for_type(p0): return p0.intValue
            case let .m_batchUpdate__request(p0): return p0.intValue
            case let .m_pull__savedObject_savedObject(p0): return p0.intValue
            case let .m_delete__object(p0): return p0.intValue
            case let .m_deleteAll__objects(p0): return p0.intValue
            case let .m_deleteAll__objectType(p0): return p0.intValue
            case let .m_deleteAll__entityName(p0): return p0.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func childTransaction(willReturn: Transaction...) -> MethodStub {
            return Given(method: .m_childTransaction, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func query<Type: NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willReturn: [Type]...) -> MethodStub {
            return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Parameter<Type.Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_new__objectType(`objectType`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func batchUpdateRequest<Type: CoreDataObject>(for type: Parameter<Type.Type>, willReturn: NSBatchUpdateRequest...) -> MethodStub {
            return Given(method: .m_batchUpdateRequest__for_type(`type`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func batchUpdate(_ request: Parameter<NSBatchUpdateRequest>, willReturn: NSBatchUpdateResult...) -> MethodStub {
            return Given(method: .m_batchUpdate__request(`request`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func childTransaction(willProduce: (Stubber<Transaction>) -> Void) -> MethodStub {
            let willReturn: [Transaction] = []
			let given: Given = { return Given(method: .m_childTransaction, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Transaction).self)
			willProduce(stubber)
			return given
        }
        public static func batchUpdateRequest<Type: CoreDataObject>(for type: Parameter<Type.Type>, willProduce: (Stubber<NSBatchUpdateRequest>) -> Void) -> MethodStub {
            let willReturn: [NSBatchUpdateRequest] = []
			let given: Given = { return Given(method: .m_batchUpdateRequest__for_type(`type`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (NSBatchUpdateRequest).self)
			willProduce(stubber)
			return given
        }
        public static func commit(willThrow: Error...) -> MethodStub {
            return Given(method: .m_commit, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func commit(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_commit, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func query<Type: NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func query<Type: NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willProduce: (StubberThrows<[Type]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Type]).self)
			willProduce(stubber)
			return given
        }
        public static func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_new__objectType(`objectType`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Parameter<Type.Type>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_new__objectType(`objectType`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func batchUpdate(_ request: Parameter<NSBatchUpdateRequest>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_batchUpdate__request(`request`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func batchUpdate(_ request: Parameter<NSBatchUpdateRequest>, willProduce: (StubberThrows<NSBatchUpdateResult>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_batchUpdate__request(`request`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (NSBatchUpdateResult).self)
			willProduce(stubber)
			return given
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func delete(_ object: Parameter<NSManagedObject>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_delete__object(`object`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func delete(_ object: Parameter<NSManagedObject>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_delete__object(`object`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func deleteAll(_ objects: Parameter<[NSManagedObject]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_deleteAll__objects(`objects`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func deleteAll(_ objects: Parameter<[NSManagedObject]>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_deleteAll__objects(`objects`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func deleteAll(_ objectType: Parameter<NSManagedObject.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_deleteAll__objectType(`objectType`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func deleteAll(_ objectType: Parameter<NSManagedObject.Type>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_deleteAll__objectType(`objectType`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func deleteAll(_ entityName: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_deleteAll__entityName(`entityName`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func deleteAll(_ entityName: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_deleteAll__entityName(`entityName`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func childTransaction() -> Verify { return Verify(method: .m_childTransaction)}
        public static func commit() -> Verify { return Verify(method: .m_commit)}
        public static func reset() -> Verify { return Verify(method: .m_reset)}
        public static func query<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>) -> Verify where Type:NSManagedObject { return Verify(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()))}
        public static func new<Type>(_ objectType: Parameter<Type.Type>) -> Verify where Type:NSManagedObject&CoreDataObject { return Verify(method: .m_new__objectType(`objectType`.wrapAsGeneric()))}
        public static func batchUpdateRequest<Type>(for type: Parameter<Type.Type>) -> Verify where Type:CoreDataObject { return Verify(method: .m_batchUpdateRequest__for_type(`type`.wrapAsGeneric()))}
        public static func batchUpdate(_ request: Parameter<NSBatchUpdateRequest>) -> Verify { return Verify(method: .m_batchUpdate__request(`request`))}
        public static func pull<Type>(savedObject: Parameter<Type>) -> Verify where Type:NSManagedObject { return Verify(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()))}
        public static func delete(_ object: Parameter<NSManagedObject>) -> Verify { return Verify(method: .m_delete__object(`object`))}
        public static func deleteAll(_ objects: Parameter<[NSManagedObject]>) -> Verify { return Verify(method: .m_deleteAll__objects(`objects`))}
        public static func deleteAll(_ objectType: Parameter<NSManagedObject.Type>) -> Verify { return Verify(method: .m_deleteAll__objectType(`objectType`))}
        public static func deleteAll(_ entityName: Parameter<String>) -> Verify { return Verify(method: .m_deleteAll__entityName(`entityName`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func childTransaction(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_childTransaction, performs: perform)
        }
        public static func commit(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_commit, performs: perform)
        }
        public static func reset(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_reset, performs: perform)
        }
        public static func query<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, perform: @escaping (NSFetchRequest<Type>) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), performs: perform)
        }
        public static func new<Type>(_ objectType: Parameter<Type.Type>, perform: @escaping (Type.Type) -> Void) -> Perform where Type:NSManagedObject&CoreDataObject {
            return Perform(method: .m_new__objectType(`objectType`.wrapAsGeneric()), performs: perform)
        }
        public static func batchUpdateRequest<Type>(for type: Parameter<Type.Type>, perform: @escaping (Type.Type) -> Void) -> Perform where Type:CoreDataObject {
            return Perform(method: .m_batchUpdateRequest__for_type(`type`.wrapAsGeneric()), performs: perform)
        }
        public static func batchUpdate(_ request: Parameter<NSBatchUpdateRequest>, perform: @escaping (NSBatchUpdateRequest) -> Void) -> Perform {
            return Perform(method: .m_batchUpdate__request(`request`), performs: perform)
        }
        public static func pull<Type>(savedObject: Parameter<Type>, perform: @escaping (Type) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), performs: perform)
        }
        public static func delete(_ object: Parameter<NSManagedObject>, perform: @escaping (NSManagedObject) -> Void) -> Perform {
            return Perform(method: .m_delete__object(`object`), performs: perform)
        }
        public static func deleteAll(_ objects: Parameter<[NSManagedObject]>, perform: @escaping ([NSManagedObject]) -> Void) -> Perform {
            return Perform(method: .m_deleteAll__objects(`objects`), performs: perform)
        }
        public static func deleteAll(_ objectType: Parameter<NSManagedObject.Type>, perform: @escaping (NSManagedObject.Type) -> Void) -> Perform {
            return Perform(method: .m_deleteAll__objectType(`objectType`), performs: perform)
        }
        public static func deleteAll(_ entityName: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_deleteAll__entityName(`entityName`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - UiUtil
open class UiUtilMock: UiUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var defaultPresenter: Presentr {
		get {	invocations.append(.p_defaultPresenter_get); return __p_defaultPresenter ?? givenGetterValue(.p_defaultPresenter_get, "UiUtilMock - stub value for defaultPresenter was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_defaultPresenter = newValue }
	}
	private var __p_defaultPresenter: (Presentr)?

    public var hasTopNotch: Bool {
		get {	invocations.append(.p_hasTopNotch_get); return __p_hasTopNotch ?? givenGetterValue(.p_hasTopNotch_get, "UiUtilMock - stub value for hasTopNotch was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_hasTopNotch = newValue }
	}
	private var __p_hasTopNotch: (Bool)?





    open func customPresenter(width: ModalSize, height: ModalSize, center: ModalCenterPosition) -> Presentr {
        addInvocation(.m_customPresenter__width_widthheight_heightcenter_center(Parameter<ModalSize>.value(`width`), Parameter<ModalSize>.value(`height`), Parameter<ModalCenterPosition>.value(`center`)))
		let perform = methodPerformValue(.m_customPresenter__width_widthheight_heightcenter_center(Parameter<ModalSize>.value(`width`), Parameter<ModalSize>.value(`height`), Parameter<ModalCenterPosition>.value(`center`))) as? (ModalSize, ModalSize, ModalCenterPosition) -> Void
		perform?(`width`, `height`, `center`)
		var __value: Presentr
		do {
		    __value = try methodReturnValue(.m_customPresenter__width_widthheight_heightcenter_center(Parameter<ModalSize>.value(`width`), Parameter<ModalSize>.value(`height`), Parameter<ModalCenterPosition>.value(`center`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for customPresenter(width: ModalSize, height: ModalSize, center: ModalCenterPosition). Use given")
			Failure("Stub return value not specified for customPresenter(width: ModalSize, height: ModalSize, center: ModalCenterPosition). Use given")
		}
		return __value
    }

    open func setView(_ view: UIView, enabled: Bool?, hidden: Bool?) {
        addInvocation(.m_setView__viewenabled_enabledhidden_hidden(Parameter<UIView>.value(`view`), Parameter<Bool?>.value(`enabled`), Parameter<Bool?>.value(`hidden`)))
		let perform = methodPerformValue(.m_setView__viewenabled_enabledhidden_hidden(Parameter<UIView>.value(`view`), Parameter<Bool?>.value(`enabled`), Parameter<Bool?>.value(`hidden`))) as? (UIView, Bool?, Bool?) -> Void
		perform?(`view`, `enabled`, `hidden`)
    }

    open func setButton(_ button: UIButton, enabled: Bool?, hidden: Bool?) {
        addInvocation(.m_setButton__buttonenabled_enabledhidden_hidden(Parameter<UIButton>.value(`button`), Parameter<Bool?>.value(`enabled`), Parameter<Bool?>.value(`hidden`)))
		let perform = methodPerformValue(.m_setButton__buttonenabled_enabledhidden_hidden(Parameter<UIButton>.value(`button`), Parameter<Bool?>.value(`enabled`), Parameter<Bool?>.value(`hidden`))) as? (UIButton, Bool?, Bool?) -> Void
		perform?(`button`, `enabled`, `hidden`)
    }

    open func setBackButton(for viewController: UIViewController, title: String, action selector: Selector) -> UIBarButtonItem {
        addInvocation(.m_setBackButton__for_viewControllertitle_titleaction_selector(Parameter<UIViewController>.value(`viewController`), Parameter<String>.value(`title`), Parameter<Selector>.value(`selector`)))
		let perform = methodPerformValue(.m_setBackButton__for_viewControllertitle_titleaction_selector(Parameter<UIViewController>.value(`viewController`), Parameter<String>.value(`title`), Parameter<Selector>.value(`selector`))) as? (UIViewController, String, Selector) -> Void
		perform?(`viewController`, `title`, `selector`)
		var __value: UIBarButtonItem
		do {
		    __value = try methodReturnValue(.m_setBackButton__for_viewControllertitle_titleaction_selector(Parameter<UIViewController>.value(`viewController`), Parameter<String>.value(`title`), Parameter<Selector>.value(`selector`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for setBackButton(for viewController: UIViewController, title: String, action selector: Selector). Use given")
			Failure("Stub return value not specified for setBackButton(for viewController: UIViewController, title: String, action selector: Selector). Use given")
		}
		return __value
    }

    open func addSaveButtonToKeyboardFor(_ textView: UITextView, target: Any?, action: Selector?) {
        addInvocation(.m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action(Parameter<UITextView>.value(`textView`), Parameter<Any?>.value(`target`), Parameter<Selector?>.value(`action`)))
		let perform = methodPerformValue(.m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action(Parameter<UITextView>.value(`textView`), Parameter<Any?>.value(`target`), Parameter<Selector?>.value(`action`))) as? (UITextView, Any?, Selector?) -> Void
		perform?(`textView`, `target`, `action`)
    }

    open func addSaveButtonToKeyboardFor(_ textField: UITextField, target: Any?, action: Selector?) {
        addInvocation(.m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action(Parameter<UITextField>.value(`textField`), Parameter<Any?>.value(`target`), Parameter<Selector?>.value(`action`)))
		let perform = methodPerformValue(.m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action(Parameter<UITextField>.value(`textField`), Parameter<Any?>.value(`target`), Parameter<Selector?>.value(`action`))) as? (UITextField, Any?, Selector?) -> Void
		perform?(`textField`, `target`, `action`)
    }

    open func value<Type>(for key: UserInfoKey, from notification: Notification, keyIsOptional: Bool) -> Type? {
        addInvocation(.m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(Parameter<UserInfoKey>.value(`key`), Parameter<Notification>.value(`notification`), Parameter<Bool>.value(`keyIsOptional`)))
		let perform = methodPerformValue(.m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(Parameter<UserInfoKey>.value(`key`), Parameter<Notification>.value(`notification`), Parameter<Bool>.value(`keyIsOptional`))) as? (UserInfoKey, Notification, Bool) -> Void
		perform?(`key`, `notification`, `keyIsOptional`)
		var __value: Type? = nil
		do {
		    __value = try methodReturnValue(.m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(Parameter<UserInfoKey>.value(`key`), Parameter<Notification>.value(`notification`), Parameter<Bool>.value(`keyIsOptional`))).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func info(_ info: [UserInfoKey: Any]) -> [AnyHashable: Any] {
        addInvocation(.m_info__info(Parameter<[UserInfoKey: Any]>.value(`info`)))
		let perform = methodPerformValue(.m_info__info(Parameter<[UserInfoKey: Any]>.value(`info`))) as? ([UserInfoKey: Any]) -> Void
		perform?(`info`)
		var __value: [AnyHashable: Any]
		do {
		    __value = try methodReturnValue(.m_info__info(Parameter<[UserInfoKey: Any]>.value(`info`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for info(_ info: [UserInfoKey: Any]). Use given")
			Failure("Stub return value not specified for info(_ info: [UserInfoKey: Any]). Use given")
		}
		return __value
    }

    open func controller<Type: UIViewController>(named controllerName: String, from storyboardName: String, as: Type.Type) -> Type {
        addInvocation(.m_controller__named_controllerNamefrom_storyboardNameas_as(Parameter<String>.value(`controllerName`), Parameter<String>.value(`storyboardName`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_controller__named_controllerNamefrom_storyboardNameas_as(Parameter<String>.value(`controllerName`), Parameter<String>.value(`storyboardName`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (String, String, Type.Type) -> Void
		perform?(`controllerName`, `storyboardName`, `as`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_controller__named_controllerNamefrom_storyboardNameas_as(Parameter<String>.value(`controllerName`), Parameter<String>.value(`storyboardName`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for controller<Type: UIViewController>(named controllerName: String, from storyboardName: String, as: Type.Type). Use given")
			Failure("Stub return value not specified for controller<Type: UIViewController>(named controllerName: String, from storyboardName: String, as: Type.Type). Use given")
		}
		return __value
    }

    open func controller<Type: UIViewController>(named controllerName: String, from storyboard: UIStoryboard, as: Type.Type) -> Type {
        addInvocation(.m_controller__named_controllerNamefrom_storyboardas_as(Parameter<String>.value(`controllerName`), Parameter<UIStoryboard>.value(`storyboard`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_controller__named_controllerNamefrom_storyboardas_as(Parameter<String>.value(`controllerName`), Parameter<UIStoryboard>.value(`storyboard`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (String, UIStoryboard, Type.Type) -> Void
		perform?(`controllerName`, `storyboard`, `as`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_controller__named_controllerNamefrom_storyboardas_as(Parameter<String>.value(`controllerName`), Parameter<UIStoryboard>.value(`storyboard`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for controller<Type: UIViewController>(named controllerName: String, from storyboard: UIStoryboard, as: Type.Type). Use given")
			Failure("Stub return value not specified for controller<Type: UIViewController>(named controllerName: String, from storyboard: UIStoryboard, as: Type.Type). Use given")
		}
		return __value
    }

    open func documentPicker(docTypes: [String], in pickerMode: UIDocumentPickerMode) -> UIDocumentPickerViewController {
        addInvocation(.m_documentPicker__docTypes_docTypesin_pickerMode(Parameter<[String]>.value(`docTypes`), Parameter<UIDocumentPickerMode>.value(`pickerMode`)))
		let perform = methodPerformValue(.m_documentPicker__docTypes_docTypesin_pickerMode(Parameter<[String]>.value(`docTypes`), Parameter<UIDocumentPickerMode>.value(`pickerMode`))) as? ([String], UIDocumentPickerMode) -> Void
		perform?(`docTypes`, `pickerMode`)
		var __value: UIDocumentPickerViewController
		do {
		    __value = try methodReturnValue(.m_documentPicker__docTypes_docTypesin_pickerMode(Parameter<[String]>.value(`docTypes`), Parameter<UIDocumentPickerMode>.value(`pickerMode`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for documentPicker(docTypes: [String], in pickerMode: UIDocumentPickerMode). Use given")
			Failure("Stub return value not specified for documentPicker(docTypes: [String], in pickerMode: UIDocumentPickerMode). Use given")
		}
		return __value
    }

    open func alert(title: String?, message: String?, preferredStyle: UIAlertController.Style) -> UIAlertController {
        addInvocation(.m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(Parameter<String?>.value(`title`), Parameter<String?>.value(`message`), Parameter<UIAlertController.Style>.value(`preferredStyle`)))
		let perform = methodPerformValue(.m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(Parameter<String?>.value(`title`), Parameter<String?>.value(`message`), Parameter<UIAlertController.Style>.value(`preferredStyle`))) as? (String?, String?, UIAlertController.Style) -> Void
		perform?(`title`, `message`, `preferredStyle`)
		var __value: UIAlertController
		do {
		    __value = try methodReturnValue(.m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(Parameter<String?>.value(`title`), Parameter<String?>.value(`message`), Parameter<UIAlertController.Style>.value(`preferredStyle`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for alert(title: String?, message: String?, preferredStyle: UIAlertController.Style). Use given")
			Failure("Stub return value not specified for alert(title: String?, message: String?, preferredStyle: UIAlertController.Style). Use given")
		}
		return __value
    }

    open func tableViewRowAction(		style: UITableViewRowAction.Style,		title: String?,		handler: @escaping (UITableViewRowAction, IndexPath) -> Void) -> UITableViewRowAction {
        addInvocation(.m_tableViewRowAction__style_styletitle_titlehandler_handler(Parameter<UITableViewRowAction.Style>.value(`style`), Parameter<String?>.value(`title`), Parameter<(UITableViewRowAction, IndexPath) -> Void>.value(`handler`)))
		let perform = methodPerformValue(.m_tableViewRowAction__style_styletitle_titlehandler_handler(Parameter<UITableViewRowAction.Style>.value(`style`), Parameter<String?>.value(`title`), Parameter<(UITableViewRowAction, IndexPath) -> Void>.value(`handler`))) as? (UITableViewRowAction.Style, String?, @escaping (UITableViewRowAction, IndexPath) -> Void) -> Void
		perform?(`style`, `title`, `handler`)
		var __value: UITableViewRowAction
		do {
		    __value = try methodReturnValue(.m_tableViewRowAction__style_styletitle_titlehandler_handler(Parameter<UITableViewRowAction.Style>.value(`style`), Parameter<String?>.value(`title`), Parameter<(UITableViewRowAction, IndexPath) -> Void>.value(`handler`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for tableViewRowAction(  style: UITableViewRowAction.Style,  title: String?,  handler: @escaping (UITableViewRowAction, IndexPath) -> Void). Use given")
			Failure("Stub return value not specified for tableViewRowAction(  style: UITableViewRowAction.Style,  title: String?,  handler: @escaping (UITableViewRowAction, IndexPath) -> Void). Use given")
		}
		return __value
    }

    open func alertAction(		title: String?,		style: UIAlertAction.Style,		handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        addInvocation(.m_alertAction__title_titlestyle_stylehandler_handler(Parameter<String?>.value(`title`), Parameter<UIAlertAction.Style>.value(`style`), Parameter<((UIAlertAction) -> Void)?>.value(`handler`)))
		let perform = methodPerformValue(.m_alertAction__title_titlestyle_stylehandler_handler(Parameter<String?>.value(`title`), Parameter<UIAlertAction.Style>.value(`style`), Parameter<((UIAlertAction) -> Void)?>.value(`handler`))) as? (String?, UIAlertAction.Style, ((UIAlertAction) -> Void)?) -> Void
		perform?(`title`, `style`, `handler`)
		var __value: UIAlertAction
		do {
		    __value = try methodReturnValue(.m_alertAction__title_titlestyle_stylehandler_handler(Parameter<String?>.value(`title`), Parameter<UIAlertAction.Style>.value(`style`), Parameter<((UIAlertAction) -> Void)?>.value(`handler`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for alertAction(  title: String?,  style: UIAlertAction.Style,  handler: ((UIAlertAction) -> Void)?). Use given")
			Failure("Stub return value not specified for alertAction(  title: String?,  style: UIAlertAction.Style,  handler: ((UIAlertAction) -> Void)?). Use given")
		}
		return __value
    }

    open func stopObserving(_ observer: Any, name: NotificationName?, object: Any?) {
        addInvocation(.m_stopObserving__observername_nameobject_object(Parameter<Any>.value(`observer`), Parameter<NotificationName?>.value(`name`), Parameter<Any?>.value(`object`)))
		let perform = methodPerformValue(.m_stopObserving__observername_nameobject_object(Parameter<Any>.value(`observer`), Parameter<NotificationName?>.value(`name`), Parameter<Any?>.value(`object`))) as? (Any, NotificationName?, Any?) -> Void
		perform?(`observer`, `name`, `object`)
    }

    open func post(name: Notification.Name, object: Any?, userInfo: [AnyHashable: Any]?) {
        addInvocation(.m_post__name_nameobject_objectuserInfo_userInfo_1(Parameter<Notification.Name>.value(`name`), Parameter<Any?>.value(`object`), Parameter<[AnyHashable: Any]?>.value(`userInfo`)))
		let perform = methodPerformValue(.m_post__name_nameobject_objectuserInfo_userInfo_1(Parameter<Notification.Name>.value(`name`), Parameter<Any?>.value(`object`), Parameter<[AnyHashable: Any]?>.value(`userInfo`))) as? (Notification.Name, Any?, [AnyHashable: Any]?) -> Void
		perform?(`name`, `object`, `userInfo`)
    }

    open func post(name: NotificationName, object: Any?, userInfo: [AnyHashable: Any]?) {
        addInvocation(.m_post__name_nameobject_objectuserInfo_userInfo_2(Parameter<NotificationName>.value(`name`), Parameter<Any?>.value(`object`), Parameter<[AnyHashable: Any]?>.value(`userInfo`)))
		let perform = methodPerformValue(.m_post__name_nameobject_objectuserInfo_userInfo_2(Parameter<NotificationName>.value(`name`), Parameter<Any?>.value(`object`), Parameter<[AnyHashable: Any]?>.value(`userInfo`))) as? (NotificationName, Any?, [AnyHashable: Any]?) -> Void
		perform?(`name`, `object`, `userInfo`)
    }

    open func present(		_ presentingController: UIViewController,		_ controllerBeingPresented: UIViewController,		animated: Bool,		completion: (() -> Void)?) {
        addInvocation(.m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(Parameter<UIViewController>.value(`presentingController`), Parameter<UIViewController>.value(`controllerBeingPresented`), Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`)))
		let perform = methodPerformValue(.m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(Parameter<UIViewController>.value(`presentingController`), Parameter<UIViewController>.value(`controllerBeingPresented`), Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`))) as? (UIViewController, UIViewController, Bool, (() -> Void)?) -> Void
		perform?(`presentingController`, `controllerBeingPresented`, `animated`, `completion`)
    }

    open func present(		_ viewController: UIViewController,		on presentingController: UIViewController,		using presenter: Presentr,		animated: Bool,		completion: (() -> Void)?) {
        addInvocation(.m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(Parameter<UIViewController>.value(`viewController`), Parameter<UIViewController>.value(`presentingController`), Parameter<Presentr>.value(`presenter`), Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`)))
		let perform = methodPerformValue(.m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(Parameter<UIViewController>.value(`viewController`), Parameter<UIViewController>.value(`presentingController`), Parameter<Presentr>.value(`presenter`), Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`))) as? (UIViewController, UIViewController, Presentr, Bool, (() -> Void)?) -> Void
		perform?(`viewController`, `presentingController`, `presenter`, `animated`, `completion`)
    }

    open func push(controller: UIViewController, toNavigationController navigationController: UINavigationController?, animated: Bool) {
        addInvocation(.m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(Parameter<UIViewController>.value(`controller`), Parameter<UINavigationController?>.value(`navigationController`), Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(Parameter<UIViewController>.value(`controller`), Parameter<UINavigationController?>.value(`navigationController`), Parameter<Bool>.value(`animated`))) as? (UIViewController, UINavigationController?, Bool) -> Void
		perform?(`controller`, `navigationController`, `animated`)
    }

    open func popFrom(_ navigationController: UINavigationController?, animated: Bool) {
        addInvocation(.m_popFrom__navigationControlleranimated_animated(Parameter<UINavigationController?>.value(`navigationController`), Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_popFrom__navigationControlleranimated_animated(Parameter<UINavigationController?>.value(`navigationController`), Parameter<Bool>.value(`animated`))) as? (UINavigationController?, Bool) -> Void
		perform?(`navigationController`, `animated`)
    }

    open func sendUserNotification(		withContent content: UNMutableNotificationContent,		id: String,		repeats: Bool,		interval: TimeInterval) {
        addInvocation(.m_sendUserNotification__withContent_contentid_idrepeats_repeatsinterval_interval(Parameter<UNMutableNotificationContent>.value(`content`), Parameter<String>.value(`id`), Parameter<Bool>.value(`repeats`), Parameter<TimeInterval>.value(`interval`)))
		let perform = methodPerformValue(.m_sendUserNotification__withContent_contentid_idrepeats_repeatsinterval_interval(Parameter<UNMutableNotificationContent>.value(`content`), Parameter<String>.value(`id`), Parameter<Bool>.value(`repeats`), Parameter<TimeInterval>.value(`interval`))) as? (UNMutableNotificationContent, String, Bool, TimeInterval) -> Void
		perform?(`content`, `id`, `repeats`, `interval`)
    }


    fileprivate enum MethodType {
        case m_customPresenter__width_widthheight_heightcenter_center(Parameter<ModalSize>, Parameter<ModalSize>, Parameter<ModalCenterPosition>)
        case m_setView__viewenabled_enabledhidden_hidden(Parameter<UIView>, Parameter<Bool?>, Parameter<Bool?>)
        case m_setButton__buttonenabled_enabledhidden_hidden(Parameter<UIButton>, Parameter<Bool?>, Parameter<Bool?>)
        case m_setBackButton__for_viewControllertitle_titleaction_selector(Parameter<UIViewController>, Parameter<String>, Parameter<Selector>)
        case m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action(Parameter<UITextView>, Parameter<Any?>, Parameter<Selector?>)
        case m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action(Parameter<UITextField>, Parameter<Any?>, Parameter<Selector?>)
        case m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(Parameter<UserInfoKey>, Parameter<Notification>, Parameter<Bool>)
        case m_info__info(Parameter<[UserInfoKey: Any]>)
        case m_controller__named_controllerNamefrom_storyboardNameas_as(Parameter<String>, Parameter<String>, Parameter<GenericAttribute>)
        case m_controller__named_controllerNamefrom_storyboardas_as(Parameter<String>, Parameter<UIStoryboard>, Parameter<GenericAttribute>)
        case m_documentPicker__docTypes_docTypesin_pickerMode(Parameter<[String]>, Parameter<UIDocumentPickerMode>)
        case m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(Parameter<String?>, Parameter<String?>, Parameter<UIAlertController.Style>)
        case m_tableViewRowAction__style_styletitle_titlehandler_handler(Parameter<UITableViewRowAction.Style>, Parameter<String?>, Parameter<(UITableViewRowAction, IndexPath) -> Void>)
        case m_alertAction__title_titlestyle_stylehandler_handler(Parameter<String?>, Parameter<UIAlertAction.Style>, Parameter<((UIAlertAction) -> Void)?>)
        case m_stopObserving__observername_nameobject_object(Parameter<Any>, Parameter<NotificationName?>, Parameter<Any?>)
        case m_post__name_nameobject_objectuserInfo_userInfo_1(Parameter<Notification.Name>, Parameter<Any?>, Parameter<[AnyHashable: Any]?>)
        case m_post__name_nameobject_objectuserInfo_userInfo_2(Parameter<NotificationName>, Parameter<Any?>, Parameter<[AnyHashable: Any]?>)
        case m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(Parameter<UIViewController>, Parameter<UIViewController>, Parameter<Bool>, Parameter<(() -> Void)?>)
        case m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(Parameter<UIViewController>, Parameter<UIViewController>, Parameter<Presentr>, Parameter<Bool>, Parameter<(() -> Void)?>)
        case m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(Parameter<UIViewController>, Parameter<UINavigationController?>, Parameter<Bool>)
        case m_popFrom__navigationControlleranimated_animated(Parameter<UINavigationController?>, Parameter<Bool>)
        case m_sendUserNotification__withContent_contentid_idrepeats_repeatsinterval_interval(Parameter<UNMutableNotificationContent>, Parameter<String>, Parameter<Bool>, Parameter<TimeInterval>)
        case p_defaultPresenter_get
        case p_hasTopNotch_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_customPresenter__width_widthheight_heightcenter_center(let lhsWidth, let lhsHeight, let lhsCenter), .m_customPresenter__width_widthheight_heightcenter_center(let rhsWidth, let rhsHeight, let rhsCenter)):
                guard Parameter.compare(lhs: lhsWidth, rhs: rhsWidth, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsHeight, rhs: rhsHeight, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsCenter, rhs: rhsCenter, with: matcher) else { return false } 
                return true 
            case (.m_setView__viewenabled_enabledhidden_hidden(let lhsView, let lhsEnabled, let lhsHidden), .m_setView__viewenabled_enabledhidden_hidden(let rhsView, let rhsEnabled, let rhsHidden)):
                guard Parameter.compare(lhs: lhsView, rhs: rhsView, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsEnabled, rhs: rhsEnabled, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsHidden, rhs: rhsHidden, with: matcher) else { return false } 
                return true 
            case (.m_setButton__buttonenabled_enabledhidden_hidden(let lhsButton, let lhsEnabled, let lhsHidden), .m_setButton__buttonenabled_enabledhidden_hidden(let rhsButton, let rhsEnabled, let rhsHidden)):
                guard Parameter.compare(lhs: lhsButton, rhs: rhsButton, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsEnabled, rhs: rhsEnabled, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsHidden, rhs: rhsHidden, with: matcher) else { return false } 
                return true 
            case (.m_setBackButton__for_viewControllertitle_titleaction_selector(let lhsViewcontroller, let lhsTitle, let lhsSelector), .m_setBackButton__for_viewControllertitle_titleaction_selector(let rhsViewcontroller, let rhsTitle, let rhsSelector)):
                guard Parameter.compare(lhs: lhsViewcontroller, rhs: rhsViewcontroller, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsSelector, rhs: rhsSelector, with: matcher) else { return false } 
                return true 
            case (.m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action(let lhsTextview, let lhsTarget, let lhsAction), .m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action(let rhsTextview, let rhsTarget, let rhsAction)):
                guard Parameter.compare(lhs: lhsTextview, rhs: rhsTextview, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsTarget, rhs: rhsTarget, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher) else { return false } 
                return true 
            case (.m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action(let lhsTextfield, let lhsTarget, let lhsAction), .m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action(let rhsTextfield, let rhsTarget, let rhsAction)):
                guard Parameter.compare(lhs: lhsTextfield, rhs: rhsTextfield, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsTarget, rhs: rhsTarget, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher) else { return false } 
                return true 
            case (.m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(let lhsKey, let lhsNotification, let lhsKeyisoptional), .m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(let rhsKey, let rhsNotification, let rhsKeyisoptional)):
                guard Parameter.compare(lhs: lhsKey, rhs: rhsKey, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsNotification, rhs: rhsNotification, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsKeyisoptional, rhs: rhsKeyisoptional, with: matcher) else { return false } 
                return true 
            case (.m_info__info(let lhsInfo), .m_info__info(let rhsInfo)):
                guard Parameter.compare(lhs: lhsInfo, rhs: rhsInfo, with: matcher) else { return false } 
                return true 
            case (.m_controller__named_controllerNamefrom_storyboardNameas_as(let lhsControllername, let lhsStoryboardname, let lhsAs), .m_controller__named_controllerNamefrom_storyboardNameas_as(let rhsControllername, let rhsStoryboardname, let rhsAs)):
                guard Parameter.compare(lhs: lhsControllername, rhs: rhsControllername, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsStoryboardname, rhs: rhsStoryboardname, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher) else { return false } 
                return true 
            case (.m_controller__named_controllerNamefrom_storyboardas_as(let lhsControllername, let lhsStoryboard, let lhsAs), .m_controller__named_controllerNamefrom_storyboardas_as(let rhsControllername, let rhsStoryboard, let rhsAs)):
                guard Parameter.compare(lhs: lhsControllername, rhs: rhsControllername, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsStoryboard, rhs: rhsStoryboard, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher) else { return false } 
                return true 
            case (.m_documentPicker__docTypes_docTypesin_pickerMode(let lhsDoctypes, let lhsPickermode), .m_documentPicker__docTypes_docTypesin_pickerMode(let rhsDoctypes, let rhsPickermode)):
                guard Parameter.compare(lhs: lhsDoctypes, rhs: rhsDoctypes, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsPickermode, rhs: rhsPickermode, with: matcher) else { return false } 
                return true 
            case (.m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(let lhsTitle, let lhsMessage, let lhsPreferredstyle), .m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(let rhsTitle, let rhsMessage, let rhsPreferredstyle)):
                guard Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsMessage, rhs: rhsMessage, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsPreferredstyle, rhs: rhsPreferredstyle, with: matcher) else { return false } 
                return true 
            case (.m_tableViewRowAction__style_styletitle_titlehandler_handler(let lhsStyle, let lhsTitle, let lhsHandler), .m_tableViewRowAction__style_styletitle_titlehandler_handler(let rhsStyle, let rhsTitle, let rhsHandler)):
                guard Parameter.compare(lhs: lhsStyle, rhs: rhsStyle, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsHandler, rhs: rhsHandler, with: matcher) else { return false } 
                return true 
            case (.m_alertAction__title_titlestyle_stylehandler_handler(let lhsTitle, let lhsStyle, let lhsHandler), .m_alertAction__title_titlestyle_stylehandler_handler(let rhsTitle, let rhsStyle, let rhsHandler)):
                guard Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsStyle, rhs: rhsStyle, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsHandler, rhs: rhsHandler, with: matcher) else { return false } 
                return true 
            case (.m_stopObserving__observername_nameobject_object(let lhsObserver, let lhsName, let lhsObject), .m_stopObserving__observername_nameobject_object(let rhsObserver, let rhsName, let rhsObject)):
                guard Parameter.compare(lhs: lhsObserver, rhs: rhsObserver, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher) else { return false } 
                return true 
            case (.m_post__name_nameobject_objectuserInfo_userInfo_1(let lhsName, let lhsObject, let lhsUserinfo), .m_post__name_nameobject_objectuserInfo_userInfo_1(let rhsName, let rhsObject, let rhsUserinfo)):
                guard Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsUserinfo, rhs: rhsUserinfo, with: matcher) else { return false } 
                return true 
            case (.m_post__name_nameobject_objectuserInfo_userInfo_2(let lhsName, let lhsObject, let lhsUserinfo), .m_post__name_nameobject_objectuserInfo_userInfo_2(let rhsName, let rhsObject, let rhsUserinfo)):
                guard Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsUserinfo, rhs: rhsUserinfo, with: matcher) else { return false } 
                return true 
            case (.m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(let lhsPresentingcontroller, let lhsControllerbeingpresented, let lhsAnimated, let lhsCompletion), .m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(let rhsPresentingcontroller, let rhsControllerbeingpresented, let rhsAnimated, let rhsCompletion)):
                guard Parameter.compare(lhs: lhsPresentingcontroller, rhs: rhsPresentingcontroller, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsControllerbeingpresented, rhs: rhsControllerbeingpresented, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher) else { return false } 
                return true 
            case (.m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(let lhsViewcontroller, let lhsPresentingcontroller, let lhsPresenter, let lhsAnimated, let lhsCompletion), .m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(let rhsViewcontroller, let rhsPresentingcontroller, let rhsPresenter, let rhsAnimated, let rhsCompletion)):
                guard Parameter.compare(lhs: lhsViewcontroller, rhs: rhsViewcontroller, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsPresentingcontroller, rhs: rhsPresentingcontroller, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsPresenter, rhs: rhsPresenter, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher) else { return false } 
                return true 
            case (.m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(let lhsController, let lhsNavigationcontroller, let lhsAnimated), .m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(let rhsController, let rhsNavigationcontroller, let rhsAnimated)):
                guard Parameter.compare(lhs: lhsController, rhs: rhsController, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsNavigationcontroller, rhs: rhsNavigationcontroller, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher) else { return false } 
                return true 
            case (.m_popFrom__navigationControlleranimated_animated(let lhsNavigationcontroller, let lhsAnimated), .m_popFrom__navigationControlleranimated_animated(let rhsNavigationcontroller, let rhsAnimated)):
                guard Parameter.compare(lhs: lhsNavigationcontroller, rhs: rhsNavigationcontroller, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher) else { return false } 
                return true 
            case (.m_sendUserNotification__withContent_contentid_idrepeats_repeatsinterval_interval(let lhsContent, let lhsId, let lhsRepeats, let lhsInterval), .m_sendUserNotification__withContent_contentid_idrepeats_repeatsinterval_interval(let rhsContent, let rhsId, let rhsRepeats, let rhsInterval)):
                guard Parameter.compare(lhs: lhsContent, rhs: rhsContent, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsId, rhs: rhsId, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsRepeats, rhs: rhsRepeats, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsInterval, rhs: rhsInterval, with: matcher) else { return false } 
                return true 
            case (.p_defaultPresenter_get,.p_defaultPresenter_get): return true
            case (.p_hasTopNotch_get,.p_hasTopNotch_get): return true
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_customPresenter__width_widthheight_heightcenter_center(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_setView__viewenabled_enabledhidden_hidden(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_setButton__buttonenabled_enabledhidden_hidden(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_setBackButton__for_viewControllertitle_titleaction_selector(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_info__info(p0): return p0.intValue
            case let .m_controller__named_controllerNamefrom_storyboardNameas_as(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_controller__named_controllerNamefrom_storyboardas_as(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_documentPicker__docTypes_docTypesin_pickerMode(p0, p1): return p0.intValue + p1.intValue
            case let .m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_tableViewRowAction__style_styletitle_titlehandler_handler(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_alertAction__title_titlestyle_stylehandler_handler(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_stopObserving__observername_nameobject_object(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_post__name_nameobject_objectuserInfo_userInfo_1(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_post__name_nameobject_objectuserInfo_userInfo_2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_popFrom__navigationControlleranimated_animated(p0, p1): return p0.intValue + p1.intValue
            case let .m_sendUserNotification__withContent_contentid_idrepeats_repeatsinterval_interval(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case .p_defaultPresenter_get: return 0
            case .p_hasTopNotch_get: return 0
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func defaultPresenter(getter defaultValue: Presentr...) -> PropertyStub {
            return Given(method: .p_defaultPresenter_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func hasTopNotch(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_hasTopNotch_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func customPresenter(width: Parameter<ModalSize>, height: Parameter<ModalSize>, center: Parameter<ModalCenterPosition>, willReturn: Presentr...) -> MethodStub {
            return Given(method: .m_customPresenter__width_widthheight_heightcenter_center(`width`, `height`, `center`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func setBackButton(for viewController: Parameter<UIViewController>, title: Parameter<String>, action selector: Parameter<Selector>, willReturn: UIBarButtonItem...) -> MethodStub {
            return Given(method: .m_setBackButton__for_viewControllertitle_titleaction_selector(`viewController`, `title`, `selector`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func value<Type>(for key: Parameter<UserInfoKey>, from notification: Parameter<Notification>, keyIsOptional: Parameter<Bool>, willReturn: Type?...) -> MethodStub {
            return Given(method: .m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(`key`, `notification`, `keyIsOptional`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func info(_ info: Parameter<[UserInfoKey: Any]>, willReturn: [AnyHashable: Any]...) -> MethodStub {
            return Given(method: .m_info__info(`info`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func controller<Type: UIViewController>(named controllerName: Parameter<String>, from storyboardName: Parameter<String>, as: Parameter<Type.Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_controller__named_controllerNamefrom_storyboardNameas_as(`controllerName`, `storyboardName`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func controller<Type: UIViewController>(named controllerName: Parameter<String>, from storyboard: Parameter<UIStoryboard>, as: Parameter<Type.Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_controller__named_controllerNamefrom_storyboardas_as(`controllerName`, `storyboard`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func documentPicker(docTypes: Parameter<[String]>, in pickerMode: Parameter<UIDocumentPickerMode>, willReturn: UIDocumentPickerViewController...) -> MethodStub {
            return Given(method: .m_documentPicker__docTypes_docTypesin_pickerMode(`docTypes`, `pickerMode`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func alert(title: Parameter<String?>, message: Parameter<String?>, preferredStyle: Parameter<UIAlertController.Style>, willReturn: UIAlertController...) -> MethodStub {
            return Given(method: .m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(`title`, `message`, `preferredStyle`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func tableViewRowAction(style: Parameter<UITableViewRowAction.Style>, title: Parameter<String?>, handler: Parameter<(UITableViewRowAction, IndexPath) -> Void>, willReturn: UITableViewRowAction...) -> MethodStub {
            return Given(method: .m_tableViewRowAction__style_styletitle_titlehandler_handler(`style`, `title`, `handler`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func alertAction(title: Parameter<String?>, style: Parameter<UIAlertAction.Style>, handler: Parameter<((UIAlertAction) -> Void)?>, willReturn: UIAlertAction...) -> MethodStub {
            return Given(method: .m_alertAction__title_titlestyle_stylehandler_handler(`title`, `style`, `handler`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func customPresenter(width: Parameter<ModalSize>, height: Parameter<ModalSize>, center: Parameter<ModalCenterPosition>, willProduce: (Stubber<Presentr>) -> Void) -> MethodStub {
            let willReturn: [Presentr] = []
			let given: Given = { return Given(method: .m_customPresenter__width_widthheight_heightcenter_center(`width`, `height`, `center`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Presentr).self)
			willProduce(stubber)
			return given
        }
        public static func setBackButton(for viewController: Parameter<UIViewController>, title: Parameter<String>, action selector: Parameter<Selector>, willProduce: (Stubber<UIBarButtonItem>) -> Void) -> MethodStub {
            let willReturn: [UIBarButtonItem] = []
			let given: Given = { return Given(method: .m_setBackButton__for_viewControllertitle_titleaction_selector(`viewController`, `title`, `selector`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UIBarButtonItem).self)
			willProduce(stubber)
			return given
        }
        public static func value<Type>(for key: Parameter<UserInfoKey>, from notification: Parameter<Notification>, keyIsOptional: Parameter<Bool>, willProduce: (Stubber<Type?>) -> Void) -> MethodStub {
            let willReturn: [Type?] = []
			let given: Given = { return Given(method: .m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(`key`, `notification`, `keyIsOptional`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Type?).self)
			willProduce(stubber)
			return given
        }
        public static func info(_ info: Parameter<[UserInfoKey: Any]>, willProduce: (Stubber<[AnyHashable: Any]>) -> Void) -> MethodStub {
            let willReturn: [[AnyHashable: Any]] = []
			let given: Given = { return Given(method: .m_info__info(`info`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([AnyHashable: Any]).self)
			willProduce(stubber)
			return given
        }
        public static func controller<Type: UIViewController>(named controllerName: Parameter<String>, from storyboardName: Parameter<String>, as: Parameter<Type.Type>, willProduce: (Stubber<Type>) -> Void) -> MethodStub {
            let willReturn: [Type] = []
			let given: Given = { return Given(method: .m_controller__named_controllerNamefrom_storyboardNameas_as(`controllerName`, `storyboardName`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func controller<Type: UIViewController>(named controllerName: Parameter<String>, from storyboard: Parameter<UIStoryboard>, as: Parameter<Type.Type>, willProduce: (Stubber<Type>) -> Void) -> MethodStub {
            let willReturn: [Type] = []
			let given: Given = { return Given(method: .m_controller__named_controllerNamefrom_storyboardas_as(`controllerName`, `storyboard`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func documentPicker(docTypes: Parameter<[String]>, in pickerMode: Parameter<UIDocumentPickerMode>, willProduce: (Stubber<UIDocumentPickerViewController>) -> Void) -> MethodStub {
            let willReturn: [UIDocumentPickerViewController] = []
			let given: Given = { return Given(method: .m_documentPicker__docTypes_docTypesin_pickerMode(`docTypes`, `pickerMode`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UIDocumentPickerViewController).self)
			willProduce(stubber)
			return given
        }
        public static func alert(title: Parameter<String?>, message: Parameter<String?>, preferredStyle: Parameter<UIAlertController.Style>, willProduce: (Stubber<UIAlertController>) -> Void) -> MethodStub {
            let willReturn: [UIAlertController] = []
			let given: Given = { return Given(method: .m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(`title`, `message`, `preferredStyle`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UIAlertController).self)
			willProduce(stubber)
			return given
        }
        public static func tableViewRowAction(style: Parameter<UITableViewRowAction.Style>, title: Parameter<String?>, handler: Parameter<(UITableViewRowAction, IndexPath) -> Void>, willProduce: (Stubber<UITableViewRowAction>) -> Void) -> MethodStub {
            let willReturn: [UITableViewRowAction] = []
			let given: Given = { return Given(method: .m_tableViewRowAction__style_styletitle_titlehandler_handler(`style`, `title`, `handler`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UITableViewRowAction).self)
			willProduce(stubber)
			return given
        }
        public static func alertAction(title: Parameter<String?>, style: Parameter<UIAlertAction.Style>, handler: Parameter<((UIAlertAction) -> Void)?>, willProduce: (Stubber<UIAlertAction>) -> Void) -> MethodStub {
            let willReturn: [UIAlertAction] = []
			let given: Given = { return Given(method: .m_alertAction__title_titlestyle_stylehandler_handler(`title`, `style`, `handler`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UIAlertAction).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func customPresenter(width: Parameter<ModalSize>, height: Parameter<ModalSize>, center: Parameter<ModalCenterPosition>) -> Verify { return Verify(method: .m_customPresenter__width_widthheight_heightcenter_center(`width`, `height`, `center`))}
        public static func setView(_ view: Parameter<UIView>, enabled: Parameter<Bool?>, hidden: Parameter<Bool?>) -> Verify { return Verify(method: .m_setView__viewenabled_enabledhidden_hidden(`view`, `enabled`, `hidden`))}
        public static func setButton(_ button: Parameter<UIButton>, enabled: Parameter<Bool?>, hidden: Parameter<Bool?>) -> Verify { return Verify(method: .m_setButton__buttonenabled_enabledhidden_hidden(`button`, `enabled`, `hidden`))}
        public static func setBackButton(for viewController: Parameter<UIViewController>, title: Parameter<String>, action selector: Parameter<Selector>) -> Verify { return Verify(method: .m_setBackButton__for_viewControllertitle_titleaction_selector(`viewController`, `title`, `selector`))}
        public static func addSaveButtonToKeyboardFor(_ textView: Parameter<UITextView>, target: Parameter<Any?>, action: Parameter<Selector?>) -> Verify { return Verify(method: .m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action(`textView`, `target`, `action`))}
        public static func addSaveButtonToKeyboardFor(_ textField: Parameter<UITextField>, target: Parameter<Any?>, action: Parameter<Selector?>) -> Verify { return Verify(method: .m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action(`textField`, `target`, `action`))}
        public static func value(for key: Parameter<UserInfoKey>, from notification: Parameter<Notification>, keyIsOptional: Parameter<Bool>) -> Verify { return Verify(method: .m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(`key`, `notification`, `keyIsOptional`))}
        public static func info(_ info: Parameter<[UserInfoKey: Any]>) -> Verify { return Verify(method: .m_info__info(`info`))}
        public static func controller<Type>(named controllerName: Parameter<String>, from storyboardName: Parameter<String>, as: Parameter<Type.Type>) -> Verify where Type:UIViewController { return Verify(method: .m_controller__named_controllerNamefrom_storyboardNameas_as(`controllerName`, `storyboardName`, `as`.wrapAsGeneric()))}
        public static func controller<Type>(named controllerName: Parameter<String>, from storyboard: Parameter<UIStoryboard>, as: Parameter<Type.Type>) -> Verify where Type:UIViewController { return Verify(method: .m_controller__named_controllerNamefrom_storyboardas_as(`controllerName`, `storyboard`, `as`.wrapAsGeneric()))}
        public static func documentPicker(docTypes: Parameter<[String]>, in pickerMode: Parameter<UIDocumentPickerMode>) -> Verify { return Verify(method: .m_documentPicker__docTypes_docTypesin_pickerMode(`docTypes`, `pickerMode`))}
        public static func alert(title: Parameter<String?>, message: Parameter<String?>, preferredStyle: Parameter<UIAlertController.Style>) -> Verify { return Verify(method: .m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(`title`, `message`, `preferredStyle`))}
        public static func tableViewRowAction(style: Parameter<UITableViewRowAction.Style>, title: Parameter<String?>, handler: Parameter<(UITableViewRowAction, IndexPath) -> Void>) -> Verify { return Verify(method: .m_tableViewRowAction__style_styletitle_titlehandler_handler(`style`, `title`, `handler`))}
        public static func alertAction(title: Parameter<String?>, style: Parameter<UIAlertAction.Style>, handler: Parameter<((UIAlertAction) -> Void)?>) -> Verify { return Verify(method: .m_alertAction__title_titlestyle_stylehandler_handler(`title`, `style`, `handler`))}
        public static func stopObserving(_ observer: Parameter<Any>, name: Parameter<NotificationName?>, object: Parameter<Any?>) -> Verify { return Verify(method: .m_stopObserving__observername_nameobject_object(`observer`, `name`, `object`))}
        public static func post(name: Parameter<Notification.Name>, object: Parameter<Any?>, userInfo: Parameter<[AnyHashable: Any]?>) -> Verify { return Verify(method: .m_post__name_nameobject_objectuserInfo_userInfo_1(`name`, `object`, `userInfo`))}
        public static func post(name: Parameter<NotificationName>, object: Parameter<Any?>, userInfo: Parameter<[AnyHashable: Any]?>) -> Verify { return Verify(method: .m_post__name_nameobject_objectuserInfo_userInfo_2(`name`, `object`, `userInfo`))}
        public static func present(_ presentingController: Parameter<UIViewController>, _ controllerBeingPresented: Parameter<UIViewController>, animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(`presentingController`, `controllerBeingPresented`, `animated`, `completion`))}
        public static func present(_ viewController: Parameter<UIViewController>, on presentingController: Parameter<UIViewController>, using presenter: Parameter<Presentr>, animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(`viewController`, `presentingController`, `presenter`, `animated`, `completion`))}
        public static func push(controller: Parameter<UIViewController>, toNavigationController navigationController: Parameter<UINavigationController?>, animated: Parameter<Bool>) -> Verify { return Verify(method: .m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(`controller`, `navigationController`, `animated`))}
        public static func popFrom(_ navigationController: Parameter<UINavigationController?>, animated: Parameter<Bool>) -> Verify { return Verify(method: .m_popFrom__navigationControlleranimated_animated(`navigationController`, `animated`))}
        public static func sendUserNotification(withContent content: Parameter<UNMutableNotificationContent>, id: Parameter<String>, repeats: Parameter<Bool>, interval: Parameter<TimeInterval>) -> Verify { return Verify(method: .m_sendUserNotification__withContent_contentid_idrepeats_repeatsinterval_interval(`content`, `id`, `repeats`, `interval`))}
        public static var defaultPresenter: Verify { return Verify(method: .p_defaultPresenter_get) }
        public static var hasTopNotch: Verify { return Verify(method: .p_hasTopNotch_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func customPresenter(width: Parameter<ModalSize>, height: Parameter<ModalSize>, center: Parameter<ModalCenterPosition>, perform: @escaping (ModalSize, ModalSize, ModalCenterPosition) -> Void) -> Perform {
            return Perform(method: .m_customPresenter__width_widthheight_heightcenter_center(`width`, `height`, `center`), performs: perform)
        }
        public static func setView(_ view: Parameter<UIView>, enabled: Parameter<Bool?>, hidden: Parameter<Bool?>, perform: @escaping (UIView, Bool?, Bool?) -> Void) -> Perform {
            return Perform(method: .m_setView__viewenabled_enabledhidden_hidden(`view`, `enabled`, `hidden`), performs: perform)
        }
        public static func setButton(_ button: Parameter<UIButton>, enabled: Parameter<Bool?>, hidden: Parameter<Bool?>, perform: @escaping (UIButton, Bool?, Bool?) -> Void) -> Perform {
            return Perform(method: .m_setButton__buttonenabled_enabledhidden_hidden(`button`, `enabled`, `hidden`), performs: perform)
        }
        public static func setBackButton(for viewController: Parameter<UIViewController>, title: Parameter<String>, action selector: Parameter<Selector>, perform: @escaping (UIViewController, String, Selector) -> Void) -> Perform {
            return Perform(method: .m_setBackButton__for_viewControllertitle_titleaction_selector(`viewController`, `title`, `selector`), performs: perform)
        }
        public static func addSaveButtonToKeyboardFor(_ textView: Parameter<UITextView>, target: Parameter<Any?>, action: Parameter<Selector?>, perform: @escaping (UITextView, Any?, Selector?) -> Void) -> Perform {
            return Perform(method: .m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action(`textView`, `target`, `action`), performs: perform)
        }
        public static func addSaveButtonToKeyboardFor(_ textField: Parameter<UITextField>, target: Parameter<Any?>, action: Parameter<Selector?>, perform: @escaping (UITextField, Any?, Selector?) -> Void) -> Perform {
            return Perform(method: .m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action(`textField`, `target`, `action`), performs: perform)
        }
        public static func value(for key: Parameter<UserInfoKey>, from notification: Parameter<Notification>, keyIsOptional: Parameter<Bool>, perform: @escaping (UserInfoKey, Notification, Bool) -> Void) -> Perform {
            return Perform(method: .m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(`key`, `notification`, `keyIsOptional`), performs: perform)
        }
        public static func info(_ info: Parameter<[UserInfoKey: Any]>, perform: @escaping ([UserInfoKey: Any]) -> Void) -> Perform {
            return Perform(method: .m_info__info(`info`), performs: perform)
        }
        public static func controller<Type>(named controllerName: Parameter<String>, from storyboardName: Parameter<String>, as: Parameter<Type.Type>, perform: @escaping (String, String, Type.Type) -> Void) -> Perform where Type:UIViewController {
            return Perform(method: .m_controller__named_controllerNamefrom_storyboardNameas_as(`controllerName`, `storyboardName`, `as`.wrapAsGeneric()), performs: perform)
        }
        public static func controller<Type>(named controllerName: Parameter<String>, from storyboard: Parameter<UIStoryboard>, as: Parameter<Type.Type>, perform: @escaping (String, UIStoryboard, Type.Type) -> Void) -> Perform where Type:UIViewController {
            return Perform(method: .m_controller__named_controllerNamefrom_storyboardas_as(`controllerName`, `storyboard`, `as`.wrapAsGeneric()), performs: perform)
        }
        public static func documentPicker(docTypes: Parameter<[String]>, in pickerMode: Parameter<UIDocumentPickerMode>, perform: @escaping ([String], UIDocumentPickerMode) -> Void) -> Perform {
            return Perform(method: .m_documentPicker__docTypes_docTypesin_pickerMode(`docTypes`, `pickerMode`), performs: perform)
        }
        public static func alert(title: Parameter<String?>, message: Parameter<String?>, preferredStyle: Parameter<UIAlertController.Style>, perform: @escaping (String?, String?, UIAlertController.Style) -> Void) -> Perform {
            return Perform(method: .m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(`title`, `message`, `preferredStyle`), performs: perform)
        }
        public static func tableViewRowAction(style: Parameter<UITableViewRowAction.Style>, title: Parameter<String?>, handler: Parameter<(UITableViewRowAction, IndexPath) -> Void>, perform: @escaping (UITableViewRowAction.Style, String?, @escaping (UITableViewRowAction, IndexPath) -> Void) -> Void) -> Perform {
            return Perform(method: .m_tableViewRowAction__style_styletitle_titlehandler_handler(`style`, `title`, `handler`), performs: perform)
        }
        public static func alertAction(title: Parameter<String?>, style: Parameter<UIAlertAction.Style>, handler: Parameter<((UIAlertAction) -> Void)?>, perform: @escaping (String?, UIAlertAction.Style, ((UIAlertAction) -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_alertAction__title_titlestyle_stylehandler_handler(`title`, `style`, `handler`), performs: perform)
        }
        public static func stopObserving(_ observer: Parameter<Any>, name: Parameter<NotificationName?>, object: Parameter<Any?>, perform: @escaping (Any, NotificationName?, Any?) -> Void) -> Perform {
            return Perform(method: .m_stopObserving__observername_nameobject_object(`observer`, `name`, `object`), performs: perform)
        }
        public static func post(name: Parameter<Notification.Name>, object: Parameter<Any?>, userInfo: Parameter<[AnyHashable: Any]?>, perform: @escaping (Notification.Name, Any?, [AnyHashable: Any]?) -> Void) -> Perform {
            return Perform(method: .m_post__name_nameobject_objectuserInfo_userInfo_1(`name`, `object`, `userInfo`), performs: perform)
        }
        public static func post(name: Parameter<NotificationName>, object: Parameter<Any?>, userInfo: Parameter<[AnyHashable: Any]?>, perform: @escaping (NotificationName, Any?, [AnyHashable: Any]?) -> Void) -> Perform {
            return Perform(method: .m_post__name_nameobject_objectuserInfo_userInfo_2(`name`, `object`, `userInfo`), performs: perform)
        }
        public static func present(_ presentingController: Parameter<UIViewController>, _ controllerBeingPresented: Parameter<UIViewController>, animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>, perform: @escaping (UIViewController, UIViewController, Bool, (() -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(`presentingController`, `controllerBeingPresented`, `animated`, `completion`), performs: perform)
        }
        public static func present(_ viewController: Parameter<UIViewController>, on presentingController: Parameter<UIViewController>, using presenter: Parameter<Presentr>, animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>, perform: @escaping (UIViewController, UIViewController, Presentr, Bool, (() -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(`viewController`, `presentingController`, `presenter`, `animated`, `completion`), performs: perform)
        }
        public static func push(controller: Parameter<UIViewController>, toNavigationController navigationController: Parameter<UINavigationController?>, animated: Parameter<Bool>, perform: @escaping (UIViewController, UINavigationController?, Bool) -> Void) -> Perform {
            return Perform(method: .m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(`controller`, `navigationController`, `animated`), performs: perform)
        }
        public static func popFrom(_ navigationController: Parameter<UINavigationController?>, animated: Parameter<Bool>, perform: @escaping (UINavigationController?, Bool) -> Void) -> Perform {
            return Perform(method: .m_popFrom__navigationControlleranimated_animated(`navigationController`, `animated`), performs: perform)
        }
        public static func sendUserNotification(withContent content: Parameter<UNMutableNotificationContent>, id: Parameter<String>, repeats: Parameter<Bool>, interval: Parameter<TimeInterval>, perform: @escaping (UNMutableNotificationContent, String, Bool, TimeInterval) -> Void) -> Perform {
            return Perform(method: .m_sendUserNotification__withContent_contentid_idrepeats_repeatsinterval_interval(`content`, `id`, `repeats`, `interval`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - UserDefaultsUtil
open class UserDefaultsUtilMock: UserDefaultsUtil, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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





    open func resetInstructionPrompts() {
        addInvocation(.m_resetInstructionPrompts)
		let perform = methodPerformValue(.m_resetInstructionPrompts) as? () -> Void
		perform?()
    }

    open func setUserDefault<ValueType>(_ value: ValueType, forKey key: UserDefaultKey) {
        addInvocation(.m_setUserDefault__valueforKey_key(Parameter<ValueType>.value(`value`).wrapAsGeneric(), Parameter<UserDefaultKey>.value(`key`)))
		let perform = methodPerformValue(.m_setUserDefault__valueforKey_key(Parameter<ValueType>.value(`value`).wrapAsGeneric(), Parameter<UserDefaultKey>.value(`key`))) as? (ValueType, UserDefaultKey) -> Void
		perform?(`value`, `key`)
    }

    open func bool(forKey key: UserDefaultKey) -> Bool {
        addInvocation(.m_bool__forKey_key(Parameter<UserDefaultKey>.value(`key`)))
		let perform = methodPerformValue(.m_bool__forKey_key(Parameter<UserDefaultKey>.value(`key`))) as? (UserDefaultKey) -> Void
		perform?(`key`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_bool__forKey_key(Parameter<UserDefaultKey>.value(`key`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for bool(forKey key: UserDefaultKey). Use given")
			Failure("Stub return value not specified for bool(forKey key: UserDefaultKey). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_resetInstructionPrompts
        case m_setUserDefault__valueforKey_key(Parameter<GenericAttribute>, Parameter<UserDefaultKey>)
        case m_bool__forKey_key(Parameter<UserDefaultKey>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_resetInstructionPrompts, .m_resetInstructionPrompts):
                return true 
            case (.m_setUserDefault__valueforKey_key(let lhsValue, let lhsKey), .m_setUserDefault__valueforKey_key(let rhsValue, let rhsKey)):
                guard Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher) else { return false } 
                guard Parameter.compare(lhs: lhsKey, rhs: rhsKey, with: matcher) else { return false } 
                return true 
            case (.m_bool__forKey_key(let lhsKey), .m_bool__forKey_key(let rhsKey)):
                guard Parameter.compare(lhs: lhsKey, rhs: rhsKey, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_resetInstructionPrompts: return 0
            case let .m_setUserDefault__valueforKey_key(p0, p1): return p0.intValue + p1.intValue
            case let .m_bool__forKey_key(p0): return p0.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func bool(forKey key: Parameter<UserDefaultKey>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_bool__forKey_key(`key`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func bool(forKey key: Parameter<UserDefaultKey>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_bool__forKey_key(`key`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func resetInstructionPrompts() -> Verify { return Verify(method: .m_resetInstructionPrompts)}
        public static func setUserDefault<ValueType>(_ value: Parameter<ValueType>, forKey key: Parameter<UserDefaultKey>) -> Verify { return Verify(method: .m_setUserDefault__valueforKey_key(`value`.wrapAsGeneric(), `key`))}
        public static func bool(forKey key: Parameter<UserDefaultKey>) -> Verify { return Verify(method: .m_bool__forKey_key(`key`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func resetInstructionPrompts(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetInstructionPrompts, performs: perform)
        }
        public static func setUserDefault<ValueType>(_ value: Parameter<ValueType>, forKey key: Parameter<UserDefaultKey>, perform: @escaping (ValueType, UserDefaultKey) -> Void) -> Perform {
            return Perform(method: .m_setUserDefault__valueforKey_key(`value`.wrapAsGeneric(), `key`), performs: perform)
        }
        public static func bool(forKey key: Parameter<UserDefaultKey>, perform: @escaping (UserDefaultKey) -> Void) -> Perform {
            return Perform(method: .m_bool__forKey_key(`key`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - WeightQuery
open class WeightQueryMock: WeightQuery, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var expression: BooleanExpression? {
		get {	invocations.append(.p_expression_get); return __p_expression ?? optionalGivenGetterValue(.p_expression_get, "WeightQueryMock - stub value for expression was not defined") }
		set {	invocations.append(.p_expression_set(.value(newValue))); __p_expression = newValue }
	}
	private var __p_expression: (BooleanExpression)?

    public var mostRecentEntryOnly: Bool {
		get {	invocations.append(.p_mostRecentEntryOnly_get); return __p_mostRecentEntryOnly ?? givenGetterValue(.p_mostRecentEntryOnly_get, "WeightQueryMock - stub value for mostRecentEntryOnly was not defined") }
		set {	invocations.append(.p_mostRecentEntryOnly_set(.value(newValue))); __p_mostRecentEntryOnly = newValue }
	}
	private var __p_mostRecentEntryOnly: (Bool)?

    public var subQuery: (matcher: SubQueryMatcher, query: Query)? {
		get {	invocations.append(.p_subQuery_get); return __p_subQuery ?? optionalGivenGetterValue(.p_subQuery_get, "WeightQueryMock - stub value for subQuery was not defined") }
		set {	invocations.append(.p_subQuery_set(.value(newValue))); __p_subQuery = newValue }
	}
	private var __p_subQuery: ((matcher: SubQueryMatcher, query: Query))?





    public required init(parts: [BooleanExpressionPart]) throws { }

    open func runQuery(callback: @escaping (QueryResult?, Error?) -> ()) {
        addInvocation(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`)))
		let perform = methodPerformValue(.m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>.value(`callback`))) as? (@escaping (QueryResult?, Error?) -> ()) -> Void
		perform?(`callback`)
    }

    open func stop() {
        addInvocation(.m_stop)
		let perform = methodPerformValue(.m_stop) as? () -> Void
		perform?()
    }

    open func resetStoppedState() {
        addInvocation(.m_resetStoppedState)
		let perform = methodPerformValue(.m_resetStoppedState) as? () -> Void
		perform?()
    }

    open func equalTo(_ otherQuery: Query) -> Bool {
        addInvocation(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`)))
		let perform = methodPerformValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))) as? (Query) -> Void
		perform?(`otherQuery`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherQuery(Parameter<Query>.value(`otherQuery`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
			Failure("Stub return value not specified for equalTo(_ otherQuery: Query). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_runQuery__callback_callback(Parameter<(QueryResult?, Error?) -> ()>)
        case m_stop
        case m_resetStoppedState
        case m_equalTo__otherQuery(Parameter<Query>)
        case p_expression_get
		case p_expression_set(Parameter<BooleanExpression?>)
        case p_mostRecentEntryOnly_get
		case p_mostRecentEntryOnly_set(Parameter<Bool>)
        case p_subQuery_get
		case p_subQuery_set(Parameter<(matcher: SubQueryMatcher, query: Query)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_runQuery__callback_callback(let lhsCallback), .m_runQuery__callback_callback(let rhsCallback)):
                guard Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher) else { return false } 
                return true 
            case (.m_stop, .m_stop):
                return true 
            case (.m_resetStoppedState, .m_resetStoppedState):
                return true 
            case (.m_equalTo__otherQuery(let lhsOtherquery), .m_equalTo__otherQuery(let rhsOtherquery)):
                guard Parameter.compare(lhs: lhsOtherquery, rhs: rhsOtherquery, with: matcher) else { return false } 
                return true 
            case (.p_expression_get,.p_expression_get): return true
			case (.p_expression_set(let left),.p_expression_set(let right)): return Parameter<BooleanExpression?>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_mostRecentEntryOnly_get,.p_mostRecentEntryOnly_get): return true
			case (.p_mostRecentEntryOnly_set(let left),.p_mostRecentEntryOnly_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            case (.p_subQuery_get,.p_subQuery_get): return true
			case (.p_subQuery_set(let left),.p_subQuery_set(let right)): return Parameter<(matcher: SubQueryMatcher, query: Query)?>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_runQuery__callback_callback(p0): return p0.intValue
            case .m_stop: return 0
            case .m_resetStoppedState: return 0
            case let .m_equalTo__otherQuery(p0): return p0.intValue
            case .p_expression_get: return 0
			case .p_expression_set(let newValue): return newValue.intValue
            case .p_mostRecentEntryOnly_get: return 0
			case .p_mostRecentEntryOnly_set(let newValue): return newValue.intValue
            case .p_subQuery_get: return 0
			case .p_subQuery_set(let newValue): return newValue.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func expression(getter defaultValue: BooleanExpression?...) -> PropertyStub {
            return Given(method: .p_expression_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentEntryOnly(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_mostRecentEntryOnly_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func subQuery(getter defaultValue: (matcher: SubQueryMatcher, query: Query)?...) -> PropertyStub {
            return Given(method: .p_subQuery_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func equalTo(_ otherQuery: Parameter<Query>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherQuery(`otherQuery`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>) -> Verify { return Verify(method: .m_runQuery__callback_callback(`callback`))}
        public static func stop() -> Verify { return Verify(method: .m_stop)}
        public static func resetStoppedState() -> Verify { return Verify(method: .m_resetStoppedState)}
        public static func equalTo(_ otherQuery: Parameter<Query>) -> Verify { return Verify(method: .m_equalTo__otherQuery(`otherQuery`))}
        public static var expression: Verify { return Verify(method: .p_expression_get) }
		public static func expression(set newValue: Parameter<BooleanExpression?>) -> Verify { return Verify(method: .p_expression_set(newValue)) }
        public static var mostRecentEntryOnly: Verify { return Verify(method: .p_mostRecentEntryOnly_get) }
		public static func mostRecentEntryOnly(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_mostRecentEntryOnly_set(newValue)) }
        public static var subQuery: Verify { return Verify(method: .p_subQuery_get) }
		public static func subQuery(set newValue: Parameter<(matcher: SubQueryMatcher, query: Query)?>) -> Verify { return Verify(method: .p_subQuery_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func runQuery(callback: Parameter<(QueryResult?, Error?) -> ()>, perform: @escaping (@escaping (QueryResult?, Error?) -> ()) -> Void) -> Perform {
            return Perform(method: .m_runQuery__callback_callback(`callback`), performs: perform)
        }
        public static func stop(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stop, performs: perform)
        }
        public static func resetStoppedState(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetStoppedState, performs: perform)
        }
        public static func equalTo(_ otherQuery: Parameter<Query>, perform: @escaping (Query) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherQuery(`otherQuery`), performs: perform)
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

// MARK: - WellnessMoodImporter
open class WellnessMoodImporterMock: WellnessMoodImporter, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
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

    public var dataTypePluralName: String {
		get {	invocations.append(.p_dataTypePluralName_get); return __p_dataTypePluralName ?? givenGetterValue(.p_dataTypePluralName_get, "WellnessMoodImporterMock - stub value for dataTypePluralName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_dataTypePluralName = newValue }
	}
	private var __p_dataTypePluralName: (String)?

    public var sourceName: String {
		get {	invocations.append(.p_sourceName_get); return __p_sourceName ?? givenGetterValue(.p_sourceName_get, "WellnessMoodImporterMock - stub value for sourceName was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_sourceName = newValue }
	}
	private var __p_sourceName: (String)?

    public var customImportMessage: String? {
		get {	invocations.append(.p_customImportMessage_get); return __p_customImportMessage ?? optionalGivenGetterValue(.p_customImportMessage_get, "WellnessMoodImporterMock - stub value for customImportMessage was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_customImportMessage = newValue }
	}
	private var __p_customImportMessage: (String)?

    public var lastImport: Date? {
		get {	invocations.append(.p_lastImport_get); return __p_lastImport ?? optionalGivenGetterValue(.p_lastImport_get, "WellnessMoodImporterMock - stub value for lastImport was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_lastImport = newValue }
	}
	private var __p_lastImport: (Date)?

    public var isPaused: Bool {
		get {	invocations.append(.p_isPaused_get); return __p_isPaused ?? givenGetterValue(.p_isPaused_get, "WellnessMoodImporterMock - stub value for isPaused was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isPaused = newValue }
	}
	private var __p_isPaused: (Bool)?

    public var isCancelled: Bool {
		get {	invocations.append(.p_isCancelled_get); return __p_isCancelled ?? givenGetterValue(.p_isCancelled_get, "WellnessMoodImporterMock - stub value for isCancelled was not defined") }
		@available(*, deprecated, message: "Using setters on readonly variables is deprecated, and will be removed in 3.1. Use Given to define stubbed property return value.")
		set {	__p_isCancelled = newValue }
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_importData__from_url(let lhsUrl), .m_importData__from_url(let rhsUrl)):
                guard Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher) else { return false } 
                return true 
            case (.m_resetLastImportDate, .m_resetLastImportDate):
                return true 
            case (.m_percentComplete, .m_percentComplete):
                return true 
            case (.m_cancel, .m_cancel):
                return true 
            case (.m_pause, .m_pause):
                return true 
            case (.m_resume, .m_resume):
                return true 
            case (.m_equalTo__other(let lhsOther), .m_equalTo__other(let rhsOther)):
                guard Parameter.compare(lhs: lhsOther, rhs: rhsOther, with: matcher) else { return false } 
                return true 
            case (.p_dataTypePluralName_get,.p_dataTypePluralName_get): return true
            case (.p_sourceName_get,.p_sourceName_get): return true
            case (.p_customImportMessage_get,.p_customImportMessage_get): return true
            case (.p_lastImport_get,.p_lastImport_get): return true
            case (.p_isPaused_get,.p_isPaused_get): return true
            case (.p_isCancelled_get,.p_isCancelled_get): return true
            case (.p_importOnlyNewData_get,.p_importOnlyNewData_get): return true
			case (.p_importOnlyNewData_set(let left),.p_importOnlyNewData_set(let right)): return Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher)
            default: return false
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
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
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
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

