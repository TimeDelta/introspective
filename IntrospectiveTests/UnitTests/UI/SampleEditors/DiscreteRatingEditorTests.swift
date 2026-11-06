import XCTest
import UIKit
import SwiftyMocky
@testable import Introspective
@testable import Common

final class DiscreteRatingEditorTests: UnitTest {
	private var uiUtil: EditorRatingUiUtilSpy!
	private var posts: [EditorRatingPost] = []

	override func setUp() {
		super.setUp()
		uiUtil = EditorRatingUiUtilSpy()
		Matcher.default.register(FatigueUiUtil.Protocol.self) { _, _ in true }
		Matcher.default.register(PainUiUtil.Protocol.self) { _, _ in true }
		Given(injectionProvider, .get(.value(MoodUiUtil.self), willReturn: uiUtil))
		Given(injectionProvider, .get(.value(FatigueUiUtil.self), willReturn: uiUtil))
		Given(injectionProvider, .get(.value(PainUiUtil.self), willReturn: uiUtil))
		Perform(mockUiUtil, .post(name: .any, object: .any, userInfo: .any,
			perform: { [weak self] (name: NotificationName, object: Any?, userInfo: [AnyHashable: Any]?) in
				self?.posts.append(EditorRatingPost(name: name, object: object, userInfo: userInfo))
			}))
	}

	func testHistoricalBoundsDriveButtonsSelectionColorsAndEndpointNotifications() {
		for kind in EditorRatingKind.allCases {
			for (minimum, maximum, rating, settingsMinimum, settingsMaximum) in [
				(0, 10, 0, 1.0, 5.0), (1, 10, 5, 0.0, 100.0),
			] {
				resetObservations()
				setSettingsRange(kind, minimum: settingsMinimum, maximum: settingsMaximum)
				let controls = makeCell(kind, minimum: minimum, maximum: maximum, rating: rating, width: 480)

				assertGeometry(controls, minimum: minimum, maximum: maximum, selected: rating)
				assertColors(minimum: minimum, maximum: maximum)
				assertPosts([], from: controls)
				for endpoint in [minimum, maximum] {
					controls.button(for: endpoint)?.sendActions(for: .touchUpInside)
					controls.layout()
					XCTAssertEqual(controls.rating, endpoint)
					assertGeometry(controls, minimum: minimum, maximum: maximum, selected: endpoint)
				}
				assertPosts([minimum, maximum], from: controls)
				XCTAssertTrue(uiUtil.colorRatings.isEmpty)
			}
		}
	}

	func testOneHundredLayoutsKeepButtonsConstraintsColorsAndScrollPosition() {
		for kind in EditorRatingKind.allCases {
			resetObservations()
			let controls = makeCell(kind, minimum: 0, maximum: 10, rating: 5, width: 180)
			assertColors(minimum: 0, maximum: 10)
			let buttons = controls.buttons
			let constraints = controls.renderConstraints
			let colors = buttons.map { $0.backgroundColor }
			let titleColors = buttons.map { $0.titleColor(for: .normal) }
			controls.scrollView.contentOffset = CGPoint(x: 80, y: 0)

			for _ in 0 ..< 100 { controls.layout() }

			assertSameRendering(controls, buttons: buttons, constraints: constraints)
			assertGeometry(controls, minimum: 0, maximum: 10, selected: 5)
			XCTAssertEqual(controls.buttons.map { $0.backgroundColor }, colors)
			XCTAssertEqual(controls.buttons.map { $0.titleColor(for: .normal) }, titleColors)
			XCTAssertEqual(controls.scrollView.contentOffset.x, 80, accuracy: 0.001)
			XCTAssertEqual(controls.scrollView.contentOffset.y, 0, accuracy: 0.001)
			XCTAssertTrue(uiUtil.colorRatings.isEmpty)
			assertPosts([], from: controls)
		}
	}

