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


// MARK: - Settings

open class SettingsMock: Settings, Mock {
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


    public var minMood: Double {
		get {	invocations.append(.p_minMood_get); return __p_minMood ?? givenGetterValue(.p_minMood_get, "SettingsMock - stub value for minMood was not defined") }
	}
	private var __p_minMood: (Double)?

    public var maxMood: Double {
		get {	invocations.append(.p_maxMood_get); return __p_maxMood ?? givenGetterValue(.p_maxMood_get, "SettingsMock - stub value for maxMood was not defined") }
	}
	private var __p_maxMood: (Double)?

    public var discreteMoods: Bool {
		get {	invocations.append(.p_discreteMoods_get); return __p_discreteMoods ?? givenGetterValue(.p_discreteMoods_get, "SettingsMock - stub value for discreteMoods was not defined") }
	}
	private var __p_discreteMoods: (Bool)?

    public var scaleMoodsOnImport: Bool {
		get {	invocations.append(.p_scaleMoodsOnImport_get); return __p_scaleMoodsOnImport ?? givenGetterValue(.p_scaleMoodsOnImport_get, "SettingsMock - stub value for scaleMoodsOnImport was not defined") }
	}
	private var __p_scaleMoodsOnImport: (Bool)?

    public var minFatigue: Double {
		get {	invocations.append(.p_minFatigue_get); return __p_minFatigue ?? givenGetterValue(.p_minFatigue_get, "SettingsMock - stub value for minFatigue was not defined") }
	}
	private var __p_minFatigue: (Double)?

    public var maxFatigue: Double {
		get {	invocations.append(.p_maxFatigue_get); return __p_maxFatigue ?? givenGetterValue(.p_maxFatigue_get, "SettingsMock - stub value for maxFatigue was not defined") }
	}
	private var __p_maxFatigue: (Double)?

    public var discreteFatigue: Bool {
		get {	invocations.append(.p_discreteFatigue_get); return __p_discreteFatigue ?? givenGetterValue(.p_discreteFatigue_get, "SettingsMock - stub value for discreteFatigue was not defined") }
	}
	private var __p_discreteFatigue: (Bool)?

    public var autoIgnoreEnabled: Bool {
		get {	invocations.append(.p_autoIgnoreEnabled_get); return __p_autoIgnoreEnabled ?? givenGetterValue(.p_autoIgnoreEnabled_get, "SettingsMock - stub value for autoIgnoreEnabled was not defined") }
	}
	private var __p_autoIgnoreEnabled: (Bool)?

    public var autoIgnoreSeconds: Int {
		get {	invocations.append(.p_autoIgnoreSeconds_get); return __p_autoIgnoreSeconds ?? givenGetterValue(.p_autoIgnoreSeconds_get, "SettingsMock - stub value for autoIgnoreSeconds was not defined") }
	}
	private var __p_autoIgnoreSeconds: (Int)?

    public var autoTrimWhitespaceInActivityNotes: Bool {
		get {	invocations.append(.p_autoTrimWhitespaceInActivityNotes_get); return __p_autoTrimWhitespaceInActivityNotes ?? givenGetterValue(.p_autoTrimWhitespaceInActivityNotes_get, "SettingsMock - stub value for autoTrimWhitespaceInActivityNotes was not defined") }
	}
	private var __p_autoTrimWhitespaceInActivityNotes: (Bool)?

    public var convertTimeZones: Bool {
		get {	invocations.append(.p_convertTimeZones_get); return __p_convertTimeZones ?? givenGetterValue(.p_convertTimeZones_get, "SettingsMock - stub value for convertTimeZones was not defined") }
	}
	private var __p_convertTimeZones: (Bool)?

    public var defaultSearchNearbyDuration: TimeDuration {
		get {	invocations.append(.p_defaultSearchNearbyDuration_get); return __p_defaultSearchNearbyDuration ?? givenGetterValue(.p_defaultSearchNearbyDuration_get, "SettingsMock - stub value for defaultSearchNearbyDuration was not defined") }
	}
	private var __p_defaultSearchNearbyDuration: (TimeDuration)?





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

