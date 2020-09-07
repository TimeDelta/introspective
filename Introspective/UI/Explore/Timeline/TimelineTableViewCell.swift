//
//  TimelineTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

protocol TimelineTableViewCellDelegate {
	func isEditable() -> Bool
	/// If `isEditable()` returns true, this function should return a controller capable of allowing the user to edit the associated sample
	func editController() -> UIViewController?
}

protocol TimelineTableViewCell: UITableViewCell {
	var date: Date! { get set }
	var descriptions: [String] { get set }
}

final class TimelineTableViewCellImpl: UITableViewCell, TimelineTableViewCell {
	@IBOutlet var leftStack: UIStackView!
	@IBOutlet var timeLabel: UILabel!
	@IBOutlet var descriptionsLabel: UILabel!

	var date: Date! {
		didSet {
			guard let date = date else { return }
			timeLabel.text = injected(CalendarUtil.self).string(for: date, dateStyle: .none, timeStyle: .medium)
		}
	}

	var descriptions = [String]() {
		didSet {
			descriptionsLabel.numberOfLines = descriptions.count
			descriptionsLabel.text = descriptions.joined(separator: "\n")
		}
	}
}