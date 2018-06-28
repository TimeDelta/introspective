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

    
    // ["name": "parts", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "[String: [NSObject]]", "isReadOnly": true, "accessibility": ""]
     override var parts: [String: [NSObject]] {
        get {
            
            return cuckoo_manager.getter("parts", superclassCall: super.parts)
            
        }
        
    }
    

    

    
    // ["name": "addPart", "returnSignature": "", "fullyQualifiedName": "addPart(_: String, _: [NSObject])", "parameterSignature": "_ partName: String, _ partValues: [NSObject]", "parameterSignatureWithoutNames": "partName: String, partValues: [NSObject]", "inputTypes": "String, [NSObject]", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "partName, partValues", "call": "partName, partValues", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "partName", type: "String", range: CountableRange(326..<344), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: nil, name: "partValues", type: "[NSObject]", range: CountableRange(346..<370), nameRange: CountableRange(0..<0))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func addPart(_ partName: String, _ partValues: [NSObject])  {
        
            return cuckoo_manager.call("addPart(_: String, _: [NSObject])",
                parameters: (partName, partValues),
                superclassCall:
                    
                    super.addPart(partName, partValues)
                    )
        
    }
    

	struct __StubbingProxy_Answer: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var parts: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAnswer, [String: [NSObject]]> {
	        return .init(manager: cuckoo_manager, name: "parts")
	    }
	    
	    
	    func addPart<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ partName: M1, _ partValues: M2) -> Cuckoo.ClassStubNoReturnFunction<(String, [NSObject])> where M1.MatchedType == String, M2.MatchedType == [NSObject] {
	        let matchers: [Cuckoo.ParameterMatcher<(String, [NSObject])>] = [wrap(matchable: partName) { $0.0 }, wrap(matchable: partValues) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAnswer.self, method: "addPart(_: String, _: [NSObject])", parameterMatchers: matchers))
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
	
	    
	    var parts: Cuckoo.VerifyReadOnlyProperty<[String: [NSObject]]> {
	        return .init(manager: cuckoo_manager, name: "parts", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func addPart<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ partName: M1, _ partValues: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == [NSObject] {
	        let matchers: [Cuckoo.ParameterMatcher<(String, [NSObject])>] = [wrap(matchable: partName) { $0.0 }, wrap(matchable: partValues) { $0.1 }]
	        return cuckoo_manager.verify("addPart(_: String, _: [NSObject])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class AnswerStub: Answer {
    
     override var parts: [String: [NSObject]] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: [NSObject]]).self)
        }
        
    }
    

    

    
    public override func addPart(_ partName: String, _ partValues: [NSObject])  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

