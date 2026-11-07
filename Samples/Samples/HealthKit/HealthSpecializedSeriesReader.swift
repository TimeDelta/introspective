import Foundation
import HealthKit
import CoreLocation

/// Values remain in their recorded order. Offsets are relative to the Health
/// sample's original start date; gaps are not filled or interpolated.
public struct HealthECGMeasurement: Equatable {
	public let timeSinceSampleStart: TimeInterval
	public let voltageInMillivolts: Double?
	public init(timeSinceSampleStart: TimeInterval, voltageInMillivolts: Double?) {
		self.timeSinceSampleStart = timeSinceSampleStart
		self.voltageInMillivolts = voltageInMillivolts
	}
}

public struct HealthHeartbeatMeasurement: Equatable {
	public let timeSinceSeriesStart: TimeInterval
	public let precededByGap: Bool
	public init(timeSinceSeriesStart: TimeInterval, precededByGap: Bool) {
		self.timeSinceSeriesStart = timeSinceSeriesStart
		self.precededByGap = precededByGap
	}
}

/// Keep the public quantity object and its exact interval. Series points can
/// have different durations; treating them as equally spaced loses data.
public struct HealthQuantityMeasurement {
	public let quantity: HKQuantity
	public let dateInterval: DateInterval
	public init(quantity: HKQuantity, dateInterval: DateInterval) {
		self.quantity = quantity; self.dateInterval = dateInterval
	}
}

/// CLLocation is immutable. Retain the original instead of reconstructing a
/// coordinate and losing accuracy, timestamp, floor, speed or source information.
public struct HealthRouteLocation {
	public let location: CLLocation
	public var timestamp: Date { location.timestamp }
	public var latitude: Double { location.coordinate.latitude }
	public var longitude: Double { location.coordinate.longitude }
	public var altitude: Double { location.altitude }
	public var horizontalAccuracy: Double { location.horizontalAccuracy }
	public var verticalAccuracy: Double { location.verticalAccuracy }
	public var speed: Double? { location.speed >= 0 ? location.speed : nil }
	public var course: Double? { location.course >= 0 ? location.course : nil }
	public init(location: CLLocation) { self.location = location }
}

public enum HealthSeriesSnapshot {
	case ecg([HealthECGMeasurement])
	case route([HealthRouteLocation])
	case heartbeat([HealthHeartbeatMeasurement])
	case quantity([HealthQuantityMeasurement])
}

public enum HealthSeriesReadError: LocalizedError, Equatable {
	case unsupportedSampleType(String)
	case unexpectedSeriesKind
	case unexpectedQuantitySample
	public var errorDescription: String? {
		switch self {
		case let .unsupportedSampleType(identifier): return "No series reader is available for \(identifier)."
		case .unexpectedSeriesKind: return "Health returned an unexpected kind of series data."
		case .unexpectedQuantitySample: return "Health returned measurements for a different Health record."
		}
	}
}

/// Reads the underlying records through public async HealthKit descriptors.
/// Cancelling their task also cancels the underlying HealthKit query. No Health
/// store is constructed for unsupported samples or until a supported read starts.
public final class HealthSpecializedSeriesReader {
	private let storeLock = NSLock()
	private var backingStore: HKHealthStore?
	public init(store: HKHealthStore? = nil) { backingStore = store }
	private func healthStore() -> HKHealthStore {
		storeLock.lock(); defer { storeLock.unlock() }
		if let store = backingStore { return store }
		let store = HKHealthStore(); backingStore = store; return store
	}

	/// Completion runs on the reader's executor, once after all records arrive.
	/// Cancellation drops buffered records and suppresses subsequent completion;
	/// it does not fabricate a partial successful series.
	@discardableResult
	public func read(sample: HKSample,
		completion: @escaping (Result<HealthSeriesSnapshot, Error>) -> Void) -> () -> Void {
		let kind: HealthSeriesReadState.Kind
		if sample is HKElectrocardiogram { kind = .ecg }
		else if sample is HKWorkoutRoute { kind = .route }
		else if sample is HKHeartbeatSeriesSample { kind = .heartbeat }
		else if sample is HKQuantitySample { kind = .quantity }
		else {
			completion(.failure(HealthSeriesReadError.unsupportedSampleType(sample.sampleType.identifier)))
			return {}
		}
		let state = HealthSeriesReadState(kind: kind, completion: completion)
		let store = healthStore()
		let task = Task {
			do {
				if let ecg = sample as? HKElectrocardiogram {
					for try await measurement in HKElectrocardiogramQueryDescriptor(ecg).results(for: store) {
						try Task.checkCancellation()
						let voltage = measurement.quantity(for: .appleWatchSimilarToLeadI)?
							.doubleValue(for: HKUnit.voltUnit(with: .milli))
						guard state.appendECG(HealthECGMeasurement(timeSinceSampleStart: measurement.timeSinceSampleStart,
							voltageInMillivolts: voltage)) else { return }
					}
				} else if let route = sample as? HKWorkoutRoute {
					for try await location in HKWorkoutRouteQueryDescriptor(route).results(for: store) {
						try Task.checkCancellation()
						guard state.appendRoute(HealthRouteLocation(location: location)) else { return }
					}
				} else if let heartbeats = sample as? HKHeartbeatSeriesSample {
					for try await heartbeat in HKHeartbeatSeriesQueryDescriptor(heartbeats).results(for: store) {
						try Task.checkCancellation()
						guard state.appendHeartbeat(HealthHeartbeatMeasurement(timeSinceSeriesStart: heartbeat.timeIntervalSinceStart,
							precededByGap: heartbeat.precededByGap)) else { return }
					}
				} else if let quantitySample = sample as? HKQuantitySample {
					let predicate = HKSamplePredicate<HKQuantitySample>.quantitySample(type: quantitySample.quantityType,
						predicate: HKQuery.predicateForObject(with: quantitySample.uuid))
					let descriptor = HKQuantitySeriesSampleQueryDescriptor(predicate: predicate, options: [.includeSample])
					for try await measurement in descriptor.results(for: store) {
						try Task.checkCancellation()
						guard measurement.sample?.uuid == quantitySample.uuid else {
							throw HealthSeriesReadError.unexpectedQuantitySample
						}
						guard state.appendQuantity(HealthQuantityMeasurement(quantity: measurement.quantity,
							dateInterval: measurement.dateInterval)) else { return }
					}
				}
				try Task.checkCancellation()
				state.finish()
			} catch { state.fail(error) }
		}
		state.installCancellation { task.cancel() }
		return { state.cancel() }
	}
}