	func testResizingUpdatesExistingWidthConstraintsWithoutRecoloring() {
		for kind in EditorRatingKind.allCases {
			resetObservations()
			let controls = makeCell(kind, minimum: 0, maximum: 7, rating: 3)
			let buttons = controls.buttons
			let constraints = controls.renderConstraints
			uiUtil.clearColors()

			for width in [CGFloat(480), 120, 0, 320] {
				controls.layout(width: width)

				assertSameRendering(controls, buttons: buttons, constraints: constraints)
				assertGeometry(controls, minimum: 0, maximum: 7, selected: 3)
			}
			XCTAssertTrue(uiUtil.colorRatings.isEmpty)
			assertPosts([], from: controls)
		}
	}

	func testTapsAndRetapsNotifyOnceWhileProgrammaticSelectionIsSilent() {
		for kind in EditorRatingKind.allCases {
			resetObservations()
			let controls = makeCell(kind, minimum: 0, maximum: 7, rating: 3)
			let buttons = controls.buttons
			let constraints = controls.renderConstraints
			uiUtil.clearColors()
			var expectedPosts: [Int] = []

			for rating in [0, 7, 7, 3] {
				controls.button(for: rating)?.sendActions(for: .touchUpInside)
				expectedPosts.append(rating)
				assertPosts(expectedPosts, from: controls)
				controls.layout()

				XCTAssertEqual(controls.rating, rating)
				assertGeometry(controls, minimum: 0, maximum: 7, selected: rating)
				assertSameRendering(controls, buttons: buttons, constraints: constraints)
				assertPosts(expectedPosts, from: controls)
			}
			controls.setRating(1)
			controls.layout()

			assertGeometry(controls, minimum: 0, maximum: 7, selected: 1)
			assertSameRendering(controls, buttons: buttons, constraints: constraints)
			assertPosts(expectedPosts, from: controls)
			XCTAssertTrue(uiUtil.colorRatings.isEmpty)
		}
	}

	func testEqualCountBoundsChangesRebuildAndRejectStaleActionsWithoutClamping() {
		for kind in EditorRatingKind.allCases {
			resetObservations()
			let controls = makeCell(kind, minimum: 0, maximum: 7, rating: 0)
			var expectedPosts: [Int] = []
			for (minimum, maximum, color) in [(2, 9, UIColor.orange), (-4, 3, UIColor.green)] {
				let oldRating = controls.rating
				let oldButtons = controls.buttons
				let oldConstraints = controls.renderConstraints
				uiUtil.clearColors()
				uiUtil.buttonColor = color
				controls.setBounds(minimum: minimum, maximum: maximum)

				// A control from the previous scale is stale even before the next layout.
				oldButtons.last?.sendActions(for: .touchUpInside)
				XCTAssertEqual(controls.rating, oldRating)
				assertPosts(expectedPosts, from: controls)
				controls.layout()

				XCTAssertEqual(controls.buttons.count, oldButtons.count)
				XCTAssertTrue(Set(controls.buttons.map(ObjectIdentifier.init))
					.isDisjoint(with: oldButtons.map(ObjectIdentifier.init)))
				XCTAssertTrue(oldButtons.allSatisfy { $0.superview == nil })
				XCTAssertTrue(oldConstraints.allSatisfy { !$0.isActive })
				XCTAssertTrue(Set(controls.renderConstraints.map(ObjectIdentifier.init))
					.isDisjoint(with: oldConstraints.map(ObjectIdentifier.init)))
				XCTAssertEqual(controls.rating, oldRating)
				assertGeometry(controls, minimum: minimum, maximum: maximum, selected: nil)
				assertColors(minimum: minimum, maximum: maximum)
				XCTAssertTrue(controls.buttons.allSatisfy { $0.backgroundColor == color })
				let newButtons = controls.buttons
				let newConstraints = controls.renderConstraints

				oldButtons.first?.sendActions(for: .touchUpInside)
				controls.layout()

				XCTAssertEqual(controls.rating, oldRating)
				assertSameRendering(controls, buttons: newButtons, constraints: newConstraints)
				assertGeometry(controls, minimum: minimum, maximum: maximum, selected: nil)
				assertPosts(expectedPosts, from: controls)
				XCTAssertTrue(uiUtil.colorRatings.isEmpty)
				controls.button(for: maximum)?.sendActions(for: .touchUpInside)
				controls.layout()
				expectedPosts.append(maximum)
				assertGeometry(controls, minimum: minimum, maximum: maximum, selected: maximum)
				assertPosts(expectedPosts, from: controls)
			}
		}
	}

