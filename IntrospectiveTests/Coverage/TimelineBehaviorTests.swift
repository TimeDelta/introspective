import XCTest
import UIKit
import SwiftyMocky
import SampleFetchers
@testable import Introspective
@testable import Common
@testable import DependencyInjection
@testable import Samples

final class TimelineBehaviorTests: UnitTest {
    private var controller: TimelineTableViewControllerImpl?
    private var factory: TimelineTestFetchers!
    private var work: DispatchGroup!
    private let base = Date(timeIntervalSince1970: 1_700_000_000)

    override func setUp() {
        super.setUp()
        factory = TimelineTestFetchers()
        work = DispatchGroup()
        Given(injectionProvider, .get(.value(CalendarUtil.self), willReturn: CalendarUtilImpl()))
        Given(injectionProvider, .get(.value(MoodUiUtil.self), willReturn: MoodUiUtilImpl()))
        Matcher.default.register(FatigueUiUtil.Protocol.self) { _, _ in true }
        Given(injectionProvider, .get(.value(FatigueUiUtil.self), willReturn: FatigueUiUtilImpl()))
        Given(mockUserDefaultsUtil, .bool(forKey: .any, willReturn: false))
        Given(mockUserDefaultsUtil, .bool(forKey: .value(.moodEnabledOnTimeline), willReturn: true))
        Given(mockUiUtil, .setBackButton(for: .any, title: .any, action: .any, willReturn: UIBarButtonItem()))
        DependencyInjector.register([TimelineFetcherProvider(factory)])
        let workers = work!
        let queue = DispatchQueue(label: "timeline coverage workers", attributes: .concurrent,
                                  autoreleaseFrequency: .workItem)
        Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in
            workers.enter()
            queue.async {
                autoreleasepool { code() }
                workers.leave()
            }
        }))
    }

    override func tearDown() {
        XCTAssertEqual(work.wait(timeout: .now() + 5), .success, "Timeline workers must finish before mocks are replaced")
        if let controller = controller {
            NotificationCenter.default.removeObserver(controller)
            controller.tableView.dataSource = nil
            controller.tableView.delegate = nil
        }
        mockAsyncUtil.resetMock()
        mockUiUtil.resetMock()
        controller = nil
        factory = nil
        super.tearDown()
    }

    private func mood(_ date: Date, rating: Double = 4, note: String? = nil) -> MoodMock {
        let sample = MoodMock()
        Given(sample, .date(getter: date))
        Given(sample, .minRating(getter: 0))
        Given(sample, .maxRating(getter: 10))
        Given(sample, .rating(getter: rating))
        Given(sample, .note(getter: note))
        return sample
    }

    private func fatigue(_ date: Date) -> TimelineFatigueMock {
        let sample = TimelineFatigueMock()
        Given(sample, .date(getter: date))
        Given(sample, .minRating(getter: 0))
        Given(sample, .maxRating(getter: 10))
        Given(sample, .rating(getter: 4))
        Given(sample, .note(getter: nil))
        return sample
    }

    private func open(from min: Date? = nil, to max: Date? = nil) -> TimelineTableViewControllerImpl {
        let result = UIStoryboard(name: "Timeline", bundle: nil).instantiateInitialViewController() as! TimelineTableViewControllerImpl
        result.minDate = min
        result.maxDate = max
        controller = result
        result.loadViewIfNeeded()
        return result
    }

    private func finishFetch() {
        let finished = expectation(description: "All timeline fetch workers finished")
        work.notify(queue: .main) { finished.fulfill() }
        wait(for: [finished], timeout: 5)
    }

    private func cell(_ section: Int = 0, _ row: Int = 0) -> TimelineTableViewCellImpl {
        let controller = controller!
        return controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: row, section: section)) as! TimelineTableViewCellImpl
    }

    private func dataTypeChooser(for controller: TimelineTableViewControllerImpl) -> MultiSelectAttributeValueViewController {
        let chooser = MultiSelectAttributeValueViewController()
        Given(mockUiUtil, .controller(named: .value("multiSelectAttribute"), from: .value("AttributeList"),
                                     as: .any, willReturn: chooser))
        controller.chooseDataTypesButtonPressed(self)
        return chooser
    }

    func testExpandedCatalogOnlyOffersFetchableTimelineSourcesAndPreservesLegacyOrderAndSelections() {
        let catalogType: Sample.Type = HealthQuantity<HealthQuantityBodyFatPercentageDefinition>.self
        let expandedTypes: [Sample.Type] = [catalogType, Workout.self, Weight.self, MoodImpl.self, Steps.self]
        Given(mockSampleFactory, .allTypes(willReturn: expandedTypes))
        Given(mockUserDefaultsUtil, .bool(forKey: .value(.weightEnabledOnTimeline), willReturn: true))
        let controller = open()
        finishFetch()

        let chooser = dataTypeChooser(for: controller)
        let supported: [Sample.Type] = [Activity.self, BloodPressure.self, BodyMassIndex.self, DietarySugar.self,
            FatigueImpl.self, HeartRate.self, LeanBodyMass.self, MedicationDose.self, MoodImpl.self, PainImpl.self,
            RestingHeartRate.self, SexualActivity.self, Sleep.self, Steps.self, Weight.self]
        XCTAssertEqual(chooser.multiSelectAttribute.possibleValues as? [String], supported.map { $0.name })
        XCTAssertEqual(chooser.initialValue as? [String], [MoodImpl.name, Weight.name])
        Verify(mockSampleFactory, .never, .allTypes())

        // Restricting Timeline must leave catalog types available in the shared
        // chooser used by queries and graph customization.
        let shared = UIStoryboard(name: "Util", bundle: Bundle(for: ChooseSampleTypeViewControllerImpl.self))
            .instantiateViewController(withIdentifier: "chooseSampleType") as! ChooseSampleTypeViewControllerImpl
        shared.selectedSampleType = catalogType
        shared.loadViewIfNeeded()
        XCTAssertEqual(shared.pickerView(shared.sampleTypePicker, numberOfRowsInComponent: 0), expandedTypes.count)
        XCTAssertEqual(shared.sampleTypePicker.selectedRow(inComponent: 0), 0)
        XCTAssertTrue(shared.selectedSampleType.map { $0 == catalogType } ?? false)
    }

    func testStaleUnsupportedTimelineSelectionsAreDiscardedWhileSupportedSourcesStillFetch() {
        let catalogType: Sample.Type = HealthQuantity<HealthQuantityBodyFatPercentageDefinition>.self
        let enabled = [catalogType.name, MoodImpl.name, Workout.name, "Unknown data type"]
        Given(mockUiUtil, .value(for: .value(.attributeValue), from: .any, keyIsOptional: .any, willReturn: enabled))
        let controller = open()
        finishFetch()

        NotificationCenter.default.post(name: TimelineTableViewControllerImpl.enabledDataTypesChanged, object: nil)
        finishFetch()

        XCTAssertEqual(factory.moods.calls.count, 2)
        XCTAssertEqual(factory.disabled.calls.count, 0)
        XCTAssertEqual(dataTypeChooser(for: controller).initialValue as? [String], [MoodImpl.name])
    }

    func testEmptyResultsFinishLoadingWithoutLeavingTheSpinnerRow() {
        let controller = open()
        finishFetch()
        XCTAssertEqual(controller.numberOfSections(in: controller.tableView), 0)
        XCTAssertEqual(factory.moods.calls.count, 1)
    }

    func testDisabledSourcesAreNotFetched() {
        Given(mockUserDefaultsUtil, .bool(forKey: .value(.moodEnabledOnTimeline), willReturn: false))
        let controller = open()
        finishFetch()
        XCTAssertEqual(factory.moods.calls.count, 0)
        XCTAssertEqual(factory.disabled.calls.count, 0)
        XCTAssertEqual(controller.numberOfSections(in: controller.tableView), 0)
    }

    func testDateBoundsArePassedToFetcherAndAppliedInclusivelyToReturnedEvents() {
        let min = base, max = base.addingTimeInterval(600)
        let samples = [mood(min.addingTimeInterval(-1)), mood(min), mood(max), mood(max.addingTimeInterval(1))]
        factory.moods.handler = { _, _ in samples }
        let controller = open(from: min, to: max)
        finishFetch()
        XCTAssertEqual(factory.moods.calls.first?.0, min)
        XCTAssertEqual(factory.moods.calls.first?.1, max)
        XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 0), 2)
        XCTAssertEqual(cell(0, 0).date, max)
        XCTAssertEqual(cell(0, 1).date, min)
    }

    func testUnsortedMoodsAreGroupedByDayWithNewestDayAndEventFirst() {
        let calendar = Calendar.autoupdatingCurrent
        let day = calendar.startOfDay(for: base)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: day)!.addingTimeInterval(3600)
        let morning = day.addingTimeInterval(3600), evening = day.addingTimeInterval(7200)
        let samples = [mood(morning), mood(yesterday), mood(evening)]
        factory.moods.handler = { _, _ in samples }
        let controller = open()
        finishFetch()
        XCTAssertEqual(controller.numberOfSections(in: controller.tableView), 2)
        XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 0), 2)
        XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 1), 1)
        XCTAssertEqual(cell(0, 0).date, evening)
        XCTAssertEqual(cell(0, 1).date, morning)
        XCTAssertEqual(cell(1, 0).date, yesterday)
    }

    func testMoodEventPreservesCustomScaleRatingAndUnicodeNote() {
        let sample = mood(base, rating: 7.5, note: "Calm 🧠\nafter a walk")
        factory.moods.handler = { _, _ in [sample] }
        _ = open()
        finishFetch()
        XCTAssertEqual(cell().date, base)
        XCTAssertEqual(cell().descriptions, ["🧠 Mood: 7.5 (scale of 0 - 10)", "- Note: Calm 🧠\nafter a walk"])
    }

    func testEmptyMoodNotesDoNotCreateEmptyDescriptionRows() {
        let sample = mood(base, note: "")
        factory.moods.handler = { _, _ in [sample] }
        _ = open()
        finishFetch()
        XCTAssertEqual(cell().descriptions.count, 1)
    }

    func testFetcherFailureCompletesRatherThanDeadlockingTimeline() {
        factory.moods.handler = { _, _ in throw GenericError("source unavailable") }
        let controller = open()
        finishFetch()
        XCTAssertEqual(controller.numberOfSections(in: controller.tableView), 0)
    }

    func testOneFailedSourceDoesNotDiscardHealthySourceEvents() {
        Given(mockUserDefaultsUtil, .bool(forKey: .value(.fatigueEnabledOnTimeline), willReturn: true))
        factory.moods.handler = { _, _ in throw GenericError("moods unavailable") }
        let healthy = fatigue(base)
        factory.fatigue.handler = { _, _ in [healthy] }
        let controller = open()
        finishFetch()
        XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 0), 1)
        XCTAssertTrue(cell().descriptions[0].contains("Fatigue"))
    }

    func testConcurrentSourcesKeepAllEventsAndSortTheirCombinedResults() {
        Given(mockUserDefaultsUtil, .bool(forKey: .value(.fatigueEnabledOnTimeline), willReturn: true))
        let moods = (0..<100).map { mood(base.addingTimeInterval(Double($0 * 2))) }
        let fatigue = (0..<100).map { self.fatigue(base.addingTimeInterval(Double($0 * 2 + 1))) }
        let rendezvous = DispatchGroup()
        rendezvous.enter(); rendezvous.enter()
        factory.moods.handler = { _, _ in
            rendezvous.leave()
            XCTAssertEqual(rendezvous.wait(timeout: .now() + 3), .success)
            return moods
        }
        factory.fatigue.handler = { _, _ in
            rendezvous.leave()
            XCTAssertEqual(rendezvous.wait(timeout: .now() + 3), .success)
            return fatigue
        }
        let controller = open()
        finishFetch()
        XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 0), 200)
        XCTAssertEqual(cell(0, 0).date, base.addingTimeInterval(199))
        XCTAssertEqual(cell(0, 199).date, base)
    }

    func testPreviousAndNextDayPreserveTheSelectedTimeRangeAndRefreshSources() {
        let start = base, end = base.addingTimeInterval(600)
        let controller = open(from: start, to: end)
        finishFetch()
        controller.previousDateRangeButtonPressed(self)
        finishFetch()
        XCTAssertEqual(controller.minDate, Calendar.current.date(byAdding: .day, value: -1, to: start))
        XCTAssertEqual(controller.maxDate, Calendar.current.date(byAdding: .day, value: -1, to: end))
        controller.nextDateRangeButtonPressed(self)
        finishFetch()
        XCTAssertEqual(controller.minDate, start)
        XCTAssertEqual(controller.maxDate, end)
        XCTAssertEqual(factory.moods.calls.count, 3)
    }

    func testUnboundedRangeDisablesDatePagingAndDisplaysFilterPrompt() {
        let controller = open()
        finishFetch()
        XCTAssertFalse(controller.previousDateRangeButton.isEnabled)
        XCTAssertFalse(controller.nextDateRangeButton.isEnabled)
        XCTAssertEqual(controller.dateRangeButton.title, "Filter Dates")
    }

    func testSupersededQueuedFetchIsSkippedAndNewRequestKeepsItsDateSnapshot() {
        var jobs = [() -> Void]()
        Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in jobs.append(code) }))
        let subject = open(from: base, to: base.addingTimeInterval(600))
        subject.nextDateRangeButtonPressed(self)
        let requestedMin = subject.minDate, requestedMax = subject.maxDate
        // Changing properties after scheduling must not change the request's bounds.
        subject.minDate = nil; subject.maxDate = nil
        XCTAssertEqual(jobs.count, 2)
        jobs.forEach { $0() }
        finishFetch()
        XCTAssertEqual(factory.moods.calls.count, 1)
        XCTAssertEqual(factory.moods.calls.first?.0, requestedMin)
        XCTAssertEqual(factory.moods.calls.first?.1, requestedMax)
    }

    func testSlowPreviousRequestCannotReplaceNewerRows() {
        let oldStarted = expectation(description: "Old fetch entered")
        let releaseOld = DispatchSemaphore(value: 0)
        let oldDate = base, newDate = base.addingTimeInterval(86_400)
        let oldMood = mood(oldDate), newMood = mood(newDate)
        factory.moods.handler = { min, _ in
            if min == oldDate {
                oldStarted.fulfill()
                XCTAssertEqual(releaseOld.wait(timeout: .now() + 5), .success)
                return [oldMood]
            }
            return [newMood]
        }
        let subject = open(from: oldDate, to: oldDate.addingTimeInterval(600))
        wait(for: [oldStarted], timeout: 5)
        // Run the replacement synchronously while the previous source remains blocked.
        Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in code() }))
        subject.nextDateRangeButtonPressed(self)
        let published = expectation(description: "Replacement published")
        DispatchQueue.main.async { published.fulfill() }
        wait(for: [published], timeout: 5)
        XCTAssertEqual(cell().date, newDate)
        releaseOld.signal()
        finishFetch()
        XCTAssertEqual(cell().date, newDate)
    }

    func testPersistenceRefreshDiscardsQueuedSamplesBeforeObjectsAreInvalidated() {
        var jobs = [() -> Void]()
        Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in jobs.append(code) }))
        let subject = open()
        NotificationCenter.default.post(name: NotificationName.persistenceLayerWillRefresh.toName(), object: nil)
        jobs.forEach { $0() }
        finishFetch()
        XCTAssertEqual(factory.moods.calls.count, 0)
        XCTAssertEqual(subject.numberOfSections(in: subject.tableView), 1, "Remain loading until the new store is ready")
    }

    func testAbandoningControllerCancelsWorkersBeforeTheyReadSources() {
        var jobs = [() -> Void]()
        Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in jobs.append(code) }))
        weak var released: TimelineTableViewControllerImpl?
        autoreleasepool {
            let subject = TimelineTableViewControllerImpl(style: .plain)
            subject.previousDateRangeButton = UIBarButtonItem()
            subject.dateRangeButton = UIBarButtonItem()
            subject.nextDateRangeButton = UIBarButtonItem()
            released = subject
            subject.loadViewIfNeeded()
            mockUiUtil.resetMock()
        }
        XCTAssertNil(released)
        jobs.forEach { $0() }
        finishFetch()
        XCTAssertEqual(factory.moods.calls.count, 0)
    }

    func testRealCoreDataFetcherRunsOnMainWhileTimelineRemainsResponsive() throws {
        let productionFactory: SampleFetcherFactory = try SampleFetchersInjectionProvider().get(SampleFetcherFactory.self)
        factory.moodFetcherOverride = productionFactory.moodSampleFetcher()
        let sample = mood(base)
        Given(mockMoodDAO, .getMoods(from: .any, to: .any, willReturn: [sample]))
        Perform(mockMoodDAO, .getMoods(from: .any, to: .any, perform: { _, _ in
            XCTAssertTrue(Thread.isMainThread, "The database's main context must only be fetched on its owner queue")
        }))
        _ = open()
        finishFetch()
        XCTAssertEqual(cell().date, base)
        Verify(mockMoodDAO, .once, .getMoods(from: .any, to: .any))
    }

    func testPoppedTimelineIgnoresFurtherRefreshNotifications() {
        var jobs = [() -> Void]()
        Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in jobs.append(code) }))
        let subject = open()
        subject.goBack()
        NotificationCenter.default.post(name: NotificationName.persistenceLayerDidRefresh.toName(), object: nil)
        jobs.forEach { $0() }
        finishFetch()
        XCTAssertEqual(jobs.count, 1)
        XCTAssertEqual(factory.moods.calls.count, 0)
    }

    func testStaleTableIndexPathsAreIgnoredWhenRefreshRemovesAllSections() {
        let sample = mood(base)
        factory.moods.handler = { _, _ in [sample] }
        let subject = open()
        finishFetch()
        XCTAssertEqual(subject.numberOfSections(in: subject.tableView), 1)
        factory.moods.handler = { _, _ in [] }
        NotificationCenter.default.post(name: TimelineTableViewControllerImpl.sampleChanged, object: nil)
        finishFetch()
        XCTAssertEqual(subject.numberOfSections(in: subject.tableView), 0)
        XCTAssertEqual(subject.tableView(subject.tableView, numberOfRowsInSection: 0), 0)
        XCTAssertNil(subject.tableView(subject.tableView, titleForHeaderInSection: 0))
        subject.tableView(subject.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    }

    func testQueuedTimelineRefreshesDoNotRetainAnAbandonedController() {
        Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in code() }))
        weak var released: TimelineTableViewControllerImpl?
        autoreleasepool {
            let subject = TimelineTableViewControllerImpl(style: .plain)
            subject.previousDateRangeButton = UIBarButtonItem()
            subject.dateRangeButton = UIBarButtonItem()
            subject.nextDateRangeButton = UIBarButtonItem()
            released = subject
            subject.loadViewIfNeeded()
            NotificationCenter.default.removeObserver(subject)
            mockAsyncUtil.resetMock()
            mockUiUtil.resetMock()
        }
        XCTAssertNil(released, "Main-queue refreshes must not retain a closed timeline")
    }

    func testModernSleepStagesAppearWithTheirRecordedBoundariesAndStageSpecificDescriptions() {
        Given(mockUserDefaultsUtil, .bool(forKey: .value(.moodEnabledOnTimeline), willReturn: false))
        Given(mockUserDefaultsUtil, .bool(forKey: .value(.sleepEnabledOnTimeline), willReturn: true))
        let states: [Sleep.State] = [.asleepCore, .asleepDeep, .asleepREM]
        let samples = states.enumerated().map { index, state in
            Sleep(state, startDate: base.addingTimeInterval(Double(index * 60)),
                  endDate: base.addingTimeInterval(Double((index + 1) * 60)))
        }
        factory.sleep.handler = { _, _ in samples }
        let subject = open()
        finishFetch()
        XCTAssertEqual(factory.sleep.calls.count, 1)
        let cells = (0..<subject.numberOfSections(in: subject.tableView)).flatMap { section in
            (0..<subject.tableView(subject.tableView, numberOfRowsInSection: section)).map { cell(section, $0) }
        }
        XCTAssertEqual(cells.count, 6)
        XCTAssertEqual(cells.map { $0.date! }.sorted(), samples.flatMap { [$0.startDate, $0.endDate] }.sorted())
        let descriptions = cells.flatMap { $0.descriptions }
        for state in states {
            XCTAssertTrue(descriptions.contains("💤 \(state.description) started"))
            XCTAssertTrue(descriptions.contains("💤 \(state.description) ended"))
        }
        XCTAssertFalse(descriptions.contains("💤 Fell asleep"), "A recorded stage change does not establish a new sleep onset")
        XCTAssertFalse(descriptions.contains("🥱 Woke up"), "Ending a stage does not establish that the person woke up")
    }

    func testUnspecifiedSleepRetainsItsExistingOnsetAndWakeDescriptions() {
        Given(mockUserDefaultsUtil, .bool(forKey: .value(.moodEnabledOnTimeline), willReturn: false))
        Given(mockUserDefaultsUtil, .bool(forKey: .value(.sleepEnabledOnTimeline), willReturn: true))
        factory.sleep.handler = { _, _ in [Sleep(.asleep, startDate: self.base, endDate: self.base.addingTimeInterval(60))] }
        let subject = open()
        finishFetch()
        XCTAssertEqual(subject.numberOfSections(in: subject.tableView), 1)
        XCTAssertEqual(subject.tableView(subject.tableView, numberOfRowsInSection: 0), 2)
        let descriptions = cell(0, 0).descriptions + cell(0, 1).descriptions
        XCTAssertTrue(descriptions.contains("💤 Fell asleep"))
        XCTAssertTrue(descriptions.contains("🥱 Woke up"))
    }

    func testUnknownAndAwakeSleepIntervalsDoNotInventAsleepOrWakeEvents() {
        Given(mockUserDefaultsUtil, .bool(forKey: .value(.moodEnabledOnTimeline), willReturn: false))
        Given(mockUserDefaultsUtil, .bool(forKey: .value(.sleepEnabledOnTimeline), willReturn: true))
        factory.sleep.handler = { _, _ in
            [Sleep(.unknown(99), startDate: self.base, endDate: self.base.addingTimeInterval(60)),
             Sleep(.awake, startDate: self.base.addingTimeInterval(60), endDate: self.base.addingTimeInterval(120))]
        }
        let subject = open()
        finishFetch()
        XCTAssertEqual(factory.sleep.calls.count, 1)
        XCTAssertEqual(subject.numberOfSections(in: subject.tableView), 0)
    }
}

