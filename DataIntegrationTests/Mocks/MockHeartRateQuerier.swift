// MARK: - Mocks generated from file: DataIntegration/Questions/Queries/Queriers/HeartRateQuerier.swift
//
//  HeartRateQuerier.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import HealthKit
import os

class MockHeartRateQuerier: HeartRateQuerier, Cuckoo.ClassMock {
    typealias MocksType = HeartRateQuerier
    typealias Stubbing = __StubbingProxy_HeartRateQuerier
    typealias Verification = __VerificationProxy_HeartRateQuerier
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    

    

    
    // ["name": "getHeartRates", "returnSignature": "", "fullyQualifiedName": "getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())", "parameterSignature": "predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->()", "parameterSignatureWithoutNames": "predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->()", "inputTypes": "NSPredicate, (Array<HKQuantitySample>?, Error?)->()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "predicate, callback", "call": "predicate: predicate, callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("predicate"), name: "predicate", type: "NSPredicate", range: CountableRange(614..<636), nameRange: CountableRange(614..<623)), CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Array<HKQuantitySample>?, Error?)->()", range: CountableRange(638..<695), nameRange: CountableRange(638..<646))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())  {
        
            return cuckoo_manager.call("getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())",
                parameters: (predicate, callback),
                superclassCall:
                    
                    super.getHeartRates(predicate: predicate, callback: callback)
                    )
        
    }
    
    // ["name": "getStatisticsFromHeartRates", "returnSignature": "", "fullyQualifiedName": "getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())", "parameterSignature": "predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->()", "parameterSignatureWithoutNames": "predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->()", "inputTypes": "NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "predicate, statsOptions, callback", "call": "predicate: predicate, statsOptions: statsOptions, callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("predicate"), name: "predicate", type: "NSPredicate", range: CountableRange(992..<1014), nameRange: CountableRange(992..<1001)), CuckooGeneratorFramework.MethodParameter(label: Optional("statsOptions"), name: "statsOptions", type: "HKStatisticsOptions", range: CountableRange(1016..<1049), nameRange: CountableRange(1016..<1028)), CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (HKStatistics?, Error?)->()", range: CountableRange(1051..<1097), nameRange: CountableRange(1051..<1059))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())  {
        
            return cuckoo_manager.call("getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())",
                parameters: (predicate, statsOptions, callback),
                superclassCall:
                    
                    super.getStatisticsFromHeartRates(predicate: predicate, statsOptions: statsOptions, callback: callback)
                    )
        
    }
    
    // ["name": "getAuthorization", "returnSignature": "", "fullyQualifiedName": "getAuthorization(callback: @escaping (Error?) -> ())", "parameterSignature": "callback: @escaping (Error?) -> ()", "parameterSignatureWithoutNames": "callback: @escaping (Error?) -> ()", "inputTypes": "(Error?) -> ()", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "callback", "call": "callback: callback", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("callback"), name: "callback", type: "@escaping (Error?) -> ()", range: CountableRange(1403..<1437), nameRange: CountableRange(1403..<1411))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func getAuthorization(callback: @escaping (Error?) -> ())  {
        
            return cuckoo_manager.call("getAuthorization(callback: @escaping (Error?) -> ())",
                parameters: (callback),
                superclassCall:
                    
                    super.getAuthorization(callback: callback)
                    )
        
    }
    

	struct __StubbingProxy_HeartRateQuerier: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func getHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(predicate: M1, callback: M2) -> Cuckoo.ClassStubNoReturnFunction<(NSPredicate, (Array<HKQuantitySample>?, Error?)->())> where M1.MatchedType == NSPredicate, M2.MatchedType == (Array<HKQuantitySample>?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, (Array<HKQuantitySample>?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuerier.self, method: "getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())", parameterMatchers: matchers))
	    }
	    
	    func getStatisticsFromHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(predicate: M1, statsOptions: M2, callback: M3) -> Cuckoo.ClassStubNoReturnFunction<(NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->())> where M1.MatchedType == NSPredicate, M2.MatchedType == HKStatisticsOptions, M3.MatchedType == (HKStatistics?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: statsOptions) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuerier.self, method: "getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())", parameterMatchers: matchers))
	    }
	    
	    func getAuthorization<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ClassStubNoReturnFunction<((Error?) -> ())> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHeartRateQuerier.self, method: "getAuthorization(callback: @escaping (Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_HeartRateQuerier: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func getHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(predicate: M1, callback: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == NSPredicate, M2.MatchedType == (Array<HKQuantitySample>?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, (Array<HKQuantitySample>?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getStatisticsFromHeartRates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(predicate: M1, statsOptions: M2, callback: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == NSPredicate, M2.MatchedType == HKStatisticsOptions, M3.MatchedType == (HKStatistics?, Error?)->() {
	        let matchers: [Cuckoo.ParameterMatcher<(NSPredicate, HKStatisticsOptions, (HKStatistics?, Error?)->())>] = [wrap(matchable: predicate) { $0.0 }, wrap(matchable: statsOptions) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return cuckoo_manager.verify("getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getAuthorization<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == (Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("getAuthorization(callback: @escaping (Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class HeartRateQuerierStub: HeartRateQuerier {
    

    

    
    public override func getHeartRates(predicate: NSPredicate, callback: @escaping (Array<HKQuantitySample>?, Error?)->())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func getStatisticsFromHeartRates(predicate: NSPredicate, statsOptions: HKStatisticsOptions, callback: @escaping (HKStatistics?, Error?)->())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func getAuthorization(callback: @escaping (Error?) -> ())  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

