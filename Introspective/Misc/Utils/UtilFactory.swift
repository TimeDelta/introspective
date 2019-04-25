//
//  UtilFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class UtilFactory {

	private typealias Me = UtilFactory

	private static let realCalendarUtil = CalendarUtilImpl()
	private static let realHKQuantitySampleUtil = NumericSampleUtilImpl()
	private static let realTextNormalizationUtil = TextNormalizationUtilImpl()
	private static let realSampleUtil = SampleUtilImpl()
	private static let realTimeConstraintUtil = AttributeRestrictionUtilImpl()
	private static let realSearchUtil = SearchUtilImpl()
	private static let realStringUtil = StringUtilImpl()
	private static let realIOUtil = IOUtilImpl()
	private static let realUiUtil = UiUtilImpl()
	private static let realMoodUtil = MoodUtilImpl()
	private static let realHealthKitUtil = HealthKitUtilImpl()
	private static let realCoreDataSampleUtil = CoreDataSampleUtilImpl()
	private static let realNotificationUtil = NotificationUtilImpl()
	private static let realUserDefaultsUtil = UserDefaultsUtilImpl()

	public final var calendar: CalendarUtil = Me.realCalendarUtil
	public final var numericSample: NumericSampleUtil = Me.realHKQuantitySampleUtil
	public final var textNormalization: TextNormalizationUtil = Me.realTextNormalizationUtil
	public final var sample: SampleUtil = Me.realSampleUtil
	public final var attributeRestriction: AttributeRestrictionUtil = Me.realTimeConstraintUtil
	public final var search: SearchUtil = Me.realSearchUtil
	public final var string: StringUtil = Me.realStringUtil
	public final var io: IOUtil = Me.realIOUtil
	public final var ui: UiUtil = Me.realUiUtil
	public final var mood: MoodUtil = Me.realMoodUtil
	public final var healthKit: HealthKitUtil = Me.realHealthKitUtil
	public final var coreDataSample: CoreDataSampleUtil = Me.realCoreDataSampleUtil
	public final var notification: NotificationUtil = Me.realNotificationUtil
	public final var userDefaults: UserDefaultsUtil = Me.realUserDefaultsUtil
}