	func testMissingOutletsAndRatingFirstLateConfigurationRecoverDuringLayout() {
		for kind in EditorRatingKind.allCases {
			resetObservations()
			let cell = kind.makeCell()
			cell.frame = CGRect(x: 0, y: 0, width: 320, height: 70)
			kind.setRating(5, on: cell)
			cell.setNeedsLayout()
			cell.layoutIfNeeded()
			kind.setBounds(minimum: 1, maximum: 10, on: cell)
			cell.layoutIfNeeded()
			kind.setBounds(minimum: nil, maximum: nil, on: cell)
			let controls = attachOutlets(kind, to: cell)
			controls.layout()
			XCTAssertTrue(controls.buttons.isEmpty)

			controls.setBounds(minimum: 1, maximum: nil)
			controls.layout()
			XCTAssertTrue(controls.buttons.isEmpty)
			controls.setBounds(minimum: 1, maximum: 10)
			XCTAssertTrue(controls.buttons.isEmpty, "Property assignment schedules rendering for layout")
			controls.layout()

			XCTAssertEqual(controls.rating, 5)
			assertGeometry(controls, minimum: 1, maximum: 10, selected: 5)
			assertColors(minimum: 1, maximum: 10)
			assertPosts([], from: controls)
		}
	}

	func testNilAndReversedBoundsClearOwnedRenderingAndLaterRecover() {
		let invalidBounds: [(Int?, Int?)] = [(nil, 7), (0, nil), (9, 2)]
		for kind in EditorRatingKind.allCases {
			resetObservations()
			let controls = makeCell(kind, minimum: 0, maximum: 7, rating: 3)
			let unrelatedView = UIView()
			controls.content.addSubview(unrelatedView)
			for (minimum, maximum) in invalidBounds {
				let oldButtons = controls.buttons
				let oldConstraints = controls.renderConstraints
				uiUtil.clearColors()
				controls.setBounds(minimum: minimum, maximum: maximum)

				controls.layout()

				XCTAssertTrue(controls.buttons.isEmpty)
				XCTAssertTrue(controls.renderConstraints.isEmpty)
				XCTAssertTrue(oldButtons.allSatisfy { $0.superview == nil })
				XCTAssertTrue(oldConstraints.allSatisfy { !$0.isActive })
				XCTAssertTrue(unrelatedView.superview === controls.content)
				XCTAssertEqual(controls.rating, 3)
				XCTAssertTrue(uiUtil.colorRatings.isEmpty)
				oldButtons.first?.sendActions(for: .touchUpInside)
				XCTAssertEqual(controls.rating, 3)
				assertPosts([], from: controls)
				controls.setBounds(minimum: 0, maximum: 7)
				controls.layout()

				assertGeometry(controls, minimum: 0, maximum: 7, selected: 3)
				assertColors(minimum: 0, maximum: 7)
				assertPosts([], from: controls)
			}
		}
	}

