//
//  SampleAggregator.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class SampleAggregator: NSObject {

	public final override var description: String {
		var text = groupCombiner.description + " "
		if groupCombiner.descriptionIsPlural {
			text += combinationAttribute.pluralName.localizedLowercase
		} else {
			text += combinationAttribute.name.localizedLowercase
		}
		text += " " + grouper.description
		return text
	}

	public final var grouper: SampleGrouper!
	public final var groupCombiner: SampleGroupCombiner!
	public final var groupByAttribute: Attribute
	public final var combinationAttribute: Attribute

	public init(_ grouper: SampleGrouper? = nil, _ groupCombiner: SampleGroupCombiner? = nil, groupingBy groupAttribute: Attribute, combining combinationAttribute: Attribute) {
		self.grouper = grouper
		self.groupCombiner = groupCombiner
		self.groupByAttribute = groupAttribute
		self.combinationAttribute = combinationAttribute
	}

	/// - Precondition: `grouper` and `groupCombiner` are both not nil
	public final func aggregate(samples: [Sample]) -> [Sample] {
		precondition(grouper != nil, "Grouper was nil")
		precondition(groupCombiner != nil, "Group Combiner was nil")

		let groups = grouper.group(samples: samples, by: groupByAttribute)
		return groupCombiner.combine(groups: groups, groupedBy: groupByAttribute, combinationAttribute: combinationAttribute)
	}
}