    open func setMinFatigue(_ value: Double) {
        addInvocation(.m_setMinFatigue__value(Parameter<Double>.value(`value`)))
		let perform = methodPerformValue(.m_setMinFatigue__value(Parameter<Double>.value(`value`))) as? (Double) -> Void
		perform?(`value`)
    }

    open func setMaxFatigue(_ value: Double) {
        addInvocation(.m_setMaxFatigue__value(Parameter<Double>.value(`value`)))
		let perform = methodPerformValue(.m_setMaxFatigue__value(Parameter<Double>.value(`value`))) as? (Double) -> Void
		perform?(`value`)
    }

    open func setDiscreteFatigue(_ value: Bool) {
        addInvocation(.m_setDiscreteFatigue__value(Parameter<Bool>.value(`value`)))
		let perform = methodPerformValue(.m_setDiscreteFatigue__value(Parameter<Bool>.value(`value`))) as? (Bool) -> Void
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

    open func setAutoTrimWhitespaceInActivityNotes(_ value: Bool) {
        addInvocation(.m_setAutoTrimWhitespaceInActivityNotes__value(Parameter<Bool>.value(`value`)))
		let perform = methodPerformValue(.m_setAutoTrimWhitespaceInActivityNotes__value(Parameter<Bool>.value(`value`))) as? (Bool) -> Void
		perform?(`value`)
    }

    open func setConvertTimeZones(_ value: Bool) {
        addInvocation(.m_setConvertTimeZones__value(Parameter<Bool>.value(`value`)))
		let perform = methodPerformValue(.m_setConvertTimeZones__value(Parameter<Bool>.value(`value`))) as? (Bool) -> Void
		perform?(`value`)
    }

    open func setDefaultSearchNearbyDuration(_ value: TimeDuration) {
        addInvocation(.m_setDefaultSearchNearbyDuration__value(Parameter<TimeDuration>.value(`value`)))
		let perform = methodPerformValue(.m_setDefaultSearchNearbyDuration__value(Parameter<TimeDuration>.value(`value`))) as? (TimeDuration) -> Void
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


    fileprivate enum MethodType {
        case m_setMinMood__value(Parameter<Double>)
        case m_setMaxMood__value(Parameter<Double>)
        case m_setDiscreteMoods__value(Parameter<Bool>)
        case m_setScaleMoodsOnImport__value(Parameter<Bool>)
        case m_setMinFatigue__value(Parameter<Double>)
        case m_setMaxFatigue__value(Parameter<Double>)
        case m_setDiscreteFatigue__value(Parameter<Bool>)
        case m_setAutoIgnoreEnabled__value(Parameter<Bool>)
        case m_setAutoIgnoreSeconds__value(Parameter<Int>)
        case m_setAutoTrimWhitespaceInActivityNotes__value(Parameter<Bool>)
        case m_setConvertTimeZones__value(Parameter<Bool>)
        case m_setDefaultSearchNearbyDuration__value(Parameter<TimeDuration>)
        case m_changed__setting(Parameter<Setting>)
        case m_reset
        case m_save
        case p_minMood_get
        case p_maxMood_get
        case p_discreteMoods_get
        case p_scaleMoodsOnImport_get
        case p_minFatigue_get
        case p_maxFatigue_get
        case p_discreteFatigue_get
        case p_autoIgnoreEnabled_get
        case p_autoIgnoreSeconds_get
        case p_autoTrimWhitespaceInActivityNotes_get
        case p_convertTimeZones_get
        case p_defaultSearchNearbyDuration_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_setMinMood__value(let lhsValue), .m_setMinMood__value(let rhsValue)):
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

            case (.m_setMaxMood__value(let lhsValue), .m_setMaxMood__value(let rhsValue)):
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

            case (.m_setDiscreteMoods__value(let lhsValue), .m_setDiscreteMoods__value(let rhsValue)):
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

            case (.m_setScaleMoodsOnImport__value(let lhsValue), .m_setScaleMoodsOnImport__value(let rhsValue)):
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

            case (.m_setMinFatigue__value(let lhsValue), .m_setMinFatigue__value(let rhsValue)):
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

            case (.m_setMaxFatigue__value(let lhsValue), .m_setMaxFatigue__value(let rhsValue)):
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

            case (.m_setDiscreteFatigue__value(let lhsValue), .m_setDiscreteFatigue__value(let rhsValue)):
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

            case (.m_setAutoIgnoreEnabled__value(let lhsValue), .m_setAutoIgnoreEnabled__value(let rhsValue)):
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

            case (.m_setAutoIgnoreSeconds__value(let lhsValue), .m_setAutoIgnoreSeconds__value(let rhsValue)):
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

            case (.m_setAutoTrimWhitespaceInActivityNotes__value(let lhsValue), .m_setAutoTrimWhitespaceInActivityNotes__value(let rhsValue)):
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

            case (.m_setConvertTimeZones__value(let lhsValue), .m_setConvertTimeZones__value(let rhsValue)):
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

            case (.m_setDefaultSearchNearbyDuration__value(let lhsValue), .m_setDefaultSearchNearbyDuration__value(let rhsValue)):
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

            case (.m_changed__setting(let lhsSetting), .m_changed__setting(let rhsSetting)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSetting) && !isCapturing(rhsSetting) {
					comparison = Parameter.compare(lhs: lhsSetting, rhs: rhsSetting, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSetting, rhsSetting, "_ setting"))
				}

				if isCapturing(lhsSetting) || isCapturing(rhsSetting) {
					comparison = Parameter.compare(lhs: lhsSetting, rhs: rhsSetting, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSetting, rhsSetting, "_ setting"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_reset, .m_reset): return .match

            case (.m_save, .m_save): return .match
            case (.p_minMood_get,.p_minMood_get): return Matcher.ComparisonResult.match
            case (.p_maxMood_get,.p_maxMood_get): return Matcher.ComparisonResult.match
            case (.p_discreteMoods_get,.p_discreteMoods_get): return Matcher.ComparisonResult.match
            case (.p_scaleMoodsOnImport_get,.p_scaleMoodsOnImport_get): return Matcher.ComparisonResult.match
            case (.p_minFatigue_get,.p_minFatigue_get): return Matcher.ComparisonResult.match
            case (.p_maxFatigue_get,.p_maxFatigue_get): return Matcher.ComparisonResult.match
            case (.p_discreteFatigue_get,.p_discreteFatigue_get): return Matcher.ComparisonResult.match
            case (.p_autoIgnoreEnabled_get,.p_autoIgnoreEnabled_get): return Matcher.ComparisonResult.match
            case (.p_autoIgnoreSeconds_get,.p_autoIgnoreSeconds_get): return Matcher.ComparisonResult.match
            case (.p_autoTrimWhitespaceInActivityNotes_get,.p_autoTrimWhitespaceInActivityNotes_get): return Matcher.ComparisonResult.match
            case (.p_convertTimeZones_get,.p_convertTimeZones_get): return Matcher.ComparisonResult.match
            case (.p_defaultSearchNearbyDuration_get,.p_defaultSearchNearbyDuration_get): return Matcher.ComparisonResult.match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_setMinMood__value(p0): return p0.intValue
            case let .m_setMaxMood__value(p0): return p0.intValue
            case let .m_setDiscreteMoods__value(p0): return p0.intValue
            case let .m_setScaleMoodsOnImport__value(p0): return p0.intValue
            case let .m_setMinFatigue__value(p0): return p0.intValue
            case let .m_setMaxFatigue__value(p0): return p0.intValue
            case let .m_setDiscreteFatigue__value(p0): return p0.intValue
            case let .m_setAutoIgnoreEnabled__value(p0): return p0.intValue
            case let .m_setAutoIgnoreSeconds__value(p0): return p0.intValue
            case let .m_setAutoTrimWhitespaceInActivityNotes__value(p0): return p0.intValue
            case let .m_setConvertTimeZones__value(p0): return p0.intValue
            case let .m_setDefaultSearchNearbyDuration__value(p0): return p0.intValue
            case let .m_changed__setting(p0): return p0.intValue
            case .m_reset: return 0
            case .m_save: return 0
            case .p_minMood_get: return 0
            case .p_maxMood_get: return 0
            case .p_discreteMoods_get: return 0
            case .p_scaleMoodsOnImport_get: return 0
            case .p_minFatigue_get: return 0
            case .p_maxFatigue_get: return 0
            case .p_discreteFatigue_get: return 0
            case .p_autoIgnoreEnabled_get: return 0
            case .p_autoIgnoreSeconds_get: return 0
            case .p_autoTrimWhitespaceInActivityNotes_get: return 0
            case .p_convertTimeZones_get: return 0
            case .p_defaultSearchNearbyDuration_get: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_setMinMood__value: return ".setMinMood(_:)"
            case .m_setMaxMood__value: return ".setMaxMood(_:)"
            case .m_setDiscreteMoods__value: return ".setDiscreteMoods(_:)"
            case .m_setScaleMoodsOnImport__value: return ".setScaleMoodsOnImport(_:)"
            case .m_setMinFatigue__value: return ".setMinFatigue(_:)"
            case .m_setMaxFatigue__value: return ".setMaxFatigue(_:)"
            case .m_setDiscreteFatigue__value: return ".setDiscreteFatigue(_:)"
            case .m_setAutoIgnoreEnabled__value: return ".setAutoIgnoreEnabled(_:)"
            case .m_setAutoIgnoreSeconds__value: return ".setAutoIgnoreSeconds(_:)"
            case .m_setAutoTrimWhitespaceInActivityNotes__value: return ".setAutoTrimWhitespaceInActivityNotes(_:)"
            case .m_setConvertTimeZones__value: return ".setConvertTimeZones(_:)"
            case .m_setDefaultSearchNearbyDuration__value: return ".setDefaultSearchNearbyDuration(_:)"
            case .m_changed__setting: return ".changed(_:)"
            case .m_reset: return ".reset()"
            case .m_save: return ".save()"
            case .p_minMood_get: return "[get] .minMood"
            case .p_maxMood_get: return "[get] .maxMood"
            case .p_discreteMoods_get: return "[get] .discreteMoods"
            case .p_scaleMoodsOnImport_get: return "[get] .scaleMoodsOnImport"
            case .p_minFatigue_get: return "[get] .minFatigue"
            case .p_maxFatigue_get: return "[get] .maxFatigue"
            case .p_discreteFatigue_get: return "[get] .discreteFatigue"
            case .p_autoIgnoreEnabled_get: return "[get] .autoIgnoreEnabled"
            case .p_autoIgnoreSeconds_get: return "[get] .autoIgnoreSeconds"
            case .p_autoTrimWhitespaceInActivityNotes_get: return "[get] .autoTrimWhitespaceInActivityNotes"
            case .p_convertTimeZones_get: return "[get] .convertTimeZones"
            case .p_defaultSearchNearbyDuration_get: return "[get] .defaultSearchNearbyDuration"
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
        public static func minFatigue(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_minFatigue_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func maxFatigue(getter defaultValue: Double...) -> PropertyStub {
            return Given(method: .p_maxFatigue_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func discreteFatigue(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_discreteFatigue_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func autoIgnoreEnabled(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_autoIgnoreEnabled_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func autoIgnoreSeconds(getter defaultValue: Int...) -> PropertyStub {
            return Given(method: .p_autoIgnoreSeconds_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func autoTrimWhitespaceInActivityNotes(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_autoTrimWhitespaceInActivityNotes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func convertTimeZones(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_convertTimeZones_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func defaultSearchNearbyDuration(getter defaultValue: TimeDuration...) -> PropertyStub {
            return Given(method: .p_defaultSearchNearbyDuration_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
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
        public static func setMinFatigue(_ value: Parameter<Double>) -> Verify { return Verify(method: .m_setMinFatigue__value(`value`))}
        public static func setMaxFatigue(_ value: Parameter<Double>) -> Verify { return Verify(method: .m_setMaxFatigue__value(`value`))}
        public static func setDiscreteFatigue(_ value: Parameter<Bool>) -> Verify { return Verify(method: .m_setDiscreteFatigue__value(`value`))}
        public static func setAutoIgnoreEnabled(_ value: Parameter<Bool>) -> Verify { return Verify(method: .m_setAutoIgnoreEnabled__value(`value`))}
        public static func setAutoIgnoreSeconds(_ value: Parameter<Int>) -> Verify { return Verify(method: .m_setAutoIgnoreSeconds__value(`value`))}
        public static func setAutoTrimWhitespaceInActivityNotes(_ value: Parameter<Bool>) -> Verify { return Verify(method: .m_setAutoTrimWhitespaceInActivityNotes__value(`value`))}
        public static func setConvertTimeZones(_ value: Parameter<Bool>) -> Verify { return Verify(method: .m_setConvertTimeZones__value(`value`))}
        public static func setDefaultSearchNearbyDuration(_ value: Parameter<TimeDuration>) -> Verify { return Verify(method: .m_setDefaultSearchNearbyDuration__value(`value`))}
        public static func changed(_ setting: Parameter<Setting>) -> Verify { return Verify(method: .m_changed__setting(`setting`))}
        public static func reset() -> Verify { return Verify(method: .m_reset)}
        public static func save() -> Verify { return Verify(method: .m_save)}
        public static var minMood: Verify { return Verify(method: .p_minMood_get) }
        public static var maxMood: Verify { return Verify(method: .p_maxMood_get) }
        public static var discreteMoods: Verify { return Verify(method: .p_discreteMoods_get) }
        public static var scaleMoodsOnImport: Verify { return Verify(method: .p_scaleMoodsOnImport_get) }
        public static var minFatigue: Verify { return Verify(method: .p_minFatigue_get) }
        public static var maxFatigue: Verify { return Verify(method: .p_maxFatigue_get) }
        public static var discreteFatigue: Verify { return Verify(method: .p_discreteFatigue_get) }
        public static var autoIgnoreEnabled: Verify { return Verify(method: .p_autoIgnoreEnabled_get) }
        public static var autoIgnoreSeconds: Verify { return Verify(method: .p_autoIgnoreSeconds_get) }
        public static var autoTrimWhitespaceInActivityNotes: Verify { return Verify(method: .p_autoTrimWhitespaceInActivityNotes_get) }
        public static var convertTimeZones: Verify { return Verify(method: .p_convertTimeZones_get) }
        public static var defaultSearchNearbyDuration: Verify { return Verify(method: .p_defaultSearchNearbyDuration_get) }
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
        public static func setMinFatigue(_ value: Parameter<Double>, perform: @escaping (Double) -> Void) -> Perform {
            return Perform(method: .m_setMinFatigue__value(`value`), performs: perform)
        }
        public static func setMaxFatigue(_ value: Parameter<Double>, perform: @escaping (Double) -> Void) -> Perform {
            return Perform(method: .m_setMaxFatigue__value(`value`), performs: perform)
        }
        public static func setDiscreteFatigue(_ value: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_setDiscreteFatigue__value(`value`), performs: perform)
        }
        public static func setAutoIgnoreEnabled(_ value: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_setAutoIgnoreEnabled__value(`value`), performs: perform)
        }
        public static func setAutoIgnoreSeconds(_ value: Parameter<Int>, perform: @escaping (Int) -> Void) -> Perform {
            return Perform(method: .m_setAutoIgnoreSeconds__value(`value`), performs: perform)
        }
        public static func setAutoTrimWhitespaceInActivityNotes(_ value: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_setAutoTrimWhitespaceInActivityNotes__value(`value`), performs: perform)
        }
        public static func setConvertTimeZones(_ value: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_setConvertTimeZones__value(`value`), performs: perform)
        }
        public static func setDefaultSearchNearbyDuration(_ value: Parameter<TimeDuration>, perform: @escaping (TimeDuration) -> Void) -> Perform {
            return Perform(method: .m_setDefaultSearchNearbyDuration__value(`value`), performs: perform)
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

