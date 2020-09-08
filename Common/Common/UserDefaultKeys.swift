//
//  UserDefaultKeys.swift
//  Introspective
//
//  Created by Bryan Nova on 2/17/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public enum UserDefaultKey: String {
	// MARK: - Instructions

	case queryViewInstructionsShown
	case recordActivitiesInstructionsShown
	case recordMedicationsInstructionsShown
	case selectDateViewInstructionsShown

	// MARK: - Enabled Timeline Data Sources

	case activityEnabledOnTimeline
	case bloodPressureEnabledOnTimeline
	case bodyMassIndexEnabledOnTimeline
	case heartRateEnabledOnTimeline
	case leanBodyMassEnabledOnTimeline
	case medicationDoseEnabledOnTimeline
	case moodEnabledOnTimeline
	case restingHeartRateEnabledOnTimeline
	case sexualActivityEnabledOnTimeline
	case sleepEnabledOnTimeline
	case weightEnabledOnTimeline
}
