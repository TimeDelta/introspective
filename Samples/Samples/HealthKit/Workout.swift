import Foundation
import HealthKit
import Attributes
import Common

/// Read-only wrapper around an actual Health workout, preserving its identity and recorded metrics.
public final class Workout: HealthKitSample, SearchableSample {
	public static let sampleType: HKSampleType = HKObjectType.workoutType()
	public static let readPermissions: Set<HKObjectType> = [sampleType]
	public static let writePermissions: Set<HKSampleType> = []
	public static func initUnits() {}
	public static let name = "Workout"
	public static let description = "Workouts recorded in Apple Health"
	public static let durationAttribute = DurationAttribute(id: 0)
	public static let kind = TextAttribute(id: 1, name: "Workout Type", pluralName: "Workout Types")
	public static let energy = DoubleAttribute(id: 2, name: "Energy (kcal)", pluralName: "Energy (kcal)", optional: true)
	public static let distance = DoubleAttribute(id: 3, name: "Distance (m)", pluralName: "Distances (m)", optional: true)
	public static let attributes: [Attribute] = [CommonSampleAttributes.healthKitStartDate, CommonSampleAttributes.healthKitEndDate, durationAttribute, kind, energy, distance]
	public static let dateAttributes: [DateType: DateAttribute] = [.start: CommonSampleAttributes.healthKitStartDate, .end: CommonSampleAttributes.healthKitEndDate]
	public static let defaultIndependentAttribute: Attribute = CommonSampleAttributes.healthKitStartDate
	public static let defaultDependentAttribute: Attribute = durationAttribute
	public let workout: HKWorkout
	public var attributedName: String { Self.name }
	public var description: String { typeName + " workout" }
	public var attributes: [Attribute] { Self.attributes }
	public init(_ workout: HKWorkout) { self.workout = workout }
	public func hkSample() -> HKSample { workout }
	public func dates() -> [DateType: Date] { [.start: workout.startDate, .end: workout.endDate] }
	public var typeName: String {
		switch workout.workoutActivityType {
		case .walking: return "Walking"
		case .running: return "Running"
		case .cycling: return "Cycling"
		case .swimming: return "Swimming"
		case .hiking: return "Hiking"
		case .yoga: return "Yoga"
		case .traditionalStrengthTraining: return "Strength Training"
		case .functionalStrengthTraining: return "Functional Strength Training"
		case .rowing: return "Rowing"
		case .elliptical: return "Elliptical"
		case .dance: return "Dance"
		case .pilates: return "Pilates"
		case .highIntensityIntervalTraining: return "High Intensity Interval Training"
		case .other: return "Other"
		default: return "Workout type \(workout.workoutActivityType.rawValue)"
		}
	}
	public func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Self.durationAttribute) { return TimeDuration(workout.duration) }
		if attribute.equalTo(Self.kind) { return typeName }
		if attribute.equalTo(Self.energy) { return workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) }
		if attribute.equalTo(Self.distance) { return workout.totalDistance?.doubleValue(for: .meter()) }
		if attribute.equalTo(CommonSampleAttributes.healthKitStartDate) { return workout.startDate }
		if attribute.equalTo(CommonSampleAttributes.healthKitEndDate) { return workout.endDate }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
	public func set(attribute: Attribute, to value: Any?) throws {
		throw GenericDisplayableError(title: "Edit workouts in Apple Health or the app that recorded them.")
	}
	public func matchesSearchString(_ text: String) -> Bool {
		typeName.range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
	}
	public func equalTo(_ other: Sample) -> Bool { (other as? Workout)?.workout.uuid == workout.uuid }
	public func equalTo(_ other: Attributed) -> Bool { (other as? Workout)?.workout.uuid == workout.uuid }
}
