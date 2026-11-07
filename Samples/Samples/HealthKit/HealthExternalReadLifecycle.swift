import Foundation

public enum HealthExternalReadError: LocalizedError, Equatable {
	case unsupportedFamily(String), parentRecordRequired, missingDocument, unexpectedDocument
	case attachmentDestinationExists, attachmentIncomplete, invalidAttachmentDestination
	public var errorDescription: String? {
		switch self {
		case .unsupportedFamily(let name): return "Use an ordinary Health sample query to read \(name)."
		case .parentRecordRequired: return "Attachments belong to individual Health records. Open a record to view its attachments."
		case .missingDocument: return "Health did not return this document. It may no longer exist or may not be shared."
		case .unexpectedDocument: return "Health returned a different document than the one selected."
		case .attachmentDestinationExists: return "An attachment file already exists at the selected destination."
		case .attachmentIncomplete: return "Health did not return the complete attachment."
		case .invalidAttachmentDestination: return "Choose a local file destination for the attachment."
		}
	}
}

/// One-shot result ownership shared by the dedicated readers. Cancellation
/// releases buffered values and the client closure, and never reports partial
/// results as a successful read. Client code is always called outside the lock.
final class HealthExternalCollectionState<Value> {
	private enum Status { case active, completed, failed, cancelled }
	private let lock = NSLock()
	private var status: Status = .active
	private var values: [Value] = []
	private var completion: ((Result<[Value], Error>) -> Void)?
	private var cancellation: (() -> Void)?
	init(completion: @escaping (Result<[Value], Error>) -> Void) { self.completion = completion }
	var isActive: Bool { lock.lock(); defer { lock.unlock() }; return status == .active }
	@discardableResult func append(_ batch: [Value]) -> Bool {
		lock.lock(); defer { lock.unlock() }
		guard status == .active else { return false }
		values.append(contentsOf: batch); return true
	}
	func installCancellation(_ action: @escaping () -> Void) {
		lock.lock()
		switch status {
		case .active: cancellation = action; lock.unlock()
		case .completed: lock.unlock()
		case .failed, .cancelled: lock.unlock(); action()
		}
	}
	func finish() {
		lock.lock()
		guard status == .active else { lock.unlock(); return }
		status = .completed
		let result = values, callback = completion
		values = []; completion = nil; cancellation = nil
		lock.unlock(); callback?(.success(result))
	}
	func fail(_ error: Error) {
		lock.lock()
		guard status == .active else { lock.unlock(); return }
		status = .failed
		let callback = completion, stop = cancellation
		values = []; completion = nil; cancellation = nil
		lock.unlock(); stop?(); callback?(.failure(error))
	}
	func cancel() {
		lock.lock()
		guard status == .active else { lock.unlock(); return }
		status = .cancelled
		let stop = cancellation
		values = []; completion = nil; cancellation = nil
		lock.unlock(); stop?()
	}
}

/// File I/O and terminal state share one short lock, so cancellation cannot
/// close a handle during a write or publish a partial file as complete.
final class HealthAttachmentFileState {
	private let lock = NSLock()
	private var completion: ((Result<URL, Error>) -> Void)?
	private var cancellation: (() -> Void)?
	private enum Status { case active, completed, failed, cancelled }
	private var status: Status = .active
	private var file: FileHandle?
	private let temporary: URL
	private let destination: URL
	private let expectedBytes: Int
	private var writtenBytes = 0
	init(destination: URL, expectedBytes: Int, completion: @escaping (Result<URL, Error>) -> Void) throws {
		guard destination.isFileURL else { throw HealthExternalReadError.invalidAttachmentDestination }
		guard expectedBytes >= 0 else { throw HealthExternalReadError.attachmentIncomplete }
		guard !FileManager.default.fileExists(atPath: destination.path) else { throw HealthExternalReadError.attachmentDestinationExists }
		self.destination = destination; self.expectedBytes = expectedBytes; self.completion = completion
		temporary = destination.deletingLastPathComponent().appendingPathComponent(UUID().uuidString + ".partial")
		guard FileManager.default.createFile(atPath: temporary.path, contents: nil,
			attributes: [.posixPermissions: 0o600]) else {
			throw CocoaError(.fileWriteUnknown)
		}
		do { file = try FileHandle(forWritingTo: temporary) }
		catch { try? FileManager.default.removeItem(at: temporary); throw error }
	}
	deinit { try? file?.close(); try? FileManager.default.removeItem(at: temporary) }
	func installCancellation(_ action: @escaping () -> Void) {
		lock.lock()
		switch status {
		case .active: cancellation = action; lock.unlock()
		case .completed: lock.unlock()
		case .failed, .cancelled: lock.unlock(); action()
		}
	}
	func receive(data: Data?, error: Error?, done: Bool) {
		lock.lock()
		guard let callback = completion else { lock.unlock(); return }
		do {
			if let error = error { throw error }
			if let data = data {
				guard data.count <= expectedBytes - writtenBytes else { throw HealthExternalReadError.attachmentIncomplete }
				guard let file = file else { throw CocoaError(.fileWriteUnknown) }
				try file.write(contentsOf: data); writtenBytes += data.count
			}
			guard done else { lock.unlock(); return }
			guard writtenBytes == expectedBytes else { throw HealthExternalReadError.attachmentIncomplete }
			try file?.close(); file = nil
			try FileManager.default.moveItem(at: temporary, to: destination)
			status = .completed; completion = nil; cancellation = nil
			lock.unlock(); callback(.success(destination))
		} catch {
			status = .failed; completion = nil
			let stop = cancellation; cancellation = nil
			try? file?.close(); file = nil; try? FileManager.default.removeItem(at: temporary)
			lock.unlock(); stop?(); callback(.failure(error))
		}
	}
	func cancel() {
		lock.lock()
		guard completion != nil else { lock.unlock(); return }
		status = .cancelled; completion = nil
		let stop = cancellation; cancellation = nil
		try? file?.close(); file = nil; try? FileManager.default.removeItem(at: temporary)
		lock.unlock(); stop?()
	}
}
