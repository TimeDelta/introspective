//
//  Result.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class QueryResult<SampleType: Sample>: NSObject {

	public fileprivate(set) var samples: [SampleType]
	public fileprivate(set) var extraInformation: [ExtraInformation<SampleType>]

	fileprivate var extraInformationByType: [InformationType: [ExtraInformation<SampleType>]]

	public init(_ samples: [SampleType]) {
		self.samples = samples
		self.extraInformation = [ExtraInformation]()
		self.extraInformationByType = [InformationType: [ExtraInformation]]()
	}

	public func addExtraInformation(_ info: ExtraInformation<SampleType>) {
		extraInformation.append(info)
		var currentInfoForType = extraInformationByType[info.informationType]
		if currentInfoForType == nil {
			currentInfoForType = [ExtraInformation]()
		}
		currentInfoForType?.append(info)
		extraInformationByType[info.informationType] = currentInfoForType!
	}

	/// - Returns: `nil` if no information of that type is found else all extra information of the specified type
	/// - Complexity: Amortized constant time complexity
	public func information(ofType type: InformationType) -> [ExtraInformation<SampleType>]? {
		return extraInformationByType[type]
	}
}
