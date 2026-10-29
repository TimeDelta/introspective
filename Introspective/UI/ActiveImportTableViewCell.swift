//
//  ActiveImportTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 4/13/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DataImport
import DependencyInjection
import UIExtensions

public final class ActiveImportTableViewCell: UITableViewCell {
	// MARK: - Static Variables

	private typealias Me = ActiveImportTableViewCell

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var cancelButton: UIButton!
	@IBOutlet final var descriptionLabel: UILabel!
	@IBOutlet final var progressView: UIProgressView!
	@IBOutlet final var percentLabel: UILabel!

	// MARK: - Instance Variables

	public final var backgroundTaskId: UIBackgroundTaskIdentifier!
	public final var importer: Importer! {
		didSet {
			timer?.invalidate()
			timer = nil
			guard let importer = importer else { return }
			descriptionLabel.text = importer.sourceName + " " + importer.dataTypePluralName
			updateProgress()
			setTimer()
		}
	}

	private final var timer: Timer?
	private final let percentFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.formatWidth = 3
		return formatter
	}()

	deinit { timer?.invalidate() }

	// MARK: - UITableViewCell Overrides

	public final override func prepareForReuse() {
		super.prepareForReuse()
		importer = nil
		injected(UiUtil.self).setButton(cancelButton, enabled: true, hidden: false)
	}

	// MARK: - Actions

	@IBAction final func cancelImport(_: Any) {
		injected(UiUtil.self).setButton(cancelButton, enabled: false, hidden: false)
		let alert = UIAlertController(
			title: "Cancel \(descriptionLabel.text!) import?",
			message: nil,
			preferredStyle: .alert
		)
		alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
			self.timer?.invalidate()
			self.post(.cancelBackgroundTask, userInfo: [.backgroundTaskId: String(self.backgroundTaskId.rawValue)])
		})
		alert.addAction(UIAlertAction(title: "No", style: .cancel) { _ in
			injected(UiUtil.self).setButton(self.cancelButton, enabled: true, hidden: false)
		})
		post(.presentView, object: importer, userInfo: [.controller: alert])
	}

	// MARK: - Helper Functions

	@objc private final func updateProgress() {
		guard let importer = importer else { return }
		let percentComplete = importer.percentComplete()
		progressView.progress = Float(percentComplete)
		if let percentString = percentFormatter.string(from: NSNumber(value: percentComplete)) {
			percentLabel.text = percentString
		} else {
			Me.log.error("Unable to convert %f to string", percentComplete * 100)
		}
		if progressView.progress == 1 {
			timer?.invalidate()
		}
	}

	private final func setTimer() {
		guard progressView.progress < 1 else { return }
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
			guard let self = self else { timer.invalidate(); return }
			self.updateProgress()
		}
	}
}
