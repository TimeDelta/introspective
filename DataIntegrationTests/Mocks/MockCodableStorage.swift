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

