//
//  Source.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

// for storage purposes, cannot use protocol here because protocols do not conform to themselves so have to use a type-eraser that just holds the protocol properties
class Source: NSObject, Codable {

	enum CodingKeys: CodingKey {
		case name
		case requiredFields
		case optionalFields
		case mappedColumnNames
	}

	var name: String
	public internal(set) var requiredFields: Array<SourceField>
	public internal(set) var optionalFields: Array<SourceField>
	public internal(set) var mappedColumnNames: [String: String]

	override init() {
		name = ""
		requiredFields = Array<SourceField>()
		optionalFields = Array<SourceField>()
		mappedColumnNames = [String: String]()
		super.init()
	}

	required convenience init(from decoder: Decoder) {
		self.init()
		do {
			let CONTAINER = try decoder.container(keyedBy: CodingKeys.self)
			name = try CONTAINER.decode(String.self, forKey: .name)
			requiredFields = try CONTAINER.decode([SourceField].self, forKey: .requiredFields)
			optionalFields = try CONTAINER.decode([SourceField].self, forKey: .optionalFields)
			mappedColumnNames = try CONTAINER.decode([String: String].self, forKey: .mappedColumnNames)
		} catch {
			os_log("Failed to decode Source (%@)", type: .error)
		}
	}

	func encode(to encoder: Encoder) {
		do {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(name, forKey: .name)
			try container.encode(requiredFields, forKey: .requiredFields)
			try container.encode(optionalFields, forKey: .optionalFields)
			try container.encode(mappedColumnNames, forKey: .mappedColumnNames)
		} catch {
			os_log("Failed to encode Source (%@)", type: .error, name)
		}
	}
}
