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

    
    // ["name": "name", "stubType": "ClassToBeStubbedProperty", "@type": "InstanceVariable", "type": "String", "isReadOnly": false, "accessibility": ""]
     override var name: String {
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
    

    

    
    // ["name": "encode", "returnSignature": "", "fullyQualifiedName": "encode(to: Encoder)", "parameterSignature": "to encoder: Encoder", "parameterSignatureWithoutNames": "encoder: Encoder", "inputTypes": "Encoder", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "encoder", "call": "to: encoder", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "encoder", type: "Encoder", range: CountableRange(1415..<1434), nameRange: CountableRange(1415..<1417))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
     override func encode(to encoder: Encoder)  {
        
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
    
     override var name: String {
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
    

    

    
     override func encode(to encoder: Encoder)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

