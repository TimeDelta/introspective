//
//  Result.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol QueryResult {

	var samples: [Sample] { get }
	var extraInformation: [ExtraInformation] { get }
}

public class SampleQueryResult<SampleType: Sample>: NSObject, QueryResult {

	public fileprivate(set) var typedSamples: [SampleType]
	public fileprivate(set) var sampleInformation: [SampleInformation<SampleType>]

	fileprivate var sampleInformationByType: [InformationType: [SampleInformation<SampleType>]]

	public init(_ samples: [SampleType]) {
		self.typedSamples = samples
		self.sampleInformation = [SampleInformation<SampleType>]()
		self.sampleInformationByType = [InformationType: [SampleInformation<SampleType>]]()
	}

	public func addExtraInformation(_ info: SampleInformation<SampleType>) {
		sampleInformation.append(info)
		var currentInfoForType = sampleInformationByType[info.informationType]
		if currentInfoForType == nil {
			currentInfoForType = [SampleInformation<SampleType>]()
		}
		currentInfoForType?.append(info)
		sampleInformationByType[info.informationType] = currentInfoForType!
	}

	/// - Returns: `nil` if no information of that type is found else all extra information of the specified type
	/// - Complexity: Amortized constant time complexity
	public func information(ofType type: InformationType) -> [SampleInformation<SampleType>]? {
		return sampleInformationByType[type]
	}
}

extension SampleQueryResult {

	public var samples: [Sample] { get { return typedSamples } }
	public var extraInformation: [ExtraInformation] { get { return sampleInformation } }
}