	func testNilAndOutOfRangeRatingsStayUnselectedAndUnchangedUntilAValidTap() {
		let invalidRatings: [Int?] = [nil, -1, 99]
		for kind in EditorRatingKind.allCases {
			resetObservations()
			let controls = makeCell(kind, minimum: 0, maximum: 7, rating: 3)
			let buttons = controls.buttons
			let constraints = controls.renderConstraints
			uiUtil.clearColors()
			var expectedPosts: [Int] = []
			for rating in invalidRatings {
				controls.setRating(rating)
				controls.layout()
				controls.layout()

				XCTAssertEqual(controls.rating, rating)
				assertGeometry(controls, minimum: 0, maximum: 7, selected: nil)
				assertSameRendering(controls, buttons: buttons, constraints: constraints)
				assertPosts(expectedPosts, from: controls)
				controls.button(for: 4)?.sendActions(for: .touchUpInside)
				controls.layout()
				expectedPosts.append(4)

				XCTAssertEqual(controls.rating, 4)
				assertGeometry(controls, minimum: 0, maximum: 7, selected: 4)
				assertSameRendering(controls, buttons: buttons, constraints: constraints)
				assertPosts(expectedPosts, from: controls)
			}
			XCTAssertTrue(uiUtil.colorRatings.isEmpty)
		}
	}

	func testConstantAndNegativeIntegerScalesRenderAndNotifyTheirActualEndpoints() {
		for kind in EditorRatingKind.allCases {
			for (minimum, maximum, rating) in [(0, 0, 0), (-3, -3, -3), (-4, -1, -2)] {
				resetObservations()
				let controls = makeCell(kind, minimum: minimum, maximum: maximum, rating: rating, width: 120)

				assertGeometry(controls, minimum: minimum, maximum: maximum, selected: rating)
				assertColors(minimum: minimum, maximum: maximum)
				assertPosts([], from: controls)
				for endpoint in [minimum, maximum] {
					controls.button(for: endpoint)?.sendActions(for: .touchUpInside)
					controls.layout()
					XCTAssertEqual(controls.rating, endpoint)
					assertGeometry(controls, minimum: minimum, maximum: maximum, selected: endpoint)
				}
				assertPosts([minimum, maximum], from: controls)
			}
		}
	}

	func testRebuiltControlsAndConstraintsAreReleasedWhileTheEditorRemainsAlive() {
		for kind in EditorRatingKind.allCases {
			resetObservations()
			var controls: EditorRatingControls!
			weak var oldButton: UIButton?
			weak var oldConstraint: NSLayoutConstraint?
			autoreleasepool {
				controls = makeCell(kind, minimum: 0, maximum: 7, rating: 3)
				oldButton = controls.buttons.first
				oldConstraint = controls.renderConstraints.first
				XCTAssertNotNil(oldButton)
				XCTAssertNotNil(oldConstraint)
				controls.setBounds(minimum: 2, maximum: 9)
				controls.layout()
			}

			XCTAssertNil(oldButton)
			XCTAssertNil(oldConstraint)
			assertGeometry(controls, minimum: 2, maximum: 9, selected: 3)
			assertPosts([], from: controls)
		}
	}

	private func resetObservations() {
		posts = []
		mockUiUtil.resetMock(.invocation)
		uiUtil.clearColors()
	}

	private func assertPosts(_ ratings: [Int], from controls: EditorRatingControls,
		file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(posts.count, ratings.count, file: file, line: line)
		for (post, rating) in zip(posts, ratings) {
			XCTAssertEqual(post.name, controls.kind.notification, file: file, line: line)
			XCTAssertTrue((post.object as? UITableViewCell) === controls.cell,
				"The rating notification must identify the editing cell as its sender", file: file, line: line)
			XCTAssertEqual(post.userInfo?.count, 1, file: file, line: line)
			XCTAssertTrue(post.userInfo?[UserInfoKey.number] is Double, file: file, line: line)
			XCTAssertEqual(post.userInfo?[UserInfoKey.number] as? Double, Double(rating), file: file, line: line)
		}
		let anyName: Parameter<NotificationName> = .any
		Verify(mockUiUtil, .exactly(ratings.count), .post(name: anyName, object: .any, userInfo: .any),
			file: file, line: line)
		Verify(mockUiUtil, .exactly(ratings.count), .post(name: .value(controls.kind.notification),
			object: .matching { ($0 as? UITableViewCell) === controls.cell }, userInfo: .any), file: file, line: line)
	}

