 //
//  Log.swift
//  Introspective
//
//  Created by Bryan Nova on 1/4/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import os
import _SwiftOSOverlayShims

public final class Log {

	// MARK: - Instance Variables

	private final var osLog: OSLog

	// MARK: - Initializers

	public init() {
		osLog = .default
	}

	public init(_ log: OSLog) {
		osLog = log
	}

	// MARK: - Logging Functions

	public final func write(_ message: StaticString, dso: UnsafeRawPointer? = #dsohandle, _ args: CVarArg...) {
		log(message, dso: dso, type: .default, args)
	}

	public final func info(_ message: StaticString, dso: UnsafeRawPointer? = #dsohandle, _ args: CVarArg...) {
		log(message, dso: dso, type: .info, args)
	}

	public final func debug(_ message: StaticString, dso: UnsafeRawPointer? = #dsohandle, _ args: CVarArg...) {
		log(message, dso: dso, type: .debug, args)
	}

	public final func error(_ message: StaticString, dso: UnsafeRawPointer? = #dsohandle, _ args: CVarArg...) {
		log(message, dso: dso, type: .error, args)
	}

	public final func fault(_ message: StaticString, dso: UnsafeRawPointer? = #dsohandle, _ args: CVarArg...) {
		log(message, dso: dso, type: .fault, args)
	}

	// MARK: - Helper Functions

	@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	private final func log(
		_ message: StaticString,
		dso: UnsafeRawPointer?,
		type: OSLogType = .default,
		_ arguments: [CVarArg])
	{
		// This crazy mess is because [CVarArg] gets treated as a single CVarArg and repassing a CVarArg... actually passes a [CVarArg]
		// This was copied from the publicly available Swift source code at https://github.com/apple/swift/blob/master/stdlib/public/Darwin/os/os_log.swift#L41
		// THIS IS A HACK
		guard osLog.isEnabled(type: type) else { return }
		let ra = _swift_os_log_return_address()

		message.withUTF8Buffer { (buf: UnsafeBufferPointer<UInt8>) in
			// Since dladdr is in libc, it is safe to unsafeBitCast
			// the cstring argument type.
			buf.baseAddress!.withMemoryRebound(
				to: CChar.self, capacity: buf.count
			) { str in
				withVaList(arguments) { valist in
					_swift_os_log(dso, ra, osLog, type, str, valist)
				}
			}
		}
	}
}
