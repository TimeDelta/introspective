//
//  CoreDataQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 8/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataQuery<SampleType: NSManagedObject & CoreDataSample>: SampleQueryImpl<SampleType> {

	final override func run() { 
		let fetchRequest: NSFetchRequest<SampleType> = NSFetchRequest<SampleType>(entityName: SampleType.entityName)
		fetchRequest.predicate = getPredicate()

		do {
			let samples: [SampleType] = try DependencyInjector.db.query(fetchRequest)

			if samples.count == 0 {
				self.queryDone(nil, NoSamplesFoundQueryError(sampleType: SampleType.self))
				return
			}

			let filteredSamples = samples.filter(self.samplePassesFilters)

			if !self.stopped {
				if filteredSamples.count == 0 {
					self.queryDone(nil, NoSamplesFoundQueryError(sampleType: SampleType.self))
					return
				}

				let result = SampleQueryResult<SampleType>(filteredSamples)
				self.queryDone(result, nil)
			}
		} catch {
			self.queryDone(nil, error)
			return
		}
	}

	/// CoreData FetchRequest's cannot be stopped once started
	public final override func stop() {
		super.stop()
	}
}
