//
//  Test.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/12/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import BooleanAlgebra
@testable import Common
@testable import DataExport
@testable import DataImport
@testable import DependencyInjection
@testable import Notifications
@testable import Persistence
@testable import Queries
@testable import Samples
@testable import SampleGroupers
@testable import SampleGroupInformation
@testable import Settings
@testable import UIExtensions

class Test: XCTestCase {

	public final var injectionProvider: InjectionProviderMock!

	override func setUp() {
		super.setUp()
		registerMatchers()
		registerTypesWithDependencyInjection()
	}

	final func registerTypesWithDependencyInjection() {
		injectionProvider = InjectionProviderMock()
		var types: [Any.Type] = AttributeRestrictionsInjectionProvider().types
		types.append(contentsOf: BooleanAlgebraInjectionProvider().types)
		types.append(contentsOf: CommonInjectionProvider().types)
		types.append(contentsOf: DataExportInjectionProvider().types)
		types.append(contentsOf: DataImportInjectionProvider().types)
		types.append(contentsOf: IntrospectiveInjectionProvider().types)
		types.append(contentsOf: PersistenceInjectionProvider(ObjectModelContainer.objectModel).types)
		types.append(contentsOf: QueriesInjectionProvider().types)
		types.append(contentsOf: SamplesInjectionProvider().types)
		types.append(contentsOf: SampleGroupersInjectionProvider().types)
		types.append(contentsOf: SampleGroupInformationInjectionProvider().types)
		types.append(contentsOf: SettingsInjectionProvider().types)

		Given(injectionProvider, .types(getter: types))
		DependencyInjector.register(injectionProvider)
	}

