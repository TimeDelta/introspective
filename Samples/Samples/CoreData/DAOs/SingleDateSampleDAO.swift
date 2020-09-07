//
//  DAO.swift
//  Samples
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes

public class SingleDateSampleDAO<SampleType: CoreDataSample> {
	private let dateAttribute: DateAttribute

	internal init(dateAttribute: DateAttribute) {
		self.dateAttribute = dateAttribute
	}

	internal final func dateSpanPredicate(from minDate: NSDate?, to maxDate: NSDate?) -> NSPredicate {
		let fieldName = dateAttribute.variableName!
		if let min = minDate, let max = maxDate {
			return NSPredicate(format: "%@ >= %K AND %K <= %@", min, fieldName, fieldName, max)
		} else if let min = minDate {
			return NSPredicate(format: "%@ >= %K", min, fieldName)
		} else if let max = maxDate {
			return NSPredicate(format: "%K <= %@", fieldName, max)
		}
		return NSPredicate(format: "true")
	}
}
