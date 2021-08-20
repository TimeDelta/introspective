//
//  UnaccountedForTimeTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/4/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import MetaData

class UnaccountedForTimeTableViewCell: UITableViewCell {
	private typealias Me = UnaccountedForTimeTableViewCell
	private static let log = Log()
	private static let baseMessage = "Time Unaccounted For: "

	@IBOutlet final var label: UILabel!
	@IBOutlet final var progressIndicator: UIActivityIndicatorView!

	override func awakeFromNib() {
		super.awakeFromNib()
		observe(selector: #selector(calculate(notification:)), name: MetaDataTableViewController.runCalculations)
		let startOfToday = injected(CalendarUtil.self).start(of: .day, in: Date())
		let endOfToday = injected(CalendarUtil.self).end(of: .day, in: startOfToday)
//		injected(AsyncUtil.self).run(qos: .default) { [weak self] in
//			self?.post(
//				MetaDataTableViewController.runCalculations,
//				object: nil,
//				userInfo: [.fromDate: startOfToday, .toDate: endOfToday]
//			)
//		}
		calculate(from: startOfToday, to: endOfToday)
	}

	@objc public func calculate(notification: Notification) {
		guard let fromDate: Date = value(for: .fromDate, from: notification) else {
			Me.log.error("Missing FROM date for triggering unaccounted for time calculation")
			return
		}
		guard let toDate: Date = value(for: .toDate, from: notification) else {
			Me.log.error("Missing TO date for triggering unaccounted for time calculation")
			return
		}
		calculate(from: fromDate, to: toDate)
	}

	private func calculate(from fromDate: Date, to toDate: Date) {
		DispatchQueue.main.async { [weak self] in
			while self?.progressIndicator == nil {}
			self?.label.text = Me.baseMessage
			self?.progressIndicator.startAnimating()
		}
//		injected(AsyncUtil.self).run(qos: .default) { [weak self] in
		do {
			let totalTime = try injected(UnaccountedForTimeMetaDataCalculator.self)
				.calculate(from: fromDate, to: toDate)
			DispatchQueue.main.async { [weak self] in
				self?.label.text = Me.baseMessage + totalTime.description
				self?.progressIndicator.stopAnimating()
			}
		} catch {
			Me.log.error("Failed to calculate unaccounted for time: %@", errorInfo(error))
		}
//		}
	}
}
