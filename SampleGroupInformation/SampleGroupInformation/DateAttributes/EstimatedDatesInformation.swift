import Foundation
import Attributes
import Common
import Samples

/// A heuristic: manually estimated timestamps normally have zero seconds and fractions.
public final class EstimatedDatesInformation: AnyInformation {
	public override var name: String { "Estimated Dates (%)" }
	public override var description: String { "Percent of " + attribute.name.lowercased() + " with zero seconds and fractional seconds" }

	public override func computeGraphable(forSamples samples: [Sample]) throws -> String {
		let dates = try filterSamples(samples, as: Date.self).compactMap { try $0.value(of: attribute) as? Date }
		guard !dates.isEmpty else { throw GenericDisplayableError(title: "No dates matching filter") }
		let estimated = dates.filter { date in
			let parts = Calendar.autoupdatingCurrent.dateComponents([.second, .nanosecond], from: date)
			return parts.second == 0 && parts.nanosecond == 0
		}.count
		return String(Double(estimated) / Double(dates.count) * 100)
	}

	public override func compute(forSamples samples: [Sample]) throws -> String {
		let value = try computeGraphable(forSamples: samples)
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 2
		return (formatter.string(from: NSNumber(value: Double(value)!)) ?? value) + "%"
	}

	public override func equalTo(_ other: SampleGroupInformation) -> Bool {
		other is EstimatedDatesInformation && attribute.equalTo(other.attribute)
	}
}
