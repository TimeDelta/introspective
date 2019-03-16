//
//  BloodPressureTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 9/5/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class BloodPressureTableViewCell: UITableViewCell {

	// MARK: - Static Variables

	private typealias Me = BloodPressureTableViewCell
	private static let valueFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var valueLabel: UILabel!
	@IBOutlet weak final var timestampLabel: UILabel!

	// MARK: - Instance Variables

	public final var sample: BloodPressure! {
		didSet {
			guard let sample = sample else { return }

			valueLabel.text = formatValue(sample.systolic) + "/" + formatValue(sample.diastolic)

			let start = sample.dates()[.start]!
			let end = sample.dates()[.end]
			var dateString = DependencyInjector.util.calendar.string(for: start, dateStyle: .medium, timeStyle: .short)
			if end != nil && start != end {
				dateString += " to " + DependencyInjector.util.calendar.string(for: end!, dateStyle: .medium, timeStyle: .short)
			}
			timestampLabel.text = dateString

			setConstraints()
		}
	}

	// MARK: - Helper Functions

	private func formatValue(_ value: Double) -> String {
		return Me.valueFormatter.string(from: NSNumber(value: value))!
	}

	private final func setConstraints() {
		setValueLabelConstraints()
		setTimestampLabelConstraints()
	}

	private final func setValueLabelConstraints() {
		valueLabel.translatesAutoresizingMaskIntoConstraints = false
		valueLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor).isActive = true
		let valueHeightConstraint = valueLabel.heightAnchor.constraint(equalToConstant: 30)
		valueHeightConstraint.priority = .required
		valueHeightConstraint.isActive = true
		let leadingConstraint = valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
		leadingConstraint.priority = .required
		leadingConstraint.isActive = true
		valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true

		setSizeOf(valueLabel)
	}

	private final func setTimestampLabelConstraints() {
		timestampLabel.translatesAutoresizingMaskIntoConstraints = false
		timestampLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor).isActive = true
		let timestampHeightConstraint = timestampLabel.heightAnchor.constraint(equalToConstant: 30)
		timestampHeightConstraint.priority = .required
		timestampHeightConstraint.isActive = true
		let bufferConstraint = timestampLabel.leadingAnchor.constraint(
			greaterThanOrEqualToSystemSpacingAfter: valueLabel.trailingAnchor,
			multiplier: 1)
		bufferConstraint.priority = .required
		bufferConstraint.isActive = true
		let trailingConstraint = timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
		trailingConstraint.priority = .required
		trailingConstraint.isActive = true
		timestampLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true

		setSizeOf(timestampLabel)
	}

	private final func setSizeOf(_ label: UILabel) {
		// this allows the value button to dynamiclly set its width based on its content
		let size = label.systemLayoutSizeFitting(
			UIView.layoutFittingCompressedSize,
			withHorizontalFittingPriority: .defaultHigh,
			verticalFittingPriority: .init(1))
		label.frame.size = size
	}
}