/// This state machine owns only value snapshots. Its short lock protects the
/// cancellation/result race and is never held while calling client code.
final class HealthSeriesReadState {
	enum Kind { case ecg, route, heartbeat, quantity }
	private enum Status { case active, completed, failed, cancelled }
	private let kind: Kind
	private let lock = NSLock()
	private var status: Status = .active
	private var cancellation: (() -> Void)?
	private var completion: ((Result<HealthSeriesSnapshot, Error>) -> Void)?
	private var ecg: [HealthECGMeasurement] = []
	private var route: [HealthRouteLocation] = []
	private var heartbeats: [HealthHeartbeatMeasurement] = []
	private var quantities: [HealthQuantityMeasurement] = []
	init(kind: Kind, completion: @escaping (Result<HealthSeriesSnapshot, Error>) -> Void) {
		self.kind = kind; self.completion = completion
	}
	func installCancellation(_ action: @escaping () -> Void) {
		lock.lock()
		switch status {
		case .active: cancellation = action; lock.unlock()
		case .completed: lock.unlock()
		case .failed, .cancelled: lock.unlock(); action()
		}
	}
	@discardableResult func appendECG(_ value: HealthECGMeasurement) -> Bool {
		lock.lock()
		guard status == .active else { lock.unlock(); return false }
		guard kind == .ecg else { lock.unlock(); fail(HealthSeriesReadError.unexpectedSeriesKind); return false }
		ecg.append(value); lock.unlock(); return true
	}
	@discardableResult func appendRoute(_ value: HealthRouteLocation) -> Bool {
		lock.lock()
		guard status == .active else { lock.unlock(); return false }
		guard kind == .route else { lock.unlock(); fail(HealthSeriesReadError.unexpectedSeriesKind); return false }
		route.append(value); lock.unlock(); return true
	}
	@discardableResult func appendHeartbeat(_ value: HealthHeartbeatMeasurement) -> Bool {
		lock.lock()
		guard status == .active else { lock.unlock(); return false }
		guard kind == .heartbeat else { lock.unlock(); fail(HealthSeriesReadError.unexpectedSeriesKind); return false }
		heartbeats.append(value); lock.unlock(); return true
	}
	@discardableResult func appendQuantity(_ value: HealthQuantityMeasurement) -> Bool {
		lock.lock()
		guard status == .active else { lock.unlock(); return false }
		guard kind == .quantity else { lock.unlock(); fail(HealthSeriesReadError.unexpectedSeriesKind); return false }
		quantities.append(value); lock.unlock(); return true
	}
	func finish() {
		lock.lock()
		guard status == .active else { lock.unlock(); return }
		let snapshot: HealthSeriesSnapshot
		switch kind {
		case .ecg: snapshot = .ecg(ecg)
		case .route: snapshot = .route(route)
		case .heartbeat: snapshot = .heartbeat(heartbeats)
		case .quantity: snapshot = .quantity(quantities)
		}
		status = .completed
		let callback = completion
		completion = nil; cancellation = nil; clear()
		lock.unlock(); callback?(.success(snapshot))
	}
	func fail(_ error: Error) {
		lock.lock()
		guard status == .active else { lock.unlock(); return }
		status = .failed
		let callback = completion, stop = cancellation
		completion = nil; cancellation = nil; clear()
		lock.unlock(); stop?(); callback?(.failure(error))
	}
	func cancel() {
		lock.lock()
		guard status == .active else { lock.unlock(); return }
		status = .cancelled
		let stop = cancellation
		completion = nil; cancellation = nil; clear()
		lock.unlock(); stop?()
	}
	private func clear() { ecg.removeAll(); route.removeAll(); heartbeats.removeAll(); quantities.removeAll() }
}
