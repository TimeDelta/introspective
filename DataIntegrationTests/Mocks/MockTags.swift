// MARK: - Mocks generated from file: DataIntegration/Questions/Tags.swift
//
//  Tags.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage

class MockTags: Tags, Cuckoo.ClassMock {
    typealias MocksType = Tags
    typealias Stubbing = __StubbingProxy_Tags
    typealias Verification = __VerificationProxy_Tags
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    

	struct __StubbingProxy_Tags: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	}

	struct __VerificationProxy_Tags: Cuckoo.VerificationProxy {
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

 class TagsStub: Tags {
    

    

    
}

