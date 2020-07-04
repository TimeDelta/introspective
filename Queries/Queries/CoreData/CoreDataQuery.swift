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
	override final func run() {
		let fetchRequest: NSFetchRequest<SampleType> = NSFetchRequest<SampleType>(entityName: SampleType.entityName)
		fetchRequest.predicate = expression?.predicate()

		do {
			let samples: [SampleType] = try DependencyInjector.get(Database.self).query(fetchRequest)

			if samples.isEmpty {
				queryDone(nil, NoSamplesFoundQueryError(sampleType: SampleType.self))
				return
			}

			let filteredSamples = try samples.filter(samplePassesFilters)

			if !stopped {
				if filteredSamples.isEmpty {
					queryDone(nil, NoSamplesFoundQueryError(sampleType: SampleType.self))
					return
				}

				let result = SampleQueryResult<SampleType>(filteredSamples)
				queryDone(result, nil)
			}
		} catch {
			queryDone(nil, error)
		}
	}

	/// CoreData FetchRequest's cannot be stopped once started
	override public final func stop() {
		super.stop()
	}
}
