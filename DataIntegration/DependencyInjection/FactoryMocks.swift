// MARK: - Mocks generated from file: DataIntegration/DataTypes/DataTypesFactory.swift
//
//  DataTypesFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

import Foundation
import HealthKit

class MockDataTypesFactory: DataTypesFactory, Cuckoo.ClassMock {
    typealias MocksType = DataTypesFactory
    typealias Stubbing = __StubbingProxy_DataTypesFactory
    typealias Verification = __VerificationProxy_DataTypesFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "activity", "returnSignature": " -> Activity", "fullyQualifiedName": "activity() -> Activity", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "Activity", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func activity()  -> Activity {
        
            return cuckoo_manager.call("activity() -> Activity",
                parameters: (),
                superclassCall:
                    
                    super.activity()
                    )
        
    }
    
    // ["name": "activityInstance", "returnSignature": " -> ActivityInstance", "fullyQualifiedName": "activityInstance(activity: Activity) -> ActivityInstance", "parameterSignature": "activity: Activity", "parameterSignatureWithoutNames": "activity: Activity", "inputTypes": "Activity", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "activity", "call": "activity: activity", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("activity"), name: "activity", type: "Activity", range: CountableRange(321..<339), nameRange: CountableRange(321..<329))], "returnType": "ActivityInstance", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func activityInstance(activity: Activity)  -> ActivityInstance {
        
