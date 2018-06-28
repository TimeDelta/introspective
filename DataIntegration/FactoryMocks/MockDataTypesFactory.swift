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

