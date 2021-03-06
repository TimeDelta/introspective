//
//  GlobalFunctions.swift
//  Introspective
//
//  Created by Bryan Nova on 12/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public func isOptional<Type>(_ instance: Type) -> Bool {
	let mirror = Mirror(reflecting: instance as Any)
	let style = mirror.displayStyle
	return style == .optional
}

public func retryOnFail<Type>(
	_ code: () throws -> Type,
	maxRetries: Int? = nil,
	_ firstError: Error? = nil
) throws -> Type {
	if let retries = maxRetries {
		guard retries >= 0 else {
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
			return try retryOnFail(code, maxRetries: retries - 1, firstError ?? error)
		}
		return try retryOnFail(code, firstError ?? error)
	}
}

public func retryOnFail(_ code: () throws -> Void, maxRetries: Int? = nil, _ firstError: Error? = nil) throws {
	if let retries = maxRetries {
		guard retries >= 0 else {
			guard let error = firstError else { return }
			throw error
		}
	}
	do {
		try code()
	} catch {
		if let retries = maxRetries {
			try retryOnFail(code, maxRetries: retries - 1, firstError ?? error)
		}
		try retryOnFail(code, firstError ?? error)
	}
}

public func errorInfo(_ error: Error) -> String {
	var errorDescription: String = error.localizedDescription
	if let customError = error as? GenericError {
		errorDescription = customError.description
	}
	return String(format: "(%@) %@ %@", versionString(), errorDescription, (error as NSError).userInfo)
}

public func copyArray<Type>(_ array: [Type]) -> [Type] {
	var copy = [Type]()
	copy.append(contentsOf: array)
	return copy
}

public func versionString() -> String {
	let gitStuff = GIT_SHA_VERSION + (UNCOMMITTED_CHANGES ? "*" : "")
	if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
		return version + " " + gitStuff
	} else {
		return gitStuff
	}
}

public func colorToHex(_ color: UIColor) -> String {
	guard let components = color.cgColor.components else {
		Log().error("Unable to color components: %@", color.description)
		return "#000000" // black
	}
	let r = Float(components[0])
	let g = Float(components[1])
	let b = Float(components[2])
	return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
}
