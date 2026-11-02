// This workload is compiled with the actual production cache by benchmark-date-formatting.py.
// Timing is informational; correctness checks fail the process, timing ratios never gate CI.
func require(_ condition: @autoclosure () -> Bool, _ message: String) {
    guard condition() else { fatalError(message) }
}
func fresh(_ date: DateFormatter.Style, _ time: DateFormatter.Style) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = date; formatter.timeStyle = time; formatter.timeZone = nil
    return formatter
}
let date = Date(timeIntervalSince1970: 1_700_000_000)
let cache = CalendarStyleFormatterCache()
let styles: [DateFormatter.Style] = [.none, .short, .medium, .long, .full]
for dateStyle in styles {
    for timeStyle in styles {
        let reference = fresh(dateStyle, timeStyle)
        let cached = cache.formatter(dateStyle: dateStyle, timeStyle: timeStyle)
        let text = reference.string(from: date)
        require(cached.string(from: date) == text, "Formatted text changed")
        require(fresh(dateStyle, timeStyle).date(from: cached.string(from: date)) == reference.date(from: text), "Formatted date no longer parses equivalently")
        require(cached === cache.formatter(dateStyle: dateStyle, timeStyle: timeStyle), "Formatter was not reused")
    }
}
let oldZone = NSTimeZone.default
NSTimeZone.default = TimeZone(secondsFromGMT: 0)!
let utc = cache.formatter(dateStyle: .full, timeStyle: .full)
let utcText = utc.string(from: date)
NSTimeZone.default = TimeZone(identifier: "America/Los_Angeles")!
let pacific = cache.formatter(dateStyle: .full, timeStyle: .full)
require(pacific !== utc, "Default time-zone change did not invalidate cache")
require(pacific.string(from: date) == fresh(.full, .full).string(from: date), "Default time-zone output changed")
require(pacific.string(from: date) != utcText, "Default time zone was ignored")
NSTimeZone.default = oldZone
let center = NotificationCenter()
let notified = CalendarStyleFormatterCache(center: center)
let before = notified.formatter(dateStyle: .full, timeStyle: .full)
center.post(name: NSLocale.currentLocaleDidChangeNotification, object: nil)
require(notified.formatter(dateStyle: .full, timeStyle: .full) !== before, "Locale notification did not invalidate")
let expected = fresh(.full, .full).string(from: date)
let expectedDate = fresh(.full, .full).date(from: expected)
let lock = NSLock()
var mismatches = 0
DispatchQueue.concurrentPerform(iterations: 200) { _ in
    let formatter = cache.formatter(dateStyle: .full, timeStyle: .full)
    let text = formatter.string(from: date)
    if text != expected || fresh(.full, .full).date(from: text) != expectedDate {
        lock.lock(); mismatches += 1; lock.unlock()
    }
}
require(mismatches == 0, "Concurrent formatting changed results")
print("PASS 25 style pairs, parse compatibility, reuse, default time-zone changes, invalidation and concurrent reads")

let iterations = Int(CommandLine.arguments[1])!
func elapsed(_ operation: (Int) -> Int) -> (seconds: Double, checksum: Int) {
    let start = ProcessInfo.processInfo.systemUptime
    var checksum = 0
    for index in 0..<iterations { checksum &+= operation(index) }
    return (ProcessInfo.processInfo.systemUptime - start, checksum)
}
// Real callers use full/full for CSV, medium/short for result rows, and none/short for times.
let workloads: [(String, DateFormatter.Style, DateFormatter.Style)] = [
    ("CSV full/full", .full, .full), ("Result row medium/short", .medium, .short), ("Time none/short", .none, .short),
]
for (name, dateStyle, timeStyle) in workloads {
    _ = cache.formatter(dateStyle: dateStyle, timeStyle: timeStyle).string(from: date)
    for round in 1...3 {
        let baseline = elapsed { index in fresh(dateStyle, timeStyle).string(from: date.addingTimeInterval(Double(index))).utf8.count }
        let cached = elapsed { index in cache.formatter(dateStyle: dateStyle, timeStyle: timeStyle).string(from: date.addingTimeInterval(Double(index))).utf8.count }
        require(baseline.checksum == cached.checksum, "Formatting workload differs")
        print("\(name) round \(round), \(iterations) calls: fresh=\(baseline.seconds)s cached=\(cached.seconds)s speedup=\(baseline.seconds / cached.seconds)x")
    }
}
