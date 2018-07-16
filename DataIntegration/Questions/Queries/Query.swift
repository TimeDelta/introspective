//
//  Query.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

protocol SampleQuery {

	associatedtype SampleType: Sample

	var timeConstraints: Set<TimeConstraint> { get set }
	var attributeRestrictions: [AttributeRestriction] { get set }
	var mostRecentEntryOnly: Bool { get set }
	var numberOfDatesPerSample: Int { get }
	/// The timestamps from the results of the sub-query will be used to limit the results of this query
//	var subQuery: Query<AnySample>? { get set }

	func runQuery(callback: @escaping (QueryResult<SampleType>?, Error?) -> ())
}

public final class Query<SampleType: Sample>: SampleQuery {

	public var timeConstraints: Set<TimeConstraint> {
		get { return box.timeConstraints }
		set { box.timeConstraints = timeConstraints }
	}
	public var attributeRestrictions: [AttributeRestriction] {
		get { return box.attributeRestrictions }
		set { box.attributeRestrictions = attributeRestrictions }
	}
	public var mostRecentEntryOnly: Bool {
		get { return box.mostRecentEntryOnly }
		set { box.mostRecentEntryOnly = mostRecentEntryOnly }
	}
	public var numberOfDatesPerSample: Int {
		get { return box.numberOfDatesPerSample }
	}
//	public var subQuery: Query<AnySample>? {
//		get { return box.subQuery }
//		set { box.subQuery = subQuery }
//	}

	fileprivate let box: QueryBase<SampleType>

	init<ConcreteType: SampleQuery>(_ concrete: ConcreteType) where ConcreteType.SampleType == SampleType {
        box = QueryBox(concrete)
    }

    public func runQuery(callback: @escaping (QueryResult<SampleType>?, Error?) -> ()) {
		box.runQuery(callback: callback)
	}
}


fileprivate class QueryBase<SampleType: Sample>: SampleQuery {

	var timeConstraints: Set<TimeConstraint> {
		get { fatalError("Must override") }
		set { fatalError("Must override") }
	}
	var attributeRestrictions: [AttributeRestriction] {
		get { fatalError("Must override") }
		set { fatalError("Must override") }
	}
	var mostRecentEntryOnly: Bool {
		get { fatalError("Must override") }
		set { fatalError("Must override") }
	}
	var numberOfDatesPerSample: Int {
		get { fatalError("Must override") }
	}

	init() {
		guard type(of: self) != QueryBase.self else {
			fatalError("Must subclass QueryBase")
		}
	}

	func runQuery(callback: @escaping (QueryResult<SampleType>?, Error?) -> ()) {
		fatalError("Must override")
	}
}


fileprivate final class QueryBox<ConcreteType: SampleQuery>: QueryBase<ConcreteType.SampleType> {

	var concrete: ConcreteType

	init(_ concrete: ConcreteType) {
		self.concrete = concrete
	}

	override var timeConstraints: Set<TimeConstraint> {
		get { return concrete.timeConstraints }
		set { concrete.timeConstraints = timeConstraints }
	}
	override var attributeRestrictions: [AttributeRestriction] {
		get { return concrete.attributeRestrictions }
		set { concrete.attributeRestrictions = attributeRestrictions }
	}
	override var mostRecentEntryOnly: Bool {
		get { return concrete.mostRecentEntryOnly }
		set { concrete.mostRecentEntryOnly = mostRecentEntryOnly }
	}
	override var numberOfDatesPerSample: Int {
		get { return concrete.numberOfDatesPerSample }
	}

	override func runQuery(callback: @escaping (QueryResult<ConcreteType.SampleType>?, Error?) -> ()) {
		concrete.runQuery(callback: callback)
	}
}
