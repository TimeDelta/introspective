import Foundation
import Attributes
import BooleanAlgebra
import Common
import Samples

/// A closed, validated subset of the query language. No generated predicates or code are executed.
public struct OnDeviceQueryPlan {
	public var dataType: String
	public var days: Int?
	public var minimumRating: Double?
	public var maximumRating: Double?
	public var noteContains: String?
	public var minimumDurationMinutes: Double?
	public var minimumEnergyKcal: Double?
	public var mostRecentOnly: Bool
	public init(dataType: String, days: Int? = nil, minimumRating: Double? = nil, maximumRating: Double? = nil,
		noteContains: String? = nil, minimumDurationMinutes: Double? = nil, minimumEnergyKcal: Double? = nil, mostRecentOnly: Bool = false) {
		self.dataType = dataType; self.days = days; self.minimumRating = minimumRating; self.maximumRating = maximumRating
		self.noteContains = noteContains; self.minimumDurationMinutes = minimumDurationMinutes; self.minimumEnergyKcal = minimumEnergyKcal; self.mostRecentOnly = mostRecentOnly
	}
	public func resolve() throws -> (sampleType: Sample.Type, expression: BooleanExpression?, mostRecentOnly: Bool) {
		let types: [String: Sample.Type] = ["mood": MoodImpl.self, "pain": PainImpl.self, "fatigue": FatigueImpl.self,
			"activity": Activity.self, "workout": Workout.self, "activeEnergy": ActiveEnergy.self, "lostItem": LostItemEvent.self]
		guard let type = types[dataType] else { throw GenericDisplayableError(title: "Unsupported query data type.") }
		var expressions: [BooleanExpression] = []
		if let days = days {
			guard (1...3650).contains(days) else { throw GenericDisplayableError(title: "Choose a lookback between 1 and 3650 days.") }
			expressions.append(InThePastXTimeUnitsDateAttributeRestriction(restrictedAttribute: type.defaultIndependentAttribute, days, .day))
		}
		if minimumRating != nil || maximumRating != nil {
			let ratings: [String: DoubleAttribute] = ["mood": MoodImpl.rating, "pain": PainImpl.rating, "fatigue": FatigueImpl.rating]
			guard let attribute = ratings[dataType] else { throw GenericDisplayableError(title: "This data type has no rating.") }
			if let min = minimumRating, let max = maximumRating, min > max { throw GenericDisplayableError(title: "The minimum rating exceeds the maximum.") }
			if let min = minimumRating {
				guard min.isFinite else { throw GenericError("Invalid minimum rating") }
				expressions.append(GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: attribute, value: min))
			}
			if let max = maximumRating {
				guard max.isFinite else { throw GenericError("Invalid maximum rating") }
				expressions.append(LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: attribute, value: max))
			}
		}
		if let text = noteContains {
			guard !text.isEmpty, text.count <= 1000, let attribute = type.attributes.first(where: { $0 is TextAttribute && $0.name == "Note" }) else {
				throw GenericDisplayableError(title: "This note condition cannot be represented.")
			}
			expressions.append(ContainsStringAttributeRestriction(restrictedAttribute: attribute, substring: text))
		}
		if let minutes = minimumDurationMinutes {
			guard minutes.isFinite, (0...5_256_000).contains(minutes), let attribute = type.attributes.first(where: { $0 is DurationAttribute }) else {
				throw GenericDisplayableError(title: "Invalid duration condition.")
			}
			expressions.append(GreaterThanOrEqualToDurationAttributeRestriction(restrictedAttribute: attribute, value: TimeDuration(minutes * 60)))
		}
		if let kcal = minimumEnergyKcal {
			guard dataType == "activeEnergy", kcal.isFinite, kcal >= 0 else { throw GenericDisplayableError(title: "Invalid active-energy condition.") }
			expressions.append(GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: ActiveEnergy.energyBurned, value: kcal))
		}
		let expression = expressions.dropFirst().reduce(expressions.first) { partial, next in partial.map { AndExpression($0, next) } ?? next }
		return (type, expression, mostRecentOnly)
	}
}
