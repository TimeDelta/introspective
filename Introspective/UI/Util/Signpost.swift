//
//  Signpost.swift
//  Introspective
//
//  Created by Bryan Nova on 10/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public final class Signpost {

	private final let log: OSLog

	public init(log: OSLog) {
		self.log = log
	}

	public final func begin(name: StaticString, idObject: AnyObject? = nil) {
		if #available(iOS 12.0, *) {
			signpost(.begin, name: name, idObject: idObject)
		}
	}

	public final func begin(name: StaticString, idObject: AnyObject? = nil, _ format: StaticString, _ arguments: CVarArg...) {
		if #available(iOS 12.0, *) {
			signpost(.begin, name: name, idObject: idObject, format, arguments)
		}
	}

	public final func event(name: StaticString, idObject: AnyObject? = nil) {
		if #available(iOS 12.0, *) {
			signpost(.event, name: name, idObject: idObject)
		}
	}

	public final func event(name: StaticString, idObject: AnyObject? = nil, _ format: StaticString, _ arguments: CVarArg...) {
		if #available(iOS 12.0, *) {
			signpost(.event, name: name, idObject: idObject, format, arguments)
		}
	}

	public final func end(name: StaticString, idObject: AnyObject? = nil) {
		if #available(iOS 12.0, *) {
			signpost(.end, name: name)
		}
	}

	public final func end(name: StaticString, idObject: AnyObject? = nil, _ format: StaticString, _ arguments: CVarArg...) {
		if #available(iOS 12.0, *) {
			signpost(.end, name: name, idObject: idObject, format, arguments)
		}
	}

	@available(iOS 12.0, *)
	private final func signpost(_ type: OSSignpostType, name: StaticString, idObject: AnyObject? = nil) {
		if log.signpostsEnabled {
			if let idObject = idObject {
				let id = OSSignpostID(log: log, object: idObject)
				os_signpost(type, log: log, name: name, signpostID: id)
			} else {
				os_signpost(type, log: log, name: name)
			}
		}
	}

	@available(iOS 12.0, *)
	private final func signpost(_ type: OSSignpostType, name: StaticString, idObject: AnyObject? = nil, _ format: StaticString, _ arguments: CVarArg...) {
		if log.signpostsEnabled {
			if let idObject = idObject {
				let id = OSSignpostID(log: log, object: idObject)
				os_signpost(type, log: log, name: name, signpostID: id, format, arguments)
			} else {
				os_signpost(type, log: log, name: name, format, arguments)
			}
		}
	}
}