	private func assertSameRendering(_ controls: EditorRatingControls, buttons: [UIButton],
		constraints: [NSLayoutConstraint], file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(controls.buttons.map(ObjectIdentifier.init), buttons.map(ObjectIdentifier.init), file: file, line: line)
		XCTAssertEqual(Set(controls.renderConstraints.map(ObjectIdentifier.init)),
			Set(constraints.map(ObjectIdentifier.init)), file: file, line: line)
		XCTAssertTrue(constraints.allSatisfy { $0.isActive }, file: file, line: line)
	}

	private func assertColors(minimum: Int, maximum: Int, file: StaticString = #file, line: UInt = #line) {
		let ratings = (minimum ... maximum).map { Double($0) }
		XCTAssertEqual(uiUtil.colorRatings, ratings, file: file, line: line)
		XCTAssertEqual(uiUtil.colorMinimums, Array(repeating: Double(minimum), count: ratings.count), file: file, line: line)
		XCTAssertEqual(uiUtil.colorMaximums, Array(repeating: Double(maximum), count: ratings.count), file: file, line: line)
		uiUtil.clearColors()
	}

	private func assertGeometry(_ controls: EditorRatingControls, minimum: Int, maximum: Int, selected: Int?,
		file: StaticString = #file, line: UInt = #line) {
		let ratings = Array(minimum ... maximum)
		let buttons = controls.buttons
		let constraints = controls.renderConstraints
		XCTAssertEqual(buttons.map { $0.title(for: .normal) }, ratings.map { Optional(String($0)) }, file: file, line: line)
		XCTAssertEqual(constraints.count, 4 * ratings.count + 1, file: file, line: line)
		let spacingCount = ratings.count - 1 + (selected == nil ? 0 : 1)
		let baseWidth = Swift.max(30, (controls.scrollView.bounds.width - 5 * CGFloat(spacingCount)) / CGFloat(ratings.count))
		let pixelAccuracy = 1 / UIScreen.main.scale
		for (index, button) in buttons.enumerated() {
			guard index < ratings.count else { continue }
			let rating = ratings[index]
			let isSelected = rating == selected
			let expectedWidth = baseWidth + (isSelected ? 5 : 0)
			let inset: CGFloat = isSelected ? 0 : 5
			let leadings = constraints.filter {
				($0.firstItem as? UIView) === button && $0.firstAttribute == .leading
			}
			XCTAssertEqual(leadings.count, 1, file: file, line: line)
			if let leading = leadings.first {
				XCTAssertEqual(leading.constant, index == 0 ? 0 : 5, accuracy: 0.001, file: file, line: line)
			}
			let widths = constraints.filter {
				($0.firstItem as? UIView) === button && $0.firstAttribute == .width && $0.secondItem == nil
			}
			XCTAssertEqual(widths.count, 1, file: file, line: line)
			if let width = widths.first { XCTAssertEqual(width.constant, expectedWidth, accuracy: 0.001, file: file, line: line) }
			for (attribute, constant) in [(NSLayoutConstraint.Attribute.top, inset), (.bottom, -inset)] {
				let edges = constraints.filter {
					($0.firstItem as? UIView) === button && $0.firstAttribute == attribute &&
					($0.secondItem as? UIView) === controls.content && $0.secondAttribute == attribute
				}
				XCTAssertEqual(edges.count, 1, file: file, line: line)
				if let edge = edges.first { XCTAssertEqual(edge.constant, constant, accuracy: 0.001, file: file, line: line) }
			}
			XCTAssertEqual(button.frame.width, expectedWidth, accuracy: pixelAccuracy, file: file, line: line)
			XCTAssertEqual(button.frame.minY, inset, accuracy: pixelAccuracy, file: file, line: line)
			XCTAssertEqual(button.frame.maxY, controls.content.bounds.height - inset, accuracy: pixelAccuracy, file: file, line: line)
			let expectedLeading = index == 0 ? 0 : buttons[index - 1].frame.maxX + 5
			XCTAssertEqual(button.frame.minX, expectedLeading, accuracy: pixelAccuracy, file: file, line: line)
			let identifier = "set \(controls.kind.rawValue) to \(rating) button"
			XCTAssertEqual(button.accessibilityIdentifier, identifier, file: file, line: line)
			XCTAssertEqual(button.accessibilityLabel, identifier, file: file, line: line)
			XCTAssertEqual(button.actions(forTarget: controls.cell, forControlEvent: .touchUpInside)?.count, 1,
				file: file, line: line)
		}
		let expectedContentWidth = CGFloat(ratings.count) * baseWidth + 5 * CGFloat(spacingCount)
		XCTAssertEqual(controls.content.bounds.width, expectedContentWidth, accuracy: pixelAccuracy, file: file, line: line)
		XCTAssertEqual(controls.scrollView.contentSize.width, expectedContentWidth, accuracy: pixelAccuracy, file: file, line: line)
	}

