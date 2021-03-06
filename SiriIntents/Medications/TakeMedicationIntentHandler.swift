//
//  TakeMedicationIntentHandler.swift
//  SiriIntents
//
//  Created by Bryan Nova on 6/26/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation
import Intents

import Common
import DependencyInjection
import Persistence
import Samples

public final class TakeMedicationIntentHandler: NSObject, TakeMedicationIntentHandling {
	private typealias Me = TakeMedicationIntentHandler

	private static let log = Log()

	public func resolveMedications(
		for intent: TakeMedicationIntent,
		with completion: @escaping ([INStringResolutionResult]) -> Void
	) {
		Me.log.info("Resolving medication names")
		guard let medicationNames = intent.medications else {
			completion([INStringResolutionResult.needsValue()])
			return
		}
		completion(medicationNames.map { n in INStringResolutionResult.success(with: n) })
	}

	public func provideMedicationsOptions(
		for _: TakeMedicationIntent,
		with completion: @escaping ([String]?, Error?) -> Void
	) {
		Me.log.info("Providing valid medication names")
		do {
			let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "recordScreenIndex", ascending: true)]
			let medications = try injected(Database.self).query(fetchRequest)
			completion(medications.map { medication in medication.name }, nil)
		} catch {
			Me.log.error("Failed to provide valid medication names: %@", errorInfo(error))
			completion(nil, error)
		}
	}

	public func handle(intent: TakeMedicationIntent, completion: @escaping (TakeMedicationIntentResponse) -> Void) {
		Me.log.info("Handling TakeMedicationIntent")
		guard let medicationNames = intent.medications else {
			Me.log.error("Medication names were not provided for TakeMedicationIntentHandler")
			completion(TakeMedicationIntentResponse(code: .failure, userActivity: nil))
			return
		}

		do {
			for name in medicationNames {
				guard let medication = try injected(MedicationDAO.self).medicationNamed(name) else {
					Me.log.error("Medication named %{private}@ does not exist.", name)
					completion(TakeMedicationIntentResponse.failure(medications: medicationNames))
					return
				}
				try injected(MedicationDAO.self).takeMedicationUsingDefaultDosage(medication)
			}
			injected(Database.self).setModifiedExternally(true)
			completion(TakeMedicationIntentResponse.success(medications: medicationNames))
		} catch {
			Me.log.error(
				"Failed to handle TakeMedicationIntentHandler: %@",
				errorInfo(error)
			)
			completion(TakeMedicationIntentResponse.failure(medications: medicationNames))
		}
	}
}
