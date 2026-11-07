import Foundation
import CoreFoundation
import HealthKit

public struct HealthRecordField: Equatable {
	public let name: String
	public let value: String
	public init(name: String, value: String) { self.name = name; self.value = value }
}

public struct HealthRecordSection: Equatable {
	public let title: String
	public let fields: [HealthRecordField]
	public init(title: String, fields: [HealthRecordField]) { self.title = title; self.fields = fields }
}

/// Value snapshots for display and explicit export. Rich payloads are decoded
/// only when a detail is opened, not whenever a results cell is reused.
public enum HealthRecordDetails {
	private static let dateLock = NSLock()
	private static let dates: ISO8601DateFormatter = {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		return formatter
	}()
	public static func sections(for sample: HealthKitSample) -> [HealthRecordSection] {
		if let original = sample.originalHealthSample { return sections(for: original) }
		// Legacy mutable values can be constructed locally, without having come
		// from Health. A newly manufactured HKSample's UUID/source is not their
		// original provenance and must not be represented as a stored record.
		var values = sections(for: sample.hkSample()).filter { $0.title != "Original Health record" }
		values.append(.init(title: "Provenance", fields: [
			.init(name: "Original Health record", value: "Unavailable for this locally constructed value.")]))
		return values
	}

	public static func summary(for sample: HKSample) -> String {
		if let value = sample as? HKQuantitySample { return value.quantity.description }
		if let value = sample as? HKCategorySample {
			return HealthCatalog.descriptors.first { $0.identifier == value.categoryType.identifier }?.categoryValues[value.value]
				?? "Recorded value \(value.value)"
		}
		if let value = sample as? HKClinicalRecord { return value.displayName }
		if let value = sample as? HKStateOfMind { return "\(stateOfMindKind(value.kind.rawValue)) · valence \(value.valence)" }
		if let value = sample as? HKScoredAssessment { return "Recorded score: \(value.score)" }
		if let value = sample as? HKWorkout { return "Workout type \(value.workoutActivityType.rawValue) · \(value.duration) s" }
		if let value = sample as? HKAudiogramSample { return "\(value.sensitivityPoints.count) recorded frequencies" }
		if let value = sample as? HKElectrocardiogram { return ecgClassification(value.classification.rawValue) }
		if let value = sample as? HKVisionPrescription {
			switch value.prescriptionType {
			case .glasses: return "Glasses prescription"
			case .contacts: return "Contact lens prescription"
			@unknown default: return "Unknown prescription type (\(value.prescriptionType.rawValue))"
			}
		}
		if let value = sample as? HKCorrelation { return "\(value.objects.count) correlated measurements" }
		if let value = sample as? HKVerifiableClinicalRecord { return value.itemNames.joined(separator: ", ") }
		if #available(iOS 26.0, *), let value = sample as? HKMedicationDoseEvent {
			return medicationStatus(value.logStatus.rawValue) + (value.doseQuantity.map { " · \($0) \(value.unit.unitString)" } ?? "")
		}
		return HealthCatalog.descriptors.first { $0.identifier == sample.sampleType.identifier }?.name ?? sample.sampleType.identifier
	}

	public static func sections(for sample: HKSample) -> [HealthRecordSection] {
		var result: [HealthRecordSection] = []
		var details: [HealthRecordField] = []
		func add(_ name: String, _ value: String?) { if let value = value { details.append(.init(name: name, value: value)) } }
		if let value = sample as? HKQuantitySample {
			add("Recorded quantity", value.quantity.description)
			add("Quantity measurement count", String(value.count))
		}
		if let value = sample as? HKDiscreteQuantitySample {
			add("Minimum quantity", value.minimumQuantity.description); add("Average quantity", value.averageQuantity.description)
			add("Maximum quantity", value.maximumQuantity.description); add("Most recent quantity", value.mostRecentQuantity.description)
			add("Most recent start reference seconds", String(value.mostRecentQuantityDateInterval.start.timeIntervalSinceReferenceDate))
			add("Most recent end reference seconds", String(value.mostRecentQuantityDateInterval.end.timeIntervalSinceReferenceDate))
		}
		if let value = sample as? HKCumulativeQuantitySample {
			add("Sum quantity", value.sumQuantity.description)
		}
		if let value = sample as? HKCategorySample {
			add("Recorded value", String(value.value)); add("Meaning", summary(for: value))
		}
		if let value = sample as? HKCorrelation {
			for (index, component) in value.objects.sorted(by: { $0.uuid.uuidString < $1.uuid.uuidString }).enumerated() {
				// Components are independent stored records. Their source, device,
				// timestamps and metadata need not match the enclosing correlation.
				let fields = sections(for: component).flatMap { section in
					section.fields.map { HealthRecordField(name: section.title + " · " + $0.name, value: $0.value) }
				}
				result.append(.init(title: "Correlated measurement \(index + 1)", fields: fields))
			}
		}
		if let value = sample as? HKAudiogramSample {
			for (index, point) in value.sensitivityPoints.enumerated() {
				var fields: [HealthRecordField] = [.init(name: "Frequency", value: point.frequency.description)]
				if #available(iOS 18.1, *) {
					for (testIndex, test) in point.tests.enumerated() {
						let prefix = "Test \(testIndex + 1) · "
						fields.append(.init(name: prefix + "Sensitivity", value: test.sensitivity.description))
						fields.append(.init(name: prefix + "Side code", value: String(test.side.rawValue)))
						fields.append(.init(name: prefix + "Conduction code", value: String(test.type.rawValue)))
						fields.append(.init(name: prefix + "Masked", value: String(test.masked)))
						if let range = test.clampingRange {
							if let lower = range.lowerBound { fields.append(.init(name: prefix + "Clamping lower bound", value: lower.description)) }
							if let upper = range.upperBound { fields.append(.init(name: prefix + "Clamping upper bound", value: upper.description)) }
						}
					}
				} else {
					if let sensitivity = point.leftEarSensitivity { fields.append(.init(name: "Left ear", value: sensitivity.description)) }
					if let sensitivity = point.rightEarSensitivity { fields.append(.init(name: "Right ear", value: sensitivity.description)) }
				}
				result.append(.init(title: "Audiogram frequency \(index + 1)", fields: fields))
			}
		}
		if let value = sample as? HKElectrocardiogram {
			add("Classification", ecgClassification(value.classification.rawValue))
			add("Classification code", String(value.classification.rawValue))
			add("Symptoms code", String(value.symptomsStatus.rawValue))
			add("Voltage measurement count", String(value.numberOfVoltageMeasurements))
			add("Sampling frequency", value.samplingFrequency?.description)
			add("Average heart rate", value.averageHeartRate?.description)
		}
		if let value = sample as? HKHeartbeatSeriesSample { add("Heartbeat count", String(value.count)) }
		if let value = sample as? HKStateOfMind {
			add("Kind", stateOfMindKind(value.kind.rawValue)); add("Kind code", String(value.kind.rawValue))
			add("Valence", String(value.valence)); add("Valence classification code", String(value.valenceClassification.rawValue))
			add("Valence classification", label(value.valenceClassification.rawValue, names: ["Very unpleasant", "Unpleasant", "Slightly unpleasant", "Neutral", "Slightly pleasant", "Pleasant", "Very pleasant"]))
			add("Labels", value.labels.map { stateOfMindLabel($0.rawValue) }.joined(separator: ", "))
			add("Label codes", value.labels.map { String($0.rawValue) }.joined(separator: ", "))
			add("Associations", value.associations.map { stateOfMindAssociation($0.rawValue) }.joined(separator: ", "))
			add("Association codes", value.associations.map { String($0.rawValue) }.joined(separator: ", "))
		}
		if let value = sample as? HKScoredAssessment { add("Recorded score", String(value.score)) }
		if let value = sample as? HKGAD7Assessment {
			add("Answer codes", value.answers.map { String($0.rawValue) }.joined(separator: ", "))
			add("Recorded risk code", String(value.risk.rawValue))
			add("Recorded risk", label(value.risk.rawValue, names: ["None to minimal", "Mild", "Moderate", "Severe"]))
			for (index, answer) in value.answers.enumerated() { add("Question \(index + 1)", assessmentAnswer(answer.rawValue)) }
		}
		if let value = sample as? HKPHQ9Assessment {
			add("Answer codes", value.answers.map { String($0.rawValue) }.joined(separator: ", "))
			add("Recorded risk code", String(value.risk.rawValue))
			add("Recorded risk", label(value.risk.rawValue, names: ["None to minimal", "Mild", "Moderate", "Moderately severe", "Severe"]))
			for (index, answer) in value.answers.enumerated() { add("Question \(index + 1)", assessmentAnswer(answer.rawValue)) }
		}
		if let value = sample as? HKVisionPrescription {
			add("Prescription type code", String(value.prescriptionType.rawValue))
			add("Issued", dateText(value.dateIssued)); add("Expiration", value.expirationDate.map(dateText))
			add("Issued reference seconds", String(value.dateIssued.timeIntervalSinceReferenceDate))
			add("Expiration reference seconds", value.expirationDate.map { String($0.timeIntervalSinceReferenceDate) })
			if let glasses = value as? HKGlassesPrescription {
				if let lens = glasses.rightEye { result.append(.init(title: "Right eye", fields: lensFields(lens))) }
				if let lens = glasses.leftEye { result.append(.init(title: "Left eye", fields: lensFields(lens))) }
			}
			if let contacts = value as? HKContactsPrescription {
				add("Brand", contacts.brand)
				if let lens = contacts.rightEye { result.append(.init(title: "Right eye", fields: lensFields(lens))) }
				if let lens = contacts.leftEye { result.append(.init(title: "Left eye", fields: lensFields(lens))) }
			}
		}
		if let value = sample as? HKClinicalRecord {
			add("Record name", value.displayName)
			if let resource = value.fhirResource {
				add("FHIR identifier", resource.identifier); add("FHIR resource type", resource.resourceType.rawValue)
				add("FHIR version", resource.fhirVersion.stringRepresentation)
				add("FHIR release", resource.fhirVersion.fhirRelease.rawValue)
				add("FHIR source URL", resource.sourceURL?.absoluteString)
				add("Original FHIR JSON", String(data: resource.data, encoding: .utf8))
				add("Original FHIR bytes (base64)", resource.data.base64EncodedString())
			}
		}
		if let value = sample as? HKCDADocumentSample {
			if let document = value.document {
				add("Document title", document.title); add("Patient", document.patientName)
				add("Author", document.authorName); add("Custodian", document.custodianName)
				if let data = document.documentData {
					add("Original CDA XML", String(data: data, encoding: .utf8))
					add("Original CDA bytes (base64)", data.base64EncodedString())
				} else { add("Document content", "Not loaded. Open the original document to request its contents from Health.") }
			} else { add("Document content", "Not loaded. Open the original document to request its contents from Health.") }
		}
		if let value = sample as? HKWorkout {
			add("Activity type code", String(value.workoutActivityType.rawValue)); add("Duration (s)", String(value.duration))
			add("Total energy", value.totalEnergyBurned?.description); add("Total distance", value.totalDistance?.description)
			add("Swimming strokes", value.totalSwimmingStrokeCount?.description); add("Flights climbed", value.totalFlightsClimbed?.description)
			for (index, event) in (value.workoutEvents ?? []).enumerated() {
				result.append(.init(title: "Workout event \(index + 1)", fields: eventFields(event)))
			}
			result += statisticsSections(value.allStatistics, prefix: "Workout statistics")
			for (index, activity) in value.workoutActivities.enumerated() {
				let title = "Workout activity \(index + 1)", configuration = activity.workoutConfiguration
				var fields: [HealthRecordField] = [
					.init(name: "Activity UUID", value: activity.uuid.uuidString),
					.init(name: "Activity type code", value: String(configuration.activityType.rawValue)),
					.init(name: "Location code", value: String(configuration.locationType.rawValue)),
					.init(name: "Swimming location code", value: String(configuration.swimmingLocationType.rawValue)),
					.init(name: "Start reference seconds", value: String(activity.startDate.timeIntervalSinceReferenceDate)),
					.init(name: "Duration (s)", value: String(activity.duration)),
					.init(name: "Metadata", value: metadataText(activity.metadata))]
				if let end = activity.endDate { fields.append(.init(name: "End reference seconds", value: String(end.timeIntervalSinceReferenceDate))) }
				if let lap = configuration.lapLength { fields.append(.init(name: "Lap length", value: lap.description)) }
				result.append(.init(title: title, fields: fields))
				for (eventIndex, event) in activity.workoutEvents.enumerated() {
					result.append(.init(title: title + " · Event \(eventIndex + 1)", fields: eventFields(event)))
				}
				result += statisticsSections(activity.allStatistics, prefix: title + " · Statistics")
			}
		}
		if let value = sample as? HKVerifiableClinicalRecord {
			add("Record types", value.recordTypes.joined(separator: ", ")); add("Issuer", value.issuerIdentifier)
			add("Subject", value.subject.fullName)
			add("Subject date of birth components", value.subject.dateOfBirthComponents.map { String(describing: $0) })
			add("Issued", dateText(value.issuedDate)); add("Relevant date", dateText(value.relevantDate))
			add("Expiration", value.expirationDate.map(dateText)); add("Items", value.itemNames.joined(separator: ", "))
			add("Issued reference seconds", String(value.issuedDate.timeIntervalSinceReferenceDate))
			add("Relevant reference seconds", String(value.relevantDate.timeIntervalSinceReferenceDate))
			add("Expiration reference seconds", value.expirationDate.map { String($0.timeIntervalSinceReferenceDate) })
			add("Source type", value.sourceType?.rawValue)
			add("Original data (base64)", value.dataRepresentation.base64EncodedString())
		}
		if #available(iOS 26.0, *), let value = sample as? HKMedicationDoseEvent {
			add("Log status", medicationStatus(value.logStatus.rawValue)); add("Log status code", String(value.logStatus.rawValue))
			add("Schedule code", String(value.scheduleType.rawValue)); add("Scheduled date", value.scheduledDate.map(dateText))
			add("Scheduled date reference seconds", value.scheduledDate.map { String($0.timeIntervalSinceReferenceDate) })
			add("Dose quantity", value.doseQuantity.map { String($0) }); add("Scheduled dose quantity", value.scheduledDoseQuantity.map { String($0) })
			add("Recorded unit", value.unit.unitString); add("Medication concept domain", value.medicationConceptIdentifier.domain.rawValue)
			do {
				let archive = try NSKeyedArchiver.archivedData(withRootObject: value.medicationConceptIdentifier, requiringSecureCoding: true)
				add("Original medication concept identifier (archive, base64)", archive.base64EncodedString())
			} catch { add("Medication concept identifier archive", "Could not encode the original concept identifier.") }
		}
		if !details.isEmpty { result.insert(.init(title: "Recorded values", fields: details), at: 0) }
		let source = sample.sourceRevision
		var provenance: [HealthRecordField] = [
			.init(name: "Health UUID", value: sample.uuid.uuidString), .init(name: "Health type", value: sample.sampleType.identifier),
			.init(name: "Start", value: dateText(sample.startDate)), .init(name: "End", value: dateText(sample.endDate)),
			.init(name: "Start reference seconds", value: String(sample.startDate.timeIntervalSinceReferenceDate)),
			.init(name: "End reference seconds", value: String(sample.endDate.timeIntervalSinceReferenceDate)),
			.init(name: "Source", value: source.source.name), .init(name: "Source bundle", value: source.source.bundleIdentifier)]
		if let version = source.version { provenance.append(.init(name: "Source version", value: version)) }
		if let product = source.productType { provenance.append(.init(name: "Product type", value: product)) }
		let os = source.operatingSystemVersion
		provenance.append(.init(name: "Source OS", value: "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"))
		if let device = sample.device {
			for (name, value) in [("Device name", device.name), ("Manufacturer", device.manufacturer), ("Model", device.model),
				("Hardware", device.hardwareVersion), ("Firmware", device.firmwareVersion), ("Software", device.softwareVersion),
				("Local device identifier", device.localIdentifier), ("UDI device identifier", device.udiDeviceIdentifier)] {
				if let value = value { provenance.append(.init(name: name, value: value)) }
			}
		}
		result.append(.init(title: "Original Health record", fields: provenance))
		if let metadata = sample.metadata, !metadata.isEmpty {
			result.append(.init(title: "Metadata", fields: metadata.keys.sorted().compactMap { key in
				metadata[key].map { .init(name: key, value: valueText($0)) }
			}))
		}
		return result
	}

	private static func eventFields(_ event: HKWorkoutEvent) -> [HealthRecordField] {
		[.init(name: "Type code", value: String(event.type.rawValue)),
			.init(name: "Start reference seconds", value: String(event.dateInterval.start.timeIntervalSinceReferenceDate)),
			.init(name: "End reference seconds", value: String(event.dateInterval.end.timeIntervalSinceReferenceDate)),
			.init(name: "Metadata", value: metadataText(event.metadata))]
	}
	private static func statisticsSections(_ values: [HKQuantityType: HKStatistics], prefix: String) -> [HealthRecordSection] {
		var sections: [HealthRecordSection] = []
		for (type, stats) in values.sorted(by: { $0.key.identifier < $1.key.identifier }) {
			var fields: [HealthRecordField] = [
				.init(name: "Start reference seconds", value: String(stats.startDate.timeIntervalSinceReferenceDate)),
				.init(name: "End reference seconds", value: String(stats.endDate.timeIntervalSinceReferenceDate))]
			for (name, quantity) in [("Sum", stats.sumQuantity()), ("Average", stats.averageQuantity()),
				("Minimum", stats.minimumQuantity()), ("Maximum", stats.maximumQuantity()),
				("Most recent", stats.mostRecentQuantity()), ("Duration", stats.duration())] {
				if let quantity = quantity { fields.append(.init(name: name, value: quantity.description)) }
			}
			if let interval = stats.mostRecentQuantityDateInterval() {
				fields += [.init(name: "Most recent start reference seconds", value: String(interval.start.timeIntervalSinceReferenceDate)),
					.init(name: "Most recent end reference seconds", value: String(interval.end.timeIntervalSinceReferenceDate))]
			}
			sections.append(.init(title: prefix + " · " + type.identifier, fields: fields))
			for source in (stats.sources ?? []).sorted(by: { ($0.bundleIdentifier, $0.name) < ($1.bundleIdentifier, $1.name) }) {
				var fields: [HealthRecordField] = [.init(name: "Source", value: source.name), .init(name: "Source bundle", value: source.bundleIdentifier)]
				for (name, quantity) in [("Sum", stats.sumQuantity(for: source)), ("Average", stats.averageQuantity(for: source)),
					("Minimum", stats.minimumQuantity(for: source)), ("Maximum", stats.maximumQuantity(for: source)),
					("Most recent", stats.mostRecentQuantity(for: source)), ("Duration", stats.duration(for: source))] {
					if let quantity = quantity { fields.append(.init(name: name, value: quantity.description)) }
				}
				if let interval = stats.mostRecentQuantityDateInterval(for: source) {
					fields += [.init(name: "Most recent start reference seconds", value: String(interval.start.timeIntervalSinceReferenceDate)),
						.init(name: "Most recent end reference seconds", value: String(interval.end.timeIntervalSinceReferenceDate))]
				}
				sections.append(.init(title: prefix + " · " + type.identifier + " · Source", fields: fields))
			}
		}
		return sections
	}
	private static func lensFields(_ lens: HKLensSpecification) -> [HealthRecordField] {
		var fields = [HealthRecordField(name: "Sphere", value: lens.sphere.description)]
		for (name, quantity) in [("Cylinder", lens.cylinder), ("Axis", lens.axis), ("Add power", lens.addPower)] {
			if let quantity = quantity { fields.append(.init(name: name, value: quantity.description)) }
		}
		if let glasses = lens as? HKGlassesLensSpecification {
			for (name, quantity) in [("Vertex distance", glasses.vertexDistance), ("Far pupillary distance", glasses.farPupillaryDistance),
				("Near pupillary distance", glasses.nearPupillaryDistance)] {
				if let quantity = quantity { fields.append(.init(name: name, value: quantity.description)) }
			}
			if let prism = glasses.prism {
				fields += [.init(name: "Prism amount", value: prism.amount.description), .init(name: "Prism angle", value: prism.angle.description),
					.init(name: "Vertical prism", value: prism.verticalAmount.description), .init(name: "Horizontal prism", value: prism.horizontalAmount.description),
					.init(name: "Vertical base code", value: String(prism.verticalBase.rawValue)), .init(name: "Horizontal base code", value: String(prism.horizontalBase.rawValue)),
					.init(name: "Eye code", value: String(prism.eye.rawValue))]
			}
		}
		if let contacts = lens as? HKContactsLensSpecification {
			if let value = contacts.baseCurve { fields.append(.init(name: "Base curve", value: value.description)) }
			if let value = contacts.diameter { fields.append(.init(name: "Diameter", value: value.description)) }
		}
		return fields
	}
	public static func dateText(_ date: Date) -> String {
		dateLock.lock(); defer { dateLock.unlock() }
		return dates.string(from: date)
	}
	public static func metadataText(_ metadata: [String: Any]?) -> String {
		guard let metadata = metadata, !metadata.isEmpty else { return "{}" }
		return valueText(metadata)
	}
	public static func valueText(_ value: Any) -> String {
		if let date = value as? Date { return "Date(referenceSeconds: \(date.timeIntervalSinceReferenceDate))" }
		if let data = value as? Data { return "base64:" + data.base64EncodedString() }
		if let text = value as? String { return String(reflecting: text) }
		if let number = value as? NSNumber, CFGetTypeID(number) == CFBooleanGetTypeID() { return number.boolValue ? "true" : "false" }
		if let values = value as? [String: Any] {
			return "{" + values.keys.sorted().compactMap { key in
				values[key].map { String(reflecting: key) + ":" + valueText($0) }
			}.joined(separator: ",") + "}"
		}
		if let values = value as? [Any] { return "[" + values.map(valueText).joined(separator: ",") + "]" }
		return String(describing: value)
	}
	public static func stateOfMindKind(_ code: Int) -> String { code == 1 ? "Momentary emotion" : code == 2 ? "Daily mood" : "Unknown kind (\(code))" }
	public static func stateOfMindLabel(_ code: Int) -> String {
		label(code, names: ["Amazed", "Amused", "Angry", "Anxious", "Ashamed", "Brave", "Calm", "Content", "Disappointed", "Discouraged", "Disgusted", "Embarrassed", "Excited", "Frustrated", "Grateful", "Guilty", "Happy", "Hopeless", "Irritated", "Jealous", "Joyful", "Lonely", "Passionate", "Peaceful", "Proud", "Relieved", "Sad", "Scared", "Stressed", "Surprised", "Worried", "Annoyed", "Confident", "Drained", "Hopeful", "Indifferent", "Overwhelmed", "Satisfied"])
	}
	public static func stateOfMindAssociation(_ code: Int) -> String {
		label(code, names: ["Community", "Current events", "Dating", "Education", "Family", "Fitness", "Friends", "Health", "Hobbies", "Identity", "Money", "Partner", "Self-care", "Spirituality", "Tasks", "Travel", "Work", "Weather"])
	}
	private static func label(_ code: Int, names: [String]) -> String {
		guard code > 0, code <= names.count else { return "Unknown (\(code))" }
		return names[code - 1]
	}
	private static func assessmentAnswer(_ code: Int) -> String {
		let names = ["Not at all", "Several days", "More than half the days", "Nearly every day", "Prefer not to answer"]
		return names.indices.contains(code) ? names[code] + " (\(code))" : "Unknown (\(code))"
	}
	private static func ecgClassification(_ code: Int) -> String {
		let values = [0: "Not set", 1: "Sinus rhythm", 2: "Atrial fibrillation", 3: "Inconclusive: low heart rate", 4: "Inconclusive: high heart rate", 5: "Inconclusive: poor reading", 6: "Inconclusive: other", 100: "Unrecognized"]
		return values[code] ?? "Unknown (\(code))"
	}
	private static func medicationStatus(_ code: Int) -> String {
		label(code, names: ["Not interacted", "Notification not sent", "Snoozed", "Taken", "Skipped", "Not logged"])
	}
}
