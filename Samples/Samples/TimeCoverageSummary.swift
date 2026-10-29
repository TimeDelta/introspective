import Foundation

/// Union recorded intervals before taking the complement; overlapping records never double count.
public struct TimeCoverageSummary {
	public let covered: TimeInterval
	public let unaccounted: TimeInterval
	public let gaps: [DateInterval]

	public init(interval: DateInterval, recordedIntervals: [DateInterval]) {
		let clipped = recordedIntervals.compactMap { record -> DateInterval? in
			let start = max(interval.start, record.start)
			let end = min(interval.end, record.end)
			return end > start ? DateInterval(start: start, end: end) : nil
		}.sorted { $0.start < $1.start }
		var cursor = interval.start
		var gaps: [DateInterval] = []
		for record in clipped {
			if record.start > cursor { gaps.append(DateInterval(start: cursor, end: record.start)) }
			cursor = max(cursor, record.end)
		}
		if cursor < interval.end { gaps.append(DateInterval(start: cursor, end: interval.end)) }
		self.gaps = gaps
		unaccounted = gaps.reduce(0) { $0 + $1.duration }
		covered = interval.duration - unaccounted
	}
}
