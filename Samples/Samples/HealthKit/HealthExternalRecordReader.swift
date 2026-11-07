import Foundation
import HealthKit

/// A public Health record that cannot be represented by an ordinary sample
/// query. Profile and medication-list entries deliberately have no event dates.
public struct HealthExternalRecord {
	public let identifier: String
	public let title: String
	public let sections: [HealthRecordSection]
	public let dates: [DateType: Date]
	public init(identifier: String, title: String, sections: [HealthRecordSection], dates: [DateType: Date] = [:]) {
		self.identifier = identifier; self.title = title; self.sections = sections; self.dates = dates
	}
}

/// Read-only adapters for characteristics, daily activity summaries, the
/// medication list, and user-selected verifiable records. Only the selected
/// family's permission is requested. The store is created on first real read.
public final class HealthExternalRecordReader {
	public typealias Authorization = (Set<HKObjectType>, @escaping (Error?) -> Void) -> Void
	public typealias ProfileRead = (HealthTypeDescriptor) throws -> HealthExternalRecord
	private let lock = NSLock()
	private var backingStore: HKHealthStore?
	private let authorization: Authorization?
	private let profileRead: ProfileRead?
	public init(store: HKHealthStore? = nil, authorization: Authorization? = nil, profileRead: ProfileRead? = nil) {
		backingStore = store; self.authorization = authorization; self.profileRead = profileRead
	}
	private func healthStore() -> HKHealthStore {
		lock.lock(); defer { lock.unlock() }
		if let store = backingStore { return store }
		let store = HKHealthStore(); backingStore = store; return store
	}
	private func authorize(_ types: Set<HKObjectType>, completion: @escaping (Error?) -> Void) {
		if let authorization = authorization { authorization(types, completion) }
		else { HealthReadAuthorizationClient(store: healthStore()).request(types: types, completion: completion) }
	}

	/// Completion may arrive on a HealthKit/background queue. A successful empty
	/// result does not establish that permission was denied or that data is absent.
	@discardableResult
	public func read(descriptor: HealthTypeDescriptor,
		completion: @escaping (Result<[HealthExternalRecord], Error>) -> Void) -> () -> Void {
		guard descriptor.isAvailableOnCurrentOS else {
			completion(.failure(HealthCatalogError.unavailable(descriptor.name))); return {}
		}
		guard [.characteristic, .activitySummary, .userAnnotatedMedication, .verifiableClinical, .attachment].contains(descriptor.family) else {
			completion(.failure(HealthExternalReadError.unsupportedFamily(descriptor.name))); return {}
		}
		guard descriptor.family != .attachment else {
			completion(.failure(HealthExternalReadError.parentRecordRequired)); return {}
		}
		let state = HealthExternalCollectionState<HealthExternalRecord>(completion: completion)
		if descriptor.family == .verifiableClinical {
			// This API presents Apple's one-time record selection. It does not use
			// an invented HKSampleType or request blanket clinical authorization.
			readVerifiable(state: state, credentialTypes: [.covid19, .immunization, .laboratory, .recovery])
			return { state.cancel() }
		}
		guard let type = HealthCatalogObjectTypes.objectType(for: descriptor) else {
			completion(.failure(HealthCatalogError.unavailable(descriptor.name))); return {}
		}
		authorize([type]) { [self] error in
			guard state.isActive else { return }
			if let error = error { state.fail(error); return }
			switch descriptor.family {
			case .characteristic:
				DispatchQueue.global(qos: .userInitiated).async {
					guard state.isActive else { return }
					do {
						let value = try self.profileRead?(descriptor) ?? Self.profileRecord(descriptor: descriptor, store: self.healthStore())
						if state.append([value]) { state.finish() }
					} catch { state.fail(error) }
				}
			case .activitySummary: self.readActivitySummaries(state: state)
			case .userAnnotatedMedication:
				if #available(iOS 26.0, *) { self.readMedicationList(state: state) }
				else { state.fail(HealthCatalogError.unavailable(descriptor.name)) }
			default: state.fail(HealthExternalReadError.unsupportedFamily(descriptor.name))
			}
		}
		return { state.cancel() }
	}

