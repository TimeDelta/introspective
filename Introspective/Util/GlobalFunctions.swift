//
//  GlobalFunctions.swift
//  Introspective
//
//  Created by Bryan Nova on 12/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

func isOptional(_ instance: Any?) -> Bool {
	let mirror = Mirror(reflecting: instance as Any)
	let style = mirror.displayStyle
	return style == .optional
}

func retryOnFail(_ code: () throws -> Void, maxRetries: Int? = nil, _ firstError: Error? = nil) throws {
	do {
		if let retries = maxRetries {
			guard retries > 0 else {
				guard let error = firstError else { return }
				throw error
			}
		}
		try code()
	} catch {
		if let retries = maxRetries {
			try retryOnFail(code, maxRetries: retries - 1, error)
		}
		try retryOnFail(code, error)
	}
}