	final func registerMatchers() {
		Matcher.default.register(ActivityDao.Protocol.self) { _,_ in true }
		Matcher.default.register(ActivityExporter.Protocol.self) { _,_ in true }
		Matcher.default.register(Any.self) { self.anyMatcher($0, $1) }
		Matcher.default.register(AnySample.self) { $0.equalTo($1) }
		Matcher.default.register(Array<Attribute>.self) { $0.elementsEqual($1, by: { $0.equalTo($1) }) }
		Matcher.default.register(Array<ExtraInformation>.self) { $0.elementsEqual($1, by: { $0.equalTo($1) }) }
		Matcher.default.register(AsyncUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(Attribute.self) { $0.equalTo($1) }
		Matcher.default.register(AttributeRestriction.self) { $0.equalTo($1) }
		Matcher.default.register(AttributeRestriction.Type.self) { $0 == $1 }
		Matcher.default.register(AttributeRestrictionFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(BooleanExpressionParser.Protocol.self) { _,_ in true }
		Matcher.default.register(BooleanExpressionPart.self) { self.booleanExpressionPartsMatch($0, $1) }
		Matcher.default.register(CalendarUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(CoachMarkFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(CoreDataSampleUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(Database.Protocol.self) { _,_ in true }
		Matcher.default.register(DayOfWeek.self)
		Matcher.default.register(Exportable.Type.self) { $0 == $1 }
		Matcher.default.register(ExporterUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(ExtraInformation.self) { $0.equalTo($1) }
		Matcher.default.register(ExtraInformationFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(GroupDefinition.self) {
			if let first = $0 as? GroupDefinitionMock, let second = $1 as? GroupDefinitionMock {
				return first === second
			}
			return $0.equalTo($1)
		}
		Matcher.default.register(HealthKitUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(HeartRate.Type.self) { _,_ in true }
		Matcher.default.register(ImporterFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(IOUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(MedicationExporter.Protocol.self) { _,_ in true }
		Matcher.default.register(MoodExporter.Protocol.self) { _,_ in true }
		Matcher.default.register(MoodUiUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(MoodUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(NotificationUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(NumericSampleUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(Optional<Any>.self) { self.anyMatcher($0, $1) }
		Matcher.default.register(Optional<Array<Attribute>>.self) {
			self.optionalEqualTo($0, $1, { $0.elementsEqual($1, by: { $0.equalTo($1) }) })
		}
		Matcher.default.register(Optional<Array<ExtraInformation>>.self) {
			self.optionalEqualTo($0, $1, { $0.elementsEqual($1, by: { $0.equalTo($1) }) })
		}
		Matcher.default.register(Optional<Attribute>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(Optional<ExtraInformation>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(Optional<Query>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(Optional<SampleGrouper>.self) { self.optionalEqualTo($0, $1, { $0.equalTo($1) }) }
		Matcher.default.register(QueryFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(Sample.self) { $0.equalTo($1) }
		Matcher.default.register(Sample.Type.self) { $0.name == $1.name }
		Matcher.default.register(SampleFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(SampleGrouperFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(SampleUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(SearchUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(Settings.Protocol.self) { _,_ in true }
		Matcher.default.register(StringUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(SubQueryMatcherFactory.Protocol.self) { _,_ in true }
		Matcher.default.register(TextNormalizationUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(UITableViewCell.Type.self)
		Matcher.default.register(UiUtil.Protocol.self) { _,_ in true }
		Matcher.default.register(UIViewController.Type.self)
		Matcher.default.register(UserDefaultsUtil.Protocol.self) { _,_ in true }
	}

	// MARK: - Helper Functions

	private final func anyMatcher(_ one: Any?, _ two: Any?) -> Bool {
		if type(of: one) != type(of: two) && (isOptional(one) == isOptional(two)) {
			return false
		}
		if (one == nil && two == nil) { return true }
		if let attribute1 = one as? Attribute, let attribute2 = two as? Attribute {
			return attribute1.equalTo(attribute2)
		}
		if let _ = one as? ATrackerActivityImporterMock, let _ = two as? ATrackerActivityImporterMock {
			// no way to mock equalTo function when other value is also a mock because the
			// Given statement would recursively call this code:
			// Given(importer, .equalTo(.value(other), willReturn: true))
			//                          ^^^^^^^^^^^^^
			// when this ran, it would go to check if the passed other value matches the
			// one from the Given statement, which would call this code, ending in infinite
			// recursion. Also, pointer comparison is not good enough because of copy
			// constructor.
			return true
		}
		if let _ = one as? ActivityExporterMock, let _ = two as? ActivityExporterMock {
			// no way to mock equalTo function when other value is also a mock because the
			// Given statement would recursively call this code:
			// Given(exporter, .equalTo(.value(other), willReturn: true))
			//                          ^^^^^^^^^^^^^
			// when this ran, it would go to check if the passed other value matches the
			// one from the Given statement, which would call this code, ending in infinite
			// recursion. Also, pointer comparison is not good enough because of copy
			// constructor.
			return true
		}
		if let importer1 = one as? Importer, let importer2 = two as? Importer {
			return importer1.equalTo(importer2)
		}
		if let exporter1 = one as? Exporter, let exporter2 = two as? Exporter {
			return exporter1.equalTo(exporter2)
		}
		if let view1 = one as? UIView, let view2 = two as? UIView {
			return view1 == view2
		}
		if let viewController1 = one as? UIViewController, let viewController2 = two as? UIViewController {
			return viewController1 == viewController2
		}
		if let cell1 = one as? UITableViewCell, let cell2 = two as? UITableViewCell {
			return cell1 == cell2
		}
		fatalError("Missing equality test for Any Matcher")
	}

	private final func booleanExpressionPartsMatch(_ first: BooleanExpressionPart, _ second: BooleanExpressionPart) -> Bool {
		if first.type != second.type {
			return false
		}
		if first.expression == nil && second.expression == nil {
			return true
		}
		guard let expression1 = first.expression, let expression2 = second.expression else {
			return false
		}
		return expression1.equalTo(expression2)
	}

	private final func optionalEqualTo<Type>(_ first: Type?, _ second: Type?, _ areEqual: (Type, Type) -> Bool) -> Bool {
		guard let first = first else { return second == nil }
		guard let second = second else { return false }
		return areEqual(first, second)
	}
}
