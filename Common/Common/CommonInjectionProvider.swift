//
//  CommonInjectionProvider.swift
//  Common
//
//  Created by Bryan Nova on 9/30/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import DependencyInjection
import Foundation

public class CommonInjectionProvider: InjectionProvider {
	private typealias Me = CommonInjectionProvider

	private static let asyncUtil = AsyncUtilImpl()
	private static let calendarUtil = CalendarUtilImpl()
	private static let fatigueUiUtil = FatigueUiUtilImpl()
	private static let ioUtil = IOUtilImpl()
	private static let moodUiUtil = MoodUiUtilImpl()
	private static let notificationUtil = NotificationUtilImpl()
	private static let searchUtil = SearchUtilImpl()
	private static let stringUtil = StringUtilImpl()
	private static let textNormalizationUtil = TextNormalizationUtilImpl()
	private static let uiUtil = UiUtilImpl()
	private static let userDefaultsUtil = UserDefaultsUtilImpl()

	public let types: [Any.Type] = [
		AsyncUtil.self,
		CalendarUtil.self,
		FatigueUiUtil.self,
		IOUtil.self,
		MoodUiUtil.self,
		NotificationUtil.self,
		SearchUtil.self,
		StringUtil.self,
		TextNormalizationUtil.self,
		UiUtil.self,
		UserDefaultsUtil.self,
	]

	public init() {}

	public func get<Type>(_ type: Type.Type) throws -> Type {
		switch type {
		case is AsyncUtil.Protocol:
			return Me.asyncUtil as! Type
		case is CalendarUtil.Protocol:
			return Me.calendarUtil as! Type
		case is FatigueUiUtil.Protocol:
			return Me.fatigueUiUtil as! Type
		case is IOUtil.Protocol:
			return Me.ioUtil as! Type
		case is MoodUiUtil.Protocol:
			return Me.moodUiUtil as! Type
		case is NotificationUtil.Protocol:
			return Me.notificationUtil as! Type
		case is SearchUtil.Protocol:
			return Me.searchUtil as! Type
		case is StringUtil.Protocol:
			return Me.stringUtil as! Type
		case is TextNormalizationUtil.Protocol:
			return Me.textNormalizationUtil as! Type
		case is UiUtil.Protocol:
			return Me.uiUtil as! Type
		case is UserDefaultsUtil.Protocol:
			return Me.userDefaultsUtil as! Type
		default:
			throw GenericError("Unknown type: " + String(describing: type))
		}
	}
}
