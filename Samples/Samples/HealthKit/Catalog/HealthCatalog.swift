import Foundation
import HealthKit
import Common

/// A concrete catalog-backed sample retains its original Health object. New
/// catalog types are read-only; recording continues in Health or its source app.
public protocol HealthCatalogSample: HealthKitSample {
    static var catalogEntry: HealthTypeDescriptor { get }
    init(validating sample: HKSample) throws
}

/// Generated marker types give each quantity/category a distinct Sample.Type,
/// preserving the application's static attribute and saved-query architecture.
public protocol HealthCatalogDefinition {
    static var catalogEntry: HealthTypeDescriptor { get }
}

public struct HealthCatalogRegistration {
    public let descriptor: HealthTypeDescriptor
    public let sampleType: Sample.Type
    public init(descriptor: HealthTypeDescriptor, sampleType: Sample.Type) {
        self.descriptor = descriptor; self.sampleType = sampleType
    }
}

public enum HealthCatalogError: LocalizedError {
    case unavailable(String), notSample(String), unexpectedSample(String), incompatibleUnit(String), readOnly
    public var errorDescription: String? {
        switch self {
        case .unavailable(let name): return "\(name) is unavailable on this version of iOS."
        case .notSample(let name): return "Review \(name) in the Health library; it is not a dated Health sample."
        case .unexpectedSample(let name): return "Health returned an unexpected record for \(name)."
        case .incompatibleUnit(let name): return "Health returned an incompatible measurement unit for \(name)."
        case .readOnly: return "Edit this record in Apple Health or the app that recorded it."
        }
    }
}

public enum HealthCatalog {
    public static var descriptors: [HealthTypeDescriptor] { HealthCatalogGenerated.descriptors }
    public static var registrations: [HealthCatalogRegistration] {
        HealthCatalogGenerated.registrations
    }
    // The OS version is fixed for the life of this process. Avoid constructing
    // hundreds of HealthKit type objects on every picker row or saved query.
    public static let availableEntries: [HealthCatalogRegistration] = registrations.filter {
        $0.descriptor.isAvailableOnCurrentOS && HealthCatalogObjectTypes.objectType(for: $0.descriptor) is HKSampleType
    }
    public static let availableDescriptors: [HealthTypeDescriptor] = descriptors.filter { $0.isAvailableOnCurrentOS }
    private static let descriptorsByID = Dictionary(uniqueKeysWithValues: descriptors.map { ($0.id, $0) })
    private static let descriptorsByIdentifier = Dictionary(uniqueKeysWithValues: descriptors.map { ($0.identifier, $0) })
    private static let descriptorsByType = Dictionary(uniqueKeysWithValues: registrations.map { (ObjectIdentifier($0.sampleType), $0.descriptor) })
    private static let availableByID = Dictionary(uniqueKeysWithValues: availableEntries.map { ($0.descriptor.id, $0.sampleType) })
    public static func descriptor(for id: Int16) -> HealthTypeDescriptor? {
        descriptorsByID[id]
    }
    public static func descriptor(for type: Sample.Type) -> HealthTypeDescriptor? {
        descriptorsByType[ObjectIdentifier(type)]
    }
    public static func descriptor(for identifier: String) -> HealthTypeDescriptor? {
        descriptorsByIdentifier[HealthCatalogGenerated.aliases[identifier] ?? identifier]
    }
    public static func sampleType(for id: Int16) throws -> Sample.Type {
        if let type = availableByID[id] { return type }
        if let descriptor = descriptor(for: id), descriptor.isAvailableOnCurrentOS,
            !registrations.contains(where: { $0.descriptor.id == id }) {
            throw HealthCatalogError.notSample(descriptor.name)
        }
        throw HealthCatalogError.unavailable(descriptor(for: id)?.name ?? "This Health data type")
    }
}
