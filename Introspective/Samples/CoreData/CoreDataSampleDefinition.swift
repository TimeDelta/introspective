//
//  CoreDataSampleDefinition.swift
//  Introspective
//
//  Created by Bryan Nova on 9/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class CoreDataSampleDefinition: NSObject, SampleDefinition, Codable {

	public final var name: String
	private final var _description: String
	public final override var description: String {
		get { return _description }
		set { _description = description }
	}

	public final var attributes: [AttributeBase]
	public final var startDateAttribute: AttributeBase
	public final var endDateAttribute: AttributeBase?

	public override init() {
		name = ""
		_description = ""
		attributes = [AttributeBase]()
		startDateAttribute = CommonSampleAttributes.timestamp
	}

	public init(from decoder: Decoder) throws {
	}

	public func encode(to encoder: Encoder) throws {
	}
}
