//
//  Signpost.swift
//  Introspective
//
//  Created by Bryan Nova on 10/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os
import _SwiftOSOverlayShims

public final class Signpost {

	private final let log: OSLog

	public init(log: OSLog) {
		self.log = log
	}

	public final func begin(name: StaticString, dso: UnsafeRawPointer = #dsohandle, idObject: AnyObject? = nil) {
		if #available(iOS 12.0, *) {
			signpost(.begin, dso: dso, name: name, idObject: idObject)
		}
	}

	public final func begin(name: StaticString, dso: UnsafeRawPointer = #dsohandle, idObject: AnyObject? = nil, _ format: StaticString, _ arguments: CVarArg...) {
		if #available(iOS 12.0, *) {
			signpost(.begin, dso: dso, name: name, idObject: idObject, format, arguments)
		}
	}

	public final func event(name: StaticString, dso: UnsafeRawPointer = #dsohandle, idObject: AnyObject? = nil) {
		if #available(iOS 12.0, *) {
			signpost(.event, dso: dso, name: name, idObject: idObject)
		}
	}

	public final func event(name: StaticString, dso: UnsafeRawPointer = #dsohandle, idObject: AnyObject? = nil, _ format: StaticString, _ arguments: CVarArg...) {
		if #available(iOS 12.0, *) {
			signpost(.event, dso: dso, name: name, idObject: idObject, format, arguments)
		}
	}

	public final func end(name: StaticString, dso: UnsafeRawPointer = #dsohandle, idObject: AnyObject? = nil) {
		if #available(iOS 12.0, *) {
			signpost(.end, dso: dso, name: name, idObject: idObject)
		}
	}

	public final func end(name: StaticString, dso: UnsafeRawPointer = #dsohandle, idObject: AnyObject? = nil, _ format: StaticString, _ arguments: CVarArg...) {
		if #available(iOS 12.0, *) {
			signpost(.end, dso: dso, name: name, idObject: idObject, format, arguments)
		}
	}

	@available(iOS 12.0, *)
	private final func signpost(_ type: OSSignpostType, dso: UnsafeRawPointer = #dsohandle, name: StaticString, idObject: AnyObject? = nil) {
		guard log.signpostsEnabled else { return }
		let signpostID = getSignpostId(forObject: idObject)
		os_signpost(type, dso: dso, log: log, name: name, signpostID: signpostID)
	}

	@available(iOS 12.0, *)
	private final func signpost(
		_ type: OSSignpostType,
		dso: UnsafeRawPointer,
		name: StaticString,
		idObject: AnyObject? = nil,
		_ format: StaticString,
		_ arguments: [CVarArg])
	{
		// This crazy mess is because [CVarArg] gets treated as a single CVarArg and repassing a CVarArg... actually passes a [CVarArg]
		// This was copied from the publicly available Swift source code at https://github.com/apple/swift/blob/master/stdlib/public/Darwin/os/os_signpost.swift#L40
		// THIS IS A HACK
		guard log.signpostsEnabled else { return }
		let signpostID = getSignpostId(forObject: idObject)
		guard signpostID != .invalid && signpostID != .null else { return }
		let ra = _swift_os_log_return_address()
		name.withUTF8Buffer { (nameBuf: UnsafeBufferPointer<UInt8>) in
			// Since dladdr is in libc, it is safe to unsafeBitCast
			// the cstring argument type.
			nameBuf.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nameBuf.count) { nameStr in
				format.withUTF8Buffer { (formatBuf: UnsafeBufferPointer<UInt8>) in
					// Since dladdr is in libc, it is safe to unsafeBitCast
					// the cstring argument type.
					formatBuf.baseAddress!.withMemoryRebound(to: CChar.self, capacity: formatBuf.count) { formatStr in
						withVaList(arguments) { valist in
							_swift_os_signpost_with_format(dso, ra, log, type, nameStr, signpostID.rawValue, formatStr, valist)
						}
					}
				}
			}
		}
	}

	@available(iOS 12.0, *)
	private final func getSignpostId(forObject idObject: AnyObject?) -> OSSignpostID {
		if let idObject = idObject {
			return OSSignpostID(log: log, object: idObject)
		}
		return .exclusive
	}
}
