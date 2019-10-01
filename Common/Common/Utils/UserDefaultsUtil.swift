//
//  UserDefaultsUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 4/24/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol UserDefaultsUtil {

	func resetInstructionPrompts()

	func setUserDefault<ValueType>(_ value: ValueType, forKey key: UserDefaultKey)

	func bool(forKey key: UserDefaultKey) -> Bool
}

public final class UserDefaultsUtilImpl: UserDefaultsUtil {

	public final func resetInstructionPrompts() {
		setUserDefault(false, forKey: .queryViewInstructionsShown)
		setUserDefault(false, forKey: .recordActivitiesInstructionsShown)
		setUserDefault(false, forKey: .recordMedicationsInstructionsShown)
		setUserDefault(false, forKey: .selectDateViewInstructionsShown)
	}

	public final func setUserDefault<ValueType>(_ value: ValueType, forKey key: UserDefaultKey) {
		UserDefaults().set(value, forKey: key.rawValue)
	}

	public final func bool(forKey key: UserDefaultKey) -> Bool {
		return UserDefaults().bool(forKey: key.rawValue)
	}
}
