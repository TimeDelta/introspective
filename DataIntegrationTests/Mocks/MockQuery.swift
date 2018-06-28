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

    
    // ["name": "finalOperation", "stubType": "ProtocolToBeStubbedProperty", "@type": "InstanceVariable", "type": "Operations?", "isReadOnly": false, "accessibility": ""]
     var finalOperation: Operations? {
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
    
    // ["name": "daysOfWeek", "stubType": "ProtocolToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Set<DayOfWeek>", "isReadOnly": true, "accessibility": ""]
     var daysOfWeek: Set<DayOfWeek> {
        get {
            
            return cuckoo_manager.getter("daysOfWeek", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            
        }
        
    }
    

    

    
    // ["name": "runQuery", "returnSignature": " throws", "fullyQualifiedName": "runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ()) throws", "parameterSignature": "callback: @escaping ([String: NSObject]?, Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping ([String: NSObject]?, Error?) -> ()", "inputTypes": "([String: NSObject]?, Error?) -> ()", "isThrowing": true, "isInit": false, "isOverriding": false, "hasClosureParams": true, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping ([String: NSObject]?, Error?) -> ()", range: CountableRange(336..<391), nameRange: CountableRange(336..<344))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ProtocolStubNoReturnThrowingFunction"]
     func runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ())  throws {
        
            return try cuckoo_manager.callThrows("runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ()) throws",
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
	    
	    var finalOperation: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, Operations?> {
	        return .init(manager: cuckoo_manager, name: "finalOperation")
	    }
	    
	    var startDate: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, Date?> {
	        return .init(manager: cuckoo_manager, name: "startDate")
	    }
	    
	    var endDate: Cuckoo.ProtocolToBeStubbedProperty<MockQuery, Date?> {
	        return .init(manager: cuckoo_manager, name: "endDate")
	    }
	    
	    var daysOfWeek: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockQuery, Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek")
	    }
	    
	    
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(([String: NSObject]?, Error?) -> ())> where M1.MatchedType == ([String: NSObject]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(([String: NSObject]?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockQuery.self, method: "runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ()) throws", parameterMatchers: matchers))
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
	
	    
	    var finalOperation: Cuckoo.VerifyProperty<Operations?> {
	        return .init(manager: cuckoo_manager, name: "finalOperation", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var startDate: Cuckoo.VerifyProperty<Date?> {
	        return .init(manager: cuckoo_manager, name: "startDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var endDate: Cuckoo.VerifyProperty<Date?> {
	        return .init(manager: cuckoo_manager, name: "endDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var daysOfWeek: Cuckoo.VerifyReadOnlyProperty<Set<DayOfWeek>> {
	        return .init(manager: cuckoo_manager, name: "daysOfWeek", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func runQuery<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == ([String: NSObject]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(([String: NSObject]?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ()) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class QueryStub: Query {
    
     var finalOperation: Operations? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Operations?).self)
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
        
    }
    

    

    
     func runQuery(callback: @escaping ([String: NSObject]?, Error?) -> ())  throws {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

