//
//  Labels.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import NaturalLanguage

class Labels: NSObject {

	struct Label {
		fileprivate(set) var tag: NLTag
		fileprivate(set) var token: String

		init(tag: NLTag, token: String) {
			self.tag = tag
			self.token = token
		}
	}

	fileprivate var labelsByTag: [NLTag: [Label]]
	fileprivate var labelsByIndex: [Label]

	override init() {
		labelsByTag = [NLTag: [Label]]()
		labelsByIndex = [Label]()
	}

	func addLabel(_ label: Label) {
		// concatenate identical consecutive tags
		var lastLabel = labelsByIndex.last
		if lastLabel?.tag == label.tag {
			lastLabel!.token.append(label.token)
			var labelsForTag = labelsByTag[lastLabel!.tag]
			labelsForTag!.removeLast()
			labelsForTag!.append(lastLabel!)
			labelsByTag[lastLabel!.tag] = labelsForTag
		} else {
			labelsByTag[label.tag]?.append(label)
			labelsByIndex.append(label)
		}
	}

	func label(_ index: Int) -> Label {
		return labelsByIndex[index]
	}

	func labels(_ tag: NLTag) -> [Label]? {
		return labelsByTag[tag]
	}
}
