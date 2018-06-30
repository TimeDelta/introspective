// MARK: - Mocks generated from file: DataIntegration/Questions/Labels.swift
//
//  Labels.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Cuckoo
@testable import DataIntegration

import Foundation
import NaturalLanguage

class MockLabels: Labels, Cuckoo.ClassMock {
    typealias MocksType = Labels
    typealias Stubbing = __StubbingProxy_Labels
    typealias Verification = __VerificationProxy_Labels
    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)

    
    // ["name": "count", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Int", "isReadOnly": true, "accessibility": "public"]
    public override var count: Int {
        get {
            
            return cuckoo_manager.getter("count", superclassCall: super.count)
            
        }
        
    }
    
    // ["name": "isEmpty", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "Bool", "isReadOnly": true, "accessibility": "public"]
    public override var isEmpty: Bool {
        get {
            
            return cuckoo_manager.getter("isEmpty", superclassCall: super.isEmpty)
            
        }
        
    }
    
    // ["name": "byTag", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "[NLTag: [Label]]", "isReadOnly": true, "accessibility": "public"]
    public override var byTag: [NLTag: [Label]] {
        get {
            
            return cuckoo_manager.getter("byTag", superclassCall: super.byTag)
            
        }
        
    }
    
    // ["name": "byIndex", "stubType": "ClassToBeStubbedReadOnlyProperty", "@type": "InstanceVariable", "type": "[Label]", "isReadOnly": true, "accessibility": "public"]
    public override var byIndex: [Label] {
        get {
            
            return cuckoo_manager.getter("byIndex", superclassCall: super.byIndex)
            
        }
        
    }
    

    

    
    // ["name": "addLabel", "returnSignature": "", "fullyQualifiedName": "addLabel(_: Label)", "parameterSignature": "_ label: Label", "parameterSignatureWithoutNames": "label: Label", "inputTypes": "Label", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "label", "call": "label", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "label", type: "Label", range: CountableRange(1697..<1711), nameRange: CountableRange(0..<0))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func addLabel(_ label: Label)  {
        
            return cuckoo_manager.call("addLabel(_: Label)",
                parameters: (label),
                superclassCall:
                    
                    super.addLabel(label)
                    )
        
    }
    
    // ["name": "hasLabelFor", "returnSignature": " -> Bool", "fullyQualifiedName": "hasLabelFor(_: NLTag) -> Bool", "parameterSignature": "_ tag: NLTag", "parameterSignatureWithoutNames": "tag: NLTag", "inputTypes": "NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag", "call": "tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "tag", type: "NLTag", range: CountableRange(2488..<2500), nameRange: CountableRange(0..<0))], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func hasLabelFor(_ tag: NLTag)  -> Bool {
        
            return cuckoo_manager.call("hasLabelFor(_: NLTag) -> Bool",
                parameters: (tag),
                superclassCall:
                    
                    super.hasLabelFor(tag)
                    )
        
    }
    
    // ["name": "hasLabels", "returnSignature": " -> Bool", "fullyQualifiedName": "hasLabels() -> Bool", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func hasLabels()  -> Bool {
        
            return cuckoo_manager.call("hasLabels() -> Bool",
                parameters: (),
                superclassCall:
                    
                    super.hasLabels()
                    )
        
    }
    
    // ["name": "labelsInAnyOrderFor", "returnSignature": " -> [Label]", "fullyQualifiedName": "labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(2755..<2771), nameRange: CountableRange(2755..<2759))], "returnType": "[Label]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func labelsInAnyOrderFor(tags: Set<NLTag>)  -> [Label] {
        
            return cuckoo_manager.call("labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]",
                parameters: (tags),
                superclassCall:
                    
                    super.labelsInAnyOrderFor(tags: tags)
                    )
        
    }
    
    // ["name": "labelsFor", "returnSignature": " -> [Label]", "fullyQualifiedName": "labelsFor(tags: Set<NLTag>) -> [Label]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(3125..<3141), nameRange: CountableRange(3125..<3129))], "returnType": "[Label]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func labelsFor(tags: Set<NLTag>)  -> [Label] {
        
            return cuckoo_manager.call("labelsFor(tags: Set<NLTag>) -> [Label]",
                parameters: (tags),
                superclassCall:
                    
                    super.labelsFor(tags: tags)
                    )
        
    }
    
    // ["name": "splitBefore", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitBefore(tag: NLTag) -> [Labels]", "parameterSignature": "tag: NLTag", "parameterSignatureWithoutNames": "tag: NLTag", "inputTypes": "NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag", "call": "tag: tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(3630..<3640), nameRange: CountableRange(3630..<3633))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitBefore(tag: NLTag)  -> [Labels] {
        
            return cuckoo_manager.call("splitBefore(tag: NLTag) -> [Labels]",
                parameters: (tag),
                superclassCall:
                    
                    super.splitBefore(tag: tag)
                    )
        
    }
    
    // ["name": "splitBefore", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitBefore(tags: Set<NLTag>) -> [Labels]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(4396..<4412), nameRange: CountableRange(4396..<4400))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitBefore(tags: Set<NLTag>)  -> [Labels] {
        
            return cuckoo_manager.call("splitBefore(tags: Set<NLTag>) -> [Labels]",
                parameters: (tags),
                superclassCall:
                    
                    super.splitBefore(tags: tags)
                    )
        
    }
    
    // ["name": "splitAfter", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitAfter(tag: NLTag) -> [Labels]", "parameterSignature": "tag: NLTag", "parameterSignatureWithoutNames": "tag: NLTag", "inputTypes": "NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag", "call": "tag: tag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(5263..<5273), nameRange: CountableRange(5263..<5266))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitAfter(tag: NLTag)  -> [Labels] {
        
            return cuckoo_manager.call("splitAfter(tag: NLTag) -> [Labels]",
                parameters: (tag),
                superclassCall:
                    
                    super.splitAfter(tag: tag)
                    )
        
    }
    
    // ["name": "splitAfter", "returnSignature": " -> [Labels]", "fullyQualifiedName": "splitAfter(tags: Set<NLTag>) -> [Labels]", "parameterSignature": "tags: Set<NLTag>", "parameterSignatureWithoutNames": "tags: Set<NLTag>", "inputTypes": "Set<NLTag>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tags", "call": "tags: tags", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tags"), name: "tags", type: "Set<NLTag>", range: CountableRange(6069..<6085), nameRange: CountableRange(6069..<6073))], "returnType": "[Labels]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func splitAfter(tags: Set<NLTag>)  -> [Labels] {
        
            return cuckoo_manager.call("splitAfter(tags: Set<NLTag>) -> [Labels]",
                parameters: (tags),
                superclassCall:
                    
                    super.splitAfter(tags: tags)
                    )
        
    }
    
    // ["name": "findNearestLabelWith", "returnSignature": " throws -> [Label]?", "fullyQualifiedName": "findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?", "parameterSignature": "tag: NLTag, to index: Int", "parameterSignatureWithoutNames": "tag: NLTag, index: Int", "inputTypes": "NLTag, Int", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag, index", "call": "tag: tag, to: index", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(6972..<6982), nameRange: CountableRange(6972..<6975)), CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "index", type: "Int", range: CountableRange(6984..<6997), nameRange: CountableRange(6984..<6986))], "returnType": "Optional<[Label]>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubThrowingFunction"]
    public override func findNearestLabelWith(tag: NLTag, to index: Int)  throws -> [Label]? {
        
            return try cuckoo_manager.callThrows("findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?",
                parameters: (tag, index),
                superclassCall:
                    
                    super.findNearestLabelWith(tag: tag, to: index)
                    )
        
    }
    
    // ["name": "findNearestLabelWith", "returnSignature": " throws -> Label?", "fullyQualifiedName": "findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?", "parameterSignature": "tag: NLTag, before index: Int", "parameterSignatureWithoutNames": "tag: NLTag, index: Int", "inputTypes": "NLTag, Int", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag, index", "call": "tag: tag, before: index", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(8124..<8134), nameRange: CountableRange(8124..<8127)), CuckooGeneratorFramework.MethodParameter(label: Optional("before"), name: "index", type: "Int", range: CountableRange(8136..<8153), nameRange: CountableRange(8136..<8142))], "returnType": "Optional<Label>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubThrowingFunction"]
    public override func findNearestLabelWith(tag: NLTag, before index: Int)  throws -> Label? {
        
            return try cuckoo_manager.callThrows("findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?",
                parameters: (tag, index),
                superclassCall:
                    
                    super.findNearestLabelWith(tag: tag, before: index)
                    )
        
    }
    
    // ["name": "findNearestLabelWith", "returnSignature": " throws -> Label?", "fullyQualifiedName": "findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?", "parameterSignature": "tag: NLTag, after index: Int", "parameterSignatureWithoutNames": "tag: NLTag, index: Int", "inputTypes": "NLTag, Int", "isThrowing": true, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag, index", "call": "tag: tag, after: index", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("tag"), name: "tag", type: "NLTag", range: CountableRange(8667..<8677), nameRange: CountableRange(8667..<8670)), CuckooGeneratorFramework.MethodParameter(label: Optional("after"), name: "index", type: "Int", range: CountableRange(8679..<8695), nameRange: CountableRange(8679..<8684))], "returnType": "Optional<Label>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubThrowingFunction"]
    public override func findNearestLabelWith(tag: NLTag, after index: Int)  throws -> Label? {
        
            return try cuckoo_manager.callThrows("findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?",
                parameters: (tag, index),
                superclassCall:
                    
                    super.findNearestLabelWith(tag: tag, after: index)
                    )
        
    }
    
    // ["name": "markTokenIn", "returnSignature": "", "fullyQualifiedName": "markTokenIn(range: Range<String.Index>, asTag: NLTag)", "parameterSignature": "range: Range<String.Index>, asTag: NLTag", "parameterSignatureWithoutNames": "range: Range<String.Index>, asTag: NLTag", "inputTypes": "Range<String.Index>, NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "range, asTag", "call": "range: range, asTag: asTag", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("range"), name: "range", type: "Range<String.Index>", range: CountableRange(9306..<9332), nameRange: CountableRange(9306..<9311)), CuckooGeneratorFramework.MethodParameter(label: Optional("asTag"), name: "asTag", type: "NLTag", range: CountableRange(9334..<9346), nameRange: CountableRange(9334..<9339))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.ClassStubNoReturnFunction"]
    public override func markTokenIn(range: Range<String.Index>, asTag: NLTag)  {
        
            return cuckoo_manager.call("markTokenIn(range: Range<String.Index>, asTag: NLTag)",
                parameters: (range, asTag),
                superclassCall:
                    
                    super.markTokenIn(range: range, asTag: asTag)
                    )
        
    }
    
    // ["name": "shortestDistance", "returnSignature": " -> Int", "fullyQualifiedName": "shortestDistance(between: NLTag, and: NLTag) -> Int", "parameterSignature": "between tag1: NLTag, and tag2: NLTag", "parameterSignatureWithoutNames": "tag1: NLTag, tag2: NLTag", "inputTypes": "NLTag, NLTag", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "tag1, tag2", "call": "between: tag1, and: tag2", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("between"), name: "tag1", type: "NLTag", range: CountableRange(9670..<9689), nameRange: CountableRange(9670..<9677)), CuckooGeneratorFramework.MethodParameter(label: Optional("and"), name: "tag2", type: "NLTag", range: CountableRange(9691..<9706), nameRange: CountableRange(9691..<9694))], "returnType": "Int", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func shortestDistance(between tag1: NLTag, and tag2: NLTag)  -> Int {
        
            return cuckoo_manager.call("shortestDistance(between: NLTag, and: NLTag) -> Int",
                parameters: (tag1, tag2),
                superclassCall:
                    
                    super.shortestDistance(between: tag1, and: tag2)
                    )
        
    }
    
    // ["name": "next", "returnSignature": " -> Labels.Label?", "fullyQualifiedName": "next() -> Labels.Label?", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "", "call": "", "parameters": [], "returnType": "Optional<Labels.Label>", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
    public override func next()  -> Labels.Label? {
        
            return cuckoo_manager.call("next() -> Labels.Label?",
                parameters: (),
                superclassCall:
                    
                    super.next()
                    )
        
    }
    

	struct __StubbingProxy_Labels: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var count: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, Int> {
	        return .init(manager: cuckoo_manager, name: "count")
	    }
	    
	    var isEmpty: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, Bool> {
	        return .init(manager: cuckoo_manager, name: "isEmpty")
	    }
	    
	    var byTag: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, [NLTag: [Label]]> {
	        return .init(manager: cuckoo_manager, name: "byTag")
	    }
	    
	    var byIndex: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockLabels, [Label]> {
	        return .init(manager: cuckoo_manager, name: "byIndex")
	    }
	    
	    
	    func addLabel<M1: Cuckoo.Matchable>(_ label: M1) -> Cuckoo.ClassStubNoReturnFunction<(Label)> where M1.MatchedType == Label {
	        let matchers: [Cuckoo.ParameterMatcher<(Label)>] = [wrap(matchable: label) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "addLabel(_: Label)", parameterMatchers: matchers))
	    }
	    
	    func hasLabelFor<M1: Cuckoo.Matchable>(_ tag: M1) -> Cuckoo.ClassStubFunction<(NLTag), Bool> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "hasLabelFor(_: NLTag) -> Bool", parameterMatchers: matchers))
	    }
	    
	    func hasLabels() -> Cuckoo.ClassStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "hasLabels() -> Bool", parameterMatchers: matchers))
	    }
	    
	    func labelsInAnyOrderFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]", parameterMatchers: matchers))
	    }
	    
	    func labelsFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "labelsFor(tags: Set<NLTag>) -> [Label]", parameterMatchers: matchers))
	    }
	    
	    func splitBefore<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.ClassStubFunction<(NLTag), [Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitBefore(tag: NLTag) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func splitBefore<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitBefore(tags: Set<NLTag>) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func splitAfter<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.ClassStubFunction<(NLTag), [Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitAfter(tag: NLTag) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func splitAfter<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.ClassStubFunction<(Set<NLTag>), [Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "splitAfter(tags: Set<NLTag>) -> [Labels]", parameterMatchers: matchers))
	    }
	    
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, to index: M2) -> Cuckoo.ClassStubThrowingFunction<(NLTag, Int), Optional<[Label]>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?", parameterMatchers: matchers))
	    }
	    
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, before index: M2) -> Cuckoo.ClassStubThrowingFunction<(NLTag, Int), Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?", parameterMatchers: matchers))
	    }
	    
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, after index: M2) -> Cuckoo.ClassStubThrowingFunction<(NLTag, Int), Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?", parameterMatchers: matchers))
	    }
	    
	    func markTokenIn<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(range: M1, asTag: M2) -> Cuckoo.ClassStubNoReturnFunction<(Range<String.Index>, NLTag)> where M1.MatchedType == Range<String.Index>, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Range<String.Index>, NLTag)>] = [wrap(matchable: range) { $0.0 }, wrap(matchable: asTag) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "markTokenIn(range: Range<String.Index>, asTag: NLTag)", parameterMatchers: matchers))
	    }
	    
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(between tag1: M1, and tag2: M2) -> Cuckoo.ClassStubFunction<(NLTag, NLTag), Int> where M1.MatchedType == NLTag, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, NLTag)>] = [wrap(matchable: tag1) { $0.0 }, wrap(matchable: tag2) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "shortestDistance(between: NLTag, and: NLTag) -> Int", parameterMatchers: matchers))
	    }
	    
	    func next() -> Cuckoo.ClassStubFunction<(), Optional<Labels.Label>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockLabels.self, method: "next() -> Labels.Label?", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_Labels: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var count: Cuckoo.VerifyReadOnlyProperty<Int> {
	        return .init(manager: cuckoo_manager, name: "count", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var isEmpty: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isEmpty", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var byTag: Cuckoo.VerifyReadOnlyProperty<[NLTag: [Label]]> {
	        return .init(manager: cuckoo_manager, name: "byTag", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var byIndex: Cuckoo.VerifyReadOnlyProperty<[Label]> {
	        return .init(manager: cuckoo_manager, name: "byIndex", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func addLabel<M1: Cuckoo.Matchable>(_ label: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Label {
	        let matchers: [Cuckoo.ParameterMatcher<(Label)>] = [wrap(matchable: label) { $0 }]
	        return cuckoo_manager.verify("addLabel(_: Label)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func hasLabelFor<M1: Cuckoo.Matchable>(_ tag: M1) -> Cuckoo.__DoNotUse<Bool> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return cuckoo_manager.verify("hasLabelFor(_: NLTag) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func hasLabels() -> Cuckoo.__DoNotUse<Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("hasLabels() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func labelsInAnyOrderFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("labelsInAnyOrderFor(tags: Set<NLTag>) -> [Label]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func labelsFor<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Label]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("labelsFor(tags: Set<NLTag>) -> [Label]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitBefore<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return cuckoo_manager.verify("splitBefore(tag: NLTag) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitBefore<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("splitBefore(tags: Set<NLTag>) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitAfter<M1: Cuckoo.Matchable>(tag: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag)>] = [wrap(matchable: tag) { $0 }]
	        return cuckoo_manager.verify("splitAfter(tag: NLTag) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func splitAfter<M1: Cuckoo.Matchable>(tags: M1) -> Cuckoo.__DoNotUse<[Labels]> where M1.MatchedType == Set<NLTag> {
	        let matchers: [Cuckoo.ParameterMatcher<(Set<NLTag>)>] = [wrap(matchable: tags) { $0 }]
	        return cuckoo_manager.verify("splitAfter(tags: Set<NLTag>) -> [Labels]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, to index: M2) -> Cuckoo.__DoNotUse<Optional<[Label]>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return cuckoo_manager.verify("findNearestLabelWith(tag: NLTag, to: Int) throws -> [Label]?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, before index: M2) -> Cuckoo.__DoNotUse<Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return cuckoo_manager.verify("findNearestLabelWith(tag: NLTag, before: Int) throws -> Label?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findNearestLabelWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(tag: M1, after index: M2) -> Cuckoo.__DoNotUse<Optional<Label>> where M1.MatchedType == NLTag, M2.MatchedType == Int {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, Int)>] = [wrap(matchable: tag) { $0.0 }, wrap(matchable: index) { $0.1 }]
	        return cuckoo_manager.verify("findNearestLabelWith(tag: NLTag, after: Int) throws -> Label?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func markTokenIn<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(range: M1, asTag: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Range<String.Index>, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(Range<String.Index>, NLTag)>] = [wrap(matchable: range) { $0.0 }, wrap(matchable: asTag) { $0.1 }]
	        return cuckoo_manager.verify("markTokenIn(range: Range<String.Index>, asTag: NLTag)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func shortestDistance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(between tag1: M1, and tag2: M2) -> Cuckoo.__DoNotUse<Int> where M1.MatchedType == NLTag, M2.MatchedType == NLTag {
	        let matchers: [Cuckoo.ParameterMatcher<(NLTag, NLTag)>] = [wrap(matchable: tag1) { $0.0 }, wrap(matchable: tag2) { $0.1 }]
	        return cuckoo_manager.verify("shortestDistance(between: NLTag, and: NLTag) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func next() -> Cuckoo.__DoNotUse<Optional<Labels.Label>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("next() -> Labels.Label?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class LabelsStub: Labels {
    
    public override var count: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        
    }
    
    public override var isEmpty: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    public override var byTag: [NLTag: [Label]] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([NLTag: [Label]]).self)
        }
        
    }
    
    public override var byIndex: [Label] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([Label]).self)
        }
        
    }
    

    

    
    public override func addLabel(_ label: Label)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func hasLabelFor(_ tag: NLTag)  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
    public override func hasLabels()  -> Bool {
        return DefaultValueRegistry.defaultValue(for: Bool.self)
    }
    
    public override func labelsInAnyOrderFor(tags: Set<NLTag>)  -> [Label] {
        return DefaultValueRegistry.defaultValue(for: [Label].self)
    }
    
    public override func labelsFor(tags: Set<NLTag>)  -> [Label] {
        return DefaultValueRegistry.defaultValue(for: [Label].self)
    }
    
    public override func splitBefore(tag: NLTag)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func splitBefore(tags: Set<NLTag>)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func splitAfter(tag: NLTag)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func splitAfter(tags: Set<NLTag>)  -> [Labels] {
        return DefaultValueRegistry.defaultValue(for: [Labels].self)
    }
    
    public override func findNearestLabelWith(tag: NLTag, to index: Int)  throws -> [Label]? {
        return DefaultValueRegistry.defaultValue(for: Optional<[Label]>.self)
    }
    
    public override func findNearestLabelWith(tag: NLTag, before index: Int)  throws -> Label? {
        return DefaultValueRegistry.defaultValue(for: Optional<Label>.self)
    }
    
    public override func findNearestLabelWith(tag: NLTag, after index: Int)  throws -> Label? {
        return DefaultValueRegistry.defaultValue(for: Optional<Label>.self)
    }
    
    public override func markTokenIn(range: Range<String.Index>, asTag: NLTag)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    public override func shortestDistance(between tag1: NLTag, and tag2: NLTag)  -> Int {
        return DefaultValueRegistry.defaultValue(for: Int.self)
    }
    
    public override func next()  -> Labels.Label? {
        return DefaultValueRegistry.defaultValue(for: Optional<Labels.Label>.self)
    }
    
}

