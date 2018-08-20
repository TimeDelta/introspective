//
//  CoreDataQuery.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataQuery<SampleType: NSManagedObject & CoreDataSample>: SampleQueryImpl<SampleType> {

	fileprivate let dataType: DataTypes

	public init(dataType: DataTypes) {
		self.dataType = dataType
	}

	override func run() {
		let fetchRequest: NSFetchRequest<SampleType> = NSFetchRequest<SampleType>(entityName: SampleType.entityName)
		fetchRequest.predicate = getPredicate()

		do {
			let samples: [SampleType] = try DependencyInjector.db.query(fetchRequest)

			if samples.count == 0 {
				self.queryDone(nil, NoSamplesFoundQueryError(dataType: dataType))
				return
			}

			let result = SampleQueryResult<SampleType>(samples)
			self.queryDone(result, nil)
		} catch {
			self.queryDone(nil, error)
			return
		}
	}

	fileprivate func getPredicate() -> NSPredicate {
		var subPredicates = [NSPredicate]()
		for attributeRestriction in attributeRestrictions {
			if let predicateRestriction = attributeRestriction as? PredicateAttributeRestriction {
				subPredicates.append(predicateRestriction.toPredicate())
			}
		}
		return NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
	}
}
