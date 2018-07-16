//
//  ExtraInformation.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum InformationType {
	case statistics
}

public protocol SampleInformation {

	associatedtype SampleType: Sample

	var informationType: InformationType { get }
	var key: String { get }
	var startDate: Date? { get set }
	var endDate: Date? { get set }

	func compute(forSamples: [SampleType]) -> String
}


public final class ExtraInformation<SampleType: Sample>: SampleInformation {

	public var informationType: InformationType { get { return box.informationType } }
	public var key: String { get { return box.key } }
	public var startDate: Date? {
		get { return box.startDate }
		set { box.startDate = startDate }
	}
	public var endDate: Date? {
		get { return box.endDate }
		set { box.endDate = endDate }
	}

	fileprivate let box: ExtraInformationBase<SampleType>

	init<ConcreteType: SampleInformation>(_ concrete: ConcreteType) where ConcreteType.SampleType == SampleType {
        box = ExtraInformationBox(concrete)
    }

    public func compute(forSamples samples: [SampleType]) -> String {
		return box.compute(forSamples: samples)
	}
}


fileprivate class ExtraInformationBase<SampleType: Sample>: SampleInformation {

	var informationType: InformationType { get { fatalError("Must override") } }
	var key: String { get { fatalError("Must override") } }
	var startDate: Date? {
		get { fatalError("Must override") }
		set { fatalError("Must override") }
	}
	var endDate: Date? {
		get { fatalError("Must override") }
		set { fatalError("Must override") }
	}

	init() {
		guard type(of: self) != ExtraInformationBase.self else {
			fatalError("Must subclass ExtraInformationBase")
		}
	}

	func compute(forSamples: [SampleType]) -> String {
		fatalError("Must override")
	}
}


fileprivate final class ExtraInformationBox<ConcreteType: SampleInformation>: ExtraInformationBase<ConcreteType.SampleType> {

	var concrete: ConcreteType

	init(_ concrete: ConcreteType) {
		self.concrete = concrete
	}

	override var key: String { get { return concrete.key } }
	override var startDate: Date? {
		get { return concrete.startDate }
		set { concrete.startDate = startDate }
	}
	override var endDate: Date? {
		get { return concrete.endDate }
		set { concrete.endDate = endDate }
	}

	override func compute(forSamples samples: [ConcreteType.SampleType]) -> String {
        return concrete.compute(forSamples: samples)
    }
}
