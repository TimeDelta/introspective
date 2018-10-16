//
//  IOUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 10/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol IOUtil {
	func contentsOf(_ url: URL) throws -> String
}

public final class IOUtilImpl: IOUtil {

	public final func contentsOf(_ url: URL) throws -> String {
		return try String(contentsOf: url)
	}
}