	private func setSettingsRange(_ kind: EditorRatingKind, minimum: Double, maximum: Double) {
		switch kind {
		case .mood:
			Given(mockSettings, .minMood(getter: minimum))
			Given(mockSettings, .maxMood(getter: maximum))
		case .fatigue:
			Given(mockSettings, .minFatigue(getter: minimum))
			Given(mockSettings, .maxFatigue(getter: maximum))
		case .pain:
			Given(mockSettings, .minPain(getter: minimum))
			Given(mockSettings, .maxPain(getter: maximum))
		}
	}

	private func makeCell(_ kind: EditorRatingKind, minimum: Int, maximum: Int, rating: Int?,
		width: CGFloat = 320) -> EditorRatingControls {
		let controls = attachOutlets(kind, to: kind.makeCell(), width: width)
		// Match editor controllers, which assign the historical rating before its bounds.
		controls.setRating(rating)
		controls.setBounds(minimum: minimum, maximum: maximum)
		controls.layout()
		return controls
	}

	private func attachOutlets(_ kind: EditorRatingKind, to cell: UITableViewCell,
		width: CGFloat = 320) -> EditorRatingControls {
		let scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: 60))
		scroll.contentInsetAdjustmentBehavior = .never
		let content = UIView()
		cell.frame = CGRect(x: 0, y: 0, width: width, height: 70)
		cell.contentView.addSubview(scroll)
		scroll.addSubview(content)
		content.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			content.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
			content.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
			content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
			content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
			content.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor),
		])
		kind.setOutlets(scroll: scroll, content: content, on: cell)
		return EditorRatingControls(kind: kind, cell: cell, scrollView: scroll, content: content)
	}
}

private struct EditorRatingPost {
	let name: NotificationName
	let object: Any?
	let userInfo: [AnyHashable: Any]?
}

private enum EditorRatingKind: String, CaseIterable {
	case mood, fatigue, pain

	var notification: NotificationName {
		switch self {
		case .mood: return .moodRatingChanged
		case .fatigue: return .fatigueRatingChanged
		case .pain: return .painRatingChanged
		}
	}

	func makeCell() -> UITableViewCell {
		switch self {
		case .mood: return DiscreteMoodRatingTableViewCell()
		case .fatigue: return DiscreteFatigueRatingTableViewCell()
		case .pain: return DiscretePainRatingTableViewCell()
		}
	}

