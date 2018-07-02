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

    

    

    

	struct __StubbingProxy_TextNormalizationUtil: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
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
	
	    
	
	    
	}

}

 class TextNormalizationUtilStub: TextNormalizationUtil {
    

    

    
}

