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




// MARK: - ActivityDAO

open class ActivityDAOMock: ActivityDAO, Mock {
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






    open func getActivities(from minDate: Date?, to maxDate: Date?) throws -> [Activity] {
        addInvocation(.m_getActivities__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`)))
		let perform = methodPerformValue(.m_getActivities__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`))) as? (Date?, Date?) -> Void
		perform?(`minDate`, `maxDate`)
		var __value: [Activity]
		do {
		    __value = try methodReturnValue(.m_getActivities__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getActivities(from minDate: Date?, to maxDate: Date?). Use given")
			Failure("Stub return value not specified for getActivities(from minDate: Date?, to maxDate: Date?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getAllActivitiesForToday(_ activityDefinition: ActivityDefinition) throws -> [Activity] {
        addInvocation(.m_getAllActivitiesForToday__activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`)))
		let perform = methodPerformValue(.m_getAllActivitiesForToday__activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`))) as? (ActivityDefinition) -> Void
		perform?(`activityDefinition`)
		var __value: [Activity]
		do {
		    __value = try methodReturnValue(.m_getAllActivitiesForToday__activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getAllActivitiesForToday(_ activityDefinition: ActivityDefinition). Use given")
			Failure("Stub return value not specified for getAllActivitiesForToday(_ activityDefinition: ActivityDefinition). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getMostRecentActivityEndDate() throws -> Date? {
        addInvocation(.m_getMostRecentActivityEndDate)
		let perform = methodPerformValue(.m_getMostRecentActivityEndDate) as? () -> Void
		perform?()
		var __value: Date? = nil
		do {
		    __value = try methodReturnValue(.m_getMostRecentActivityEndDate).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    open func getMostRecentlyStartedActivity(for activityDefinition: ActivityDefinition) throws -> Activity? {
        addInvocation(.m_getMostRecentlyStartedActivity__for_activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`)))
		let perform = methodPerformValue(.m_getMostRecentlyStartedActivity__for_activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`))) as? (ActivityDefinition) -> Void
		perform?(`activityDefinition`)
		var __value: Activity? = nil
		do {
		    __value = try methodReturnValue(.m_getMostRecentlyStartedActivity__for_activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`))).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    open func getMostRecentlyStartedIncompleteActivity(for activityDefinition: ActivityDefinition) throws -> Activity? {
        addInvocation(.m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`)))
		let perform = methodPerformValue(.m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`))) as? (ActivityDefinition) -> Void
		perform?(`activityDefinition`)
		var __value: Activity? = nil
		do {
		    __value = try methodReturnValue(.m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`))).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    open func getDefinitionWith(name: String) throws -> ActivityDefinition? {
        addInvocation(.m_getDefinitionWith__name_name(Parameter<String>.value(`name`)))
		let perform = methodPerformValue(.m_getDefinitionWith__name_name(Parameter<String>.value(`name`))) as? (String) -> Void
		perform?(`name`)
		var __value: ActivityDefinition? = nil
		do {
		    __value = try methodReturnValue(.m_getDefinitionWith__name_name(Parameter<String>.value(`name`))).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    open func activityDefinitionWithNameExists(_ name: String) throws -> Bool {
        addInvocation(.m_activityDefinitionWithNameExists__name(Parameter<String>.value(`name`)))
		let perform = methodPerformValue(.m_activityDefinitionWithNameExists__name(Parameter<String>.value(`name`))) as? (String) -> Void
		perform?(`name`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_activityDefinitionWithNameExists__name(Parameter<String>.value(`name`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for activityDefinitionWithNameExists(_ name: String). Use given")
			Failure("Stub return value not specified for activityDefinitionWithNameExists(_ name: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func hasUnfinishedActivity(_ activityDefinition: ActivityDefinition) throws -> Bool {
        addInvocation(.m_hasUnfinishedActivity__activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`)))
		let perform = methodPerformValue(.m_hasUnfinishedActivity__activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`))) as? (ActivityDefinition) -> Void
		perform?(`activityDefinition`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_hasUnfinishedActivity__activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for hasUnfinishedActivity(_ activityDefinition: ActivityDefinition). Use given")
			Failure("Stub return value not specified for hasUnfinishedActivity(_ activityDefinition: ActivityDefinition). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    @discardableResult
	open func startActivity(_ definition: ActivityDefinition, withNote note: String?) throws -> Activity {
        addInvocation(.m_startActivity__definitionwithNote_note(Parameter<ActivityDefinition>.value(`definition`), Parameter<String?>.value(`note`)))
		let perform = methodPerformValue(.m_startActivity__definitionwithNote_note(Parameter<ActivityDefinition>.value(`definition`), Parameter<String?>.value(`note`))) as? (ActivityDefinition, String?) -> Void
		perform?(`definition`, `note`)
		var __value: Activity
		do {
		    __value = try methodReturnValue(.m_startActivity__definitionwithNote_note(Parameter<ActivityDefinition>.value(`definition`), Parameter<String?>.value(`note`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for startActivity(_ definition: ActivityDefinition, withNote note: String?). Use given")
			Failure("Stub return value not specified for startActivity(_ definition: ActivityDefinition, withNote note: String?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    @discardableResult
	open func stopMostRecentlyStartedIncompleteActivity(for activityDefinition: ActivityDefinition) throws -> Activity {
        addInvocation(.m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`)))
		let perform = methodPerformValue(.m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`))) as? (ActivityDefinition) -> Void
		perform?(`activityDefinition`)
		var __value: Activity
		do {
		    __value = try methodReturnValue(.m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(Parameter<ActivityDefinition>.value(`activityDefinition`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for stopMostRecentlyStartedIncompleteActivity(for activityDefinition: ActivityDefinition). Use given")
			Failure("Stub return value not specified for stopMostRecentlyStartedIncompleteActivity(for activityDefinition: ActivityDefinition). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    @discardableResult
	open func stopMostRecentlyStartedIncompleteActivity() throws -> Activity {
        addInvocation(.m_stopMostRecentlyStartedIncompleteActivity)
		let perform = methodPerformValue(.m_stopMostRecentlyStartedIncompleteActivity) as? () -> Void
		perform?()
		var __value: Activity
		do {
		    __value = try methodReturnValue(.m_stopMostRecentlyStartedIncompleteActivity).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for stopMostRecentlyStartedIncompleteActivity(). Use given")
			Failure("Stub return value not specified for stopMostRecentlyStartedIncompleteActivity(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    @discardableResult
	open func stopAllActivities() throws -> [Activity] {
        addInvocation(.m_stopAllActivities)
		let perform = methodPerformValue(.m_stopAllActivities) as? () -> Void
		perform?()
		var __value: [Activity]
		do {
		    __value = try methodReturnValue(.m_stopAllActivities).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for stopAllActivities(). Use given")
			Failure("Stub return value not specified for stopAllActivities(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func autoIgnoreIfAppropriate(_ activity: Activity, end: Date) -> Bool {
        addInvocation(.m_autoIgnoreIfAppropriate__activityend_end(Parameter<Activity>.value(`activity`), Parameter<Date>.value(`end`)))
		let perform = methodPerformValue(.m_autoIgnoreIfAppropriate__activityend_end(Parameter<Activity>.value(`activity`), Parameter<Date>.value(`end`))) as? (Activity, Date) -> Void
		perform?(`activity`, `end`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_autoIgnoreIfAppropriate__activityend_end(Parameter<Activity>.value(`activity`), Parameter<Date>.value(`end`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for autoIgnoreIfAppropriate(_ activity: Activity, end: Date). Use given")
			Failure("Stub return value not specified for autoIgnoreIfAppropriate(_ activity: Activity, end: Date). Use given")
		}
		return __value
    }

    @discardableResult
	open func createDefinition(		name: String,		description: String?,		source: Sources.ActivitySourceNum,		recordScreenIndex: Int16?,		autoNote: Bool?,		using transaction: Transaction?	) throws -> ActivityDefinition {
        addInvocation(.m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(Parameter<String>.value(`name`), Parameter<String?>.value(`description`), Parameter<Sources.ActivitySourceNum>.value(`source`), Parameter<Int16?>.value(`recordScreenIndex`), Parameter<Bool?>.value(`autoNote`), Parameter<Transaction?>.value(`transaction`)))
		let perform = methodPerformValue(.m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(Parameter<String>.value(`name`), Parameter<String?>.value(`description`), Parameter<Sources.ActivitySourceNum>.value(`source`), Parameter<Int16?>.value(`recordScreenIndex`), Parameter<Bool?>.value(`autoNote`), Parameter<Transaction?>.value(`transaction`))) as? (String, String?, Sources.ActivitySourceNum, Int16?, Bool?, Transaction?) -> Void
		perform?(`name`, `description`, `source`, `recordScreenIndex`, `autoNote`, `transaction`)
		var __value: ActivityDefinition
		do {
		    __value = try methodReturnValue(.m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(Parameter<String>.value(`name`), Parameter<String?>.value(`description`), Parameter<Sources.ActivitySourceNum>.value(`source`), Parameter<Int16?>.value(`recordScreenIndex`), Parameter<Bool?>.value(`autoNote`), Parameter<Transaction?>.value(`transaction`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for createDefinition(  name: String,  description: String?,  source: Sources.ActivitySourceNum,  recordScreenIndex: Int16?,  autoNote: Bool?,  using transaction: Transaction? ). Use given")
			Failure("Stub return value not specified for createDefinition(  name: String,  description: String?,  source: Sources.ActivitySourceNum,  recordScreenIndex: Int16?,  autoNote: Bool?,  using transaction: Transaction? ). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    @discardableResult
	open func createActivity(		definition: ActivityDefinition,		startDate: Date,		source: Sources.ActivitySourceNum,		endDate: Date?,		note: String?,		extraTags: [Tag],		using transaction: Transaction?	) throws -> Activity {
        addInvocation(.m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(Parameter<ActivityDefinition>.value(`definition`), Parameter<Date>.value(`startDate`), Parameter<Sources.ActivitySourceNum>.value(`source`), Parameter<Date?>.value(`endDate`), Parameter<String?>.value(`note`), Parameter<[Tag]>.value(`extraTags`), Parameter<Transaction?>.value(`transaction`)))
		let perform = methodPerformValue(.m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(Parameter<ActivityDefinition>.value(`definition`), Parameter<Date>.value(`startDate`), Parameter<Sources.ActivitySourceNum>.value(`source`), Parameter<Date?>.value(`endDate`), Parameter<String?>.value(`note`), Parameter<[Tag]>.value(`extraTags`), Parameter<Transaction?>.value(`transaction`))) as? (ActivityDefinition, Date, Sources.ActivitySourceNum, Date?, String?, [Tag], Transaction?) -> Void
		perform?(`definition`, `startDate`, `source`, `endDate`, `note`, `extraTags`, `transaction`)
		var __value: Activity
		do {
		    __value = try methodReturnValue(.m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(Parameter<ActivityDefinition>.value(`definition`), Parameter<Date>.value(`startDate`), Parameter<Sources.ActivitySourceNum>.value(`source`), Parameter<Date?>.value(`endDate`), Parameter<String?>.value(`note`), Parameter<[Tag]>.value(`extraTags`), Parameter<Transaction?>.value(`transaction`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for createActivity(  definition: ActivityDefinition,  startDate: Date,  source: Sources.ActivitySourceNum,  endDate: Date?,  note: String?,  extraTags: [Tag],  using transaction: Transaction? ). Use given")
			Failure("Stub return value not specified for createActivity(  definition: ActivityDefinition,  startDate: Date,  source: Sources.ActivitySourceNum,  endDate: Date?,  note: String?,  extraTags: [Tag],  using transaction: Transaction? ). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getActivities__from_minDateto_maxDate(Parameter<Date?>, Parameter<Date?>)
        case m_getAllActivitiesForToday__activityDefinition(Parameter<ActivityDefinition>)
        case m_getMostRecentActivityEndDate
        case m_getMostRecentlyStartedActivity__for_activityDefinition(Parameter<ActivityDefinition>)
        case m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(Parameter<ActivityDefinition>)
        case m_getDefinitionWith__name_name(Parameter<String>)
        case m_activityDefinitionWithNameExists__name(Parameter<String>)
        case m_hasUnfinishedActivity__activityDefinition(Parameter<ActivityDefinition>)
        case m_startActivity__definitionwithNote_note(Parameter<ActivityDefinition>, Parameter<String?>)
        case m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(Parameter<ActivityDefinition>)
        case m_stopMostRecentlyStartedIncompleteActivity
        case m_stopAllActivities
        case m_autoIgnoreIfAppropriate__activityend_end(Parameter<Activity>, Parameter<Date>)
        case m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(Parameter<String>, Parameter<String?>, Parameter<Sources.ActivitySourceNum>, Parameter<Int16?>, Parameter<Bool?>, Parameter<Transaction?>)
        case m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(Parameter<ActivityDefinition>, Parameter<Date>, Parameter<Sources.ActivitySourceNum>, Parameter<Date?>, Parameter<String?>, Parameter<[Tag]>, Parameter<Transaction?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getActivities__from_minDateto_maxDate(let lhsMindate, let lhsMaxdate), .m_getActivities__from_minDateto_maxDate(let rhsMindate, let rhsMaxdate)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsMindate) && !isCapturing(rhsMindate) {
					comparison = Parameter.compare(lhs: lhsMindate, rhs: rhsMindate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMindate, rhsMindate, "from minDate"))
				}


				if !isCapturing(lhsMaxdate) && !isCapturing(rhsMaxdate) {
					comparison = Parameter.compare(lhs: lhsMaxdate, rhs: rhsMaxdate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxdate, rhsMaxdate, "to maxDate"))
				}

				if isCapturing(lhsMindate) || isCapturing(rhsMindate) {
					comparison = Parameter.compare(lhs: lhsMindate, rhs: rhsMindate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMindate, rhsMindate, "from minDate"))
				}


				if isCapturing(lhsMaxdate) || isCapturing(rhsMaxdate) {
					comparison = Parameter.compare(lhs: lhsMaxdate, rhs: rhsMaxdate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxdate, rhsMaxdate, "to maxDate"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getAllActivitiesForToday__activityDefinition(let lhsActivitydefinition), .m_getAllActivitiesForToday__activityDefinition(let rhsActivitydefinition)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsActivitydefinition) && !isCapturing(rhsActivitydefinition) {
					comparison = Parameter.compare(lhs: lhsActivitydefinition, rhs: rhsActivitydefinition, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivitydefinition, rhsActivitydefinition, "_ activityDefinition"))
				}

				if isCapturing(lhsActivitydefinition) || isCapturing(rhsActivitydefinition) {
					comparison = Parameter.compare(lhs: lhsActivitydefinition, rhs: rhsActivitydefinition, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivitydefinition, rhsActivitydefinition, "_ activityDefinition"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getMostRecentActivityEndDate, .m_getMostRecentActivityEndDate): return .match

            case (.m_getMostRecentlyStartedActivity__for_activityDefinition(let lhsActivitydefinition), .m_getMostRecentlyStartedActivity__for_activityDefinition(let rhsActivitydefinition)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsActivitydefinition) && !isCapturing(rhsActivitydefinition) {
					comparison = Parameter.compare(lhs: lhsActivitydefinition, rhs: rhsActivitydefinition, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivitydefinition, rhsActivitydefinition, "for activityDefinition"))
				}

				if isCapturing(lhsActivitydefinition) || isCapturing(rhsActivitydefinition) {
					comparison = Parameter.compare(lhs: lhsActivitydefinition, rhs: rhsActivitydefinition, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivitydefinition, rhsActivitydefinition, "for activityDefinition"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(let lhsActivitydefinition), .m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(let rhsActivitydefinition)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsActivitydefinition) && !isCapturing(rhsActivitydefinition) {
					comparison = Parameter.compare(lhs: lhsActivitydefinition, rhs: rhsActivitydefinition, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivitydefinition, rhsActivitydefinition, "for activityDefinition"))
				}

				if isCapturing(lhsActivitydefinition) || isCapturing(rhsActivitydefinition) {
					comparison = Parameter.compare(lhs: lhsActivitydefinition, rhs: rhsActivitydefinition, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivitydefinition, rhsActivitydefinition, "for activityDefinition"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getDefinitionWith__name_name(let lhsName), .m_getDefinitionWith__name_name(let rhsName)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_activityDefinitionWithNameExists__name(let lhsName), .m_activityDefinitionWithNameExists__name(let rhsName)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "_ name"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "_ name"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_hasUnfinishedActivity__activityDefinition(let lhsActivitydefinition), .m_hasUnfinishedActivity__activityDefinition(let rhsActivitydefinition)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsActivitydefinition) && !isCapturing(rhsActivitydefinition) {
					comparison = Parameter.compare(lhs: lhsActivitydefinition, rhs: rhsActivitydefinition, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivitydefinition, rhsActivitydefinition, "_ activityDefinition"))
				}

				if isCapturing(lhsActivitydefinition) || isCapturing(rhsActivitydefinition) {
					comparison = Parameter.compare(lhs: lhsActivitydefinition, rhs: rhsActivitydefinition, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivitydefinition, rhsActivitydefinition, "_ activityDefinition"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_startActivity__definitionwithNote_note(let lhsDefinition, let lhsNote), .m_startActivity__definitionwithNote_note(let rhsDefinition, let rhsNote)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDefinition) && !isCapturing(rhsDefinition) {
					comparison = Parameter.compare(lhs: lhsDefinition, rhs: rhsDefinition, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDefinition, rhsDefinition, "_ definition"))
				}


				if !isCapturing(lhsNote) && !isCapturing(rhsNote) {
					comparison = Parameter.compare(lhs: lhsNote, rhs: rhsNote, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNote, rhsNote, "withNote note"))
				}

				if isCapturing(lhsDefinition) || isCapturing(rhsDefinition) {
					comparison = Parameter.compare(lhs: lhsDefinition, rhs: rhsDefinition, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDefinition, rhsDefinition, "_ definition"))
				}


				if isCapturing(lhsNote) || isCapturing(rhsNote) {
					comparison = Parameter.compare(lhs: lhsNote, rhs: rhsNote, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNote, rhsNote, "withNote note"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(let lhsActivitydefinition), .m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(let rhsActivitydefinition)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsActivitydefinition) && !isCapturing(rhsActivitydefinition) {
					comparison = Parameter.compare(lhs: lhsActivitydefinition, rhs: rhsActivitydefinition, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivitydefinition, rhsActivitydefinition, "for activityDefinition"))
				}

				if isCapturing(lhsActivitydefinition) || isCapturing(rhsActivitydefinition) {
					comparison = Parameter.compare(lhs: lhsActivitydefinition, rhs: rhsActivitydefinition, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivitydefinition, rhsActivitydefinition, "for activityDefinition"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_stopMostRecentlyStartedIncompleteActivity, .m_stopMostRecentlyStartedIncompleteActivity): return .match

            case (.m_stopAllActivities, .m_stopAllActivities): return .match

            case (.m_autoIgnoreIfAppropriate__activityend_end(let lhsActivity, let lhsEnd), .m_autoIgnoreIfAppropriate__activityend_end(let rhsActivity, let rhsEnd)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsActivity) && !isCapturing(rhsActivity) {
					comparison = Parameter.compare(lhs: lhsActivity, rhs: rhsActivity, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivity, rhsActivity, "_ activity"))
				}


				if !isCapturing(lhsEnd) && !isCapturing(rhsEnd) {
					comparison = Parameter.compare(lhs: lhsEnd, rhs: rhsEnd, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnd, rhsEnd, "end"))
				}

				if isCapturing(lhsActivity) || isCapturing(rhsActivity) {
					comparison = Parameter.compare(lhs: lhsActivity, rhs: rhsActivity, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsActivity, rhsActivity, "_ activity"))
				}


				if isCapturing(lhsEnd) || isCapturing(rhsEnd) {
					comparison = Parameter.compare(lhs: lhsEnd, rhs: rhsEnd, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnd, rhsEnd, "end"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(let lhsName, let lhsDescription, let lhsSource, let lhsRecordscreenindex, let lhsAutonote, let lhsTransaction), .m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(let rhsName, let rhsDescription, let rhsSource, let rhsRecordscreenindex, let rhsAutonote, let rhsTransaction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}


				if !isCapturing(lhsDescription) && !isCapturing(rhsDescription) {
					comparison = Parameter.compare(lhs: lhsDescription, rhs: rhsDescription, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDescription, rhsDescription, "description"))
				}


				if !isCapturing(lhsSource) && !isCapturing(rhsSource) {
					comparison = Parameter.compare(lhs: lhsSource, rhs: rhsSource, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSource, rhsSource, "source"))
				}


				if !isCapturing(lhsRecordscreenindex) && !isCapturing(rhsRecordscreenindex) {
					comparison = Parameter.compare(lhs: lhsRecordscreenindex, rhs: rhsRecordscreenindex, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRecordscreenindex, rhsRecordscreenindex, "recordScreenIndex"))
				}


				if !isCapturing(lhsAutonote) && !isCapturing(rhsAutonote) {
					comparison = Parameter.compare(lhs: lhsAutonote, rhs: rhsAutonote, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAutonote, rhsAutonote, "autoNote"))
				}


				if !isCapturing(lhsTransaction) && !isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}


				if isCapturing(lhsDescription) || isCapturing(rhsDescription) {
					comparison = Parameter.compare(lhs: lhsDescription, rhs: rhsDescription, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDescription, rhsDescription, "description"))
				}


				if isCapturing(lhsSource) || isCapturing(rhsSource) {
					comparison = Parameter.compare(lhs: lhsSource, rhs: rhsSource, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSource, rhsSource, "source"))
				}


				if isCapturing(lhsRecordscreenindex) || isCapturing(rhsRecordscreenindex) {
					comparison = Parameter.compare(lhs: lhsRecordscreenindex, rhs: rhsRecordscreenindex, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRecordscreenindex, rhsRecordscreenindex, "recordScreenIndex"))
				}


				if isCapturing(lhsAutonote) || isCapturing(rhsAutonote) {
					comparison = Parameter.compare(lhs: lhsAutonote, rhs: rhsAutonote, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAutonote, rhsAutonote, "autoNote"))
				}


				if isCapturing(lhsTransaction) || isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(let lhsDefinition, let lhsStartdate, let lhsSource, let lhsEnddate, let lhsNote, let lhsExtratags, let lhsTransaction), .m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(let rhsDefinition, let rhsStartdate, let rhsSource, let rhsEnddate, let rhsNote, let rhsExtratags, let rhsTransaction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDefinition) && !isCapturing(rhsDefinition) {
					comparison = Parameter.compare(lhs: lhsDefinition, rhs: rhsDefinition, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDefinition, rhsDefinition, "definition"))
				}


				if !isCapturing(lhsStartdate) && !isCapturing(rhsStartdate) {
					comparison = Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartdate, rhsStartdate, "startDate"))
				}


				if !isCapturing(lhsSource) && !isCapturing(rhsSource) {
					comparison = Parameter.compare(lhs: lhsSource, rhs: rhsSource, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSource, rhsSource, "source"))
				}


				if !isCapturing(lhsEnddate) && !isCapturing(rhsEnddate) {
					comparison = Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnddate, rhsEnddate, "endDate"))
				}


				if !isCapturing(lhsNote) && !isCapturing(rhsNote) {
					comparison = Parameter.compare(lhs: lhsNote, rhs: rhsNote, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNote, rhsNote, "note"))
				}


				if !isCapturing(lhsExtratags) && !isCapturing(rhsExtratags) {
					comparison = Parameter.compare(lhs: lhsExtratags, rhs: rhsExtratags, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsExtratags, rhsExtratags, "extraTags"))
				}


				if !isCapturing(lhsTransaction) && !isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				if isCapturing(lhsDefinition) || isCapturing(rhsDefinition) {
					comparison = Parameter.compare(lhs: lhsDefinition, rhs: rhsDefinition, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDefinition, rhsDefinition, "definition"))
				}


				if isCapturing(lhsStartdate) || isCapturing(rhsStartdate) {
					comparison = Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartdate, rhsStartdate, "startDate"))
				}


				if isCapturing(lhsSource) || isCapturing(rhsSource) {
					comparison = Parameter.compare(lhs: lhsSource, rhs: rhsSource, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSource, rhsSource, "source"))
				}


				if isCapturing(lhsEnddate) || isCapturing(rhsEnddate) {
					comparison = Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnddate, rhsEnddate, "endDate"))
				}


				if isCapturing(lhsNote) || isCapturing(rhsNote) {
					comparison = Parameter.compare(lhs: lhsNote, rhs: rhsNote, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNote, rhsNote, "note"))
				}


				if isCapturing(lhsExtratags) || isCapturing(rhsExtratags) {
					comparison = Parameter.compare(lhs: lhsExtratags, rhs: rhsExtratags, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsExtratags, rhsExtratags, "extraTags"))
				}


				if isCapturing(lhsTransaction) || isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getActivities__from_minDateto_maxDate(p0, p1): return p0.intValue + p1.intValue
            case let .m_getAllActivitiesForToday__activityDefinition(p0): return p0.intValue
            case .m_getMostRecentActivityEndDate: return 0
            case let .m_getMostRecentlyStartedActivity__for_activityDefinition(p0): return p0.intValue
            case let .m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(p0): return p0.intValue
            case let .m_getDefinitionWith__name_name(p0): return p0.intValue
            case let .m_activityDefinitionWithNameExists__name(p0): return p0.intValue
            case let .m_hasUnfinishedActivity__activityDefinition(p0): return p0.intValue
            case let .m_startActivity__definitionwithNote_note(p0, p1): return p0.intValue + p1.intValue
            case let .m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(p0): return p0.intValue
            case .m_stopMostRecentlyStartedIncompleteActivity: return 0
            case .m_stopAllActivities: return 0
            case let .m_autoIgnoreIfAppropriate__activityend_end(p0, p1): return p0.intValue + p1.intValue
            case let .m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(p0, p1, p2, p3, p4, p5, p6): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getActivities__from_minDateto_maxDate: return ".getActivities(from:to:)"
            case .m_getAllActivitiesForToday__activityDefinition: return ".getAllActivitiesForToday(_:)"
            case .m_getMostRecentActivityEndDate: return ".getMostRecentActivityEndDate()"
            case .m_getMostRecentlyStartedActivity__for_activityDefinition: return ".getMostRecentlyStartedActivity(for:)"
            case .m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition: return ".getMostRecentlyStartedIncompleteActivity(for:)"
            case .m_getDefinitionWith__name_name: return ".getDefinitionWith(name:)"
            case .m_activityDefinitionWithNameExists__name: return ".activityDefinitionWithNameExists(_:)"
            case .m_hasUnfinishedActivity__activityDefinition: return ".hasUnfinishedActivity(_:)"
            case .m_startActivity__definitionwithNote_note: return ".startActivity(_:withNote:)"
            case .m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition: return ".stopMostRecentlyStartedIncompleteActivity(for:)"
            case .m_stopMostRecentlyStartedIncompleteActivity: return ".stopMostRecentlyStartedIncompleteActivity()"
            case .m_stopAllActivities: return ".stopAllActivities()"
            case .m_autoIgnoreIfAppropriate__activityend_end: return ".autoIgnoreIfAppropriate(_:end:)"
            case .m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction: return ".createDefinition(name:description:source:recordScreenIndex:autoNote:using:)"
            case .m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction: return ".createActivity(definition:startDate:source:endDate:note:extraTags:using:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getActivities(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willReturn: [Activity]...) -> MethodStub {
            return Given(method: .m_getActivities__from_minDateto_maxDate(`minDate`, `maxDate`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getAllActivitiesForToday(_ activityDefinition: Parameter<ActivityDefinition>, willReturn: [Activity]...) -> MethodStub {
            return Given(method: .m_getAllActivitiesForToday__activityDefinition(`activityDefinition`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getMostRecentActivityEndDate(willReturn: Date?...) -> MethodStub {
            return Given(method: .m_getMostRecentActivityEndDate, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getMostRecentlyStartedActivity(for activityDefinition: Parameter<ActivityDefinition>, willReturn: Activity?...) -> MethodStub {
            return Given(method: .m_getMostRecentlyStartedActivity__for_activityDefinition(`activityDefinition`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getMostRecentlyStartedIncompleteActivity(for activityDefinition: Parameter<ActivityDefinition>, willReturn: Activity?...) -> MethodStub {
            return Given(method: .m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(`activityDefinition`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getDefinitionWith(name: Parameter<String>, willReturn: ActivityDefinition?...) -> MethodStub {
            return Given(method: .m_getDefinitionWith__name_name(`name`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func activityDefinitionWithNameExists(_ name: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_activityDefinitionWithNameExists__name(`name`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func hasUnfinishedActivity(_ activityDefinition: Parameter<ActivityDefinition>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_hasUnfinishedActivity__activityDefinition(`activityDefinition`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        @discardableResult
		public static func startActivity(_ definition: Parameter<ActivityDefinition>, withNote note: Parameter<String?>, willReturn: Activity...) -> MethodStub {
            return Given(method: .m_startActivity__definitionwithNote_note(`definition`, `note`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        @discardableResult
		public static func stopMostRecentlyStartedIncompleteActivity(for activityDefinition: Parameter<ActivityDefinition>, willReturn: Activity...) -> MethodStub {
            return Given(method: .m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(`activityDefinition`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        @discardableResult
		public static func stopMostRecentlyStartedIncompleteActivity(willReturn: Activity...) -> MethodStub {
            return Given(method: .m_stopMostRecentlyStartedIncompleteActivity, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        @discardableResult
		public static func stopAllActivities(willReturn: [Activity]...) -> MethodStub {
            return Given(method: .m_stopAllActivities, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func autoIgnoreIfAppropriate(_ activity: Parameter<Activity>, end: Parameter<Date>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_autoIgnoreIfAppropriate__activityend_end(`activity`, `end`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        @discardableResult
		public static func createDefinition(name: Parameter<String>, description: Parameter<String?>, source: Parameter<Sources.ActivitySourceNum>, recordScreenIndex: Parameter<Int16?>, autoNote: Parameter<Bool?>, using transaction: Parameter<Transaction?>, willReturn: ActivityDefinition...) -> MethodStub {
            return Given(method: .m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(`name`, `description`, `source`, `recordScreenIndex`, `autoNote`, `transaction`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        @discardableResult
		public static func createActivity(definition: Parameter<ActivityDefinition>, startDate: Parameter<Date>, source: Parameter<Sources.ActivitySourceNum>, endDate: Parameter<Date?>, note: Parameter<String?>, extraTags: Parameter<[Tag]>, using transaction: Parameter<Transaction?>, willReturn: Activity...) -> MethodStub {
            return Given(method: .m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(`definition`, `startDate`, `source`, `endDate`, `note`, `extraTags`, `transaction`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func autoIgnoreIfAppropriate(_ activity: Parameter<Activity>, end: Parameter<Date>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_autoIgnoreIfAppropriate__activityend_end(`activity`, `end`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func getActivities(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getActivities__from_minDateto_maxDate(`minDate`, `maxDate`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getActivities(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willProduce: (StubberThrows<[Activity]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getActivities__from_minDateto_maxDate(`minDate`, `maxDate`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Activity]).self)
			willProduce(stubber)
			return given
        }
        public static func getAllActivitiesForToday(_ activityDefinition: Parameter<ActivityDefinition>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getAllActivitiesForToday__activityDefinition(`activityDefinition`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getAllActivitiesForToday(_ activityDefinition: Parameter<ActivityDefinition>, willProduce: (StubberThrows<[Activity]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getAllActivitiesForToday__activityDefinition(`activityDefinition`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Activity]).self)
			willProduce(stubber)
			return given
        }
        public static func getMostRecentActivityEndDate(willThrow: Error...) -> MethodStub {
            return Given(method: .m_getMostRecentActivityEndDate, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getMostRecentActivityEndDate(willProduce: (StubberThrows<Date?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getMostRecentActivityEndDate, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Date?).self)
			willProduce(stubber)
			return given
        }
        public static func getMostRecentlyStartedActivity(for activityDefinition: Parameter<ActivityDefinition>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getMostRecentlyStartedActivity__for_activityDefinition(`activityDefinition`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getMostRecentlyStartedActivity(for activityDefinition: Parameter<ActivityDefinition>, willProduce: (StubberThrows<Activity?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getMostRecentlyStartedActivity__for_activityDefinition(`activityDefinition`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Activity?).self)
			willProduce(stubber)
			return given
        }
        public static func getMostRecentlyStartedIncompleteActivity(for activityDefinition: Parameter<ActivityDefinition>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(`activityDefinition`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getMostRecentlyStartedIncompleteActivity(for activityDefinition: Parameter<ActivityDefinition>, willProduce: (StubberThrows<Activity?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(`activityDefinition`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Activity?).self)
			willProduce(stubber)
			return given
        }
        public static func getDefinitionWith(name: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getDefinitionWith__name_name(`name`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getDefinitionWith(name: Parameter<String>, willProduce: (StubberThrows<ActivityDefinition?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getDefinitionWith__name_name(`name`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ActivityDefinition?).self)
			willProduce(stubber)
			return given
        }
        public static func activityDefinitionWithNameExists(_ name: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_activityDefinitionWithNameExists__name(`name`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func activityDefinitionWithNameExists(_ name: Parameter<String>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_activityDefinitionWithNameExists__name(`name`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func hasUnfinishedActivity(_ activityDefinition: Parameter<ActivityDefinition>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_hasUnfinishedActivity__activityDefinition(`activityDefinition`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func hasUnfinishedActivity(_ activityDefinition: Parameter<ActivityDefinition>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_hasUnfinishedActivity__activityDefinition(`activityDefinition`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        @discardableResult
		public static func startActivity(_ definition: Parameter<ActivityDefinition>, withNote note: Parameter<String?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_startActivity__definitionwithNote_note(`definition`, `note`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func startActivity(_ definition: Parameter<ActivityDefinition>, withNote note: Parameter<String?>, willProduce: (StubberThrows<Activity>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_startActivity__definitionwithNote_note(`definition`, `note`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Activity).self)
			willProduce(stubber)
			return given
        }
        @discardableResult
		public static func stopMostRecentlyStartedIncompleteActivity(for activityDefinition: Parameter<ActivityDefinition>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(`activityDefinition`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func stopMostRecentlyStartedIncompleteActivity(for activityDefinition: Parameter<ActivityDefinition>, willProduce: (StubberThrows<Activity>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(`activityDefinition`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Activity).self)
			willProduce(stubber)
			return given
        }
        @discardableResult
		public static func stopMostRecentlyStartedIncompleteActivity(willThrow: Error...) -> MethodStub {
            return Given(method: .m_stopMostRecentlyStartedIncompleteActivity, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func stopMostRecentlyStartedIncompleteActivity(willProduce: (StubberThrows<Activity>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_stopMostRecentlyStartedIncompleteActivity, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Activity).self)
			willProduce(stubber)
			return given
        }
        @discardableResult
		public static func stopAllActivities(willThrow: Error...) -> MethodStub {
            return Given(method: .m_stopAllActivities, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func stopAllActivities(willProduce: (StubberThrows<[Activity]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_stopAllActivities, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Activity]).self)
			willProduce(stubber)
			return given
        }
        @discardableResult
		public static func createDefinition(name: Parameter<String>, description: Parameter<String?>, source: Parameter<Sources.ActivitySourceNum>, recordScreenIndex: Parameter<Int16?>, autoNote: Parameter<Bool?>, using transaction: Parameter<Transaction?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(`name`, `description`, `source`, `recordScreenIndex`, `autoNote`, `transaction`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func createDefinition(name: Parameter<String>, description: Parameter<String?>, source: Parameter<Sources.ActivitySourceNum>, recordScreenIndex: Parameter<Int16?>, autoNote: Parameter<Bool?>, using transaction: Parameter<Transaction?>, willProduce: (StubberThrows<ActivityDefinition>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(`name`, `description`, `source`, `recordScreenIndex`, `autoNote`, `transaction`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ActivityDefinition).self)
			willProduce(stubber)
			return given
        }
        @discardableResult
		public static func createActivity(definition: Parameter<ActivityDefinition>, startDate: Parameter<Date>, source: Parameter<Sources.ActivitySourceNum>, endDate: Parameter<Date?>, note: Parameter<String?>, extraTags: Parameter<[Tag]>, using transaction: Parameter<Transaction?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(`definition`, `startDate`, `source`, `endDate`, `note`, `extraTags`, `transaction`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func createActivity(definition: Parameter<ActivityDefinition>, startDate: Parameter<Date>, source: Parameter<Sources.ActivitySourceNum>, endDate: Parameter<Date?>, note: Parameter<String?>, extraTags: Parameter<[Tag]>, using transaction: Parameter<Transaction?>, willProduce: (StubberThrows<Activity>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(`definition`, `startDate`, `source`, `endDate`, `note`, `extraTags`, `transaction`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Activity).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getActivities(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>) -> Verify { return Verify(method: .m_getActivities__from_minDateto_maxDate(`minDate`, `maxDate`))}
        public static func getAllActivitiesForToday(_ activityDefinition: Parameter<ActivityDefinition>) -> Verify { return Verify(method: .m_getAllActivitiesForToday__activityDefinition(`activityDefinition`))}
        public static func getMostRecentActivityEndDate() -> Verify { return Verify(method: .m_getMostRecentActivityEndDate)}
        public static func getMostRecentlyStartedActivity(for activityDefinition: Parameter<ActivityDefinition>) -> Verify { return Verify(method: .m_getMostRecentlyStartedActivity__for_activityDefinition(`activityDefinition`))}
        public static func getMostRecentlyStartedIncompleteActivity(for activityDefinition: Parameter<ActivityDefinition>) -> Verify { return Verify(method: .m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(`activityDefinition`))}
        public static func getDefinitionWith(name: Parameter<String>) -> Verify { return Verify(method: .m_getDefinitionWith__name_name(`name`))}
        public static func activityDefinitionWithNameExists(_ name: Parameter<String>) -> Verify { return Verify(method: .m_activityDefinitionWithNameExists__name(`name`))}
        public static func hasUnfinishedActivity(_ activityDefinition: Parameter<ActivityDefinition>) -> Verify { return Verify(method: .m_hasUnfinishedActivity__activityDefinition(`activityDefinition`))}
        @discardableResult
		public static func startActivity(_ definition: Parameter<ActivityDefinition>, withNote note: Parameter<String?>) -> Verify { return Verify(method: .m_startActivity__definitionwithNote_note(`definition`, `note`))}
        @discardableResult
		public static func stopMostRecentlyStartedIncompleteActivity(for activityDefinition: Parameter<ActivityDefinition>) -> Verify { return Verify(method: .m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(`activityDefinition`))}
        @discardableResult
		public static func stopMostRecentlyStartedIncompleteActivity() -> Verify { return Verify(method: .m_stopMostRecentlyStartedIncompleteActivity)}
        @discardableResult
		public static func stopAllActivities() -> Verify { return Verify(method: .m_stopAllActivities)}
        public static func autoIgnoreIfAppropriate(_ activity: Parameter<Activity>, end: Parameter<Date>) -> Verify { return Verify(method: .m_autoIgnoreIfAppropriate__activityend_end(`activity`, `end`))}
        @discardableResult
		public static func createDefinition(name: Parameter<String>, description: Parameter<String?>, source: Parameter<Sources.ActivitySourceNum>, recordScreenIndex: Parameter<Int16?>, autoNote: Parameter<Bool?>, using transaction: Parameter<Transaction?>) -> Verify { return Verify(method: .m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(`name`, `description`, `source`, `recordScreenIndex`, `autoNote`, `transaction`))}
        @discardableResult
		public static func createActivity(definition: Parameter<ActivityDefinition>, startDate: Parameter<Date>, source: Parameter<Sources.ActivitySourceNum>, endDate: Parameter<Date?>, note: Parameter<String?>, extraTags: Parameter<[Tag]>, using transaction: Parameter<Transaction?>) -> Verify { return Verify(method: .m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(`definition`, `startDate`, `source`, `endDate`, `note`, `extraTags`, `transaction`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getActivities(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, perform: @escaping (Date?, Date?) -> Void) -> Perform {
            return Perform(method: .m_getActivities__from_minDateto_maxDate(`minDate`, `maxDate`), performs: perform)
        }
        public static func getAllActivitiesForToday(_ activityDefinition: Parameter<ActivityDefinition>, perform: @escaping (ActivityDefinition) -> Void) -> Perform {
            return Perform(method: .m_getAllActivitiesForToday__activityDefinition(`activityDefinition`), performs: perform)
        }
        public static func getMostRecentActivityEndDate(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getMostRecentActivityEndDate, performs: perform)
        }
        public static func getMostRecentlyStartedActivity(for activityDefinition: Parameter<ActivityDefinition>, perform: @escaping (ActivityDefinition) -> Void) -> Perform {
            return Perform(method: .m_getMostRecentlyStartedActivity__for_activityDefinition(`activityDefinition`), performs: perform)
        }
        public static func getMostRecentlyStartedIncompleteActivity(for activityDefinition: Parameter<ActivityDefinition>, perform: @escaping (ActivityDefinition) -> Void) -> Perform {
            return Perform(method: .m_getMostRecentlyStartedIncompleteActivity__for_activityDefinition(`activityDefinition`), performs: perform)
        }
        public static func getDefinitionWith(name: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getDefinitionWith__name_name(`name`), performs: perform)
        }
        public static func activityDefinitionWithNameExists(_ name: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_activityDefinitionWithNameExists__name(`name`), performs: perform)
        }
        public static func hasUnfinishedActivity(_ activityDefinition: Parameter<ActivityDefinition>, perform: @escaping (ActivityDefinition) -> Void) -> Perform {
            return Perform(method: .m_hasUnfinishedActivity__activityDefinition(`activityDefinition`), performs: perform)
        }
        @discardableResult
		public static func startActivity(_ definition: Parameter<ActivityDefinition>, withNote note: Parameter<String?>, perform: @escaping (ActivityDefinition, String?) -> Void) -> Perform {
            return Perform(method: .m_startActivity__definitionwithNote_note(`definition`, `note`), performs: perform)
        }
        @discardableResult
		public static func stopMostRecentlyStartedIncompleteActivity(for activityDefinition: Parameter<ActivityDefinition>, perform: @escaping (ActivityDefinition) -> Void) -> Perform {
            return Perform(method: .m_stopMostRecentlyStartedIncompleteActivity__for_activityDefinition(`activityDefinition`), performs: perform)
        }
        @discardableResult
		public static func stopMostRecentlyStartedIncompleteActivity(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stopMostRecentlyStartedIncompleteActivity, performs: perform)
        }
        @discardableResult
		public static func stopAllActivities(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_stopAllActivities, performs: perform)
        }
        public static func autoIgnoreIfAppropriate(_ activity: Parameter<Activity>, end: Parameter<Date>, perform: @escaping (Activity, Date) -> Void) -> Perform {
            return Perform(method: .m_autoIgnoreIfAppropriate__activityend_end(`activity`, `end`), performs: perform)
        }
        @discardableResult
		public static func createDefinition(name: Parameter<String>, description: Parameter<String?>, source: Parameter<Sources.ActivitySourceNum>, recordScreenIndex: Parameter<Int16?>, autoNote: Parameter<Bool?>, using transaction: Parameter<Transaction?>, perform: @escaping (String, String?, Sources.ActivitySourceNum, Int16?, Bool?, Transaction?) -> Void) -> Perform {
            return Perform(method: .m_createDefinition__name_namedescription_descriptionsource_sourcerecordScreenIndex_recordScreenIndexautoNote_autoNoteusing_transaction(`name`, `description`, `source`, `recordScreenIndex`, `autoNote`, `transaction`), performs: perform)
        }
        @discardableResult
		public static func createActivity(definition: Parameter<ActivityDefinition>, startDate: Parameter<Date>, source: Parameter<Sources.ActivitySourceNum>, endDate: Parameter<Date?>, note: Parameter<String?>, extraTags: Parameter<[Tag]>, using transaction: Parameter<Transaction?>, perform: @escaping (ActivityDefinition, Date, Sources.ActivitySourceNum, Date?, String?, [Tag], Transaction?) -> Void) -> Perform {
            return Perform(method: .m_createActivity__definition_definitionstartDate_startDatesource_sourceendDate_endDatenote_noteextraTags_extraTagsusing_transaction(`definition`, `startDate`, `source`, `endDate`, `note`, `extraTags`, `transaction`), performs: perform)
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

// MARK: - ActivityExporter

open class ActivityExporterMock: ActivityExporter, Mock {
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








    fileprivate struct MethodType {
        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult { return .match }
        func intValue() -> Int { return 0 }
        func assertionName() -> String { return "" }
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

// MARK: - FatigueDAO

open class FatigueDAOMock: FatigueDAO, Mock {
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






    open func getFatigueRecords(from minDate: Date?, to maxDate: Date?) throws -> [Fatigue] {
        addInvocation(.m_getFatigueRecords__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`)))
		let perform = methodPerformValue(.m_getFatigueRecords__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`))) as? (Date?, Date?) -> Void
		perform?(`minDate`, `maxDate`)
		var __value: [Fatigue]
		do {
		    __value = try methodReturnValue(.m_getFatigueRecords__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getFatigueRecords(from minDate: Date?, to maxDate: Date?). Use given")
			Failure("Stub return value not specified for getFatigueRecords(from minDate: Date?, to maxDate: Date?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func createFatigue(timestamp: Date, rating: Double, min: Double?, max: Double?, note: String?) throws -> Fatigue {
        addInvocation(.m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(Parameter<Date>.value(`timestamp`), Parameter<Double>.value(`rating`), Parameter<Double?>.value(`min`), Parameter<Double?>.value(`max`), Parameter<String?>.value(`note`)))
		let perform = methodPerformValue(.m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(Parameter<Date>.value(`timestamp`), Parameter<Double>.value(`rating`), Parameter<Double?>.value(`min`), Parameter<Double?>.value(`max`), Parameter<String?>.value(`note`))) as? (Date, Double, Double?, Double?, String?) -> Void
		perform?(`timestamp`, `rating`, `min`, `max`, `note`)
		var __value: Fatigue
		do {
		    __value = try methodReturnValue(.m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(Parameter<Date>.value(`timestamp`), Parameter<Double>.value(`rating`), Parameter<Double?>.value(`min`), Parameter<Double?>.value(`max`), Parameter<String?>.value(`note`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for createFatigue(timestamp: Date, rating: Double, min: Double?, max: Double?, note: String?). Use given")
			Failure("Stub return value not specified for createFatigue(timestamp: Date, rating: Double, min: Double?, max: Double?, note: String?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getMostRecentFatigue() throws -> Fatigue? {
        addInvocation(.m_getMostRecentFatigue)
		let perform = methodPerformValue(.m_getMostRecentFatigue) as? () -> Void
		perform?()
		var __value: Fatigue? = nil
		do {
		    __value = try methodReturnValue(.m_getMostRecentFatigue).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getFatigueRecords__from_minDateto_maxDate(Parameter<Date?>, Parameter<Date?>)
        case m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(Parameter<Date>, Parameter<Double>, Parameter<Double?>, Parameter<Double?>, Parameter<String?>)
        case m_getMostRecentFatigue

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getFatigueRecords__from_minDateto_maxDate(let lhsMindate, let lhsMaxdate), .m_getFatigueRecords__from_minDateto_maxDate(let rhsMindate, let rhsMaxdate)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsMindate) && !isCapturing(rhsMindate) {
					comparison = Parameter.compare(lhs: lhsMindate, rhs: rhsMindate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMindate, rhsMindate, "from minDate"))
				}


				if !isCapturing(lhsMaxdate) && !isCapturing(rhsMaxdate) {
					comparison = Parameter.compare(lhs: lhsMaxdate, rhs: rhsMaxdate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxdate, rhsMaxdate, "to maxDate"))
				}

				if isCapturing(lhsMindate) || isCapturing(rhsMindate) {
					comparison = Parameter.compare(lhs: lhsMindate, rhs: rhsMindate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMindate, rhsMindate, "from minDate"))
				}


				if isCapturing(lhsMaxdate) || isCapturing(rhsMaxdate) {
					comparison = Parameter.compare(lhs: lhsMaxdate, rhs: rhsMaxdate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxdate, rhsMaxdate, "to maxDate"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(let lhsTimestamp, let lhsRating, let lhsMin, let lhsMax, let lhsNote), .m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(let rhsTimestamp, let rhsRating, let rhsMin, let rhsMax, let rhsNote)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTimestamp) && !isCapturing(rhsTimestamp) {
					comparison = Parameter.compare(lhs: lhsTimestamp, rhs: rhsTimestamp, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimestamp, rhsTimestamp, "timestamp"))
				}


				if !isCapturing(lhsRating) && !isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "rating"))
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


				if !isCapturing(lhsNote) && !isCapturing(rhsNote) {
					comparison = Parameter.compare(lhs: lhsNote, rhs: rhsNote, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNote, rhsNote, "note"))
				}

				if isCapturing(lhsTimestamp) || isCapturing(rhsTimestamp) {
					comparison = Parameter.compare(lhs: lhsTimestamp, rhs: rhsTimestamp, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimestamp, rhsTimestamp, "timestamp"))
				}


				if isCapturing(lhsRating) || isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "rating"))
				}


				if isCapturing(lhsMin) || isCapturing(rhsMin) {
					comparison = Parameter.compare(lhs: lhsMin, rhs: rhsMin, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMin, rhsMin, "min"))
				}


				if isCapturing(lhsMax) || isCapturing(rhsMax) {
					comparison = Parameter.compare(lhs: lhsMax, rhs: rhsMax, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMax, rhsMax, "max"))
				}


				if isCapturing(lhsNote) || isCapturing(rhsNote) {
					comparison = Parameter.compare(lhs: lhsNote, rhs: rhsNote, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNote, rhsNote, "note"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getMostRecentFatigue, .m_getMostRecentFatigue): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getFatigueRecords__from_minDateto_maxDate(p0, p1): return p0.intValue + p1.intValue
            case let .m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case .m_getMostRecentFatigue: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getFatigueRecords__from_minDateto_maxDate: return ".getFatigueRecords(from:to:)"
            case .m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note: return ".createFatigue(timestamp:rating:min:max:note:)"
            case .m_getMostRecentFatigue: return ".getMostRecentFatigue()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getFatigueRecords(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willReturn: [Fatigue]...) -> MethodStub {
            return Given(method: .m_getFatigueRecords__from_minDateto_maxDate(`minDate`, `maxDate`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func createFatigue(timestamp: Parameter<Date>, rating: Parameter<Double>, min: Parameter<Double?>, max: Parameter<Double?>, note: Parameter<String?>, willReturn: Fatigue...) -> MethodStub {
            return Given(method: .m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(`timestamp`, `rating`, `min`, `max`, `note`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getMostRecentFatigue(willReturn: Fatigue?...) -> MethodStub {
            return Given(method: .m_getMostRecentFatigue, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getFatigueRecords(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getFatigueRecords__from_minDateto_maxDate(`minDate`, `maxDate`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getFatigueRecords(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willProduce: (StubberThrows<[Fatigue]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getFatigueRecords__from_minDateto_maxDate(`minDate`, `maxDate`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Fatigue]).self)
			willProduce(stubber)
			return given
        }
        public static func createFatigue(timestamp: Parameter<Date>, rating: Parameter<Double>, min: Parameter<Double?>, max: Parameter<Double?>, note: Parameter<String?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(`timestamp`, `rating`, `min`, `max`, `note`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func createFatigue(timestamp: Parameter<Date>, rating: Parameter<Double>, min: Parameter<Double?>, max: Parameter<Double?>, note: Parameter<String?>, willProduce: (StubberThrows<Fatigue>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(`timestamp`, `rating`, `min`, `max`, `note`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Fatigue).self)
			willProduce(stubber)
			return given
        }
        public static func getMostRecentFatigue(willThrow: Error...) -> MethodStub {
            return Given(method: .m_getMostRecentFatigue, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getMostRecentFatigue(willProduce: (StubberThrows<Fatigue?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getMostRecentFatigue, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Fatigue?).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getFatigueRecords(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>) -> Verify { return Verify(method: .m_getFatigueRecords__from_minDateto_maxDate(`minDate`, `maxDate`))}
        public static func createFatigue(timestamp: Parameter<Date>, rating: Parameter<Double>, min: Parameter<Double?>, max: Parameter<Double?>, note: Parameter<String?>) -> Verify { return Verify(method: .m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(`timestamp`, `rating`, `min`, `max`, `note`))}
        public static func getMostRecentFatigue() -> Verify { return Verify(method: .m_getMostRecentFatigue)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getFatigueRecords(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, perform: @escaping (Date?, Date?) -> Void) -> Perform {
            return Perform(method: .m_getFatigueRecords__from_minDateto_maxDate(`minDate`, `maxDate`), performs: perform)
        }
        public static func createFatigue(timestamp: Parameter<Date>, rating: Parameter<Double>, min: Parameter<Double?>, max: Parameter<Double?>, note: Parameter<String?>, perform: @escaping (Date, Double, Double?, Double?, String?) -> Void) -> Perform {
            return Perform(method: .m_createFatigue__timestamp_timestamprating_ratingmin_minmax_maxnote_note(`timestamp`, `rating`, `min`, `max`, `note`), performs: perform)
        }
        public static func getMostRecentFatigue(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getMostRecentFatigue, performs: perform)
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

// MARK: - HealthKitUtil

open class HealthKitUtilMock: HealthKitUtil, Mock {
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






    open func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {
        addInvocation(.m_setTimeZoneIfApplicable__for_datefrom_sample(Parameter<Date>.value(`date`), Parameter<HKSample>.value(`sample`)))
		let perform = methodPerformValue(.m_setTimeZoneIfApplicable__for_datefrom_sample(Parameter<Date>.value(`date`), Parameter<HKSample>.value(`sample`))) as? (inout Date, HKSample) -> Void
		perform?(&`date`, `sample`)
    }

    open func calculate(		_ calculation: HKStatisticsOptions,		_ type: HealthKitQuantitySample.Type,		from startDate: Date,		to endDate: Date,		callback: @escaping (Double?, Error?) -> Void	) {
        addInvocation(.m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(Parameter<HKStatisticsOptions>.value(`calculation`), Parameter<HealthKitQuantitySample.Type>.value(`type`), Parameter<Date>.value(`startDate`), Parameter<Date>.value(`endDate`), Parameter<(Double?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(Parameter<HKStatisticsOptions>.value(`calculation`), Parameter<HealthKitQuantitySample.Type>.value(`type`), Parameter<Date>.value(`startDate`), Parameter<Date>.value(`endDate`), Parameter<(Double?, Error?) -> Void>.value(`callback`))) as? (HKStatisticsOptions, HealthKitQuantitySample.Type, Date, Date, @escaping (Double?, Error?) -> Void) -> Void
		perform?(`calculation`, `type`, `startDate`, `endDate`, `callback`)
    }

    open func getSamples(		for type: HealthKitSample.Type,		from startDate: Date?,		to endDate: Date?,		predicate: NSPredicate?,		callback: @escaping ([HKSample]?, Error?) -> Void	) -> (() -> Void) {
        addInvocation(.m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(Parameter<HealthKitSample.Type>.value(`type`), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`), Parameter<NSPredicate?>.value(`predicate`), Parameter<([HKSample]?, Error?) -> Void>.value(`callback`)))
		let perform = methodPerformValue(.m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(Parameter<HealthKitSample.Type>.value(`type`), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`), Parameter<NSPredicate?>.value(`predicate`), Parameter<([HKSample]?, Error?) -> Void>.value(`callback`))) as? (HealthKitSample.Type, Date?, Date?, NSPredicate?, @escaping ([HKSample]?, Error?) -> Void) -> Void
		perform?(`type`, `startDate`, `endDate`, `predicate`, `callback`)
		var __value: () -> Void
		do {
		    __value = try methodReturnValue(.m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(Parameter<HealthKitSample.Type>.value(`type`), Parameter<Date?>.value(`startDate`), Parameter<Date?>.value(`endDate`), Parameter<NSPredicate?>.value(`predicate`), Parameter<([HKSample]?, Error?) -> Void>.value(`callback`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getSamples(  for type: HealthKitSample.Type,  from startDate: Date?,  to endDate: Date?,  predicate: NSPredicate?,  callback: @escaping ([HKSample]?, Error?) -> Void ). Use given")
			Failure("Stub return value not specified for getSamples(  for type: HealthKitSample.Type,  from startDate: Date?,  to endDate: Date?,  predicate: NSPredicate?,  callback: @escaping ([HKSample]?, Error?) -> Void ). Use given")
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
        case m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(Parameter<HealthKitSample.Type>, Parameter<Date?>, Parameter<Date?>, Parameter<NSPredicate?>, Parameter<([HKSample]?, Error?) -> Void>)
        case m_preferredUnitFor__typeId(Parameter<HKQuantityTypeIdentifier>)
        case m_getAuthorization__callback_callback(Parameter<(Error?) -> Void>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_setTimeZoneIfApplicable__for_datefrom_sample(let lhsDate, let lhsSample), .m_setTimeZoneIfApplicable__for_datefrom_sample(let rhsDate, let rhsSample)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDate) && !isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "for date"))
				}


				if !isCapturing(lhsSample) && !isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "from sample"))
				}

				if isCapturing(lhsDate) || isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "for date"))
				}


				if isCapturing(lhsSample) || isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "from sample"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(let lhsCalculation, let lhsType, let lhsStartdate, let lhsEnddate, let lhsCallback), .m_calculate__calculation_typefrom_startDateto_endDatecallback_callback(let rhsCalculation, let rhsType, let rhsStartdate, let rhsEnddate, let rhsCallback)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsCalculation) && !isCapturing(rhsCalculation) {
					comparison = Parameter.compare(lhs: lhsCalculation, rhs: rhsCalculation, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCalculation, rhsCalculation, "_ calculation"))
				}


				if !isCapturing(lhsType) && !isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "_ type"))
				}


				if !isCapturing(lhsStartdate) && !isCapturing(rhsStartdate) {
					comparison = Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartdate, rhsStartdate, "from startDate"))
				}


				if !isCapturing(lhsEnddate) && !isCapturing(rhsEnddate) {
					comparison = Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnddate, rhsEnddate, "to endDate"))
				}


				if !isCapturing(lhsCallback) && !isCapturing(rhsCallback) {
					comparison = Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCallback, rhsCallback, "callback"))
				}

				if isCapturing(lhsCalculation) || isCapturing(rhsCalculation) {
					comparison = Parameter.compare(lhs: lhsCalculation, rhs: rhsCalculation, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCalculation, rhsCalculation, "_ calculation"))
				}


				if isCapturing(lhsType) || isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "_ type"))
				}


				if isCapturing(lhsStartdate) || isCapturing(rhsStartdate) {
					comparison = Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartdate, rhsStartdate, "from startDate"))
				}


				if isCapturing(lhsEnddate) || isCapturing(rhsEnddate) {
					comparison = Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnddate, rhsEnddate, "to endDate"))
				}


				if isCapturing(lhsCallback) || isCapturing(rhsCallback) {
					comparison = Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCallback, rhsCallback, "callback"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(let lhsType, let lhsStartdate, let lhsEnddate, let lhsPredicate, let lhsCallback), .m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(let rhsType, let rhsStartdate, let rhsEnddate, let rhsPredicate, let rhsCallback)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsType) && !isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "for type"))
				}


				if !isCapturing(lhsStartdate) && !isCapturing(rhsStartdate) {
					comparison = Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartdate, rhsStartdate, "from startDate"))
				}


				if !isCapturing(lhsEnddate) && !isCapturing(rhsEnddate) {
					comparison = Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnddate, rhsEnddate, "to endDate"))
				}


				if !isCapturing(lhsPredicate) && !isCapturing(rhsPredicate) {
					comparison = Parameter.compare(lhs: lhsPredicate, rhs: rhsPredicate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPredicate, rhsPredicate, "predicate"))
				}


				if !isCapturing(lhsCallback) && !isCapturing(rhsCallback) {
					comparison = Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCallback, rhsCallback, "callback"))
				}

				if isCapturing(lhsType) || isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "for type"))
				}


				if isCapturing(lhsStartdate) || isCapturing(rhsStartdate) {
					comparison = Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartdate, rhsStartdate, "from startDate"))
				}


				if isCapturing(lhsEnddate) || isCapturing(rhsEnddate) {
					comparison = Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnddate, rhsEnddate, "to endDate"))
				}


				if isCapturing(lhsPredicate) || isCapturing(rhsPredicate) {
					comparison = Parameter.compare(lhs: lhsPredicate, rhs: rhsPredicate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsPredicate, rhsPredicate, "predicate"))
				}


				if isCapturing(lhsCallback) || isCapturing(rhsCallback) {
					comparison = Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCallback, rhsCallback, "callback"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_preferredUnitFor__typeId(let lhsTypeid), .m_preferredUnitFor__typeId(let rhsTypeid)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTypeid) && !isCapturing(rhsTypeid) {
					comparison = Parameter.compare(lhs: lhsTypeid, rhs: rhsTypeid, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTypeid, rhsTypeid, "_ typeId"))
				}

				if isCapturing(lhsTypeid) || isCapturing(rhsTypeid) {
					comparison = Parameter.compare(lhs: lhsTypeid, rhs: rhsTypeid, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTypeid, rhsTypeid, "_ typeId"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getAuthorization__callback_callback(let lhsCallback), .m_getAuthorization__callback_callback(let rhsCallback)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsCallback) && !isCapturing(rhsCallback) {
					comparison = Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCallback, rhsCallback, "callback"))
				}

				if isCapturing(lhsCallback) || isCapturing(rhsCallback) {
					comparison = Parameter.compare(lhs: lhsCallback, rhs: rhsCallback, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCallback, rhsCallback, "callback"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
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
        func assertionName() -> String {
            switch self {
            case .m_setTimeZoneIfApplicable__for_datefrom_sample: return ".setTimeZoneIfApplicable(for:from:)"
            case .m_calculate__calculation_typefrom_startDateto_endDatecallback_callback: return ".calculate(_:_:from:to:callback:)"
            case .m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback: return ".getSamples(for:from:to:predicate:callback:)"
            case .m_preferredUnitFor__typeId: return ".preferredUnitFor(_:)"
            case .m_getAuthorization__callback_callback: return ".getAuthorization(callback:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getSamples(for type: Parameter<HealthKitSample.Type>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, predicate: Parameter<NSPredicate?>, callback: Parameter<([HKSample]?, Error?) -> Void>, willReturn: () -> Void...) -> MethodStub {
            return Given(method: .m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(`type`, `startDate`, `endDate`, `predicate`, `callback`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func preferredUnitFor(_ typeId: Parameter<HKQuantityTypeIdentifier>, willReturn: HKUnit?...) -> MethodStub {
            return Given(method: .m_preferredUnitFor__typeId(`typeId`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getSamples(for type: Parameter<HealthKitSample.Type>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, predicate: Parameter<NSPredicate?>, callback: Parameter<([HKSample]?, Error?) -> Void>, willProduce: (Stubber<() -> Void>) -> Void) -> MethodStub {
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
        public static func getSamples(for type: Parameter<HealthKitSample.Type>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, predicate: Parameter<NSPredicate?>, callback: Parameter<([HKSample]?, Error?) -> Void>) -> Verify { return Verify(method: .m_getSamples__for_typefrom_startDateto_endDatepredicate_predicatecallback_callback(`type`, `startDate`, `endDate`, `predicate`, `callback`))}
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
        public static func getSamples(for type: Parameter<HealthKitSample.Type>, from startDate: Parameter<Date?>, to endDate: Parameter<Date?>, predicate: Parameter<NSPredicate?>, callback: Parameter<([HKSample]?, Error?) -> Void>, perform: @escaping (HealthKitSample.Type, Date?, Date?, NSPredicate?, @escaping ([HKSample]?, Error?) -> Void) -> Void) -> Perform {
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

// MARK: - MedicationDAO

open class MedicationDAOMock: MedicationDAO, Mock {
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






    open func allMedications() throws -> [Medication] {
        addInvocation(.m_allMedications)
		let perform = methodPerformValue(.m_allMedications) as? () -> Void
		perform?()
		var __value: [Medication]
		do {
		    __value = try methodReturnValue(.m_allMedications).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for allMedications(). Use given")
			Failure("Stub return value not specified for allMedications(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getMedicationDoses(from minDate: Date?, to maxDate: Date?) throws -> [MedicationDose] {
        addInvocation(.m_getMedicationDoses__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`)))
		let perform = methodPerformValue(.m_getMedicationDoses__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`))) as? (Date?, Date?) -> Void
		perform?(`minDate`, `maxDate`)
		var __value: [MedicationDose]
		do {
		    __value = try methodReturnValue(.m_getMedicationDoses__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getMedicationDoses(from minDate: Date?, to maxDate: Date?). Use given")
			Failure("Stub return value not specified for getMedicationDoses(from minDate: Date?, to maxDate: Date?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func medicationExists(withName name: String, using transaction: Transaction?) throws -> Bool {
        addInvocation(.m_medicationExists__withName_nameusing_transaction(Parameter<String>.value(`name`), Parameter<Transaction?>.value(`transaction`)))
		let perform = methodPerformValue(.m_medicationExists__withName_nameusing_transaction(Parameter<String>.value(`name`), Parameter<Transaction?>.value(`transaction`))) as? (String, Transaction?) -> Void
		perform?(`name`, `transaction`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_medicationExists__withName_nameusing_transaction(Parameter<String>.value(`name`), Parameter<Transaction?>.value(`transaction`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for medicationExists(withName name: String, using transaction: Transaction?). Use given")
			Failure("Stub return value not specified for medicationExists(withName name: String, using transaction: Transaction?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func medicationNamed(_ name: String) throws -> Medication? {
        addInvocation(.m_medicationNamed__name(Parameter<String>.value(`name`)))
		let perform = methodPerformValue(.m_medicationNamed__name(Parameter<String>.value(`name`))) as? (String) -> Void
		perform?(`name`)
		var __value: Medication? = nil
		do {
		    __value = try methodReturnValue(.m_medicationNamed__name(Parameter<String>.value(`name`))).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    @discardableResult
	open func takeMedicationUsingDefaultDosage(_ medication: Medication) throws -> MedicationDose {
        addInvocation(.m_takeMedicationUsingDefaultDosage__medication(Parameter<Medication>.value(`medication`)))
		let perform = methodPerformValue(.m_takeMedicationUsingDefaultDosage__medication(Parameter<Medication>.value(`medication`))) as? (Medication) -> Void
		perform?(`medication`)
		var __value: MedicationDose
		do {
		    __value = try methodReturnValue(.m_takeMedicationUsingDefaultDosage__medication(Parameter<Medication>.value(`medication`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for takeMedicationUsingDefaultDosage(_ medication: Medication). Use given")
			Failure("Stub return value not specified for takeMedicationUsingDefaultDosage(_ medication: Medication). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func mostRecentDoseOf(_ medication: Medication) throws -> MedicationDose? {
        addInvocation(.m_mostRecentDoseOf__medication(Parameter<Medication>.value(`medication`)))
		let perform = methodPerformValue(.m_mostRecentDoseOf__medication(Parameter<Medication>.value(`medication`))) as? (Medication) -> Void
		perform?(`medication`)
		var __value: MedicationDose? = nil
		do {
		    __value = try methodReturnValue(.m_mostRecentDoseOf__medication(Parameter<Medication>.value(`medication`))).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    @discardableResult
	open func createMedication(		name: String,		frequency: Frequency?,		dosage: Dosage?,		startedOn: Date?,		note: String?,		source: Sources.MedicationSourceNum,		recordScreenIndex: Int16?,		using transaction: Transaction?	) throws -> Medication {
        addInvocation(.m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(Parameter<String>.value(`name`), Parameter<Frequency?>.value(`frequency`), Parameter<Dosage?>.value(`dosage`), Parameter<Date?>.value(`startedOn`), Parameter<String?>.value(`note`), Parameter<Sources.MedicationSourceNum>.value(`source`), Parameter<Int16?>.value(`recordScreenIndex`), Parameter<Transaction?>.value(`transaction`)))
		let perform = methodPerformValue(.m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(Parameter<String>.value(`name`), Parameter<Frequency?>.value(`frequency`), Parameter<Dosage?>.value(`dosage`), Parameter<Date?>.value(`startedOn`), Parameter<String?>.value(`note`), Parameter<Sources.MedicationSourceNum>.value(`source`), Parameter<Int16?>.value(`recordScreenIndex`), Parameter<Transaction?>.value(`transaction`))) as? (String, Frequency?, Dosage?, Date?, String?, Sources.MedicationSourceNum, Int16?, Transaction?) -> Void
		perform?(`name`, `frequency`, `dosage`, `startedOn`, `note`, `source`, `recordScreenIndex`, `transaction`)
		var __value: Medication
		do {
		    __value = try methodReturnValue(.m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(Parameter<String>.value(`name`), Parameter<Frequency?>.value(`frequency`), Parameter<Dosage?>.value(`dosage`), Parameter<Date?>.value(`startedOn`), Parameter<String?>.value(`note`), Parameter<Sources.MedicationSourceNum>.value(`source`), Parameter<Int16?>.value(`recordScreenIndex`), Parameter<Transaction?>.value(`transaction`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for createMedication(  name: String,  frequency: Frequency?,  dosage: Dosage?,  startedOn: Date?,  note: String?,  source: Sources.MedicationSourceNum,  recordScreenIndex: Int16?,  using transaction: Transaction? ). Use given")
			Failure("Stub return value not specified for createMedication(  name: String,  frequency: Frequency?,  dosage: Dosage?,  startedOn: Date?,  note: String?,  source: Sources.MedicationSourceNum,  recordScreenIndex: Int16?,  using transaction: Transaction? ). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    @discardableResult
	open func createDose(		medication: Medication,		dosage: Dosage?,		timestamp: Date,		source: Sources.MedicationSourceNum,		using transaction: Transaction?	) throws -> MedicationDose {
        addInvocation(.m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(Parameter<Medication>.value(`medication`), Parameter<Dosage?>.value(`dosage`), Parameter<Date>.value(`timestamp`), Parameter<Sources.MedicationSourceNum>.value(`source`), Parameter<Transaction?>.value(`transaction`)))
		let perform = methodPerformValue(.m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(Parameter<Medication>.value(`medication`), Parameter<Dosage?>.value(`dosage`), Parameter<Date>.value(`timestamp`), Parameter<Sources.MedicationSourceNum>.value(`source`), Parameter<Transaction?>.value(`transaction`))) as? (Medication, Dosage?, Date, Sources.MedicationSourceNum, Transaction?) -> Void
		perform?(`medication`, `dosage`, `timestamp`, `source`, `transaction`)
		var __value: MedicationDose
		do {
		    __value = try methodReturnValue(.m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(Parameter<Medication>.value(`medication`), Parameter<Dosage?>.value(`dosage`), Parameter<Date>.value(`timestamp`), Parameter<Sources.MedicationSourceNum>.value(`source`), Parameter<Transaction?>.value(`transaction`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for createDose(  medication: Medication,  dosage: Dosage?,  timestamp: Date,  source: Sources.MedicationSourceNum,  using transaction: Transaction? ). Use given")
			Failure("Stub return value not specified for createDose(  medication: Medication,  dosage: Dosage?,  timestamp: Date,  source: Sources.MedicationSourceNum,  using transaction: Transaction? ). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_allMedications
        case m_getMedicationDoses__from_minDateto_maxDate(Parameter<Date?>, Parameter<Date?>)
        case m_medicationExists__withName_nameusing_transaction(Parameter<String>, Parameter<Transaction?>)
        case m_medicationNamed__name(Parameter<String>)
        case m_takeMedicationUsingDefaultDosage__medication(Parameter<Medication>)
        case m_mostRecentDoseOf__medication(Parameter<Medication>)
        case m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(Parameter<String>, Parameter<Frequency?>, Parameter<Dosage?>, Parameter<Date?>, Parameter<String?>, Parameter<Sources.MedicationSourceNum>, Parameter<Int16?>, Parameter<Transaction?>)
        case m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(Parameter<Medication>, Parameter<Dosage?>, Parameter<Date>, Parameter<Sources.MedicationSourceNum>, Parameter<Transaction?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_allMedications, .m_allMedications): return .match

            case (.m_getMedicationDoses__from_minDateto_maxDate(let lhsMindate, let lhsMaxdate), .m_getMedicationDoses__from_minDateto_maxDate(let rhsMindate, let rhsMaxdate)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsMindate) && !isCapturing(rhsMindate) {
					comparison = Parameter.compare(lhs: lhsMindate, rhs: rhsMindate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMindate, rhsMindate, "from minDate"))
				}


				if !isCapturing(lhsMaxdate) && !isCapturing(rhsMaxdate) {
					comparison = Parameter.compare(lhs: lhsMaxdate, rhs: rhsMaxdate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxdate, rhsMaxdate, "to maxDate"))
				}

				if isCapturing(lhsMindate) || isCapturing(rhsMindate) {
					comparison = Parameter.compare(lhs: lhsMindate, rhs: rhsMindate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMindate, rhsMindate, "from minDate"))
				}


				if isCapturing(lhsMaxdate) || isCapturing(rhsMaxdate) {
					comparison = Parameter.compare(lhs: lhsMaxdate, rhs: rhsMaxdate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxdate, rhsMaxdate, "to maxDate"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_medicationExists__withName_nameusing_transaction(let lhsName, let lhsTransaction), .m_medicationExists__withName_nameusing_transaction(let rhsName, let rhsTransaction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "withName name"))
				}


				if !isCapturing(lhsTransaction) && !isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "withName name"))
				}


				if isCapturing(lhsTransaction) || isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_medicationNamed__name(let lhsName), .m_medicationNamed__name(let rhsName)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "_ name"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "_ name"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_takeMedicationUsingDefaultDosage__medication(let lhsMedication), .m_takeMedicationUsingDefaultDosage__medication(let rhsMedication)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsMedication) && !isCapturing(rhsMedication) {
					comparison = Parameter.compare(lhs: lhsMedication, rhs: rhsMedication, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMedication, rhsMedication, "_ medication"))
				}

				if isCapturing(lhsMedication) || isCapturing(rhsMedication) {
					comparison = Parameter.compare(lhs: lhsMedication, rhs: rhsMedication, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMedication, rhsMedication, "_ medication"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_mostRecentDoseOf__medication(let lhsMedication), .m_mostRecentDoseOf__medication(let rhsMedication)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsMedication) && !isCapturing(rhsMedication) {
					comparison = Parameter.compare(lhs: lhsMedication, rhs: rhsMedication, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMedication, rhsMedication, "_ medication"))
				}

				if isCapturing(lhsMedication) || isCapturing(rhsMedication) {
					comparison = Parameter.compare(lhs: lhsMedication, rhs: rhsMedication, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMedication, rhsMedication, "_ medication"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(let lhsName, let lhsFrequency, let lhsDosage, let lhsStartedon, let lhsNote, let lhsSource, let lhsRecordscreenindex, let lhsTransaction), .m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(let rhsName, let rhsFrequency, let rhsDosage, let rhsStartedon, let rhsNote, let rhsSource, let rhsRecordscreenindex, let rhsTransaction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}


				if !isCapturing(lhsFrequency) && !isCapturing(rhsFrequency) {
					comparison = Parameter.compare(lhs: lhsFrequency, rhs: rhsFrequency, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFrequency, rhsFrequency, "frequency"))
				}


				if !isCapturing(lhsDosage) && !isCapturing(rhsDosage) {
					comparison = Parameter.compare(lhs: lhsDosage, rhs: rhsDosage, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDosage, rhsDosage, "dosage"))
				}


				if !isCapturing(lhsStartedon) && !isCapturing(rhsStartedon) {
					comparison = Parameter.compare(lhs: lhsStartedon, rhs: rhsStartedon, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartedon, rhsStartedon, "startedOn"))
				}


				if !isCapturing(lhsNote) && !isCapturing(rhsNote) {
					comparison = Parameter.compare(lhs: lhsNote, rhs: rhsNote, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNote, rhsNote, "note"))
				}


				if !isCapturing(lhsSource) && !isCapturing(rhsSource) {
					comparison = Parameter.compare(lhs: lhsSource, rhs: rhsSource, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSource, rhsSource, "source"))
				}


				if !isCapturing(lhsRecordscreenindex) && !isCapturing(rhsRecordscreenindex) {
					comparison = Parameter.compare(lhs: lhsRecordscreenindex, rhs: rhsRecordscreenindex, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRecordscreenindex, rhsRecordscreenindex, "recordScreenIndex"))
				}


				if !isCapturing(lhsTransaction) && !isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "name"))
				}


				if isCapturing(lhsFrequency) || isCapturing(rhsFrequency) {
					comparison = Parameter.compare(lhs: lhsFrequency, rhs: rhsFrequency, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFrequency, rhsFrequency, "frequency"))
				}


				if isCapturing(lhsDosage) || isCapturing(rhsDosage) {
					comparison = Parameter.compare(lhs: lhsDosage, rhs: rhsDosage, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDosage, rhsDosage, "dosage"))
				}


				if isCapturing(lhsStartedon) || isCapturing(rhsStartedon) {
					comparison = Parameter.compare(lhs: lhsStartedon, rhs: rhsStartedon, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartedon, rhsStartedon, "startedOn"))
				}


				if isCapturing(lhsNote) || isCapturing(rhsNote) {
					comparison = Parameter.compare(lhs: lhsNote, rhs: rhsNote, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNote, rhsNote, "note"))
				}


				if isCapturing(lhsSource) || isCapturing(rhsSource) {
					comparison = Parameter.compare(lhs: lhsSource, rhs: rhsSource, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSource, rhsSource, "source"))
				}


				if isCapturing(lhsRecordscreenindex) || isCapturing(rhsRecordscreenindex) {
					comparison = Parameter.compare(lhs: lhsRecordscreenindex, rhs: rhsRecordscreenindex, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRecordscreenindex, rhsRecordscreenindex, "recordScreenIndex"))
				}


				if isCapturing(lhsTransaction) || isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(let lhsMedication, let lhsDosage, let lhsTimestamp, let lhsSource, let lhsTransaction), .m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(let rhsMedication, let rhsDosage, let rhsTimestamp, let rhsSource, let rhsTransaction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsMedication) && !isCapturing(rhsMedication) {
					comparison = Parameter.compare(lhs: lhsMedication, rhs: rhsMedication, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMedication, rhsMedication, "medication"))
				}


				if !isCapturing(lhsDosage) && !isCapturing(rhsDosage) {
					comparison = Parameter.compare(lhs: lhsDosage, rhs: rhsDosage, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDosage, rhsDosage, "dosage"))
				}


				if !isCapturing(lhsTimestamp) && !isCapturing(rhsTimestamp) {
					comparison = Parameter.compare(lhs: lhsTimestamp, rhs: rhsTimestamp, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimestamp, rhsTimestamp, "timestamp"))
				}


				if !isCapturing(lhsSource) && !isCapturing(rhsSource) {
					comparison = Parameter.compare(lhs: lhsSource, rhs: rhsSource, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSource, rhsSource, "source"))
				}


				if !isCapturing(lhsTransaction) && !isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				if isCapturing(lhsMedication) || isCapturing(rhsMedication) {
					comparison = Parameter.compare(lhs: lhsMedication, rhs: rhsMedication, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMedication, rhsMedication, "medication"))
				}


				if isCapturing(lhsDosage) || isCapturing(rhsDosage) {
					comparison = Parameter.compare(lhs: lhsDosage, rhs: rhsDosage, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDosage, rhsDosage, "dosage"))
				}


				if isCapturing(lhsTimestamp) || isCapturing(rhsTimestamp) {
					comparison = Parameter.compare(lhs: lhsTimestamp, rhs: rhsTimestamp, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimestamp, rhsTimestamp, "timestamp"))
				}


				if isCapturing(lhsSource) || isCapturing(rhsSource) {
					comparison = Parameter.compare(lhs: lhsSource, rhs: rhsSource, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSource, rhsSource, "source"))
				}


				if isCapturing(lhsTransaction) || isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_allMedications: return 0
            case let .m_getMedicationDoses__from_minDateto_maxDate(p0, p1): return p0.intValue + p1.intValue
            case let .m_medicationExists__withName_nameusing_transaction(p0, p1): return p0.intValue + p1.intValue
            case let .m_medicationNamed__name(p0): return p0.intValue
            case let .m_takeMedicationUsingDefaultDosage__medication(p0): return p0.intValue
            case let .m_mostRecentDoseOf__medication(p0): return p0.intValue
            case let .m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(p0, p1, p2, p3, p4, p5, p6, p7): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue + p7.intValue
            case let .m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_allMedications: return ".allMedications()"
            case .m_getMedicationDoses__from_minDateto_maxDate: return ".getMedicationDoses(from:to:)"
            case .m_medicationExists__withName_nameusing_transaction: return ".medicationExists(withName:using:)"
            case .m_medicationNamed__name: return ".medicationNamed(_:)"
            case .m_takeMedicationUsingDefaultDosage__medication: return ".takeMedicationUsingDefaultDosage(_:)"
            case .m_mostRecentDoseOf__medication: return ".mostRecentDoseOf(_:)"
            case .m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction: return ".createMedication(name:frequency:dosage:startedOn:note:source:recordScreenIndex:using:)"
            case .m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction: return ".createDose(medication:dosage:timestamp:source:using:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func allMedications(willReturn: [Medication]...) -> MethodStub {
            return Given(method: .m_allMedications, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getMedicationDoses(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willReturn: [MedicationDose]...) -> MethodStub {
            return Given(method: .m_getMedicationDoses__from_minDateto_maxDate(`minDate`, `maxDate`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func medicationExists(withName name: Parameter<String>, using transaction: Parameter<Transaction?>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_medicationExists__withName_nameusing_transaction(`name`, `transaction`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func medicationNamed(_ name: Parameter<String>, willReturn: Medication?...) -> MethodStub {
            return Given(method: .m_medicationNamed__name(`name`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        @discardableResult
		public static func takeMedicationUsingDefaultDosage(_ medication: Parameter<Medication>, willReturn: MedicationDose...) -> MethodStub {
            return Given(method: .m_takeMedicationUsingDefaultDosage__medication(`medication`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func mostRecentDoseOf(_ medication: Parameter<Medication>, willReturn: MedicationDose?...) -> MethodStub {
            return Given(method: .m_mostRecentDoseOf__medication(`medication`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        @discardableResult
		public static func createMedication(name: Parameter<String>, frequency: Parameter<Frequency?>, dosage: Parameter<Dosage?>, startedOn: Parameter<Date?>, note: Parameter<String?>, source: Parameter<Sources.MedicationSourceNum>, recordScreenIndex: Parameter<Int16?>, using transaction: Parameter<Transaction?>, willReturn: Medication...) -> MethodStub {
            return Given(method: .m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(`name`, `frequency`, `dosage`, `startedOn`, `note`, `source`, `recordScreenIndex`, `transaction`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        @discardableResult
		public static func createDose(medication: Parameter<Medication>, dosage: Parameter<Dosage?>, timestamp: Parameter<Date>, source: Parameter<Sources.MedicationSourceNum>, using transaction: Parameter<Transaction?>, willReturn: MedicationDose...) -> MethodStub {
            return Given(method: .m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(`medication`, `dosage`, `timestamp`, `source`, `transaction`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func allMedications(willThrow: Error...) -> MethodStub {
            return Given(method: .m_allMedications, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func allMedications(willProduce: (StubberThrows<[Medication]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_allMedications, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Medication]).self)
			willProduce(stubber)
			return given
        }
        public static func getMedicationDoses(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getMedicationDoses__from_minDateto_maxDate(`minDate`, `maxDate`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getMedicationDoses(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willProduce: (StubberThrows<[MedicationDose]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getMedicationDoses__from_minDateto_maxDate(`minDate`, `maxDate`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([MedicationDose]).self)
			willProduce(stubber)
			return given
        }
        public static func medicationExists(withName name: Parameter<String>, using transaction: Parameter<Transaction?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_medicationExists__withName_nameusing_transaction(`name`, `transaction`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func medicationExists(withName name: Parameter<String>, using transaction: Parameter<Transaction?>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_medicationExists__withName_nameusing_transaction(`name`, `transaction`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func medicationNamed(_ name: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_medicationNamed__name(`name`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func medicationNamed(_ name: Parameter<String>, willProduce: (StubberThrows<Medication?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_medicationNamed__name(`name`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Medication?).self)
			willProduce(stubber)
			return given
        }
        @discardableResult
		public static func takeMedicationUsingDefaultDosage(_ medication: Parameter<Medication>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_takeMedicationUsingDefaultDosage__medication(`medication`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func takeMedicationUsingDefaultDosage(_ medication: Parameter<Medication>, willProduce: (StubberThrows<MedicationDose>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_takeMedicationUsingDefaultDosage__medication(`medication`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (MedicationDose).self)
			willProduce(stubber)
			return given
        }
        public static func mostRecentDoseOf(_ medication: Parameter<Medication>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_mostRecentDoseOf__medication(`medication`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func mostRecentDoseOf(_ medication: Parameter<Medication>, willProduce: (StubberThrows<MedicationDose?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_mostRecentDoseOf__medication(`medication`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (MedicationDose?).self)
			willProduce(stubber)
			return given
        }
        @discardableResult
		public static func createMedication(name: Parameter<String>, frequency: Parameter<Frequency?>, dosage: Parameter<Dosage?>, startedOn: Parameter<Date?>, note: Parameter<String?>, source: Parameter<Sources.MedicationSourceNum>, recordScreenIndex: Parameter<Int16?>, using transaction: Parameter<Transaction?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(`name`, `frequency`, `dosage`, `startedOn`, `note`, `source`, `recordScreenIndex`, `transaction`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func createMedication(name: Parameter<String>, frequency: Parameter<Frequency?>, dosage: Parameter<Dosage?>, startedOn: Parameter<Date?>, note: Parameter<String?>, source: Parameter<Sources.MedicationSourceNum>, recordScreenIndex: Parameter<Int16?>, using transaction: Parameter<Transaction?>, willProduce: (StubberThrows<Medication>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(`name`, `frequency`, `dosage`, `startedOn`, `note`, `source`, `recordScreenIndex`, `transaction`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Medication).self)
			willProduce(stubber)
			return given
        }
        @discardableResult
		public static func createDose(medication: Parameter<Medication>, dosage: Parameter<Dosage?>, timestamp: Parameter<Date>, source: Parameter<Sources.MedicationSourceNum>, using transaction: Parameter<Transaction?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(`medication`, `dosage`, `timestamp`, `source`, `transaction`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func createDose(medication: Parameter<Medication>, dosage: Parameter<Dosage?>, timestamp: Parameter<Date>, source: Parameter<Sources.MedicationSourceNum>, using transaction: Parameter<Transaction?>, willProduce: (StubberThrows<MedicationDose>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(`medication`, `dosage`, `timestamp`, `source`, `transaction`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (MedicationDose).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func allMedications() -> Verify { return Verify(method: .m_allMedications)}
        public static func getMedicationDoses(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>) -> Verify { return Verify(method: .m_getMedicationDoses__from_minDateto_maxDate(`minDate`, `maxDate`))}
        public static func medicationExists(withName name: Parameter<String>, using transaction: Parameter<Transaction?>) -> Verify { return Verify(method: .m_medicationExists__withName_nameusing_transaction(`name`, `transaction`))}
        public static func medicationNamed(_ name: Parameter<String>) -> Verify { return Verify(method: .m_medicationNamed__name(`name`))}
        @discardableResult
		public static func takeMedicationUsingDefaultDosage(_ medication: Parameter<Medication>) -> Verify { return Verify(method: .m_takeMedicationUsingDefaultDosage__medication(`medication`))}
        public static func mostRecentDoseOf(_ medication: Parameter<Medication>) -> Verify { return Verify(method: .m_mostRecentDoseOf__medication(`medication`))}
        @discardableResult
		public static func createMedication(name: Parameter<String>, frequency: Parameter<Frequency?>, dosage: Parameter<Dosage?>, startedOn: Parameter<Date?>, note: Parameter<String?>, source: Parameter<Sources.MedicationSourceNum>, recordScreenIndex: Parameter<Int16?>, using transaction: Parameter<Transaction?>) -> Verify { return Verify(method: .m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(`name`, `frequency`, `dosage`, `startedOn`, `note`, `source`, `recordScreenIndex`, `transaction`))}
        @discardableResult
		public static func createDose(medication: Parameter<Medication>, dosage: Parameter<Dosage?>, timestamp: Parameter<Date>, source: Parameter<Sources.MedicationSourceNum>, using transaction: Parameter<Transaction?>) -> Verify { return Verify(method: .m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(`medication`, `dosage`, `timestamp`, `source`, `transaction`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func allMedications(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_allMedications, performs: perform)
        }
        public static func getMedicationDoses(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, perform: @escaping (Date?, Date?) -> Void) -> Perform {
            return Perform(method: .m_getMedicationDoses__from_minDateto_maxDate(`minDate`, `maxDate`), performs: perform)
        }
        public static func medicationExists(withName name: Parameter<String>, using transaction: Parameter<Transaction?>, perform: @escaping (String, Transaction?) -> Void) -> Perform {
            return Perform(method: .m_medicationExists__withName_nameusing_transaction(`name`, `transaction`), performs: perform)
        }
        public static func medicationNamed(_ name: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_medicationNamed__name(`name`), performs: perform)
        }
        @discardableResult
		public static func takeMedicationUsingDefaultDosage(_ medication: Parameter<Medication>, perform: @escaping (Medication) -> Void) -> Perform {
            return Perform(method: .m_takeMedicationUsingDefaultDosage__medication(`medication`), performs: perform)
        }
        public static func mostRecentDoseOf(_ medication: Parameter<Medication>, perform: @escaping (Medication) -> Void) -> Perform {
            return Perform(method: .m_mostRecentDoseOf__medication(`medication`), performs: perform)
        }
        @discardableResult
		public static func createMedication(name: Parameter<String>, frequency: Parameter<Frequency?>, dosage: Parameter<Dosage?>, startedOn: Parameter<Date?>, note: Parameter<String?>, source: Parameter<Sources.MedicationSourceNum>, recordScreenIndex: Parameter<Int16?>, using transaction: Parameter<Transaction?>, perform: @escaping (String, Frequency?, Dosage?, Date?, String?, Sources.MedicationSourceNum, Int16?, Transaction?) -> Void) -> Perform {
            return Perform(method: .m_createMedication__name_namefrequency_frequencydosage_dosagestartedOn_startedOnnote_notesource_sourcerecordScreenIndex_recordScreenIndexusing_transaction(`name`, `frequency`, `dosage`, `startedOn`, `note`, `source`, `recordScreenIndex`, `transaction`), performs: perform)
        }
        @discardableResult
		public static func createDose(medication: Parameter<Medication>, dosage: Parameter<Dosage?>, timestamp: Parameter<Date>, source: Parameter<Sources.MedicationSourceNum>, using transaction: Parameter<Transaction?>, perform: @escaping (Medication, Dosage?, Date, Sources.MedicationSourceNum, Transaction?) -> Void) -> Perform {
            return Perform(method: .m_createDose__medication_medicationdosage_dosagetimestamp_timestampsource_sourceusing_transaction(`medication`, `dosage`, `timestamp`, `source`, `transaction`), performs: perform)
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

// MARK: - MedicationExporter

open class MedicationExporterMock: MedicationExporter, Mock {
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








    fileprivate struct MethodType {
        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult { return .match }
        func intValue() -> Int { return 0 }
        func assertionName() -> String { return "" }
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

// MARK: - MoodDAO

open class MoodDAOMock: MoodDAO, Mock {
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






    open func getMoods(from minDate: Date?, to maxDate: Date?) throws -> [Mood] {
        addInvocation(.m_getMoods__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`)))
		let perform = methodPerformValue(.m_getMoods__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`))) as? (Date?, Date?) -> Void
		perform?(`minDate`, `maxDate`)
		var __value: [Mood]
		do {
		    __value = try methodReturnValue(.m_getMoods__from_minDateto_maxDate(Parameter<Date?>.value(`minDate`), Parameter<Date?>.value(`maxDate`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getMoods(from minDate: Date?, to maxDate: Date?). Use given")
			Failure("Stub return value not specified for getMoods(from minDate: Date?, to maxDate: Date?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func createMood(timestamp: Date, rating: Double, min: Double?, max: Double?, note: String?) throws -> Mood {
        addInvocation(.m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(Parameter<Date>.value(`timestamp`), Parameter<Double>.value(`rating`), Parameter<Double?>.value(`min`), Parameter<Double?>.value(`max`), Parameter<String?>.value(`note`)))
		let perform = methodPerformValue(.m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(Parameter<Date>.value(`timestamp`), Parameter<Double>.value(`rating`), Parameter<Double?>.value(`min`), Parameter<Double?>.value(`max`), Parameter<String?>.value(`note`))) as? (Date, Double, Double?, Double?, String?) -> Void
		perform?(`timestamp`, `rating`, `min`, `max`, `note`)
		var __value: Mood
		do {
		    __value = try methodReturnValue(.m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(Parameter<Date>.value(`timestamp`), Parameter<Double>.value(`rating`), Parameter<Double?>.value(`min`), Parameter<Double?>.value(`max`), Parameter<String?>.value(`note`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for createMood(timestamp: Date, rating: Double, min: Double?, max: Double?, note: String?). Use given")
			Failure("Stub return value not specified for createMood(timestamp: Date, rating: Double, min: Double?, max: Double?, note: String?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getMostRecentMood() throws -> Mood? {
        addInvocation(.m_getMostRecentMood)
		let perform = methodPerformValue(.m_getMostRecentMood) as? () -> Void
		perform?()
		var __value: Mood? = nil
		do {
		    __value = try methodReturnValue(.m_getMostRecentMood).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getMoods__from_minDateto_maxDate(Parameter<Date?>, Parameter<Date?>)
        case m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(Parameter<Date>, Parameter<Double>, Parameter<Double?>, Parameter<Double?>, Parameter<String?>)
        case m_getMostRecentMood

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getMoods__from_minDateto_maxDate(let lhsMindate, let lhsMaxdate), .m_getMoods__from_minDateto_maxDate(let rhsMindate, let rhsMaxdate)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsMindate) && !isCapturing(rhsMindate) {
					comparison = Parameter.compare(lhs: lhsMindate, rhs: rhsMindate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMindate, rhsMindate, "from minDate"))
				}


				if !isCapturing(lhsMaxdate) && !isCapturing(rhsMaxdate) {
					comparison = Parameter.compare(lhs: lhsMaxdate, rhs: rhsMaxdate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxdate, rhsMaxdate, "to maxDate"))
				}

				if isCapturing(lhsMindate) || isCapturing(rhsMindate) {
					comparison = Parameter.compare(lhs: lhsMindate, rhs: rhsMindate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMindate, rhsMindate, "from minDate"))
				}


				if isCapturing(lhsMaxdate) || isCapturing(rhsMaxdate) {
					comparison = Parameter.compare(lhs: lhsMaxdate, rhs: rhsMaxdate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMaxdate, rhsMaxdate, "to maxDate"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(let lhsTimestamp, let lhsRating, let lhsMin, let lhsMax, let lhsNote), .m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(let rhsTimestamp, let rhsRating, let rhsMin, let rhsMax, let rhsNote)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTimestamp) && !isCapturing(rhsTimestamp) {
					comparison = Parameter.compare(lhs: lhsTimestamp, rhs: rhsTimestamp, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimestamp, rhsTimestamp, "timestamp"))
				}


				if !isCapturing(lhsRating) && !isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "rating"))
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


				if !isCapturing(lhsNote) && !isCapturing(rhsNote) {
					comparison = Parameter.compare(lhs: lhsNote, rhs: rhsNote, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNote, rhsNote, "note"))
				}

				if isCapturing(lhsTimestamp) || isCapturing(rhsTimestamp) {
					comparison = Parameter.compare(lhs: lhsTimestamp, rhs: rhsTimestamp, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTimestamp, rhsTimestamp, "timestamp"))
				}


				if isCapturing(lhsRating) || isCapturing(rhsRating) {
					comparison = Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRating, rhsRating, "rating"))
				}


				if isCapturing(lhsMin) || isCapturing(rhsMin) {
					comparison = Parameter.compare(lhs: lhsMin, rhs: rhsMin, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMin, rhsMin, "min"))
				}


				if isCapturing(lhsMax) || isCapturing(rhsMax) {
					comparison = Parameter.compare(lhs: lhsMax, rhs: rhsMax, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMax, rhsMax, "max"))
				}


				if isCapturing(lhsNote) || isCapturing(rhsNote) {
					comparison = Parameter.compare(lhs: lhsNote, rhs: rhsNote, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsNote, rhsNote, "note"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getMostRecentMood, .m_getMostRecentMood): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getMoods__from_minDateto_maxDate(p0, p1): return p0.intValue + p1.intValue
            case let .m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case .m_getMostRecentMood: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getMoods__from_minDateto_maxDate: return ".getMoods(from:to:)"
            case .m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note: return ".createMood(timestamp:rating:min:max:note:)"
            case .m_getMostRecentMood: return ".getMostRecentMood()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getMoods(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willReturn: [Mood]...) -> MethodStub {
            return Given(method: .m_getMoods__from_minDateto_maxDate(`minDate`, `maxDate`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func createMood(timestamp: Parameter<Date>, rating: Parameter<Double>, min: Parameter<Double?>, max: Parameter<Double?>, note: Parameter<String?>, willReturn: Mood...) -> MethodStub {
            return Given(method: .m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(`timestamp`, `rating`, `min`, `max`, `note`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getMostRecentMood(willReturn: Mood?...) -> MethodStub {
            return Given(method: .m_getMostRecentMood, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getMoods(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getMoods__from_minDateto_maxDate(`minDate`, `maxDate`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getMoods(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, willProduce: (StubberThrows<[Mood]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getMoods__from_minDateto_maxDate(`minDate`, `maxDate`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Mood]).self)
			willProduce(stubber)
			return given
        }
        public static func createMood(timestamp: Parameter<Date>, rating: Parameter<Double>, min: Parameter<Double?>, max: Parameter<Double?>, note: Parameter<String?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(`timestamp`, `rating`, `min`, `max`, `note`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func createMood(timestamp: Parameter<Date>, rating: Parameter<Double>, min: Parameter<Double?>, max: Parameter<Double?>, note: Parameter<String?>, willProduce: (StubberThrows<Mood>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(`timestamp`, `rating`, `min`, `max`, `note`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Mood).self)
			willProduce(stubber)
			return given
        }
        public static func getMostRecentMood(willThrow: Error...) -> MethodStub {
            return Given(method: .m_getMostRecentMood, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getMostRecentMood(willProduce: (StubberThrows<Mood?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getMostRecentMood, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Mood?).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getMoods(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>) -> Verify { return Verify(method: .m_getMoods__from_minDateto_maxDate(`minDate`, `maxDate`))}
        public static func createMood(timestamp: Parameter<Date>, rating: Parameter<Double>, min: Parameter<Double?>, max: Parameter<Double?>, note: Parameter<String?>) -> Verify { return Verify(method: .m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(`timestamp`, `rating`, `min`, `max`, `note`))}
        public static func getMostRecentMood() -> Verify { return Verify(method: .m_getMostRecentMood)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getMoods(from minDate: Parameter<Date?>, to maxDate: Parameter<Date?>, perform: @escaping (Date?, Date?) -> Void) -> Perform {
            return Perform(method: .m_getMoods__from_minDateto_maxDate(`minDate`, `maxDate`), performs: perform)
        }
        public static func createMood(timestamp: Parameter<Date>, rating: Parameter<Double>, min: Parameter<Double?>, max: Parameter<Double?>, note: Parameter<String?>, perform: @escaping (Date, Double, Double?, Double?, String?) -> Void) -> Perform {
            return Perform(method: .m_createMood__timestamp_timestamprating_ratingmin_minmax_maxnote_note(`timestamp`, `rating`, `min`, `max`, `note`), performs: perform)
        }
        public static func getMostRecentMood(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getMostRecentMood, performs: perform)
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

// MARK: - MoodUtil

open class MoodUtilMock: MoodUtil, Mock {
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

    open func scaleMood(_ mood: inout Mood) {
        addInvocation(.m_scaleMood__mood(Parameter<Mood>.value(`mood`)))
		let perform = methodPerformValue(.m_scaleMood__mood(Parameter<Mood>.value(`mood`))) as? (inout Mood) -> Void
		perform?(&`mood`)
    }


    fileprivate enum MethodType {
        case m_scaleMoods
        case m_scaleMood__mood(Parameter<Mood>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_scaleMoods, .m_scaleMoods): return .match

            case (.m_scaleMood__mood(let lhsMood), .m_scaleMood__mood(let rhsMood)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsMood) && !isCapturing(rhsMood) {
					comparison = Parameter.compare(lhs: lhsMood, rhs: rhsMood, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMood, rhsMood, "_ mood"))
				}

				if isCapturing(lhsMood) || isCapturing(rhsMood) {
					comparison = Parameter.compare(lhs: lhsMood, rhs: rhsMood, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsMood, rhsMood, "_ mood"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_scaleMoods: return 0
            case let .m_scaleMood__mood(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_scaleMoods: return ".scaleMoods()"
            case .m_scaleMood__mood: return ".scaleMood(_:)"
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
        public static func scaleMood(_ mood: Parameter<Mood>, perform: @escaping (inout Mood) -> Void) -> Perform {
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

// MARK: - NumericSampleUtil

open class NumericSampleUtilMock: NumericSampleUtil, Mock {
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






    open func average(		for attribute: Attribute,		over samples: [Sample],		per aggregationUnit: Calendar.Component?	) throws -> [(date: Date?, value: Double)] {
        addInvocation(.m_average__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`)))
		let perform = methodPerformValue(.m_average__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`))) as? (Attribute, [Sample], Calendar.Component?) -> Void
		perform?(`attribute`, `samples`, `aggregationUnit`)
		var __value: [(date: Date?, value: Double)]
		do {
		    __value = try methodReturnValue(.m_average__for_attributeover_samplesper_aggregationUnit(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for average(  for attribute: Attribute,  over samples: [Sample],  per aggregationUnit: Calendar.Component? ). Use given")
			Failure("Stub return value not specified for average(  for attribute: Attribute,  over samples: [Sample],  per aggregationUnit: Calendar.Component? ). Use given")
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

    open func max<Type: Comparable>(		for attribute: Attribute,		over samples: [Sample],		per aggregationUnit: Calendar.Component?,		as: Type.Type	) throws -> [(date: Date?, value: Type)] {
        addInvocation(.m_max__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_max__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (Attribute, [Sample], Calendar.Component?, Type.Type) -> Void
		perform?(`attribute`, `samples`, `aggregationUnit`, `as`)
		var __value: [(date: Date?, value: Type)]
		do {
		    __value = try methodReturnValue(.m_max__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for max<Type: Comparable>(  for attribute: Attribute,  over samples: [Sample],  per aggregationUnit: Calendar.Component?,  as: Type.Type ). Use given")
			Failure("Stub return value not specified for max<Type: Comparable>(  for attribute: Attribute,  over samples: [Sample],  per aggregationUnit: Calendar.Component?,  as: Type.Type ). Use given")
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

    open func min<Type: Comparable>(		for attribute: Attribute,		over samples: [Sample],		per aggregationUnit: Calendar.Component?,		as: Type.Type	) throws -> [(date: Date?, value: Type)] {
        addInvocation(.m_min__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_min__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (Attribute, [Sample], Calendar.Component?, Type.Type) -> Void
		perform?(`attribute`, `samples`, `aggregationUnit`, `as`)
		var __value: [(date: Date?, value: Type)]
		do {
		    __value = try methodReturnValue(.m_min__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for min<Type: Comparable>(  for attribute: Attribute,  over samples: [Sample],  per aggregationUnit: Calendar.Component?,  as: Type.Type ). Use given")
			Failure("Stub return value not specified for min<Type: Comparable>(  for attribute: Attribute,  over samples: [Sample],  per aggregationUnit: Calendar.Component?,  as: Type.Type ). Use given")
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

    open func sum<Type: Numeric>(		for attribute: Attribute,		over samples: [Sample],		per aggregationUnit: Calendar.Component?,		as: Type.Type	) throws -> [(date: Date?, value: Type)] {
        addInvocation(.m_sum__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_sum__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (Attribute, [Sample], Calendar.Component?, Type.Type) -> Void
		perform?(`attribute`, `samples`, `aggregationUnit`, `as`)
		var __value: [(date: Date?, value: Type)]
		do {
		    __value = try methodReturnValue(.m_sum__for_attributeover_samplesper_aggregationUnitas_as(Parameter<Attribute>.value(`attribute`), Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component?>.value(`aggregationUnit`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for sum<Type: Numeric>(  for attribute: Attribute,  over samples: [Sample],  per aggregationUnit: Calendar.Component?,  as: Type.Type ). Use given")
			Failure("Stub return value not specified for sum<Type: Numeric>(  for attribute: Attribute,  over samples: [Sample],  per aggregationUnit: Calendar.Component?,  as: Type.Type ). Use given")
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_average__for_attributeover_samplesper_aggregationUnit(let lhsAttribute, let lhsSamples, let lhsAggregationunit), .m_average__for_attributeover_samplesper_aggregationUnit(let rhsAttribute, let rhsSamples, let rhsAggregationunit)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if !isCapturing(lhsAggregationunit) && !isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "per aggregationUnit"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if isCapturing(lhsAggregationunit) || isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "per aggregationUnit"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_average__for_attributeover_samples(let lhsAttribute, let lhsSamples), .m_average__for_attributeover_samples(let rhsAttribute, let rhsSamples)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_count__over_samplesper_aggregationUnit(let lhsSamples, let lhsAggregationunit), .m_count__over_samplesper_aggregationUnit(let rhsSamples, let rhsAggregationunit)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if !isCapturing(lhsAggregationunit) && !isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "per aggregationUnit"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if isCapturing(lhsAggregationunit) || isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "per aggregationUnit"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_max__for_attributeover_samplesper_aggregationUnitas_as(let lhsAttribute, let lhsSamples, let lhsAggregationunit, let lhsAs), .m_max__for_attributeover_samplesper_aggregationUnitas_as(let rhsAttribute, let rhsSamples, let rhsAggregationunit, let rhsAs)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if !isCapturing(lhsAggregationunit) && !isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "per aggregationUnit"))
				}


				if !isCapturing(lhsAs) && !isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if isCapturing(lhsAggregationunit) || isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "per aggregationUnit"))
				}


				if isCapturing(lhsAs) || isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_max__for_attributeover_samplesas_as(let lhsAttribute, let lhsSamples, let lhsAs), .m_max__for_attributeover_samplesas_as(let rhsAttribute, let rhsSamples, let rhsAs)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if !isCapturing(lhsAs) && !isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if isCapturing(lhsAs) || isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_min__for_attributeover_samplesper_aggregationUnitas_as(let lhsAttribute, let lhsSamples, let lhsAggregationunit, let lhsAs), .m_min__for_attributeover_samplesper_aggregationUnitas_as(let rhsAttribute, let rhsSamples, let rhsAggregationunit, let rhsAs)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if !isCapturing(lhsAggregationunit) && !isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "per aggregationUnit"))
				}


				if !isCapturing(lhsAs) && !isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if isCapturing(lhsAggregationunit) || isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "per aggregationUnit"))
				}


				if isCapturing(lhsAs) || isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_min__for_attributeover_samplesas_as(let lhsAttribute, let lhsSamples, let lhsAs), .m_min__for_attributeover_samplesas_as(let rhsAttribute, let rhsSamples, let rhsAs)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if !isCapturing(lhsAs) && !isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if isCapturing(lhsAs) || isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_sum__for_attributeover_samplesper_aggregationUnitas_as(let lhsAttribute, let lhsSamples, let lhsAggregationunit, let lhsAs), .m_sum__for_attributeover_samplesper_aggregationUnitas_as(let rhsAttribute, let rhsSamples, let rhsAggregationunit, let rhsAs)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if !isCapturing(lhsAggregationunit) && !isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "per aggregationUnit"))
				}


				if !isCapturing(lhsAs) && !isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if isCapturing(lhsAggregationunit) || isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "per aggregationUnit"))
				}


				if isCapturing(lhsAs) || isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_sum__for_attributeover_samplesas_as(let lhsAttribute, let lhsSamples, let lhsAs), .m_sum__for_attributeover_samplesas_as(let rhsAttribute, let rhsSamples, let rhsAs)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if !isCapturing(lhsAs) && !isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}


				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "over samples"))
				}


				if isCapturing(lhsAs) || isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
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
        func assertionName() -> String {
            switch self {
            case .m_average__for_attributeover_samplesper_aggregationUnit: return ".average(for:over:per:)"
            case .m_average__for_attributeover_samples: return ".average(for:over:)"
            case .m_count__over_samplesper_aggregationUnit: return ".count(over:per:)"
            case .m_max__for_attributeover_samplesper_aggregationUnitas_as: return ".max(for:over:per:as:)"
            case .m_max__for_attributeover_samplesas_as: return ".max(for:over:as:)"
            case .m_min__for_attributeover_samplesper_aggregationUnitas_as: return ".min(for:over:per:as:)"
            case .m_min__for_attributeover_samplesas_as: return ".min(for:over:as:)"
            case .m_sum__for_attributeover_samplesper_aggregationUnitas_as: return ".sum(for:over:per:as:)"
            case .m_sum__for_attributeover_samplesas_as: return ".sum(for:over:as:)"
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
        public static func max<Type:Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_max__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func max<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willProduce: (StubberThrows<[(date: Date?, value: Type)]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_max__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(date: Date?, value: Type)]).self)
			willProduce(stubber)
			return given
        }
        public static func max<Type:Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_max__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func max<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_max__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func min<Type:Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_min__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func min<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willProduce: (StubberThrows<[(date: Date?, value: Type)]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_min__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(date: Date?, value: Type)]).self)
			willProduce(stubber)
			return given
        }
        public static func min<Type:Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_min__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func min<Type: Comparable>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_min__for_attributeover_samplesas_as(`attribute`, `samples`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func sum<Type:Numeric>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_sum__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func sum<Type: Numeric>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, per aggregationUnit: Parameter<Calendar.Component?>, as: Parameter<Type.Type>, willProduce: (StubberThrows<[(date: Date?, value: Type)]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_sum__for_attributeover_samplesper_aggregationUnitas_as(`attribute`, `samples`, `aggregationUnit`, `as`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([(date: Date?, value: Type)]).self)
			willProduce(stubber)
			return given
        }
        public static func sum<Type:Numeric>(for attribute: Parameter<Attribute>, over samples: Parameter<[Sample]>, as: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
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

// MARK: - Sample

open class SampleMock: Sample, Mock, StaticMock {
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


    public static var name: String {
		get {	SampleMock.invocations.append(.p_name_get); return SampleMock.__p_name ?? givenGetterValue(.p_name_get, "SampleMock - stub value for name was not defined") }
	}
	private static var __p_name: (String)?

    public static var attributes: [Attribute] {
		get {	SampleMock.invocations.append(.p_attributes_get); return SampleMock.__p_attributes ?? givenGetterValue(.p_attributes_get, "SampleMock - stub value for attributes was not defined") }
	}
	private static var __p_attributes: ([Attribute])?

    public static var defaultDependentAttribute: Attribute {
		get {	SampleMock.invocations.append(.p_defaultDependentAttribute_get); return SampleMock.__p_defaultDependentAttribute ?? givenGetterValue(.p_defaultDependentAttribute_get, "SampleMock - stub value for defaultDependentAttribute was not defined") }
	}
	private static var __p_defaultDependentAttribute: (Attribute)?

    public static var defaultIndependentAttribute: Attribute {
		get {	SampleMock.invocations.append(.p_defaultIndependentAttribute_get); return SampleMock.__p_defaultIndependentAttribute ?? givenGetterValue(.p_defaultIndependentAttribute_get, "SampleMock - stub value for defaultIndependentAttribute was not defined") }
	}
	private static var __p_defaultIndependentAttribute: (Attribute)?

    public static var dateAttributes: [DateType: DateAttribute] {
		get {	SampleMock.invocations.append(.p_dateAttributes_get); return SampleMock.__p_dateAttributes ?? givenGetterValue(.p_dateAttributes_get, "SampleMock - stub value for dateAttributes was not defined") }
	}
	private static var __p_dateAttributes: ([DateType: DateAttribute])?




    open func graphableValue(of attribute: Attribute) throws -> Any? {
        addInvocation(.m_graphableValue__of_attribute(Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_graphableValue__of_attribute(Parameter<Attribute>.value(`attribute`))) as? (Attribute) -> Void
		perform?(`attribute`)
		var __value: Any? = nil
		do {
		    __value = try methodReturnValue(.m_graphableValue__of_attribute(Parameter<Attribute>.value(`attribute`))).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    open func dates() -> [DateType: Date] {
        addInvocation(.m_dates)
		let perform = methodPerformValue(.m_dates) as? () -> Void
		perform?()
		var __value: [DateType: Date]
		do {
		    __value = try methodReturnValue(.m_dates).casted()
		} catch {
			onFatalFailure("Stub return value not specified for dates(). Use given")
			Failure("Stub return value not specified for dates(). Use given")
		}
		return __value
    }

    open func equalTo(_ otherSample: Sample) -> Bool {
        addInvocation(.m_equalTo__otherSample(Parameter<Sample>.value(`otherSample`)))
		let perform = methodPerformValue(.m_equalTo__otherSample(Parameter<Sample>.value(`otherSample`))) as? (Sample) -> Void
		perform?(`otherSample`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_equalTo__otherSample(Parameter<Sample>.value(`otherSample`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for equalTo(_ otherSample: Sample). Use given")
			Failure("Stub return value not specified for equalTo(_ otherSample: Sample). Use given")
		}
		return __value
    }

    open func safeEqualityCheck<Type: Equatable>(		_ attribute: Attribute,		_ otherSample: Sample,		as: Type.Type	) -> Bool {
        addInvocation(.m_safeEqualityCheck__attribute_otherSampleas_as(Parameter<Attribute>.value(`attribute`), Parameter<Sample>.value(`otherSample`), Parameter<Type.Type>.value(`as`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_safeEqualityCheck__attribute_otherSampleas_as(Parameter<Attribute>.value(`attribute`), Parameter<Sample>.value(`otherSample`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())) as? (Attribute, Sample, Type.Type) -> Void
		perform?(`attribute`, `otherSample`, `as`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_safeEqualityCheck__attribute_otherSampleas_as(Parameter<Attribute>.value(`attribute`), Parameter<Sample>.value(`otherSample`), Parameter<Type.Type>.value(`as`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for safeEqualityCheck<Type: Equatable>(  _ attribute: Attribute,  _ otherSample: Sample,  as: Type.Type ). Use given")
			Failure("Stub return value not specified for safeEqualityCheck<Type: Equatable>(  _ attribute: Attribute,  _ otherSample: Sample,  as: Type.Type ). Use given")
		}
		return __value
    }

    fileprivate enum StaticMethodType {
        case p_name_get
        case p_attributes_get
        case p_defaultDependentAttribute_get
        case p_defaultIndependentAttribute_get
        case p_dateAttributes_get

        static func compareParameters(lhs: StaticMethodType, rhs: StaticMethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_name_get,.p_name_get): return Matcher.ComparisonResult.match
            case (.p_attributes_get,.p_attributes_get): return Matcher.ComparisonResult.match
            case (.p_defaultDependentAttribute_get,.p_defaultDependentAttribute_get): return Matcher.ComparisonResult.match
            case (.p_defaultIndependentAttribute_get,.p_defaultIndependentAttribute_get): return Matcher.ComparisonResult.match
            case (.p_dateAttributes_get,.p_dateAttributes_get): return Matcher.ComparisonResult.match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
                case .p_name_get: return 0
                case .p_attributes_get: return 0
                case .p_defaultDependentAttribute_get: return 0
                case .p_defaultIndependentAttribute_get: return 0
                case .p_dateAttributes_get: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_name_get: return "[get] .name"
            case .p_attributes_get: return "[get] .attributes"
            case .p_defaultDependentAttribute_get: return "[get] .defaultDependentAttribute"
            case .p_defaultIndependentAttribute_get: return "[get] .defaultIndependentAttribute"
            case .p_dateAttributes_get: return "[get] .dateAttributes"

            }
        }
    }

    open class StaticGiven: StubbedMethod {
        fileprivate var method: StaticMethodType

        private init(method: StaticMethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func name(getter defaultValue: String...) -> StaticPropertyStub {
            return StaticGiven(method: .p_name_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func attributes(getter defaultValue: [Attribute]...) -> StaticPropertyStub {
            return StaticGiven(method: .p_attributes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func defaultDependentAttribute(getter defaultValue: Attribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_defaultDependentAttribute_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func defaultIndependentAttribute(getter defaultValue: Attribute...) -> StaticPropertyStub {
            return StaticGiven(method: .p_defaultIndependentAttribute_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func dateAttributes(getter defaultValue: [DateType: DateAttribute]...) -> StaticPropertyStub {
            return StaticGiven(method: .p_dateAttributes_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct StaticVerify {
        fileprivate var method: StaticMethodType

        public static var name: StaticVerify { return StaticVerify(method: .p_name_get) }
        public static var attributes: StaticVerify { return StaticVerify(method: .p_attributes_get) }
        public static var defaultDependentAttribute: StaticVerify { return StaticVerify(method: .p_defaultDependentAttribute_get) }
        public static var defaultIndependentAttribute: StaticVerify { return StaticVerify(method: .p_defaultIndependentAttribute_get) }
        public static var dateAttributes: StaticVerify { return StaticVerify(method: .p_dateAttributes_get) }
    }

    public struct StaticPerform {
        fileprivate var method: StaticMethodType
        var performs: Any

    }

    
    fileprivate enum MethodType {
        case m_graphableValue__of_attribute(Parameter<Attribute>)
        case m_dates
        case m_equalTo__otherSample(Parameter<Sample>)
        case m_safeEqualityCheck__attribute_otherSampleas_as(Parameter<Attribute>, Parameter<Sample>, Parameter<GenericAttribute>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_graphableValue__of_attribute(let lhsAttribute), .m_graphableValue__of_attribute(let rhsAttribute)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "of attribute"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "of attribute"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_dates, .m_dates): return .match

            case (.m_equalTo__otherSample(let lhsOthersample), .m_equalTo__otherSample(let rhsOthersample)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsOthersample) && !isCapturing(rhsOthersample) {
					comparison = Parameter.compare(lhs: lhsOthersample, rhs: rhsOthersample, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOthersample, rhsOthersample, "_ otherSample"))
				}

				if isCapturing(lhsOthersample) || isCapturing(rhsOthersample) {
					comparison = Parameter.compare(lhs: lhsOthersample, rhs: rhsOthersample, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOthersample, rhsOthersample, "_ otherSample"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_safeEqualityCheck__attribute_otherSampleas_as(let lhsAttribute, let lhsOthersample, let lhsAs), .m_safeEqualityCheck__attribute_otherSampleas_as(let rhsAttribute, let rhsOthersample, let rhsAs)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "_ attribute"))
				}


				if !isCapturing(lhsOthersample) && !isCapturing(rhsOthersample) {
					comparison = Parameter.compare(lhs: lhsOthersample, rhs: rhsOthersample, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOthersample, rhsOthersample, "_ otherSample"))
				}


				if !isCapturing(lhsAs) && !isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "_ attribute"))
				}


				if isCapturing(lhsOthersample) || isCapturing(rhsOthersample) {
					comparison = Parameter.compare(lhs: lhsOthersample, rhs: rhsOthersample, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOthersample, rhsOthersample, "_ otherSample"))
				}


				if isCapturing(lhsAs) || isCapturing(rhsAs) {
					comparison = Parameter.compare(lhs: lhsAs, rhs: rhsAs, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAs, rhsAs, "as"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_graphableValue__of_attribute(p0): return p0.intValue
            case .m_dates: return 0
            case let .m_equalTo__otherSample(p0): return p0.intValue
            case let .m_safeEqualityCheck__attribute_otherSampleas_as(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_graphableValue__of_attribute: return ".graphableValue(of:)"
            case .m_dates: return ".dates()"
            case .m_equalTo__otherSample: return ".equalTo(_:)"
            case .m_safeEqualityCheck__attribute_otherSampleas_as: return ".safeEqualityCheck(_:_:as:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func graphableValue(of attribute: Parameter<Attribute>, willReturn: Any?...) -> MethodStub {
            return Given(method: .m_graphableValue__of_attribute(`attribute`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func dates(willReturn: [DateType: Date]...) -> MethodStub {
            return Given(method: .m_dates, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func equalTo(_ otherSample: Parameter<Sample>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_equalTo__otherSample(`otherSample`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func safeEqualityCheck<Type: Equatable>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as: Parameter<Type.Type>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_safeEqualityCheck__attribute_otherSampleas_as(`attribute`, `otherSample`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func dates(willProduce: (Stubber<[DateType: Date]>) -> Void) -> MethodStub {
            let willReturn: [[DateType: Date]] = []
			let given: Given = { return Given(method: .m_dates, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([DateType: Date]).self)
			willProduce(stubber)
			return given
        }
        public static func equalTo(_ otherSample: Parameter<Sample>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_equalTo__otherSample(`otherSample`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func safeEqualityCheck<Type: Equatable>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as: Parameter<Type.Type>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_safeEqualityCheck__attribute_otherSampleas_as(`attribute`, `otherSample`, `as`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func graphableValue(of attribute: Parameter<Attribute>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_graphableValue__of_attribute(`attribute`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func graphableValue(of attribute: Parameter<Attribute>, willProduce: (StubberThrows<Any?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_graphableValue__of_attribute(`attribute`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Any?).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func graphableValue(of attribute: Parameter<Attribute>) -> Verify { return Verify(method: .m_graphableValue__of_attribute(`attribute`))}
        public static func dates() -> Verify { return Verify(method: .m_dates)}
        public static func equalTo(_ otherSample: Parameter<Sample>) -> Verify { return Verify(method: .m_equalTo__otherSample(`otherSample`))}
        public static func safeEqualityCheck<Type>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as: Parameter<Type.Type>) -> Verify where Type:Equatable { return Verify(method: .m_safeEqualityCheck__attribute_otherSampleas_as(`attribute`, `otherSample`, `as`.wrapAsGeneric()))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func graphableValue(of attribute: Parameter<Attribute>, perform: @escaping (Attribute) -> Void) -> Perform {
            return Perform(method: .m_graphableValue__of_attribute(`attribute`), performs: perform)
        }
        public static func dates(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_dates, performs: perform)
        }
        public static func equalTo(_ otherSample: Parameter<Sample>, perform: @escaping (Sample) -> Void) -> Perform {
            return Perform(method: .m_equalTo__otherSample(`otherSample`), performs: perform)
        }
        public static func safeEqualityCheck<Type>(_ attribute: Parameter<Attribute>, _ otherSample: Parameter<Sample>, as: Parameter<Type.Type>, perform: @escaping (Attribute, Sample, Type.Type) -> Void) -> Perform where Type:Equatable {
            return Perform(method: .m_safeEqualityCheck__attribute_otherSampleas_as(`attribute`, `otherSample`, `as`.wrapAsGeneric()), performs: perform)
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
}

// MARK: - SampleFactory

open class SampleFactoryMock: SampleFactory, Mock {
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

    open func fatigue(using transaction: Transaction) throws -> Fatigue {
        addInvocation(.m_fatigue__using_transaction(Parameter<Transaction>.value(`transaction`)))
		let perform = methodPerformValue(.m_fatigue__using_transaction(Parameter<Transaction>.value(`transaction`))) as? (Transaction) -> Void
		perform?(`transaction`)
		var __value: Fatigue
		do {
		    __value = try methodReturnValue(.m_fatigue__using_transaction(Parameter<Transaction>.value(`transaction`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for fatigue(using transaction: Transaction). Use given")
			Failure("Stub return value not specified for fatigue(using transaction: Transaction). Use given")
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
        case m_fatigue__using_transaction(Parameter<Transaction>)
        case m_heartRate__value_date(Parameter<Double>, Parameter<Date>)
        case m_heartRate__value_value(Parameter<Double>)
        case m_heartRate__sample(Parameter<HKQuantitySample>)
        case m_medicationDose__using_transaction(Parameter<Transaction>)
        case m_mood__using_transaction(Parameter<Transaction>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_allTypes, .m_allTypes): return .match

            case (.m_healthKitTypes, .m_healthKitTypes): return .match

            case (.m_activity__using_transaction(let lhsTransaction), .m_activity__using_transaction(let rhsTransaction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTransaction) && !isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				if isCapturing(lhsTransaction) || isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_fatigue__using_transaction(let lhsTransaction), .m_fatigue__using_transaction(let rhsTransaction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTransaction) && !isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				if isCapturing(lhsTransaction) || isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_heartRate__value_date(let lhsValue, let lhsDate), .m_heartRate__value_date(let rhsValue, let rhsDate)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsValue) && !isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "_ value"))
				}


				if !isCapturing(lhsDate) && !isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "_ date"))
				}

				if isCapturing(lhsValue) || isCapturing(rhsValue) {
					comparison = Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsValue, rhsValue, "_ value"))
				}


				if isCapturing(lhsDate) || isCapturing(rhsDate) {
					comparison = Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDate, rhsDate, "_ date"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_heartRate__value_value(let lhsValue), .m_heartRate__value_value(let rhsValue)):
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

            case (.m_heartRate__sample(let lhsSample), .m_heartRate__sample(let rhsSample)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSample) && !isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "_ sample"))
				}

				if isCapturing(lhsSample) || isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "_ sample"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_medicationDose__using_transaction(let lhsTransaction), .m_medicationDose__using_transaction(let rhsTransaction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTransaction) && !isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				if isCapturing(lhsTransaction) || isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_mood__using_transaction(let lhsTransaction), .m_mood__using_transaction(let rhsTransaction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsTransaction) && !isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				if isCapturing(lhsTransaction) || isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_allTypes: return 0
            case .m_healthKitTypes: return 0
            case let .m_activity__using_transaction(p0): return p0.intValue
            case let .m_fatigue__using_transaction(p0): return p0.intValue
            case let .m_heartRate__value_date(p0, p1): return p0.intValue + p1.intValue
            case let .m_heartRate__value_value(p0): return p0.intValue
            case let .m_heartRate__sample(p0): return p0.intValue
            case let .m_medicationDose__using_transaction(p0): return p0.intValue
            case let .m_mood__using_transaction(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_allTypes: return ".allTypes()"
            case .m_healthKitTypes: return ".healthKitTypes()"
            case .m_activity__using_transaction: return ".activity(using:)"
            case .m_fatigue__using_transaction: return ".fatigue(using:)"
            case .m_heartRate__value_date: return ".heartRate(_:_:)"
            case .m_heartRate__value_value: return ".heartRate(value:)"
            case .m_heartRate__sample: return ".heartRate(_:)"
            case .m_medicationDose__using_transaction: return ".medicationDose(using:)"
            case .m_mood__using_transaction: return ".mood(using:)"
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
        public static func fatigue(using transaction: Parameter<Transaction>, willReturn: Fatigue...) -> MethodStub {
            return Given(method: .m_fatigue__using_transaction(`transaction`), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func fatigue(using transaction: Parameter<Transaction>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_fatigue__using_transaction(`transaction`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func fatigue(using transaction: Parameter<Transaction>, willProduce: (StubberThrows<Fatigue>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_fatigue__using_transaction(`transaction`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Fatigue).self)
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
        public static func fatigue(using transaction: Parameter<Transaction>) -> Verify { return Verify(method: .m_fatigue__using_transaction(`transaction`))}
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
        public static func fatigue(using transaction: Parameter<Transaction>, perform: @escaping (Transaction) -> Void) -> Perform {
            return Perform(method: .m_fatigue__using_transaction(`transaction`), performs: perform)
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

// MARK: - SampleUtil

open class SampleUtilMock: SampleUtil, Mock {
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

    open func aggregate(		samples: [Sample],		by aggregationUnit: Calendar.Component,		for attribute: Attribute	) throws -> [Date: [Sample]] {
        addInvocation(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`))) as? ([Sample], Calendar.Component, Attribute) -> Void
		perform?(`samples`, `aggregationUnit`, `attribute`)
		var __value: [Date: [Sample]]
		do {
		    __value = try methodReturnValue(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(Parameter<[Sample]>.value(`samples`), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for aggregate(  samples: [Sample],  by aggregationUnit: Calendar.Component,  for attribute: Attribute ). Use given")
			Failure("Stub return value not specified for aggregate(  samples: [Sample],  by aggregationUnit: Calendar.Component,  for attribute: Attribute ). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func aggregate<SampleType: Sample>(		samples: [SampleType],		by aggregationUnit: Calendar.Component,		for attribute: Attribute	) throws -> [Date: [SampleType]] {
        addInvocation(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`)))
		let perform = methodPerformValue(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`))) as? ([SampleType], Calendar.Component, Attribute) -> Void
		perform?(`samples`, `aggregationUnit`, `attribute`)
		var __value: [Date: [SampleType]]
		do {
		    __value = try methodReturnValue(.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`), Parameter<Attribute>.value(`attribute`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for aggregate<SampleType: Sample>(  samples: [SampleType],  by aggregationUnit: Calendar.Component,  for attribute: Attribute ). Use given")
			Failure("Stub return value not specified for aggregate<SampleType: Sample>(  samples: [SampleType],  by aggregationUnit: Calendar.Component,  for attribute: Attribute ). Use given")
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

    open func sort<SampleType: Sample>(		samples: [SampleType],		by aggregationUnit: Calendar.Component	) throws -> [(date: Date, samples: [SampleType])] {
        addInvocation(.m_sort__samples_samplesby_aggregationUnit_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`)))
		let perform = methodPerformValue(.m_sort__samples_samplesby_aggregationUnit_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`))) as? ([SampleType], Calendar.Component) -> Void
		perform?(`samples`, `aggregationUnit`)
		var __value: [(date: Date, samples: [SampleType])]
		do {
		    __value = try methodReturnValue(.m_sort__samples_samplesby_aggregationUnit_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<Calendar.Component>.value(`aggregationUnit`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for sort<SampleType: Sample>(  samples: [SampleType],  by aggregationUnit: Calendar.Component ). Use given")
			Failure("Stub return value not specified for sort<SampleType: Sample>(  samples: [SampleType],  by aggregationUnit: Calendar.Component ). Use given")
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

    open func sort<SampleType: Sample>(		samples: [SampleType],		by dateType: DateType,		in order: ComparisonResult	) -> [SampleType] {
        addInvocation(.m_sort__samples_samplesby_dateTypein_order_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<DateType>.value(`dateType`), Parameter<ComparisonResult>.value(`order`)))
		let perform = methodPerformValue(.m_sort__samples_samplesby_dateTypein_order_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<DateType>.value(`dateType`), Parameter<ComparisonResult>.value(`order`))) as? ([SampleType], DateType, ComparisonResult) -> Void
		perform?(`samples`, `dateType`, `order`)
		var __value: [SampleType]
		do {
		    __value = try methodReturnValue(.m_sort__samples_samplesby_dateTypein_order_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<DateType>.value(`dateType`), Parameter<ComparisonResult>.value(`order`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for sort<SampleType: Sample>(  samples: [SampleType],  by dateType: DateType,  in order: ComparisonResult ). Use given")
			Failure("Stub return value not specified for sort<SampleType: Sample>(  samples: [SampleType],  by dateType: DateType,  in order: ComparisonResult ). Use given")
		}
		return __value
    }

    open func convertOneDateSamplesToTwoDateSamples(		_ samples: [Sample],		samplesShouldNotBeJoined: (Sample, Sample) -> Bool,		joinSamples: ([Sample], Date, Date) -> Sample	) -> [Sample] {
        addInvocation(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(Parameter<[Sample]>.value(`samples`), Parameter<(Sample, Sample) -> Bool>.any, Parameter<([Sample], Date, Date) -> Sample>.any))
		let perform = methodPerformValue(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(Parameter<[Sample]>.value(`samples`), Parameter<(Sample, Sample) -> Bool>.any, Parameter<([Sample], Date, Date) -> Sample>.any)) as? ([Sample], (Sample, Sample) -> Bool, ([Sample], Date, Date) -> Sample) -> Void
		perform?(`samples`, `samplesShouldNotBeJoined`, `joinSamples`)
		var __value: [Sample]
		do {
		    __value = try methodReturnValue(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(Parameter<[Sample]>.value(`samples`), Parameter<(Sample, Sample) -> Bool>.any, Parameter<([Sample], Date, Date) -> Sample>.any)).casted()
		} catch {
			onFatalFailure("Stub return value not specified for convertOneDateSamplesToTwoDateSamples(  _ samples: [Sample],  samplesShouldNotBeJoined: (Sample, Sample) -> Bool,  joinSamples: ([Sample], Date, Date) -> Sample ). Use given")
			Failure("Stub return value not specified for convertOneDateSamplesToTwoDateSamples(  _ samples: [Sample],  samplesShouldNotBeJoined: (Sample, Sample) -> Bool,  joinSamples: ([Sample], Date, Date) -> Sample ). Use given")
		}
		return __value
    }

    open func convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(		_ samples: [SampleType],		samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool,		joinSamples: ([SampleType], Date, Date) -> SampleType	) -> [SampleType] {
        addInvocation(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<(SampleType, SampleType) -> Bool>.any.wrapAsGeneric(), Parameter<([SampleType], Date, Date) -> SampleType>.any.wrapAsGeneric()))
		let perform = methodPerformValue(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<(SampleType, SampleType) -> Bool>.any.wrapAsGeneric(), Parameter<([SampleType], Date, Date) -> SampleType>.any.wrapAsGeneric())) as? ([SampleType], (SampleType, SampleType) -> Bool, ([SampleType], Date, Date) -> SampleType) -> Void
		perform?(`samples`, `samplesShouldNotBeJoined`, `joinSamples`)
		var __value: [SampleType]
		do {
		    __value = try methodReturnValue(.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(Parameter<[SampleType]>.value(`samples`).wrapAsGeneric(), Parameter<(SampleType, SampleType) -> Bool>.any.wrapAsGeneric(), Parameter<([SampleType], Date, Date) -> SampleType>.any.wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(  _ samples: [SampleType],  samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool,  joinSamples: ([SampleType], Date, Date) -> SampleType ). Use given")
			Failure("Stub return value not specified for convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(  _ samples: [SampleType],  samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool,  joinSamples: ([SampleType], Date, Date) -> SampleType ). Use given")
		}
		return __value
    }

    open func closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(		sample: SampleType1,		in samples: [SampleType2]	) -> SampleType2 {
        addInvocation(.m_closestInTimeTo__sample_samplein_samples_1(Parameter<SampleType1>.value(`sample`).wrapAsGeneric(), Parameter<[SampleType2]>.value(`samples`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_closestInTimeTo__sample_samplein_samples_1(Parameter<SampleType1>.value(`sample`).wrapAsGeneric(), Parameter<[SampleType2]>.value(`samples`).wrapAsGeneric())) as? (SampleType1, [SampleType2]) -> Void
		perform?(`sample`, `samples`)
		var __value: SampleType2
		do {
		    __value = try methodReturnValue(.m_closestInTimeTo__sample_samplein_samples_1(Parameter<SampleType1>.value(`sample`).wrapAsGeneric(), Parameter<[SampleType2]>.value(`samples`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(  sample: SampleType1,  in samples: [SampleType2] ). Use given")
			Failure("Stub return value not specified for closestInTimeTo<SampleType1: Sample, SampleType2: Sample>(  sample: SampleType1,  in samples: [SampleType2] ). Use given")
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

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getOnly__samples_samplesfrom_startDateto_endDate_1(let lhsSamples, let lhsStartdate, let lhsEnddate), .m_getOnly__samples_samplesfrom_startDateto_endDate_1(let rhsSamples, let rhsStartdate, let rhsEnddate)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if !isCapturing(lhsStartdate) && !isCapturing(rhsStartdate) {
					comparison = Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartdate, rhsStartdate, "from startDate"))
				}


				if !isCapturing(lhsEnddate) && !isCapturing(rhsEnddate) {
					comparison = Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnddate, rhsEnddate, "to endDate"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if isCapturing(lhsStartdate) || isCapturing(rhsStartdate) {
					comparison = Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartdate, rhsStartdate, "from startDate"))
				}


				if isCapturing(lhsEnddate) || isCapturing(rhsEnddate) {
					comparison = Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnddate, rhsEnddate, "to endDate"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getOnly__samples_samplesfrom_startDateto_endDate_2(let lhsSamples, let lhsStartdate, let lhsEnddate), .m_getOnly__samples_samplesfrom_startDateto_endDate_2(let rhsSamples, let rhsStartdate, let rhsEnddate)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if !isCapturing(lhsStartdate) && !isCapturing(rhsStartdate) {
					comparison = Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartdate, rhsStartdate, "from startDate"))
				}


				if !isCapturing(lhsEnddate) && !isCapturing(rhsEnddate) {
					comparison = Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnddate, rhsEnddate, "to endDate"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if isCapturing(lhsStartdate) || isCapturing(rhsStartdate) {
					comparison = Parameter.compare(lhs: lhsStartdate, rhs: rhsStartdate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsStartdate, rhsStartdate, "from startDate"))
				}


				if isCapturing(lhsEnddate) || isCapturing(rhsEnddate) {
					comparison = Parameter.compare(lhs: lhsEnddate, rhs: rhsEnddate, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEnddate, rhsEnddate, "to endDate"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_sample__sampleoccursOnOneOf_daysOfWeek(let lhsSample, let lhsDaysofweek), .m_sample__sampleoccursOnOneOf_daysOfWeek(let rhsSample, let rhsDaysofweek)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSample) && !isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "_ sample"))
				}


				if !isCapturing(lhsDaysofweek) && !isCapturing(rhsDaysofweek) {
					comparison = Parameter.compare(lhs: lhsDaysofweek, rhs: rhsDaysofweek, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDaysofweek, rhsDaysofweek, "occursOnOneOf daysOfWeek"))
				}

				if isCapturing(lhsSample) || isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "_ sample"))
				}


				if isCapturing(lhsDaysofweek) || isCapturing(rhsDaysofweek) {
					comparison = Parameter.compare(lhs: lhsDaysofweek, rhs: rhsDaysofweek, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDaysofweek, rhsDaysofweek, "occursOnOneOf daysOfWeek"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(let lhsSamples, let lhsAggregationunit, let lhsAttribute), .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1(let rhsSamples, let rhsAggregationunit, let rhsAttribute)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if !isCapturing(lhsAggregationunit) && !isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "by aggregationUnit"))
				}


				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if isCapturing(lhsAggregationunit) || isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "by aggregationUnit"))
				}


				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(let lhsSamples, let lhsAggregationunit, let lhsAttribute), .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2(let rhsSamples, let rhsAggregationunit, let rhsAttribute)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if !isCapturing(lhsAggregationunit) && !isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "by aggregationUnit"))
				}


				if !isCapturing(lhsAttribute) && !isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if isCapturing(lhsAggregationunit) || isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "by aggregationUnit"))
				}


				if isCapturing(lhsAttribute) || isCapturing(rhsAttribute) {
					comparison = Parameter.compare(lhs: lhsAttribute, rhs: rhsAttribute, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAttribute, rhsAttribute, "for attribute"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_sort__samples_samplesby_aggregationUnit_1(let lhsSamples, let lhsAggregationunit), .m_sort__samples_samplesby_aggregationUnit_1(let rhsSamples, let rhsAggregationunit)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if !isCapturing(lhsAggregationunit) && !isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "by aggregationUnit"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if isCapturing(lhsAggregationunit) || isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "by aggregationUnit"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_sort__samples_samplesby_aggregationUnit_2(let lhsSamples, let lhsAggregationunit), .m_sort__samples_samplesby_aggregationUnit_2(let rhsSamples, let rhsAggregationunit)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if !isCapturing(lhsAggregationunit) && !isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "by aggregationUnit"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if isCapturing(lhsAggregationunit) || isCapturing(rhsAggregationunit) {
					comparison = Parameter.compare(lhs: lhsAggregationunit, rhs: rhsAggregationunit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsAggregationunit, rhsAggregationunit, "by aggregationUnit"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_sort__samples_samplesby_dateTypein_order_1(let lhsSamples, let lhsDatetype, let lhsOrder), .m_sort__samples_samplesby_dateTypein_order_1(let rhsSamples, let rhsDatetype, let rhsOrder)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if !isCapturing(lhsDatetype) && !isCapturing(rhsDatetype) {
					comparison = Parameter.compare(lhs: lhsDatetype, rhs: rhsDatetype, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatetype, rhsDatetype, "by dateType"))
				}


				if !isCapturing(lhsOrder) && !isCapturing(rhsOrder) {
					comparison = Parameter.compare(lhs: lhsOrder, rhs: rhsOrder, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOrder, rhsOrder, "in order"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if isCapturing(lhsDatetype) || isCapturing(rhsDatetype) {
					comparison = Parameter.compare(lhs: lhsDatetype, rhs: rhsDatetype, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatetype, rhsDatetype, "by dateType"))
				}


				if isCapturing(lhsOrder) || isCapturing(rhsOrder) {
					comparison = Parameter.compare(lhs: lhsOrder, rhs: rhsOrder, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOrder, rhsOrder, "in order"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_sort__samples_samplesby_dateTypein_order_2(let lhsSamples, let lhsDatetype, let lhsOrder), .m_sort__samples_samplesby_dateTypein_order_2(let rhsSamples, let rhsDatetype, let rhsOrder)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if !isCapturing(lhsDatetype) && !isCapturing(rhsDatetype) {
					comparison = Parameter.compare(lhs: lhsDatetype, rhs: rhsDatetype, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatetype, rhsDatetype, "by dateType"))
				}


				if !isCapturing(lhsOrder) && !isCapturing(rhsOrder) {
					comparison = Parameter.compare(lhs: lhsOrder, rhs: rhsOrder, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOrder, rhsOrder, "in order"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "samples"))
				}


				if isCapturing(lhsDatetype) || isCapturing(rhsDatetype) {
					comparison = Parameter.compare(lhs: lhsDatetype, rhs: rhsDatetype, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDatetype, rhsDatetype, "by dateType"))
				}


				if isCapturing(lhsOrder) || isCapturing(rhsOrder) {
					comparison = Parameter.compare(lhs: lhsOrder, rhs: rhsOrder, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOrder, rhsOrder, "in order"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(let lhsSamples, let lhsSamplesshouldnotbejoined, let lhsJoinsamples), .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1(let rhsSamples, let rhsSamplesshouldnotbejoined, let rhsJoinsamples)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "_ samples"))
				}


				if !isCapturing(lhsSamplesshouldnotbejoined) && !isCapturing(rhsSamplesshouldnotbejoined) {
					comparison = Parameter.compare(lhs: lhsSamplesshouldnotbejoined, rhs: rhsSamplesshouldnotbejoined, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamplesshouldnotbejoined, rhsSamplesshouldnotbejoined, "samplesShouldNotBeJoined"))
				}


				if !isCapturing(lhsJoinsamples) && !isCapturing(rhsJoinsamples) {
					comparison = Parameter.compare(lhs: lhsJoinsamples, rhs: rhsJoinsamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsJoinsamples, rhsJoinsamples, "joinSamples"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "_ samples"))
				}


				if isCapturing(lhsSamplesshouldnotbejoined) || isCapturing(rhsSamplesshouldnotbejoined) {
					comparison = Parameter.compare(lhs: lhsSamplesshouldnotbejoined, rhs: rhsSamplesshouldnotbejoined, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamplesshouldnotbejoined, rhsSamplesshouldnotbejoined, "samplesShouldNotBeJoined"))
				}


				if isCapturing(lhsJoinsamples) || isCapturing(rhsJoinsamples) {
					comparison = Parameter.compare(lhs: lhsJoinsamples, rhs: rhsJoinsamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsJoinsamples, rhsJoinsamples, "joinSamples"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(let lhsSamples, let lhsSamplesshouldnotbejoined, let lhsJoinsamples), .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2(let rhsSamples, let rhsSamplesshouldnotbejoined, let rhsJoinsamples)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "_ samples"))
				}


				if !isCapturing(lhsSamplesshouldnotbejoined) && !isCapturing(rhsSamplesshouldnotbejoined) {
					comparison = Parameter.compare(lhs: lhsSamplesshouldnotbejoined, rhs: rhsSamplesshouldnotbejoined, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamplesshouldnotbejoined, rhsSamplesshouldnotbejoined, "samplesShouldNotBeJoined"))
				}


				if !isCapturing(lhsJoinsamples) && !isCapturing(rhsJoinsamples) {
					comparison = Parameter.compare(lhs: lhsJoinsamples, rhs: rhsJoinsamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsJoinsamples, rhsJoinsamples, "joinSamples"))
				}

				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "_ samples"))
				}


				if isCapturing(lhsSamplesshouldnotbejoined) || isCapturing(rhsSamplesshouldnotbejoined) {
					comparison = Parameter.compare(lhs: lhsSamplesshouldnotbejoined, rhs: rhsSamplesshouldnotbejoined, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamplesshouldnotbejoined, rhsSamplesshouldnotbejoined, "samplesShouldNotBeJoined"))
				}


				if isCapturing(lhsJoinsamples) || isCapturing(rhsJoinsamples) {
					comparison = Parameter.compare(lhs: lhsJoinsamples, rhs: rhsJoinsamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsJoinsamples, rhsJoinsamples, "joinSamples"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_closestInTimeTo__sample_samplein_samples_1(let lhsSample, let lhsSamples), .m_closestInTimeTo__sample_samplein_samples_1(let rhsSample, let rhsSamples)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSample) && !isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "sample"))
				}


				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "in samples"))
				}

				if isCapturing(lhsSample) || isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "sample"))
				}


				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "in samples"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_closestInTimeTo__sample_samplein_samples_2(let lhsSample, let lhsSamples), .m_closestInTimeTo__sample_samplein_samples_2(let rhsSample, let rhsSamples)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSample) && !isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "sample"))
				}


				if !isCapturing(lhsSamples) && !isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "in samples"))
				}

				if isCapturing(lhsSample) || isCapturing(rhsSample) {
					comparison = Parameter.compare(lhs: lhsSample, rhs: rhsSample, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample, rhsSample, "sample"))
				}


				if isCapturing(lhsSamples) || isCapturing(rhsSamples) {
					comparison = Parameter.compare(lhs: lhsSamples, rhs: rhsSamples, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSamples, rhsSamples, "in samples"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_distance__between_sample1and_sample2in_unit(let lhsSample1, let lhsSample2, let lhsUnit), .m_distance__between_sample1and_sample2in_unit(let rhsSample1, let rhsSample2, let rhsUnit)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSample1) && !isCapturing(rhsSample1) {
					comparison = Parameter.compare(lhs: lhsSample1, rhs: rhsSample1, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample1, rhsSample1, "between sample1"))
				}


				if !isCapturing(lhsSample2) && !isCapturing(rhsSample2) {
					comparison = Parameter.compare(lhs: lhsSample2, rhs: rhsSample2, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample2, rhsSample2, "and sample2"))
				}


				if !isCapturing(lhsUnit) && !isCapturing(rhsUnit) {
					comparison = Parameter.compare(lhs: lhsUnit, rhs: rhsUnit, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUnit, rhsUnit, "in unit"))
				}

				if isCapturing(lhsSample1) || isCapturing(rhsSample1) {
					comparison = Parameter.compare(lhs: lhsSample1, rhs: rhsSample1, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample1, rhsSample1, "between sample1"))
				}


				if isCapturing(lhsSample2) || isCapturing(rhsSample2) {
					comparison = Parameter.compare(lhs: lhsSample2, rhs: rhsSample2, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSample2, rhsSample2, "and sample2"))
				}


				if isCapturing(lhsUnit) || isCapturing(rhsUnit) {
					comparison = Parameter.compare(lhs: lhsUnit, rhs: rhsUnit, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsUnit, rhsUnit, "in unit"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
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
        func assertionName() -> String {
            switch self {
            case .m_getOnly__samples_samplesfrom_startDateto_endDate_1: return ".getOnly(samples:from:to:)"
            case .m_getOnly__samples_samplesfrom_startDateto_endDate_2: return ".getOnly(samples:from:to:)"
            case .m_sample__sampleoccursOnOneOf_daysOfWeek: return ".sample(_:occursOnOneOf:)"
            case .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_1: return ".aggregate(samples:by:for:)"
            case .m_aggregate__samples_samplesby_aggregationUnitfor_attribute_2: return ".aggregate(samples:by:for:)"
            case .m_sort__samples_samplesby_aggregationUnit_1: return ".sort(samples:by:)"
            case .m_sort__samples_samplesby_aggregationUnit_2: return ".sort(samples:by:)"
            case .m_sort__samples_samplesby_dateTypein_order_1: return ".sort(samples:by:in:)"
            case .m_sort__samples_samplesby_dateTypein_order_2: return ".sort(samples:by:in:)"
            case .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_1: return ".convertOneDateSamplesToTwoDateSamples(_:samplesShouldNotBeJoined:joinSamples:)"
            case .m_convertOneDateSamplesToTwoDateSamples__samplessamplesShouldNotBeJoined_samplesShouldNotBeJoinedjoinSamples_joinSamples_2: return ".convertOneDateSamplesToTwoDateSamples(_:samplesShouldNotBeJoined:joinSamples:)"
            case .m_closestInTimeTo__sample_samplein_samples_1: return ".closestInTimeTo(sample:in:)"
            case .m_closestInTimeTo__sample_samplein_samples_2: return ".closestInTimeTo(sample:in:)"
            case .m_distance__between_sample1and_sample2in_unit: return ".distance(between:and:in:)"
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
        public static func aggregate<SampleType:Sample>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, for attribute: Parameter<Attribute>, willThrow: Error...) -> MethodStub {
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
        public static func sort<SampleType:Sample>(samples: Parameter<[SampleType]>, by aggregationUnit: Parameter<Calendar.Component>, willThrow: Error...) -> MethodStub {
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

// MARK: - TagDAO

open class TagDAOMock: TagDAO, Mock {
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






    open func getTag(named name: String, using transaction: Transaction?) throws -> Tag? {
        addInvocation(.m_getTag__named_nameusing_transaction(Parameter<String>.value(`name`), Parameter<Transaction?>.value(`transaction`)))
		let perform = methodPerformValue(.m_getTag__named_nameusing_transaction(Parameter<String>.value(`name`), Parameter<Transaction?>.value(`transaction`))) as? (String, Transaction?) -> Void
		perform?(`name`, `transaction`)
		var __value: Tag? = nil
		do {
		    __value = try methodReturnValue(.m_getTag__named_nameusing_transaction(Parameter<String>.value(`name`), Parameter<Transaction?>.value(`transaction`))).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    open func getOrCreateTag(named name: String) throws -> Tag {
        addInvocation(.m_getOrCreateTag__named_name(Parameter<String>.value(`name`)))
		let perform = methodPerformValue(.m_getOrCreateTag__named_name(Parameter<String>.value(`name`))) as? (String) -> Void
		perform?(`name`)
		var __value: Tag
		do {
		    __value = try methodReturnValue(.m_getOrCreateTag__named_name(Parameter<String>.value(`name`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getOrCreateTag(named name: String). Use given")
			Failure("Stub return value not specified for getOrCreateTag(named name: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getAllTags() throws -> [Tag] {
        addInvocation(.m_getAllTags)
		let perform = methodPerformValue(.m_getAllTags) as? () -> Void
		perform?()
		var __value: [Tag]
		do {
		    __value = try methodReturnValue(.m_getAllTags).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getAllTags(). Use given")
			Failure("Stub return value not specified for getAllTags(). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getTag__named_nameusing_transaction(Parameter<String>, Parameter<Transaction?>)
        case m_getOrCreateTag__named_name(Parameter<String>)
        case m_getAllTags

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getTag__named_nameusing_transaction(let lhsName, let lhsTransaction), .m_getTag__named_nameusing_transaction(let rhsName, let rhsTransaction)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "named name"))
				}


				if !isCapturing(lhsTransaction) && !isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "named name"))
				}


				if isCapturing(lhsTransaction) || isCapturing(rhsTransaction) {
					comparison = Parameter.compare(lhs: lhsTransaction, rhs: rhsTransaction, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsTransaction, rhsTransaction, "using transaction"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getOrCreateTag__named_name(let lhsName), .m_getOrCreateTag__named_name(let rhsName)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsName) && !isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "named name"))
				}

				if isCapturing(lhsName) || isCapturing(rhsName) {
					comparison = Parameter.compare(lhs: lhsName, rhs: rhsName, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsName, rhsName, "named name"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_getAllTags, .m_getAllTags): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getTag__named_nameusing_transaction(p0, p1): return p0.intValue + p1.intValue
            case let .m_getOrCreateTag__named_name(p0): return p0.intValue
            case .m_getAllTags: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getTag__named_nameusing_transaction: return ".getTag(named:using:)"
            case .m_getOrCreateTag__named_name: return ".getOrCreateTag(named:)"
            case .m_getAllTags: return ".getAllTags()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getTag(named name: Parameter<String>, using transaction: Parameter<Transaction?>, willReturn: Tag?...) -> MethodStub {
            return Given(method: .m_getTag__named_nameusing_transaction(`name`, `transaction`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getOrCreateTag(named name: Parameter<String>, willReturn: Tag...) -> MethodStub {
            return Given(method: .m_getOrCreateTag__named_name(`name`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getAllTags(willReturn: [Tag]...) -> MethodStub {
            return Given(method: .m_getAllTags, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getTag(named name: Parameter<String>, using transaction: Parameter<Transaction?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getTag__named_nameusing_transaction(`name`, `transaction`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getTag(named name: Parameter<String>, using transaction: Parameter<Transaction?>, willProduce: (StubberThrows<Tag?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getTag__named_nameusing_transaction(`name`, `transaction`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Tag?).self)
			willProduce(stubber)
			return given
        }
        public static func getOrCreateTag(named name: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getOrCreateTag__named_name(`name`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getOrCreateTag(named name: Parameter<String>, willProduce: (StubberThrows<Tag>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getOrCreateTag__named_name(`name`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Tag).self)
			willProduce(stubber)
			return given
        }
        public static func getAllTags(willThrow: Error...) -> MethodStub {
            return Given(method: .m_getAllTags, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getAllTags(willProduce: (StubberThrows<[Tag]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getAllTags, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Tag]).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getTag(named name: Parameter<String>, using transaction: Parameter<Transaction?>) -> Verify { return Verify(method: .m_getTag__named_nameusing_transaction(`name`, `transaction`))}
        public static func getOrCreateTag(named name: Parameter<String>) -> Verify { return Verify(method: .m_getOrCreateTag__named_name(`name`))}
        public static func getAllTags() -> Verify { return Verify(method: .m_getAllTags)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getTag(named name: Parameter<String>, using transaction: Parameter<Transaction?>, perform: @escaping (String, Transaction?) -> Void) -> Perform {
            return Perform(method: .m_getTag__named_nameusing_transaction(`name`, `transaction`), performs: perform)
        }
        public static func getOrCreateTag(named name: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getOrCreateTag__named_name(`name`), performs: perform)
        }
        public static func getAllTags(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getAllTags, performs: perform)
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