	func setOutlets(scroll: UIScrollView, content: UIView, on cell: UITableViewCell) {
		switch self {
		case .mood:
			let mood = cell as! DiscreteMoodRatingTableViewCell
			mood.scrollView = scroll
			mood.moodContentView = content
		case .fatigue:
			let fatigue = cell as! DiscreteFatigueRatingTableViewCell
			fatigue.scrollView = scroll
			fatigue.fatigueContentView = content
		case .pain:
			let pain = cell as! DiscretePainRatingTableViewCell
			pain.scrollView = scroll
			pain.painContentView = content
		}
	}

	func rating(on cell: UITableViewCell) -> Int? {
		switch self {
		case .mood: return (cell as! DiscreteMoodRatingTableViewCell).rating
		case .fatigue: return (cell as! DiscreteFatigueRatingTableViewCell).rating
		case .pain: return (cell as! DiscretePainRatingTableViewCell).rating
		}
	}

	func setRating(_ rating: Int?, on cell: UITableViewCell) {
		switch self {
		case .mood: (cell as! DiscreteMoodRatingTableViewCell).rating = rating
		case .fatigue: (cell as! DiscreteFatigueRatingTableViewCell).rating = rating
		case .pain: (cell as! DiscretePainRatingTableViewCell).rating = rating
		}
	}

	func setBounds(minimum: Int?, maximum: Int?, on cell: UITableViewCell) {
		switch self {
		case .mood:
			let mood = cell as! DiscreteMoodRatingTableViewCell
			mood.minRating = minimum
			mood.maxRating = maximum
		case .fatigue:
			let fatigue = cell as! DiscreteFatigueRatingTableViewCell
			fatigue.minRating = minimum
			fatigue.maxRating = maximum
		case .pain:
			let pain = cell as! DiscretePainRatingTableViewCell
			pain.minRating = minimum
			pain.maxRating = maximum
		}
	}
}

private struct EditorRatingControls {
	let kind: EditorRatingKind
	let cell: UITableViewCell
	let scrollView: UIScrollView
	let content: UIView

	var rating: Int? { kind.rating(on: cell) }
	var buttons: [UIButton] { content.subviews.compactMap { $0 as? UIButton } }
	var renderConstraints: [NSLayoutConstraint] {
		(content.constraints + buttons.flatMap { $0.constraints }).filter {
			$0.isActive && $0.identifier == "discreteRatingEditor"
		}
	}

	func button(for rating: Int) -> UIButton? {
		buttons.first { $0.title(for: .normal) == String(rating) }
	}

	func setRating(_ rating: Int?) { kind.setRating(rating, on: cell) }
	func setBounds(minimum: Int?, maximum: Int?) { kind.setBounds(minimum: minimum, maximum: maximum, on: cell) }

	func layout(width: CGFloat? = nil) {
		if let width = width {
			cell.frame.size.width = width
			scrollView.frame.size.width = width
		}
		cell.setNeedsLayout()
		cell.layoutIfNeeded()
		scrollView.layoutIfNeeded()
		content.layoutIfNeeded()
	}
}

private final class EditorRatingUiUtilSpy: MoodUiUtil, FatigueUiUtil, PainUiUtil {
	var buttonColor: UIColor = .purple
	var colorRatings: [Double] = []
	var colorMinimums: [Double] = []
	var colorMaximums: [Double] = []

	func valueToString(_ value: Double) -> String { String(value) }
	func feedbackMessage(for rating: Double, min: Double, max: Double) -> String { "Recorded" }
	func colorForMood(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		color(rating: rating, min: minRating, max: maxRating)
	}
	func colorForFatigue(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		color(rating: rating, min: minRating, max: maxRating)
	}
	func colorForPain(rating: Double, minRating: Double, maxRating: Double) -> UIColor {
		color(rating: rating, min: minRating, max: maxRating)
	}

	func clearColors() {
		colorRatings = []
		colorMinimums = []
		colorMaximums = []
	}

	private func color(rating: Double, min: Double, max: Double) -> UIColor {
		colorRatings.append(rating)
		colorMinimums.append(min)
		colorMaximums.append(max)
		return buttonColor
	}
}
