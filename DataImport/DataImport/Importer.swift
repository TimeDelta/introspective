//
//  Importer.swift
//  Introspective
//
//  Created by Bryan Nova on 9/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
public protocol Importer {
	var dataTypePluralName: String { get }
	var sourceName: String { get }
	/// This will be displayed to the user as the message of the "Import new data only?" prompt
	var customImportMessage: String? { get }
	var lastImport: Date? { get }
	var isPaused: Bool { get }
	var isCancelled: Bool { get }
	var importOnlyNewData: Bool { get set }

	func importData(from url: URL) throws
	func resetLastImportDate() throws

	/// - Returns: A value between 0 and 1
	func percentComplete() -> Double

	/// Once cancelled, an import cannot be resumed.
	func cancel()
	func pause()
	func resume() throws

	func equalTo(_ other: Importer) -> Bool
}

public extension Importer {
	func equalTo(_ other: Importer) -> Bool {
		type(of: self) == type(of: other) && lastImport == other.lastImport
	}
}

/// Serializes lifecycle transitions without holding a lock during Core Data work.
/// Cancellation requests rollback on the importing thread, after its current row.
internal final class ImporterExecution {
	internal enum StateError: Error { case alreadyRunning }
	private let lock = NSRecursiveLock()
	private var owner: Thread?
	private var committing = false
	private var cancelled = false
	private var paused = false
	private var completed = -1
	private var total = -1
	// A deterministic boundary for cancellation integration tests; normally nil.
	internal var beforeResume: (() -> Void)?

	internal var isCancelled: Bool {
		get { locked { cancelled } }
		set { locked { if !committing { cancelled = newValue } } }
	}
	internal var isPaused: Bool {
		get { locked { paused } }
		set { locked { paused = newValue } }
	}
	internal var recordNumber: Int {
		get { locked { completed } }
		set { locked { completed = newValue } }
	}
	internal var totalLines: Int {
		get { locked { total } }
		set { locked { total = newValue } }
	}

	internal func cancel(rollback: () -> Void) {
		lock.lock()
		// Once the final save begins, let that atomic operation finish.
		guard !committing else { lock.unlock(); return }
		cancelled = true
		guard owner == nil else { lock.unlock(); return }
		owner = Thread.current
		lock.unlock()
		rollback()
		locked { owner = nil }
	}

	internal func execute(newImport: Bool = false, rollback: () -> Void, work: () throws -> Void) throws {
		lock.lock()
		if let owner = owner {
			let nestedResume = !newImport && owner === Thread.current
			lock.unlock()
			guard nestedResume else { throw StateError.alreadyRunning }
			try work()
			return
		}
		owner = Thread.current
		if newImport { cancelled = false; paused = false; completed = -1; total = -1 }
		lock.unlock()
		var failed = false
		defer {
			lock.lock()
			if cancelled || failed {
				lock.unlock()
				rollback()
				lock.lock()
			}
			committing = false
			owner = nil
			lock.unlock()
		}
		do { try work() } catch { failed = true; throw error }
	}

	internal func commit(_ work: () throws -> Void) throws {
		lock.lock()
		guard !cancelled else { lock.unlock(); return }
		committing = true
		lock.unlock()
		try work()
	}

	private func locked<T>(_ work: () -> T) -> T {
		lock.lock(); defer { lock.unlock() }
		return work()
	}
}
