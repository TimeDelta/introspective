//
//  SampleFetcher.swift
//  Samples
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import Samples

public protocol SampleFetcher {
	var sampleTypePluralName: String { get }

	func getSamples(from minDate: Date?, to maxDate: Date?) throws -> [Sample]
}

/// These DAOs return objects owned by Database's root view context.
/// Keep the fetch on its owner queue; callers must consume managed properties there too.
internal func fetchOnMainQueue<Value>(_ fetch: () throws -> Value) rethrows -> Value {
	if Thread.isMainThread { return try fetch() }
	return try DispatchQueue.main.sync(execute: fetch)
}
