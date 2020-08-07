//
//  MoodRatingsFlowLayout.swift
//  DiscreteMoodWidget
//
//  Created by Bryan Nova on 10/4/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import DependencyInjection
import Settings

class MoodRatingsFlowLayout: UICollectionViewFlowLayout {
	private final let minCellWidth: CGFloat = 40
	private final var availableWidth: CGFloat!

	override init() {
		super.init()
		minimumInteritemSpacing = 5
		minimumLineSpacing = 0
		estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		scrollDirection = .vertical
	}

	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepare() {
		super.prepare()
		guard let collectionView = collectionView else { return }
		availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right

		let numMoodRatings = CGFloat(numberOfMoodRatings())
		var totalSpacingRequired = minimumInteritemSpacing * numMoodRatings - 1
		let sameLineWidth = (availableWidth - totalSpacingRequired) / numMoodRatings
		if sameLineWidth > minCellWidth {
			itemSize = CGSize(width: sameLineWidth, height: sameLineWidth)
		} else {
			let numCellsPerRow = cellsPerRow()
			totalSpacingRequired = minimumInteritemSpacing * (numCellsPerRow - 1)
			let itemWidth = (availableWidth - totalSpacingRequired) / numCellsPerRow
			itemSize = CGSize(width: itemWidth, height: minCellWidth)
		}
	}

	func setContentSize() {
		let numMoodRatings = CGFloat(numberOfMoodRatings())
		let rowHeight = itemSize.height + minimumLineSpacing
		let numRows = numMoodRatings / cellsPerRow()
		collectionView!.contentSize = CGSize(width: collectionView!.bounds.width, height: rowHeight * numRows)
	}

	override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
		let context = super
			.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
		context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
		return context
	}

	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
		layoutAttributes.bounds.size.width = itemSize.width
		layoutAttributes.bounds.size.height = itemSize.height
		let numCellsPerRow = cellsPerRow()
		let rowHeight = itemSize.height + minimumLineSpacing
		let cellPosition = layoutAttributes.indexPath.row % Int(numCellsPerRow)
		let minX = (CGFloat(cellPosition) / numCellsPerRow) * availableWidth
		let rowNumber = (CGFloat(layoutAttributes.indexPath.row) / numCellsPerRow).rounded(.down)
		let minY = rowNumber * rowHeight
		layoutAttributes.frame = CGRect(x: minX, y: minY, width: itemSize.width, height: itemSize.height)

		return layoutAttributes
	}

	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let superLayoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
		let computedAttributes = superLayoutAttributes.compactMap { layoutAttribute in
			layoutAttribute
				.representedElementCategory == .cell ? layoutAttributesForItem(at: layoutAttribute.indexPath) :
				layoutAttribute
		}
		return computedAttributes
	}

	override func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
		true
	}

	// MARK: Helper Functions

	private final func numberOfMoodRatings() -> Int {
		let min = injected(Settings.self).minMood
		let max = injected(Settings.self).maxMood
		return Int(max - min + 1)
	}

	private final func cellsPerRow() -> CGFloat {
		if availableWidth == nil { prepare() }
		var cellsPerRow: CGFloat = 1
		while cellsPerRow * minCellWidth + (cellsPerRow - 1) * minimumInteritemSpacing <= availableWidth {
			cellsPerRow += 1
		}
		// subtract one because we went over the available width
		return cellsPerRow - 1
	}
}
