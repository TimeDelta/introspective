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

    
    // ["name": "finalAnswer", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": ""]
     override var finalAnswer: String {
        get {
            
            return cuckoo_manager.getter("finalAnswer", superclassCall: super.finalAnswer)
            
        }
        
        set {
            
            cuckoo_manager.setter("finalAnswer", value: newValue, superclassCall: super.finalAnswer = newValue)
            
        }
        
    }
    
    // ["name": "otherRelevantInformation", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "[String: [NSObject]]", "isReadOnly": false, "accessibility": ""]
     override var otherRelevantInformation: [String: [NSObject]] {
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
    
     override var finalAnswer: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
     override var otherRelevantInformation: [String: [NSObject]] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: [NSObject]]).self)
        }
        
        set { }
        
    }
    

    

    
}