	private func readActivitySummaries(state: HealthExternalCollectionState<HealthExternalRecord>) {
		let store = healthStore(), calendar = Calendar.current
		let query = HKActivitySummaryQuery(predicate: nil) { _, values, error in
			if let error = error { state.fail(error); return }
			guard let values = values else { state.finish(); return }
			if state.append(values.map { Self.activityRecord($0, calendar: calendar) }) { state.finish() }
		}
		guard state.isActive else { return }
		store.execute(query)
		state.installCancellation { store.stop(query) }
	}

	@available(iOS 26.0, *)
	private func readMedicationList(state: HealthExternalCollectionState<HealthExternalRecord>) {
		let store = healthStore()
		let task = Task {
			do {
				let medications = try await HKUserAnnotatedMedicationQueryDescriptor().result(for: store)
				try Task.checkCancellation()
				let records = try medications.map(Self.medicationRecord)
				if state.append(records) { state.finish() }
			} catch { state.fail(error) }
		}
		state.installCancellation { task.cancel() }
	}

	/// A caller can request one credential kind from its selection screen. The
	/// catalog's all-records entry serializes all four public kinds, deduplicating
	/// records that contain more than one kind. Each request remains user-selected.
	@discardableResult
	public func readVerifiable(credentialTypes: [HKVerifiableClinicalRecordCredentialType],
		completion: @escaping (Result<[HealthExternalRecord], Error>) -> Void) -> () -> Void {
		let state = HealthExternalCollectionState<HealthExternalRecord>(completion: completion)
		readVerifiable(state: state, credentialTypes: credentialTypes)
		return { state.cancel() }
	}
	private func readVerifiable(state: HealthExternalCollectionState<HealthExternalRecord>,
		credentialTypes: [HKVerifiableClinicalRecordCredentialType]) {
		let store = healthStore()
		let task = Task {
			do {
				var seen = Set<UUID>(), requested = Set<String>()
				for kind in credentialTypes where requested.insert(kind.rawValue).inserted {
					try Task.checkCancellation()
					// Public documentation does not promise that an empty required-
					// type array means all records. Use one explicit kind per query.
					let descriptor = HKVerifiableClinicalRecordQueryDescriptor(recordTypes: [kind],
						sourceTypes: [.smartHealthCard, .euDigitalCOVIDCertificate])
					let values = try await descriptor.result(for: store)
					try Task.checkCancellation()
					let records = values.filter { seen.insert($0.uuid).inserted }.map { value in
						HealthExternalRecord(identifier: value.uuid.uuidString,
							title: value.itemNames.isEmpty ? "Verifiable Health record" : value.itemNames.joined(separator: ", "),
							sections: HealthRecordDetails.sections(for: value), dates: [.start: value.startDate, .end: value.endDate])
					}
					guard state.append(records) else { return }
				}
				state.finish()
			} catch { state.fail(error) }
		}
		state.installCancellation { task.cancel() }
	}

	private static func profileRecord(descriptor: HealthTypeDescriptor, store: HKHealthStore) throws -> HealthExternalRecord {
		if descriptor.identifier == "HKCharacteristicTypeIdentifierDateOfBirth" {
			return profileRecord(descriptor: descriptor, birthComponents: try store.dateOfBirthComponents())
		}
		let code: Int
		switch descriptor.identifier {
		case "HKCharacteristicTypeIdentifierBiologicalSex": code = try store.biologicalSex().biologicalSex.rawValue
		case "HKCharacteristicTypeIdentifierBloodType": code = try store.bloodType().bloodType.rawValue
		case "HKCharacteristicTypeIdentifierFitzpatrickSkinType": code = try store.fitzpatrickSkinType().skinType.rawValue
		case "HKCharacteristicTypeIdentifierWheelchairUse": code = try store.wheelchairUse().wheelchairUse.rawValue
		case "HKCharacteristicTypeIdentifierActivityMoveMode": code = try store.activityMoveMode().activityMoveMode.rawValue
		default: throw HealthCatalogError.unavailable(descriptor.name)
		}
		return profileRecord(descriptor: descriptor, code: code)
	}

