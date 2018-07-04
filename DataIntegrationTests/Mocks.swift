// MARK: - Mocks generated from file: DataIntegration/DataTypes/Activity.swift
//
//  Activity.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockActivity: Activity, Cuckoo.ClassMock {
    typealias MocksType = Activity
    typealias Stubbing = __StubbingProxy_Activity
    typealias Verification = __VerificationProxy_Activity
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": ""]
     override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "tags", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "NSArray", "isReadOnly": false, "accessibility": ""]
     override var tags: NSArray {
        get {
            
            return cuckoo_manager.getter("tags", superclassCall: super.tags)
            
        }
        
        set {
            
            cuckoo_manager.setter("tags", value: newValue, superclassCall: super.tags = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_Activity: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockActivity, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var tags: Cuckoo.ClassToBeStubbedProperty<MockActivity, NSArray> {
	        return .init(manager: cuckoo_manager, name: "tags")
	    }
	    
	    
	}

	struct __VerificationProxy_Activity: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var tags: Cuckoo.VerifyProperty<NSArray> {
	        return .init(manager: cuckoo_manager, name: "tags", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class ActivityStub: Activity {
    
     override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
     override var tags: NSArray {
        get {
            return DefaultValueRegistry.defaultValue(for: (NSArray).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/DataTypes/ActivityInstance.swift
//
//  ActivityInstance.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockActivityInstance: ActivityInstance, Cuckoo.ClassMock {
    typealias MocksType = ActivityInstance
    typealias Stubbing = __StubbingProxy_ActivityInstance
    typealias Verification = __VerificationProxy_ActivityInstance
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "activity", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Activity", "isReadOnly": false, "accessibility": ""]
     override var activity: Activity {
        get {
            
            return cuckoo_manager.getter("activity", superclassCall: super.activity)
            
        }
        
        set {
            
            cuckoo_manager.setter("activity", value: newValue, superclassCall: super.activity = newValue)
            
        }
        
    }
    
    // ["name": "startTimestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var startTimestamp: Date {
        get {
            
            return cuckoo_manager.getter("startTimestamp", superclassCall: super.startTimestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("startTimestamp", value: newValue, superclassCall: super.startTimestamp = newValue)
            
        }
        
    }
    
    // ["name": "endTimestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var endTimestamp: Date {
        get {
            
            return cuckoo_manager.getter("endTimestamp", superclassCall: super.endTimestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("endTimestamp", value: newValue, superclassCall: super.endTimestamp = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_ActivityInstance: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var activity: Cuckoo.ClassToBeStubbedProperty<MockActivityInstance, Activity> {
	        return .init(manager: cuckoo_manager, name: "activity")
	    }
	    
	    var startTimestamp: Cuckoo.ClassToBeStubbedProperty<MockActivityInstance, Date> {
	        return .init(manager: cuckoo_manager, name: "startTimestamp")
	    }
	    
	    var endTimestamp: Cuckoo.ClassToBeStubbedProperty<MockActivityInstance, Date> {
	        return .init(manager: cuckoo_manager, name: "endTimestamp")
	    }
	    
	    
	}

	struct __VerificationProxy_ActivityInstance: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var activity: Cuckoo.VerifyProperty<Activity> {
	        return .init(manager: cuckoo_manager, name: "activity", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var startTimestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "startTimestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var endTimestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "endTimestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class ActivityInstanceStub: ActivityInstance {
    
     override var activity: Activity {
        get {
            return DefaultValueRegistry.defaultValue(for: (Activity).self)
        }
        
        set { }
        
    }
    
     override var startTimestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    
     override var endTimestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/DataTypes/DataTypesFactory.swift
//
//  DataTypesFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockDataTypesFactory: DataTypesFactory, Cuckoo.ClassMock {
    typealias MocksType = DataTypesFactory
    typealias Stubbing = __StubbingProxy_DataTypesFactory
    typealias Verification = __VerificationProxy_DataTypesFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "activity", "returnSignature": " -> Activity", "fullyQualifiedName": "activity() -> Activity", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Activity", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func activity()  -> Activity {
        
            return cuckoo_manager.call("activity() -> Activity",
                parameters: (),
                superclassCall:
                    
                    super.activity()
                    )
        
    }
    
    // ["name": "activityInstance", "returnSignature": " -> ActivityInstance", "fullyQualifiedName": "activityInstance(activity: Activity) -> ActivityInstance", "parameterSignature": "activity: Activity", "parameterSignatureWithoutNames": "activity: Activity", "inputTypes": "Activity", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "activity", "call": "activity: activity", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("activity"), name: "activity", type: "Activity", range: CountableRange(283..<301), nameRange: CountableRange(283..<291))], "returnType": "ActivityInstance", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func activityInstance(activity: Activity)  -> ActivityInstance {
        
            return cuckoo_manager.call("activityInstance(activity: Activity) -> ActivityInstance",
                parameters: (activity),
                superclassCall:
                    
                    super.activityInstance(activity: activity)
                    )
        
    }
    
    // ["name": "heartRate", "returnSignature": " -> HeartRate", "fullyQualifiedName": "heartRate(value: Double) -> HeartRate", "parameterSignature": "value: Double", "parameterSignatureWithoutNames": "value: Double", "inputTypes": "Double", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "value", "call": "value: value", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("value"), name: "value", type: "Double", range: CountableRange(391..<404), nameRange: CountableRange(391..<396))], "returnType": "HeartRate", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func heartRate(value: Double)  -> HeartRate {
        
            return cuckoo_manager.call("heartRate(value: Double) -> HeartRate",
                parameters: (value),
                superclassCall:
                    
                    super.heartRate(value: value)
                    )
        
    }
    
    // ["name": "heartRate", "returnSignature": " -> HeartRate", "fullyQualifiedName": "heartRate(value: Double, timestamp: Date) -> HeartRate", "parameterSignature": "value: Double, timestamp: Date", "parameterSignatureWithoutNames": "value: Double, timestamp: Date", "inputTypes": "Double, Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "value, timestamp", "call": "value: value, timestamp: timestamp", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("value"), name: "value", type: "Double", range: CountableRange(474..<487), nameRange: CountableRange(474..<479)), CuckooGeneratorFramework.MethodParameter(label: Optional("timestamp"), name: "timestamp", type: "Date", range: CountableRange(489..<504), nameRange: CountableRange(489..<498))], "returnType": "HeartRate", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func heartRate(value: Double, timestamp: Date)  -> HeartRate {
        
            return cuckoo_manager.call("heartRate(value: Double, timestamp: Date) -> HeartRate",
                parameters: (value, timestamp),
                superclassCall:
                    
                    super.heartRate(value: value, timestamp: timestamp)
                    )
        
    }
    
    // ["name": "mood", "returnSignature": " -> Mood", "fullyQualifiedName": "mood() -> Mood", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Mood", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func mood()  -> Mood {
        
            return cuckoo_manager.call("mood() -> Mood",
                parameters: (),
                superclassCall:
                    
                    super.mood()
                    )
        
    }
    
    // ["name": "mood", "returnSignature": " -> Mood", "fullyQualifiedName": "mood(rating: Double) -> Mood", "parameterSignature": "rating: Double", "parameterSignatureWithoutNames": "rating: Double", "inputTypes": "Double", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "rating", "call": "rating: rating", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("rating"), name: "rating", type: "Double", range: CountableRange(634..<648), nameRange: CountableRange(634..<640))], "returnType": "Mood", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func mood(rating: Double)  -> Mood {
        
            return cuckoo_manager.call("mood(rating: Double) -> Mood",
                parameters: (rating),
                superclassCall:
                    
                    super.mood(rating: rating)
                    )
        
    }
    
    // ["name": "mood", "returnSignature": " -> Mood", "fullyQualifiedName": "mood(timestamp: Date) -> Mood", "parameterSignature": "timestamp: Date", "parameterSignatureWithoutNames": "timestamp: Date", "inputTypes": "Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "timestamp", "call": "timestamp: timestamp", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("timestamp"), name: "timestamp", type: "Date", range: CountableRange(705..<720), nameRange: CountableRange(705..<714))], "returnType": "Mood", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func mood(timestamp: Date)  -> Mood {
        
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
	    
	    func heartRate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(value: M1, timestamp: M2) -> Cuckoo.ClassStubFunction<(Double, Date), HeartRate> where M1.MatchedType == Double, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, Date)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: timestamp) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataTypesFactory.self, method: "heartRate(value: Double, timestamp: Date) -> HeartRate", parameterMatchers: matchers))
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
	    func heartRate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(value: M1, timestamp: M2) -> Cuckoo.__DoNotUse<HeartRate> where M1.MatchedType == Double, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, Date)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: timestamp) { $0.1 }]
	        return cuckoo_manager.verify("heartRate(value: Double, timestamp: Date) -> HeartRate", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    

    

    
     override func activity()  -> Activity {
        return DefaultValueRegistry.defaultValue(for: Activity.self)
    }
    
     override func activityInstance(activity: Activity)  -> ActivityInstance {
        return DefaultValueRegistry.defaultValue(for: ActivityInstance.self)
    }
    
     override func heartRate(value: Double)  -> HeartRate {
        return DefaultValueRegistry.defaultValue(for: HeartRate.self)
    }
    
     override func heartRate(value: Double, timestamp: Date)  -> HeartRate {
        return DefaultValueRegistry.defaultValue(for: HeartRate.self)
    }
    
     override func mood()  -> Mood {
        return DefaultValueRegistry.defaultValue(for: Mood.self)
    }
    
     override func mood(rating: Double)  -> Mood {
        return DefaultValueRegistry.defaultValue(for: Mood.self)
    }
    
     override func mood(timestamp: Date)  -> Mood {
        return DefaultValueRegistry.defaultValue(for: Mood.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/DataTypes/HeartRate.swift
//
//  HeartRate.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockHeartRate: HeartRate, Cuckoo.ClassMock {
    typealias MocksType = HeartRate
    typealias Stubbing = __StubbingProxy_HeartRate
    typealias Verification = __VerificationProxy_HeartRate
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "value", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Double", "isReadOnly": false, "accessibility": ""]
     override var value: Double {
        get {
            
            return cuckoo_manager.getter("value", superclassCall: super.value)
            
        }
        
        set {
            
            cuckoo_manager.setter("value", value: newValue, superclassCall: super.value = newValue)
            
        }
        
    }
    
    // ["name": "timestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var timestamp: Date {
        get {
            
            return cuckoo_manager.getter("timestamp", superclassCall: super.timestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("timestamp", value: newValue, superclassCall: super.timestamp = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_HeartRate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var value: Cuckoo.ClassToBeStubbedProperty<MockHeartRate, Double> {
	        return .init(manager: cuckoo_manager, name: "value")
	    }
	    
	    var timestamp: Cuckoo.ClassToBeStubbedProperty<MockHeartRate, Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp")
	    }
	    
	    
	}

	struct __VerificationProxy_HeartRate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var value: Cuckoo.VerifyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "value", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var timestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class HeartRateStub: HeartRate {
    
     override var value: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
        set { }
        
    }
    
     override var timestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/DataTypes/Mood.swift
//
//  Mood.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockMood: Mood, Cuckoo.ClassMock {
    typealias MocksType = Mood
    typealias Stubbing = __StubbingProxy_Mood
    typealias Verification = __VerificationProxy_Mood
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "timestamp", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date", "isReadOnly": false, "accessibility": ""]
     override var timestamp: Date {
        get {
            
            return cuckoo_manager.getter("timestamp", superclassCall: super.timestamp)
            
        }
        
        set {
            
            cuckoo_manager.setter("timestamp", value: newValue, superclassCall: super.timestamp = newValue)
            
        }
        
    }
    
    // ["name": "rating", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Double", "isReadOnly": false, "accessibility": ""]
     override var rating: Double {
        get {
            
            return cuckoo_manager.getter("rating", superclassCall: super.rating)
            
        }
        
        set {
            
            cuckoo_manager.setter("rating", value: newValue, superclassCall: super.rating = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_Mood: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var timestamp: Cuckoo.ClassToBeStubbedProperty<MockMood, Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp")
	    }
	    
	    var rating: Cuckoo.ClassToBeStubbedProperty<MockMood, Double> {
	        return .init(manager: cuckoo_manager, name: "rating")
	    }
	    
	    
	}

	struct __VerificationProxy_Mood: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var timestamp: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "timestamp", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var rating: Cuckoo.VerifyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "rating", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class MoodStub: Mood {
    
     override var timestamp: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    
     override var rating: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Answer.swift
//
//  Answer.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockAnswer: Answer, Cuckoo.ClassMock {
    typealias MocksType = Answer
    typealias Stubbing = __StubbingProxy_Answer
    typealias Verification = __VerificationProxy_Answer
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "finalAnswer", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var finalAnswer: String {
        get {
            
            return cuckoo_manager.getter("finalAnswer", superclassCall: super.finalAnswer)
            
        }
        
        set {
            
            cuckoo_manager.setter("finalAnswer", value: newValue, superclassCall: super.finalAnswer = newValue)
            
        }
        
    }
    
    // ["name": "otherRelevantInformation", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: [NSObject]]", "isReadOnly": false, "accessibility": "public"]
    public override var otherRelevantInformation: [String: [NSObject]] {
        get {
            
            return cuckoo_manager.getter("otherRelevantInformation", superclassCall: super.otherRelevantInformation)
            
        }
        
        set {
            
            cuckoo_manager.setter("otherRelevantInformation", value: newValue, superclassCall: super.otherRelevantInformation = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_Answer: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var finalAnswer: Cuckoo.ClassToBeStubbedProperty<MockAnswer, String> {
	        return .init(manager: cuckoo_manager, name: "finalAnswer")
	    }
	    
	    var otherRelevantInformation: Cuckoo.ClassToBeStubbedProperty<MockAnswer, [String: [NSObject]]> {
	        return .init(manager: cuckoo_manager, name: "otherRelevantInformation")
	    }
	    
	    
	}

	struct __VerificationProxy_Answer: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var finalAnswer: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "finalAnswer", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var otherRelevantInformation: Cuckoo.VerifyProperty<[String: [NSObject]]> {
	        return .init(manager: cuckoo_manager, name: "otherRelevantInformation", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class AnswerStub: Answer {
    
    public override var finalAnswer: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var otherRelevantInformation: [String: [NSObject]] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: [NSObject]]).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Labels.swift
//
//  Labels.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage

class MockLabels: Labels, Cuckoo.ClassMock {
    typealias MocksType = Labels
    typealias Stubbing = __StubbingProxy_Labels
    typealias Verification = __VerificationProxy_Labels
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "count", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Int", "isReadOnly": true, "accessibility": "public"]
    public override var count: Int {
        get {
            
            return cuckoo_manager.getter("count", superclassCall: super.count)
            
        }
        
    }
    
    // ["name": "isEmpty", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Bool", "isReadOnly": true, "accessibility": "public"]
    public override var isEmpty: Bool {
        get {
            
            return cuckoo_manager.getter("isEmpty", superclassCall: super.isEmpty)
            
        }
        
    }
    
    // ["name": "byTag", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "[NLTag: [Label]]", "isReadOnly": true, "accessibility": "public"]
    public override var byTag: [NLTag: [Label]] {
        get {
            
            return cuckoo_manager.getter("byTag", superclassCall: super.byTag)
            
        }
        
    }
    
    // ["name": "byIndex", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "[Label]", "isReadOnly": true, "accessibility": "public"]
    public override var byIndex: [Label] {
        get {
            
            return cuckoo_manager.getter("byIndex", superclassCall: super.byIndex)
            
        }
        
    }
    

    

    
    // ["name": "addLabel", "returnSignature": "", "fullyQualifiedName": "addLabel(_: Label)", "parameterSignature": "_ label: Label", "parameterSignatureWithoutNames": "label: Label", "inputTypes": "Label", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "label", "call": "label", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "label", type: "Label", range: CountableRange(1831..<1845), nameRange: CountableRange(0..<0))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func addLabel(_ label: Label)  {
        
            return cuckoo_manager.call("addLabel(_: Label)",
                parameters: (label),
                superclassCall:
                    
                    super.addLabel(label)
                    )
        
    }
    
    // ["name": "hasLabelFor", "returnSignature": " -> Bool", "fullyQualifiedName": "hasLabelFor(_: NLTag) -> Bool", "parameterSignature": "_ tag: NLTag", "parameterSignatureWithoutNames": "tag: NLTag", "inputTypes": "NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag", "call": "tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "tag", type: "NLTag", range: CountableRange(2622..<2634), nameRange: CountableRange(0..<0))], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func hasLabelFor(_ tag: NLTag)  -> Bool {
        
            return cuckoo_manager.call("hasLabelFor(_: NLTag) -> Bool",
                parameters: (tag),
                superclassCall:
                    
                    super.hasLabelFor(tag)
                    )
        
    }
    
    // ["name": "hasLabels", "returnSignature": " -> Bool", "fullyQualifiedName": "hasLabels() -> Bool", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func hasLabels()  -> Bool {
        
            return cuckoo_manager.call("hasLabels() -> Bool",
                parameters: (),
                superclassCall:
                    
                    super.hasLabels()
                    )
        
    }
    
    // ["name": "indexOf", "returnSignature": " -> Int", "fullyQualifiedName": "indexOf(label: Label) -> Int", "parameterSignature": "label: Label", "parameterSignatureWithoutNames": "label: Label", "inputTypes": "Label", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "label", "call": "label: label", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("label"), name: "label", type: "Label", range: CountableRange(2928..<2940), nameRange: CountableRange(2928..<2933))], "returnType": "Int", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func indexOf(label: Label)  -> Int {
        
            return cuckoo_manager.call("indexOf(label: Label) -> Int",
                parameters: (label),
                superclassCall:
                    
                    super.indexOf(label: label)
                    )
        
    }
    
    // ["name": "labelsInAnyOrderFor", "returnSignature": " -> [Label]", "fullyQualifiedName": "labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(3136..<3152), nameRange: CountableRange(3136..<3140))], "returnType": "[Label]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func labelsInAnyOrderFor(tags: Set<NLTag>)  -> [Label] {
        
            return cuckoo_manager.call("labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]",
                parameters: (tags),
                superclassCall:
                    
                    super.labelsInAnyOrderFor(tags: tags)
                    )
        
    }
    
    // ["name": "labelsFor", "returnSignature": " -> [Label]", "fullyQualifiedName": "labelsFor(tags: Set<NLTag>) -> [Label]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(3506..<3522), nameRange: CountableRange(3506..<3510))], "returnType": "[Label]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func labelsFor(tags: Set<NLTag>)  -> [Label] {
        
            return cuckoo_manager.call("labelsFor(tags: Set<NLTag>) -> [Label]",
                parameters: (tags),
                superclassCall:
                    
                    super.labelsFor(tags: tags)
                    )
        
    }
    
    // ["name": "splitBefore", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitBefore(tag: NLTag) -> [Labels]", "parameterSignature": "tag: NLTag", "parameterSignatureWithoutNames": "tag: NLTag", "inputTypes": "NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag", "call": "tag: tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(4011..<4021), nameRange: CountableRange(4011..<4014))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitBefore(tag: NLTag)  -> [Labels] {
        
            return cuckoo_manager.call("splitBefore(tag: NLTag) -> [Labels]",
                parameters: (tag),
                superclassCall:
                    
                    super.splitBefore(tag: tag)
                    )
        
    }
    
    // ["name": "splitBefore", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitBefore(tags: Set<NLTag>) -> [Labels]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(4777..<4793), nameRange: CountableRange(4777..<4781))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitBefore(tags: Set<NLTag>)  -> [Labels] {
        
            return cuckoo_manager.call("splitBefore(tags: Set<NLTag>) -> [Labels]",
                parameters: (tags),
                superclassCall:
                    
                    super.splitBefore(tags: tags)
                    )
        
    }
    
    // ["name": "splitAfter", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitAfter(tag: NLTag) -> [Labels]", "parameterSignature": "tag: NLTag", "parameterSignatureWithoutNames": "tag: NLTag", "inputTypes": "NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag", "call": "tag: tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(5644..<5654), nameRange: CountableRange(5644..<5647))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitAfter(tag: NLTag)  -> [Labels] {
        
            return cuckoo_manager.call("splitAfter(tag: NLTag) -> [Labels]",
                parameters: (tag),
                superclassCall:
                    
                    super.splitAfter(tag: tag)
                    )
        
    }
    
    // ["name": "splitAfter", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitAfter(tags: Set<NLTag>) -> [Labels]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(6450..<6466), nameRange: CountableRange(6450..<6454))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitAfter(tags: Set<NLTag>)  -> [Labels] {
        
            return cuckoo_manager.call("splitAfter(tags: Set<NLTag>) -> [Labels]",
                parameters: (tags),
                superclassCall:
                    
                    super.splitAfter(tags: tags)
                    )
        
    }
    
    // ["name": "findNearestLabelWith", "returnSignature": " throws -> [Label]?", "fullyQualifiedName": "findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?", "parameterSignature": "tag: NLTag, to index: Int", "parameterSignatureWithoutNames": "tag: NLTag, index: Int", "inputTypes": "NLTag, Int", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag, index", "call": "tag: tag, to: index", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(7353..<7363), nameRange: CountableRange(7353..<7356)), CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "index", type: "Int", range: CountableRange(7365..<7378), nameRange: CountableRange(7365..<7367))], "returnType": "Optional<[Label]>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubThrowingFunction"]
    public override func findNearestLabelWith(tag: NLTag, to index: Int)  throws -> [Label]? {
        
            return try cuckoo_manager.callThrows("findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?",
                parameters: (tag, index),
                superclassCall:
                    
                    super.findNearestLabelWith(tag: tag, to: index)
                    )
        
    }
    
    // ["name": "findNearestLabelWith", "returnSignature": " throws -> Label?", "fullyQualifiedName": "findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?", "parameterSignature": "tag: NLTag, before index: Int", "parameterSignatureWithoutNames": "tag: NLTag, index: Int", "inputTypes": "NLTag, Int", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag, index", "call": "tag: tag, before: index", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(8505..<8515), nameRange: CountableRange(8505..<8508)), CuckooGeneratorFramework.MethodParameter(label: Optional("before"), name: "index", type: "Int", range: CountableRange(8517..<8534), nameRange: CountableRange(8517..<8523))], "returnType": "Optional<Label>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubThrowingFunction"]
    public override func findNearestLabelWith(tag: NLTag, before index: Int)  throws -> Label? {
        
            return try cuckoo_manager.callThrows("findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?",
                parameters: (tag, index),
                superclassCall:
                    
                    super.findNearestLabelWith(tag: tag, before: index)
                    )
        
    }
    
    // ["name": "findNearestLabelWith", "returnSignature": " throws -> Label?", "fullyQualifiedName": "findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?", "parameterSignature": "tag: NLTag, after index: Int", "parameterSignatureWithoutNames": "tag: NLTag, index: Int", "inputTypes": "NLTag, Int", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag, index", "call": "tag: tag, after: index", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(9048..<9058), nameRange: CountableRange(9048..<9051)), CuckooGeneratorFramework.MethodParameter(label: Optional("after"), name: "index", type: "Int", range: CountableRange(9060..<9076), nameRange: CountableRange(9060..<9065))], "returnType": "Optional<Label>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubThrowingFunction"]
    public override func findNearestLabelWith(tag: NLTag, after index: Int)  throws -> Label? {
        
            return try cuckoo_manager.callThrows("findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?",
                parameters: (tag, index),
                superclassCall:
                    
                    super.findNearestLabelWith(tag: tag, after: index)
                    )
        
    }
    
    // ["name": "ifNotTaggedTagLabelAt", "returnSignature": "", "fullyQualifiedName": "ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)", "parameterSignature": "range: Range<String.Index>, asTag: NLTag", "parameterSignatureWithoutNames": "range: Range<String.Index>, asTag: NLTag", "inputTypes": "Range<String.Index>, NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "range, asTag", "call": "range: range, asTag: asTag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("range"), name: "range", type: "Range<String.Index>", range: CountableRange(9697..<9723), nameRange: CountableRange(9697..<9702)), CuckooGeneratorFramework.MethodParameter(label: Optional("asTag"), name: "asTag", type: "NLTag", range: CountableRange(9725..<9737), nameRange: CountableRange(9725..<9730))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)  {
        
            return cuckoo_manager.call("ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)",
                parameters: (range, asTag),
                superclassCall:
                    
                    super.ifNotTaggedTagLabelAt(range: range, asTag: asTag)
                    )
        
    }
    
    // ["name": "shortestDistance", "returnSignature": " -> Int", "fullyQualifiedName": "shortestDistance(between: NLTag, and: NLTag) -> Int", "parameterSignature": "between tag1: NLTag, and tag2: NLTag", "parameterSignatureWithoutNames": "tag1: NLTag, tag2: NLTag", "inputTypes": "NLTag, NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag1, tag2", "call": "between: tag1, and: tag2", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("between"), name: "tag1", type: "NLTag", range: CountableRange(10400..<10419), nameRange: CountableRange(10400..<10407)), CuckooGeneratorFramework.MethodParameter(label: Optional("and"), name: "tag2", type: "NLTag", range: CountableRange(10421..<10436), nameRange: CountableRange(10421..<10424))], "returnType": "Int", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func shortestDistance(between tag1: NLTag, and tag2: NLTag)  -> Int {
        
            return cuckoo_manager.call("shortestDistance(between: NLTag, and: NLTag) -> Int",
                parameters: (tag1, tag2),
                superclassCall:
                    
                    super.shortestDistance(between: tag1, and: tag2)
                    )
        
    }
    
    // ["name": "shortestDistance", "returnSignature": " -> Int?", "fullyQualifiedName": "shortestDistance(from: Label, toLabelWith: NLTag) -> Int?", "parameterSignature": "from: Label, toLabelWith tag: NLTag", "parameterSignatureWithoutNames": "from: Label, tag: NLTag", "inputTypes": "Label, NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "from, tag", "call": "from: from, toLabelWith: tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("from"), name: "from", type: "Label", range: CountableRange(11400..<11411), nameRange: CountableRange(11400..<11404)), CuckooGeneratorFramework.MethodParameter(label: Optional("toLabelWith"), name: "tag", type: "NLTag", range: CountableRange(11413..<11435), nameRange: CountableRange(11413..<11424))], "returnType": "Optional<Int>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func shortestDistance(from: Label, toLabelWith tag: NLTag)  -> Int? {
        
            return cuckoo_manager.call("shortestDistance(from: Label, toLabelWith: NLTag) -> Int?",
                parameters: (from, tag),
                superclassCall:
                    
                    super.shortestDistance(from: from, toLabelWith: tag)
                    )
        
    }
    
    // ["name": "next", "returnSignature": " -> Labels.Label?", "fullyQualifiedName": "next() -> Labels.Label?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<Labels.Label>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func next()  -> Labels.Label? {
        
            return cuckoo_manager.call("next() -> Labels.Label?",
                parameters: (),
                superclassCall:
                    
                    super.next()
                    )
        
    }
    

	struct __StubbingProxy_Labels: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var count: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, Int> {
	        return .init(manager: cuckoo_manager, name: "count")
	    }
	    
	    var isEmpty: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, Bool> {
	        return .init(manager: cuckoo_manager, name: "isEmpty")
	    }
	    
	    var byTag: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, [NLTag: [Label]]> {
	        return .init(manager: cuckoo_manager, name: "byTag")
	    }
	    
	    var byIndex: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, [Label]> {
	        return .init(manager: cuckoo_manager, name: "byIndex")
	    }
	    
	    
	    func addLabel<M1: Cuckoo.Matchable>(_ label: M1) -> Cuckoo.ClassStubNoReturnFunction<(Label)> where M1.MatchedType == Label {
	        let matchers: [Cuckoo.ParameterMatcher<(Label)>] = [wrap(matchable: label) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "addLabel(_: Label)", parameterMatchers: matchers))
	    }
	    
	    func hasLabelFor<M1: Cuckoo.Matchable>(_ tag: M1) -> Cuckoo.ClassStubFunction<(NLTag), Bool> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "hasLabelFor(_: NLTag) -> Bool", parameterMatchers: matchers))
	    }
	    
	    func hasLabels() -> Cuckoo.ClassStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "hasLabels() -> Bool", parameterMatchers: matchers))
	    }
	    
	    func indexOf<M1: Cuckoo.Matchable>(label: M1) -> Cuckoo.ClassStubFunction<(Label), Int> where M1.MatchedType == Label {
	        let matchers: [Cuckoo.ParameterMatcher<(Label)>] = [wrap(matchable: label) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "indexOf(label: Label) -> Int", parameterMatchers: matchers))
	    }
	    
	    func labelsInAnyOrderFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]", parameterMatchers: matchers))
	    }
	    
	    func labelsFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "labelsFor(tags: Set<NLTag>) -> [Label]", parameterMatchers: matchers))
	    }
	    
	    func splitBefore<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.ClassStubFunction<(NLTag), [Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitBefore(tag: NLTag) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func splitBefore<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitBefore(tags: Set<NLTag>) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func splitAfter<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.ClassStubFunction<(NLTag), [Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitAfter(tag: NLTag) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func splitAfter<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitAfter(tags: Set<NLTag>) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, to index: M2) -> Cuckoo.ClassStubThrowingFunction<(NLTag, Int), Optional<[Label]>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?", parameterMatchers: matchers))
	    }
	    
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, before index: M2) -> Cuckoo.ClassStubThrowingFunction<(NLTag, Int), Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?", parameterMatchers: matchers))
	    }
	    
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, after index: M2) -> Cuckoo.ClassStubThrowingFunction<(NLTag, Int), Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?", parameterMatchers: matchers))
	    }
	    
	    func ifNotTaggedTagLabelAt<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(range: M1, asTag: M2) -> Cuckoo.ClassStubNoReturnFunction<(Range<String.Index>, NLTag)> where M1.MatchedType == Range<String.Index>, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Range<String.Index>, NLTag)>] = [wrap(matchable: range) { $0.0 }, wrap(matchable: asTag) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)", parameterMatchers: matchers))
	    }
	    
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(between tag1: M1, and tag2: M2) -> Cuckoo.ClassStubFunction<(NLTag, NLTag), Int> where M1.MatchedType == NLTag, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, NLTag)>] = [wrap(matchable: tag1) { $0.0 }, wrap(matchable: tag2) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "shortestDistance(between: NLTag, and: NLTag) -> Int", parameterMatchers: matchers))
	    }
	    
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(from: M1, toLabelWith tag: M2) -> Cuckoo.ClassStubFunction<(Label, NLTag), Optional<Int>> where M1.MatchedType == Label, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Label, NLTag)>] = [wrap(matchable: from) { $0.0 }, wrap(matchable: tag) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "shortestDistance(from: Label, toLabelWith: NLTag) -> Int?", parameterMatchers: matchers))
	    }
	    
	    func next() -> Cuckoo.ClassStubFunction<(), Optional<Labels.Label>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "next() -> Labels.Label?", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_Labels: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var count: Cuckoo.VerifyReadOnlyProperty<Int> {
	        return .init(manager: cuckoo_manager, name: "count", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var isEmpty: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isEmpty", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var byTag: Cuckoo.VerifyReadOnlyProperty<[NLTag: [Label]]> {
	        return .init(manager: cuckoo_manager, name: "byTag", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var byIndex: Cuckoo.VerifyReadOnlyProperty<[Label]> {
	        return .init(manager: cuckoo_manager, name: "byIndex", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func addLabel<M1: Cuckoo.Matchable>(_ label: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Label {
	        let matchers: [Cuckoo.ParameterMatcher<(Label)>] = [wrap(matchable: label) { $0 }]
	        return cuckoo_manager.verify("addLabel(_: Label)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func hasLabelFor<M1: Cuckoo.Matchable>(_ tag: M1) -> Cuckoo.__DoNotUse<Bool> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return cuckoo_manager.verify("hasLabelFor(_: NLTag) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func hasLabels() -> Cuckoo.__DoNotUse<Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("hasLabels() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func indexOf<M1: Cuckoo.Matchable>(label: M1) -> Cuckoo.__DoNotUse<Int> where M1.MatchedType == Label {
	        let matchers: [Cuckoo.ParameterMatcher<(Label)>] = [wrap(matchable: label) { $0 }]
	        return cuckoo_manager.verify("indexOf(label: Label) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func labelsInAnyOrderFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func labelsFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("labelsFor(tags: Set<NLTag>) -> [Label]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitBefore<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return cuckoo_manager.verify("splitBefore(tag: NLTag) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitBefore<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("splitBefore(tags: Set<NLTag>) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitAfter<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return cuckoo_manager.verify("splitAfter(tag: NLTag) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitAfter<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("splitAfter(tags: Set<NLTag>) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, to index: M2) -> Cuckoo.__DoNotUse<Optional<[Label]>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return cuckoo_manager.verify("findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, before index: M2) -> Cuckoo.__DoNotUse<Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return cuckoo_manager.verify("findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, after index: M2) -> Cuckoo.__DoNotUse<Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return cuckoo_manager.verify("findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func ifNotTaggedTagLabelAt<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(range: M1, asTag: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Range<String.Index>, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Range<String.Index>, NLTag)>] = [wrap(matchable: range) { $0.0 }, wrap(matchable: asTag) { $0.1 }]
	        return cuckoo_manager.verify("ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(between tag1: M1, and tag2: M2) -> Cuckoo.__DoNotUse<Int> where M1.MatchedType == NLTag, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, NLTag)>] = [wrap(matchable: tag1) { $0.0 }, wrap(matchable: tag2) { $0.1 }]
	        return cuckoo_manager.verify("shortestDistance(between: NLTag, and: NLTag) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(from: M1, toLabelWith tag: M2) -> Cuckoo.__DoNotUse<Optional<Int>> where M1.MatchedType == Label, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Label, NLTag)>] = [wrap(matchable: from) { $0.0 }, wrap(matchable: tag) { $0.1 }]
	        return cuckoo_manager.verify("shortestDistance(from: Label, toLabelWith: NLTag) -> Int?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func next() -> Cuckoo.__DoNotUse<Optional<Labels.Label>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("next() -> Labels.Label?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class LabelsStub: Labels {
    
    public override var count: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        
    }
    
    public override var isEmpty: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    public override var byTag: [NLTag: [Label]] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([NLTag: [Label]]).self)
        }
        
    }
    
    public override var byIndex: [Label] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([Label]).self)
        }
        
    }
    

    

    
    public override func addLabel(_ label: Label)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func hasLabelFor(_ tag: NLTag)  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
    public override func hasLabels()  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
    public override func indexOf(label: Label)  -> Int {
        return DefaultValueRegistry.defaultValue(for: Int.self)
    }
    
    public override func labelsInAnyOrderFor(tags: Set<NLTag>)  -> [Label] {
        return DefaultValueRegistry.defaultValue(for: [Label].self)
    }
    
    public override func labelsFor(tags: Set<NLTag>)  -> [Label] {
        return DefaultValueRegistry.defaultValue(for: [Label].self)
    }
    
    public override func splitBefore(tag: NLTag)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func splitBefore(tags: Set<NLTag>)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func splitAfter(tag: NLTag)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func splitAfter(tags: Set<NLTag>)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func findNearestLabelWith(tag: NLTag, to index: Int)  throws -> [Label]? {
        return DefaultValueRegistry.defaultValue(for: Optional<[Label]>.self)
    }
    
    public override func findNearestLabelWith(tag: NLTag, before index: Int)  throws -> Label? {
        return DefaultValueRegistry.defaultValue(for: Optional<Label>.self)
    }
    
    public override func findNearestLabelWith(tag: NLTag, after index: Int)  throws -> Label? {
        return DefaultValueRegistry.defaultValue(for: Optional<Label>.self)
    }
    
    public override func ifNotTaggedTagLabelAt(range: Range<String.Index>, asTag: NLTag)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func shortestDistance(between tag1: NLTag, and tag2: NLTag)  -> Int {
        return DefaultValueRegistry.defaultValue(for: Int.self)
    }
    
    public override func shortestDistance(from: Label, toLabelWith tag: NLTag)  -> Int? {
        return DefaultValueRegistry.defaultValue(for: Optional<Int>.self)
    }
    
    public override func next()  -> Labels.Label? {
        return DefaultValueRegistry.defaultValue(for: Optional<Labels.Label>.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/DayOfWeek.swift
//
//  DayOfWeek.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockDayOfWeek: DayOfWeek, Cuckoo.ClassMock {
    typealias MocksType = DayOfWeek
    typealias Stubbing = __StubbingProxy_DayOfWeek
    typealias Verification = __VerificationProxy_DayOfWeek
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "fullDayName", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": "public"]
    public override var fullDayName: String {
        get {
            
            return cuckoo_manager.getter("fullDayName", superclassCall: super.fullDayName)
            
        }
        
    }
    
    // ["name": "intValue", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Int", "isReadOnly": true, "accessibility": "public"]
    public override var intValue: Int {
        get {
            
            return cuckoo_manager.getter("intValue", superclassCall: super.intValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_DayOfWeek: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var fullDayName: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockDayOfWeek, String> {
	        return .init(manager: cuckoo_manager, name: "fullDayName")
	    }
	    
	    var intValue: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockDayOfWeek, Int> {
	        return .init(manager: cuckoo_manager, name: "intValue")
	    }
	    
	    
	}

	struct __VerificationProxy_DayOfWeek: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var fullDayName: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "fullDayName", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var intValue: Cuckoo.VerifyReadOnlyProperty<Int> {
	        return .init(manager: cuckoo_manager, name: "intValue", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class DayOfWeekStub: DayOfWeek {
    
    public override var fullDayName: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    public override var intValue: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/HeartRateQuery.swift
//
//  HeartRateQuery.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import HealthKit

class MockHeartRateQuery: HeartRateQuery, Cuckoo.ClassMock {
    typealias MocksType = HeartRateQuery
    typealias Stubbing = __StubbingProxy_HeartRateQuery
    typealias Verification = __VerificationProxy_HeartRateQuery
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "finalOperation", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "QueryOperation?", "isReadOnly": false, "accessibility": "public"]
    public override var finalOperation: QueryOperation? {
        get {
            
            return cuckoo_manager.getter("finalOperation", superclassCall: super.finalOperation)
            
        }
        
        set {
            
            cuckoo_manager.setter("finalOperation", value: newValue, superclassCall: super.finalOperation = newValue)
            
        }
        
    }
    
    // ["name": "startDate", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date?", "isReadOnly": false, "accessibility": "public"]
    public override var startDate: Date? {
        get {
            
            return cuckoo_manager.getter("startDate", superclassCall: super.startDate)
            
        }
        
        set {
            
            cuckoo_manager.setter("startDate", value: newValue, superclassCall: super.startDate = newValue)
            
        }
        
    }
    
    // ["name": "endDate", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date?", "isReadOnly": false, "accessibility": "public"]
    public override var endDate: Date? {
        get {
            
            return cuckoo_manager.getter("endDate", superclassCall: super.endDate)
            
        }
        
        set {
            
            cuckoo_manager.setter("endDate", value: newValue, superclassCall: super.endDate = newValue)
            
        }
        
    }
    
    // ["name": "daysOfWeek", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Set<DayOfWeek>", "isReadOnly": false, "accessibility": "public"]
    public override var daysOfWeek: Set<DayOfWeek> {
        get {
            
            return cuckoo_manager.getter("daysOfWeek", superclassCall: super.daysOfWeek)
            
        }
        
        set {
            
            cuckoo_manager.setter("daysOfWeek", value: newValue, superclassCall: super.daysOfWeek = newValue)
            
        }
        
    }
    
    // ["name": "quantityRestrictions", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[QuantityRestriction]", "isReadOnly": false, "accessibility": "public"]
    public override var quantityRestrictions: [QuantityRestriction] {
        get {
            
            return cuckoo_manager.getter("quantityRestrictions", superclassCall: super.quantityRestrictions)
            
        }
        
        set {
            
            cuckoo_manager.setter("quantityRestrictions", value: newValue, superclassCall: super.quantityRestrictions = newValue)
            
        }
        
    }
    
    // ["name": "returnType", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "ReturnType?", "isReadOnly": false, "accessibility": "public"]
    public override var returnType: ReturnType? {
        get {
            
            return cuckoo_manager.getter("returnType", superclassCall: super.returnType)
            
        }
        
        set {
            
            cuckoo_manager.setter("returnType", value: newValue, superclassCall: super.returnType = newValue)
            
        }
        
    }
    
    // ["name": "mostRecentEntryOnly", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Bool", "isReadOnly": false, "accessibility": "public"]
    public override var mostRecentEntryOnly: Bool {
        get {
            
            return cuckoo_manager.getter("mostRecentEntryOnly", superclassCall: super.mostRecentEntryOnly)
            
        }
        
        set {
            
            cuckoo_manager.setter("mostRecentEntryOnly", value: newValue, superclassCall: super.mostRecentEntryOnly = newValue)
            
        }
        
    }
    

    

    
    // ["name": "runQuery", "returnSignature": "", "fullyQualifiedName": "runQuery(callback: @escaping (QueryResult?, Error?) -> ())", "parameterSignature": "callback: @escaping (QueryResult?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (QueryResult?, Error?) -> ()", "inputTypes": "(QueryResult?, Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (QueryResult?, Error?) -> ()", range: CountableRange(899..<947), nameRange: CountableRange(899..<907))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func runQuery(callback: @escaping (QueryResult?, Error?) -> ())  {
        
            return cuckoo_manager.call("runQuery(callback: @escaping (QueryResult?, Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.runQuery(callback: callback)
                    )
        
    }
    

	struct __StubbingProxy_HeartRateQuery: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var finalOperation: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "finalOperation")
	    }
	    
	    var startDate: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, Date?> {
	        return .init(manager: cuckoo_manager, name: "startDate")
	    }
	    
	    var endDate: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, Date?> {
	        return .init(manager: cuckoo_manager, name: "endDate")
	    }
	    
	    var daysOfWeek: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek")
	    }
	    
	    var quantityRestrictions: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, [QuantityRestriction]> {
	        return .init(manager: cuckoo_manager, name: "quantityRestrictions")
	    }
	    
	    var returnType: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, ReturnType?> {
	        return .init(manager: cuckoo_manager, name: "returnType")
	    }
	    
	    var mostRecentEntryOnly: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, Bool> {
	        return .init(manager: cuckoo_manager, name: "mostRecentEntryOnly")
	    }
	    
	    
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((QueryResult?, Error?) -> ())> where M1.MatchedType == (QueryResult?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((QueryResult?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuery.self, method: "runQuery(callback: @escaping (QueryResult?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_HeartRateQuery: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var finalOperation: Cuckoo.VerifyProperty<QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "finalOperation", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var startDate: Cuckoo.VerifyProperty<Date?> {
	        return .init(manager: cuckoo_manager, name: "startDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var endDate: Cuckoo.VerifyProperty<Date?> {
	        return .init(manager: cuckoo_manager, name: "endDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var daysOfWeek: Cuckoo.VerifyProperty<Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var quantityRestrictions: Cuckoo.VerifyProperty<[QuantityRestriction]> {
	        return .init(manager: cuckoo_manager, name: "quantityRestrictions", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var returnType: Cuckoo.VerifyProperty<ReturnType?> {
	        return .init(manager: cuckoo_manager, name: "returnType", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mostRecentEntryOnly: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "mostRecentEntryOnly", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (QueryResult?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((QueryResult?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("runQuery(callback: @escaping (QueryResult?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HeartRateQueryStub: HeartRateQuery {
    
    public override var finalOperation: QueryOperation? {
        get {
            return DefaultValueRegistry.defaultValue(for: (QueryOperation?).self)
        }
        
        set { }
        
    }
    
    public override var startDate: Date? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date?).self)
        }
        
        set { }
        
    }
    
    public override var endDate: Date? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date?).self)
        }
        
        set { }
        
    }
    
    public override var daysOfWeek: Set<DayOfWeek> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Set<DayOfWeek>).self)
        }
        
        set { }
        
    }
    
    public override var quantityRestrictions: [QuantityRestriction] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([QuantityRestriction]).self)
        }
        
        set { }
        
    }
    
    public override var returnType: ReturnType? {
        get {
            return DefaultValueRegistry.defaultValue(for: (ReturnType?).self)
        }
        
        set { }
        
    }
    
    public override var mostRecentEntryOnly: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    

    

    
    public override func runQuery(callback: @escaping (QueryResult?, Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/QuantityRestriction.swift
//
//  QuantityRestriction.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage

class MockQuantityRestriction: QuantityRestriction, Cuckoo.ClassMock {
    typealias MocksType = QuantityRestriction
    typealias Stubbing = __StubbingProxy_QuantityRestriction
    typealias Verification = __VerificationProxy_QuantityRestriction
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "attribute", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": "public"]
    public override var attribute: String {
        get {
            
            return cuckoo_manager.getter("attribute", superclassCall: super.attribute)
            
        }
        
    }
    
    // ["name": "comparison", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "ComparisonType", "isReadOnly": true, "accessibility": "public"]
    public override var comparison: ComparisonType {
        get {
            
            return cuckoo_manager.getter("comparison", superclassCall: super.comparison)
            
        }
        
    }
    
    // ["name": "value", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Double", "isReadOnly": true, "accessibility": "public"]
    public override var value: Double {
        get {
            
            return cuckoo_manager.getter("value", superclassCall: super.value)
            
        }
        
    }
    
    // ["name": "aggregationUnit", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Calendar.Component?", "isReadOnly": true, "accessibility": "public"]
    public override var aggregationUnit: Calendar.Component? {
        get {
            
            return cuckoo_manager.getter("aggregationUnit", superclassCall: super.aggregationUnit)
            
        }
        
    }
    
    // ["name": "operation", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "QueryOperation?", "isReadOnly": true, "accessibility": "public"]
    public override var operation: QueryOperation? {
        get {
            
            return cuckoo_manager.getter("operation", superclassCall: super.operation)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_QuantityRestriction: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var attribute: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, String> {
	        return .init(manager: cuckoo_manager, name: "attribute")
	    }
	    
	    var comparison: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, ComparisonType> {
	        return .init(manager: cuckoo_manager, name: "comparison")
	    }
	    
	    var value: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, Double> {
	        return .init(manager: cuckoo_manager, name: "value")
	    }
	    
	    var aggregationUnit: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, Calendar.Component?> {
	        return .init(manager: cuckoo_manager, name: "aggregationUnit")
	    }
	    
	    var operation: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuantityRestriction, QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "operation")
	    }
	    
	    
	}

	struct __VerificationProxy_QuantityRestriction: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var attribute: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "attribute", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var comparison: Cuckoo.VerifyReadOnlyProperty<ComparisonType> {
	        return .init(manager: cuckoo_manager, name: "comparison", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var value: Cuckoo.VerifyReadOnlyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "value", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var aggregationUnit: Cuckoo.VerifyReadOnlyProperty<Calendar.Component?> {
	        return .init(manager: cuckoo_manager, name: "aggregationUnit", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var operation: Cuckoo.VerifyReadOnlyProperty<QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "operation", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class QuantityRestrictionStub: QuantityRestriction {
    
    public override var attribute: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    public override var comparison: ComparisonType {
        get {
            return DefaultValueRegistry.defaultValue(for: (ComparisonType).self)
        }
        
    }
    
    public override var value: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    public override var aggregationUnit: Calendar.Component? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Calendar.Component?).self)
        }
        
    }
    
    public override var operation: QueryOperation? {
        get {
            return DefaultValueRegistry.defaultValue(for: (QueryOperation?).self)
        }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/Queriers/HeartRateQuerier.swift
//
//  HeartRateQuerier.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import HealthKit
import os

class MockHeartRateQuerier: HeartRateQuerier, Cuckoo.ClassMock {
    typealias MocksType = HeartRateQuerier
    typealias Stubbing = __StubbingProxy_HeartRateQuerier
    typealias Verification = __VerificationProxy_HeartRateQuerier
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "getHeartRates", "returnSignature": "", "fullyQualifiedName": "getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())", "parameterSignature": "predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->()", "parameterSignatureWithoutNames": "predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->()", "inputTypes": "NSPredicate, (Array<HKQuantitySample>?, Error?)->()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "predicate, callback", "call": "predicate: predicate, callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("predicate"), name: "predicate", type: "NSPredicate", range: CountableRange(614..<636), nameRange: CountableRange(614..<623)), CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Array<HKQuantitySample>?, Error?)->()", range: CountableRange(638..<695), nameRange: CountableRange(638..<646))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())  {
        
            return cuckoo_manager.call("getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())",
                parameters: (predicate, callback),
                superclassCall:
                    
                    super.getHeartRates(predicate: predicate, callback: callback)
                    )
        
    }
    
    // ["name": "getStatisticsFromHeartRates", "returnSignature": "", "fullyQualifiedName": "getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())", "parameterSignature": "predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->()", "parameterSignatureWithoutNames": "predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->()", "inputTypes": "NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "predicate, statsOptions, callback", "call": "predicate: predicate, statsOptions: statsOptions, callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("predicate"), name: "predicate", type: "NSPredicate", range: CountableRange(992..<1014), nameRange: CountableRange(992..<1001)), CuckooGeneratorFramework.MethodParameter(label: Optional("statsOptions"), name: "statsOptions", type: "HKStatisticsOptions", range: CountableRange(1016..<1049), nameRange: CountableRange(1016..<1028)), CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (HKStatistics?, Error?)->()", range: CountableRange(1051..<1097), nameRange: CountableRange(1051..<1059))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())  {
        
            return cuckoo_manager.call("getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())",
                parameters: (predicate, statsOptions, callback),
                superclassCall:
                    
                    super.getStatisticsFromHeartRates(predicate: predicate, statsOptions: statsOptions, callback: callback)
                    )
        
    }
    
    // ["name": "getAuthorization", "returnSignature": "", "fullyQualifiedName": "getAuthorization(callback: @escaping (Error?) -> ())", "parameterSignature": "callback: @escaping (Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (Error?) -> ()", "inputTypes": "(Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Error?) -> ()", range: CountableRange(1403..<1437), nameRange: CountableRange(1403..<1411))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func getAuthorization(callback: @escaping (Error?) -> ())  {
        
            return cuckoo_manager.call("getAuthorization(callback: @escaping (Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.getAuthorization(callback: callback)
                    )
        
    }
    

	struct __StubbingProxy_HeartRateQuerier: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func getHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(predicate: M1, callback: M2) -> Cuckoo.ClassStubNoReturnFunction<(NSPredicate, (Array<HKQuantitySample>?, Error?)->())> where M1.MatchedType == NSPredicate, M2.MatchedType == (Array<HKQuantitySample>?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, (Array<HKQuantitySample>?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuerier.self, method: "getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())", parameterMatchers: matchers))
	    }
	    
	    func getStatisticsFromHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(predicate: M1, statsOptions: M2, callback: M3) -> Cuckoo.ClassStubNoReturnFunction<(NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->())> where M1.MatchedType == NSPredicate, M2.MatchedType == HKStatisticsOptions, M3.MatchedType == (HKStatistics?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: statsOptions) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuerier.self, method: "getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())", parameterMatchers: matchers))
	    }
	    
	    func getAuthorization<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((Error?) -> ())> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuerier.self, method: "getAuthorization(callback: @escaping (Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_HeartRateQuerier: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func getHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(predicate: M1, callback: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == NSPredicate, M2.MatchedType == (Array<HKQuantitySample>?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, (Array<HKQuantitySample>?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getStatisticsFromHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(predicate: M1, statsOptions: M2, callback: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == NSPredicate, M2.MatchedType == HKStatisticsOptions, M3.MatchedType == (HKStatistics?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: statsOptions) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return cuckoo_manager.verify("getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getAuthorization<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("getAuthorization(callback: @escaping (Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HeartRateQuerierStub: HeartRateQuerier {
    

    

    
    public override func getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func getAuthorization(callback: @escaping (Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
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
@testable import DataIntegration

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


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/Query.swift
//
//  Query.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockQuery: Query, Cuckoo.ProtocolMock {
    typealias MocksType = Query
    typealias Stubbing = __StubbingProxy_Query
    typealias Verification = __VerificationProxy_Query
    let cuckoo_manager = Cuckoo.MockManager(hasParent: false)

    
    // ["name": "finalOperation", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "QueryOperation?", "isReadOnly": false, "accessibility": ""]
     var finalOperation: QueryOperation? {
        get {
            
            return cuckoo_manager.getter("finalOperation", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("finalOperation", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "startDate", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date?", "isReadOnly": false, "accessibility": ""]
     var startDate: Date? {
        get {
            
            return cuckoo_manager.getter("startDate", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("startDate", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "endDate", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "Date?", "isReadOnly": false, "accessibility": ""]
     var endDate: Date? {
        get {
            
            return cuckoo_manager.getter("endDate", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("endDate", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "daysOfWeek", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "Set<DayOfWeek>", "isReadOnly": false, "accessibility": ""]
     var daysOfWeek: Set<DayOfWeek> {
        get {
            
            return cuckoo_manager.getter("daysOfWeek", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("daysOfWeek", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "quantityRestrictions", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "[QuantityRestriction]", "isReadOnly": false, "accessibility": ""]
     var quantityRestrictions: [QuantityRestriction] {
        get {
            
            return cuckoo_manager.getter("quantityRestrictions", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("quantityRestrictions", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "returnType", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "ReturnType?", "isReadOnly": false, "accessibility": ""]
     var returnType: ReturnType? {
        get {
            
            return cuckoo_manager.getter("returnType", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("returnType", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    
    // ["name": "mostRecentEntryOnly", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "Bool", "isReadOnly": false, "accessibility": ""]
     var mostRecentEntryOnly: Bool {
        get {
            
            return cuckoo_manager.getter("mostRecentEntryOnly", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
        set {
            
            cuckoo_manager.setter("mostRecentEntryOnly", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    

    

    
    // ["name": "runQuery", "returnSignature": " throws", "fullyQualifiedName": "runQuery(callback: @escaping (QueryResult?, Error?) -> ()) throws", "parameterSignature": "callback: @escaping (QueryResult?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (QueryResult?, Error?) -> ()", "inputTypes": "(QueryResult?, Error?) -> ()", "isThrowing": true, "isInit": false, "isOverriding": false, "hasClosureParams": true, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (QueryResult?, Error?) -> ()", range: CountableRange(766..<814), nameRange: CountableRange(766..<774))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnThrowingFunction"]
     func runQuery(callback: @escaping (QueryResult?, Error?) -> ())  throws {
        
            return try cuckoo_manager.callThrows("runQuery(callback: @escaping (QueryResult?, Error?) -> ()) throws",
                parameters: (callback),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    )
        
    }
    

	struct __StubbingProxy_Query: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var finalOperation: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "finalOperation")
	    }
	    
	    var startDate: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, Date?> {
	        return .init(manager: cuckoo_manager, name: "startDate")
	    }
	    
	    var endDate: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, Date?> {
	        return .init(manager: cuckoo_manager, name: "endDate")
	    }
	    
	    var daysOfWeek: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek")
	    }
	    
	    var quantityRestrictions: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, [QuantityRestriction]> {
	        return .init(manager: cuckoo_manager, name: "quantityRestrictions")
	    }
	    
	    var returnType: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, ReturnType?> {
	        return .init(manager: cuckoo_manager, name: "returnType")
	    }
	    
	    var mostRecentEntryOnly: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, Bool> {
	        return .init(manager: cuckoo_manager, name: "mostRecentEntryOnly")
	    }
	    
	    
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<((QueryResult?, Error?) -> ())> where M1.MatchedType == (QueryResult?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((QueryResult?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockQuery.self, method: "runQuery(callback: @escaping (QueryResult?, Error?) -> ()) throws", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_Query: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var finalOperation: Cuckoo.VerifyProperty<QueryOperation?> {
	        return .init(manager: cuckoo_manager, name: "finalOperation", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var startDate: Cuckoo.VerifyProperty<Date?> {
	        return .init(manager: cuckoo_manager, name: "startDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var endDate: Cuckoo.VerifyProperty<Date?> {
	        return .init(manager: cuckoo_manager, name: "endDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var daysOfWeek: Cuckoo.VerifyProperty<Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var quantityRestrictions: Cuckoo.VerifyProperty<[QuantityRestriction]> {
	        return .init(manager: cuckoo_manager, name: "quantityRestrictions", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var returnType: Cuckoo.VerifyProperty<ReturnType?> {
	        return .init(manager: cuckoo_manager, name: "returnType", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mostRecentEntryOnly: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "mostRecentEntryOnly", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (QueryResult?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((QueryResult?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("runQuery(callback: @escaping (QueryResult?, Error?) -> ()) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class QueryStub: Query {
    
     var finalOperation: QueryOperation? {
        get {
            return DefaultValueRegistry.defaultValue(for: (QueryOperation?).self)
        }
        
        set { }
        
    }
    
     var startDate: Date? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date?).self)
        }
        
        set { }
        
    }
    
     var endDate: Date? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date?).self)
        }
        
        set { }
        
    }
    
     var daysOfWeek: Set<DayOfWeek> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Set<DayOfWeek>).self)
        }
        
        set { }
        
    }
    
     var quantityRestrictions: [QuantityRestriction] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([QuantityRestriction]).self)
        }
        
        set { }
        
    }
    
     var returnType: ReturnType? {
        get {
            return DefaultValueRegistry.defaultValue(for: (ReturnType?).self)
        }
        
        set { }
        
    }
    
     var mostRecentEntryOnly: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    

    

    
     func runQuery(callback: @escaping (QueryResult?, Error?) -> ())  throws {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/QueryFactory.swift
//
//  QueryFactory.swift
//  DataIntegration
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockQueryFactory: QueryFactory, Cuckoo.ClassMock {
    typealias MocksType = QueryFactory
    typealias Stubbing = __StubbingProxy_QueryFactory
    typealias Verification = __VerificationProxy_QueryFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "heartRateQuery", "returnSignature": " -> HeartRateQuery", "fullyQualifiedName": "heartRateQuery() -> HeartRateQuery", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "HeartRateQuery", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func heartRateQuery()  -> HeartRateQuery {
        
            return cuckoo_manager.call("heartRateQuery() -> HeartRateQuery",
                parameters: (),
                superclassCall:
                    
                    super.heartRateQuery()
                    )
        
    }
    

	struct __StubbingProxy_QueryFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func heartRateQuery() -> Cuckoo.ClassStubFunction<(), HeartRateQuery> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockQueryFactory.self, method: "heartRateQuery() -> HeartRateQuery", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_QueryFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func heartRateQuery() -> Cuckoo.__DoNotUse<HeartRateQuery> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("heartRateQuery() -> HeartRateQuery", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class QueryFactoryStub: QueryFactory {
    

    

    
    public override func heartRateQuery()  -> HeartRateQuery {
        return DefaultValueRegistry.defaultValue(for: HeartRateQuery.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/QueryOperation.swift
//
//  Operations.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage

class MockQueryOperation: QueryOperation, Cuckoo.ClassMock {
    typealias MocksType = QueryOperation
    typealias Stubbing = __StubbingProxy_QueryOperation
    typealias Verification = __VerificationProxy_QueryOperation
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "kind", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Kind", "isReadOnly": true, "accessibility": "public"]
    public override var kind: Kind {
        get {
            
            return cuckoo_manager.getter("kind", superclassCall: super.kind)
            
        }
        
    }
    
    // ["name": "aggregationUnit", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Calendar.Component?", "isReadOnly": false, "accessibility": "public"]
    public override var aggregationUnit: Calendar.Component? {
        get {
            
            return cuckoo_manager.getter("aggregationUnit", superclassCall: super.aggregationUnit)
            
        }
        
        set {
            
            cuckoo_manager.setter("aggregationUnit", value: newValue, superclassCall: super.aggregationUnit = newValue)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_QueryOperation: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var kind: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQueryOperation, Kind> {
	        return .init(manager: cuckoo_manager, name: "kind")
	    }
	    
	    var aggregationUnit: Cuckoo.ClassToBeStubbedProperty<MockQueryOperation, Calendar.Component?> {
	        return .init(manager: cuckoo_manager, name: "aggregationUnit")
	    }
	    
	    
	}

	struct __VerificationProxy_QueryOperation: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var kind: Cuckoo.VerifyReadOnlyProperty<Kind> {
	        return .init(manager: cuckoo_manager, name: "kind", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var aggregationUnit: Cuckoo.VerifyProperty<Calendar.Component?> {
	        return .init(manager: cuckoo_manager, name: "aggregationUnit", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class QueryOperationStub: QueryOperation {
    
    public override var kind: Kind {
        get {
            return DefaultValueRegistry.defaultValue(for: (Kind).self)
        }
        
    }
    
    public override var aggregationUnit: Calendar.Component? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Calendar.Component?).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/QueryResult.swift
//
//  Result.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockQueryResult: QueryResult, Cuckoo.ClassMock {
    typealias MocksType = QueryResult
    typealias Stubbing = __StubbingProxy_QueryResult
    typealias Verification = __VerificationProxy_QueryResult
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "finalAnswer", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Any", "isReadOnly": true, "accessibility": "public"]
    public override var finalAnswer: Any {
        get {
            
            return cuckoo_manager.getter("finalAnswer", superclassCall: super.finalAnswer)
            
        }
        
    }
    
    // ["name": "returnType", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "ReturnType", "isReadOnly": true, "accessibility": "public"]
    public override var returnType: ReturnType {
        get {
            
            return cuckoo_manager.getter("returnType", superclassCall: super.returnType)
            
        }
        
    }
    

    

    

	struct __StubbingProxy_QueryResult: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var finalAnswer: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQueryResult, Any> {
	        return .init(manager: cuckoo_manager, name: "finalAnswer")
	    }
	    
	    var returnType: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQueryResult, ReturnType> {
	        return .init(manager: cuckoo_manager, name: "returnType")
	    }
	    
	    
	}

	struct __VerificationProxy_QueryResult: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var finalAnswer: Cuckoo.VerifyReadOnlyProperty<Any> {
	        return .init(manager: cuckoo_manager, name: "finalAnswer", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var returnType: Cuckoo.VerifyReadOnlyProperty<ReturnType> {
	        return .init(manager: cuckoo_manager, name: "returnType", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class QueryResultStub: QueryResult {
    
    public override var finalAnswer: Any {
        get {
            return DefaultValueRegistry.defaultValue(for: (Any).self)
        }
        
    }
    
    public override var returnType: ReturnType {
        get {
            return DefaultValueRegistry.defaultValue(for: (ReturnType).self)
        }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/ReturnType.swift
//
//  ReturnType.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

// MARK: - Mocks generated from file: DataIntegration/Questions/Question.swift
//
//  Question.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage
import os

class MockQuestion: Question, Cuckoo.ClassMock {
    typealias MocksType = Question
    typealias Stubbing = __StubbingProxy_Question
    typealias Verification = __VerificationProxy_Question
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "questionText", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": ""]
     override var questionText: String {
        get {
            
            return cuckoo_manager.getter("questionText", superclassCall: super.questionText)
            
        }
        
    }
    

    

    
    // ["name": "parse", "returnSignature": "", "fullyQualifiedName": "parse(callback: (Error?) -> ())", "parameterSignature": "callback: (Error?) -> ()", "parameterSignatureWithoutNames": "callback: (Error?) -> ()", "inputTypes": "(Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "(Error?) -> ()", range: CountableRange(791..<815), nameRange: CountableRange(791..<799))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func parse(callback: (Error?) -> ())  {
        	return withoutActuallyEscaping(callback, do: { (callback) in

            return cuckoo_manager.call("parse(callback: (Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.parse(callback: callback)
                    )
        	})

    }
    
    // ["name": "answer", "returnSignature": "", "fullyQualifiedName": "answer(callback: @escaping (Answer?, Error?) -> ())", "parameterSignature": "callback: @escaping (Answer?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (Answer?, Error?) -> ()", "inputTypes": "(Answer?, Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Answer?, Error?) -> ()", range: CountableRange(3257..<3300), nameRange: CountableRange(3257..<3265))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func answer(callback: @escaping (Answer?, Error?) -> ())  {
        
            return cuckoo_manager.call("answer(callback: @escaping (Answer?, Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.answer(callback: callback)
                    )
        
    }
    

	struct __StubbingProxy_Question: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var questionText: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockQuestion, String> {
	        return .init(manager: cuckoo_manager, name: "questionText")
	    }
	    
	    
	    func parse<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((Error?) -> ())> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockQuestion.self, method: "parse(callback: (Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func answer<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((Answer?, Error?) -> ())> where M1.MatchedType == (Answer?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Answer?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockQuestion.self, method: "answer(callback: @escaping (Answer?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_Question: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var questionText: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "questionText", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func parse<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("parse(callback: (Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func answer<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (Answer?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Answer?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("answer(callback: @escaping (Answer?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class QuestionStub: Question {
    
     override var questionText: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    

    

    
    public override func parse(callback: (Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func answer(callback: @escaping (Answer?, Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
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
@testable import DataIntegration

import Foundation

class MockQuestionFactory: QuestionFactory, Cuckoo.ClassMock {
    typealias MocksType = QuestionFactory
    typealias Stubbing = __StubbingProxy_QuestionFactory
    typealias Verification = __VerificationProxy_QuestionFactory
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "question", "returnSignature": " -> Question", "fullyQualifiedName": "question(text: String) -> Question", "parameterSignature": "text: String", "parameterSignatureWithoutNames": "text: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "text", "call": "text: text", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("text"), name: "text", type: "String", range: CountableRange(225..<237), nameRange: CountableRange(225..<229))], "returnType": "Question", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
     override func question(text: String)  -> Question {
        
            return cuckoo_manager.call("question(text: String) -> Question",
                parameters: (text),
                superclassCall:
                    
                    super.question(text: text)
                    )
        
    }
    
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
	    
	    
	    func question<M1: Cuckoo.Matchable>(text: M1) -> Cuckoo.ClassStubFunction<(String), Question> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockQuestionFactory.self, method: "question(text: String) -> Question", parameterMatchers: matchers))
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
	    func question<M1: Cuckoo.Matchable>(text: M1) -> Cuckoo.__DoNotUse<Question> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("question(text: String) -> Question", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    

    

    
     override func question(text: String)  -> Question {
        return DefaultValueRegistry.defaultValue(for: Question.self)
    }
    
     override func answer()  -> Answer {
        return DefaultValueRegistry.defaultValue(for: Answer.self)
    }
    
     override func labels()  -> Labels {
        return DefaultValueRegistry.defaultValue(for: Labels.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Questions/Tags.swift
//
//  Tags.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage

class MockTags: Tags, Cuckoo.ClassMock {
    typealias MocksType = Tags
    typealias Stubbing = __StubbingProxy_Tags
    typealias Verification = __VerificationProxy_Tags
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    

	struct __StubbingProxy_Tags: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	}

	struct __VerificationProxy_Tags: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	}

}

 class TagsStub: Tags {
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/ActivitySource.swift
//
//  ActivitySource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockActivitySource: ActivitySource, Cuckoo.ClassMock {
    typealias MocksType = ActivitySource
    typealias Stubbing = __StubbingProxy_ActivitySource
    typealias Verification = __VerificationProxy_ActivitySource
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "requiredFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var requiredFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("requiredFields", superclassCall: super.requiredFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("requiredFields", value: newValue, superclassCall: super.requiredFields = newValue)
            
        }
        
    }
    
    // ["name": "optionalFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var optionalFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("optionalFields", superclassCall: super.optionalFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("optionalFields", value: newValue, superclassCall: super.optionalFields = newValue)
            
        }
        
    }
    
    // ["name": "mappedColumnNames", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: String]", "isReadOnly": false, "accessibility": "public"]
    public override var mappedColumnNames: [String: String] {
        get {
            
            return cuckoo_manager.getter("mappedColumnNames", superclassCall: super.mappedColumnNames)
            
        }
        
        set {
            
            cuckoo_manager.setter("mappedColumnNames", value: newValue, superclassCall: super.mappedColumnNames = newValue)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1464..<1483), nameRange: CountableRange(1464..<1466))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_ActivitySource: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockActivitySource, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var requiredFields: Cuckoo.ClassToBeStubbedProperty<MockActivitySource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields")
	    }
	    
	    var optionalFields: Cuckoo.ClassToBeStubbedProperty<MockActivitySource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields")
	    }
	    
	    var mappedColumnNames: Cuckoo.ClassToBeStubbedProperty<MockActivitySource, [String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockActivitySource.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_ActivitySource: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var requiredFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var optionalFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mappedColumnNames: Cuckoo.VerifyProperty<[String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class ActivitySourceStub: ActivitySource {
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var requiredFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var optionalFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var mappedColumnNames: [String: String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: String]).self)
        }
        
        set { }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/HeartRateSource.swift
//
//  HeartRateSource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockHeartRateSource: HeartRateSource, Cuckoo.ClassMock {
    typealias MocksType = HeartRateSource
    typealias Stubbing = __StubbingProxy_HeartRateSource
    typealias Verification = __VerificationProxy_HeartRateSource
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "requiredFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var requiredFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("requiredFields", superclassCall: super.requiredFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("requiredFields", value: newValue, superclassCall: super.requiredFields = newValue)
            
        }
        
    }
    
    // ["name": "optionalFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var optionalFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("optionalFields", superclassCall: super.optionalFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("optionalFields", value: newValue, superclassCall: super.optionalFields = newValue)
            
        }
        
    }
    
    // ["name": "mappedColumnNames", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: String]", "isReadOnly": false, "accessibility": "public"]
    public override var mappedColumnNames: [String: String] {
        get {
            
            return cuckoo_manager.getter("mappedColumnNames", superclassCall: super.mappedColumnNames)
            
        }
        
        set {
            
            cuckoo_manager.setter("mappedColumnNames", value: newValue, superclassCall: super.mappedColumnNames = newValue)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1464..<1483), nameRange: CountableRange(1464..<1466))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_HeartRateSource: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockHeartRateSource, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var requiredFields: Cuckoo.ClassToBeStubbedProperty<MockHeartRateSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields")
	    }
	    
	    var optionalFields: Cuckoo.ClassToBeStubbedProperty<MockHeartRateSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields")
	    }
	    
	    var mappedColumnNames: Cuckoo.ClassToBeStubbedProperty<MockHeartRateSource, [String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateSource.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_HeartRateSource: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var requiredFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var optionalFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mappedColumnNames: Cuckoo.VerifyProperty<[String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HeartRateSourceStub: HeartRateSource {
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var requiredFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var optionalFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var mappedColumnNames: [String: String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: String]).self)
        }
        
        set { }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/MedicationSource.swift
//
//  MedicationsSource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockMedicationSource: MedicationSource, Cuckoo.ClassMock {
    typealias MocksType = MedicationSource
    typealias Stubbing = __StubbingProxy_MedicationSource
    typealias Verification = __VerificationProxy_MedicationSource
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "requiredFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var requiredFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("requiredFields", superclassCall: super.requiredFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("requiredFields", value: newValue, superclassCall: super.requiredFields = newValue)
            
        }
        
    }
    
    // ["name": "optionalFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var optionalFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("optionalFields", superclassCall: super.optionalFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("optionalFields", value: newValue, superclassCall: super.optionalFields = newValue)
            
        }
        
    }
    
    // ["name": "mappedColumnNames", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: String]", "isReadOnly": false, "accessibility": "public"]
    public override var mappedColumnNames: [String: String] {
        get {
            
            return cuckoo_manager.getter("mappedColumnNames", superclassCall: super.mappedColumnNames)
            
        }
        
        set {
            
            cuckoo_manager.setter("mappedColumnNames", value: newValue, superclassCall: super.mappedColumnNames = newValue)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1464..<1483), nameRange: CountableRange(1464..<1466))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_MedicationSource: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockMedicationSource, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var requiredFields: Cuckoo.ClassToBeStubbedProperty<MockMedicationSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields")
	    }
	    
	    var optionalFields: Cuckoo.ClassToBeStubbedProperty<MockMedicationSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields")
	    }
	    
	    var mappedColumnNames: Cuckoo.ClassToBeStubbedProperty<MockMedicationSource, [String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMedicationSource.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_MedicationSource: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var requiredFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var optionalFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mappedColumnNames: Cuckoo.VerifyProperty<[String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class MedicationSourceStub: MedicationSource {
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var requiredFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var optionalFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var mappedColumnNames: [String: String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: String]).self)
        }
        
        set { }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/MoodSource.swift
//
//  MoodSource.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockMoodSource: MoodSource, Cuckoo.ClassMock {
    typealias MocksType = MoodSource
    typealias Stubbing = __StubbingProxy_MoodSource
    typealias Verification = __VerificationProxy_MoodSource
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "requiredFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var requiredFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("requiredFields", superclassCall: super.requiredFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("requiredFields", value: newValue, superclassCall: super.requiredFields = newValue)
            
        }
        
    }
    
    // ["name": "optionalFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var optionalFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("optionalFields", superclassCall: super.optionalFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("optionalFields", value: newValue, superclassCall: super.optionalFields = newValue)
            
        }
        
    }
    
    // ["name": "mappedColumnNames", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: String]", "isReadOnly": false, "accessibility": "public"]
    public override var mappedColumnNames: [String: String] {
        get {
            
            return cuckoo_manager.getter("mappedColumnNames", superclassCall: super.mappedColumnNames)
            
        }
        
        set {
            
            cuckoo_manager.setter("mappedColumnNames", value: newValue, superclassCall: super.mappedColumnNames = newValue)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1464..<1483), nameRange: CountableRange(1464..<1466))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_MoodSource: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockMoodSource, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var requiredFields: Cuckoo.ClassToBeStubbedProperty<MockMoodSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields")
	    }
	    
	    var optionalFields: Cuckoo.ClassToBeStubbedProperty<MockMoodSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields")
	    }
	    
	    var mappedColumnNames: Cuckoo.ClassToBeStubbedProperty<MockMoodSource, [String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMoodSource.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_MoodSource: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var requiredFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var optionalFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mappedColumnNames: Cuckoo.VerifyProperty<[String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class MoodSourceStub: MoodSource {
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var requiredFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var optionalFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var mappedColumnNames: [String: String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: String]).self)
        }
        
        set { }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/Source.swift
//
//  Source.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import os

class MockSource: Source, Cuckoo.ClassMock {
    typealias MocksType = Source
    typealias Stubbing = __StubbingProxy_Source
    typealias Verification = __VerificationProxy_Source
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": "public"]
    public override var name: String {
        get {
            
            return cuckoo_manager.getter("name", superclassCall: super.name)
            
        }
        
        set {
            
            cuckoo_manager.setter("name", value: newValue, superclassCall: super.name = newValue)
            
        }
        
    }
    
    // ["name": "requiredFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var requiredFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("requiredFields", superclassCall: super.requiredFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("requiredFields", value: newValue, superclassCall: super.requiredFields = newValue)
            
        }
        
    }
    
    // ["name": "optionalFields", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Array<SourceField>", "isReadOnly": false, "accessibility": "public"]
    public override var optionalFields: Array<SourceField> {
        get {
            
            return cuckoo_manager.getter("optionalFields", superclassCall: super.optionalFields)
            
        }
        
        set {
            
            cuckoo_manager.setter("optionalFields", value: newValue, superclassCall: super.optionalFields = newValue)
            
        }
        
    }
    
    // ["name": "mappedColumnNames", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: String]", "isReadOnly": false, "accessibility": "public"]
    public override var mappedColumnNames: [String: String] {
        get {
            
            return cuckoo_manager.getter("mappedColumnNames", superclassCall: super.mappedColumnNames)
            
        }
        
        set {
            
            cuckoo_manager.setter("mappedColumnNames", value: newValue, superclassCall: super.mappedColumnNames = newValue)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1464..<1483), nameRange: CountableRange(1464..<1466))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_Source: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var name: Cuckoo.ClassToBeStubbedProperty<MockSource, String> {
	        return .init(manager: cuckoo_manager, name: "name")
	    }
	    
	    var requiredFields: Cuckoo.ClassToBeStubbedProperty<MockSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields")
	    }
	    
	    var optionalFields: Cuckoo.ClassToBeStubbedProperty<MockSource, Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields")
	    }
	    
	    var mappedColumnNames: Cuckoo.ClassToBeStubbedProperty<MockSource, [String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSource.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_Source: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var name: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var requiredFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "requiredFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var optionalFields: Cuckoo.VerifyProperty<Array<SourceField>> {
	        return .init(manager: cuckoo_manager, name: "optionalFields", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var mappedColumnNames: Cuckoo.VerifyProperty<[String: String]> {
	        return .init(manager: cuckoo_manager, name: "mappedColumnNames", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class SourceStub: Source {
    
    public override var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
    public override var requiredFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var optionalFields: Array<SourceField> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Array<SourceField>).self)
        }
        
        set { }
        
    }
    
    public override var mappedColumnNames: [String: String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: String]).self)
        }
        
        set { }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Sources/SourceField.swift
//
//  SourceField.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import os

class MockSourceField: SourceField, Cuckoo.ClassMock {
    typealias MocksType = SourceField
    typealias Stubbing = __StubbingProxy_SourceField
    typealias Verification = __VerificationProxy_SourceField
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "fieldName", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": true, "accessibility": "public"]
    public override var fieldName: String {
        get {
            
            return cuckoo_manager.getter("fieldName", superclassCall: super.fieldName)
            
        }
        
    }
    
    // ["name": "fieldType", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "FieldType", "isReadOnly": true, "accessibility": "public"]
    public override var fieldType: FieldType {
        get {
            
            return cuckoo_manager.getter("fieldType", superclassCall: super.fieldType)
            
        }
        
    }
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1108..<1127), nameRange: CountableRange(1108..<1110))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func encode(to encoder: Encoder)  {
        
            return cuckoo_manager.call("encode(to: Encoder)",
                parameters: (encoder),
                superclassCall:
                    
                    super.encode(to: encoder)
                    )
        
    }
    

	struct __StubbingProxy_SourceField: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var fieldName: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSourceField, String> {
	        return .init(manager: cuckoo_manager, name: "fieldName")
	    }
	    
	    var fieldType: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSourceField, FieldType> {
	        return .init(manager: cuckoo_manager, name: "fieldType")
	    }
	    
	    
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.ClassStubNoReturnFunction<(Encoder)> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSourceField.self, method: "encode(to: Encoder)", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_SourceField: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var fieldName: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "fieldName", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var fieldType: Cuckoo.VerifyReadOnlyProperty<FieldType> {
	        return .init(manager: cuckoo_manager, name: "fieldType", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func encode<M1: Cuckoo.Matchable>(to encoder: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Encoder {
	        let matchers: [Cuckoo.ParameterMatcher<(Encoder)>] = [wrap(matchable: encoder) { $0 }]
	        return cuckoo_manager.verify("encode(to: Encoder)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class SourceFieldStub: SourceField {
    
    public override var fieldName: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    public override var fieldType: FieldType {
        get {
            return DefaultValueRegistry.defaultValue(for: (FieldType).self)
        }
        
    }
    

    

    
    public override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Storage/CodableStorage.swift
//
//  CodableStorage.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockCodableStorage: CodableStorage, Cuckoo.ClassMock {
    typealias MocksType = CodableStorage
    typealias Stubbing = __StubbingProxy_CodableStorage
    typealias Verification = __VerificationProxy_CodableStorage
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    

	struct __StubbingProxy_CodableStorage: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	}

	struct __VerificationProxy_CodableStorage: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	}

}

 class CodableStorageStub: CodableStorage {
    

    

    
}


// MARK: - Mocks generated from file: DataIntegration/Storage/DatabaseConnector.swift
//
//  DatabaseConnector.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import SQLite

class MockDatabaseConnector: DatabaseConnector, Cuckoo.ClassMock {
    typealias MocksType = DatabaseConnector
    typealias Stubbing = __StubbingProxy_DatabaseConnector
    typealias Verification = __VerificationProxy_DatabaseConnector
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "db", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Connection?", "isReadOnly": false, "accessibility": ""]
     override var db: Connection? {
        get {
            
            return cuckoo_manager.getter("db", superclassCall: super.db)
            
        }
        
        set {
            
            cuckoo_manager.setter("db", value: newValue, superclassCall: super.db = newValue)
            
        }
        
    }
    

    

    
    // ["name": "connect", "returnSignature": " throws", "fullyQualifiedName": "connect() throws", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnThrowingFunction"]
    public override func connect()  throws {
        
            return try cuckoo_manager.callThrows("connect() throws",
                parameters: (),
                superclassCall:
                    
                    super.connect()
                    )
        
    }
    

	struct __StubbingProxy_DatabaseConnector: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var db: Cuckoo.ClassToBeStubbedProperty<MockDatabaseConnector, Connection?> {
	        return .init(manager: cuckoo_manager, name: "db")
	    }
	    
	    
	    func connect() -> Cuckoo.ClassStubNoReturnThrowingFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDatabaseConnector.self, method: "connect() throws", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_DatabaseConnector: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var db: Cuckoo.VerifyProperty<Connection?> {
	        return .init(manager: cuckoo_manager, name: "db", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func connect() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("connect() throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class DatabaseConnectorStub: DatabaseConnector {
    
     override var db: Connection? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Connection?).self)
        }
        
        set { }
        
    }
    

    

    
    public override func connect()  throws {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Util/CalendarUtil.swift
//
//  CalendarUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockCalendarUtil: CalendarUtil, Cuckoo.ClassMock {
    typealias MocksType = CalendarUtil
    typealias Stubbing = __StubbingProxy_CalendarUtil
    typealias Verification = __VerificationProxy_CalendarUtil
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "zeroAllComponents", "returnSignature": " -> Date", "fullyQualifiedName": "zeroAllComponents(toBeginningOf: Calendar.Component, in: Date) -> Date", "parameterSignature": "toBeginningOf component: Calendar.Component, in date: Date", "parameterSignatureWithoutNames": "component: Calendar.Component, date: Date", "inputTypes": "Calendar.Component, Date", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "component, date", "call": "toBeginningOf: component, in: date", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("toBeginningOf"), name: "component", type: "Calendar.Component", range: CountableRange(797..<840), nameRange: CountableRange(797..<810)), CuckooGeneratorFramework.MethodParameter(label: Optional("in"), name: "date", type: "Date", range: CountableRange(842..<855), nameRange: CountableRange(842..<844))], "returnType": "Date", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func zeroAllComponents(toBeginningOf component: Calendar.Component, in date: Date)  -> Date {
        
            return cuckoo_manager.call("zeroAllComponents(toBeginningOf: Calendar.Component, in: Date) -> Date",
                parameters: (component, date),
                superclassCall:
                    
                    super.zeroAllComponents(toBeginningOf: component, in: date)
                    )
        
    }
    

	struct __StubbingProxy_CalendarUtil: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func zeroAllComponents<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(toBeginningOf component: M1, in date: M2) -> Cuckoo.ClassStubFunction<(Calendar.Component, Date), Date> where M1.MatchedType == Calendar.Component, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Calendar.Component, Date)>] = [wrap(matchable: component) { $0.0 }, wrap(matchable: date) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCalendarUtil.self, method: "zeroAllComponents(toBeginningOf: Calendar.Component, in: Date) -> Date", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_CalendarUtil: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func zeroAllComponents<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(toBeginningOf component: M1, in date: M2) -> Cuckoo.__DoNotUse<Date> where M1.MatchedType == Calendar.Component, M2.MatchedType == Date {
	        let matchers: [Cuckoo.ParameterMatcher<(Calendar.Component, Date)>] = [wrap(matchable: component) { $0.0 }, wrap(matchable: date) { $0.1 }]
	        return cuckoo_manager.verify("zeroAllComponents(toBeginningOf: Calendar.Component, in: Date) -> Date", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class CalendarUtilStub: CalendarUtil {
    

    

    
    public override func zeroAllComponents(toBeginningOf component: Calendar.Component, in date: Date)  -> Date {
        return DefaultValueRegistry.defaultValue(for: Date.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Util/HKQuantitySampleUtil.swift
//
//  HKQuantitySampleUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import HealthKit

class MockHKQuantitySampleUtil: HKQuantitySampleUtil, Cuckoo.ClassMock {
    typealias MocksType = HKQuantitySampleUtil
    typealias Stubbing = __StubbingProxy_HKQuantitySampleUtil
    typealias Verification = __VerificationProxy_HKQuantitySampleUtil
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "compute", "returnSignature": " -> [Double]", "fullyQualifiedName": "compute(operation: QueryOperation, over: [HKQuantitySample], withUnit: HKUnit) -> [Double]", "parameterSignature": "operation: QueryOperation, over samples: [HKQuantitySample], withUnit unit: HKUnit", "parameterSignatureWithoutNames": "operation: QueryOperation, samples: [HKQuantitySample], unit: HKUnit", "inputTypes": "QueryOperation, [HKQuantitySample], HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "operation, samples, unit", "call": "operation: operation, over: samples, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("operation"), name: "operation", type: "QueryOperation", range: CountableRange(247..<272), nameRange: CountableRange(247..<256)), CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(274..<306), nameRange: CountableRange(274..<278)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(308..<329), nameRange: CountableRange(308..<316))], "returnType": "[Double]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func compute(operation: QueryOperation, over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> [Double] {
        
            return cuckoo_manager.call("compute(operation: QueryOperation, over: [HKQuantitySample], withUnit: HKUnit) -> [Double]",
                parameters: (operation, samples, unit),
                superclassCall:
                    
                    super.compute(operation: operation, over: samples, withUnit: unit)
                    )
        
    }
    
    // ["name": "average", "returnSignature": " -> [Double]", "fullyQualifiedName": "average(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", "parameterSignature": "over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component?, unit: HKUnit", "inputTypes": "[HKQuantitySample], Calendar.Component?, HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit, unit", "call": "over: samples, per: aggregationUnit, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(873..<905), nameRange: CountableRange(873..<877)), CuckooGeneratorFramework.MethodParameter(label: Optional("per"), name: "aggregationUnit", type: "Calendar.Component?", range: CountableRange(907..<947), nameRange: CountableRange(907..<910)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(949..<970), nameRange: CountableRange(949..<957))], "returnType": "[Double]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func average(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [Double] {
        
            return cuckoo_manager.call("average(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]",
                parameters: (samples, aggregationUnit, unit),
                superclassCall:
                    
                    super.average(over: samples, per: aggregationUnit, withUnit: unit)
                    )
        
    }
    
    // ["name": "average", "returnSignature": " -> Double", "fullyQualifiedName": "average(over: [HKQuantitySample], withUnit: HKUnit) -> Double", "parameterSignature": "over samples: [HKQuantitySample], withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], unit: HKUnit", "inputTypes": "[HKQuantitySample], HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, unit", "call": "over: samples, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(1348..<1380), nameRange: CountableRange(1348..<1352)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(1382..<1403), nameRange: CountableRange(1382..<1390))], "returnType": "Double", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func average(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        
            return cuckoo_manager.call("average(over: [HKQuantitySample], withUnit: HKUnit) -> Double",
                parameters: (samples, unit),
                superclassCall:
                    
                    super.average(over: samples, withUnit: unit)
                    )
        
    }
    
    // ["name": "count", "returnSignature": " -> [Double]", "fullyQualifiedName": "count(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", "parameterSignature": "over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component?, unit: HKUnit", "inputTypes": "[HKQuantitySample], Calendar.Component?, HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit, unit", "call": "over: samples, per: aggregationUnit, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(1581..<1613), nameRange: CountableRange(1581..<1585)), CuckooGeneratorFramework.MethodParameter(label: Optional("per"), name: "aggregationUnit", type: "Calendar.Component?", range: CountableRange(1615..<1655), nameRange: CountableRange(1615..<1618)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(1657..<1678), nameRange: CountableRange(1657..<1665))], "returnType": "[Double]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func count(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [Double] {
        
            return cuckoo_manager.call("count(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]",
                parameters: (samples, aggregationUnit, unit),
                superclassCall:
                    
                    super.count(over: samples, per: aggregationUnit, withUnit: unit)
                    )
        
    }
    
    // ["name": "max", "returnSignature": " -> [Double]", "fullyQualifiedName": "max(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", "parameterSignature": "over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component?, unit: HKUnit", "inputTypes": "[HKQuantitySample], Calendar.Component?, HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit, unit", "call": "over: samples, per: aggregationUnit, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(2012..<2044), nameRange: CountableRange(2012..<2016)), CuckooGeneratorFramework.MethodParameter(label: Optional("per"), name: "aggregationUnit", type: "Calendar.Component?", range: CountableRange(2046..<2086), nameRange: CountableRange(2046..<2049)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(2088..<2109), nameRange: CountableRange(2088..<2096))], "returnType": "[Double]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func max(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [Double] {
        
            return cuckoo_manager.call("max(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]",
                parameters: (samples, aggregationUnit, unit),
                superclassCall:
                    
                    super.max(over: samples, per: aggregationUnit, withUnit: unit)
                    )
        
    }
    
    // ["name": "max", "returnSignature": " -> Double", "fullyQualifiedName": "max(over: [HKQuantitySample], withUnit: HKUnit) -> Double", "parameterSignature": "over samples: [HKQuantitySample], withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], unit: HKUnit", "inputTypes": "[HKQuantitySample], HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, unit", "call": "over: samples, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(2463..<2495), nameRange: CountableRange(2463..<2467)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(2497..<2518), nameRange: CountableRange(2497..<2505))], "returnType": "Double", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func max(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        
            return cuckoo_manager.call("max(over: [HKQuantitySample], withUnit: HKUnit) -> Double",
                parameters: (samples, unit),
                superclassCall:
                    
                    super.max(over: samples, withUnit: unit)
                    )
        
    }
    
    // ["name": "min", "returnSignature": " -> [Double]", "fullyQualifiedName": "min(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", "parameterSignature": "over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component?, unit: HKUnit", "inputTypes": "[HKQuantitySample], Calendar.Component?, HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit, unit", "call": "over: samples, per: aggregationUnit, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(2751..<2783), nameRange: CountableRange(2751..<2755)), CuckooGeneratorFramework.MethodParameter(label: Optional("per"), name: "aggregationUnit", type: "Calendar.Component?", range: CountableRange(2785..<2825), nameRange: CountableRange(2785..<2788)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(2827..<2848), nameRange: CountableRange(2827..<2835))], "returnType": "[Double]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func min(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [Double] {
        
            return cuckoo_manager.call("min(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]",
                parameters: (samples, aggregationUnit, unit),
                superclassCall:
                    
                    super.min(over: samples, per: aggregationUnit, withUnit: unit)
                    )
        
    }
    
    // ["name": "min", "returnSignature": " -> Double", "fullyQualifiedName": "min(over: [HKQuantitySample], withUnit: HKUnit) -> Double", "parameterSignature": "over samples: [HKQuantitySample], withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], unit: HKUnit", "inputTypes": "[HKQuantitySample], HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, unit", "call": "over: samples, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(3202..<3234), nameRange: CountableRange(3202..<3206)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(3236..<3257), nameRange: CountableRange(3236..<3244))], "returnType": "Double", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func min(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        
            return cuckoo_manager.call("min(over: [HKQuantitySample], withUnit: HKUnit) -> Double",
                parameters: (samples, unit),
                superclassCall:
                    
                    super.min(over: samples, withUnit: unit)
                    )
        
    }
    
    // ["name": "sum", "returnSignature": " -> [Double]", "fullyQualifiedName": "sum(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", "parameterSignature": "over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component?, unit: HKUnit", "inputTypes": "[HKQuantitySample], Calendar.Component?, HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit, unit", "call": "over: samples, per: aggregationUnit, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(3491..<3523), nameRange: CountableRange(3491..<3495)), CuckooGeneratorFramework.MethodParameter(label: Optional("per"), name: "aggregationUnit", type: "Calendar.Component?", range: CountableRange(3525..<3565), nameRange: CountableRange(3525..<3528)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(3567..<3588), nameRange: CountableRange(3567..<3575))], "returnType": "[Double]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func sum(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [Double] {
        
            return cuckoo_manager.call("sum(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]",
                parameters: (samples, aggregationUnit, unit),
                superclassCall:
                    
                    super.sum(over: samples, per: aggregationUnit, withUnit: unit)
                    )
        
    }
    
    // ["name": "sum", "returnSignature": " -> Double", "fullyQualifiedName": "sum(over: [HKQuantitySample], withUnit: HKUnit) -> Double", "parameterSignature": "over samples: [HKQuantitySample], withUnit unit: HKUnit", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], unit: HKUnit", "inputTypes": "[HKQuantitySample], HKUnit", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, unit", "call": "over: samples, withUnit: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("over"), name: "samples", type: "[HKQuantitySample]", range: CountableRange(3942..<3974), nameRange: CountableRange(3942..<3946)), CuckooGeneratorFramework.MethodParameter(label: Optional("withUnit"), name: "unit", type: "HKUnit", range: CountableRange(3976..<3997), nameRange: CountableRange(3976..<3984))], "returnType": "Double", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func sum(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        
            return cuckoo_manager.call("sum(over: [HKQuantitySample], withUnit: HKUnit) -> Double",
                parameters: (samples, unit),
                superclassCall:
                    
                    super.sum(over: samples, withUnit: unit)
                    )
        
    }
    
    // ["name": "sortSamplesByAggregation", "returnSignature": " -> [(date: Date, samples: [HKQuantitySample])]", "fullyQualifiedName": "sortSamplesByAggregation(_: [HKQuantitySample], _: Calendar.Component) -> [(date: Date, samples: [HKQuantitySample])]", "parameterSignature": "_ samples: [HKQuantitySample], _ aggregationUnit: Calendar.Component", "parameterSignatureWithoutNames": "samples: [HKQuantitySample], aggregationUnit: Calendar.Component", "inputTypes": "[HKQuantitySample], Calendar.Component", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit", "call": "samples, aggregationUnit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "samples", type: "[HKQuantitySample]", range: CountableRange(4150..<4179), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: nil, name: "aggregationUnit", type: "Calendar.Component", range: CountableRange(4181..<4218), nameRange: CountableRange(0..<0))], "returnType": "[(date: Date, samples: [HKQuantitySample])]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func sortSamplesByAggregation(_ samples: [HKQuantitySample], _ aggregationUnit: Calendar.Component)  -> [(date: Date, samples: [HKQuantitySample])] {
        
            return cuckoo_manager.call("sortSamplesByAggregation(_: [HKQuantitySample], _: Calendar.Component) -> [(date: Date, samples: [HKQuantitySample])]",
                parameters: (samples, aggregationUnit),
                superclassCall:
                    
                    super.sortSamplesByAggregation(samples, aggregationUnit)
                    )
        
    }
    

	struct __StubbingProxy_HKQuantitySampleUtil: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func compute<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(operation: M1, over samples: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<(QueryOperation, [HKQuantitySample], HKUnit), [Double]> where M1.MatchedType == QueryOperation, M2.MatchedType == [HKQuantitySample], M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<(QueryOperation, [HKQuantitySample], HKUnit)>] = [wrap(matchable: operation) { $0.0 }, wrap(matchable: samples) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "compute(operation: QueryOperation, over: [HKQuantitySample], withUnit: HKUnit) -> [Double]", parameterMatchers: matchers))
	    }
	    
	    func average<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component?, HKUnit), [Double]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "average(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", parameterMatchers: matchers))
	    }
	    
	    func average<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.ClassStubFunction<([HKQuantitySample], HKUnit), Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "average(over: [HKQuantitySample], withUnit: HKUnit) -> Double", parameterMatchers: matchers))
	    }
	    
	    func count<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component?, HKUnit), [Double]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "count(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", parameterMatchers: matchers))
	    }
	    
	    func max<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component?, HKUnit), [Double]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "max(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", parameterMatchers: matchers))
	    }
	    
	    func max<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.ClassStubFunction<([HKQuantitySample], HKUnit), Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "max(over: [HKQuantitySample], withUnit: HKUnit) -> Double", parameterMatchers: matchers))
	    }
	    
	    func min<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component?, HKUnit), [Double]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "min(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", parameterMatchers: matchers))
	    }
	    
	    func min<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.ClassStubFunction<([HKQuantitySample], HKUnit), Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "min(over: [HKQuantitySample], withUnit: HKUnit) -> Double", parameterMatchers: matchers))
	    }
	    
	    func sum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component?, HKUnit), [Double]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "sum(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", parameterMatchers: matchers))
	    }
	    
	    func sum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.ClassStubFunction<([HKQuantitySample], HKUnit), Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "sum(over: [HKQuantitySample], withUnit: HKUnit) -> Double", parameterMatchers: matchers))
	    }
	    
	    func sortSamplesByAggregation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ samples: M1, _ aggregationUnit: M2) -> Cuckoo.ClassStubFunction<([HKQuantitySample], Calendar.Component), [(date: Date, samples: [HKQuantitySample])]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKQuantitySampleUtil.self, method: "sortSamplesByAggregation(_: [HKQuantitySample], _: Calendar.Component) -> [(date: Date, samples: [HKQuantitySample])]", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_HKQuantitySampleUtil: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func compute<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(operation: M1, over samples: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[Double]> where M1.MatchedType == QueryOperation, M2.MatchedType == [HKQuantitySample], M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<(QueryOperation, [HKQuantitySample], HKUnit)>] = [wrap(matchable: operation) { $0.0 }, wrap(matchable: samples) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("compute(operation: QueryOperation, over: [HKQuantitySample], withUnit: HKUnit) -> [Double]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func average<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[Double]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("average(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func average<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.__DoNotUse<Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return cuckoo_manager.verify("average(over: [HKQuantitySample], withUnit: HKUnit) -> Double", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func count<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[Double]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("count(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func max<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[Double]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("max(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func max<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.__DoNotUse<Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return cuckoo_manager.verify("max(over: [HKQuantitySample], withUnit: HKUnit) -> Double", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func min<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[Double]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("min(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func min<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.__DoNotUse<Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return cuckoo_manager.verify("min(over: [HKQuantitySample], withUnit: HKUnit) -> Double", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func sum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(over samples: M1, per aggregationUnit: M2, withUnit unit: M3) -> Cuckoo.__DoNotUse<[Double]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component?, M3.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component?, HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: unit) { $0.2 }]
	        return cuckoo_manager.verify("sum(over: [HKQuantitySample], per: Calendar.Component?, withUnit: HKUnit) -> [Double]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func sum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(over samples: M1, withUnit unit: M2) -> Cuckoo.__DoNotUse<Double> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == HKUnit {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], HKUnit)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: unit) { $0.1 }]
	        return cuckoo_manager.verify("sum(over: [HKQuantitySample], withUnit: HKUnit) -> Double", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func sortSamplesByAggregation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ samples: M1, _ aggregationUnit: M2) -> Cuckoo.__DoNotUse<[(date: Date, samples: [HKQuantitySample])]> where M1.MatchedType == [HKQuantitySample], M2.MatchedType == Calendar.Component {
	        let matchers: [Cuckoo.ParameterMatcher<([HKQuantitySample], Calendar.Component)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }]
	        return cuckoo_manager.verify("sortSamplesByAggregation(_: [HKQuantitySample], _: Calendar.Component) -> [(date: Date, samples: [HKQuantitySample])]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HKQuantitySampleUtilStub: HKQuantitySampleUtil {
    

    

    
    public override func compute(operation: QueryOperation, over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> [Double] {
        return DefaultValueRegistry.defaultValue(for: [Double].self)
    }
    
    public override func average(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [Double] {
        return DefaultValueRegistry.defaultValue(for: [Double].self)
    }
    
    public override func average(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        return DefaultValueRegistry.defaultValue(for: Double.self)
    }
    
    public override func count(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [Double] {
        return DefaultValueRegistry.defaultValue(for: [Double].self)
    }
    
    public override func max(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [Double] {
        return DefaultValueRegistry.defaultValue(for: [Double].self)
    }
    
    public override func max(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        return DefaultValueRegistry.defaultValue(for: Double.self)
    }
    
    public override func min(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [Double] {
        return DefaultValueRegistry.defaultValue(for: [Double].self)
    }
    
    public override func min(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        return DefaultValueRegistry.defaultValue(for: Double.self)
    }
    
    public override func sum(over samples: [HKQuantitySample], per aggregationUnit: Calendar.Component?, withUnit unit: HKUnit)  -> [Double] {
        return DefaultValueRegistry.defaultValue(for: [Double].self)
    }
    
    public override func sum(over samples: [HKQuantitySample], withUnit unit: HKUnit)  -> Double {
        return DefaultValueRegistry.defaultValue(for: Double.self)
    }
    
    public override func sortSamplesByAggregation(_ samples: [HKQuantitySample], _ aggregationUnit: Calendar.Component)  -> [(date: Date, samples: [HKQuantitySample])] {
        return DefaultValueRegistry.defaultValue(for: [(date: Date, samples: [HKQuantitySample])].self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Util/HKSampleUtil.swift
//
//  HKSampleUtil.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import HealthKit

class MockHKSampleUtil: HKSampleUtil, Cuckoo.ClassMock {
    typealias MocksType = HKSampleUtil
    typealias Stubbing = __StubbingProxy_HKSampleUtil
    typealias Verification = __VerificationProxy_HKSampleUtil
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "sample", "returnSignature": " -> Bool", "fullyQualifiedName": "sample(_: HKSample, occursOnOneOf: Set<DayOfWeek>) -> Bool", "parameterSignature": "_ sample: HKSample, occursOnOneOf daysOfWeek: Set<DayOfWeek>", "parameterSignatureWithoutNames": "sample: HKSample, daysOfWeek: Set<DayOfWeek>", "inputTypes": "HKSample, Set<DayOfWeek>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "sample, daysOfWeek", "call": "sample, occursOnOneOf: daysOfWeek", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "sample", type: "HKSample", range: CountableRange(487..<505), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: Optional("occursOnOneOf"), name: "daysOfWeek", type: "Set<DayOfWeek>", range: CountableRange(507..<547), nameRange: CountableRange(507..<520))], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func sample(_ sample: HKSample, occursOnOneOf daysOfWeek: Set<DayOfWeek>)  -> Bool {
        
            return cuckoo_manager.call("sample(_: HKSample, occursOnOneOf: Set<DayOfWeek>) -> Bool",
                parameters: (sample, daysOfWeek),
                superclassCall:
                    
                    super.sample(sample, occursOnOneOf: daysOfWeek)
                    )
        
    }
    

	struct __StubbingProxy_HKSampleUtil: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func sample<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ sample: M1, occursOnOneOf daysOfWeek: M2) -> Cuckoo.ClassStubFunction<(HKSample, Set<DayOfWeek>), Bool> where M1.MatchedType == HKSample, M2.MatchedType == Set<DayOfWeek> {
	        let matchers: [Cuckoo.ParameterMatcher<(HKSample, Set<DayOfWeek>)>] = [wrap(matchable: sample) { $0.0 }, wrap(matchable: daysOfWeek) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHKSampleUtil.self, method: "sample(_: HKSample, occursOnOneOf: Set<DayOfWeek>) -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_HKSampleUtil: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func sample<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ sample: M1, occursOnOneOf daysOfWeek: M2) -> Cuckoo.__DoNotUse<Bool> where M1.MatchedType == HKSample, M2.MatchedType == Set<DayOfWeek> {
	        let matchers: [Cuckoo.ParameterMatcher<(HKSample, Set<DayOfWeek>)>] = [wrap(matchable: sample) { $0.0 }, wrap(matchable: daysOfWeek) { $0.1 }]
	        return cuckoo_manager.verify("sample(_: HKSample, occursOnOneOf: Set<DayOfWeek>) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HKSampleUtilStub: HKSampleUtil {
    

    

    
    public override func sample(_ sample: HKSample, occursOnOneOf daysOfWeek: Set<DayOfWeek>)  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
}


// MARK: - Mocks generated from file: DataIntegration/Util/TextNormalizationUtil.swift
//
//  ContractionsReplacementUtil.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation

class MockTextNormalizationUtil: TextNormalizationUtil, Cuckoo.ClassMock {
    typealias MocksType = TextNormalizationUtil
    typealias Stubbing = __StubbingProxy_TextNormalizationUtil
    typealias Verification = __VerificationProxy_TextNormalizationUtil
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "expandContractions", "returnSignature": " -> String", "fullyQualifiedName": "expandContractions(_: String) -> String", "parameterSignature": "_ text: String", "parameterSignatureWithoutNames": "text: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "text", "call": "text", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "text", type: "String", range: CountableRange(4849..<4863), nameRange: CountableRange(0..<0))], "returnType": "String", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func expandContractions(_ text: String)  -> String {
        
            return cuckoo_manager.call("expandContractions(_: String) -> String",
                parameters: (text),
                superclassCall:
                    
                    super.expandContractions(text)
                    )
        
    }
    
    // ["name": "normalizeNumbers", "returnSignature": " -> String", "fullyQualifiedName": "normalizeNumbers(_: String) -> String", "parameterSignature": "_ text: String", "parameterSignatureWithoutNames": "text: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "text", "call": "text", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "text", type: "String", range: CountableRange(5133..<5147), nameRange: CountableRange(0..<0))], "returnType": "String", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func normalizeNumbers(_ text: String)  -> String {
        
            return cuckoo_manager.call("normalizeNumbers(_: String) -> String",
                parameters: (text),
                superclassCall:
                    
                    super.normalizeNumbers(text)
                    )
        
    }
    
    // ["name": "removePunctuation", "returnSignature": " -> String", "fullyQualifiedName": "removePunctuation(_: String) -> String", "parameterSignature": "_ text: String", "parameterSignatureWithoutNames": "text: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "text", "call": "text", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "text", type: "String", range: CountableRange(6773..<6787), nameRange: CountableRange(0..<0))], "returnType": "String", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func removePunctuation(_ text: String)  -> String {
        
            return cuckoo_manager.call("removePunctuation(_: String) -> String",
                parameters: (text),
                superclassCall:
                    
                    super.removePunctuation(text)
                    )
        
    }
    

	struct __StubbingProxy_TextNormalizationUtil: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func expandContractions<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.ClassStubFunction<(String), String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTextNormalizationUtil.self, method: "expandContractions(_: String) -> String", parameterMatchers: matchers))
	    }
	    
	    func normalizeNumbers<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.ClassStubFunction<(String), String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTextNormalizationUtil.self, method: "normalizeNumbers(_: String) -> String", parameterMatchers: matchers))
	    }
	    
	    func removePunctuation<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.ClassStubFunction<(String), String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTextNormalizationUtil.self, method: "removePunctuation(_: String) -> String", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_TextNormalizationUtil: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func expandContractions<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.__DoNotUse<String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("expandContractions(_: String) -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func normalizeNumbers<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.__DoNotUse<String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("normalizeNumbers(_: String) -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func removePunctuation<M1: Cuckoo.Matchable>(_ text: M1) -> Cuckoo.__DoNotUse<String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: text) { $0 }]
	        return cuckoo_manager.verify("removePunctuation(_: String) -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class TextNormalizationUtilStub: TextNormalizationUtil {
    

    

    
    public override func expandContractions(_ text: String)  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
    }
    
    public override func normalizeNumbers(_ text: String)  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
    }
    
    public override func removePunctuation(_ text: String)  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
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
@testable import DataIntegration

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
    
    // ["name": "hkQuantitySampleUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "HKQuantitySampleUtil", "isReadOnly": true, "accessibility": "public"]
    public override var hkQuantitySampleUtil: HKQuantitySampleUtil {
        get {
            
            return cuckoo_manager.getter("hkQuantitySampleUtil", superclassCall: super.hkQuantitySampleUtil)
            
        }
        
    }
    
    // ["name": "hkSampleUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "HKSampleUtil", "isReadOnly": true, "accessibility": "public"]
    public override var hkSampleUtil: HKSampleUtil {
        get {
            
            return cuckoo_manager.getter("hkSampleUtil", superclassCall: super.hkSampleUtil)
            
        }
        
    }
    
    // ["name": "textNormalizationUtil", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "TextNormalizationUtil", "isReadOnly": true, "accessibility": "public"]
    public override var textNormalizationUtil: TextNormalizationUtil {
        get {
            
            return cuckoo_manager.getter("textNormalizationUtil", superclassCall: super.textNormalizationUtil)
            
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
	    
	    var hkQuantitySampleUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, HKQuantitySampleUtil> {
	        return .init(manager: cuckoo_manager, name: "hkQuantitySampleUtil")
	    }
	    
	    var hkSampleUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, HKSampleUtil> {
	        return .init(manager: cuckoo_manager, name: "hkSampleUtil")
	    }
	    
	    var textNormalizationUtil: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockUtilFactory, TextNormalizationUtil> {
	        return .init(manager: cuckoo_manager, name: "textNormalizationUtil")
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
	    
	    var hkQuantitySampleUtil: Cuckoo.VerifyReadOnlyProperty<HKQuantitySampleUtil> {
	        return .init(manager: cuckoo_manager, name: "hkQuantitySampleUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var hkSampleUtil: Cuckoo.VerifyReadOnlyProperty<HKSampleUtil> {
	        return .init(manager: cuckoo_manager, name: "hkSampleUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var textNormalizationUtil: Cuckoo.VerifyReadOnlyProperty<TextNormalizationUtil> {
	        return .init(manager: cuckoo_manager, name: "textNormalizationUtil", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}

}

 class UtilFactoryStub: UtilFactory {
    
    public override var calendarUtil: CalendarUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (CalendarUtil).self)
        }
        
    }
    
    public override var hkQuantitySampleUtil: HKQuantitySampleUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (HKQuantitySampleUtil).self)
        }
        
    }
    
    public override var hkSampleUtil: HKSampleUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (HKSampleUtil).self)
        }
        
    }
    
    public override var textNormalizationUtil: TextNormalizationUtil {
        get {
            return DefaultValueRegistry.defaultValue(for: (TextNormalizationUtil).self)
        }
        
    }
    

    

    
}

