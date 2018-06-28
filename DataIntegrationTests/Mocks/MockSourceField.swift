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
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1054..<1073), nameRange: CountableRange(1054..<1056))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func encode(to encoder: Encoder)  {
        
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
    

    

    
     override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