	static func profileRecord(descriptor: HealthTypeDescriptor, code: Int) -> HealthExternalRecord {
		let names: [Int: String]
		switch descriptor.identifier {
		case "HKCharacteristicTypeIdentifierBiologicalSex": names = [0: "Not set", 1: "Female", 2: "Male", 3: "Other"]
		case "HKCharacteristicTypeIdentifierBloodType": names = [0: "Not set", 1: "A+", 2: "A−", 3: "B+", 4: "B−", 5: "AB+", 6: "AB−", 7: "O+", 8: "O−"]
		case "HKCharacteristicTypeIdentifierFitzpatrickSkinType": names = [0: "Not set", 1: "I", 2: "II", 3: "III", 4: "IV", 5: "V", 6: "VI"]
		case "HKCharacteristicTypeIdentifierWheelchairUse": names = [0: "Not set", 1: "No", 2: "Yes"]
		case "HKCharacteristicTypeIdentifierActivityMoveMode": names = [1: "Active energy", 2: "Move time"]
		default: names = [:]
		}
		return HealthExternalRecord(identifier: descriptor.identifier, title: descriptor.name, sections: [
			.init(title: "Health profile", fields: [.init(name: descriptor.name, value: names[code] ?? "Unknown (\(code))"),
				.init(name: "Recorded code", value: String(code))])])
	}
	static func profileRecord(descriptor: HealthTypeDescriptor, birthComponents: DateComponents) -> HealthExternalRecord {
		var fields: [HealthRecordField] = []
		for (name, value) in [("Era", birthComponents.era), ("Year", birthComponents.year),
			("Month", birthComponents.month), ("Day", birthComponents.day)] {
			if let value = value { fields.append(.init(name: name, value: String(value))) }
		}
		if let leap = birthComponents.isLeapMonth { fields.append(.init(name: "Leap month", value: String(leap))) }
		if let calendar = birthComponents.calendar { fields.append(.init(name: "Calendar", value: String(describing: calendar.identifier))) }
		if let zone = birthComponents.timeZone { fields.append(.init(name: "Time zone", value: zone.identifier)) }
		return HealthExternalRecord(identifier: descriptor.identifier, title: descriptor.name,
			sections: [.init(title: "Date-of-birth components", fields: fields)])
	}

	static func activityRecord(_ summary: HKActivitySummary, calendar: Calendar) -> HealthExternalRecord {
		let day = summary.dateComponents(for: calendar)
		let dayName = [day.year, day.month, day.day].map { $0.map(String.init) ?? "?" }.joined(separator: "-")
		let date = calendar.date(from: day).map { calendar.startOfDay(for: $0) }
		var fields: [HealthRecordField] = [.init(name: "Summary day", value: dayName),
			.init(name: "Calendar", value: String(describing: calendar.identifier)),
			.init(name: "Time zone", value: calendar.timeZone.identifier),
			.init(name: "Move mode code", value: String(summary.activityMoveMode.rawValue)),
			.init(name: "Rings paused", value: String(summary.isPaused))]
		for (name, quantity) in [("Active energy", Optional(summary.activeEnergyBurned)),
			("Active energy goal", Optional(summary.activeEnergyBurnedGoal)), ("Move time", Optional(summary.appleMoveTime)),
			("Move time goal", Optional(summary.appleMoveTimeGoal)), ("Exercise time", Optional(summary.appleExerciseTime)),
			("Exercise time goal", summary.exerciseTimeGoal), ("Stand hours", Optional(summary.appleStandHours)),
			("Stand hours goal", summary.standHoursGoal)] {
			if let quantity = quantity { fields.append(.init(name: name, value: quantity.description)) }
		}
		return HealthExternalRecord(identifier: "activity-summary:\(calendar.identifier):\(day.era ?? 0):\(dayName)",
			title: dayName, sections: [.init(title: "Daily activity summary", fields: fields)], dates: date.map { [.start: $0] } ?? [:])
	}

	@available(iOS 26.0, *)
	private static func medicationRecord(_ value: HKUserAnnotatedMedication) throws -> HealthExternalRecord {
		let medication = value.medication
		// The public concept identifier is opaque. Archive the actual NSSecureCoding
		// value instead of inventing an ID from a medicine's display name.
		let identifier = try NSKeyedArchiver.archivedData(withRootObject: medication.identifier, requiringSecureCoding: true).base64EncodedString()
		var fields: [HealthRecordField] = [.init(name: "Medication", value: medication.displayText),
			.init(name: "Concept domain", value: medication.identifier.domain.rawValue),
			.init(name: "Original concept identifier (archive, base64)", value: identifier),
			.init(name: "General form", value: medication.generalForm.rawValue),
			.init(name: "Archived", value: String(value.isArchived)), .init(name: "Has schedule", value: String(value.hasSchedule))]
		if let nickname = value.nickname { fields.append(.init(name: "Nickname", value: nickname)) }
		var sections = [HealthRecordSection(title: "Medication list entry", fields: fields)]
		for code in medication.relatedCodings.sorted(by: { ($0.system, $0.version ?? "", $0.code) < ($1.system, $1.version ?? "", $1.code) }) {
			var fields = [HealthRecordField(name: "System", value: code.system), .init(name: "Code", value: code.code)]
			if let version = code.version { fields.append(.init(name: "Version", value: version)) }
			sections.append(.init(title: "Clinical coding", fields: fields))
		}
		return HealthExternalRecord(identifier: "medication-concept:" + identifier,
			title: value.nickname.flatMap { $0.isEmpty ? nil : $0 } ?? medication.displayText, sections: sections)
	}
}

