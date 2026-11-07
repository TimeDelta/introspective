import Foundation

/// Families exposed by the public HealthKit SDK. Some are profile or document
/// records rather than dated samples and use dedicated readers.
public enum HealthTypeFamily: String, Codable, CaseIterable {
    case quantity, category, correlation, clinical, document, characteristic
    case activitySummary, workout, workoutRoute, heartbeatSeries
    case electrocardiogram, audiogram, visionPrescription, stateOfMind
    case scoredAssessment, medicationDose, userAnnotatedMedication
    case verifiableClinical, attachment
}

/// Stable catalog metadata. IDs are persisted in saved queries: never renumber
/// them, derive them from display order, or compact them for an older OS.
public struct HealthTypeDescriptor: Codable, Equatable {
    public let id: Int16
    public let identifier: String
    public let name: String
    public let group: String
    public let family: HealthTypeFamily
    public let minimumOS: String
    public let canonicalUnit: String?
    public let categoryValues: [Int: String]

    public init(id: Int16, identifier: String, name: String, group: String,
                family: HealthTypeFamily, minimumOS: String,
                canonicalUnit: String? = nil, categoryValues: [Int: String] = [:]) {
        self.id = id; self.identifier = identifier; self.name = name; self.group = group
        self.family = family; self.minimumOS = minimumOS
        self.canonicalUnit = canonicalUnit; self.categoryValues = categoryValues
    }

    public func isAvailable(on version: OperatingSystemVersion) -> Bool {
        let components = minimumOS.split(separator: ".", omittingEmptySubsequences: false)
        guard (1...3).contains(components.count),
            components.allSatisfy({ !$0.isEmpty && $0.allSatisfy(\.isNumber) }),
            components.allSatisfy({ Int($0).map { $0 >= 0 } == true }) else { return false }
        let required = components.compactMap { Int($0) }
        let actual = [version.majorVersion, version.minorVersion, version.patchVersion]
        for index in 0..<3 {
            let expected = index < required.count ? required[index] : 0
            if actual[index] != expected { return actual[index] > expected }
        }
        return true
    }

    public var isAvailableOnCurrentOS: Bool {
        isAvailable(on: ProcessInfo.processInfo.operatingSystemVersion)
    }

    /// Preserve a future code explicitly instead of reporting it as None,
    /// Not applicable, or a different known state.
    public func categoryLabel(for rawValue: Int) -> String {
        categoryValues[rawValue] ?? "Unknown Health category (\(rawValue))"
    }
}
