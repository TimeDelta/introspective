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
		guard readContext?.isCancelled != true else { return }
		let fetchRequest: NSFetchRequest<SampleType> = NSFetchRequest<SampleType>(entityName: SampleType.entityName)
		fetchRequest.predicate = expression?.predicate()

		do {
			let samples: [SampleType]
			if let context = readContext?.context {
				fetchRequest.shouldRefreshRefetchedObjects = true
				samples = try context.fetch(fetchRequest)
			} else {
				samples = try injected(Database.self).query(fetchRequest)
			}
			guard readContext?.isCancelled != true else { return }

			if samples.isEmpty {
				queryDone(nil, NoSamplesFoundQueryError(sampleType: SampleType.self))
				return
			}

			let filteredSamples: [SampleType]
			if readContext != nil, fetchRequest.predicate != nil {
				// The scoped fetch applied the complete predicate with a fixed clock
				// and settings. Rebuilding it per row adds no further filtering.
				filteredSamples = samples
			} else {
				filteredSamples = try samples.filter(samplePassesFilters)
			}

			if !stopped && readContext?.isCancelled != true {
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
