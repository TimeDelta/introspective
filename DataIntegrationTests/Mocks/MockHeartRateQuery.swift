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

    
    // ["name": "finalOperation", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "Operations?", "isReadOnly": false, "accessibility": "public"]
    public override var finalOperation: Operations? {
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
    
    // ["name": "daysOfWeekCombinationType", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "CombinationType", "isReadOnly": false, "accessibility": "public"]
    public override var daysOfWeekCombinationType: CombinationType {
        get {
            
            return cuckoo_manager.getter("daysOfWeekCombinationType", superclassCall: super.daysOfWeekCombinationType)
            
        }
        
        set {
            
            cuckoo_manager.setter("daysOfWeekCombinationType", value: newValue, superclassCall: super.daysOfWeekCombinationType = newValue)
            
        }
        
    }
    
    // ["name": "quantityRestrictions", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[QuantityRestriction<Double>]", "isReadOnly": false, "accessibility": "public"]
    public override var quantityRestrictions: [QuantityRestriction<Double>] {
        get {
            
            return cuckoo_manager.getter("quantityRestrictions", superclassCall: super.quantityRestrictions)
            
        }
        
        set {
            
            cuckoo_manager.setter("quantityRestrictions", value: newValue, superclassCall: super.quantityRestrictions = newValue)
            
        }
        
    }
    

    

    
    // ["name": "runQuery", "returnSignature": "", "fullyQualifiedName": "runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ())", "parameterSignature": "callback: @escaping ([String: NSObject]?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping ([String: NSObject]?, Error?) -> ()", "inputTypes": "([String: NSObject]?, Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping ([String: NSObject]?, Error?) -> ()", range: CountableRange(797..<852), nameRange: CountableRange(797..<805))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ())  {
        
            return cuckoo_manager.call("runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ())",
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
	    
	    var finalOperation: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, Operations?> {
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
	    
	    var daysOfWeekCombinationType: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, CombinationType> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeekCombinationType")
	    }
	    
	    var quantityRestrictions: Cuckoo.ClassToBeStubbedProperty<MockHeartRateQuery, [QuantityRestriction<Double>]> {
	        return .init(manager: cuckoo_manager, name: "quantityRestrictions")
	    }
	    
	    
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<(([String: NSObject]?, Error?) -> ())> where M1.MatchedType == ([String: NSObject]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(([String: NSObject]?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuery.self, method: "runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ())", parameterMatchers: matchers))
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
	
	    
	    var finalOperation: Cuckoo.VerifyProperty<Operations?> {
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
	    
	    var daysOfWeekCombinationType: Cuckoo.VerifyProperty<CombinationType> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeekCombinationType", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var quantityRestrictions: Cuckoo.VerifyProperty<[QuantityRestriction<Double>]> {
	        return .init(manager: cuckoo_manager, name: "quantityRestrictions", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == ([String: NSObject]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(([String: NSObject]?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HeartRateQueryStub: HeartRateQuery {
    
    public override var finalOperation: Operations? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Operations?).self)
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
    
    public override var daysOfWeekCombinationType: CombinationType {
        get {
            return DefaultValueRegistry.defaultValue(for: (CombinationType).self)
        }
        
        set { }
        
    }
    
    public override var quantityRestrictions: [QuantityRestriction<Double>] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([QuantityRestriction<Double>]).self)
        }
        
        set { }
        
    }
    

    

    
    public override func runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