            return cuckoo_manager.call("activityInstance(activity: Activity) -> ActivityInstance",
                parameters: (activity),
                superclassCall:
                    
                    super.activityInstance(activity: activity)
                    )
        
    }
    
    // ["name": "heartRate", "returnSignature": " -> HeartRate", "fullyQualifiedName": "heartRate(value: Double) -> HeartRate", "parameterSignature": "value: Double", "parameterSignatureWithoutNames": "value: Double", "inputTypes": "Double", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "value", "call": "value: value", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("value"), name: "value", type: "Double", range: CountableRange(436..<449), nameRange: CountableRange(436..<441))], "returnType": "HeartRate", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func heartRate(value: Double)  -> HeartRate {
        
            return cuckoo_manager.call("heartRate(value: Double) -> HeartRate",
                parameters: (value),
                superclassCall:
                    
                    super.heartRate(value: value)
                    )
        
    }
    
    // ["name": "heartRate", "returnSignature": " -> HeartRate", "fullyQualifiedName": "heartRate(_: Double, _: DateType, _: Date) -> HeartRate", "parameterSignature": "_ value: Double, _ dateType: DateType, _ date: Date", "parameterSignatureWithoutNames": "value: Double, dateType: DateType, date: Date", "inputTypes": "Double, DateType, Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "value, dateType, date", "call": "value, dateType, date", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "value", type: "Double", range: CountableRange(519..<534), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: nil, name: "dateType", type: "DateType", range: CountableRange(536..<556), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: nil, name: "date", type: "Date", range: CountableRange(558..<570), nameRange: CountableRange(0..<0))], "returnType": "HeartRate", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func heartRate(_ value: Double, _ dateType: DateType, _ date: Date)  -> HeartRate {
        
            return cuckoo_manager.call("heartRate(_: Double, _: DateType, _: Date) -> HeartRate",
                parameters: (value, dateType, date),
                superclassCall:
                    
                    super.heartRate(value, dateType, date)
                    )
        
    }
    
    // ["name": "heartRate", "returnSignature": " -> HeartRate", "fullyQualifiedName": "heartRate(_: Double, _: [DateType: Date]) -> HeartRate", "parameterSignature": "_ value: Double, _ dates: [DateType: Date]", "parameterSignatureWithoutNames": "value: Double, dates: [DateType: Date]", "inputTypes": "Double, [DateType: Date]", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "value, dates", "call": "value, dates", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "value", type: "Double", range: CountableRange(656..<671), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: nil, name: "dates", type: "[DateType: Date]", range: CountableRange(673..<698), nameRange: CountableRange(0..<0))], "returnType": "HeartRate", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func heartRate(_ value: Double, _ dates: [DateType: Date])  -> HeartRate {
        
            return cuckoo_manager.call("heartRate(_: Double, _: [DateType: Date]) -> HeartRate",
                parameters: (value, dates),
                superclassCall:
                    
                    super.heartRate(value, dates)
                    )
        
    }
    
    // ["name": "heartRate", "returnSignature": " -> HeartRate", "fullyQualifiedName": "heartRate(_: HKQuantitySample) -> HeartRate", "parameterSignature": "_ sample: HKQuantitySample", "parameterSignatureWithoutNames": "sample: HKQuantitySample", "inputTypes": "HKQuantitySample", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "sample", "call": "sample", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "sample", type: "HKQuantitySample", range: CountableRange(775..<801), nameRange: CountableRange(0..<0))], "returnType": "HeartRate", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func heartRate(_ sample: HKQuantitySample)  -> HeartRate {
        
            return cuckoo_manager.call("heartRate(_: HKQuantitySample) -> HeartRate",
                parameters: (sample),
                superclassCall:
                    
                    super.heartRate(sample)
                    )
        
    }
    
    // ["name": "mood", "returnSignature": " -> Mood", "fullyQualifiedName": "mood() -> Mood", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "Mood", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func mood()  -> Mood {
        
            return cuckoo_manager.call("mood() -> Mood",
                parameters: (),
                superclassCall:
                    
                    super.mood()
                    )
        
    }
    
    // ["name": "mood", "returnSignature": " -> Mood", "fullyQualifiedName": "mood(rating: Double) -> Mood", "parameterSignature": "rating: Double", "parameterSignatureWithoutNames": "rating: Double", "inputTypes": "Double", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "rating", "call": "rating: rating", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("rating"), name: "rating", type: "Double", range: CountableRange(917..<931), nameRange: CountableRange(917..<923))], "returnType": "Mood", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func mood(rating: Double)  -> Mood {
        
            return cuckoo_manager.call("mood(rating: Double) -> Mood",
                parameters: (rating),
                superclassCall:
                    
                    super.mood(rating: rating)
                    )
        
    }
    
    // ["name": "mood", "returnSignature": " -> Mood", "fullyQualifiedName": "mood(timestamp: Date) -> Mood", "parameterSignature": "timestamp: Date", "parameterSignatureWithoutNames": "timestamp: Date", "inputTypes": "Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "timestamp", "call": "timestamp: timestamp", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("timestamp"), name: "timestamp", type: "Date", range: CountableRange(995..<1010), nameRange: CountableRange(995..<1004))], "returnType": "Mood", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func mood(timestamp: Date)  -> Mood {
        
            return cuckoo_manager.call("mood(timestamp: Date) -> Mood",
                parameters: (timestamp),
                superclassCall:
                    
                    super.mood(timestamp: timestamp)
                    )
        
    }
    

	struct __StubbingProxy_DataTypesFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func activity() -> Cuckoo.ClassStubFunction<(), Activity> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "activity() -> Activity", parameterMatchers: matchers))
	    }
	    
	    func activityInstance<M1: Cuckoo.Matchable>(activity: M1) -> Cuckoo.ClassStubFunction<(Activity), ActivityInstance> where M1.MatchedType == Activity {
	        let matchers: [Cuckoo.ParameterMatcher<(Activity)>] = [wrap(matchable: activity) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "activityInstance(activity: Activity) -> ActivityInstance", parameterMatchers: matchers))
	    }
	    
	    func heartRate<M1: Cuckoo.Matchable>(value: M1) -> Cuckoo.ClassStubFunction<(Double), HeartRate> where M1.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Double)>] = [wrap(matchable: value) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "heartRate(value: Double) -> HeartRate", parameterMatchers: matchers))
	    }
	    
	    func heartRate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ value: M1, _ dateType: M2, _ date: M3) -> Cuckoo.ClassStubFunction<(Double, DateType, Date), HeartRate> where M1.MatchedType == Double, M2.MatchedType == DateType, M3.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, DateType, Date)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: dateType) { $0.1 }, wrap(matchable: date) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "heartRate(_: Double, _: DateType, _: Date) -> HeartRate", parameterMatchers: matchers))
	    }
	    
	    func heartRate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ value: M1, _ dates: M2) -> Cuckoo.ClassStubFunction<(Double, [DateType: Date]), HeartRate> where M1.MatchedType == Double, M2.MatchedType == [DateType: Date] {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, [DateType: Date])>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: dates) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "heartRate(_: Double, _: [DateType: Date]) -> HeartRate", parameterMatchers: matchers))
	    }
	    
	    func heartRate<M1: Cuckoo.Matchable>(_ sample: M1) -> Cuckoo.ClassStubFunction<(HKQuantitySample), HeartRate> where M1.MatchedType == HKQuantitySample {
	        let matchers: [Cuckoo.ParameterMatcher<(HKQuantitySample)>] = [wrap(matchable: sample) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "heartRate(_: HKQuantitySample) -> HeartRate", parameterMatchers: matchers))
	    }
	    
	    func mood() -> Cuckoo.ClassStubFunction<(), Mood> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "mood() -> Mood", parameterMatchers: matchers))
	    }
	    
	    func mood<M1: Cuckoo.Matchable>(rating: M1) -> Cuckoo.ClassStubFunction<(Double), Mood> where M1.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Double)>] = [wrap(matchable: rating) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "mood(rating: Double) -> Mood", parameterMatchers: matchers))
	    }
	    
	    func mood<M1: Cuckoo.Matchable>(timestamp: M1) -> Cuckoo.ClassStubFunction<(Date), Mood> where M1.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Date)>] = [wrap(matchable: timestamp) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "mood(timestamp: Date) -> Mood", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_DataTypesFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func activity() -> Cuckoo.__DoNotUse<Activity> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("activity() -> Activity", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func activityInstance<M1: Cuckoo.Matchable>(activity: M1) -> Cuckoo.__DoNotUse<ActivityInstance> where M1.MatchedType == Activity {
	        let matchers: [Cuckoo.ParameterMatcher<(Activity)>] = [wrap(matchable: activity) { $0 }]
	        return cuckoo_manager.verify("activityInstance(activity: Activity) -> ActivityInstance", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func heartRate<M1: Cuckoo.Matchable>(value: M1) -> Cuckoo.__DoNotUse<HeartRate> where M1.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Double)>] = [wrap(matchable: value) { $0 }]
	        return cuckoo_manager.verify("heartRate(value: Double) -> HeartRate", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func heartRate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ value: M1, _ dateType: M2, _ date: M3) -> Cuckoo.__DoNotUse<HeartRate> where M1.MatchedType == Double, M2.MatchedType == DateType, M3.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, DateType, Date)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: dateType) { $0.1 }, wrap(matchable: date) { $0.2 }]
	        return cuckoo_manager.verify("heartRate(_: Double, _: DateType, _: Date) -> HeartRate", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func heartRate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ value: M1, _ dates: M2) -> Cuckoo.__DoNotUse<HeartRate> where M1.MatchedType == Double, M2.MatchedType == [DateType: Date] {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, [DateType: Date])>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: dates) { $0.1 }]
	        return cuckoo_manager.verify("heartRate(_: Double, _: [DateType: Date]) -> HeartRate", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func heartRate<M1: Cuckoo.Matchable>(_ sample: M1) -> Cuckoo.__DoNotUse<HeartRate> where M1.MatchedType == HKQuantitySample {
	        let matchers: [Cuckoo.ParameterMatcher<(HKQuantitySample)>] = [wrap(matchable: sample) { $0 }]
	        return cuckoo_manager.verify("heartRate(_: HKQuantitySample) -> HeartRate", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func mood() -> Cuckoo.__DoNotUse<Mood> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("mood() -> Mood", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func mood<M1: Cuckoo.Matchable>(rating: M1) -> Cuckoo.__DoNotUse<Mood> where M1.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Double)>] = [wrap(matchable: rating) { $0 }]
	        return cuckoo_manager.verify("mood(rating: Double) -> Mood", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func mood<M1: Cuckoo.Matchable>(timestamp: M1) -> Cuckoo.__DoNotUse<Mood> where M1.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Date)>] = [wrap(matchable: timestamp) { $0 }]
	        return cuckoo_manager.verify("mood(timestamp: Date) -> Mood", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class DataTypesFactoryStub: DataTypesFactory {
    

    

    
    public override func activity()  -> Activity {
        return DefaultValueRegistry.defaultValue(for: Activity.self)
    }
    
    public override func activityInstance(activity: Activity)  -> ActivityInstance {
        return DefaultValueRegistry.defaultValue(for: ActivityInstance.self)
    }
    
    public override func heartRate(value: Double)  -> HeartRate {
        return DefaultValueRegistry.defaultValue(for: HeartRate.self)
    }
    
    public override func heartRate(_ value: Double, _ dateType: DateType, _ date: Date)  -> HeartRate {
        return DefaultValueRegistry.defaultValue(for: HeartRate.self)
    }
    
    public override func heartRate(_ value: Double, _ dates: [DateType: Date])  -> HeartRate {
        return DefaultValueRegistry.defaultValue(for: HeartRate.self)
    }
    
    public override func heartRate(_ sample: HKQuantitySample)  -> HeartRate {
        return DefaultValueRegistry.defaultValue(for: HeartRate.self)
    }
    
    public override func mood()  -> Mood {
        return DefaultValueRegistry.defaultValue(for: Mood.self)
    }
    
    public override func mood(rating: Double)  -> Mood {
        return DefaultValueRegistry.defaultValue(for: Mood.self)
    }
    
    public override func mood(timestamp: Date)  -> Mood {
        return DefaultValueRegistry.defaultValue(for: Mood.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/Queriers/QuerierFactory.swift
//
//  QuerierFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

import Foundation

class MockQuerierFactory: QuerierFactory, Cuckoo.ClassMock {
    typealias MocksType = QuerierFactory
    typealias Stubbing = __StubbingProxy_QuerierFactory
    typealias Verification = __VerificationProxy_QuerierFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "heartRateQuerier", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "HeartRateQuerier", "isReadOnly": true, "accessibility": "public"]
    public override var heartRateQuerier: HeartRateQuerier {
        get {
            
            return cuckoo_manager.getter("heartRateQuerier", superclassCall: super.heartRateQuerier)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_QuerierFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var heartRateQuerier: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuerierFactory, HeartRateQuerier> {
	        return .init(manager: cuckoo_manager, name: "heartRateQuerier")
	    }
	    
	    
	}

	struct __VerificationProxy_QuerierFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var heartRateQuerier: Cuckoo.VerifyReadOnlyProperty<HeartRateQuerier> {
	        return .init(manager: cuckoo_manager, name: "heartRateQuerier", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class QuerierFactoryStub: QuerierFactory {
    
    public override var heartRateQuerier: HeartRateQuerier {
        get {
            return DefaultValueRegistry.defaultValue(for: (HeartRateQuerier).self)
        }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/SubQueryMatchers/SubQueryMatcherFactory.swift
//
//  SubQueryMatcherFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

import Foundation

class MockSubQueryMatcherFactory: SubQueryMatcherFactory, Cuckoo.ClassMock {
    typealias MocksType = SubQueryMatcherFactory
    typealias Stubbing = __StubbingProxy_SubQueryMatcherFactory
    typealias Verification = __VerificationProxy_SubQueryMatcherFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "withinXCalendarUnitsSubQueryMatcher", "returnSignature": " -> WithinXCalendarUnitsSubQueryMatcher", "fullyQualifiedName": "withinXCalendarUnitsSubQueryMatcher() -> WithinXCalendarUnitsSubQueryMatcher", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "WithinXCalendarUnitsSubQueryMatcher", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func withinXCalendarUnitsSubQueryMatcher()  -> WithinXCalendarUnitsSubQueryMatcher {
        
            return cuckoo_manager.call("withinXCalendarUnitsSubQueryMatcher() -> WithinXCalendarUnitsSubQueryMatcher",
                parameters: (),
                superclassCall:
                    
                    super.withinXCalendarUnitsSubQueryMatcher()
                    )
        
    }
    
    // ["name": "inSameCalendarUnitSubQueryMatcher", "returnSignature": " -> InSameCalendarUnitSubQueryMatcher", "fullyQualifiedName": "inSameCalendarUnitSubQueryMatcher() -> InSameCalendarUnitSubQueryMatcher", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "InSameCalendarUnitSubQueryMatcher", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func inSameCalendarUnitSubQueryMatcher()  -> InSameCalendarUnitSubQueryMatcher {
        
            return cuckoo_manager.call("inSameCalendarUnitSubQueryMatcher() -> InSameCalendarUnitSubQueryMatcher",
                parameters: (),
                superclassCall:
                    
                    super.inSameCalendarUnitSubQueryMatcher()
                    )
        
    }
    
    // ["name": "sameDatesSubQueryMatcher", "returnSignature": " -> SameDatesSubQueryMatcher", "fullyQualifiedName": "sameDatesSubQueryMatcher() -> SameDatesSubQueryMatcher", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "SameDatesSubQueryMatcher", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func sameDatesSubQueryMatcher()  -> SameDatesSubQueryMatcher {
        
            return cuckoo_manager.call("sameDatesSubQueryMatcher() -> SameDatesSubQueryMatcher",
                parameters: (),
                superclassCall:
                    
                    super.sameDatesSubQueryMatcher()
                    )
        
    }
    
    // ["name": "sameStartDatesSubQueryMatcher", "returnSignature": " -> SameStartDatesSubQueryMatcher", "fullyQualifiedName": "sameStartDatesSubQueryMatcher() -> SameStartDatesSubQueryMatcher", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "SameStartDatesSubQueryMatcher", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func sameStartDatesSubQueryMatcher()  -> SameStartDatesSubQueryMatcher {
        
            return cuckoo_manager.call("sameStartDatesSubQueryMatcher() -> SameStartDatesSubQueryMatcher",
                parameters: (),
                superclassCall:
                    
                    super.sameStartDatesSubQueryMatcher()
                    )
        
    }
    
    // ["name": "sameEndDatesSubQueryMatcher", "returnSignature": " -> SameEndDatesSubQueryMatcher", "fullyQualifiedName": "sameEndDatesSubQueryMatcher() -> SameEndDatesSubQueryMatcher", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "SameEndDatesSubQueryMatcher", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func sameEndDatesSubQueryMatcher()  -> SameEndDatesSubQueryMatcher {
        
            return cuckoo_manager.call("sameEndDatesSubQueryMatcher() -> SameEndDatesSubQueryMatcher",
                parameters: (),
                superclassCall:
                    
                    super.sameEndDatesSubQueryMatcher()
                    )
        
    }
    

	struct __StubbingProxy_SubQueryMatcherFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func withinXCalendarUnitsSubQueryMatcher() -> Cuckoo.ClassStubFunction<(), WithinXCalendarUnitsSubQueryMatcher> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockSubQueryMatcherFactory.self, method: "withinXCalendarUnitsSubQueryMatcher() -> WithinXCalendarUnitsSubQueryMatcher", parameterMatchers: matchers))
	    }
	    
	    func inSameCalendarUnitSubQueryMatcher() -> Cuckoo.ClassStubFunction<(), InSameCalendarUnitSubQueryMatcher> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockSubQueryMatcherFactory.self, method: "inSameCalendarUnitSubQueryMatcher() -> InSameCalendarUnitSubQueryMatcher", parameterMatchers: matchers))
	    }
	    
	    func sameDatesSubQueryMatcher() -> Cuckoo.ClassStubFunction<(), SameDatesSubQueryMatcher> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockSubQueryMatcherFactory.self, method: "sameDatesSubQueryMatcher() -> SameDatesSubQueryMatcher", parameterMatchers: matchers))
	    }
	    
	    func sameStartDatesSubQueryMatcher() -> Cuckoo.ClassStubFunction<(), SameStartDatesSubQueryMatcher> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockSubQueryMatcherFactory.self, method: "sameStartDatesSubQueryMatcher() -> SameStartDatesSubQueryMatcher", parameterMatchers: matchers))
	    }
	    
	    func sameEndDatesSubQueryMatcher() -> Cuckoo.ClassStubFunction<(), SameEndDatesSubQueryMatcher> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockSubQueryMatcherFactory.self, method: "sameEndDatesSubQueryMatcher() -> SameEndDatesSubQueryMatcher", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_SubQueryMatcherFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func withinXCalendarUnitsSubQueryMatcher() -> Cuckoo.__DoNotUse<WithinXCalendarUnitsSubQueryMatcher> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("withinXCalendarUnitsSubQueryMatcher() -> WithinXCalendarUnitsSubQueryMatcher", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func inSameCalendarUnitSubQueryMatcher() -> Cuckoo.__DoNotUse<InSameCalendarUnitSubQueryMatcher> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("inSameCalendarUnitSubQueryMatcher() -> InSameCalendarUnitSubQueryMatcher", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func sameDatesSubQueryMatcher() -> Cuckoo.__DoNotUse<SameDatesSubQueryMatcher> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("sameDatesSubQueryMatcher() -> SameDatesSubQueryMatcher", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func sameStartDatesSubQueryMatcher() -> Cuckoo.__DoNotUse<SameStartDatesSubQueryMatcher> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("sameStartDatesSubQueryMatcher() -> SameStartDatesSubQueryMatcher", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func sameEndDatesSubQueryMatcher() -> Cuckoo.__DoNotUse<SameEndDatesSubQueryMatcher> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("sameEndDatesSubQueryMatcher() -> SameEndDatesSubQueryMatcher", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class SubQueryMatcherFactoryStub: SubQueryMatcherFactory {
    

    

    
    public override func withinXCalendarUnitsSubQueryMatcher()  -> WithinXCalendarUnitsSubQueryMatcher {
        return DefaultValueRegistry.defaultValue(for: WithinXCalendarUnitsSubQueryMatcher.self)
    }
    
    public override func inSameCalendarUnitSubQueryMatcher()  -> InSameCalendarUnitSubQueryMatcher {
        return DefaultValueRegistry.defaultValue(for: InSameCalendarUnitSubQueryMatcher.self)
    }
    
    public override func sameDatesSubQueryMatcher()  -> SameDatesSubQueryMatcher {
        return DefaultValueRegistry.defaultValue(for: SameDatesSubQueryMatcher.self)
    }
    
    public override func sameStartDatesSubQueryMatcher()  -> SameStartDatesSubQueryMatcher {
        return DefaultValueRegistry.defaultValue(for: SameStartDatesSubQueryMatcher.self)
    }
    
    public override func sameEndDatesSubQueryMatcher()  -> SameEndDatesSubQueryMatcher {
        return DefaultValueRegistry.defaultValue(for: SameEndDatesSubQueryMatcher.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/QuestionFactory.swift
//
//  QuestionFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

import Foundation

class MockQuestionFactory: QuestionFactory, Cuckoo.ClassMock {
    typealias MocksType = QuestionFactory
    typealias Stubbing = __StubbingProxy_QuestionFactory
    typealias Verification = __VerificationProxy_QuestionFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "answer", "returnSignature": " -> Answer", "fullyQualifiedName": "answer() -> Answer", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Answer", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func answer()  -> Answer {
        
            return cuckoo_manager.call("answer() -> Answer",
                parameters: (),
                superclassCall:
                    
                    super.answer()
                    )
        
    }
    
    // ["name": "labels", "returnSignature": " -> Labels", "fullyQualifiedName": "labels() -> Labels", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Labels", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func labels()  -> Labels {
        
            return cuckoo_manager.call("labels() -> Labels",
                parameters: (),
                superclassCall:
                    
                    super.labels()
                    )
        
    }
    

	struct __StubbingProxy_QuestionFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func answer() -> Cuckoo.ClassStubFunction<(), Answer> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockQuestionFactory.self, method: "answer() -> Answer", parameterMatchers: matchers))
	    }
	    
	    func labels() -> Cuckoo.ClassStubFunction<(), Labels> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockQuestionFactory.self, method: "labels() -> Labels", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_QuestionFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func answer() -> Cuckoo.__DoNotUse<Answer> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("answer() -> Answer", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func labels() -> Cuckoo.__DoNotUse<Labels> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("labels() -> Labels", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class QuestionFactoryStub: QuestionFactory {
    

    

    
     override func answer()  -> Answer {
        return DefaultValueRegistry.defaultValue(for: Answer.self)
    }
    
     override func labels()  -> Labels {
        return DefaultValueRegistry.defaultValue(for: Labels.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/RestrictionParsers/RestrictionParserFactory.swift
//
//  RestrictionParserFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

import Foundation

class MockRestrictionParserFactory: RestrictionParserFactory, Cuckoo.ClassMock {
    typealias MocksType = RestrictionParserFactory
    typealias Stubbing = __StubbingProxy_RestrictionParserFactory
    typealias Verification = __VerificationProxy_RestrictionParserFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "dayOfWeekRestrictionParser", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "DayOfWeekRestrictionParser", "isReadOnly": true, "accessibility": "public"]
    public override var dayOfWeekRestrictionParser: DayOfWeekRestrictionParser {
        get {
            
            return cuckoo_manager.getter("dayOfWeekRestrictionParser", superclassCall: super.dayOfWeekRestrictionParser)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_RestrictionParserFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var dayOfWeekRestrictionParser: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockRestrictionParserFactory, DayOfWeekRestrictionParser> {
	        return .init(manager: cuckoo_manager, name: "dayOfWeekRestrictionParser")
	    }
	    
	    
	}

	struct __VerificationProxy_RestrictionParserFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var dayOfWeekRestrictionParser: Cuckoo.VerifyReadOnlyProperty<DayOfWeekRestrictionParser> {
	        return .init(manager: cuckoo_manager, name: "dayOfWeekRestrictionParser", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class RestrictionParserFactoryStub: RestrictionParserFactory {
    
    public override var dayOfWeekRestrictionParser: DayOfWeekRestrictionParser {
        get {
            return DefaultValueRegistry.defaultValue(for: (DayOfWeekRestrictionParser).self)
        }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Util/UtilFactory.swift
//
//  UtilFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo

import Foundation

class MockUtilFactory: UtilFactory, Cuckoo.ClassMock {
    typealias MocksType = UtilFactory
    typealias Stubbing = __StubbingProxy_UtilFactory
    typealias Verification = __VerificationProxy_UtilFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "calendarUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "CalendarUtil", "isReadOnly": true, "accessibility": "public"]
    public override var calendarUtil: CalendarUtil {
        get {
            
            return cuckoo_manager.getter("calendarUtil", superclassCall: super.calendarUtil)
            
        }
        
    }
    
    // ["name": "numericSampleUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "NumericSampleUtil", "isReadOnly": true, "accessibility": "public"]
    public override var numericSampleUtil: NumericSampleUtil {
        get {
            
            return cuckoo_manager.getter("numericSampleUtil", superclassCall: super.numericSampleUtil)
            
        }
        
    }
    
    // ["name": "textNormalizationUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "TextNormalizationUtil", "isReadOnly": true, "accessibility": "public"]
    public override var textNormalizationUtil: TextNormalizationUtil {
        get {
            
            return cuckoo_manager.getter("textNormalizationUtil", superclassCall: super.textNormalizationUtil)
            
        }
        
    }
    
    // ["name": "sampleUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "SampleUtil", "isReadOnly": true, "accessibility": "public"]
    public override var sampleUtil: SampleUtil {
        get {
            
            return cuckoo_manager.getter("sampleUtil", superclassCall: super.sampleUtil)
            
        }
        
    }
    
    // ["name": "timeConstraintUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "TimeConstraintUtil", "isReadOnly": true, "accessibility": "public"]
    public override var timeConstraintUtil: TimeConstraintUtil {
        get {
            
            return cuckoo_manager.getter("timeConstraintUtil", superclassCall: super.timeConstraintUtil)
            
        }
        
    }
    
    // ["name": "searchUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "SearchUtil", "isReadOnly": true, "accessibility": "public"]
    public override var searchUtil: SearchUtil {
        get {
            
            return cuckoo_manager.getter("searchUtil", superclassCall: super.searchUtil)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_UtilFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var calendarUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, CalendarUtil> {
	        return .init(manager: cuckoo_manager, name: "calendarUtil")
	    }
	    
	    var numericSampleUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, NumericSampleUtil> {
	        return .init(manager: cuckoo_manager, name: "numericSampleUtil")
	    }
	    
	    var textNormalizationUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, TextNormalizationUtil> {
	        return .init(manager: cuckoo_manager, name: "textNormalizationUtil")
	    }
	    
	    var sampleUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, SampleUtil> {
	        return .init(manager: cuckoo_manager, name: "sampleUtil")
	    }
	    
	    var timeConstraintUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, TimeConstraintUtil> {
	        return .init(manager: cuckoo_manager, name: "timeConstraintUtil")
	    }
	    
	    var searchUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, SearchUtil> {
	        return .init(manager: cuckoo_manager, name: "searchUtil")
	    }
	    
	    
	}

	struct __VerificationProxy_UtilFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var calendarUtil: Cuckoo.VerifyReadOnlyProperty<CalendarUtil> {
	        return .init(manager: cuckoo_manager, name: "calendarUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var numericSampleUtil: Cuckoo.VerifyReadOnlyProperty<NumericSampleUtil> {
	        return .init(manager: cuckoo_manager, name: "numericSampleUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var textNormalizationUtil: Cuckoo.VerifyReadOnlyProperty<TextNormalizationUtil> {
	        return .init(manager: cuckoo_manager, name: "textNormalizationUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var sampleUtil: Cuckoo.VerifyReadOnlyProperty<SampleUtil> {
	        return .init(manager: cuckoo_manager, name: "sampleUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var timeConstraintUtil: Cuckoo.VerifyReadOnlyProperty<TimeConstraintUtil> {
	        return .init(manager: cuckoo_manager, name: "timeConstraintUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var searchUtil: Cuckoo.VerifyReadOnlyProperty<SearchUtil> {
	        return .init(manager: cuckoo_manager, name: "searchUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class UtilFactoryStub: UtilFactory {
    
    public override var calendarUtil: CalendarUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (CalendarUtil).self)
        }
        
    }
    
    public override var numericSampleUtil: NumericSampleUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (NumericSampleUtil).self)
        }
        
    }
    
    public override var textNormalizationUtil: TextNormalizationUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (TextNormalizationUtil).self)
        }
        
    }
    
    public override var sampleUtil: SampleUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (SampleUtil).self)
        }
        
    }
    
    public override var timeConstraintUtil: TimeConstraintUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (TimeConstraintUtil).self)
        }
        
    }
    
    public override var searchUtil: SearchUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (SearchUtil).self)
        }
        
    }
    

    

    
}