/// CDA content is intentionally separate from the metadata-only sample query.
/// Apple's document query requests access to this particular document on demand.
public final class HealthDocumentContentReader {
	private let store: HKHealthStore
	public init(store: HKHealthStore = HKHealthStore()) { self.store = store }
	@discardableResult
	public func read(document: HKCDADocumentSample,
		completion: @escaping (Result<HKCDADocumentSample, Error>) -> Void) -> () -> Void {
		let state = HealthExternalCollectionState<HKCDADocumentSample> { result in
			switch result {
			case .failure(let error): completion(.failure(error))
			case .success(let values):
				guard let value = values.first, value.uuid == document.uuid else {
					completion(.failure(HealthExternalReadError.missingDocument)); return
				}
				completion(.success(value))
			}
		}
		let query = HKDocumentQuery(documentType: document.documentType,
			predicate: HKQuery.predicateForObject(with: document.uuid), limit: 1, sortDescriptors: nil,
			includeDocumentData: true) { _, values, done, error in
			if let error = error { state.fail(error); return }
			guard let values = values else { state.fail(HealthExternalReadError.missingDocument); return }
			var documents: [HKCDADocumentSample] = []
			for value in values {
				guard let value = value as? HKCDADocumentSample, value.uuid == document.uuid else {
					state.fail(HealthExternalReadError.unexpectedDocument); return
				}
				documents.append(value)
			}
			guard state.append(documents) else { return }
			if done { state.finish() }
		}
		store.execute(query); state.installCancellation { [store] in store.stop(query) }
		return { state.cancel() }
	}
}

/// Attachments are scoped to an authorized parent record. Downloads stream into
/// a private caller-selected file instead of buffering a large document in RAM.
public final class HealthRecordAttachmentReader {
	private let attachmentStore: HKAttachmentStore
	public init(store: HKHealthStore = HKHealthStore()) { attachmentStore = HKAttachmentStore(healthStore: store) }
	@discardableResult
	public func readAttachments(for record: HKObject,
		completion: @escaping (Result<[HKAttachment], Error>) -> Void) -> () -> Void {
		let state = HealthExternalCollectionState<HKAttachment>(completion: completion)
		attachmentStore.getAttachments(for: record) { values, error in
			if let error = error { state.fail(error); return }
			if state.append(values ?? []) { state.finish() }
		}
		return { state.cancel() }
	}
	public static func sections(for attachment: HKAttachment) -> [HealthRecordSection] {
		var fields = [HealthRecordField(name: "Attachment UUID", value: attachment.identifier.uuidString),
			.init(name: "Name", value: attachment.name), .init(name: "Content type", value: attachment.contentType.identifier),
			.init(name: "Size (bytes)", value: String(attachment.size)),
			.init(name: "Created", value: HealthRecordDetails.dateText(attachment.creationDate)),
			.init(name: "Creation reference seconds", value: String(attachment.creationDate.timeIntervalSinceReferenceDate))]
		if let metadata = attachment.metadata { fields.append(.init(name: "Metadata", value: HealthRecordDetails.metadataText(metadata))) }
		return [.init(title: "Health record attachment", fields: fields)]
	}
	@discardableResult
	public func download(_ attachment: HKAttachment, to destination: URL,
		completion: @escaping (Result<URL, Error>) -> Void) -> () -> Void {
		do {
			let state = try HealthAttachmentFileState(destination: destination, expectedBytes: attachment.size, completion: completion)
			let progress = attachmentStore.streamData(for: attachment) { data, error, done in
				state.receive(data: data, error: error, done: done)
			}
			state.installCancellation { progress.cancel() }
			return { state.cancel() }
		} catch { completion(.failure(error)); return {} }
	}
}
