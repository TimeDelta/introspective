//
//  HealthKitQuantitySampleTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import SwiftDate
import UIKit

import Common
import DependencyInjection
import Samples

final class HealthKitQuantitySampleTableViewCell: UITableViewCell {
	// MARK: - Static Variables

	private typealias Me = HealthKitQuantitySampleTableViewCell
	private static let valueFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}()

	// MARK: - Instance Variables

	public final var sample: HealthKitQuantitySample! {
		didSet { updateView() }
	}
	private var ownedConstraints: [NSLayoutConstraint] = []
	private weak var constrainedValueLabel: UILabel?
	private weak var constrainedTimestampLabel: UILabel?

	// MARK: - IBOutlets

	@IBOutlet final var valueLabel: UILabel! { didSet { updateView() } }
	@IBOutlet final var timestampLabel: UILabel! { didSet { updateView() } }

	override func layoutSubviews() {
		super.layoutSubviews()
		setConstraintsIfNeeded()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		sample = nil
	}

	// MARK: - Helper Functions

	private final func formatValue(_ value: Double) -> String {
		Me.valueFormatter.string(from: NSNumber(value: value)) ?? String(value)
	}

	private func updateView() {
		setConstraintsIfNeeded()
		guard let valueLabel = valueLabel, let timestampLabel = timestampLabel else { return }
		guard let sample = sample else {
			valueLabel.text = nil; timestampLabel.text = nil
			return
		}
		valueLabel.text = formatValue(sample.quantityValue()) + " " + sample.unitString
		let dates = sample.dates()
		guard let start = dates[.start] else { timestampLabel.text = nil; return }
		var dateString = injected(CalendarUtil.self).string(for: start, dateStyle: .medium, timeStyle: .short)
		if let end = dates[.end], end != start {
			dateString += " to " + injected(CalendarUtil.self).string(for: end, dateStyle: .medium, timeStyle: .short)
		}
		timestampLabel.text = dateString
	}

	private func setConstraintsIfNeeded() {
		guard let valueLabel = valueLabel, let timestampLabel = timestampLabel,
			valueLabel.isDescendant(of: self), timestampLabel.isDescendant(of: self) else {
			NSLayoutConstraint.deactivate(ownedConstraints)
			ownedConstraints = []; constrainedValueLabel = nil; constrainedTimestampLabel = nil
			return
		}
		if constrainedValueLabel === valueLabel, constrainedTimestampLabel === timestampLabel,
			!ownedConstraints.isEmpty, ownedConstraints.allSatisfy({ $0.isActive }) { return }
		NSLayoutConstraint.deactivate(ownedConstraints)
		valueLabel.translatesAutoresizingMaskIntoConstraints = false
		timestampLabel.translatesAutoresizingMaskIntoConstraints = false
		ownedConstraints = [
			valueLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor),
			valueLabel.heightAnchor.constraint(equalToConstant: 30),
			valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
			valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
			timestampLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor),
			timestampLabel.heightAnchor.constraint(equalToConstant: 30),
			timestampLabel.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: valueLabel.trailingAnchor, multiplier: 1),
			timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
			timestampLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
		]
		for constraint in ownedConstraints { constraint.identifier = "healthQuantityCell" }
		NSLayoutConstraint.activate(ownedConstraints)
		constrainedValueLabel = valueLabel; constrainedTimestampLabel = timestampLabel
	}
}
