//
//  AttributeFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class AttributeFactory {
	public static let allTypes: [Attribute.Type] = [
		TextAttribute.self,
		DateOnlyAttribute.self,
		DateTimeAttribute.self,
	]
}
