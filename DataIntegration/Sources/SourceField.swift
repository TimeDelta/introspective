//
//  SourceField.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public final class SourceField: NSObject, Codable {

	private enum CodingKeys: CodingKey {
		case fieldName
		case fieldType
	}

	public enum FieldType: String, Codable {
		case DateTime
		case String
		case Integer
		case Decimal
		case List
	}

	public private(set) final var fieldName: String
	public private(set) final var fieldType: FieldType

	public override init() {
		fieldName = ""
		fieldType = FieldType.String
		super.init()
	}

	public init(name: String, type: FieldType) {
		self.fieldName = name
		self.fieldType = type
		super.init()
	}

	public required convenience init(from decoder: Decoder) {
		self.init()
		do {
			let CONTAINER = try decoder.container(keyedBy: CodingKeys.self)
			fieldName = try CONTAINER.decode(String.self, forKey: .fieldName)
			fieldType = try CONTAINER.decode(FieldType.self, forKey: .fieldType)
		} catch {
			os_log("Failed to decode SourceField", type: .error)
		}
	}

	public final func encode(to encoder: Encoder) {
		do {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(fieldName, forKey: .fieldName)
			try container.encode(fieldType, forKey: .fieldType)
		} catch {
			os_log("Failed to encode SourceField (%@)", type: .error, fieldName)
		}
	}
}
