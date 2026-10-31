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
    let moods = TimelineClosureFetcher("Moods")
    let fatigue = TimelineClosureFetcher("Fatigue")
    let disabled = TimelineClosureFetcher("Disabled")
    func moodSampleFetcher() -> SampleFetcher { moods }
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
    func sleepSampleFetcher() -> SampleFetcher { disabled }
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
