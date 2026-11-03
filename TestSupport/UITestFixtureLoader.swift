import CoreData
import Common
import DependencyInjection
import Persistence
import Queries
import Samples

/// Populates the real isolated SQLite store before any application screens load.
enum UITestFixtureLoader {
	enum FixtureError: Error {
		case duplicateOrEmptyName, unknownReference, invalidFrequency, invalidDosage, invalidDate, nonemptyDatabase, missingDashboardPreferences
	}

	@discardableResult
	static func load(environment: [String: String], isUITesting: Bool) throws -> Bool {
		guard isUITesting, let text = environment[UITestFixtures.environmentKey] else { return false }
		let preferences = PinnedQueryPreferences(defaults: UserDefaults(suiteName: "com.bnova.Introspective.dashboard-ui-tests")!)
		try seed(UITestFixtures.decode(text), dashboardPreferences: preferences)
		return true
	}

	static func seed(_ fixtures: UITestFixtures, dashboardPreferences: PinnedQueryPreferences? = nil) throws {
		// Validate every reference/value before writing any of the fixture records.
		try validateNames(fixtures.activityDefinitions.map { $0.name })
		try validateNames(fixtures.medications.map { $0.name })
		if let dashboard = fixtures.dashboardQueries {
			try validateNames(try dashboard.map { try StoredQueriesDAOImpl.validName($0.name) })
			let pinnedCount = dashboard.filter { $0.pinned }.count
			if pinnedCount > 0 {
				guard let preferences = dashboardPreferences else { throw FixtureError.missingDashboardPreferences }
				guard try preferences.pins().count + pinnedCount <= PinnedQueryPreferences.maximumPins else {
					throw PinnedQueryPreferencesError.tooManyPins
				}
			}
		}
		let definitionNames = Set(fixtures.activityDefinitions.map { $0.name })
		let medicationNames = Set(fixtures.medications.map { $0.name })
		for activity in fixtures.activities {
			guard definitionNames.contains(activity.definitionName) else { throw FixtureError.unknownReference }
			guard activity.start.timeIntervalSince1970.isFinite,
				activity.end.map({ $0.timeIntervalSince1970.isFinite && $0 >= activity.start }) ?? true
			else { throw FixtureError.invalidDate }
		}
		for medication in fixtures.medications {
			_ = try frequency(medication.frequency)
			_ = try dosage(medication.dosage)
			guard medication.startedOn.map({ $0.timeIntervalSince1970.isFinite }) ?? true else { throw FixtureError.invalidDate }
		}
		for dose in fixtures.doses {
			guard medicationNames.contains(dose.medicationName) else { throw FixtureError.unknownReference }
			_ = try dosage(dose.dosage)
			guard dose.timestamp.timeIntervalSince1970.isFinite else { throw FixtureError.invalidDate }
		}
		for mood in fixtures.moods {
			guard mood.rating.isFinite, mood.timestamp.timeIntervalSince1970.isFinite else { throw FixtureError.invalidDate }
		}

		let database = injected(Database.self)
		guard try database.count(ActivityDefinition.self) == 0,
			try database.count(Activity.self) == 0,
			try database.count(Medication.self) == 0,
			try database.count(MedicationDose.self) == 0,
			try database.count(MoodImpl.self) == 0 else { throw FixtureError.nonemptyDatabase }
		if fixtures.dashboardQueries != nil, try database.count(StoredQuery.self) != 0 { throw FixtureError.nonemptyDatabase }
		let activityDAO = injected(ActivityDAO.self)
		let medicationDAO = injected(MedicationDAO.self)
		var definitions = [String: ActivityDefinition]()
		for (index, fixture) in fixtures.activityDefinitions.enumerated() {
			let created = try activityDAO.createDefinition(name: fixture.name, description: fixture.description,
				recordScreenIndex: Int16(index), autoNote: fixture.autoNote)
			let definition = try database.pull(savedObject: created)
			if let names = fixture.tags, !names.isEmpty {
				let tags = try names.map { try injected(TagDAO.self).getOrCreateTag(named: $0) }
				let transaction = database.transaction()
				let editable = try transaction.pull(savedObject: definition)
				for tag in tags { editable.addToTags(try transaction.pull(savedObject: tag)) }
				try transaction.commit()
			}
			definitions[fixture.name] = definition
		}
		for fixture in fixtures.activities {
			let tags = try fixture.tags.map { try injected(TagDAO.self).getOrCreateTag(named: $0) }
			let transaction = database.transaction()
			let localTags = try tags.map { try transaction.pull(savedObject: $0) }
			try activityDAO.createActivity(definition: definitions[fixture.definitionName]!,
				startDate: fixture.start, startDateSetAt: fixture.start, endDate: fixture.end,
				endDateSetAt: fixture.end, note: fixture.note, extraTags: localTags, using: transaction)
		}
		var medications = [String: Medication]()
		for (index, fixture) in fixtures.medications.enumerated() {
			medications[fixture.name] = try medicationDAO.createMedication(name: fixture.name,
				frequency: frequency(fixture.frequency), dosage: dosage(fixture.dosage),
				startedOn: fixture.startedOn, note: fixture.note, recordScreenIndex: Int16(index))
		}
		for fixture in fixtures.doses {
			try medicationDAO.createDose(medication: medications[fixture.medicationName]!,
				dosage: dosage(fixture.dosage), timestamp: fixture.timestamp)
		}
		for fixture in fixtures.moods {
			_ = try injected(MoodDAO.self).createMood(timestamp: fixture.timestamp,
				rating: fixture.rating, note: fixture.note)
		}
		for fixture in fixtures.dashboardQueries ?? [] {
			let queries = injected(StoredQueriesDAO.self)
			try queries.save(MoodQueryImpl(), name: fixture.name)
			if fixture.pinned {
				guard let saved = try queries.getQueryWith(name: fixture.name), !saved.objectID.isTemporaryID,
					let preferences = dashboardPreferences else { throw FixtureError.missingDashboardPreferences }
				try preferences.pin(PinnedQueryReference(id: saved.objectID.uriRepresentation().absoluteString,
					lastKnownName: String(saved.name.prefix(PinnedQueryPreferences.maximumNameLength))))
			}
		}
	}

	private static func validateNames(_ names: [String]) throws {
		let normalized = names.map { $0.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: Locale(identifier: "en_US_POSIX")) }
		guard !names.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }),
			Set(normalized).count == names.count else { throw FixtureError.duplicateOrEmptyName }
	}

	private static func frequency(_ fixture: UITestFixtures.Medication.Frequency?) throws -> Frequency? {
		guard let fixture = fixture else { return nil }
		guard let value = Frequency("\(fixture.times) times per \(fixture.unit)") else { throw FixtureError.invalidFrequency }
		return value
	}

	private static func dosage(_ text: String?) throws -> Dosage? {
		guard let text = text else { return nil }
		guard let value = Dosage(text) else { throw FixtureError.invalidDosage }
		return value
	}
}
