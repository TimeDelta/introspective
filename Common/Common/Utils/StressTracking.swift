import Foundation

public struct StressTrackingError: LocalizedError {
	public let message: String
	public init(_ message: String) { self.message = message }
	public var errorDescription: String? { message }
}

/// Anchors for perceived stress right now. These are descriptive ordinal responses, not clinical scores.
public enum StressRating: Int, Codable, CaseIterable {
	case none = 0, mild, moderate, high, overwhelming
	public var title: String {
		switch self {
		case .none: return "None"
		case .mild: return "Mild"
		case .moderate: return "Moderate"
		case .high: return "High"
		case .overwhelming: return "Overwhelming"
		}
	}
}

public enum StressResponseStatus: String, Codable, CaseIterable {
	case rated, notApplicable, skipped
	public var title: String {
		switch self {
		case .rated: return "Rated"
		case .notApplicable: return "Not applicable"
		case .skipped: return "Skipped"
		}
	}
}

/// A definition's stable identity and name at the time it is offered in a check-in.
public struct StressStressorSnapshot: Codable, Equatable {
	public var id: UUID
	public var name: String
	public init(id: UUID = UUID(), name: String) { self.id = id; self.name = name }
}

public struct StressResponseDraft: Codable, Equatable {
	public var stressorID: UUID
	public var nameSnapshot: String
	public var order: Int
	public var status: StressResponseStatus
	public var rating: Int?

	/// A newly offered stressor begins unanswered; nil never means a recorded zero.
	public init(stressorID: UUID, nameSnapshot: String, order: Int = 0,
		status: StressResponseStatus = .skipped, rating: Int? = nil) {
		self.stressorID = stressorID; self.nameSnapshot = nameSnapshot; self.order = order
		self.status = status; self.rating = rating
	}

	public func validate() throws {
		guard !nameSnapshot.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
			nameSnapshot.count <= 120 else {
			throw StressTrackingError("Give each stressor a name of up to 120 characters.")
		}
		guard order >= 0 else { throw StressTrackingError("Use a valid stressor order.") }
		switch status {
		case .rated:
			guard let rating = rating, StressRating(rawValue: rating) != nil else {
				throw StressTrackingError("Choose a stress rating from None through Overwhelming.")
			}
		case .notApplicable, .skipped:
			guard rating == nil else {
				throw StressTrackingError("Skipped and not-applicable responses cannot contain a rating.")
			}
		}
	}
}

public struct StressCheckInDraft: Codable, Equatable {
	public static let supportedMeasurementKind = "momentary"
	public static let currentScaleVersion = 1

	public var date: Date
	public var overallRating: Int?
	public var note: String?
	public var responses: [StressResponseDraft]
	public var measurementKind: String
	public var scaleVersion: Int

	public init(date: Date = Date(), overallRating: Int? = nil, note: String? = nil,
		responses: [StressResponseDraft] = [], measurementKind: String = StressCheckInDraft.supportedMeasurementKind,
		scaleVersion: Int = StressCheckInDraft.currentScaleVersion) {
		self.date = date; self.overallRating = overallRating; self.note = note; self.responses = responses
		self.measurementKind = measurementKind; self.scaleVersion = scaleVersion
	}

	public func validate() throws {
		guard date.timeIntervalSinceReferenceDate.isFinite else { throw StressTrackingError("Choose a valid check-in time.") }
		guard let overallRating = overallRating, StressRating(rawValue: overallRating) != nil else {
			throw StressTrackingError("Choose your overall stress before saving.")
		}
		guard measurementKind == Self.supportedMeasurementKind, scaleVersion == Self.currentScaleVersion else {
			throw StressTrackingError("This check-in uses an unsupported stress question or rating scale.")
		}
		guard (note?.count ?? 0) <= 4000 else { throw StressTrackingError("Use a note of up to 4,000 characters.") }
		guard Set(responses.map { $0.stressorID }).count == responses.count else {
			throw StressTrackingError("Offer each stressor only once in a check-in.")
		}
		// The number of personal stressors is the user's choice; no response-count cap.
		for response in responses { try response.validate() }
	}
}
