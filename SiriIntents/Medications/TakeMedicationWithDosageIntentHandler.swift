//
//  TakeMedicationWithDosageIntentHandler.swift
//  SiriIntents
//
//  Created by Bryan Nova on 6/29/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import Intents

import Common
import DependencyInjection
import Persistence
import Samples

public final class TakeMedicationWithDosageIntentHandler: NSObject, TakeMedicationWithDosageIntentHandling {

	private typealias Me = TakeMedicationWithDosageIntentHandler

	private static let log = Log()

	public func resolveMedication(for intent: TakeMedicationWithDosageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
		Me.log.info("Resolving medication names")
		guard let medicationName = intent.medication else {
			completion(INStringResolutionResult.needsValue())
			return
		}
		completion(INStringResolutionResult.success(with: medicationName))
	}

	public func resolveDosage(for intent: TakeMedicationWithDosageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
		Me.log.info("Resolving dosage")
		guard let dosageText = intent.dosage else {
			completion(INStringResolutionResult.needsValue())
			return
		}
		guard let _ = Dosage(dosageText) else {
			completion(INStringResolutionResult.needsValue())
			return
		}
		completion(INStringResolutionResult.success(with: dosageText))
	}

	public func provideMedicationOptions(for intent: TakeMedicationWithDosageIntent, with completion: @escaping ([String]?, Error?) -> Void) {
		Me.log.info("Providing valid medication names")
		do {
			let medications = try DependencyInjector.get(Database.self).query(Medication.fetchRequest())
			completion(medications.map{ medication in medication.name }, nil)
		} catch {
			completion(nil, error)
		}
	}

	public func handle(intent: TakeMedicationWithDosageIntent, completion: @escaping (TakeMedicationWithDosageIntentResponse) -> Void) {
		Me.log.info("Handling TakeMedicationWithDosageIntent")
		guard let medicationName = intent.medication else {
			Me.log.error("Medication name was not provided for TakeMedicationWithDosageIntentHandler")
			completion(TakeMedicationWithDosageIntentResponse(code: .failure, userActivity: nil))
			return
		}
		guard let dosageText = intent.dosage else {
			Me.log.error("Medication dosage not provided for TakeMedicationWithDosageIntentHandler")
			completion(TakeMedicationWithDosageIntentResponse(code: .failure, userActivity: nil))
			return
		}

		do {
			guard let medication = try DependencyInjector.get(MedicationDAO.self).medicationNamed(medicationName) else {
				Me.log.error("Medication named %{private}@ does not exist.", medicationName)
				completion(TakeMedicationWithDosageIntentResponse.failure(dosage: dosageText, medication: medicationName))
				return
			}
			guard let dosage = Dosage(dosageText) else {
				Me.log.error("Invalid dosage text sent to TakeMedicationWithDosageIntentHandler: %@", dosageText)
				completion(TakeMedicationWithDosageIntentResponse.failure(dosage: dosageText, medication: medicationName))
				return
			}
			try DependencyInjector.get(MedicationDAO.self).createDose(medication: medication, dosage: dosage)
			completion(TakeMedicationWithDosageIntentResponse.success(dosage: dosageText, medication: medicationName))
		} catch {
			Me.log.error("Failed to retrieve MedicationDefinition for TakeMedicationIntentHandler: %@", errorInfo(error))
		}
	}
}
