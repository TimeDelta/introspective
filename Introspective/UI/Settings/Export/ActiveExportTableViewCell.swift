//
//  ActiveExportTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 4/18/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DataExport
import DependencyInjection
import UIExtensions

public final class ActiveExportTableViewCell: UITableViewCell {
	// MARK: - Static Variables

	private typealias Me = ActiveExportTableViewCell

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var cancelButton: UIButton!
	@IBOutlet final var descriptionLabel: UILabel!
	@IBOutlet final var progressView: UIProgressView!
	@IBOutlet final var percentLabel: UILabel!
	@IBOutlet final var toolbar: UIToolbar!

	// MARK: - Instance Variables

	public final var backgroundTaskId: UIBackgroundTaskIdentifier!
	public final var exporter: Exporter! {
		didSet {
			timer?.invalidate()
			timer = nil
			if let previous = oldValue {
				injected(UiUtil.self).stopObserving(self, name: .backgroundExportFinished, object: previous)
			}
			guard let exporter = exporter else { return }
			descriptionLabel.text = exporter.dataTypePluralName
			updateProgress()
			setTimer()
			observe(selector: #selector(exportFinished), name: .backgroundExportFinished, object: exporter)
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
		exporter = nil
		injected(UiUtil.self).setButton(cancelButton, enabled: true, hidden: false)
		toolbar.isHidden = true
	}

	// MARK: - Actions

	@IBAction final func cancelExport(_: Any) {
		injected(UiUtil.self).setButton(cancelButton, enabled: false, hidden: false)
		let alert = UIAlertController(
			title: "Cancel \(descriptionLabel.text!) export?",
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
		post(.presentView, userInfo: [.controller: alert])
	}

	@IBAction final func share(_: Any) {
		post(.shareExportFile, userInfo: [.backgroundTaskId: backgroundTaskId])
	}

	// MARK: - Received Notifications

	@objc private final func exportFinished(notification _: Notification) {
		updateProgress()
		timer?.invalidate()
		timer = nil
		injected(UiUtil.self).setButton(cancelButton, enabled: false, hidden: false)
		toolbar.isHidden = false
	}

	// MARK: - Helper Functions

	@objc private final func updateProgress() {
		guard let exporter = exporter else { return }
		let percentComplete = exporter.percentComplete()
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
