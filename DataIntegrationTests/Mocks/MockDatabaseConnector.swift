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
    

    

    
    // ["name": "connect", "returnSignature": " throws", "fullyQualifiedName": "connect() throws", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnThrowingFunction"]
     override func connect()  throws {
        
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
    

    

    
     override func connect()  throws {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

