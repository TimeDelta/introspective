import Foundation

/// Shared by the UI runner and the app so fixture transport cannot drift.
/// Only the Debug app's --ui-testing launch path consumes this environment value.
struct UITestFixtures: Codable {
	static let environmentKey = "INTROSPECTIVE_UI_FIXTURES"
	var activityDefinitions = [ActivityDefinition]()
	var activities = [Activity]()
	var medications = [Medication]()
	var doses = [Dose]()
	var moods = [Mood]()

	func encoded() throws -> String {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .millisecondsSince1970
		return String(decoding: try encoder.encode(self), as: UTF8.self)
	}

	static func decode(_ text: String) throws -> UITestFixtures {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .millisecondsSince1970
		return try decoder.decode(Self.self, from: Data(text.utf8))
	}

	struct Mood: Codable {
		var rating: Double
		var note: String?
		var timestamp: Date

		init(_ rating: Double = 0, _ note: String? = nil, timestamp: Date = Date()) {
			self.rating = rating
			self.note = note
			self.timestamp = timestamp
		}
	}

	struct ActivityDefinition: Codable {
		var name: String
		var autoNote: Bool?
		var description: String?
		var tags: [String]?

		init(name: String, autoNote: Bool? = nil, description: String? = nil, tags: [String]? = nil) {
			self.name = name
			self.autoNote = autoNote
			self.description = description
			self.tags = tags
		}
	}

	struct Activity: Codable {
		var definitionName: String
		var start: Date
		var end: Date?
		var note: String?
		var tags: [String]

		init(_ definition: ActivityDefinition, start: Date = Date(), end: Date? = nil,
			note: String? = nil, tags: [String] = []) {
			definitionName = definition.name
			self.start = start
			self.end = end
			self.note = note
			self.tags = tags
		}
	}

	struct Medication: Codable {
		struct Frequency: Codable {
			var times: String
			var unit: String
		}
		var name: String
		var frequency: Frequency?
		var startedOn: Date?
		var dosage: String?
		var note: String?

		init(_ name: String, frequency: (times: String, unit: String)? = nil,
			startedOn: Date? = nil, dosage: String? = nil, note: String? = nil) {
			self.name = name
			self.frequency = frequency.map { Frequency(times: $0.times, unit: $0.unit) }
			self.startedOn = startedOn
			self.dosage = dosage
			self.note = note
		}
	}

	struct Dose: Codable {
		var medicationName: String
		var timestamp: Date
		var dosage: String?

		init(_ medication: Medication, at timestamp: Date, dosage: String? = nil) {
			medicationName = medication.name
			self.timestamp = timestamp
			self.dosage = dosage ?? medication.dosage
		}
	}
}
