//// MARK: - Mocks generated from file: DataIntegration/Util/SampleUtil.swift
////
////  SampleUtil.swift
////  DataIntegration
////
////  Created by Bryan Nova on 7/14/18.
////  Copyright © 2018 Bryan Nova. All rights reserved.
////
//
//import Cuckoo
//@testable import DataIntegration
//
//import Foundation
//
//class MockSampleUtil: SampleUtil, Cuckoo.ClassMock {
//    typealias MocksType = SampleUtil
//    typealias Stubbing = __StubbingProxy_SampleUtil
//    typealias Verification = __VerificationProxy_SampleUtil
//    let cuckoo_manager = Cuckoo.MockManager(hasParent: true)
//
//
//
//
//
//
//    // ["name": "getOnly", "returnSignature": " -> [SampleType]", "fullyQualifiedName": "getOnly(samples: [SampleType], from: Date?, to: Date?) -> [SampleType]", "parameterSignature": "samples: [SampleType], from startDate: Date?, to endDate: Date?", "parameterSignatureWithoutNames": "samples: [SampleType], startDate: Date?, endDate: Date?", "inputTypes": "[SampleType], Date?, Date?", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, startDate, endDate", "call": "samples: samples, from: startDate, to: endDate", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("samples"), name: "samples", type: "[SampleType]", range: CountableRange(231..<252), nameRange: CountableRange(231..<238)), CuckooGeneratorFramework.MethodParameter(label: Optional("from"), name: "startDate", type: "Date?", range: CountableRange(254..<275), nameRange: CountableRange(254..<258)), CuckooGeneratorFramework.MethodParameter(label: Optional("to"), name: "endDate", type: "Date?", range: CountableRange(277..<294), nameRange: CountableRange(277..<279))], "returnType": "[SampleType]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
//    public override func getOnly<SampleType: Sample>(samples: [SampleType], from startDate: Date?, to endDate: Date?)  -> [SampleType] {
//
//            return cuckoo_manager.call("getOnly(samples: [SampleType], from: Date?, to: Date?) -> [SampleType]",
//                parameters: (samples, startDate, endDate),
//                superclassCall:
//
//                    super.getOnly(samples: samples, from: startDate, to: endDate)
//                    )
//
//    }
//
//    // ["name": "sample", "returnSignature": " -> Bool", "fullyQualifiedName": "sample(_: Sample, occursOnOneOf: Set<DayOfWeek>) -> Bool", "parameterSignature": "_ sample: Sample, occursOnOneOf daysOfWeek: Set<DayOfWeek>", "parameterSignatureWithoutNames": "sample: Sample, daysOfWeek: Set<DayOfWeek>", "inputTypes": "Sample, Set<DayOfWeek>", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "sample, daysOfWeek", "call": "sample, occursOnOneOf: daysOfWeek", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "sample", type: "Sample", range: CountableRange(1129..<1145), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: Optional("occursOnOneOf"), name: "daysOfWeek", type: "Set<DayOfWeek>", range: CountableRange(1147..<1187), nameRange: CountableRange(1147..<1160))], "returnType": "Bool", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
//    public override func sample(_ sample: Sample, occursOnOneOf daysOfWeek: Set<DayOfWeek>)  -> Bool {
//
//            return cuckoo_manager.call("sample(_: Sample, occursOnOneOf: Set<DayOfWeek>) -> Bool",
//                parameters: (sample, daysOfWeek),
//                superclassCall:
//
//                    super.sample(sample, occursOnOneOf: daysOfWeek)
//                    )
//
//    }
//
//    // ["name": "aggregate", "returnSignature": " -> [Date: [SampleType]]", "fullyQualifiedName": "aggregate(samples: [SampleType], by: Calendar.Component, dateType: DateType) -> [Date: [SampleType]]", "parameterSignature": "samples: [SampleType], by aggregationUnit: Calendar.Component, dateType: DateType", "parameterSignatureWithoutNames": "samples: [SampleType], aggregationUnit: Calendar.Component, dateType: DateType", "inputTypes": "[SampleType], Calendar.Component, DateType", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit, dateType", "call": "samples: samples, by: aggregationUnit, dateType: dateType", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("samples"), name: "samples", type: "[SampleType]", range: CountableRange(1828..<1849), nameRange: CountableRange(1828..<1835)), CuckooGeneratorFramework.MethodParameter(label: Optional("by"), name: "aggregationUnit", type: "Calendar.Component", range: CountableRange(1851..<1889), nameRange: CountableRange(1851..<1853)), CuckooGeneratorFramework.MethodParameter(label: Optional("dateType"), name: "dateType", type: "DateType", range: CountableRange(1891..<1918), nameRange: CountableRange(1891..<1899))], "returnType": "[Date: [SampleType]]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
//    public override func aggregate<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component, dateType: DateType)  -> [Date: [SampleType]] {
//
//            return cuckoo_manager.call("aggregate(samples: [SampleType], by: Calendar.Component, dateType: DateType) -> [Date: [SampleType]]",
//                parameters: (samples, aggregationUnit, dateType),
//                superclassCall:
//
//                    super.aggregate(samples: samples, by: aggregationUnit, dateType: dateType)
//                    )
//
//    }
//
//    // ["name": "sort", "returnSignature": " -> [(date: Date, samples: [SampleType])]", "fullyQualifiedName": "sort(samples: [SampleType], by: Calendar.Component) -> [(date: Date, samples: [SampleType])]", "parameterSignature": "samples: [SampleType], by aggregationUnit: Calendar.Component", "parameterSignatureWithoutNames": "samples: [SampleType], aggregationUnit: Calendar.Component", "inputTypes": "[SampleType], Calendar.Component", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, aggregationUnit", "call": "samples: samples, by: aggregationUnit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("samples"), name: "samples", type: "[SampleType]", range: CountableRange(2549..<2570), nameRange: CountableRange(2549..<2556)), CuckooGeneratorFramework.MethodParameter(label: Optional("by"), name: "aggregationUnit", type: "Calendar.Component", range: CountableRange(2572..<2610), nameRange: CountableRange(2572..<2574))], "returnType": "[(date: Date, samples: [SampleType])]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
//    public override func sort<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component)  -> [(date: Date, samples: [SampleType])] {
//
//            return cuckoo_manager.call("sort(samples: [SampleType], by: Calendar.Component) -> [(date: Date, samples: [SampleType])]",
//                parameters: (samples, aggregationUnit),
//                superclassCall:
//
//                    super.sort(samples: samples, by: aggregationUnit)
//                    )
//
//    }
//
//    // ["name": "sort", "returnSignature": " -> [SampleType]", "fullyQualifiedName": "sort(samples: [SampleType], by: DateType) -> [SampleType]", "parameterSignature": "samples: [SampleType], by dateType: DateType", "parameterSignatureWithoutNames": "samples: [SampleType], dateType: DateType", "inputTypes": "[SampleType], DateType", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, dateType", "call": "samples: samples, by: dateType", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("samples"), name: "samples", type: "[SampleType]", range: CountableRange(3199..<3220), nameRange: CountableRange(3199..<3206)), CuckooGeneratorFramework.MethodParameter(label: Optional("by"), name: "dateType", type: "DateType", range: CountableRange(3222..<3243), nameRange: CountableRange(3222..<3224))], "returnType": "[SampleType]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
//    public override func sort<SampleType: Sample>(samples: [SampleType], by dateType: DateType)  -> [SampleType] {
//
//            return cuckoo_manager.call("sort(samples: [SampleType], by: DateType) -> [SampleType]",
//                parameters: (samples, dateType),
//                superclassCall:
//
//                    super.sort(samples: samples, by: dateType)
//                    )
//
//    }
//
//    // ["name": "convertOneDateSamplesToTwoDateSamples", "returnSignature": " -> [SampleType]", "fullyQualifiedName": "convertOneDateSamplesToTwoDateSamples(_: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType) -> [SampleType]", "parameterSignature": "_ samples: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType", "parameterSignatureWithoutNames": "samples: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType", "inputTypes": "[SampleType], (SampleType, SampleType) -> Bool, ([SampleType], Date, Date) -> SampleType", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": true, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "samples, samplesShouldNotBeJoined, joinSamples", "call": "samples, samplesShouldNotBeJoined: samplesShouldNotBeJoined, joinSamples: joinSamples", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "samples", type: "[SampleType]", range: CountableRange(3599..<3622), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: Optional("samplesShouldNotBeJoined"), name: "samplesShouldNotBeJoined", type: "(SampleType, SampleType) -> Bool", range: CountableRange(3626..<3684), nameRange: CountableRange(3626..<3650)), CuckooGeneratorFramework.MethodParameter(label: Optional("joinSamples"), name: "joinSamples", type: "([SampleType], Date, Date) -> SampleType", range: CountableRange(3688..<3741), nameRange: CountableRange(3688..<3699))], "returnType": "[SampleType]", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
//    public override func convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(_ samples: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType)  -> [SampleType] {
//        		return withoutActuallyEscaping(samplesShouldNotBeJoined, do: { (samplesShouldNotBeJoined) in
//			return withoutActuallyEscaping(joinSamples, do: { (joinSamples) in
//
//            return cuckoo_manager.call("convertOneDateSamplesToTwoDateSamples(_: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType) -> [SampleType]",
//                parameters: (samples, samplesShouldNotBeJoined, joinSamples),
//                superclassCall:
//
//                    super.convertOneDateSamplesToTwoDateSamples(samples, samplesShouldNotBeJoined: samplesShouldNotBeJoined, joinSamples: joinSamples)
//                    )
//        		})
//			})
//
//    }
//
//    // ["name": "closestInTimeTo", "returnSignature": " -> SampleType", "fullyQualifiedName": "closestInTimeTo(sample: SampleType, in: [SampleType]) -> SampleType", "parameterSignature": "sample: SampleType, in samples: [SampleType]", "parameterSignatureWithoutNames": "sample: SampleType, samples: [SampleType]", "inputTypes": "SampleType, [SampleType]", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "sample, samples", "call": "sample: sample, in: samples", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("sample"), name: "sample", type: "SampleType", range: CountableRange(4623..<4641), nameRange: CountableRange(4623..<4629)), CuckooGeneratorFramework.MethodParameter(label: Optional("in"), name: "samples", type: "[SampleType]", range: CountableRange(4643..<4667), nameRange: CountableRange(4643..<4645))], "returnType": "SampleType", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
//    public override func closestInTimeTo<SampleType: Sample>(sample: SampleType, in samples: [SampleType])  -> SampleType {
//
//            return cuckoo_manager.call("closestInTimeTo(sample: SampleType, in: [SampleType]) -> SampleType",
//                parameters: (sample, samples),
//                superclassCall:
//
//                    super.closestInTimeTo(sample: sample, in: samples)
//                    )
//
//    }
//
//    // ["name": "distance", "returnSignature": " -> Int", "fullyQualifiedName": "distance(between: SampleType, and: SampleType, in: Calendar.Component) -> Int", "parameterSignature": "between sample1: SampleType, and sample2: SampleType, in unit: Calendar.Component", "parameterSignatureWithoutNames": "sample1: SampleType, sample2: SampleType, unit: Calendar.Component", "inputTypes": "SampleType, SampleType, Calendar.Component", "isThrowing": false, "isInit": false, "isOverriding": true, "hasClosureParams": false, "@type": "ClassMethod", "accessibility": "public", "parameterNames": "sample1, sample2, unit", "call": "between: sample1, and: sample2, in: unit", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("between"), name: "sample1", type: "SampleType", range: CountableRange(4922..<4949), nameRange: CountableRange(4922..<4929)), CuckooGeneratorFramework.MethodParameter(label: Optional("and"), name: "sample2", type: "SampleType", range: CountableRange(4951..<4974), nameRange: CountableRange(4951..<4954)), CuckooGeneratorFramework.MethodParameter(label: Optional("in"), name: "unit", type: "Calendar.Component", range: CountableRange(4976..<5017), nameRange: CountableRange(4976..<4978))], "returnType": "Int", "isOptional": false, "stubFunction": "Cuckoo.ClassStubFunction"]
//    public override func distance<SampleType: Sample>(between sample1: SampleType, and sample2: SampleType, in unit: Calendar.Component)  -> Int {
//
//            return cuckoo_manager.call("distance(between: SampleType, and: SampleType, in: Calendar.Component) -> Int",
//                parameters: (sample1, sample2, unit),
//                superclassCall:
//
//                    super.distance(between: sample1, and: sample2, in: unit)
//                    )
//
//    }
//
//
//	struct __StubbingProxy_SampleUtil: Cuckoo.StubbingProxy {
//	    private let cuckoo_manager: Cuckoo.MockManager
//
//	    init(manager: Cuckoo.MockManager) {
//	        self.cuckoo_manager = manager
//	    }
//
//
//	    func getOnly<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, SampleType: Sample>(samples: M1, from startDate: M2, to endDate: M3) -> Cuckoo.ClassStubFunction<([SampleType], Date?, Date?), [SampleType]> where M1.MatchedType == [SampleType], M2.MatchedType == Date?, M3.MatchedType == Date? {
//	        let matchers: [Cuckoo.ParameterMatcher<([SampleType], Date?, Date?)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: startDate) { $0.1 }, wrap(matchable: endDate) { $0.2 }]
//	        return .init(stub: cuckoo_manager.createStub(for: MockSampleUtil.self, method: "getOnly(samples: [SampleType], from: Date?, to: Date?) -> [SampleType]", parameterMatchers: matchers))
//	    }
//
//	    func sample<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ sample: M1, occursOnOneOf daysOfWeek: M2) -> Cuckoo.ClassStubFunction<(Sample, Set<DayOfWeek>), Bool> where M1.MatchedType == Sample, M2.MatchedType == Set<DayOfWeek> {
//	        let matchers: [Cuckoo.ParameterMatcher<(Sample, Set<DayOfWeek>)>] = [wrap(matchable: sample) { $0.0 }, wrap(matchable: daysOfWeek) { $0.1 }]
//	        return .init(stub: cuckoo_manager.createStub(for: MockSampleUtil.self, method: "sample(_: Sample, occursOnOneOf: Set<DayOfWeek>) -> Bool", parameterMatchers: matchers))
//	    }
//
//	    func aggregate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, SampleType: Sample>(samples: M1, by aggregationUnit: M2, dateType: M3) -> Cuckoo.ClassStubFunction<([SampleType], Calendar.Component, DateType), [Date: [SampleType]]> where M1.MatchedType == [SampleType], M2.MatchedType == Calendar.Component, M3.MatchedType == DateType {
//	        let matchers: [Cuckoo.ParameterMatcher<([SampleType], Calendar.Component, DateType)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: dateType) { $0.2 }]
//	        return .init(stub: cuckoo_manager.createStub(for: MockSampleUtil.self, method: "aggregate(samples: [SampleType], by: Calendar.Component, dateType: DateType) -> [Date: [SampleType]]", parameterMatchers: matchers))
//	    }
//
//	    func sort<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, SampleType: Sample>(samples: M1, by aggregationUnit: M2) -> Cuckoo.ClassStubFunction<([SampleType], Calendar.Component), [(date: Date, samples: [SampleType])]> where M1.MatchedType == [SampleType], M2.MatchedType == Calendar.Component {
//	        let matchers: [Cuckoo.ParameterMatcher<([SampleType], Calendar.Component)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }]
//	        return .init(stub: cuckoo_manager.createStub(for: MockSampleUtil.self, method: "sort(samples: [SampleType], by: Calendar.Component) -> [(date: Date, samples: [SampleType])]", parameterMatchers: matchers))
//	    }
//
//	    func sort<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, SampleType: Sample>(samples: M1, by dateType: M2) -> Cuckoo.ClassStubFunction<([SampleType], DateType), [SampleType]> where M1.MatchedType == [SampleType], M2.MatchedType == DateType {
//	        let matchers: [Cuckoo.ParameterMatcher<([SampleType], DateType)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: dateType) { $0.1 }]
//	        return .init(stub: cuckoo_manager.createStub(for: MockSampleUtil.self, method: "sort(samples: [SampleType], by: DateType) -> [SampleType]", parameterMatchers: matchers))
//	    }
//
//	    func convertOneDateSamplesToTwoDateSamples<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, SampleType: Sample>(_ samples: M1, samplesShouldNotBeJoined: M2, joinSamples: M3) -> Cuckoo.ClassStubFunction<([SampleType], (SampleType, SampleType) -> Bool, ([SampleType], Date, Date) -> SampleType), [SampleType]> where M1.MatchedType == [SampleType], M2.MatchedType == (SampleType, SampleType) -> Bool, M3.MatchedType == ([SampleType], Date, Date) -> SampleType {
//	        let matchers: [Cuckoo.ParameterMatcher<([SampleType], (SampleType, SampleType) -> Bool, ([SampleType], Date, Date) -> SampleType)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: samplesShouldNotBeJoined) { $0.1 }, wrap(matchable: joinSamples) { $0.2 }]
//	        return .init(stub: cuckoo_manager.createStub(for: MockSampleUtil.self, method: "convertOneDateSamplesToTwoDateSamples(_: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType) -> [SampleType]", parameterMatchers: matchers))
//	    }
//
//	    func closestInTimeTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, SampleType: Sample>(sample: M1, in samples: M2) -> Cuckoo.ClassStubFunction<(SampleType, [SampleType]), SampleType> where M1.MatchedType == SampleType, M2.MatchedType == [SampleType] {
//	        let matchers: [Cuckoo.ParameterMatcher<(SampleType, [SampleType])>] = [wrap(matchable: sample) { $0.0 }, wrap(matchable: samples) { $0.1 }]
//	        return .init(stub: cuckoo_manager.createStub(for: MockSampleUtil.self, method: "closestInTimeTo(sample: SampleType, in: [SampleType]) -> SampleType", parameterMatchers: matchers))
//	    }
//
//	    func distance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, SampleType: Sample>(between sample1: M1, and sample2: M2, in unit: M3) -> Cuckoo.ClassStubFunction<(SampleType, SampleType, Calendar.Component), Int> where M1.MatchedType == SampleType, M2.MatchedType == SampleType, M3.MatchedType == Calendar.Component {
//	        let matchers: [Cuckoo.ParameterMatcher<(SampleType, SampleType, Calendar.Component)>] = [wrap(matchable: sample1) { $0.0 }, wrap(matchable: sample2) { $0.1 }, wrap(matchable: unit) { $0.2 }]
//	        return .init(stub: cuckoo_manager.createStub(for: MockSampleUtil.self, method: "distance(between: SampleType, and: SampleType, in: Calendar.Component) -> Int", parameterMatchers: matchers))
//	    }
//
//	}
//
//	struct __VerificationProxy_SampleUtil: Cuckoo.VerificationProxy {
//	    private let cuckoo_manager: Cuckoo.MockManager
//	    private let callMatcher: Cuckoo.CallMatcher
//	    private let sourceLocation: Cuckoo.SourceLocation
//
//	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
//	        self.cuckoo_manager = manager
//	        self.callMatcher = callMatcher
//	        self.sourceLocation = sourceLocation
//	    }
//
//
//
//
//	    @discardableResult
//	    func getOnly<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, SampleType: Sample>(samples: M1, from startDate: M2, to endDate: M3) -> Cuckoo.__DoNotUse<[SampleType]> where M1.MatchedType == [SampleType], M2.MatchedType == Date?, M3.MatchedType == Date? {
//	        let matchers: [Cuckoo.ParameterMatcher<([SampleType], Date?, Date?)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: startDate) { $0.1 }, wrap(matchable: endDate) { $0.2 }]
//	        return cuckoo_manager.verify("getOnly(samples: [SampleType], from: Date?, to: Date?) -> [SampleType]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
//	    }
//
//	    @discardableResult
//	    func sample<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ sample: M1, occursOnOneOf daysOfWeek: M2) -> Cuckoo.__DoNotUse<Bool> where M1.MatchedType == Sample, M2.MatchedType == Set<DayOfWeek> {
//	        let matchers: [Cuckoo.ParameterMatcher<(Sample, Set<DayOfWeek>)>] = [wrap(matchable: sample) { $0.0 }, wrap(matchable: daysOfWeek) { $0.1 }]
//	        return cuckoo_manager.verify("sample(_: Sample, occursOnOneOf: Set<DayOfWeek>) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
//	    }
//
//	    @discardableResult
//	    func aggregate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, SampleType: Sample>(samples: M1, by aggregationUnit: M2, dateType: M3) -> Cuckoo.__DoNotUse<[Date: [SampleType]]> where M1.MatchedType == [SampleType], M2.MatchedType == Calendar.Component, M3.MatchedType == DateType {
//	        let matchers: [Cuckoo.ParameterMatcher<([SampleType], Calendar.Component, DateType)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }, wrap(matchable: dateType) { $0.2 }]
//	        return cuckoo_manager.verify("aggregate(samples: [SampleType], by: Calendar.Component, dateType: DateType) -> [Date: [SampleType]]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
//	    }
//
//	    @discardableResult
//	    func sort<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, SampleType: Sample>(samples: M1, by aggregationUnit: M2) -> Cuckoo.__DoNotUse<[(date: Date, samples: [SampleType])]> where M1.MatchedType == [SampleType], M2.MatchedType == Calendar.Component {
//	        let matchers: [Cuckoo.ParameterMatcher<([SampleType], Calendar.Component)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: aggregationUnit) { $0.1 }]
//	        return cuckoo_manager.verify("sort(samples: [SampleType], by: Calendar.Component) -> [(date: Date, samples: [SampleType])]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
//	    }
//
//	    @discardableResult
//	    func sort<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, SampleType: Sample>(samples: M1, by dateType: M2) -> Cuckoo.__DoNotUse<[SampleType]> where M1.MatchedType == [SampleType], M2.MatchedType == DateType {
//	        let matchers: [Cuckoo.ParameterMatcher<([SampleType], DateType)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: dateType) { $0.1 }]
//	        return cuckoo_manager.verify("sort(samples: [SampleType], by: DateType) -> [SampleType]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
//	    }
//
//	    @discardableResult
//	    func convertOneDateSamplesToTwoDateSamples<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, SampleType: Sample>(_ samples: M1, samplesShouldNotBeJoined: M2, joinSamples: M3) -> Cuckoo.__DoNotUse<[SampleType]> where M1.MatchedType == [SampleType], M2.MatchedType == (SampleType, SampleType) -> Bool, M3.MatchedType == ([SampleType], Date, Date) -> SampleType {
//	        let matchers: [Cuckoo.ParameterMatcher<([SampleType], (SampleType, SampleType) -> Bool, ([SampleType], Date, Date) -> SampleType)>] = [wrap(matchable: samples) { $0.0 }, wrap(matchable: samplesShouldNotBeJoined) { $0.1 }, wrap(matchable: joinSamples) { $0.2 }]
//	        return cuckoo_manager.verify("convertOneDateSamplesToTwoDateSamples(_: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType) -> [SampleType]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
//	    }
//
//	    @discardableResult
//	    func closestInTimeTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, SampleType: Sample>(sample: M1, in samples: M2) -> Cuckoo.__DoNotUse<SampleType> where M1.MatchedType == SampleType, M2.MatchedType == [SampleType] {
//	        let matchers: [Cuckoo.ParameterMatcher<(SampleType, [SampleType])>] = [wrap(matchable: sample) { $0.0 }, wrap(matchable: samples) { $0.1 }]
//	        return cuckoo_manager.verify("closestInTimeTo(sample: SampleType, in: [SampleType]) -> SampleType", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
//	    }
//
//	    @discardableResult
//	    func distance<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, SampleType: Sample>(between sample1: M1, and sample2: M2, in unit: M3) -> Cuckoo.__DoNotUse<Int> where M1.MatchedType == SampleType, M2.MatchedType == SampleType, M3.MatchedType == Calendar.Component {
//	        let matchers: [Cuckoo.ParameterMatcher<(SampleType, SampleType, Calendar.Component)>] = [wrap(matchable: sample1) { $0.0 }, wrap(matchable: sample2) { $0.1 }, wrap(matchable: unit) { $0.2 }]
//	        return cuckoo_manager.verify("distance(between: SampleType, and: SampleType, in: Calendar.Component) -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
//	    }
//
//	}
//
//}
//
// class SampleUtilStub: SampleUtil {
//
//    public override func getOnly<SampleType: Sample>(samples: [SampleType], from startDate: Date?, to endDate: Date?)  -> [SampleType] {
//        return DefaultValueRegistry.defaultValue(for: [SampleType].self)
//    }
//
//    public override func sample(_ sample: Sample, occursOnOneOf daysOfWeek: Set<DayOfWeek>)  -> Bool {
//        return DefaultValueRegistry.defaultValue(for: Bool.self)
//    }
//
//    public override func aggregate<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component, dateType: DateType)  -> [Date: [SampleType]] {
//        return DefaultValueRegistry.defaultValue(for: [Date: [SampleType]].self)
//    }
//
//    public override func sort<SampleType: Sample>(samples: [SampleType], by aggregationUnit: Calendar.Component)  -> [(date: Date, samples: [SampleType])] {
//        return DefaultValueRegistry.defaultValue(for: [(date: Date, samples: [SampleType])].self)
//    }
//
//    public override func sort<SampleType: Sample>(samples: [SampleType], by dateType: DateType)  -> [SampleType] {
//        return DefaultValueRegistry.defaultValue(for: [SampleType].self)
//    }
//
//    public override func convertOneDateSamplesToTwoDateSamples<SampleType: Sample>(_ samples: [SampleType], samplesShouldNotBeJoined: (SampleType, SampleType) -> Bool, joinSamples: ([SampleType], Date, Date) -> SampleType)  -> [SampleType] {
//        return DefaultValueRegistry.defaultValue(for: [SampleType].self)
//    }
//
//    public override func closestInTimeTo<SampleType: Sample>(sample: SampleType, in samples: [SampleType])  -> SampleType {
//        return DefaultValueRegistry.defaultValue(for: SampleType.self)
//    }
//
//    public override func distance<SampleType: Sample>(between sample1: SampleType, and sample2: SampleType, in unit: Calendar.Component)  -> Int {
//        return DefaultValueRegistry.defaultValue(for: Int.self)
//    }
//}
//