private final class TimelineClosureFetcher: SampleFetcher {
    let sampleTypePluralName: String
    var handler: (Date?, Date?) throws -> [Sample] = { _, _ in [] }
    private let lock = NSLock()
    private var recorded = [(Date?, Date?)]()
    var calls: [(Date?, Date?)] {
        lock.lock(); defer { lock.unlock() }
        return recorded
    }
    init(_ name: String) { sampleTypePluralName = name }
    func getSamples(from minDate: Date?, to maxDate: Date?) throws -> [Sample] {
        lock.lock(); recorded.append((minDate, maxDate)); lock.unlock()
        return try handler(minDate, maxDate)
    }
}

private final class TimelineTestFetchers: SampleFetcherFactory {
    var moodFetcherOverride: SampleFetcher?
    let moods = TimelineClosureFetcher("Moods")
    let fatigue = TimelineClosureFetcher("Fatigue")
    let sleep = TimelineClosureFetcher("Sleep")
    let disabled = TimelineClosureFetcher("Disabled")
    func moodSampleFetcher() -> SampleFetcher { moodFetcherOverride ?? moods }
    func fatigueSampleFetcher() -> SampleFetcher { fatigue }
    func activitySampleFetcher() -> SampleFetcher { disabled }
    func bloodPressureSampleFetcher() -> SampleFetcher { disabled }
    func bodyMassIndexSampleFetcher() -> SampleFetcher { disabled }
    func dietarySugarSampleFetcher() -> SampleFetcher { disabled }
    func heartRateSampleFetcher() -> SampleFetcher { disabled }
    func leanBodyMassSampleFetcher() -> SampleFetcher { disabled }
    func medicationDoseSampleFetcher() -> SampleFetcher { disabled }
    func painSampleFetcher() -> SampleFetcher { disabled }
    func restingHeartRateSampleFetcher() -> SampleFetcher { disabled }
    func sexualActivitySampleFetcher() -> SampleFetcher { disabled }
    func sleepSampleFetcher() -> SampleFetcher { sleep }
    func stepsSampleFetcher() -> SampleFetcher { disabled }
    func weightSampleFetcher() -> SampleFetcher { disabled }
}

private final class TimelineFetcherProvider: InjectionProvider {
    let types: [Any.Type] = [SampleFetcherFactory.self]
    private let factory: SampleFetcherFactory
    init(_ factory: SampleFetcherFactory) { self.factory = factory }
    func get<Type>(_: Type.Type) throws -> Type { factory as! Type }
}

// These scalar protocols share the same property surface; reuse the generated stub.
private final class TimelineFatigueMock: MoodMock, Fatigue {}
