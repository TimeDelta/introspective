//
//  Dosage.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public final class Dosage: NSObject, NSCoding, Codable, Comparable {

	// MARK: - Enums

	private enum CodingKeys: String, CodingKey {
		case amount
		case unit
	}

	// MARK: - Static Variables

	private typealias Me = Dosage
	private static let amountRegex = "^[0-9]+(\\.[0-9]+)?"

	// MARK: - Comparable

	public static func ==(lhs: Dosage, rhs: Dosage) -> Bool {
		return lhs.getBaseUnitAmount() == rhs.getBaseUnitAmount()
	}

	public static func <(lhs: Dosage, rhs: Dosage) -> Bool {
		return lhs.getBaseUnitAmount() < rhs.getBaseUnitAmount()
	}

	// MARK: - Instance Variables

	public final var amount: Double
	public final var unit: String

	public final override var description: String {
		var amountText = String(amount)
		if amountText.hasSuffix(".0") {
			amountText = String(amountText.prefix(amountText.count - 2))
		}
		return amountText + " " + unit
	}

	// Initializers

	public init?(_ text: String) {
		if let amountRange = text.range(of: Me.amountRegex, options: .regularExpression, range: nil, locale: nil) {
			amount = Double(text[amountRange])!
			var unitText = text.replacingOccurrences(of: text[amountRange], with: "")
			unitText = unitText.trimmingCharacters(in: .whitespacesAndNewlines)
			unit = unitText
		} else {
			return nil
		}
	}

	public init(_ amount: Double, _ unit: String) {
		self.amount = amount
		self.unit = unit
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		amount = try values.decode(Double.self, forKey: .amount)
		unit = try values.decode(String.self, forKey: .unit)
	}

	public init(coder decoder: NSCoder) {
		amount = decoder.decodeDouble(forKey: CodingKeys.amount.rawValue)
		unit = decoder.decodeObject(forKey: CodingKeys.unit.rawValue) as! String
	}

	// MARK: - Encodable

	public final func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(amount, forKey: .amount)
		try container.encode(unit, forKey: .unit)
	}

	public final func encode(with encoder: NSCoder) {
		encoder.encode(amount, forKey: CodingKeys.amount.rawValue)
		encoder.encode(unit, forKey: CodingKeys.unit.rawValue)
	}

	// MARK: - Other

	public final func getBaseUnitAmount() -> Double {
		if isDeci() { return amount / 10 }
		if isCenti() { return amount / 100 }
		if isMilli() { return amount / 1000 }
		if isMicro() { return amount / 1000000 }
		return amount // base unit
	}

	public final func inUnits(_ newUnits: String) -> Double {
		if isDeci(newUnits) { return getBaseUnitAmount() * 10 }
		if isCenti(newUnits) { return getBaseUnitAmount() * 100 }
		if isMilli(newUnits) { return getBaseUnitAmount() * 1000 }
		if isMicro(newUnits) { return getBaseUnitAmount() * 1000000 }
		return getBaseUnitAmount() // base unit
	}

	// MARK: - Helper Functions

	private final func isDeci(_ u: String? = nil) -> Bool {
		let unit = u ?? self.unit
		return unit == "dg" || unit == "dl" || unit == "dL" || unit.localizedLowercase.starts(with: "deci")
	}

	private final func isCenti(_ u: String? = nil) -> Bool {
		let unit = u ?? self.unit
		return unit == "cg" || unit == "cl" || unit == "cL" || unit.localizedLowercase.starts(with: "centi")
	}

	private final func isMilli(_ u: String? = nil) -> Bool {
		let unit = u ?? self.unit
		return unit == "mg" || unit == "ml" || unit == "mL"
			|| unit.localizedLowercase.starts(with: "milli")
			|| unit.localizedLowercase.starts(with: "mili") // common misspelling
	}

	private final func isMicro(_ u: String? = nil) -> Bool {
		let unit = u ?? self.unit
		return unit == "mcg"
			|| unit.localizedLowercase.starts(with: "µ")
			|| unit.localizedLowercase == "ug"
			|| unit.localizedLowercase == "mcl"
			|| unit.localizedLowercase == "ul"
			|| unit.localizedLowercase.starts(with: "micro")
	}
}
