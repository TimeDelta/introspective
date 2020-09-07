//
//  SampleFetcherFactory.swift
//  Samples
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SampleFetcherFactory {
	func activitySampleFetcher() -> SampleFetcher
	func bloodPressureSampleFetcher() -> SampleFetcher
	func bodyMassIndexSampleFetcher() -> SampleFetcher
	func heartRateSampleFetcher() -> SampleFetcher
	func leanBodyMassSampleFetcher() -> SampleFetcher
	func medicationDoseSampleFetcher() -> SampleFetcher
	func moodSampleFetcher() -> SampleFetcher
	func restingHeartRateSampleFetcher() -> SampleFetcher
	func sexualActivitySampleFetcher() -> SampleFetcher
	func sleepSampleFetcher() -> SampleFetcher
	func weightSampleFetcher() -> SampleFetcher
}

public final class SampleFetcherFactoryImpl: SampleFetcherFactory {
	public func activitySampleFetcher() -> SampleFetcher {
		ActivitySampleFetcher()
	}

	public func bloodPressureSampleFetcher() -> SampleFetcher {
		BloodPressureSampleFetcher()
	}

	public func bodyMassIndexSampleFetcher() -> SampleFetcher {
		BodyMassIndexSampleFetcher()
	}

	public func heartRateSampleFetcher() -> SampleFetcher {
		HeartRateSampleFetcher()
	}

	public func leanBodyMassSampleFetcher() -> SampleFetcher {
		LeanBodyMassSampleFetcher()
	}

	public func medicationDoseSampleFetcher() -> SampleFetcher {
		MedicationDoseSampleFetcher()
	}

	public func moodSampleFetcher() -> SampleFetcher {
		MoodSampleFetcher()
	}

	public func restingHeartRateSampleFetcher() -> SampleFetcher {
		RestingHeartRateSampleFetcher()
	}

	public func sexualActivitySampleFetcher() -> SampleFetcher {
		SexualActivitySampleFetcher()
	}

	public func sleepSampleFetcher() -> SampleFetcher {
		SleepSampleFetcher()
	}

	public func weightSampleFetcher() -> SampleFetcher {
		WeightSampleFetcher()
	}
}
