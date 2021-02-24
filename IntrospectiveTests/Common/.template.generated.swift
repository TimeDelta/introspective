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


// MARK: - AsyncUtil

open class AsyncUtilMock: AsyncUtil, Mock {
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






    open func run(qos: DispatchQoS.QoSClass, code: @escaping () -> Void) {
        addInvocation(.m_run__qos_qoscode_code(Parameter<DispatchQoS.QoSClass>.value(`qos`), Parameter<() -> Void>.value(`code`)))
		let perform = methodPerformValue(.m_run__qos_qoscode_code(Parameter<DispatchQoS.QoSClass>.value(`qos`), Parameter<() -> Void>.value(`code`))) as? (DispatchQoS.QoSClass, @escaping () -> Void) -> Void
		perform?(`qos`, `code`)
    }


    fileprivate enum MethodType {
        case m_run__qos_qoscode_code(Parameter<DispatchQoS.QoSClass>, Parameter<() -> Void>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_run__qos_qoscode_code(let lhsQos, let lhsCode), .m_run__qos_qoscode_code(let rhsQos, let rhsCode)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsQos) && !isCapturing(rhsQos) {
					comparison = Parameter.compare(lhs: lhsQos, rhs: rhsQos, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsQos, rhsQos, "qos"))
				}


				if !isCapturing(lhsCode) && !isCapturing(rhsCode) {
					comparison = Parameter.compare(lhs: lhsCode, rhs: rhsCode, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCode, rhsCode, "code"))
				}

				if isCapturing(lhsQos) || isCapturing(rhsQos) {
					comparison = Parameter.compare(lhs: lhsQos, rhs: rhsQos, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsQos, rhsQos, "qos"))
				}


				if isCapturing(lhsCode) || isCapturing(rhsCode) {
					comparison = Parameter.compare(lhs: lhsCode, rhs: rhsCode, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCode, rhsCode, "code"))
				}

				return Matcher.ComparisonResult(results)
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_run__qos_qoscode_code(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_run__qos_qoscode_code: return ".run(qos:code:)"
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

        public static func run(qos: Parameter<DispatchQoS.QoSClass>, code: Parameter<() -> Void>) -> Verify { return Verify(method: .m_run__qos_qoscode_code(`qos`, `code`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func run(qos: Parameter<DispatchQoS.QoSClass>, code: Parameter<() -> Void>, perform: @escaping (DispatchQoS.QoSClass, @escaping () -> Void) -> Void) -> Perform {
            return Perform(method: .m_run__qos_qoscode_code(`qos`, `code`), performs: perform)
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

// MARK: - CalendarUtil

open class CalendarUtilMock: CalendarUtil, Mock {
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

    open func date(from dateString: String, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> Date? {
        addInvocation(.m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle(Parameter<String>.value(`dateString`), Parameter<DateFormatter.Style>.value(`dateStyle`), Parameter<DateFormatter.Style>.value(`timeStyle`)))
		let perform = methodPerformValue(.m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle(Parameter<String>.value(`dateString`), Parameter<DateFormatter.Style>.value(`dateStyle`), Parameter<DateFormatter.Style>.value(`timeStyle`))) as? (String, DateFormatter.Style, DateFormatter.Style) -> Void
		perform?(`dateString`, `dateStyle`, `timeStyle`)
		var __value: Date? = nil
		do {
		    __value = try methodReturnValue(.m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle(Parameter<String>.value(`dateString`), Parameter<DateFormatter.Style>.value(`dateStyle`), Parameter<DateFormatter.Style>.value(`timeStyle`))).casted()
		} catch {
			// do nothing
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

    open func date<CollectionType: Collection>(_ date: Date, isOnOneOf daysOfWeek: CollectionType) -> Bool
		where CollectionType.Element == DayOfWeek {
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

    open func ago(_ numUnits: Int, _ timeUnit: Calendar.Component) -> Date {
        addInvocation(.m_ago__numUnits_timeUnit(Parameter<Int>.value(`numUnits`), Parameter<Calendar.Component>.value(`timeUnit`)))
		let perform = methodPerformValue(.m_ago__numUnits_timeUnit(Parameter<Int>.value(`numUnits`), Parameter<Calendar.Component>.value(`timeUnit`))) as? (Int, Calendar.Component) -> Void
		perform?(`numUnits`, `timeUnit`)
		var __value: Date
		do {
		    __value = try methodReturnValue(.m_ago__numUnits_timeUnit(Parameter<Int>.value(`numUnits`), Parameter<Calendar.Component>.value(`timeUnit`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for ago(_ numUnits: Int, _ timeUnit: Calendar.Component). Use given")
			Failure("Stub return value not specified for ago(_ numUnits: Int, _ timeUnit: Calendar.Component). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_convert__datefrom_fromTimeZoneto_toTimeZone(Parameter<Date>, Parameter<TimeZone>, Parameter<TimeZone>)
        case m_start__of_componentin_date(Parameter<Calendar.Component>, Parameter<Date>)
        case m_end__of_componentin_date(Parameter<Calendar.Component>, Parameter<Date>)
        case m_string__for_dateinFormat_format(Parameter<Date>, Parameter<String>)
        case m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(Parameter<Date>, Parameter<DateFormatter.Style>, Parameter<DateFormatter.Style>)
        case m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle(Parameter<String>, Parameter<DateFormatter.Style>, Parameter<DateFormatter.Style>)
        case m_date__date1occursOnSame_componentas_date2(Parameter<Date>, Parameter<Calendar.Component>, Parameter<Date>)
        case m_compare__date1_date2(Parameter<Date?>, Parameter<Date?>)
        case m_date__dateisOnOneOf_daysOfWeek(Parameter<Date>, Parameter<GenericAttribute>)
        case m_date__dateisOnA_dayOfWeek(Parameter<Date>, Parameter<DayOfWeek>)
        case m_date__from_dateStrformat_format(Parameter<String>, Parameter<String?>)
        case m_dayOfWeek__forDate_date(Parameter<Date>)
        case m_distance__from_date1to_date2in_unit(Parameter<Date>, Parameter<Date>, Parameter<Calendar.Component>)
        case m_currentTimeZone
        case m_ago__numUnits_timeUnit(Parameter<Int>, Parameter<Calendar.Component>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_convert__datefrom_fromTimeZoneto_toTimeZone(let lhsDate, let lhsFromtimezone, let lhsTotimezone), .m_convert__datefrom_fromTimeZoneto_toTimeZone(let rhsDate, let rhsFromtimezone, let rhsTotimezone)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDate) && !isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "_ date"))
				}


				if !isCapturing(lhsFromtimezone) && !isCapturing(rhsFromtimezone) {
					comparison = Parameter.compare(lhs: lhsFromtimezone, rhs: rhsFromtimezone, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFromtimezone, rhsFromtimezone, "from fromTimeZone"))
				}


				if !isCapturing(lhsTotimezone) && !isCapturing(rhsTotimezone) {
					comparison = Parameter.compare(lhs: lhsTotimezone, rhs: rhsTotimezone, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTotimezone, rhsTotimezone, "to toTimeZone"))
				}

				if isCapturing(lhsDate) || isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "_ date"))
				}


				if isCapturing(lhsFromtimezone) || isCapturing(rhsFromtimezone) {
					comparison = Parameter.compare(lhs: lhsFromtimezone, rhs: rhsFromtimezone, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFromtimezone, rhsFromtimezone, "from fromTimeZone"))
				}


				if isCapturing(lhsTotimezone) || isCapturing(rhsTotimezone) {
					comparison = Parameter.compare(lhs: lhsTotimezone, rhs: rhsTotimezone, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTotimezone, rhsTotimezone, "to toTimeZone"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_start__of_componentin_date(let lhsComponent, let lhsDate), .m_start__of_componentin_date(let rhsComponent, let rhsDate)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsComponent) && !isCapturing(rhsComponent) {
					comparison = Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsComponent, rhsComponent, "of component"))
				}


				if !isCapturing(lhsDate) && !isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "in date"))
				}

				if isCapturing(lhsComponent) || isCapturing(rhsComponent) {
					comparison = Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsComponent, rhsComponent, "of component"))
				}


				if isCapturing(lhsDate) || isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "in date"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_end__of_componentin_date(let lhsComponent, let lhsDate), .m_end__of_componentin_date(let rhsComponent, let rhsDate)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsComponent) && !isCapturing(rhsComponent) {
					comparison = Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsComponent, rhsComponent, "of component"))
				}


				if !isCapturing(lhsDate) && !isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "in date"))
				}

				if isCapturing(lhsComponent) || isCapturing(rhsComponent) {
					comparison = Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsComponent, rhsComponent, "of component"))
				}


				if isCapturing(lhsDate) || isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "in date"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_string__for_dateinFormat_format(let lhsDate, let lhsFormat), .m_string__for_dateinFormat_format(let rhsDate, let rhsFormat)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDate) && !isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "for date"))
				}


				if !isCapturing(lhsFormat) && !isCapturing(rhsFormat) {
					comparison = Parameter.compare(lhs: lhsFormat, rhs: rhsFormat, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFormat, rhsFormat, "inFormat format"))
				}

				if isCapturing(lhsDate) || isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "for date"))
				}


				if isCapturing(lhsFormat) || isCapturing(rhsFormat) {
					comparison = Parameter.compare(lhs: lhsFormat, rhs: rhsFormat, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFormat, rhsFormat, "inFormat format"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(let lhsDate, let lhsDatestyle, let lhsTimestyle), .m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(let rhsDate, let rhsDatestyle, let rhsTimestyle)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDate) && !isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "for date"))
				}


				if !isCapturing(lhsDatestyle) && !isCapturing(rhsDatestyle) {
					comparison = Parameter.compare(lhs: lhsDatestyle, rhs: rhsDatestyle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatestyle, rhsDatestyle, "dateStyle"))
				}


				if !isCapturing(lhsTimestyle) && !isCapturing(rhsTimestyle) {
					comparison = Parameter.compare(lhs: lhsTimestyle, rhs: rhsTimestyle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimestyle, rhsTimestyle, "timeStyle"))
				}

				if isCapturing(lhsDate) || isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "for date"))
				}


				if isCapturing(lhsDatestyle) || isCapturing(rhsDatestyle) {
					comparison = Parameter.compare(lhs: lhsDatestyle, rhs: rhsDatestyle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatestyle, rhsDatestyle, "dateStyle"))
				}


				if isCapturing(lhsTimestyle) || isCapturing(rhsTimestyle) {
					comparison = Parameter.compare(lhs: lhsTimestyle, rhs: rhsTimestyle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimestyle, rhsTimestyle, "timeStyle"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle(let lhsDatestring, let lhsDatestyle, let lhsTimestyle), .m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle(let rhsDatestring, let rhsDatestyle, let rhsTimestyle)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDatestring) && !isCapturing(rhsDatestring) {
					comparison = Parameter.compare(lhs: lhsDatestring, rhs: rhsDatestring, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatestring, rhsDatestring, "from dateString"))
				}


				if !isCapturing(lhsDatestyle) && !isCapturing(rhsDatestyle) {
					comparison = Parameter.compare(lhs: lhsDatestyle, rhs: rhsDatestyle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatestyle, rhsDatestyle, "dateStyle"))
				}


				if !isCapturing(lhsTimestyle) && !isCapturing(rhsTimestyle) {
					comparison = Parameter.compare(lhs: lhsTimestyle, rhs: rhsTimestyle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimestyle, rhsTimestyle, "timeStyle"))
				}

				if isCapturing(lhsDatestring) || isCapturing(rhsDatestring) {
					comparison = Parameter.compare(lhs: lhsDatestring, rhs: rhsDatestring, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatestring, rhsDatestring, "from dateString"))
				}


				if isCapturing(lhsDatestyle) || isCapturing(rhsDatestyle) {
					comparison = Parameter.compare(lhs: lhsDatestyle, rhs: rhsDatestyle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatestyle, rhsDatestyle, "dateStyle"))
				}


				if isCapturing(lhsTimestyle) || isCapturing(rhsTimestyle) {
					comparison = Parameter.compare(lhs: lhsTimestyle, rhs: rhsTimestyle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimestyle, rhsTimestyle, "timeStyle"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_date__date1occursOnSame_componentas_date2(let lhsDate1, let lhsComponent, let lhsDate2), .m_date__date1occursOnSame_componentas_date2(let rhsDate1, let rhsComponent, let rhsDate2)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDate1) && !isCapturing(rhsDate1) {
					comparison = Parameter.compare(lhs: lhsDate1, rhs: rhsDate1, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate1, rhsDate1, "_ date1"))
				}


				if !isCapturing(lhsComponent) && !isCapturing(rhsComponent) {
					comparison = Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsComponent, rhsComponent, "occursOnSame component"))
				}


				if !isCapturing(lhsDate2) && !isCapturing(rhsDate2) {
					comparison = Parameter.compare(lhs: lhsDate2, rhs: rhsDate2, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate2, rhsDate2, "as date2"))
				}

				if isCapturing(lhsDate1) || isCapturing(rhsDate1) {
					comparison = Parameter.compare(lhs: lhsDate1, rhs: rhsDate1, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate1, rhsDate1, "_ date1"))
				}


				if isCapturing(lhsComponent) || isCapturing(rhsComponent) {
					comparison = Parameter.compare(lhs: lhsComponent, rhs: rhsComponent, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsComponent, rhsComponent, "occursOnSame component"))
				}


				if isCapturing(lhsDate2) || isCapturing(rhsDate2) {
					comparison = Parameter.compare(lhs: lhsDate2, rhs: rhsDate2, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate2, rhsDate2, "as date2"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_compare__date1_date2(let lhsDate1, let lhsDate2), .m_compare__date1_date2(let rhsDate1, let rhsDate2)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDate1) && !isCapturing(rhsDate1) {
					comparison = Parameter.compare(lhs: lhsDate1, rhs: rhsDate1, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate1, rhsDate1, "_ date1"))
				}


				if !isCapturing(lhsDate2) && !isCapturing(rhsDate2) {
					comparison = Parameter.compare(lhs: lhsDate2, rhs: rhsDate2, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate2, rhsDate2, "_ date2"))
				}

				if isCapturing(lhsDate1) || isCapturing(rhsDate1) {
					comparison = Parameter.compare(lhs: lhsDate1, rhs: rhsDate1, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate1, rhsDate1, "_ date1"))
				}


				if isCapturing(lhsDate2) || isCapturing(rhsDate2) {
					comparison = Parameter.compare(lhs: lhsDate2, rhs: rhsDate2, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate2, rhsDate2, "_ date2"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_date__dateisOnOneOf_daysOfWeek(let lhsDate, let lhsDaysofweek), .m_date__dateisOnOneOf_daysOfWeek(let rhsDate, let rhsDaysofweek)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDate) && !isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "_ date"))
				}


				if !isCapturing(lhsDaysofweek) && !isCapturing(rhsDaysofweek) {
					comparison = Parameter.compare(lhs: lhsDaysofweek, rhs: rhsDaysofweek, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDaysofweek, rhsDaysofweek, "isOnOneOf daysOfWeek"))
				}

				if isCapturing(lhsDate) || isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "_ date"))
				}


				if isCapturing(lhsDaysofweek) || isCapturing(rhsDaysofweek) {
					comparison = Parameter.compare(lhs: lhsDaysofweek, rhs: rhsDaysofweek, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDaysofweek, rhsDaysofweek, "isOnOneOf daysOfWeek"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_date__dateisOnA_dayOfWeek(let lhsDate, let lhsDayofweek), .m_date__dateisOnA_dayOfWeek(let rhsDate, let rhsDayofweek)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDate) && !isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "_ date"))
				}


				if !isCapturing(lhsDayofweek) && !isCapturing(rhsDayofweek) {
					comparison = Parameter.compare(lhs: lhsDayofweek, rhs: rhsDayofweek, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDayofweek, rhsDayofweek, "isOnA dayOfWeek"))
				}

				if isCapturing(lhsDate) || isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "_ date"))
				}


				if isCapturing(lhsDayofweek) || isCapturing(rhsDayofweek) {
					comparison = Parameter.compare(lhs: lhsDayofweek, rhs: rhsDayofweek, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDayofweek, rhsDayofweek, "isOnA dayOfWeek"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_date__from_dateStrformat_format(let lhsDatestr, let lhsFormat), .m_date__from_dateStrformat_format(let rhsDatestr, let rhsFormat)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDatestr) && !isCapturing(rhsDatestr) {
					comparison = Parameter.compare(lhs: lhsDatestr, rhs: rhsDatestr, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatestr, rhsDatestr, "from dateStr"))
				}


				if !isCapturing(lhsFormat) && !isCapturing(rhsFormat) {
					comparison = Parameter.compare(lhs: lhsFormat, rhs: rhsFormat, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFormat, rhsFormat, "format"))
				}

				if isCapturing(lhsDatestr) || isCapturing(rhsDatestr) {
					comparison = Parameter.compare(lhs: lhsDatestr, rhs: rhsDatestr, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatestr, rhsDatestr, "from dateStr"))
				}


				if isCapturing(lhsFormat) || isCapturing(rhsFormat) {
					comparison = Parameter.compare(lhs: lhsFormat, rhs: rhsFormat, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFormat, rhsFormat, "format"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_dayOfWeek__forDate_date(let lhsDate), .m_dayOfWeek__forDate_date(let rhsDate)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDate) && !isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "forDate date"))
				}

				if isCapturing(lhsDate) || isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "forDate date"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_distance__from_date1to_date2in_unit(let lhsDate1, let lhsDate2, let lhsUnit), .m_distance__from_date1to_date2in_unit(let rhsDate1, let rhsDate2, let rhsUnit)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDate1) && !isCapturing(rhsDate1) {
					comparison = Parameter.compare(lhs: lhsDate1, rhs: rhsDate1, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate1, rhsDate1, "from date1"))
				}


				if !isCapturing(lhsDate2) && !isCapturing(rhsDate2) {
					comparison = Parameter.compare(lhs: lhsDate2, rhs: rhsDate2, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate2, rhsDate2, "to date2"))
				}


				if !isCapturing(lhsUnit) && !isCapturing(rhsUnit) {
					comparison = Parameter.compare(lhs: lhsUnit, rhs: rhsUnit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUnit, rhsUnit, "in unit"))
				}

				if isCapturing(lhsDate1) || isCapturing(rhsDate1) {
					comparison = Parameter.compare(lhs: lhsDate1, rhs: rhsDate1, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate1, rhsDate1, "from date1"))
				}


				if isCapturing(lhsDate2) || isCapturing(rhsDate2) {
					comparison = Parameter.compare(lhs: lhsDate2, rhs: rhsDate2, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate2, rhsDate2, "to date2"))
				}


				if isCapturing(lhsUnit) || isCapturing(rhsUnit) {
					comparison = Parameter.compare(lhs: lhsUnit, rhs: rhsUnit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUnit, rhsUnit, "in unit"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_currentTimeZone, .m_currentTimeZone): return .match

            case (.m_ago__numUnits_timeUnit(let lhsNumunits, let lhsTimeunit), .m_ago__numUnits_timeUnit(let rhsNumunits, let rhsTimeunit)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsNumunits) && !isCapturing(rhsNumunits) {
					comparison = Parameter.compare(lhs: lhsNumunits, rhs: rhsNumunits, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNumunits, rhsNumunits, "_ numUnits"))
				}


				if !isCapturing(lhsTimeunit) && !isCapturing(rhsTimeunit) {
					comparison = Parameter.compare(lhs: lhsTimeunit, rhs: rhsTimeunit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimeunit, rhsTimeunit, "_ timeUnit"))
				}

				if isCapturing(lhsNumunits) || isCapturing(rhsNumunits) {
					comparison = Parameter.compare(lhs: lhsNumunits, rhs: rhsNumunits, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNumunits, rhsNumunits, "_ numUnits"))
				}


				if isCapturing(lhsTimeunit) || isCapturing(rhsTimeunit) {
					comparison = Parameter.compare(lhs: lhsTimeunit, rhs: rhsTimeunit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimeunit, rhsTimeunit, "_ timeUnit"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_convert__datefrom_fromTimeZoneto_toTimeZone(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_start__of_componentin_date(p0, p1): return p0.intValue + p1.intValue
            case let .m_end__of_componentin_date(p0, p1): return p0.intValue + p1.intValue
            case let .m_string__for_dateinFormat_format(p0, p1): return p0.intValue + p1.intValue
            case let .m_string__for_datedateStyle_dateStyletimeStyle_timeStyle(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_date__date1occursOnSame_componentas_date2(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_compare__date1_date2(p0, p1): return p0.intValue + p1.intValue
            case let .m_date__dateisOnOneOf_daysOfWeek(p0, p1): return p0.intValue + p1.intValue
            case let .m_date__dateisOnA_dayOfWeek(p0, p1): return p0.intValue + p1.intValue
            case let .m_date__from_dateStrformat_format(p0, p1): return p0.intValue + p1.intValue
            case let .m_dayOfWeek__forDate_date(p0): return p0.intValue
            case let .m_distance__from_date1to_date2in_unit(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case .m_currentTimeZone: return 0
            case let .m_ago__numUnits_timeUnit(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_convert__datefrom_fromTimeZoneto_toTimeZone: return ".convert(_:from:to:)"
            case .m_start__of_componentin_date: return ".start(of:in:)"
            case .m_end__of_componentin_date: return ".end(of:in:)"
            case .m_string__for_dateinFormat_format: return ".string(for:inFormat:)"
            case .m_string__for_datedateStyle_dateStyletimeStyle_timeStyle: return ".string(for:dateStyle:timeStyle:)"
            case .m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle: return ".date(from:dateStyle:timeStyle:)"
            case .m_date__date1occursOnSame_componentas_date2: return ".date(_:occursOnSame:as:)"
            case .m_compare__date1_date2: return ".compare(_:_:)"
            case .m_date__dateisOnOneOf_daysOfWeek: return ".date(_:isOnOneOf:)"
            case .m_date__dateisOnA_dayOfWeek: return ".date(_:isOnA:)"
            case .m_date__from_dateStrformat_format: return ".date(from:format:)"
            case .m_dayOfWeek__forDate_date: return ".dayOfWeek(forDate:)"
            case .m_distance__from_date1to_date2in_unit: return ".distance(from:to:in:)"
            case .m_currentTimeZone: return ".currentTimeZone()"
            case .m_ago__numUnits_timeUnit: return ".ago(_:_:)"
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
        public static func date(from dateString: Parameter<String>, dateStyle: Parameter<DateFormatter.Style>, timeStyle: Parameter<DateFormatter.Style>, willReturn: Date?...) -> MethodStub {
            return Given(method: .m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle(`dateString`, `dateStyle`, `timeStyle`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func date(_ date1: Parameter<Date>, occursOnSame component: Parameter<Calendar.Component>, as date2: Parameter<Date>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_date__date1occursOnSame_componentas_date2(`date1`, `component`, `date2`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func compare(_ date1: Parameter<Date?>, _ date2: Parameter<Date?>, willReturn: ComparisonResult...) -> MethodStub {
            return Given(method: .m_compare__date1_date2(`date1`, `date2`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func date<CollectionType: Collection>(_ date: Parameter<Date>, isOnOneOf daysOfWeek: Parameter<CollectionType>, willReturn: Bool...) -> MethodStub where CollectionType.Element == DayOfWeek {
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
        public static func ago(_ numUnits: Parameter<Int>, _ timeUnit: Parameter<Calendar.Component>, willReturn: Date...) -> MethodStub {
            return Given(method: .m_ago__numUnits_timeUnit(`numUnits`, `timeUnit`), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func date(from dateString: Parameter<String>, dateStyle: Parameter<DateFormatter.Style>, timeStyle: Parameter<DateFormatter.Style>, willProduce: (Stubber<Date?>) -> Void) -> MethodStub {
            let willReturn: [Date?] = []
			let given: Given = { return Given(method: .m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle(`dateString`, `dateStyle`, `timeStyle`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Date?).self)
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
        public static func date<CollectionType: Collection>(_ date: Parameter<Date>, isOnOneOf daysOfWeek: Parameter<CollectionType>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub where CollectionType.Element == DayOfWeek {
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
        public static func ago(_ numUnits: Parameter<Int>, _ timeUnit: Parameter<Calendar.Component>, willProduce: (Stubber<Date>) -> Void) -> MethodStub {
            let willReturn: [Date] = []
			let given: Given = { return Given(method: .m_ago__numUnits_timeUnit(`numUnits`, `timeUnit`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Date).self)
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
        public static func date(from dateString: Parameter<String>, dateStyle: Parameter<DateFormatter.Style>, timeStyle: Parameter<DateFormatter.Style>) -> Verify { return Verify(method: .m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle(`dateString`, `dateStyle`, `timeStyle`))}
        public static func date(_ date1: Parameter<Date>, occursOnSame component: Parameter<Calendar.Component>, as date2: Parameter<Date>) -> Verify { return Verify(method: .m_date__date1occursOnSame_componentas_date2(`date1`, `component`, `date2`))}
        public static func compare(_ date1: Parameter<Date?>, _ date2: Parameter<Date?>) -> Verify { return Verify(method: .m_compare__date1_date2(`date1`, `date2`))}
        public static func date<CollectionType>(_ date: Parameter<Date>, isOnOneOf daysOfWeek: Parameter<CollectionType>) -> Verify where CollectionType:Collection { return Verify(method: .m_date__dateisOnOneOf_daysOfWeek(`date`, `daysOfWeek`.wrapAsGeneric()))}
        public static func date(_ date: Parameter<Date>, isOnA dayOfWeek: Parameter<DayOfWeek>) -> Verify { return Verify(method: .m_date__dateisOnA_dayOfWeek(`date`, `dayOfWeek`))}
        public static func date(from dateStr: Parameter<String>, format: Parameter<String?>) -> Verify { return Verify(method: .m_date__from_dateStrformat_format(`dateStr`, `format`))}
        public static func dayOfWeek(forDate date: Parameter<Date>) -> Verify { return Verify(method: .m_dayOfWeek__forDate_date(`date`))}
        public static func distance(from date1: Parameter<Date>, to date2: Parameter<Date>, in unit: Parameter<Calendar.Component>) -> Verify { return Verify(method: .m_distance__from_date1to_date2in_unit(`date1`, `date2`, `unit`))}
        public static func currentTimeZone() -> Verify { return Verify(method: .m_currentTimeZone)}
        public static func ago(_ numUnits: Parameter<Int>, _ timeUnit: Parameter<Calendar.Component>) -> Verify { return Verify(method: .m_ago__numUnits_timeUnit(`numUnits`, `timeUnit`))}
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
        public static func date(from dateString: Parameter<String>, dateStyle: Parameter<DateFormatter.Style>, timeStyle: Parameter<DateFormatter.Style>, perform: @escaping (String, DateFormatter.Style, DateFormatter.Style) -> Void) -> Perform {
            return Perform(method: .m_date__from_dateStringdateStyle_dateStyletimeStyle_timeStyle(`dateString`, `dateStyle`, `timeStyle`), performs: perform)
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
        public static func ago(_ numUnits: Parameter<Int>, _ timeUnit: Parameter<Calendar.Component>, perform: @escaping (Int, Calendar.Component) -> Void) -> Perform {
            return Perform(method: .m_ago__numUnits_timeUnit(`numUnits`, `timeUnit`), performs: perform)
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

// MARK: - FatigueUiUtil

open class FatigueUiUtilMock: FatigueUiUtil, Mock {
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






    open func valueToString(_ value: Double) -> String {
        addInvocation(.m_valueToString__value(Parameter<Double>.value(`value`)))
		let perform = methodPerformValue(.m_valueToString__value(Parameter<Double>.value(`value`))) as? (Double) -> Void
		perform?(`value`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_valueToString__value(Parameter<Double>.value(`value`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for valueToString(_ value: Double). Use given")
			Failure("Stub return value not specified for valueToString(_ value: Double). Use given")
		}
		return __value
    }

    open func colorForFatigue(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
        addInvocation(.m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating(Parameter<Double>.value(`rating`), Parameter<Double>.value(`minRating`), Parameter<Double>.value(`maxRating`)))
		let perform = methodPerformValue(.m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating(Parameter<Double>.value(`rating`), Parameter<Double>.value(`minRating`), Parameter<Double>.value(`maxRating`))) as? (Double, Double, Double) -> Void
		perform?(`rating`, `minRating`, `maxRating`)
		var __value: UIColor
		do {
		    __value = try methodReturnValue(.m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating(Parameter<Double>.value(`rating`), Parameter<Double>.value(`minRating`), Parameter<Double>.value(`maxRating`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for colorForFatigue(rating: Double, minRating: Double, maxRating: Double). Use given")
			Failure("Stub return value not specified for colorForFatigue(rating: Double, minRating: Double, maxRating: Double). Use given")
		}
		return __value
    }

    open func feedbackMessage(for rating: Double, min: Double, max: Double) -> String {
        addInvocation(.m_feedbackMessage__for_ratingmin_minmax_max(Parameter<Double>.value(`rating`), Parameter<Double>.value(`min`), Parameter<Double>.value(`max`)))
		let perform = methodPerformValue(.m_feedbackMessage__for_ratingmin_minmax_max(Parameter<Double>.value(`rating`), Parameter<Double>.value(`min`), Parameter<Double>.value(`max`))) as? (Double, Double, Double) -> Void
		perform?(`rating`, `min`, `max`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_feedbackMessage__for_ratingmin_minmax_max(Parameter<Double>.value(`rating`), Parameter<Double>.value(`min`), Parameter<Double>.value(`max`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for feedbackMessage(for rating: Double, min: Double, max: Double). Use given")
			Failure("Stub return value not specified for feedbackMessage(for rating: Double, min: Double, max: Double). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_valueToString__value(Parameter<Double>)
        case m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating(Parameter<Double>, Parameter<Double>, Parameter<Double>)
        case m_feedbackMessage__for_ratingmin_minmax_max(Parameter<Double>, Parameter<Double>, Parameter<Double>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_valueToString__value(let lhsValue), .m_valueToString__value(let rhsValue)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsValue) && !isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "_ value"))
				}

				if isCapturing(lhsValue) || isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "_ value"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating(let lhsRating, let lhsMinrating, let lhsMaxrating), .m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating(let rhsRating, let rhsMinrating, let rhsMaxrating)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsRating) && !isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "rating"))
				}


				if !isCapturing(lhsMinrating) && !isCapturing(rhsMinrating) {
					comparison = Parameter.compare(lhs: lhsMinrating, rhs: rhsMinrating, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMinrating, rhsMinrating, "minRating"))
				}


				if !isCapturing(lhsMaxrating) && !isCapturing(rhsMaxrating) {
					comparison = Parameter.compare(lhs: lhsMaxrating, rhs: rhsMaxrating, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxrating, rhsMaxrating, "maxRating"))
				}

				if isCapturing(lhsRating) || isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "rating"))
				}


				if isCapturing(lhsMinrating) || isCapturing(rhsMinrating) {
					comparison = Parameter.compare(lhs: lhsMinrating, rhs: rhsMinrating, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMinrating, rhsMinrating, "minRating"))
				}


				if isCapturing(lhsMaxrating) || isCapturing(rhsMaxrating) {
					comparison = Parameter.compare(lhs: lhsMaxrating, rhs: rhsMaxrating, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxrating, rhsMaxrating, "maxRating"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_feedbackMessage__for_ratingmin_minmax_max(let lhsRating, let lhsMin, let lhsMax), .m_feedbackMessage__for_ratingmin_minmax_max(let rhsRating, let rhsMin, let rhsMax)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsRating) && !isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "for rating"))
				}


				if !isCapturing(lhsMin) && !isCapturing(rhsMin) {
					comparison = Parameter.compare(lhs: lhsMin, rhs: rhsMin, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMin, rhsMin, "min"))
				}


				if !isCapturing(lhsMax) && !isCapturing(rhsMax) {
					comparison = Parameter.compare(lhs: lhsMax, rhs: rhsMax, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMax, rhsMax, "max"))
				}

				if isCapturing(lhsRating) || isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "for rating"))
				}


				if isCapturing(lhsMin) || isCapturing(rhsMin) {
					comparison = Parameter.compare(lhs: lhsMin, rhs: rhsMin, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMin, rhsMin, "min"))
				}


				if isCapturing(lhsMax) || isCapturing(rhsMax) {
					comparison = Parameter.compare(lhs: lhsMax, rhs: rhsMax, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMax, rhsMax, "max"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_valueToString__value(p0): return p0.intValue
            case let .m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_feedbackMessage__for_ratingmin_minmax_max(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_valueToString__value: return ".valueToString(_:)"
            case .m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating: return ".colorForFatigue(rating:minRating:maxRating:)"
            case .m_feedbackMessage__for_ratingmin_minmax_max: return ".feedbackMessage(for:min:max:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func valueToString(_ value: Parameter<Double>, willReturn: String...) -> MethodStub {
            return Given(method: .m_valueToString__value(`value`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func colorForFatigue(rating: Parameter<Double>, minRating: Parameter<Double>, maxRating: Parameter<Double>, willReturn: UIColor...) -> MethodStub {
            return Given(method: .m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating(`rating`, `minRating`, `maxRating`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func feedbackMessage(for rating: Parameter<Double>, min: Parameter<Double>, max: Parameter<Double>, willReturn: String...) -> MethodStub {
            return Given(method: .m_feedbackMessage__for_ratingmin_minmax_max(`rating`, `min`, `max`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func valueToString(_ value: Parameter<Double>, willProduce: (Stubber<String>) -> Void) -> MethodStub {
            let willReturn: [String] = []
			let given: Given = { return Given(method: .m_valueToString__value(`value`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func colorForFatigue(rating: Parameter<Double>, minRating: Parameter<Double>, maxRating: Parameter<Double>, willProduce: (Stubber<UIColor>) -> Void) -> MethodStub {
            let willReturn: [UIColor] = []
			let given: Given = { return Given(method: .m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating(`rating`, `minRating`, `maxRating`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UIColor).self)
			willProduce(stubber)
			return given
        }
        public static func feedbackMessage(for rating: Parameter<Double>, min: Parameter<Double>, max: Parameter<Double>, willProduce: (Stubber<String>) -> Void) -> MethodStub {
            let willReturn: [String] = []
			let given: Given = { return Given(method: .m_feedbackMessage__for_ratingmin_minmax_max(`rating`, `min`, `max`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (String).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func valueToString(_ value: Parameter<Double>) -> Verify { return Verify(method: .m_valueToString__value(`value`))}
        public static func colorForFatigue(rating: Parameter<Double>, minRating: Parameter<Double>, maxRating: Parameter<Double>) -> Verify { return Verify(method: .m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating(`rating`, `minRating`, `maxRating`))}
        public static func feedbackMessage(for rating: Parameter<Double>, min: Parameter<Double>, max: Parameter<Double>) -> Verify { return Verify(method: .m_feedbackMessage__for_ratingmin_minmax_max(`rating`, `min`, `max`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func valueToString(_ value: Parameter<Double>, perform: @escaping (Double) -> Void) -> Perform {
            return Perform(method: .m_valueToString__value(`value`), performs: perform)
        }
        public static func colorForFatigue(rating: Parameter<Double>, minRating: Parameter<Double>, maxRating: Parameter<Double>, perform: @escaping (Double, Double, Double) -> Void) -> Perform {
            return Perform(method: .m_colorForFatigue__rating_ratingminRating_minRatingmaxRating_maxRating(`rating`, `minRating`, `maxRating`), performs: perform)
        }
        public static func feedbackMessage(for rating: Parameter<Double>, min: Parameter<Double>, max: Parameter<Double>, perform: @escaping (Double, Double, Double) -> Void) -> Perform {
            return Perform(method: .m_feedbackMessage__for_ratingmin_minmax_max(`rating`, `min`, `max`), performs: perform)
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

// MARK: - IOUtil

open class IOUtilMock: IOUtil, Mock {
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


    fileprivate enum MethodType {
        case m_contentsOf__url(Parameter<URL>)
        case m_csvReader__url_urlhasHeaderRow_hasHeaderRow(Parameter<URL>, Parameter<Bool>)
        case m_csvWriter__url_url(Parameter<URL>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_contentsOf__url(let lhsUrl), .m_contentsOf__url(let rhsUrl)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsUrl) && !isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "_ url"))
				}

				if isCapturing(lhsUrl) || isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "_ url"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_csvReader__url_urlhasHeaderRow_hasHeaderRow(let lhsUrl, let lhsHasheaderrow), .m_csvReader__url_urlhasHeaderRow_hasHeaderRow(let rhsUrl, let rhsHasheaderrow)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsUrl) && !isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "url"))
				}


				if !isCapturing(lhsHasheaderrow) && !isCapturing(rhsHasheaderrow) {
					comparison = Parameter.compare(lhs: lhsHasheaderrow, rhs: rhsHasheaderrow, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHasheaderrow, rhsHasheaderrow, "hasHeaderRow"))
				}

				if isCapturing(lhsUrl) || isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "url"))
				}


				if isCapturing(lhsHasheaderrow) || isCapturing(rhsHasheaderrow) {
					comparison = Parameter.compare(lhs: lhsHasheaderrow, rhs: rhsHasheaderrow, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHasheaderrow, rhsHasheaderrow, "hasHeaderRow"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_csvWriter__url_url(let lhsUrl), .m_csvWriter__url_url(let rhsUrl)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsUrl) && !isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "url"))
				}

				if isCapturing(lhsUrl) || isCapturing(rhsUrl) {
					comparison = Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUrl, rhsUrl, "url"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_contentsOf__url(p0): return p0.intValue
            case let .m_csvReader__url_urlhasHeaderRow_hasHeaderRow(p0, p1): return p0.intValue + p1.intValue
            case let .m_csvWriter__url_url(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_contentsOf__url: return ".contentsOf(_:)"
            case .m_csvReader__url_urlhasHeaderRow_hasHeaderRow: return ".csvReader(url:hasHeaderRow:)"
            case .m_csvWriter__url_url: return ".csvWriter(url:)"
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

// MARK: - MoodUiUtil

open class MoodUiUtilMock: MoodUiUtil, Mock {
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






    open func valueToString(_ value: Double) -> String {
        addInvocation(.m_valueToString__value(Parameter<Double>.value(`value`)))
		let perform = methodPerformValue(.m_valueToString__value(Parameter<Double>.value(`value`))) as? (Double) -> Void
		perform?(`value`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_valueToString__value(Parameter<Double>.value(`value`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for valueToString(_ value: Double). Use given")
			Failure("Stub return value not specified for valueToString(_ value: Double). Use given")
		}
		return __value
    }

    open func colorForMood(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
        addInvocation(.m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating(Parameter<Double>.value(`rating`), Parameter<Double>.value(`minRating`), Parameter<Double>.value(`maxRating`)))
		let perform = methodPerformValue(.m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating(Parameter<Double>.value(`rating`), Parameter<Double>.value(`minRating`), Parameter<Double>.value(`maxRating`))) as? (Double, Double, Double) -> Void
		perform?(`rating`, `minRating`, `maxRating`)
		var __value: UIColor
		do {
		    __value = try methodReturnValue(.m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating(Parameter<Double>.value(`rating`), Parameter<Double>.value(`minRating`), Parameter<Double>.value(`maxRating`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for colorForMood(rating: Double, minRating: Double, maxRating: Double). Use given")
			Failure("Stub return value not specified for colorForMood(rating: Double, minRating: Double, maxRating: Double). Use given")
		}
		return __value
    }

    open func feedbackMessage(for rating: Double, min: Double, max: Double) -> String {
        addInvocation(.m_feedbackMessage__for_ratingmin_minmax_max(Parameter<Double>.value(`rating`), Parameter<Double>.value(`min`), Parameter<Double>.value(`max`)))
		let perform = methodPerformValue(.m_feedbackMessage__for_ratingmin_minmax_max(Parameter<Double>.value(`rating`), Parameter<Double>.value(`min`), Parameter<Double>.value(`max`))) as? (Double, Double, Double) -> Void
		perform?(`rating`, `min`, `max`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_feedbackMessage__for_ratingmin_minmax_max(Parameter<Double>.value(`rating`), Parameter<Double>.value(`min`), Parameter<Double>.value(`max`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for feedbackMessage(for rating: Double, min: Double, max: Double). Use given")
			Failure("Stub return value not specified for feedbackMessage(for rating: Double, min: Double, max: Double). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_valueToString__value(Parameter<Double>)
        case m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating(Parameter<Double>, Parameter<Double>, Parameter<Double>)
        case m_feedbackMessage__for_ratingmin_minmax_max(Parameter<Double>, Parameter<Double>, Parameter<Double>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_valueToString__value(let lhsValue), .m_valueToString__value(let rhsValue)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsValue) && !isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "_ value"))
				}

				if isCapturing(lhsValue) || isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "_ value"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating(let lhsRating, let lhsMinrating, let lhsMaxrating), .m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating(let rhsRating, let rhsMinrating, let rhsMaxrating)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsRating) && !isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "rating"))
				}


				if !isCapturing(lhsMinrating) && !isCapturing(rhsMinrating) {
					comparison = Parameter.compare(lhs: lhsMinrating, rhs: rhsMinrating, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMinrating, rhsMinrating, "minRating"))
				}


				if !isCapturing(lhsMaxrating) && !isCapturing(rhsMaxrating) {
					comparison = Parameter.compare(lhs: lhsMaxrating, rhs: rhsMaxrating, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxrating, rhsMaxrating, "maxRating"))
				}

				if isCapturing(lhsRating) || isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "rating"))
				}


				if isCapturing(lhsMinrating) || isCapturing(rhsMinrating) {
					comparison = Parameter.compare(lhs: lhsMinrating, rhs: rhsMinrating, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMinrating, rhsMinrating, "minRating"))
				}


				if isCapturing(lhsMaxrating) || isCapturing(rhsMaxrating) {
					comparison = Parameter.compare(lhs: lhsMaxrating, rhs: rhsMaxrating, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxrating, rhsMaxrating, "maxRating"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_feedbackMessage__for_ratingmin_minmax_max(let lhsRating, let lhsMin, let lhsMax), .m_feedbackMessage__for_ratingmin_minmax_max(let rhsRating, let rhsMin, let rhsMax)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsRating) && !isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "for rating"))
				}


				if !isCapturing(lhsMin) && !isCapturing(rhsMin) {
					comparison = Parameter.compare(lhs: lhsMin, rhs: rhsMin, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMin, rhsMin, "min"))
				}


				if !isCapturing(lhsMax) && !isCapturing(rhsMax) {
					comparison = Parameter.compare(lhs: lhsMax, rhs: rhsMax, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMax, rhsMax, "max"))
				}

				if isCapturing(lhsRating) || isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "for rating"))
				}


				if isCapturing(lhsMin) || isCapturing(rhsMin) {
					comparison = Parameter.compare(lhs: lhsMin, rhs: rhsMin, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMin, rhsMin, "min"))
				}


				if isCapturing(lhsMax) || isCapturing(rhsMax) {
					comparison = Parameter.compare(lhs: lhsMax, rhs: rhsMax, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMax, rhsMax, "max"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_valueToString__value(p0): return p0.intValue
            case let .m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_feedbackMessage__for_ratingmin_minmax_max(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_valueToString__value: return ".valueToString(_:)"
            case .m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating: return ".colorForMood(rating:minRating:maxRating:)"
            case .m_feedbackMessage__for_ratingmin_minmax_max: return ".feedbackMessage(for:min:max:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func valueToString(_ value: Parameter<Double>, willReturn: String...) -> MethodStub {
            return Given(method: .m_valueToString__value(`value`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func colorForMood(rating: Parameter<Double>, minRating: Parameter<Double>, maxRating: Parameter<Double>, willReturn: UIColor...) -> MethodStub {
            return Given(method: .m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating(`rating`, `minRating`, `maxRating`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func feedbackMessage(for rating: Parameter<Double>, min: Parameter<Double>, max: Parameter<Double>, willReturn: String...) -> MethodStub {
            return Given(method: .m_feedbackMessage__for_ratingmin_minmax_max(`rating`, `min`, `max`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func valueToString(_ value: Parameter<Double>, willProduce: (Stubber<String>) -> Void) -> MethodStub {
            let willReturn: [String] = []
			let given: Given = { return Given(method: .m_valueToString__value(`value`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func colorForMood(rating: Parameter<Double>, minRating: Parameter<Double>, maxRating: Parameter<Double>, willProduce: (Stubber<UIColor>) -> Void) -> MethodStub {
            let willReturn: [UIColor] = []
			let given: Given = { return Given(method: .m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating(`rating`, `minRating`, `maxRating`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UIColor).self)
			willProduce(stubber)
			return given
        }
        public static func feedbackMessage(for rating: Parameter<Double>, min: Parameter<Double>, max: Parameter<Double>, willProduce: (Stubber<String>) -> Void) -> MethodStub {
            let willReturn: [String] = []
			let given: Given = { return Given(method: .m_feedbackMessage__for_ratingmin_minmax_max(`rating`, `min`, `max`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (String).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func valueToString(_ value: Parameter<Double>) -> Verify { return Verify(method: .m_valueToString__value(`value`))}
        public static func colorForMood(rating: Parameter<Double>, minRating: Parameter<Double>, maxRating: Parameter<Double>) -> Verify { return Verify(method: .m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating(`rating`, `minRating`, `maxRating`))}
        public static func feedbackMessage(for rating: Parameter<Double>, min: Parameter<Double>, max: Parameter<Double>) -> Verify { return Verify(method: .m_feedbackMessage__for_ratingmin_minmax_max(`rating`, `min`, `max`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func valueToString(_ value: Parameter<Double>, perform: @escaping (Double) -> Void) -> Perform {
            return Perform(method: .m_valueToString__value(`value`), performs: perform)
        }
        public static func colorForMood(rating: Parameter<Double>, minRating: Parameter<Double>, maxRating: Parameter<Double>, perform: @escaping (Double, Double, Double) -> Void) -> Perform {
            return Perform(method: .m_colorForMood__rating_ratingminRating_minRatingmaxRating_maxRating(`rating`, `minRating`, `maxRating`), performs: perform)
        }
        public static func feedbackMessage(for rating: Parameter<Double>, min: Parameter<Double>, max: Parameter<Double>, perform: @escaping (Double, Double, Double) -> Void) -> Perform {
            return Perform(method: .m_feedbackMessage__for_ratingmin_minmax_max(`rating`, `min`, `max`), performs: perform)
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

// MARK: - NotificationUtil

open class NotificationUtilMock: NotificationUtil, Mock {
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






    open func post(_ name: NotificationName, object: Any?, userInfo: [UserInfoKey: Any]?, qos: DispatchQoS.QoSClass?) {
        addInvocation(.m_post__nameobject_objectuserInfo_userInfoqos_qos_1(Parameter<NotificationName>.value(`name`), Parameter<Any?>.value(`object`), Parameter<[UserInfoKey: Any]?>.value(`userInfo`), Parameter<DispatchQoS.QoSClass?>.value(`qos`)))
		let perform = methodPerformValue(.m_post__nameobject_objectuserInfo_userInfoqos_qos_1(Parameter<NotificationName>.value(`name`), Parameter<Any?>.value(`object`), Parameter<[UserInfoKey: Any]?>.value(`userInfo`), Parameter<DispatchQoS.QoSClass?>.value(`qos`))) as? (NotificationName, Any?, [UserInfoKey: Any]?, DispatchQoS.QoSClass?) -> Void
		perform?(`name`, `object`, `userInfo`, `qos`)
    }

    open func post(_ name: Notification.Name, object: Any?, userInfo: [UserInfoKey: Any]?, qos: DispatchQoS.QoSClass?) {
        addInvocation(.m_post__nameobject_objectuserInfo_userInfoqos_qos_2(Parameter<Notification.Name>.value(`name`), Parameter<Any?>.value(`object`), Parameter<[UserInfoKey: Any]?>.value(`userInfo`), Parameter<DispatchQoS.QoSClass?>.value(`qos`)))
		let perform = methodPerformValue(.m_post__nameobject_objectuserInfo_userInfoqos_qos_2(Parameter<Notification.Name>.value(`name`), Parameter<Any?>.value(`object`), Parameter<[UserInfoKey: Any]?>.value(`userInfo`), Parameter<DispatchQoS.QoSClass?>.value(`qos`))) as? (Notification.Name, Any?, [UserInfoKey: Any]?, DispatchQoS.QoSClass?) -> Void
		perform?(`name`, `object`, `userInfo`, `qos`)
    }


    fileprivate enum MethodType {
        case m_post__nameobject_objectuserInfo_userInfoqos_qos_1(Parameter<NotificationName>, Parameter<Any?>, Parameter<[UserInfoKey: Any]?>, Parameter<DispatchQoS.QoSClass?>)
        case m_post__nameobject_objectuserInfo_userInfoqos_qos_2(Parameter<Notification.Name>, Parameter<Any?>, Parameter<[UserInfoKey: Any]?>, Parameter<DispatchQoS.QoSClass?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_post__nameobject_objectuserInfo_userInfoqos_qos_1(let lhsName, let lhsObject, let lhsUserinfo, let lhsQos), .m_post__nameobject_objectuserInfo_userInfoqos_qos_1(let rhsName, let rhsObject, let rhsUserinfo, let rhsQos)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "_ name"))
				}


				if !isCapturing(lhsObject) && !isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "object"))
				}


				if !isCapturing(lhsUserinfo) && !isCapturing(rhsUserinfo) {
					comparison = Parameter.compare(lhs: lhsUserinfo, rhs: rhsUserinfo, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUserinfo, rhsUserinfo, "userInfo"))
				}


				if !isCapturing(lhsQos) && !isCapturing(rhsQos) {
					comparison = Parameter.compare(lhs: lhsQos, rhs: rhsQos, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsQos, rhsQos, "qos"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "_ name"))
				}


				if isCapturing(lhsObject) || isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "object"))
				}


				if isCapturing(lhsUserinfo) || isCapturing(rhsUserinfo) {
					comparison = Parameter.compare(lhs: lhsUserinfo, rhs: rhsUserinfo, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUserinfo, rhsUserinfo, "userInfo"))
				}


				if isCapturing(lhsQos) || isCapturing(rhsQos) {
					comparison = Parameter.compare(lhs: lhsQos, rhs: rhsQos, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsQos, rhsQos, "qos"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_post__nameobject_objectuserInfo_userInfoqos_qos_2(let lhsName, let lhsObject, let lhsUserinfo, let lhsQos), .m_post__nameobject_objectuserInfo_userInfoqos_qos_2(let rhsName, let rhsObject, let rhsUserinfo, let rhsQos)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "_ name"))
				}


				if !isCapturing(lhsObject) && !isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "object"))
				}


				if !isCapturing(lhsUserinfo) && !isCapturing(rhsUserinfo) {
					comparison = Parameter.compare(lhs: lhsUserinfo, rhs: rhsUserinfo, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUserinfo, rhsUserinfo, "userInfo"))
				}


				if !isCapturing(lhsQos) && !isCapturing(rhsQos) {
					comparison = Parameter.compare(lhs: lhsQos, rhs: rhsQos, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsQos, rhsQos, "qos"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "_ name"))
				}


				if isCapturing(lhsObject) || isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "object"))
				}


				if isCapturing(lhsUserinfo) || isCapturing(rhsUserinfo) {
					comparison = Parameter.compare(lhs: lhsUserinfo, rhs: rhsUserinfo, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUserinfo, rhsUserinfo, "userInfo"))
				}


				if isCapturing(lhsQos) || isCapturing(rhsQos) {
					comparison = Parameter.compare(lhs: lhsQos, rhs: rhsQos, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsQos, rhsQos, "qos"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_post__nameobject_objectuserInfo_userInfoqos_qos_1(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_post__nameobject_objectuserInfo_userInfoqos_qos_2(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_post__nameobject_objectuserInfo_userInfoqos_qos_1: return ".post(_:object:userInfo:qos:)"
            case .m_post__nameobject_objectuserInfo_userInfoqos_qos_2: return ".post(_:object:userInfo:qos:)"
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

        public static func post(_ name: Parameter<NotificationName>, object: Parameter<Any?>, userInfo: Parameter<[UserInfoKey: Any]?>, qos: Parameter<DispatchQoS.QoSClass?>) -> Verify { return Verify(method: .m_post__nameobject_objectuserInfo_userInfoqos_qos_1(`name`, `object`, `userInfo`, `qos`))}
        public static func post(_ name: Parameter<Notification.Name>, object: Parameter<Any?>, userInfo: Parameter<[UserInfoKey: Any]?>, qos: Parameter<DispatchQoS.QoSClass?>) -> Verify { return Verify(method: .m_post__nameobject_objectuserInfo_userInfoqos_qos_2(`name`, `object`, `userInfo`, `qos`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func post(_ name: Parameter<NotificationName>, object: Parameter<Any?>, userInfo: Parameter<[UserInfoKey: Any]?>, qos: Parameter<DispatchQoS.QoSClass?>, perform: @escaping (NotificationName, Any?, [UserInfoKey: Any]?, DispatchQoS.QoSClass?) -> Void) -> Perform {
            return Perform(method: .m_post__nameobject_objectuserInfo_userInfoqos_qos_1(`name`, `object`, `userInfo`, `qos`), performs: perform)
        }
        public static func post(_ name: Parameter<Notification.Name>, object: Parameter<Any?>, userInfo: Parameter<[UserInfoKey: Any]?>, qos: Parameter<DispatchQoS.QoSClass?>, perform: @escaping (Notification.Name, Any?, [UserInfoKey: Any]?, DispatchQoS.QoSClass?) -> Void) -> Perform {
            return Perform(method: .m_post__nameobject_objectuserInfo_userInfoqos_qos_2(`name`, `object`, `userInfo`, `qos`), performs: perform)
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

// MARK: - SearchUtil

open class SearchUtilMock: SearchUtil, Mock {
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






    open func binarySearch<T: Comparable>(for targetItem: T, in items: [T]) -> Int? {
        addInvocation(.m_binarySearch__for_targetItemin_items(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<[T]>.value(`items`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_binarySearch__for_targetItemin_items(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<[T]>.value(`items`).wrapAsGeneric())) as? (T, [T]) -> Void
		perform?(`targetItem`, `items`)
		var __value: Int? = nil
		do {
		    __value = try methodReturnValue(.m_binarySearch__for_targetItemin_items(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<[T]>.value(`items`).wrapAsGeneric())).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func binarySearch<T>(for targetItem: T, in items: [T], compare: (T, T) -> ComparisonResult) -> Int? {
        addInvocation(.m_binarySearch__for_targetItemin_itemscompare_compare(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<[T]>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> ComparisonResult>.any.wrapAsGeneric()))
		let perform = methodPerformValue(.m_binarySearch__for_targetItemin_itemscompare_compare(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<[T]>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> ComparisonResult>.any.wrapAsGeneric())) as? (T, [T], (T, T) -> ComparisonResult) -> Void
		perform?(`targetItem`, `items`, `compare`)
		var __value: Int? = nil
		do {
		    __value = try methodReturnValue(.m_binarySearch__for_targetItemin_itemscompare_compare(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<[T]>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> ComparisonResult>.any.wrapAsGeneric())).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func closestItem<T>(to targetItem: T, in items: [T], distance: (T, T) -> Int) -> T {
        addInvocation(.m_closestItem__to_targetItemin_itemsdistance_distance(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<[T]>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> Int>.any.wrapAsGeneric()))
		let perform = methodPerformValue(.m_closestItem__to_targetItemin_itemsdistance_distance(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<[T]>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> Int>.any.wrapAsGeneric())) as? (T, [T], (T, T) -> Int) -> Void
		perform?(`targetItem`, `items`, `distance`)
		var __value: T
		do {
		    __value = try methodReturnValue(.m_closestItem__to_targetItemin_itemsdistance_distance(Parameter<T>.value(`targetItem`).wrapAsGeneric(), Parameter<[T]>.value(`items`).wrapAsGeneric(), Parameter<(T, T) -> Int>.any.wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for closestItem<T>(to targetItem: T, in items: [T], distance: (T, T) -> Int). Use given")
			Failure("Stub return value not specified for closestItem<T>(to targetItem: T, in items: [T], distance: (T, T) -> Int). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_binarySearch__for_targetItemin_items(Parameter<GenericAttribute>, Parameter<GenericAttribute>)
        case m_binarySearch__for_targetItemin_itemscompare_compare(Parameter<GenericAttribute>, Parameter<GenericAttribute>, Parameter<GenericAttribute>)
        case m_closestItem__to_targetItemin_itemsdistance_distance(Parameter<GenericAttribute>, Parameter<GenericAttribute>, Parameter<GenericAttribute>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_binarySearch__for_targetItemin_items(let lhsTargetitem, let lhsItems), .m_binarySearch__for_targetItemin_items(let rhsTargetitem, let rhsItems)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTargetitem) && !isCapturing(rhsTargetitem) {
					comparison = Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTargetitem, rhsTargetitem, "for targetItem"))
				}


				if !isCapturing(lhsItems) && !isCapturing(rhsItems) {
					comparison = Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsItems, rhsItems, "in items"))
				}

				if isCapturing(lhsTargetitem) || isCapturing(rhsTargetitem) {
					comparison = Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTargetitem, rhsTargetitem, "for targetItem"))
				}


				if isCapturing(lhsItems) || isCapturing(rhsItems) {
					comparison = Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsItems, rhsItems, "in items"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_binarySearch__for_targetItemin_itemscompare_compare(let lhsTargetitem, let lhsItems, let lhsCompare), .m_binarySearch__for_targetItemin_itemscompare_compare(let rhsTargetitem, let rhsItems, let rhsCompare)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTargetitem) && !isCapturing(rhsTargetitem) {
					comparison = Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTargetitem, rhsTargetitem, "for targetItem"))
				}


				if !isCapturing(lhsItems) && !isCapturing(rhsItems) {
					comparison = Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsItems, rhsItems, "in items"))
				}


				if !isCapturing(lhsCompare) && !isCapturing(rhsCompare) {
					comparison = Parameter.compare(lhs: lhsCompare, rhs: rhsCompare, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCompare, rhsCompare, "compare"))
				}

				if isCapturing(lhsTargetitem) || isCapturing(rhsTargetitem) {
					comparison = Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTargetitem, rhsTargetitem, "for targetItem"))
				}


				if isCapturing(lhsItems) || isCapturing(rhsItems) {
					comparison = Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsItems, rhsItems, "in items"))
				}


				if isCapturing(lhsCompare) || isCapturing(rhsCompare) {
					comparison = Parameter.compare(lhs: lhsCompare, rhs: rhsCompare, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCompare, rhsCompare, "compare"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_closestItem__to_targetItemin_itemsdistance_distance(let lhsTargetitem, let lhsItems, let lhsDistance), .m_closestItem__to_targetItemin_itemsdistance_distance(let rhsTargetitem, let rhsItems, let rhsDistance)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTargetitem) && !isCapturing(rhsTargetitem) {
					comparison = Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTargetitem, rhsTargetitem, "to targetItem"))
				}


				if !isCapturing(lhsItems) && !isCapturing(rhsItems) {
					comparison = Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsItems, rhsItems, "in items"))
				}


				if !isCapturing(lhsDistance) && !isCapturing(rhsDistance) {
					comparison = Parameter.compare(lhs: lhsDistance, rhs: rhsDistance, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDistance, rhsDistance, "distance"))
				}

				if isCapturing(lhsTargetitem) || isCapturing(rhsTargetitem) {
					comparison = Parameter.compare(lhs: lhsTargetitem, rhs: rhsTargetitem, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTargetitem, rhsTargetitem, "to targetItem"))
				}


				if isCapturing(lhsItems) || isCapturing(rhsItems) {
					comparison = Parameter.compare(lhs: lhsItems, rhs: rhsItems, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsItems, rhsItems, "in items"))
				}


				if isCapturing(lhsDistance) || isCapturing(rhsDistance) {
					comparison = Parameter.compare(lhs: lhsDistance, rhs: rhsDistance, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDistance, rhsDistance, "distance"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_binarySearch__for_targetItemin_items(p0, p1): return p0.intValue + p1.intValue
            case let .m_binarySearch__for_targetItemin_itemscompare_compare(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_closestItem__to_targetItemin_itemsdistance_distance(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_binarySearch__for_targetItemin_items: return ".binarySearch(for:in:)"
            case .m_binarySearch__for_targetItemin_itemscompare_compare: return ".binarySearch(for:in:compare:)"
            case .m_closestItem__to_targetItemin_itemsdistance_distance: return ".closestItem(to:in:distance:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func binarySearch<T: Comparable>(for targetItem: Parameter<T>, in items: Parameter<[T]>, willReturn: Int?...) -> MethodStub {
            return Given(method: .m_binarySearch__for_targetItemin_items(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<[T]>, compare: Parameter<(T, T) -> ComparisonResult>, willReturn: Int?...) -> MethodStub {
            return Given(method: .m_binarySearch__for_targetItemin_itemscompare_compare(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `compare`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func closestItem<T>(to targetItem: Parameter<T>, in items: Parameter<[T]>, distance: Parameter<(T, T) -> Int>, willReturn: T...) -> MethodStub {
            return Given(method: .m_closestItem__to_targetItemin_itemsdistance_distance(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `distance`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func binarySearch<T: Comparable>(for targetItem: Parameter<T>, in items: Parameter<[T]>, willProduce: (Stubber<Int?>) -> Void) -> MethodStub {
            let willReturn: [Int?] = []
			let given: Given = { return Given(method: .m_binarySearch__for_targetItemin_items(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Int?).self)
			willProduce(stubber)
			return given
        }
        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<[T]>, compare: Parameter<(T, T) -> ComparisonResult>, willProduce: (Stubber<Int?>) -> Void) -> MethodStub {
            let willReturn: [Int?] = []
			let given: Given = { return Given(method: .m_binarySearch__for_targetItemin_itemscompare_compare(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `compare`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Int?).self)
			willProduce(stubber)
			return given
        }
        public static func closestItem<T>(to targetItem: Parameter<T>, in items: Parameter<[T]>, distance: Parameter<(T, T) -> Int>, willProduce: (Stubber<T>) -> Void) -> MethodStub {
            let willReturn: [T] = []
			let given: Given = { return Given(method: .m_closestItem__to_targetItemin_itemsdistance_distance(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `distance`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (T).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<[T]>) -> Verify where T:Comparable { return Verify(method: .m_binarySearch__for_targetItemin_items(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric()))}
        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<[T]>, compare: Parameter<(T, T) -> ComparisonResult>) -> Verify { return Verify(method: .m_binarySearch__for_targetItemin_itemscompare_compare(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `compare`.wrapAsGeneric()))}
        public static func closestItem<T>(to targetItem: Parameter<T>, in items: Parameter<[T]>, distance: Parameter<(T, T) -> Int>) -> Verify { return Verify(method: .m_closestItem__to_targetItemin_itemsdistance_distance(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `distance`.wrapAsGeneric()))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<[T]>, perform: @escaping (T, [T]) -> Void) -> Perform where T:Comparable {
            return Perform(method: .m_binarySearch__for_targetItemin_items(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric()), performs: perform)
        }
        public static func binarySearch<T>(for targetItem: Parameter<T>, in items: Parameter<[T]>, compare: Parameter<(T, T) -> ComparisonResult>, perform: @escaping (T, [T], (T, T) -> ComparisonResult) -> Void) -> Perform {
            return Perform(method: .m_binarySearch__for_targetItemin_itemscompare_compare(`targetItem`.wrapAsGeneric(), `items`.wrapAsGeneric(), `compare`.wrapAsGeneric()), performs: perform)
        }
        public static func closestItem<T>(to targetItem: Parameter<T>, in items: Parameter<[T]>, distance: Parameter<(T, T) -> Int>, perform: @escaping (T, [T], (T, T) -> Int) -> Void) -> Perform {
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

// MARK: - StringUtil

open class StringUtilMock: StringUtil, Mock {
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_isNumber__str(let lhsStr), .m_isNumber__str(let rhsStr)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsStr) && !isCapturing(rhsStr) {
					comparison = Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStr, rhsStr, "_ str"))
				}

				if isCapturing(lhsStr) || isCapturing(rhsStr) {
					comparison = Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStr, rhsStr, "_ str"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_isInteger__str(let lhsStr), .m_isInteger__str(let rhsStr)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsStr) && !isCapturing(rhsStr) {
					comparison = Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStr, rhsStr, "_ str"))
				}

				if isCapturing(lhsStr) || isCapturing(rhsStr) {
					comparison = Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStr, rhsStr, "_ str"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_rangeOfNumberIn__str(let lhsStr), .m_rangeOfNumberIn__str(let rhsStr)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsStr) && !isCapturing(rhsStr) {
					comparison = Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStr, rhsStr, "_ str"))
				}

				if isCapturing(lhsStr) || isCapturing(rhsStr) {
					comparison = Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStr, rhsStr, "_ str"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_isDayOfWeek__str(let lhsStr), .m_isDayOfWeek__str(let rhsStr)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsStr) && !isCapturing(rhsStr) {
					comparison = Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStr, rhsStr, "_ str"))
				}

				if isCapturing(lhsStr) || isCapturing(rhsStr) {
					comparison = Parameter.compare(lhs: lhsStr, rhs: rhsStr, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStr, rhsStr, "_ str"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
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
        func assertionName() -> String {
            switch self {
            case .m_isNumber__str: return ".isNumber(_:)"
            case .m_isInteger__str: return ".isInteger(_:)"
            case .m_rangeOfNumberIn__str: return ".rangeOfNumberIn(_:)"
            case .m_isDayOfWeek__str: return ".isDayOfWeek(_:)"
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

// MARK: - TextNormalizationUtil

open class TextNormalizationUtilMock: TextNormalizationUtil, Mock {
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_expandContractions__text(let lhsText), .m_expandContractions__text(let rhsText)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsText) && !isCapturing(rhsText) {
					comparison = Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsText, rhsText, "_ text"))
				}

				if isCapturing(lhsText) || isCapturing(rhsText) {
					comparison = Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsText, rhsText, "_ text"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_normalizeNumbers__text(let lhsText), .m_normalizeNumbers__text(let rhsText)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsText) && !isCapturing(rhsText) {
					comparison = Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsText, rhsText, "_ text"))
				}

				if isCapturing(lhsText) || isCapturing(rhsText) {
					comparison = Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsText, rhsText, "_ text"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_removePunctuation__text(let lhsText), .m_removePunctuation__text(let rhsText)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsText) && !isCapturing(rhsText) {
					comparison = Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsText, rhsText, "_ text"))
				}

				if isCapturing(lhsText) || isCapturing(rhsText) {
					comparison = Parameter.compare(lhs: lhsText, rhs: rhsText, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsText, rhsText, "_ text"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_expandContractions__text(p0): return p0.intValue
            case let .m_normalizeNumbers__text(p0): return p0.intValue
            case let .m_removePunctuation__text(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_expandContractions__text: return ".expandContractions(_:)"
            case .m_normalizeNumbers__text: return ".normalizeNumbers(_:)"
            case .m_removePunctuation__text: return ".removePunctuation(_:)"
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

// MARK: - UiUtil

open class UiUtilMock: UiUtil, Mock {
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


    public var defaultPresenter: Presentr {
		get {	invocations.append(.p_defaultPresenter_get); return __p_defaultPresenter ?? givenGetterValue(.p_defaultPresenter_get, "UiUtilMock - stub value for defaultPresenter was not defined") }
	}
	private var __p_defaultPresenter: (Presentr)?

    public var hasTopNotch: Bool {
		get {	invocations.append(.p_hasTopNotch_get); return __p_hasTopNotch ?? givenGetterValue(.p_hasTopNotch_get, "UiUtilMock - stub value for hasTopNotch was not defined") }
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

    @discardableResult
	open func setBackButton(		for viewController: UIViewController,		title: String,		action selector: Selector	) -> UIBarButtonItem {
        addInvocation(.m_setBackButton__for_viewControllertitle_titleaction_selector(Parameter<UIViewController>.value(`viewController`), Parameter<String>.value(`title`), Parameter<Selector>.value(`selector`)))
		let perform = methodPerformValue(.m_setBackButton__for_viewControllertitle_titleaction_selector(Parameter<UIViewController>.value(`viewController`), Parameter<String>.value(`title`), Parameter<Selector>.value(`selector`))) as? (UIViewController, String, Selector) -> Void
		perform?(`viewController`, `title`, `selector`)
		var __value: UIBarButtonItem
		do {
		    __value = try methodReturnValue(.m_setBackButton__for_viewControllertitle_titleaction_selector(Parameter<UIViewController>.value(`viewController`), Parameter<String>.value(`title`), Parameter<Selector>.value(`selector`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for setBackButton(  for viewController: UIViewController,  title: String,  action selector: Selector ). Use given")
			Failure("Stub return value not specified for setBackButton(  for viewController: UIViewController,  title: String,  action selector: Selector ). Use given")
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

    open func controller<Type: UIViewController>(		named controllerName: String,		from storyboardName: String,		as: Type.Type	) -> Type {
        addInvocation(.m_controller__named_controllerNamefrom_storyboardNameas_as(Parameter<String>.value(`controllerName`), Parameter<String>.value(`storyboardName`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_controller__named_controllerNamefrom_storyboardNameas_as(Parameter<String>.value(`controllerName`), Parameter<String>.value(`storyboardName`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (String, String, Type.Type) -> Void
		perform?(`controllerName`, `storyboardName`, `as`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_controller__named_controllerNamefrom_storyboardNameas_as(Parameter<String>.value(`controllerName`), Parameter<String>.value(`storyboardName`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for controller<Type: UIViewController>(  named controllerName: String,  from storyboardName: String,  as: Type.Type ). Use given")
			Failure("Stub return value not specified for controller<Type: UIViewController>(  named controllerName: String,  from storyboardName: String,  as: Type.Type ). Use given")
		}
		return __value
    }

    open func controller<Type: UIViewController>(		named controllerName: String,		from storyboard: UIStoryboard,		as: Type.Type	) -> Type {
        addInvocation(.m_controller__named_controllerNamefrom_storyboardas_as(Parameter<String>.value(`controllerName`), Parameter<UIStoryboard>.value(`storyboard`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_controller__named_controllerNamefrom_storyboardas_as(Parameter<String>.value(`controllerName`), Parameter<UIStoryboard>.value(`storyboard`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (String, UIStoryboard, Type.Type) -> Void
		perform?(`controllerName`, `storyboard`, `as`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_controller__named_controllerNamefrom_storyboardas_as(Parameter<String>.value(`controllerName`), Parameter<UIStoryboard>.value(`storyboard`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for controller<Type: UIViewController>(  named controllerName: String,  from storyboard: UIStoryboard,  as: Type.Type ). Use given")
			Failure("Stub return value not specified for controller<Type: UIViewController>(  named controllerName: String,  from storyboard: UIStoryboard,  as: Type.Type ). Use given")
		}
		return __value
    }

    open func tableViewCell<Type: UITableViewCell>(		from tableView: UITableView,		withIdentifier identifier: String,		for indexPath: IndexPath,		as: Type.Type	) -> Type {
        addInvocation(.m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as(Parameter<UITableView>.value(`tableView`), Parameter<String>.value(`identifier`), Parameter<IndexPath>.value(`indexPath`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as(Parameter<UITableView>.value(`tableView`), Parameter<String>.value(`identifier`), Parameter<IndexPath>.value(`indexPath`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (UITableView, String, IndexPath, Type.Type) -> Void
		perform?(`tableView`, `identifier`, `indexPath`, `as`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as(Parameter<UITableView>.value(`tableView`), Parameter<String>.value(`identifier`), Parameter<IndexPath>.value(`indexPath`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for tableViewCell<Type: UITableViewCell>(  from tableView: UITableView,  withIdentifier identifier: String,  for indexPath: IndexPath,  as: Type.Type ). Use given")
			Failure("Stub return value not specified for tableViewCell<Type: UITableViewCell>(  from tableView: UITableView,  withIdentifier identifier: String,  for indexPath: IndexPath,  as: Type.Type ). Use given")
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

    open func tableViewRowAction(		style: UITableViewRowAction.Style,		title: String?,		handler: @escaping (UITableViewRowAction, IndexPath) -> Void	) -> UITableViewRowAction {
        addInvocation(.m_tableViewRowAction__style_styletitle_titlehandler_handler(Parameter<UITableViewRowAction.Style>.value(`style`), Parameter<String?>.value(`title`), Parameter<(UITableViewRowAction, IndexPath) -> Void>.value(`handler`)))
		let perform = methodPerformValue(.m_tableViewRowAction__style_styletitle_titlehandler_handler(Parameter<UITableViewRowAction.Style>.value(`style`), Parameter<String?>.value(`title`), Parameter<(UITableViewRowAction, IndexPath) -> Void>.value(`handler`))) as? (UITableViewRowAction.Style, String?, @escaping (UITableViewRowAction, IndexPath) -> Void) -> Void
		perform?(`style`, `title`, `handler`)
		var __value: UITableViewRowAction
		do {
		    __value = try methodReturnValue(.m_tableViewRowAction__style_styletitle_titlehandler_handler(Parameter<UITableViewRowAction.Style>.value(`style`), Parameter<String?>.value(`title`), Parameter<(UITableViewRowAction, IndexPath) -> Void>.value(`handler`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for tableViewRowAction(  style: UITableViewRowAction.Style,  title: String?,  handler: @escaping (UITableViewRowAction, IndexPath) -> Void ). Use given")
			Failure("Stub return value not specified for tableViewRowAction(  style: UITableViewRowAction.Style,  title: String?,  handler: @escaping (UITableViewRowAction, IndexPath) -> Void ). Use given")
		}
		return __value
    }

    open func alertAction(		title: String?,		style: UIAlertAction.Style,		handler: ((UIAlertAction) -> Void)?	) -> UIAlertAction {
        addInvocation(.m_alertAction__title_titlestyle_stylehandler_handler(Parameter<String?>.value(`title`), Parameter<UIAlertAction.Style>.value(`style`), Parameter<((UIAlertAction) -> Void)?>.value(`handler`)))
		let perform = methodPerformValue(.m_alertAction__title_titlestyle_stylehandler_handler(Parameter<String?>.value(`title`), Parameter<UIAlertAction.Style>.value(`style`), Parameter<((UIAlertAction) -> Void)?>.value(`handler`))) as? (String?, UIAlertAction.Style, ((UIAlertAction) -> Void)?) -> Void
		perform?(`title`, `style`, `handler`)
		var __value: UIAlertAction
		do {
		    __value = try methodReturnValue(.m_alertAction__title_titlestyle_stylehandler_handler(Parameter<String?>.value(`title`), Parameter<UIAlertAction.Style>.value(`style`), Parameter<((UIAlertAction) -> Void)?>.value(`handler`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for alertAction(  title: String?,  style: UIAlertAction.Style,  handler: ((UIAlertAction) -> Void)? ). Use given")
			Failure("Stub return value not specified for alertAction(  title: String?,  style: UIAlertAction.Style,  handler: ((UIAlertAction) -> Void)? ). Use given")
		}
		return __value
    }

    open func cancelAlertAction(handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        addInvocation(.m_cancelAlertAction__handler_handler(Parameter<((UIAlertAction) -> Void)?>.value(`handler`)))
		let perform = methodPerformValue(.m_cancelAlertAction__handler_handler(Parameter<((UIAlertAction) -> Void)?>.value(`handler`))) as? (((UIAlertAction) -> Void)?) -> Void
		perform?(`handler`)
		var __value: UIAlertAction
		do {
		    __value = try methodReturnValue(.m_cancelAlertAction__handler_handler(Parameter<((UIAlertAction) -> Void)?>.value(`handler`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for cancelAlertAction(handler: ((UIAlertAction) -> Void)?). Use given")
			Failure("Stub return value not specified for cancelAlertAction(handler: ((UIAlertAction) -> Void)?). Use given")
		}
		return __value
    }

    open func contextualAction(		style: UIContextualAction.Style,		title: String?,		handler: @escaping UIContextualAction.Handler	) -> UIContextualAction {
        addInvocation(.m_contextualAction__style_styletitle_titlehandler_handler(Parameter<UIContextualAction.Style>.value(`style`), Parameter<String?>.value(`title`), Parameter<UIContextualAction.Handler>.value(`handler`)))
		let perform = methodPerformValue(.m_contextualAction__style_styletitle_titlehandler_handler(Parameter<UIContextualAction.Style>.value(`style`), Parameter<String?>.value(`title`), Parameter<UIContextualAction.Handler>.value(`handler`))) as? (UIContextualAction.Style, String?, @escaping UIContextualAction.Handler) -> Void
		perform?(`style`, `title`, `handler`)
		var __value: UIContextualAction
		do {
		    __value = try methodReturnValue(.m_contextualAction__style_styletitle_titlehandler_handler(Parameter<UIContextualAction.Style>.value(`style`), Parameter<String?>.value(`title`), Parameter<UIContextualAction.Handler>.value(`handler`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for contextualAction(  style: UIContextualAction.Style,  title: String?,  handler: @escaping UIContextualAction.Handler ). Use given")
			Failure("Stub return value not specified for contextualAction(  style: UIContextualAction.Style,  title: String?,  handler: @escaping UIContextualAction.Handler ). Use given")
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

    open func present(		_ presentingController: UIViewController,		_ controllerBeingPresented: UIViewController,		animated: Bool,		completion: (() -> Void)?	) {
        addInvocation(.m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(Parameter<UIViewController>.value(`presentingController`), Parameter<UIViewController>.value(`controllerBeingPresented`), Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`)))
		let perform = methodPerformValue(.m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(Parameter<UIViewController>.value(`presentingController`), Parameter<UIViewController>.value(`controllerBeingPresented`), Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`))) as? (UIViewController, UIViewController, Bool, (() -> Void)?) -> Void
		perform?(`presentingController`, `controllerBeingPresented`, `animated`, `completion`)
    }

    open func present(		_ viewController: UIViewController,		on presentingController: UIViewController,		using presenter: Presentr,		animated: Bool,		completion: (() -> Void)?	) {
        addInvocation(.m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(Parameter<UIViewController>.value(`viewController`), Parameter<UIViewController>.value(`presentingController`), Parameter<Presentr>.value(`presenter`), Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`)))
		let perform = methodPerformValue(.m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(Parameter<UIViewController>.value(`viewController`), Parameter<UIViewController>.value(`presentingController`), Parameter<Presentr>.value(`presenter`), Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`))) as? (UIViewController, UIViewController, Presentr, Bool, (() -> Void)?) -> Void
		perform?(`viewController`, `presentingController`, `presenter`, `animated`, `completion`)
    }

    open func push(		controller: UIViewController,		toNavigationController navigationController: UINavigationController?,		animated: Bool	) {
        addInvocation(.m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(Parameter<UIViewController>.value(`controller`), Parameter<UINavigationController?>.value(`navigationController`), Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(Parameter<UIViewController>.value(`controller`), Parameter<UINavigationController?>.value(`navigationController`), Parameter<Bool>.value(`animated`))) as? (UIViewController, UINavigationController?, Bool) -> Void
		perform?(`controller`, `navigationController`, `animated`)
    }

    open func popFrom(_ navigationController: UINavigationController?, animated: Bool) {
        addInvocation(.m_popFrom__navigationControlleranimated_animated(Parameter<UINavigationController?>.value(`navigationController`), Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_popFrom__navigationControlleranimated_animated(Parameter<UINavigationController?>.value(`navigationController`), Parameter<Bool>.value(`animated`))) as? (UINavigationController?, Bool) -> Void
		perform?(`navigationController`, `animated`)
    }

    open func sendUserNotification(		withContent content: UNMutableNotificationContent,		id: String,		repeats: Bool,		interval: TimeInterval	) {
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
        case m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as(Parameter<UITableView>, Parameter<String>, Parameter<IndexPath>, Parameter<GenericAttribute>)
        case m_documentPicker__docTypes_docTypesin_pickerMode(Parameter<[String]>, Parameter<UIDocumentPickerMode>)
        case m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(Parameter<String?>, Parameter<String?>, Parameter<UIAlertController.Style>)
        case m_tableViewRowAction__style_styletitle_titlehandler_handler(Parameter<UITableViewRowAction.Style>, Parameter<String?>, Parameter<(UITableViewRowAction, IndexPath) -> Void>)
        case m_alertAction__title_titlestyle_stylehandler_handler(Parameter<String?>, Parameter<UIAlertAction.Style>, Parameter<((UIAlertAction) -> Void)?>)
        case m_cancelAlertAction__handler_handler(Parameter<((UIAlertAction) -> Void)?>)
        case m_contextualAction__style_styletitle_titlehandler_handler(Parameter<UIContextualAction.Style>, Parameter<String?>, Parameter<UIContextualAction.Handler>)
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_customPresenter__width_widthheight_heightcenter_center(let lhsWidth, let lhsHeight, let lhsCenter), .m_customPresenter__width_widthheight_heightcenter_center(let rhsWidth, let rhsHeight, let rhsCenter)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsWidth) && !isCapturing(rhsWidth) {
					comparison = Parameter.compare(lhs: lhsWidth, rhs: rhsWidth, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsWidth, rhsWidth, "width"))
				}


				if !isCapturing(lhsHeight) && !isCapturing(rhsHeight) {
					comparison = Parameter.compare(lhs: lhsHeight, rhs: rhsHeight, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHeight, rhsHeight, "height"))
				}


				if !isCapturing(lhsCenter) && !isCapturing(rhsCenter) {
					comparison = Parameter.compare(lhs: lhsCenter, rhs: rhsCenter, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCenter, rhsCenter, "center"))
				}

				if isCapturing(lhsWidth) || isCapturing(rhsWidth) {
					comparison = Parameter.compare(lhs: lhsWidth, rhs: rhsWidth, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsWidth, rhsWidth, "width"))
				}


				if isCapturing(lhsHeight) || isCapturing(rhsHeight) {
					comparison = Parameter.compare(lhs: lhsHeight, rhs: rhsHeight, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHeight, rhsHeight, "height"))
				}


				if isCapturing(lhsCenter) || isCapturing(rhsCenter) {
					comparison = Parameter.compare(lhs: lhsCenter, rhs: rhsCenter, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCenter, rhsCenter, "center"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_setView__viewenabled_enabledhidden_hidden(let lhsView, let lhsEnabled, let lhsHidden), .m_setView__viewenabled_enabledhidden_hidden(let rhsView, let rhsEnabled, let rhsHidden)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsView) && !isCapturing(rhsView) {
					comparison = Parameter.compare(lhs: lhsView, rhs: rhsView, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsView, rhsView, "_ view"))
				}


				if !isCapturing(lhsEnabled) && !isCapturing(rhsEnabled) {
					comparison = Parameter.compare(lhs: lhsEnabled, rhs: rhsEnabled, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnabled, rhsEnabled, "enabled"))
				}


				if !isCapturing(lhsHidden) && !isCapturing(rhsHidden) {
					comparison = Parameter.compare(lhs: lhsHidden, rhs: rhsHidden, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHidden, rhsHidden, "hidden"))
				}

				if isCapturing(lhsView) || isCapturing(rhsView) {
					comparison = Parameter.compare(lhs: lhsView, rhs: rhsView, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsView, rhsView, "_ view"))
				}


				if isCapturing(lhsEnabled) || isCapturing(rhsEnabled) {
					comparison = Parameter.compare(lhs: lhsEnabled, rhs: rhsEnabled, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnabled, rhsEnabled, "enabled"))
				}


				if isCapturing(lhsHidden) || isCapturing(rhsHidden) {
					comparison = Parameter.compare(lhs: lhsHidden, rhs: rhsHidden, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHidden, rhsHidden, "hidden"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_setButton__buttonenabled_enabledhidden_hidden(let lhsButton, let lhsEnabled, let lhsHidden), .m_setButton__buttonenabled_enabledhidden_hidden(let rhsButton, let rhsEnabled, let rhsHidden)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsButton) && !isCapturing(rhsButton) {
					comparison = Parameter.compare(lhs: lhsButton, rhs: rhsButton, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsButton, rhsButton, "_ button"))
				}


				if !isCapturing(lhsEnabled) && !isCapturing(rhsEnabled) {
					comparison = Parameter.compare(lhs: lhsEnabled, rhs: rhsEnabled, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnabled, rhsEnabled, "enabled"))
				}


				if !isCapturing(lhsHidden) && !isCapturing(rhsHidden) {
					comparison = Parameter.compare(lhs: lhsHidden, rhs: rhsHidden, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHidden, rhsHidden, "hidden"))
				}

				if isCapturing(lhsButton) || isCapturing(rhsButton) {
					comparison = Parameter.compare(lhs: lhsButton, rhs: rhsButton, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsButton, rhsButton, "_ button"))
				}


				if isCapturing(lhsEnabled) || isCapturing(rhsEnabled) {
					comparison = Parameter.compare(lhs: lhsEnabled, rhs: rhsEnabled, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnabled, rhsEnabled, "enabled"))
				}


				if isCapturing(lhsHidden) || isCapturing(rhsHidden) {
					comparison = Parameter.compare(lhs: lhsHidden, rhs: rhsHidden, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHidden, rhsHidden, "hidden"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_setBackButton__for_viewControllertitle_titleaction_selector(let lhsViewcontroller, let lhsTitle, let lhsSelector), .m_setBackButton__for_viewControllertitle_titleaction_selector(let rhsViewcontroller, let rhsTitle, let rhsSelector)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsViewcontroller) && !isCapturing(rhsViewcontroller) {
					comparison = Parameter.compare(lhs: lhsViewcontroller, rhs: rhsViewcontroller, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsViewcontroller, rhsViewcontroller, "for viewController"))
				}


				if !isCapturing(lhsTitle) && !isCapturing(rhsTitle) {
					comparison = Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTitle, rhsTitle, "title"))
				}


				if !isCapturing(lhsSelector) && !isCapturing(rhsSelector) {
					comparison = Parameter.compare(lhs: lhsSelector, rhs: rhsSelector, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSelector, rhsSelector, "action selector"))
				}

				if isCapturing(lhsViewcontroller) || isCapturing(rhsViewcontroller) {
					comparison = Parameter.compare(lhs: lhsViewcontroller, rhs: rhsViewcontroller, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsViewcontroller, rhsViewcontroller, "for viewController"))
				}


				if isCapturing(lhsTitle) || isCapturing(rhsTitle) {
					comparison = Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTitle, rhsTitle, "title"))
				}


				if isCapturing(lhsSelector) || isCapturing(rhsSelector) {
					comparison = Parameter.compare(lhs: lhsSelector, rhs: rhsSelector, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSelector, rhsSelector, "action selector"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action(let lhsTextview, let lhsTarget, let lhsAction), .m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action(let rhsTextview, let rhsTarget, let rhsAction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTextview) && !isCapturing(rhsTextview) {
					comparison = Parameter.compare(lhs: lhsTextview, rhs: rhsTextview, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTextview, rhsTextview, "_ textView"))
				}


				if !isCapturing(lhsTarget) && !isCapturing(rhsTarget) {
					comparison = Parameter.compare(lhs: lhsTarget, rhs: rhsTarget, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTarget, rhsTarget, "target"))
				}


				if !isCapturing(lhsAction) && !isCapturing(rhsAction) {
					comparison = Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAction, rhsAction, "action"))
				}

				if isCapturing(lhsTextview) || isCapturing(rhsTextview) {
					comparison = Parameter.compare(lhs: lhsTextview, rhs: rhsTextview, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTextview, rhsTextview, "_ textView"))
				}


				if isCapturing(lhsTarget) || isCapturing(rhsTarget) {
					comparison = Parameter.compare(lhs: lhsTarget, rhs: rhsTarget, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTarget, rhsTarget, "target"))
				}


				if isCapturing(lhsAction) || isCapturing(rhsAction) {
					comparison = Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAction, rhsAction, "action"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action(let lhsTextfield, let lhsTarget, let lhsAction), .m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action(let rhsTextfield, let rhsTarget, let rhsAction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTextfield) && !isCapturing(rhsTextfield) {
					comparison = Parameter.compare(lhs: lhsTextfield, rhs: rhsTextfield, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTextfield, rhsTextfield, "_ textField"))
				}


				if !isCapturing(lhsTarget) && !isCapturing(rhsTarget) {
					comparison = Parameter.compare(lhs: lhsTarget, rhs: rhsTarget, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTarget, rhsTarget, "target"))
				}


				if !isCapturing(lhsAction) && !isCapturing(rhsAction) {
					comparison = Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAction, rhsAction, "action"))
				}

				if isCapturing(lhsTextfield) || isCapturing(rhsTextfield) {
					comparison = Parameter.compare(lhs: lhsTextfield, rhs: rhsTextfield, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTextfield, rhsTextfield, "_ textField"))
				}


				if isCapturing(lhsTarget) || isCapturing(rhsTarget) {
					comparison = Parameter.compare(lhs: lhsTarget, rhs: rhsTarget, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTarget, rhsTarget, "target"))
				}


				if isCapturing(lhsAction) || isCapturing(rhsAction) {
					comparison = Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAction, rhsAction, "action"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(let lhsKey, let lhsNotification, let lhsKeyisoptional), .m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(let rhsKey, let rhsNotification, let rhsKeyisoptional)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsKey) && !isCapturing(rhsKey) {
					comparison = Parameter.compare(lhs: lhsKey, rhs: rhsKey, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsKey, rhsKey, "for key"))
				}


				if !isCapturing(lhsNotification) && !isCapturing(rhsNotification) {
					comparison = Parameter.compare(lhs: lhsNotification, rhs: rhsNotification, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNotification, rhsNotification, "from notification"))
				}


				if !isCapturing(lhsKeyisoptional) && !isCapturing(rhsKeyisoptional) {
					comparison = Parameter.compare(lhs: lhsKeyisoptional, rhs: rhsKeyisoptional, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsKeyisoptional, rhsKeyisoptional, "keyIsOptional"))
				}

				if isCapturing(lhsKey) || isCapturing(rhsKey) {
					comparison = Parameter.compare(lhs: lhsKey, rhs: rhsKey, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsKey, rhsKey, "for key"))
				}


				if isCapturing(lhsNotification) || isCapturing(rhsNotification) {
					comparison = Parameter.compare(lhs: lhsNotification, rhs: rhsNotification, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNotification, rhsNotification, "from notification"))
				}


				if isCapturing(lhsKeyisoptional) || isCapturing(rhsKeyisoptional) {
					comparison = Parameter.compare(lhs: lhsKeyisoptional, rhs: rhsKeyisoptional, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsKeyisoptional, rhsKeyisoptional, "keyIsOptional"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_info__info(let lhsInfo), .m_info__info(let rhsInfo)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsInfo) && !isCapturing(rhsInfo) {
					comparison = Parameter.compare(lhs: lhsInfo, rhs: rhsInfo, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsInfo, rhsInfo, "_ info"))
				}

				if isCapturing(lhsInfo) || isCapturing(rhsInfo) {
					comparison = Parameter.compare(lhs: lhsInfo, rhs: rhsInfo, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsInfo, rhsInfo, "_ info"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_controller__named_controllerNamefrom_storyboardNameas_as(let lhsControllername, let lhsStoryboardname, let lhsAs), .m_controller__named_controllerNamefrom_storyboardNameas_as(let rhsControllername, let rhsStoryboardname, let rhsAs)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsControllername) && !isCapturing(rhsControllername) {
					comparison = Parameter.compare(lhs: lhsControllername, rhs: rhsControllername, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsControllername, rhsControllername, "named controllerName"))
				}


				if !isCapturing(lhsStoryboardname) && !isCapturing(rhsStoryboardname) {
					comparison = Parameter.compare(lhs: lhsStoryboardname, rhs: rhsStoryboardname, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStoryboardname, rhsStoryboardname, "from storyboardName"))
				}


				if !isCapturing(lhsAs) && !isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				if isCapturing(lhsControllername) || isCapturing(rhsControllername) {
					comparison = Parameter.compare(lhs: lhsControllername, rhs: rhsControllername, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsControllername, rhsControllername, "named controllerName"))
				}


				if isCapturing(lhsStoryboardname) || isCapturing(rhsStoryboardname) {
					comparison = Parameter.compare(lhs: lhsStoryboardname, rhs: rhsStoryboardname, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStoryboardname, rhsStoryboardname, "from storyboardName"))
				}


				if isCapturing(lhsAs) || isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_controller__named_controllerNamefrom_storyboardas_as(let lhsControllername, let lhsStoryboard, let lhsAs), .m_controller__named_controllerNamefrom_storyboardas_as(let rhsControllername, let rhsStoryboard, let rhsAs)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsControllername) && !isCapturing(rhsControllername) {
					comparison = Parameter.compare(lhs: lhsControllername, rhs: rhsControllername, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsControllername, rhsControllername, "named controllerName"))
				}


				if !isCapturing(lhsStoryboard) && !isCapturing(rhsStoryboard) {
					comparison = Parameter.compare(lhs: lhsStoryboard, rhs: rhsStoryboard, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStoryboard, rhsStoryboard, "from storyboard"))
				}


				if !isCapturing(lhsAs) && !isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				if isCapturing(lhsControllername) || isCapturing(rhsControllername) {
					comparison = Parameter.compare(lhs: lhsControllername, rhs: rhsControllername, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsControllername, rhsControllername, "named controllerName"))
				}


				if isCapturing(lhsStoryboard) || isCapturing(rhsStoryboard) {
					comparison = Parameter.compare(lhs: lhsStoryboard, rhs: rhsStoryboard, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStoryboard, rhsStoryboard, "from storyboard"))
				}


				if isCapturing(lhsAs) || isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as(let lhsTableview, let lhsIdentifier, let lhsIndexpath, let lhsAs), .m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as(let rhsTableview, let rhsIdentifier, let rhsIndexpath, let rhsAs)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTableview) && !isCapturing(rhsTableview) {
					comparison = Parameter.compare(lhs: lhsTableview, rhs: rhsTableview, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTableview, rhsTableview, "from tableView"))
				}


				if !isCapturing(lhsIdentifier) && !isCapturing(rhsIdentifier) {
					comparison = Parameter.compare(lhs: lhsIdentifier, rhs: rhsIdentifier, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsIdentifier, rhsIdentifier, "withIdentifier identifier"))
				}


				if !isCapturing(lhsIndexpath) && !isCapturing(rhsIndexpath) {
					comparison = Parameter.compare(lhs: lhsIndexpath, rhs: rhsIndexpath, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsIndexpath, rhsIndexpath, "for indexPath"))
				}


				if !isCapturing(lhsAs) && !isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				if isCapturing(lhsTableview) || isCapturing(rhsTableview) {
					comparison = Parameter.compare(lhs: lhsTableview, rhs: rhsTableview, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTableview, rhsTableview, "from tableView"))
				}


				if isCapturing(lhsIdentifier) || isCapturing(rhsIdentifier) {
					comparison = Parameter.compare(lhs: lhsIdentifier, rhs: rhsIdentifier, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsIdentifier, rhsIdentifier, "withIdentifier identifier"))
				}


				if isCapturing(lhsIndexpath) || isCapturing(rhsIndexpath) {
					comparison = Parameter.compare(lhs: lhsIndexpath, rhs: rhsIndexpath, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsIndexpath, rhsIndexpath, "for indexPath"))
				}


				if isCapturing(lhsAs) || isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_documentPicker__docTypes_docTypesin_pickerMode(let lhsDoctypes, let lhsPickermode), .m_documentPicker__docTypes_docTypesin_pickerMode(let rhsDoctypes, let rhsPickermode)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDoctypes) && !isCapturing(rhsDoctypes) {
					comparison = Parameter.compare(lhs: lhsDoctypes, rhs: rhsDoctypes, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDoctypes, rhsDoctypes, "docTypes"))
				}


				if !isCapturing(lhsPickermode) && !isCapturing(rhsPickermode) {
					comparison = Parameter.compare(lhs: lhsPickermode, rhs: rhsPickermode, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPickermode, rhsPickermode, "in pickerMode"))
				}

				if isCapturing(lhsDoctypes) || isCapturing(rhsDoctypes) {
					comparison = Parameter.compare(lhs: lhsDoctypes, rhs: rhsDoctypes, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDoctypes, rhsDoctypes, "docTypes"))
				}


				if isCapturing(lhsPickermode) || isCapturing(rhsPickermode) {
					comparison = Parameter.compare(lhs: lhsPickermode, rhs: rhsPickermode, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPickermode, rhsPickermode, "in pickerMode"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(let lhsTitle, let lhsMessage, let lhsPreferredstyle), .m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(let rhsTitle, let rhsMessage, let rhsPreferredstyle)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTitle) && !isCapturing(rhsTitle) {
					comparison = Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTitle, rhsTitle, "title"))
				}


				if !isCapturing(lhsMessage) && !isCapturing(rhsMessage) {
					comparison = Parameter.compare(lhs: lhsMessage, rhs: rhsMessage, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMessage, rhsMessage, "message"))
				}


				if !isCapturing(lhsPreferredstyle) && !isCapturing(rhsPreferredstyle) {
					comparison = Parameter.compare(lhs: lhsPreferredstyle, rhs: rhsPreferredstyle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPreferredstyle, rhsPreferredstyle, "preferredStyle"))
				}

				if isCapturing(lhsTitle) || isCapturing(rhsTitle) {
					comparison = Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTitle, rhsTitle, "title"))
				}


				if isCapturing(lhsMessage) || isCapturing(rhsMessage) {
					comparison = Parameter.compare(lhs: lhsMessage, rhs: rhsMessage, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMessage, rhsMessage, "message"))
				}


				if isCapturing(lhsPreferredstyle) || isCapturing(rhsPreferredstyle) {
					comparison = Parameter.compare(lhs: lhsPreferredstyle, rhs: rhsPreferredstyle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPreferredstyle, rhsPreferredstyle, "preferredStyle"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_tableViewRowAction__style_styletitle_titlehandler_handler(let lhsStyle, let lhsTitle, let lhsHandler), .m_tableViewRowAction__style_styletitle_titlehandler_handler(let rhsStyle, let rhsTitle, let rhsHandler)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsStyle) && !isCapturing(rhsStyle) {
					comparison = Parameter.compare(lhs: lhsStyle, rhs: rhsStyle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStyle, rhsStyle, "style"))
				}


				if !isCapturing(lhsTitle) && !isCapturing(rhsTitle) {
					comparison = Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTitle, rhsTitle, "title"))
				}


				if !isCapturing(lhsHandler) && !isCapturing(rhsHandler) {
					comparison = Parameter.compare(lhs: lhsHandler, rhs: rhsHandler, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHandler, rhsHandler, "handler"))
				}

				if isCapturing(lhsStyle) || isCapturing(rhsStyle) {
					comparison = Parameter.compare(lhs: lhsStyle, rhs: rhsStyle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStyle, rhsStyle, "style"))
				}


				if isCapturing(lhsTitle) || isCapturing(rhsTitle) {
					comparison = Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTitle, rhsTitle, "title"))
				}


				if isCapturing(lhsHandler) || isCapturing(rhsHandler) {
					comparison = Parameter.compare(lhs: lhsHandler, rhs: rhsHandler, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHandler, rhsHandler, "handler"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_alertAction__title_titlestyle_stylehandler_handler(let lhsTitle, let lhsStyle, let lhsHandler), .m_alertAction__title_titlestyle_stylehandler_handler(let rhsTitle, let rhsStyle, let rhsHandler)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTitle) && !isCapturing(rhsTitle) {
					comparison = Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTitle, rhsTitle, "title"))
				}


				if !isCapturing(lhsStyle) && !isCapturing(rhsStyle) {
					comparison = Parameter.compare(lhs: lhsStyle, rhs: rhsStyle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStyle, rhsStyle, "style"))
				}


				if !isCapturing(lhsHandler) && !isCapturing(rhsHandler) {
					comparison = Parameter.compare(lhs: lhsHandler, rhs: rhsHandler, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHandler, rhsHandler, "handler"))
				}

				if isCapturing(lhsTitle) || isCapturing(rhsTitle) {
					comparison = Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTitle, rhsTitle, "title"))
				}


				if isCapturing(lhsStyle) || isCapturing(rhsStyle) {
					comparison = Parameter.compare(lhs: lhsStyle, rhs: rhsStyle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStyle, rhsStyle, "style"))
				}


				if isCapturing(lhsHandler) || isCapturing(rhsHandler) {
					comparison = Parameter.compare(lhs: lhsHandler, rhs: rhsHandler, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHandler, rhsHandler, "handler"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_cancelAlertAction__handler_handler(let lhsHandler), .m_cancelAlertAction__handler_handler(let rhsHandler)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsHandler) && !isCapturing(rhsHandler) {
					comparison = Parameter.compare(lhs: lhsHandler, rhs: rhsHandler, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHandler, rhsHandler, "handler"))
				}

				if isCapturing(lhsHandler) || isCapturing(rhsHandler) {
					comparison = Parameter.compare(lhs: lhsHandler, rhs: rhsHandler, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHandler, rhsHandler, "handler"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_contextualAction__style_styletitle_titlehandler_handler(let lhsStyle, let lhsTitle, let lhsHandler), .m_contextualAction__style_styletitle_titlehandler_handler(let rhsStyle, let rhsTitle, let rhsHandler)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsStyle) && !isCapturing(rhsStyle) {
					comparison = Parameter.compare(lhs: lhsStyle, rhs: rhsStyle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStyle, rhsStyle, "style"))
				}


				if !isCapturing(lhsTitle) && !isCapturing(rhsTitle) {
					comparison = Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTitle, rhsTitle, "title"))
				}


				if !isCapturing(lhsHandler) && !isCapturing(rhsHandler) {
					comparison = Parameter.compare(lhs: lhsHandler, rhs: rhsHandler, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHandler, rhsHandler, "handler"))
				}

				if isCapturing(lhsStyle) || isCapturing(rhsStyle) {
					comparison = Parameter.compare(lhs: lhsStyle, rhs: rhsStyle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStyle, rhsStyle, "style"))
				}


				if isCapturing(lhsTitle) || isCapturing(rhsTitle) {
					comparison = Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTitle, rhsTitle, "title"))
				}


				if isCapturing(lhsHandler) || isCapturing(rhsHandler) {
					comparison = Parameter.compare(lhs: lhsHandler, rhs: rhsHandler, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsHandler, rhsHandler, "handler"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_stopObserving__observername_nameobject_object(let lhsObserver, let lhsName, let lhsObject), .m_stopObserving__observername_nameobject_object(let rhsObserver, let rhsName, let rhsObject)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsObserver) && !isCapturing(rhsObserver) {
					comparison = Parameter.compare(lhs: lhsObserver, rhs: rhsObserver, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObserver, rhsObserver, "_ observer"))
				}


				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}


				if !isCapturing(lhsObject) && !isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "object"))
				}

				if isCapturing(lhsObserver) || isCapturing(rhsObserver) {
					comparison = Parameter.compare(lhs: lhsObserver, rhs: rhsObserver, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObserver, rhsObserver, "_ observer"))
				}


				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}


				if isCapturing(lhsObject) || isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "object"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_post__name_nameobject_objectuserInfo_userInfo_1(let lhsName, let lhsObject, let lhsUserinfo), .m_post__name_nameobject_objectuserInfo_userInfo_1(let rhsName, let rhsObject, let rhsUserinfo)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}


				if !isCapturing(lhsObject) && !isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "object"))
				}


				if !isCapturing(lhsUserinfo) && !isCapturing(rhsUserinfo) {
					comparison = Parameter.compare(lhs: lhsUserinfo, rhs: rhsUserinfo, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUserinfo, rhsUserinfo, "userInfo"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}


				if isCapturing(lhsObject) || isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "object"))
				}


				if isCapturing(lhsUserinfo) || isCapturing(rhsUserinfo) {
					comparison = Parameter.compare(lhs: lhsUserinfo, rhs: rhsUserinfo, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUserinfo, rhsUserinfo, "userInfo"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_post__name_nameobject_objectuserInfo_userInfo_2(let lhsName, let lhsObject, let lhsUserinfo), .m_post__name_nameobject_objectuserInfo_userInfo_2(let rhsName, let rhsObject, let rhsUserinfo)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}


				if !isCapturing(lhsObject) && !isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "object"))
				}


				if !isCapturing(lhsUserinfo) && !isCapturing(rhsUserinfo) {
					comparison = Parameter.compare(lhs: lhsUserinfo, rhs: rhsUserinfo, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUserinfo, rhsUserinfo, "userInfo"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}


				if isCapturing(lhsObject) || isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "object"))
				}


				if isCapturing(lhsUserinfo) || isCapturing(rhsUserinfo) {
					comparison = Parameter.compare(lhs: lhsUserinfo, rhs: rhsUserinfo, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUserinfo, rhsUserinfo, "userInfo"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(let lhsPresentingcontroller, let lhsControllerbeingpresented, let lhsAnimated, let lhsCompletion), .m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion(let rhsPresentingcontroller, let rhsControllerbeingpresented, let rhsAnimated, let rhsCompletion)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsPresentingcontroller) && !isCapturing(rhsPresentingcontroller) {
					comparison = Parameter.compare(lhs: lhsPresentingcontroller, rhs: rhsPresentingcontroller, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPresentingcontroller, rhsPresentingcontroller, "_ presentingController"))
				}


				if !isCapturing(lhsControllerbeingpresented) && !isCapturing(rhsControllerbeingpresented) {
					comparison = Parameter.compare(lhs: lhsControllerbeingpresented, rhs: rhsControllerbeingpresented, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsControllerbeingpresented, rhsControllerbeingpresented, "_ controllerBeingPresented"))
				}


				if !isCapturing(lhsAnimated) && !isCapturing(rhsAnimated) {
					comparison = Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAnimated, rhsAnimated, "animated"))
				}


				if !isCapturing(lhsCompletion) && !isCapturing(rhsCompletion) {
					comparison = Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCompletion, rhsCompletion, "completion"))
				}

				if isCapturing(lhsPresentingcontroller) || isCapturing(rhsPresentingcontroller) {
					comparison = Parameter.compare(lhs: lhsPresentingcontroller, rhs: rhsPresentingcontroller, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPresentingcontroller, rhsPresentingcontroller, "_ presentingController"))
				}


				if isCapturing(lhsControllerbeingpresented) || isCapturing(rhsControllerbeingpresented) {
					comparison = Parameter.compare(lhs: lhsControllerbeingpresented, rhs: rhsControllerbeingpresented, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsControllerbeingpresented, rhsControllerbeingpresented, "_ controllerBeingPresented"))
				}


				if isCapturing(lhsAnimated) || isCapturing(rhsAnimated) {
					comparison = Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAnimated, rhsAnimated, "animated"))
				}


				if isCapturing(lhsCompletion) || isCapturing(rhsCompletion) {
					comparison = Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCompletion, rhsCompletion, "completion"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(let lhsViewcontroller, let lhsPresentingcontroller, let lhsPresenter, let lhsAnimated, let lhsCompletion), .m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion(let rhsViewcontroller, let rhsPresentingcontroller, let rhsPresenter, let rhsAnimated, let rhsCompletion)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsViewcontroller) && !isCapturing(rhsViewcontroller) {
					comparison = Parameter.compare(lhs: lhsViewcontroller, rhs: rhsViewcontroller, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsViewcontroller, rhsViewcontroller, "_ viewController"))
				}


				if !isCapturing(lhsPresentingcontroller) && !isCapturing(rhsPresentingcontroller) {
					comparison = Parameter.compare(lhs: lhsPresentingcontroller, rhs: rhsPresentingcontroller, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPresentingcontroller, rhsPresentingcontroller, "on presentingController"))
				}


				if !isCapturing(lhsPresenter) && !isCapturing(rhsPresenter) {
					comparison = Parameter.compare(lhs: lhsPresenter, rhs: rhsPresenter, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPresenter, rhsPresenter, "using presenter"))
				}


				if !isCapturing(lhsAnimated) && !isCapturing(rhsAnimated) {
					comparison = Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAnimated, rhsAnimated, "animated"))
				}


				if !isCapturing(lhsCompletion) && !isCapturing(rhsCompletion) {
					comparison = Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCompletion, rhsCompletion, "completion"))
				}

				if isCapturing(lhsViewcontroller) || isCapturing(rhsViewcontroller) {
					comparison = Parameter.compare(lhs: lhsViewcontroller, rhs: rhsViewcontroller, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsViewcontroller, rhsViewcontroller, "_ viewController"))
				}


				if isCapturing(lhsPresentingcontroller) || isCapturing(rhsPresentingcontroller) {
					comparison = Parameter.compare(lhs: lhsPresentingcontroller, rhs: rhsPresentingcontroller, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPresentingcontroller, rhsPresentingcontroller, "on presentingController"))
				}


				if isCapturing(lhsPresenter) || isCapturing(rhsPresenter) {
					comparison = Parameter.compare(lhs: lhsPresenter, rhs: rhsPresenter, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPresenter, rhsPresenter, "using presenter"))
				}


				if isCapturing(lhsAnimated) || isCapturing(rhsAnimated) {
					comparison = Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAnimated, rhsAnimated, "animated"))
				}


				if isCapturing(lhsCompletion) || isCapturing(rhsCompletion) {
					comparison = Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCompletion, rhsCompletion, "completion"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(let lhsController, let lhsNavigationcontroller, let lhsAnimated), .m_push__controller_controllertoNavigationController_navigationControlleranimated_animated(let rhsController, let rhsNavigationcontroller, let rhsAnimated)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsController) && !isCapturing(rhsController) {
					comparison = Parameter.compare(lhs: lhsController, rhs: rhsController, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsController, rhsController, "controller"))
				}


				if !isCapturing(lhsNavigationcontroller) && !isCapturing(rhsNavigationcontroller) {
					comparison = Parameter.compare(lhs: lhsNavigationcontroller, rhs: rhsNavigationcontroller, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNavigationcontroller, rhsNavigationcontroller, "toNavigationController navigationController"))
				}


				if !isCapturing(lhsAnimated) && !isCapturing(rhsAnimated) {
					comparison = Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAnimated, rhsAnimated, "animated"))
				}

				if isCapturing(lhsController) || isCapturing(rhsController) {
					comparison = Parameter.compare(lhs: lhsController, rhs: rhsController, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsController, rhsController, "controller"))
				}


				if isCapturing(lhsNavigationcontroller) || isCapturing(rhsNavigationcontroller) {
					comparison = Parameter.compare(lhs: lhsNavigationcontroller, rhs: rhsNavigationcontroller, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNavigationcontroller, rhsNavigationcontroller, "toNavigationController navigationController"))
				}


				if isCapturing(lhsAnimated) || isCapturing(rhsAnimated) {
					comparison = Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAnimated, rhsAnimated, "animated"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_popFrom__navigationControlleranimated_animated(let lhsNavigationcontroller, let lhsAnimated), .m_popFrom__navigationControlleranimated_animated(let rhsNavigationcontroller, let rhsAnimated)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsNavigationcontroller) && !isCapturing(rhsNavigationcontroller) {
					comparison = Parameter.compare(lhs: lhsNavigationcontroller, rhs: rhsNavigationcontroller, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNavigationcontroller, rhsNavigationcontroller, "_ navigationController"))
				}


				if !isCapturing(lhsAnimated) && !isCapturing(rhsAnimated) {
					comparison = Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAnimated, rhsAnimated, "animated"))
				}

				if isCapturing(lhsNavigationcontroller) || isCapturing(rhsNavigationcontroller) {
					comparison = Parameter.compare(lhs: lhsNavigationcontroller, rhs: rhsNavigationcontroller, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNavigationcontroller, rhsNavigationcontroller, "_ navigationController"))
				}


				if isCapturing(lhsAnimated) || isCapturing(rhsAnimated) {
					comparison = Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAnimated, rhsAnimated, "animated"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_sendUserNotification__withContent_contentid_idrepeats_repeatsinterval_interval(let lhsContent, let lhsId, let lhsRepeats, let lhsInterval), .m_sendUserNotification__withContent_contentid_idrepeats_repeatsinterval_interval(let rhsContent, let rhsId, let rhsRepeats, let rhsInterval)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsContent) && !isCapturing(rhsContent) {
					comparison = Parameter.compare(lhs: lhsContent, rhs: rhsContent, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsContent, rhsContent, "withContent content"))
				}


				if !isCapturing(lhsId) && !isCapturing(rhsId) {
					comparison = Parameter.compare(lhs: lhsId, rhs: rhsId, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsId, rhsId, "id"))
				}


				if !isCapturing(lhsRepeats) && !isCapturing(rhsRepeats) {
					comparison = Parameter.compare(lhs: lhsRepeats, rhs: rhsRepeats, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRepeats, rhsRepeats, "repeats"))
				}


				if !isCapturing(lhsInterval) && !isCapturing(rhsInterval) {
					comparison = Parameter.compare(lhs: lhsInterval, rhs: rhsInterval, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsInterval, rhsInterval, "interval"))
				}

				if isCapturing(lhsContent) || isCapturing(rhsContent) {
					comparison = Parameter.compare(lhs: lhsContent, rhs: rhsContent, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsContent, rhsContent, "withContent content"))
				}


				if isCapturing(lhsId) || isCapturing(rhsId) {
					comparison = Parameter.compare(lhs: lhsId, rhs: rhsId, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsId, rhsId, "id"))
				}


				if isCapturing(lhsRepeats) || isCapturing(rhsRepeats) {
					comparison = Parameter.compare(lhs: lhsRepeats, rhs: rhsRepeats, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRepeats, rhsRepeats, "repeats"))
				}


				if isCapturing(lhsInterval) || isCapturing(rhsInterval) {
					comparison = Parameter.compare(lhs: lhsInterval, rhs: rhsInterval, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsInterval, rhsInterval, "interval"))
				}

				return Matcher.ComparisonResult(results)
            case (.p_defaultPresenter_get,.p_defaultPresenter_get): return Matcher.ComparisonResult.match
            case (.p_hasTopNotch_get,.p_hasTopNotch_get): return Matcher.ComparisonResult.match
            default: return .none
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
            case let .m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_documentPicker__docTypes_docTypesin_pickerMode(p0, p1): return p0.intValue + p1.intValue
            case let .m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_tableViewRowAction__style_styletitle_titlehandler_handler(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_alertAction__title_titlestyle_stylehandler_handler(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_cancelAlertAction__handler_handler(p0): return p0.intValue
            case let .m_contextualAction__style_styletitle_titlehandler_handler(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
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
        func assertionName() -> String {
            switch self {
            case .m_customPresenter__width_widthheight_heightcenter_center: return ".customPresenter(width:height:center:)"
            case .m_setView__viewenabled_enabledhidden_hidden: return ".setView(_:enabled:hidden:)"
            case .m_setButton__buttonenabled_enabledhidden_hidden: return ".setButton(_:enabled:hidden:)"
            case .m_setBackButton__for_viewControllertitle_titleaction_selector: return ".setBackButton(for:title:action:)"
            case .m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action: return ".addSaveButtonToKeyboardFor(_:target:action:)"
            case .m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action: return ".addSaveButtonToKeyboardFor(_:target:action:)"
            case .m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional: return ".value(for:from:keyIsOptional:)"
            case .m_info__info: return ".info(_:)"
            case .m_controller__named_controllerNamefrom_storyboardNameas_as: return ".controller(named:from:as:)"
            case .m_controller__named_controllerNamefrom_storyboardas_as: return ".controller(named:from:as:)"
            case .m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as: return ".tableViewCell(from:withIdentifier:for:as:)"
            case .m_documentPicker__docTypes_docTypesin_pickerMode: return ".documentPicker(docTypes:in:)"
            case .m_alert__title_titlemessage_messagepreferredStyle_preferredStyle: return ".alert(title:message:preferredStyle:)"
            case .m_tableViewRowAction__style_styletitle_titlehandler_handler: return ".tableViewRowAction(style:title:handler:)"
            case .m_alertAction__title_titlestyle_stylehandler_handler: return ".alertAction(title:style:handler:)"
            case .m_cancelAlertAction__handler_handler: return ".cancelAlertAction(handler:)"
            case .m_contextualAction__style_styletitle_titlehandler_handler: return ".contextualAction(style:title:handler:)"
            case .m_stopObserving__observername_nameobject_object: return ".stopObserving(_:name:object:)"
            case .m_post__name_nameobject_objectuserInfo_userInfo_1: return ".post(name:object:userInfo:)"
            case .m_post__name_nameobject_objectuserInfo_userInfo_2: return ".post(name:object:userInfo:)"
            case .m_present__presentingController_controllerBeingPresentedanimated_animatedcompletion_completion: return ".present(_:_:animated:completion:)"
            case .m_present__viewControlleron_presentingControllerusing_presenteranimated_animatedcompletion_completion: return ".present(_:on:using:animated:completion:)"
            case .m_push__controller_controllertoNavigationController_navigationControlleranimated_animated: return ".push(controller:toNavigationController:animated:)"
            case .m_popFrom__navigationControlleranimated_animated: return ".popFrom(_:animated:)"
            case .m_sendUserNotification__withContent_contentid_idrepeats_repeatsinterval_interval: return ".sendUserNotification(withContent:id:repeats:interval:)"
            case .p_defaultPresenter_get: return "[get] .defaultPresenter"
            case .p_hasTopNotch_get: return "[get] .hasTopNotch"
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
        @discardableResult
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
        public static func tableViewCell<Type: UITableViewCell>(from tableView: Parameter<UITableView>, withIdentifier identifier: Parameter<String>, for indexPath: Parameter<IndexPath>, as: Parameter<Type.Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as(`tableView`, `identifier`, `indexPath`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func cancelAlertAction(handler: Parameter<((UIAlertAction) -> Void)?>, willReturn: UIAlertAction...) -> MethodStub {
            return Given(method: .m_cancelAlertAction__handler_handler(`handler`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func contextualAction(style: Parameter<UIContextualAction.Style>, title: Parameter<String?>, handler: Parameter<UIContextualAction.Handler>, willReturn: UIContextualAction...) -> MethodStub {
            return Given(method: .m_contextualAction__style_styletitle_titlehandler_handler(`style`, `title`, `handler`), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func tableViewCell<Type: UITableViewCell>(from tableView: Parameter<UITableView>, withIdentifier identifier: Parameter<String>, for indexPath: Parameter<IndexPath>, as: Parameter<Type.Type>, willProduce: (Stubber<Type>) -> Void) -> MethodStub {
            let willReturn: [Type] = []
			let given: Given = { return Given(method: .m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as(`tableView`, `identifier`, `indexPath`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
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
        public static func cancelAlertAction(handler: Parameter<((UIAlertAction) -> Void)?>, willProduce: (Stubber<UIAlertAction>) -> Void) -> MethodStub {
            let willReturn: [UIAlertAction] = []
			let given: Given = { return Given(method: .m_cancelAlertAction__handler_handler(`handler`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UIAlertAction).self)
			willProduce(stubber)
			return given
        }
        public static func contextualAction(style: Parameter<UIContextualAction.Style>, title: Parameter<String?>, handler: Parameter<UIContextualAction.Handler>, willProduce: (Stubber<UIContextualAction>) -> Void) -> MethodStub {
            let willReturn: [UIContextualAction] = []
			let given: Given = { return Given(method: .m_contextualAction__style_styletitle_titlehandler_handler(`style`, `title`, `handler`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UIContextualAction).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func customPresenter(width: Parameter<ModalSize>, height: Parameter<ModalSize>, center: Parameter<ModalCenterPosition>) -> Verify { return Verify(method: .m_customPresenter__width_widthheight_heightcenter_center(`width`, `height`, `center`))}
        public static func setView(_ view: Parameter<UIView>, enabled: Parameter<Bool?>, hidden: Parameter<Bool?>) -> Verify { return Verify(method: .m_setView__viewenabled_enabledhidden_hidden(`view`, `enabled`, `hidden`))}
        public static func setButton(_ button: Parameter<UIButton>, enabled: Parameter<Bool?>, hidden: Parameter<Bool?>) -> Verify { return Verify(method: .m_setButton__buttonenabled_enabledhidden_hidden(`button`, `enabled`, `hidden`))}
        @discardableResult
		public static func setBackButton(for viewController: Parameter<UIViewController>, title: Parameter<String>, action selector: Parameter<Selector>) -> Verify { return Verify(method: .m_setBackButton__for_viewControllertitle_titleaction_selector(`viewController`, `title`, `selector`))}
        public static func addSaveButtonToKeyboardFor(_ textView: Parameter<UITextView>, target: Parameter<Any?>, action: Parameter<Selector?>) -> Verify { return Verify(method: .m_addSaveButtonToKeyboardFor__textViewtarget_targetaction_action(`textView`, `target`, `action`))}
        public static func addSaveButtonToKeyboardFor(_ textField: Parameter<UITextField>, target: Parameter<Any?>, action: Parameter<Selector?>) -> Verify { return Verify(method: .m_addSaveButtonToKeyboardFor__textFieldtarget_targetaction_action(`textField`, `target`, `action`))}
        public static func value(for key: Parameter<UserInfoKey>, from notification: Parameter<Notification>, keyIsOptional: Parameter<Bool>) -> Verify { return Verify(method: .m_value__for_keyfrom_notificationkeyIsOptional_keyIsOptional(`key`, `notification`, `keyIsOptional`))}
        public static func info(_ info: Parameter<[UserInfoKey: Any]>) -> Verify { return Verify(method: .m_info__info(`info`))}
        public static func controller<Type>(named controllerName: Parameter<String>, from storyboardName: Parameter<String>, as: Parameter<Type.Type>) -> Verify where Type:UIViewController { return Verify(method: .m_controller__named_controllerNamefrom_storyboardNameas_as(`controllerName`, `storyboardName`, `as`.wrapAsGeneric()))}
        public static func controller<Type>(named controllerName: Parameter<String>, from storyboard: Parameter<UIStoryboard>, as: Parameter<Type.Type>) -> Verify where Type:UIViewController { return Verify(method: .m_controller__named_controllerNamefrom_storyboardas_as(`controllerName`, `storyboard`, `as`.wrapAsGeneric()))}
        public static func tableViewCell<Type>(from tableView: Parameter<UITableView>, withIdentifier identifier: Parameter<String>, for indexPath: Parameter<IndexPath>, as: Parameter<Type.Type>) -> Verify where Type:UITableViewCell { return Verify(method: .m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as(`tableView`, `identifier`, `indexPath`, `as`.wrapAsGeneric()))}
        public static func documentPicker(docTypes: Parameter<[String]>, in pickerMode: Parameter<UIDocumentPickerMode>) -> Verify { return Verify(method: .m_documentPicker__docTypes_docTypesin_pickerMode(`docTypes`, `pickerMode`))}
        public static func alert(title: Parameter<String?>, message: Parameter<String?>, preferredStyle: Parameter<UIAlertController.Style>) -> Verify { return Verify(method: .m_alert__title_titlemessage_messagepreferredStyle_preferredStyle(`title`, `message`, `preferredStyle`))}
        public static func tableViewRowAction(style: Parameter<UITableViewRowAction.Style>, title: Parameter<String?>, handler: Parameter<(UITableViewRowAction, IndexPath) -> Void>) -> Verify { return Verify(method: .m_tableViewRowAction__style_styletitle_titlehandler_handler(`style`, `title`, `handler`))}
        public static func alertAction(title: Parameter<String?>, style: Parameter<UIAlertAction.Style>, handler: Parameter<((UIAlertAction) -> Void)?>) -> Verify { return Verify(method: .m_alertAction__title_titlestyle_stylehandler_handler(`title`, `style`, `handler`))}
        public static func cancelAlertAction(handler: Parameter<((UIAlertAction) -> Void)?>) -> Verify { return Verify(method: .m_cancelAlertAction__handler_handler(`handler`))}
        public static func contextualAction(style: Parameter<UIContextualAction.Style>, title: Parameter<String?>, handler: Parameter<UIContextualAction.Handler>) -> Verify { return Verify(method: .m_contextualAction__style_styletitle_titlehandler_handler(`style`, `title`, `handler`))}
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
        @discardableResult
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
        public static func tableViewCell<Type>(from tableView: Parameter<UITableView>, withIdentifier identifier: Parameter<String>, for indexPath: Parameter<IndexPath>, as: Parameter<Type.Type>, perform: @escaping (UITableView, String, IndexPath, Type.Type) -> Void) -> Perform where Type:UITableViewCell {
            return Perform(method: .m_tableViewCell__from_tableViewwithIdentifier_identifierfor_indexPathas_as(`tableView`, `identifier`, `indexPath`, `as`.wrapAsGeneric()), performs: perform)
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
        public static func cancelAlertAction(handler: Parameter<((UIAlertAction) -> Void)?>, perform: @escaping (((UIAlertAction) -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_cancelAlertAction__handler_handler(`handler`), performs: perform)
        }
        public static func contextualAction(style: Parameter<UIContextualAction.Style>, title: Parameter<String?>, handler: Parameter<UIContextualAction.Handler>, perform: @escaping (UIContextualAction.Style, String?, @escaping UIContextualAction.Handler) -> Void) -> Perform {
            return Perform(method: .m_contextualAction__style_styletitle_titlehandler_handler(`style`, `title`, `handler`), performs: perform)
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

// MARK: - UserDefaultsUtil

open class UserDefaultsUtilMock: UserDefaultsUtil, Mock {
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_resetInstructionPrompts, .m_resetInstructionPrompts): return .match

            case (.m_setUserDefault__valueforKey_key(let lhsValue, let lhsKey), .m_setUserDefault__valueforKey_key(let rhsValue, let rhsKey)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsValue) && !isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "_ value"))
				}


				if !isCapturing(lhsKey) && !isCapturing(rhsKey) {
					comparison = Parameter.compare(lhs: lhsKey, rhs: rhsKey, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsKey, rhsKey, "forKey key"))
				}

				if isCapturing(lhsValue) || isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "_ value"))
				}


				if isCapturing(lhsKey) || isCapturing(rhsKey) {
					comparison = Parameter.compare(lhs: lhsKey, rhs: rhsKey, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsKey, rhsKey, "forKey key"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_bool__forKey_key(let lhsKey), .m_bool__forKey_key(let rhsKey)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsKey) && !isCapturing(rhsKey) {
					comparison = Parameter.compare(lhs: lhsKey, rhs: rhsKey, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsKey, rhsKey, "forKey key"))
				}

				if isCapturing(lhsKey) || isCapturing(rhsKey) {
					comparison = Parameter.compare(lhs: lhsKey, rhs: rhsKey, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsKey, rhsKey, "forKey key"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_resetInstructionPrompts: return 0
            case let .m_setUserDefault__valueforKey_key(p0, p1): return p0.intValue + p1.intValue
            case let .m_bool__forKey_key(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_resetInstructionPrompts: return ".resetInstructionPrompts()"
            case .m_setUserDefault__valueforKey_key: return ".setUserDefault(_:forKey:)"
            case .m_bool__forKey_key: return ".bool(forKey:)"
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

