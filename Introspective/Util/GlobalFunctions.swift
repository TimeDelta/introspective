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

func retryOnFail<Type>(_ code: () throws -> Type, maxRetries: Int? = nil, _ firstError: Error? = nil) throws -> Type {
	if let retries = maxRetries {
		guard retries > 0 else {
			guard let error = firstError else {
				throw GenericError("Unable to determine error to throw in retryOnFail()")
			}
			throw error
		}
	}
	do {
		return try code()
	} catch {
		if let retries = maxRetries {
			return try retryOnFail(code, maxRetries: retries - 1, error)
		}
		return try retryOnFail(code, error)
	}
}

func retryOnFail(_ code: () throws -> Void, maxRetries: Int? = nil, _ firstError: Error? = nil) throws {
	if let retries = maxRetries {
		guard retries > 0 else {
			guard let error = firstError else { return }
			throw error
		}
	}
	do {
		try code()
	} catch {
		if let retries = maxRetries {
			try retryOnFail(code, maxRetries: retries - 1, error)
		}
		try retryOnFail(code, error)
	}
}

func errorInfo(_ error: Error) -> String {
	return String(format: "%@ %@", error.localizedDescription, (error as NSError).userInfo)
}
