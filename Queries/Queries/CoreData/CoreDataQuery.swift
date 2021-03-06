//
//  CoreDataQuery.swift
//  Introspective
//
//  Created by Bryan Nova on 8/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import DependencyInjection
import Persistence
import Samples

public class CoreDataQuery<SampleType: NSManagedObject & CoreDataSample>: SampleQueryImpl<SampleType> {
	final override func run() {
		let fetchRequest: NSFetchRequest<SampleType> = NSFetchRequest<SampleType>(entityName: SampleType.entityName)
		fetchRequest.predicate = expression?.predicate()

		do {
			let samples: [SampleType] = try injected(Database.self).query(fetchRequest)

			if samples.isEmpty {
				queryDone(nil, NoSamplesFoundQueryError(sampleType: SampleType.self))
				return
			}

			let filteredSamples = try samples.filter(samplePassesFilters)

			if !stopped {
				let result = SampleQueryResult<SampleType>(filteredSamples)
				queryDone(result, nil)
			}
		} catch {
			queryDone(nil, error)
		}
	}

	/// CoreData FetchRequest's cannot be stopped once started
	public final override func stop() {
		super.stop()
	}
}
