// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.0.0

import SwiftyMocky
import XCTest
import HealthKit
import CoreData
import Presentr
import CSV
import SwiftDate
import UserNotifications
import Instructions
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import BooleanAlgebra
@testable import Common
@testable import DataExport
@testable import DataImport
@testable import DependencyInjection
@testable import Notifications
@testable import Persistence
@testable import Queries
@testable import SampleGroupers
@testable import SampleGroupInformation
@testable import Samples
@testable import Settings
@testable import UIExtensions


// MARK: - CodableStorage

open class CodableStorageMock: CodableStorage, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }

    private static func isCapturing<T>(_ param: Parameter<T>) -> Bool {
        switch param {
            // can't use `case .capturing(_, _):` here because it causes an EXC_BAD_ACCESS error
            case .value(_):
                return false
            case .matching(_):
                return false
            case ._:
                return false
            default:
                return true
        }
    }






    open func store<T: Encodable>(_ object: T, to directory: StorageDirectory, as fileName: String) throws {
        addInvocation(.m_store__objectto_directoryas_fileName(Parameter<T>.value(`object`).wrapAsGeneric(), Parameter<StorageDirectory>.value(`directory`), Parameter<String>.value(`fileName`)))
		let perform = methodPerformValue(.m_store__objectto_directoryas_fileName(Parameter<T>.value(`object`).wrapAsGeneric(), Parameter<StorageDirectory>.value(`directory`), Parameter<String>.value(`fileName`))) as? (T, StorageDirectory, String) -> Void
		perform?(`object`, `directory`, `fileName`)
		do {
		    _ = try methodReturnValue(.m_store__objectto_directoryas_fileName(Parameter<T>.value(`object`).wrapAsGeneric(), Parameter<StorageDirectory>.value(`directory`), Parameter<String>.value(`fileName`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func retrieve<T: Decodable>(_ fileName: String, from directory: StorageDirectory, as type: T.Type) throws -> T {
        addInvocation(.m_retrieve__fileNamefrom_directoryas_type(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`), Parameter<T.Type>.value(`type`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_retrieve__fileNamefrom_directoryas_type(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`), Parameter<T.Type>.value(`type`).wrapAsGeneric())) as? (String, StorageDirectory, T.Type) -> Void
		perform?(`fileName`, `directory`, `type`)
		var __value: T
		do {
		    __value = try methodReturnValue(.m_retrieve__fileNamefrom_directoryas_type(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`), Parameter<T.Type>.value(`type`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for retrieve<T: Decodable>(_ fileName: String, from directory: StorageDirectory, as type: T.Type). Use given")
			Failure("Stub return value not specified for retrieve<T: Decodable>(_ fileName: String, from directory: StorageDirectory, as type: T.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func clear(_ directory: StorageDirectory) throws {
        addInvocation(.m_clear__directory(Parameter<StorageDirectory>.value(`directory`)))
		let perform = methodPerformValue(.m_clear__directory(Parameter<StorageDirectory>.value(`directory`))) as? (StorageDirectory) -> Void
		perform?(`directory`)
		do {
		    _ = try methodReturnValue(.m_clear__directory(Parameter<StorageDirectory>.value(`directory`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func remove(_ fileName: String, from directory: StorageDirectory) throws {
        addInvocation(.m_remove__fileNamefrom_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`)))
		let perform = methodPerformValue(.m_remove__fileNamefrom_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`))) as? (String, StorageDirectory) -> Void
		perform?(`fileName`, `directory`)
		do {
		    _ = try methodReturnValue(.m_remove__fileNamefrom_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func fileExists(_ fileName: String, in directory: StorageDirectory) -> Bool {
        addInvocation(.m_fileExists__fileNamein_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`)))
		let perform = methodPerformValue(.m_fileExists__fileNamein_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`))) as? (String, StorageDirectory) -> Void
		perform?(`fileName`, `directory`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_fileExists__fileNamein_directory(Parameter<String>.value(`fileName`), Parameter<StorageDirectory>.value(`directory`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for fileExists(_ fileName: String, in directory: StorageDirectory). Use given")
			Failure("Stub return value not specified for fileExists(_ fileName: String, in directory: StorageDirectory). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_store__objectto_directoryas_fileName(Parameter<GenericAttribute>, Parameter<StorageDirectory>, Parameter<String>)
        case m_retrieve__fileNamefrom_directoryas_type(Parameter<String>, Parameter<StorageDirectory>, Parameter<GenericAttribute>)
        case m_clear__directory(Parameter<StorageDirectory>)
        case m_remove__fileNamefrom_directory(Parameter<String>, Parameter<StorageDirectory>)
        case m_fileExists__fileNamein_directory(Parameter<String>, Parameter<StorageDirectory>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_store__objectto_directoryas_fileName(let lhsObject, let lhsDirectory, let lhsFilename), .m_store__objectto_directoryas_fileName(let rhsObject, let rhsDirectory, let rhsFilename)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsObject) && !isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "_ object"))
				}


				if !isCapturing(lhsDirectory) && !isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "to directory"))
				}


				if !isCapturing(lhsFilename) && !isCapturing(rhsFilename) {
					comparison = Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFilename, rhsFilename, "as fileName"))
				}

				if isCapturing(lhsObject) || isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "_ object"))
				}


				if isCapturing(lhsDirectory) || isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "to directory"))
				}


				if isCapturing(lhsFilename) || isCapturing(rhsFilename) {
					comparison = Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFilename, rhsFilename, "as fileName"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_retrieve__fileNamefrom_directoryas_type(let lhsFilename, let lhsDirectory, let lhsType), .m_retrieve__fileNamefrom_directoryas_type(let rhsFilename, let rhsDirectory, let rhsType)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsFilename) && !isCapturing(rhsFilename) {
					comparison = Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFilename, rhsFilename, "_ fileName"))
				}


				if !isCapturing(lhsDirectory) && !isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "from directory"))
				}


				if !isCapturing(lhsType) && !isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "as type"))
				}

				if isCapturing(lhsFilename) || isCapturing(rhsFilename) {
					comparison = Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFilename, rhsFilename, "_ fileName"))
				}


				if isCapturing(lhsDirectory) || isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "from directory"))
				}


				if isCapturing(lhsType) || isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "as type"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_clear__directory(let lhsDirectory), .m_clear__directory(let rhsDirectory)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsDirectory) && !isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "_ directory"))
				}

				if isCapturing(lhsDirectory) || isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "_ directory"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_remove__fileNamefrom_directory(let lhsFilename, let lhsDirectory), .m_remove__fileNamefrom_directory(let rhsFilename, let rhsDirectory)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsFilename) && !isCapturing(rhsFilename) {
					comparison = Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFilename, rhsFilename, "_ fileName"))
				}


				if !isCapturing(lhsDirectory) && !isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "from directory"))
				}

				if isCapturing(lhsFilename) || isCapturing(rhsFilename) {
					comparison = Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFilename, rhsFilename, "_ fileName"))
				}


				if isCapturing(lhsDirectory) || isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "from directory"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_fileExists__fileNamein_directory(let lhsFilename, let lhsDirectory), .m_fileExists__fileNamein_directory(let rhsFilename, let rhsDirectory)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsFilename) && !isCapturing(rhsFilename) {
					comparison = Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFilename, rhsFilename, "_ fileName"))
				}


				if !isCapturing(lhsDirectory) && !isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "in directory"))
				}

				if isCapturing(lhsFilename) || isCapturing(rhsFilename) {
					comparison = Parameter.compare(lhs: lhsFilename, rhs: rhsFilename, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFilename, rhsFilename, "_ fileName"))
				}


				if isCapturing(lhsDirectory) || isCapturing(rhsDirectory) {
					comparison = Parameter.compare(lhs: lhsDirectory, rhs: rhsDirectory, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsDirectory, rhsDirectory, "in directory"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_store__objectto_directoryas_fileName(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_retrieve__fileNamefrom_directoryas_type(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_clear__directory(p0): return p0.intValue
            case let .m_remove__fileNamefrom_directory(p0, p1): return p0.intValue + p1.intValue
            case let .m_fileExists__fileNamein_directory(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_store__objectto_directoryas_fileName: return ".store(_:to:as:)"
            case .m_retrieve__fileNamefrom_directoryas_type: return ".retrieve(_:from:as:)"
            case .m_clear__directory: return ".clear(_:)"
            case .m_remove__fileNamefrom_directory: return ".remove(_:from:)"
            case .m_fileExists__fileNamein_directory: return ".fileExists(_:in:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func retrieve<T: Decodable>(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, as type: Parameter<T.Type>, willReturn: T...) -> MethodStub {
            return Given(method: .m_retrieve__fileNamefrom_directoryas_type(`fileName`, `directory`, `type`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func fileExists(_ fileName: Parameter<String>, in directory: Parameter<StorageDirectory>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_fileExists__fileNamein_directory(`fileName`, `directory`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func fileExists(_ fileName: Parameter<String>, in directory: Parameter<StorageDirectory>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_fileExists__fileNamein_directory(`fileName`, `directory`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func store<T:Encodable>(_ object: Parameter<T>, to directory: Parameter<StorageDirectory>, as fileName: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_store__objectto_directoryas_fileName(`object`.wrapAsGeneric(), `directory`, `fileName`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func store<T: Encodable>(_ object: Parameter<T>, to directory: Parameter<StorageDirectory>, as fileName: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_store__objectto_directoryas_fileName(`object`.wrapAsGeneric(), `directory`, `fileName`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func retrieve<T:Decodable>(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, as type: Parameter<T.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_retrieve__fileNamefrom_directoryas_type(`fileName`, `directory`, `type`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func retrieve<T: Decodable>(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, as type: Parameter<T.Type>, willProduce: (StubberThrows<T>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_retrieve__fileNamefrom_directoryas_type(`fileName`, `directory`, `type`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (T).self)
			willProduce(stubber)
			return given
        }
        public static func clear(_ directory: Parameter<StorageDirectory>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_clear__directory(`directory`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func clear(_ directory: Parameter<StorageDirectory>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_clear__directory(`directory`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func remove(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_remove__fileNamefrom_directory(`fileName`, `directory`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func remove(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_remove__fileNamefrom_directory(`fileName`, `directory`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func store<T>(_ object: Parameter<T>, to directory: Parameter<StorageDirectory>, as fileName: Parameter<String>) -> Verify where T:Encodable { return Verify(method: .m_store__objectto_directoryas_fileName(`object`.wrapAsGeneric(), `directory`, `fileName`))}
        public static func retrieve<T>(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, as type: Parameter<T.Type>) -> Verify where T:Decodable { return Verify(method: .m_retrieve__fileNamefrom_directoryas_type(`fileName`, `directory`, `type`.wrapAsGeneric()))}
        public static func clear(_ directory: Parameter<StorageDirectory>) -> Verify { return Verify(method: .m_clear__directory(`directory`))}
        public static func remove(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>) -> Verify { return Verify(method: .m_remove__fileNamefrom_directory(`fileName`, `directory`))}
        public static func fileExists(_ fileName: Parameter<String>, in directory: Parameter<StorageDirectory>) -> Verify { return Verify(method: .m_fileExists__fileNamein_directory(`fileName`, `directory`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func store<T>(_ object: Parameter<T>, to directory: Parameter<StorageDirectory>, as fileName: Parameter<String>, perform: @escaping (T, StorageDirectory, String) -> Void) -> Perform where T:Encodable {
            return Perform(method: .m_store__objectto_directoryas_fileName(`object`.wrapAsGeneric(), `directory`, `fileName`), performs: perform)
        }
        public static func retrieve<T>(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, as type: Parameter<T.Type>, perform: @escaping (String, StorageDirectory, T.Type) -> Void) -> Perform where T:Decodable {
            return Perform(method: .m_retrieve__fileNamefrom_directoryas_type(`fileName`, `directory`, `type`.wrapAsGeneric()), performs: perform)
        }
        public static func clear(_ directory: Parameter<StorageDirectory>, perform: @escaping (StorageDirectory) -> Void) -> Perform {
            return Perform(method: .m_clear__directory(`directory`), performs: perform)
        }
        public static func remove(_ fileName: Parameter<String>, from directory: Parameter<StorageDirectory>, perform: @escaping (String, StorageDirectory) -> Void) -> Perform {
            return Perform(method: .m_remove__fileNamefrom_directory(`fileName`, `directory`), performs: perform)
        }
        public static func fileExists(_ fileName: Parameter<String>, in directory: Parameter<StorageDirectory>, perform: @escaping (String, StorageDirectory) -> Void) -> Perform {
            return Perform(method: .m_fileExists__fileNamein_directory(`fileName`, `directory`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - Database

open class DatabaseMock: Database, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }

    private static func isCapturing<T>(_ param: Parameter<T>) -> Bool {
        switch param {
            // can't use `case .capturing(_, _):` here because it causes an EXC_BAD_ACCESS error
            case .value(_):
                return false
            case .matching(_):
                return false
            case ._:
                return false
            default:
                return true
        }
    }






    open func transaction() -> Transaction {
        addInvocation(.m_transaction)
		let perform = methodPerformValue(.m_transaction) as? () -> Void
		perform?()
		var __value: Transaction
		do {
		    __value = try methodReturnValue(.m_transaction).casted()
		} catch {
			onFatalFailure("Stub return value not specified for transaction(). Use given")
			Failure("Stub return value not specified for transaction(). Use given")
		}
		return __value
    }

    open func setModifiedExternally(_ modified: Bool) {
        addInvocation(.m_setModifiedExternally__modified(Parameter<Bool>.value(`modified`)))
		let perform = methodPerformValue(.m_setModifiedExternally__modified(Parameter<Bool>.value(`modified`))) as? (Bool) -> Void
		perform?(`modified`)
    }

    open func refreshContext() {
        addInvocation(.m_refreshContext)
		let perform = methodPerformValue(.m_refreshContext) as? () -> Void
		perform?()
    }

    open func fetchedResultsController<Type: NSManagedObject>(		type: Type.Type,		sortDescriptors: [NSSortDescriptor],		cacheName: String?	) -> NSFetchedResultsController<Type> {
        addInvocation(.m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(Parameter<Type.Type>.value(`type`).wrapAsGeneric(), Parameter<[NSSortDescriptor]>.value(`sortDescriptors`), Parameter<String?>.value(`cacheName`)))
		let perform = methodPerformValue(.m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(Parameter<Type.Type>.value(`type`).wrapAsGeneric(), Parameter<[NSSortDescriptor]>.value(`sortDescriptors`), Parameter<String?>.value(`cacheName`))) as? (Type.Type, [NSSortDescriptor], String?) -> Void
		perform?(`type`, `sortDescriptors`, `cacheName`)
		var __value: NSFetchedResultsController<Type>
		do {
		    __value = try methodReturnValue(.m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(Parameter<Type.Type>.value(`type`).wrapAsGeneric(), Parameter<[NSSortDescriptor]>.value(`sortDescriptors`), Parameter<String?>.value(`cacheName`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for fetchedResultsController<Type: NSManagedObject>(  type: Type.Type,  sortDescriptors: [NSSortDescriptor],  cacheName: String? ). Use given")
			Failure("Stub return value not specified for fetchedResultsController<Type: NSManagedObject>(  type: Type.Type,  sortDescriptors: [NSSortDescriptor],  cacheName: String? ). Use given")
		}
		return __value
    }

    open func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type] {
        addInvocation(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())) as? (NSFetchRequest<Type>) -> Void
		perform?(`fetchRequest`)
		var __value: [Type]
		do {
		    __value = try methodReturnValue(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>). Use given")
			Failure("Stub return value not specified for query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func count<Type: NSManagedObject>(_ type: Type.Type) throws -> Int {
        addInvocation(.m_count__type(Parameter<Type.Type>.value(`type`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_count__type(Parameter<Type.Type>.value(`type`).wrapAsGeneric())) as? (Type.Type) -> Void
		perform?(`type`)
		var __value: Int
		do {
		    __value = try methodReturnValue(.m_count__type(Parameter<Type.Type>.value(`type`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for count<Type: NSManagedObject>(_ type: Type.Type). Use given")
			Failure("Stub return value not specified for count<Type: NSManagedObject>(_ type: Type.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func count<Type: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<Type>) throws -> Int {
        addInvocation(.m_count__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_count__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())) as? (NSFetchRequest<Type>) -> Void
		perform?(`fetchRequest`)
		var __value: Int
		do {
		    __value = try methodReturnValue(.m_count__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for count<Type: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<Type>). Use given")
			Failure("Stub return value not specified for count<Type: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<Type>). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func pull<Type: NSManagedObject>(savedObject: Type) throws -> Type {
        addInvocation(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric())) as? (Type) -> Void
		perform?(`savedObject`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type). Use given")
			Failure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func pull<Type: NSManagedObject>(savedObject: Type, fromSameContextAs otherObject: NSManagedObject) throws -> Type {
        addInvocation(.m_pull__savedObject_savedObjectfromSameContextAs_otherObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObject>.value(`otherObject`)))
		let perform = methodPerformValue(.m_pull__savedObject_savedObjectfromSameContextAs_otherObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObject>.value(`otherObject`))) as? (Type, NSManagedObject) -> Void
		perform?(`savedObject`, `otherObject`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_pull__savedObject_savedObjectfromSameContextAs_otherObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObject>.value(`otherObject`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type, fromSameContextAs otherObject: NSManagedObject). Use given")
			Failure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type, fromSameContextAs otherObject: NSManagedObject). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func pull<Type: NSManagedObject>(savedObject: Type, fromContext context: NSManagedObjectContext) throws -> Type {
        addInvocation(.m_pull__savedObject_savedObjectfromContext_context(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObjectContext>.value(`context`)))
		let perform = methodPerformValue(.m_pull__savedObject_savedObjectfromContext_context(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObjectContext>.value(`context`))) as? (Type, NSManagedObjectContext) -> Void
		perform?(`savedObject`, `context`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_pull__savedObject_savedObjectfromContext_context(Parameter<Type>.value(`savedObject`).wrapAsGeneric(), Parameter<NSManagedObjectContext>.value(`context`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type, fromContext context: NSManagedObjectContext). Use given")
			Failure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type, fromContext context: NSManagedObjectContext). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func deleteEverything() throws {
        addInvocation(.m_deleteEverything)
		let perform = methodPerformValue(.m_deleteEverything) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_deleteEverything).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func cleanUpManagedObjectWithStrongReferenceCycle<Type: NSManagedObject>(_ object: Type) {
        addInvocation(.m_cleanUpManagedObjectWithStrongReferenceCycle__object(Parameter<Type>.value(`object`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_cleanUpManagedObjectWithStrongReferenceCycle__object(Parameter<Type>.value(`object`).wrapAsGeneric())) as? (Type) -> Void
		perform?(`object`)
    }


    fileprivate enum MethodType {
        case m_transaction
        case m_setModifiedExternally__modified(Parameter<Bool>)
        case m_refreshContext
        case m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(Parameter<GenericAttribute>, Parameter<[NSSortDescriptor]>, Parameter<String?>)
        case m_query__fetchRequest(Parameter<GenericAttribute>)
        case m_count__type(Parameter<GenericAttribute>)
        case m_count__fetchRequest(Parameter<GenericAttribute>)
        case m_pull__savedObject_savedObject(Parameter<GenericAttribute>)
        case m_pull__savedObject_savedObjectfromSameContextAs_otherObject(Parameter<GenericAttribute>, Parameter<NSManagedObject>)
        case m_pull__savedObject_savedObjectfromContext_context(Parameter<GenericAttribute>, Parameter<NSManagedObjectContext>)
        case m_deleteEverything
        case m_cleanUpManagedObjectWithStrongReferenceCycle__object(Parameter<GenericAttribute>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_transaction, .m_transaction): return .match

            case (.m_setModifiedExternally__modified(let lhsModified), .m_setModifiedExternally__modified(let rhsModified)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsModified) && !isCapturing(rhsModified) {
					comparison = Parameter.compare(lhs: lhsModified, rhs: rhsModified, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsModified, rhsModified, "_ modified"))
				}

				if isCapturing(lhsModified) || isCapturing(rhsModified) {
					comparison = Parameter.compare(lhs: lhsModified, rhs: rhsModified, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsModified, rhsModified, "_ modified"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_refreshContext, .m_refreshContext): return .match

            case (.m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(let lhsType, let lhsSortdescriptors, let lhsCachename), .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(let rhsType, let rhsSortdescriptors, let rhsCachename)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsType) && !isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "type"))
				}


				if !isCapturing(lhsSortdescriptors) && !isCapturing(rhsSortdescriptors) {
					comparison = Parameter.compare(lhs: lhsSortdescriptors, rhs: rhsSortdescriptors, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSortdescriptors, rhsSortdescriptors, "sortDescriptors"))
				}


				if !isCapturing(lhsCachename) && !isCapturing(rhsCachename) {
					comparison = Parameter.compare(lhs: lhsCachename, rhs: rhsCachename, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCachename, rhsCachename, "cacheName"))
				}

				if isCapturing(lhsType) || isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "type"))
				}


				if isCapturing(lhsSortdescriptors) || isCapturing(rhsSortdescriptors) {
					comparison = Parameter.compare(lhs: lhsSortdescriptors, rhs: rhsSortdescriptors, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSortdescriptors, rhsSortdescriptors, "sortDescriptors"))
				}


				if isCapturing(lhsCachename) || isCapturing(rhsCachename) {
					comparison = Parameter.compare(lhs: lhsCachename, rhs: rhsCachename, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCachename, rhsCachename, "cacheName"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_query__fetchRequest(let lhsFetchrequest), .m_query__fetchRequest(let rhsFetchrequest)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsFetchrequest) && !isCapturing(rhsFetchrequest) {
					comparison = Parameter.compare(lhs: lhsFetchrequest, rhs: rhsFetchrequest, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFetchrequest, rhsFetchrequest, "_ fetchRequest"))
				}

				if isCapturing(lhsFetchrequest) || isCapturing(rhsFetchrequest) {
					comparison = Parameter.compare(lhs: lhsFetchrequest, rhs: rhsFetchrequest, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFetchrequest, rhsFetchrequest, "_ fetchRequest"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_count__type(let lhsType), .m_count__type(let rhsType)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsType) && !isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "_ type"))
				}

				if isCapturing(lhsType) || isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "_ type"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_count__fetchRequest(let lhsFetchrequest), .m_count__fetchRequest(let rhsFetchrequest)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsFetchrequest) && !isCapturing(rhsFetchrequest) {
					comparison = Parameter.compare(lhs: lhsFetchrequest, rhs: rhsFetchrequest, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFetchrequest, rhsFetchrequest, "_ fetchRequest"))
				}

				if isCapturing(lhsFetchrequest) || isCapturing(rhsFetchrequest) {
					comparison = Parameter.compare(lhs: lhsFetchrequest, rhs: rhsFetchrequest, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFetchrequest, rhsFetchrequest, "_ fetchRequest"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_pull__savedObject_savedObject(let lhsSavedobject), .m_pull__savedObject_savedObject(let rhsSavedobject)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSavedobject) && !isCapturing(rhsSavedobject) {
					comparison = Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSavedobject, rhsSavedobject, "savedObject"))
				}

				if isCapturing(lhsSavedobject) || isCapturing(rhsSavedobject) {
					comparison = Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSavedobject, rhsSavedobject, "savedObject"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_pull__savedObject_savedObjectfromSameContextAs_otherObject(let lhsSavedobject, let lhsOtherobject), .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(let rhsSavedobject, let rhsOtherobject)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSavedobject) && !isCapturing(rhsSavedobject) {
					comparison = Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSavedobject, rhsSavedobject, "savedObject"))
				}


				if !isCapturing(lhsOtherobject) && !isCapturing(rhsOtherobject) {
					comparison = Parameter.compare(lhs: lhsOtherobject, rhs: rhsOtherobject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOtherobject, rhsOtherobject, "fromSameContextAs otherObject"))
				}

				if isCapturing(lhsSavedobject) || isCapturing(rhsSavedobject) {
					comparison = Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSavedobject, rhsSavedobject, "savedObject"))
				}


				if isCapturing(lhsOtherobject) || isCapturing(rhsOtherobject) {
					comparison = Parameter.compare(lhs: lhsOtherobject, rhs: rhsOtherobject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsOtherobject, rhsOtherobject, "fromSameContextAs otherObject"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_pull__savedObject_savedObjectfromContext_context(let lhsSavedobject, let lhsContext), .m_pull__savedObject_savedObjectfromContext_context(let rhsSavedobject, let rhsContext)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSavedobject) && !isCapturing(rhsSavedobject) {
					comparison = Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSavedobject, rhsSavedobject, "savedObject"))
				}


				if !isCapturing(lhsContext) && !isCapturing(rhsContext) {
					comparison = Parameter.compare(lhs: lhsContext, rhs: rhsContext, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsContext, rhsContext, "fromContext context"))
				}

				if isCapturing(lhsSavedobject) || isCapturing(rhsSavedobject) {
					comparison = Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSavedobject, rhsSavedobject, "savedObject"))
				}


				if isCapturing(lhsContext) || isCapturing(rhsContext) {
					comparison = Parameter.compare(lhs: lhsContext, rhs: rhsContext, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsContext, rhsContext, "fromContext context"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_deleteEverything, .m_deleteEverything): return .match

            case (.m_cleanUpManagedObjectWithStrongReferenceCycle__object(let lhsObject), .m_cleanUpManagedObjectWithStrongReferenceCycle__object(let rhsObject)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsObject) && !isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "_ object"))
				}

				if isCapturing(lhsObject) || isCapturing(rhsObject) {
					comparison = Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObject, rhsObject, "_ object"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_transaction: return 0
            case let .m_setModifiedExternally__modified(p0): return p0.intValue
            case .m_refreshContext: return 0
            case let .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_query__fetchRequest(p0): return p0.intValue
            case let .m_count__type(p0): return p0.intValue
            case let .m_count__fetchRequest(p0): return p0.intValue
            case let .m_pull__savedObject_savedObject(p0): return p0.intValue
            case let .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(p0, p1): return p0.intValue + p1.intValue
            case let .m_pull__savedObject_savedObjectfromContext_context(p0, p1): return p0.intValue + p1.intValue
            case .m_deleteEverything: return 0
            case let .m_cleanUpManagedObjectWithStrongReferenceCycle__object(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_transaction: return ".transaction()"
            case .m_setModifiedExternally__modified: return ".setModifiedExternally(_:)"
            case .m_refreshContext: return ".refreshContext()"
            case .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName: return ".fetchedResultsController(type:sortDescriptors:cacheName:)"
            case .m_query__fetchRequest: return ".query(_:)"
            case .m_count__type: return ".count(_:)"
            case .m_count__fetchRequest: return ".count(_:)"
            case .m_pull__savedObject_savedObject: return ".pull(savedObject:)"
            case .m_pull__savedObject_savedObjectfromSameContextAs_otherObject: return ".pull(savedObject:fromSameContextAs:)"
            case .m_pull__savedObject_savedObjectfromContext_context: return ".pull(savedObject:fromContext:)"
            case .m_deleteEverything: return ".deleteEverything()"
            case .m_cleanUpManagedObjectWithStrongReferenceCycle__object: return ".cleanUpManagedObjectWithStrongReferenceCycle(_:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func transaction(willReturn: Transaction...) -> MethodStub {
            return Given(method: .m_transaction, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func fetchedResultsController<Type: NSManagedObject>(type: Parameter<Type.Type>, sortDescriptors: Parameter<[NSSortDescriptor]>, cacheName: Parameter<String?>, willReturn: NSFetchedResultsController<Type>...) -> MethodStub {
            return Given(method: .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(`type`.wrapAsGeneric(), `sortDescriptors`, `cacheName`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func query<Type: NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willReturn: [Type]...) -> MethodStub {
            return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func count<Type: NSManagedObject>(_ type: Parameter<Type.Type>, willReturn: Int...) -> MethodStub {
            return Given(method: .m_count__type(`type`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func count<Type: NSFetchRequestResult>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willReturn: Int...) -> MethodStub {
            return Given(method: .m_count__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, fromSameContextAs otherObject: Parameter<NSManagedObject>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(`savedObject`.wrapAsGeneric(), `otherObject`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, fromContext context: Parameter<NSManagedObjectContext>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObjectfromContext_context(`savedObject`.wrapAsGeneric(), `context`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func transaction(willProduce: (Stubber<Transaction>) -> Void) -> MethodStub {
            let willReturn: [Transaction] = []
			let given: Given = { return Given(method: .m_transaction, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Transaction).self)
			willProduce(stubber)
			return given
        }
        public static func fetchedResultsController<Type: NSManagedObject>(type: Parameter<Type.Type>, sortDescriptors: Parameter<[NSSortDescriptor]>, cacheName: Parameter<String?>, willProduce: (Stubber<NSFetchedResultsController<Type>>) -> Void) -> MethodStub {
            let willReturn: [NSFetchedResultsController<Type>] = []
			let given: Given = { return Given(method: .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(`type`.wrapAsGeneric(), `sortDescriptors`, `cacheName`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (NSFetchedResultsController<Type>).self)
			willProduce(stubber)
			return given
        }
        public static func query<Type:NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func query<Type: NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willProduce: (StubberThrows<[Type]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Type]).self)
			willProduce(stubber)
			return given
        }
        public static func count<Type:NSManagedObject>(_ type: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_count__type(`type`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func count<Type: NSManagedObject>(_ type: Parameter<Type.Type>, willProduce: (StubberThrows<Int>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_count__type(`type`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Int).self)
			willProduce(stubber)
			return given
        }
        public static func count<Type:NSFetchRequestResult>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_count__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func count<Type: NSFetchRequestResult>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willProduce: (StubberThrows<Int>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_count__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Int).self)
			willProduce(stubber)
			return given
        }
        public static func pull<Type:NSManagedObject>(savedObject: Parameter<Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func pull<Type:NSManagedObject>(savedObject: Parameter<Type>, fromSameContextAs otherObject: Parameter<NSManagedObject>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(`savedObject`.wrapAsGeneric(), `otherObject`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, fromSameContextAs otherObject: Parameter<NSManagedObject>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(`savedObject`.wrapAsGeneric(), `otherObject`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func pull<Type:NSManagedObject>(savedObject: Parameter<Type>, fromContext context: Parameter<NSManagedObjectContext>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObjectfromContext_context(`savedObject`.wrapAsGeneric(), `context`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, fromContext context: Parameter<NSManagedObjectContext>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_pull__savedObject_savedObjectfromContext_context(`savedObject`.wrapAsGeneric(), `context`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func deleteEverything(willThrow: Error...) -> MethodStub {
            return Given(method: .m_deleteEverything, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func deleteEverything(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_deleteEverything, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func transaction() -> Verify { return Verify(method: .m_transaction)}
        public static func setModifiedExternally(_ modified: Parameter<Bool>) -> Verify { return Verify(method: .m_setModifiedExternally__modified(`modified`))}
        public static func refreshContext() -> Verify { return Verify(method: .m_refreshContext)}
        public static func fetchedResultsController<Type>(type: Parameter<Type.Type>, sortDescriptors: Parameter<[NSSortDescriptor]>, cacheName: Parameter<String?>) -> Verify where Type:NSManagedObject { return Verify(method: .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(`type`.wrapAsGeneric(), `sortDescriptors`, `cacheName`))}
        public static func query<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>) -> Verify where Type:NSManagedObject { return Verify(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()))}
        public static func count<Type>(_ type: Parameter<Type.Type>) -> Verify where Type:NSManagedObject { return Verify(method: .m_count__type(`type`.wrapAsGeneric()))}
        public static func count<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>) -> Verify where Type:NSFetchRequestResult { return Verify(method: .m_count__fetchRequest(`fetchRequest`.wrapAsGeneric()))}
        public static func pull<Type>(savedObject: Parameter<Type>) -> Verify where Type:NSManagedObject { return Verify(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()))}
        public static func pull<Type>(savedObject: Parameter<Type>, fromSameContextAs otherObject: Parameter<NSManagedObject>) -> Verify where Type:NSManagedObject { return Verify(method: .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(`savedObject`.wrapAsGeneric(), `otherObject`))}
        public static func pull<Type>(savedObject: Parameter<Type>, fromContext context: Parameter<NSManagedObjectContext>) -> Verify where Type:NSManagedObject { return Verify(method: .m_pull__savedObject_savedObjectfromContext_context(`savedObject`.wrapAsGeneric(), `context`))}
        public static func deleteEverything() -> Verify { return Verify(method: .m_deleteEverything)}
        public static func cleanUpManagedObjectWithStrongReferenceCycle<Type>(_ object: Parameter<Type>) -> Verify where Type:NSManagedObject { return Verify(method: .m_cleanUpManagedObjectWithStrongReferenceCycle__object(`object`.wrapAsGeneric()))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func transaction(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_transaction, performs: perform)
        }
        public static func setModifiedExternally(_ modified: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_setModifiedExternally__modified(`modified`), performs: perform)
        }
        public static func refreshContext(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_refreshContext, performs: perform)
        }
        public static func fetchedResultsController<Type>(type: Parameter<Type.Type>, sortDescriptors: Parameter<[NSSortDescriptor]>, cacheName: Parameter<String?>, perform: @escaping (Type.Type, [NSSortDescriptor], String?) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_fetchedResultsController__type_typesortDescriptors_sortDescriptorscacheName_cacheName(`type`.wrapAsGeneric(), `sortDescriptors`, `cacheName`), performs: perform)
        }
        public static func query<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, perform: @escaping (NSFetchRequest<Type>) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), performs: perform)
        }
        public static func count<Type>(_ type: Parameter<Type.Type>, perform: @escaping (Type.Type) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_count__type(`type`.wrapAsGeneric()), performs: perform)
        }
        public static func count<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, perform: @escaping (NSFetchRequest<Type>) -> Void) -> Perform where Type:NSFetchRequestResult {
            return Perform(method: .m_count__fetchRequest(`fetchRequest`.wrapAsGeneric()), performs: perform)
        }
        public static func pull<Type>(savedObject: Parameter<Type>, perform: @escaping (Type) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), performs: perform)
        }
        public static func pull<Type>(savedObject: Parameter<Type>, fromSameContextAs otherObject: Parameter<NSManagedObject>, perform: @escaping (Type, NSManagedObject) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_pull__savedObject_savedObjectfromSameContextAs_otherObject(`savedObject`.wrapAsGeneric(), `otherObject`), performs: perform)
        }
        public static func pull<Type>(savedObject: Parameter<Type>, fromContext context: Parameter<NSManagedObjectContext>, perform: @escaping (Type, NSManagedObjectContext) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_pull__savedObject_savedObjectfromContext_context(`savedObject`.wrapAsGeneric(), `context`), performs: perform)
        }
        public static func deleteEverything(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_deleteEverything, performs: perform)
        }
        public static func cleanUpManagedObjectWithStrongReferenceCycle<Type>(_ object: Parameter<Type>, perform: @escaping (Type) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_cleanUpManagedObjectWithStrongReferenceCycle__object(`object`.wrapAsGeneric()), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - Transaction

open class TransactionMock: Transaction, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }

    private static func isCapturing<T>(_ param: Parameter<T>) -> Bool {
        switch param {
            // can't use `case .capturing(_, _):` here because it causes an EXC_BAD_ACCESS error
            case .value(_):
                return false
            case .matching(_):
                return false
            case ._:
                return false
            default:
                return true
        }
    }






    open func childTransaction() -> Transaction {
        addInvocation(.m_childTransaction)
		let perform = methodPerformValue(.m_childTransaction) as? () -> Void
		perform?()
		var __value: Transaction
		do {
		    __value = try methodReturnValue(.m_childTransaction).casted()
		} catch {
			onFatalFailure("Stub return value not specified for childTransaction(). Use given")
			Failure("Stub return value not specified for childTransaction(). Use given")
		}
		return __value
    }

    open func commit() throws {
        addInvocation(.m_commit)
		let perform = methodPerformValue(.m_commit) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_commit).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func reset() {
        addInvocation(.m_reset)
		let perform = methodPerformValue(.m_reset) as? () -> Void
		perform?()
    }

    open func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type] {
        addInvocation(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())) as? (NSFetchRequest<Type>) -> Void
		perform?(`fetchRequest`)
		var __value: [Type]
		do {
		    __value = try methodReturnValue(.m_query__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>). Use given")
			Failure("Stub return value not specified for query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func count<Type: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<Type>) throws -> Int {
        addInvocation(.m_count__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_count__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())) as? (NSFetchRequest<Type>) -> Void
		perform?(`fetchRequest`)
		var __value: Int
		do {
		    __value = try methodReturnValue(.m_count__fetchRequest(Parameter<NSFetchRequest<Type>>.value(`fetchRequest`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for count<Type: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<Type>). Use given")
			Failure("Stub return value not specified for count<Type: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<Type>). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type) throws -> Type {
        addInvocation(.m_new__objectType(Parameter<Type.Type>.value(`objectType`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_new__objectType(Parameter<Type.Type>.value(`objectType`).wrapAsGeneric())) as? (Type.Type) -> Void
		perform?(`objectType`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_new__objectType(Parameter<Type.Type>.value(`objectType`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type). Use given")
			Failure("Stub return value not specified for new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type) -> NSBatchUpdateRequest {
        addInvocation(.m_batchUpdateRequest__for_type(Parameter<Type.Type>.value(`type`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_batchUpdateRequest__for_type(Parameter<Type.Type>.value(`type`).wrapAsGeneric())) as? (Type.Type) -> Void
		perform?(`type`)
		var __value: NSBatchUpdateRequest
		do {
		    __value = try methodReturnValue(.m_batchUpdateRequest__for_type(Parameter<Type.Type>.value(`type`).wrapAsGeneric())).casted()
		} catch {
			onFatalFailure("Stub return value not specified for batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type). Use given")
			Failure("Stub return value not specified for batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type). Use given")
		}
		return __value
    }

    open func batchUpdate(_ request: NSBatchUpdateRequest) throws -> NSBatchUpdateResult {
        addInvocation(.m_batchUpdate__request(Parameter<NSBatchUpdateRequest>.value(`request`)))
		let perform = methodPerformValue(.m_batchUpdate__request(Parameter<NSBatchUpdateRequest>.value(`request`))) as? (NSBatchUpdateRequest) -> Void
		perform?(`request`)
		var __value: NSBatchUpdateResult
		do {
		    __value = try methodReturnValue(.m_batchUpdate__request(Parameter<NSBatchUpdateRequest>.value(`request`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for batchUpdate(_ request: NSBatchUpdateRequest). Use given")
			Failure("Stub return value not specified for batchUpdate(_ request: NSBatchUpdateRequest). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func pull<Type: NSManagedObject>(savedObject: Type) throws -> Type {
        addInvocation(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric()))
		let perform = methodPerformValue(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric())) as? (Type) -> Void
		perform?(`savedObject`)
		var __value: Type
		do {
		    __value = try methodReturnValue(.m_pull__savedObject_savedObject(Parameter<Type>.value(`savedObject`).wrapAsGeneric())).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type). Use given")
			Failure("Stub return value not specified for pull<Type: NSManagedObject>(savedObject: Type). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func delete(_ coreDataObject: CoreDataObject) throws {
        addInvocation(.m_delete__coreDataObject(Parameter<CoreDataObject>.value(`coreDataObject`)))
		let perform = methodPerformValue(.m_delete__coreDataObject(Parameter<CoreDataObject>.value(`coreDataObject`))) as? (CoreDataObject) -> Void
		perform?(`coreDataObject`)
		do {
		    _ = try methodReturnValue(.m_delete__coreDataObject(Parameter<CoreDataObject>.value(`coreDataObject`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func deleteAll(_ objects: [NSManagedObject]) throws {
        addInvocation(.m_deleteAll__objects(Parameter<[NSManagedObject]>.value(`objects`)))
		let perform = methodPerformValue(.m_deleteAll__objects(Parameter<[NSManagedObject]>.value(`objects`))) as? ([NSManagedObject]) -> Void
		perform?(`objects`)
		do {
		    _ = try methodReturnValue(.m_deleteAll__objects(Parameter<[NSManagedObject]>.value(`objects`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func deleteAll(_ objectType: NSManagedObject.Type) throws {
        addInvocation(.m_deleteAll__objectType(Parameter<NSManagedObject.Type>.value(`objectType`)))
		let perform = methodPerformValue(.m_deleteAll__objectType(Parameter<NSManagedObject.Type>.value(`objectType`))) as? (NSManagedObject.Type) -> Void
		perform?(`objectType`)
		do {
		    _ = try methodReturnValue(.m_deleteAll__objectType(Parameter<NSManagedObject.Type>.value(`objectType`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func deleteAll(_ entityName: String) throws {
        addInvocation(.m_deleteAll__entityName(Parameter<String>.value(`entityName`)))
		let perform = methodPerformValue(.m_deleteAll__entityName(Parameter<String>.value(`entityName`))) as? (String) -> Void
		perform?(`entityName`)
		do {
		    _ = try methodReturnValue(.m_deleteAll__entityName(Parameter<String>.value(`entityName`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }


    fileprivate enum MethodType {
        case m_childTransaction
        case m_commit
        case m_reset
        case m_query__fetchRequest(Parameter<GenericAttribute>)
        case m_count__fetchRequest(Parameter<GenericAttribute>)
        case m_new__objectType(Parameter<GenericAttribute>)
        case m_batchUpdateRequest__for_type(Parameter<GenericAttribute>)
        case m_batchUpdate__request(Parameter<NSBatchUpdateRequest>)
        case m_pull__savedObject_savedObject(Parameter<GenericAttribute>)
        case m_delete__coreDataObject(Parameter<CoreDataObject>)
        case m_deleteAll__objects(Parameter<[NSManagedObject]>)
        case m_deleteAll__objectType(Parameter<NSManagedObject.Type>)
        case m_deleteAll__entityName(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_childTransaction, .m_childTransaction): return .match

            case (.m_commit, .m_commit): return .match

            case (.m_reset, .m_reset): return .match

            case (.m_query__fetchRequest(let lhsFetchrequest), .m_query__fetchRequest(let rhsFetchrequest)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsFetchrequest) && !isCapturing(rhsFetchrequest) {
					comparison = Parameter.compare(lhs: lhsFetchrequest, rhs: rhsFetchrequest, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFetchrequest, rhsFetchrequest, "_ fetchRequest"))
				}

				if isCapturing(lhsFetchrequest) || isCapturing(rhsFetchrequest) {
					comparison = Parameter.compare(lhs: lhsFetchrequest, rhs: rhsFetchrequest, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFetchrequest, rhsFetchrequest, "_ fetchRequest"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_count__fetchRequest(let lhsFetchrequest), .m_count__fetchRequest(let rhsFetchrequest)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsFetchrequest) && !isCapturing(rhsFetchrequest) {
					comparison = Parameter.compare(lhs: lhsFetchrequest, rhs: rhsFetchrequest, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFetchrequest, rhsFetchrequest, "_ fetchRequest"))
				}

				if isCapturing(lhsFetchrequest) || isCapturing(rhsFetchrequest) {
					comparison = Parameter.compare(lhs: lhsFetchrequest, rhs: rhsFetchrequest, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsFetchrequest, rhsFetchrequest, "_ fetchRequest"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_new__objectType(let lhsObjecttype), .m_new__objectType(let rhsObjecttype)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsObjecttype) && !isCapturing(rhsObjecttype) {
					comparison = Parameter.compare(lhs: lhsObjecttype, rhs: rhsObjecttype, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObjecttype, rhsObjecttype, "_ objectType"))
				}

				if isCapturing(lhsObjecttype) || isCapturing(rhsObjecttype) {
					comparison = Parameter.compare(lhs: lhsObjecttype, rhs: rhsObjecttype, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObjecttype, rhsObjecttype, "_ objectType"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_batchUpdateRequest__for_type(let lhsType), .m_batchUpdateRequest__for_type(let rhsType)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsType) && !isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "for type"))
				}

				if isCapturing(lhsType) || isCapturing(rhsType) {
					comparison = Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsType, rhsType, "for type"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_batchUpdate__request(let lhsRequest), .m_batchUpdate__request(let rhsRequest)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsRequest) && !isCapturing(rhsRequest) {
					comparison = Parameter.compare(lhs: lhsRequest, rhs: rhsRequest, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRequest, rhsRequest, "_ request"))
				}

				if isCapturing(lhsRequest) || isCapturing(rhsRequest) {
					comparison = Parameter.compare(lhs: lhsRequest, rhs: rhsRequest, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsRequest, rhsRequest, "_ request"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_pull__savedObject_savedObject(let lhsSavedobject), .m_pull__savedObject_savedObject(let rhsSavedobject)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsSavedobject) && !isCapturing(rhsSavedobject) {
					comparison = Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSavedobject, rhsSavedobject, "savedObject"))
				}

				if isCapturing(lhsSavedobject) || isCapturing(rhsSavedobject) {
					comparison = Parameter.compare(lhs: lhsSavedobject, rhs: rhsSavedobject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsSavedobject, rhsSavedobject, "savedObject"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_delete__coreDataObject(let lhsCoredataobject), .m_delete__coreDataObject(let rhsCoredataobject)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsCoredataobject) && !isCapturing(rhsCoredataobject) {
					comparison = Parameter.compare(lhs: lhsCoredataobject, rhs: rhsCoredataobject, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCoredataobject, rhsCoredataobject, "_ coreDataObject"))
				}

				if isCapturing(lhsCoredataobject) || isCapturing(rhsCoredataobject) {
					comparison = Parameter.compare(lhs: lhsCoredataobject, rhs: rhsCoredataobject, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsCoredataobject, rhsCoredataobject, "_ coreDataObject"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_deleteAll__objects(let lhsObjects), .m_deleteAll__objects(let rhsObjects)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsObjects) && !isCapturing(rhsObjects) {
					comparison = Parameter.compare(lhs: lhsObjects, rhs: rhsObjects, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObjects, rhsObjects, "_ objects"))
				}

				if isCapturing(lhsObjects) || isCapturing(rhsObjects) {
					comparison = Parameter.compare(lhs: lhsObjects, rhs: rhsObjects, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObjects, rhsObjects, "_ objects"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_deleteAll__objectType(let lhsObjecttype), .m_deleteAll__objectType(let rhsObjecttype)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsObjecttype) && !isCapturing(rhsObjecttype) {
					comparison = Parameter.compare(lhs: lhsObjecttype, rhs: rhsObjecttype, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObjecttype, rhsObjecttype, "_ objectType"))
				}

				if isCapturing(lhsObjecttype) || isCapturing(rhsObjecttype) {
					comparison = Parameter.compare(lhs: lhsObjecttype, rhs: rhsObjecttype, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsObjecttype, rhsObjecttype, "_ objectType"))
				}

				return Matcher.ComparisonResult(results)

            case (.m_deleteAll__entityName(let lhsEntityname), .m_deleteAll__entityName(let rhsEntityname)):
				var noncapturingComparisons: [Bool] = []
				var comparison: Bool
				var results: [Matcher.ParameterComparisonResult] = []

				if !isCapturing(lhsEntityname) && !isCapturing(rhsEntityname) {
					comparison = Parameter.compare(lhs: lhsEntityname, rhs: rhsEntityname, with: matcher)
					noncapturingComparisons.append(comparison)
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEntityname, rhsEntityname, "_ entityName"))
				}

				if isCapturing(lhsEntityname) || isCapturing(rhsEntityname) {
					comparison = Parameter.compare(lhs: lhsEntityname, rhs: rhsEntityname, with: matcher, nonCapturingParamsMatch: noncapturingComparisons.allSatisfy({$0}))
					results.append(Matcher.ParameterComparisonResult(comparison, lhsEntityname, rhsEntityname, "_ entityName"))
				}

				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_childTransaction: return 0
            case .m_commit: return 0
            case .m_reset: return 0
            case let .m_query__fetchRequest(p0): return p0.intValue
            case let .m_count__fetchRequest(p0): return p0.intValue
            case let .m_new__objectType(p0): return p0.intValue
            case let .m_batchUpdateRequest__for_type(p0): return p0.intValue
            case let .m_batchUpdate__request(p0): return p0.intValue
            case let .m_pull__savedObject_savedObject(p0): return p0.intValue
            case let .m_delete__coreDataObject(p0): return p0.intValue
            case let .m_deleteAll__objects(p0): return p0.intValue
            case let .m_deleteAll__objectType(p0): return p0.intValue
            case let .m_deleteAll__entityName(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_childTransaction: return ".childTransaction()"
            case .m_commit: return ".commit()"
            case .m_reset: return ".reset()"
            case .m_query__fetchRequest: return ".query(_:)"
            case .m_count__fetchRequest: return ".count(_:)"
            case .m_new__objectType: return ".new(_:)"
            case .m_batchUpdateRequest__for_type: return ".batchUpdateRequest(for:)"
            case .m_batchUpdate__request: return ".batchUpdate(_:)"
            case .m_pull__savedObject_savedObject: return ".pull(savedObject:)"
            case .m_delete__coreDataObject: return ".delete(_:)"
            case .m_deleteAll__objects: return ".deleteAll(_:)"
            case .m_deleteAll__objectType: return ".deleteAll(_:)"
            case .m_deleteAll__entityName: return ".deleteAll(_:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func childTransaction(willReturn: Transaction...) -> MethodStub {
            return Given(method: .m_childTransaction, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func query<Type: NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willReturn: [Type]...) -> MethodStub {
            return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func count<Type: NSFetchRequestResult>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willReturn: Int...) -> MethodStub {
            return Given(method: .m_count__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Parameter<Type.Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_new__objectType(`objectType`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func batchUpdateRequest<Type: CoreDataObject>(for type: Parameter<Type.Type>, willReturn: NSBatchUpdateRequest...) -> MethodStub {
            return Given(method: .m_batchUpdateRequest__for_type(`type`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func batchUpdate(_ request: Parameter<NSBatchUpdateRequest>, willReturn: NSBatchUpdateResult...) -> MethodStub {
            return Given(method: .m_batchUpdate__request(`request`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, willReturn: Type...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func childTransaction(willProduce: (Stubber<Transaction>) -> Void) -> MethodStub {
            let willReturn: [Transaction] = []
			let given: Given = { return Given(method: .m_childTransaction, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Transaction).self)
			willProduce(stubber)
			return given
        }
        public static func batchUpdateRequest<Type: CoreDataObject>(for type: Parameter<Type.Type>, willProduce: (Stubber<NSBatchUpdateRequest>) -> Void) -> MethodStub {
            let willReturn: [NSBatchUpdateRequest] = []
			let given: Given = { return Given(method: .m_batchUpdateRequest__for_type(`type`.wrapAsGeneric()), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (NSBatchUpdateRequest).self)
			willProduce(stubber)
			return given
        }
        public static func commit(willThrow: Error...) -> MethodStub {
            return Given(method: .m_commit, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func commit(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_commit, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func query<Type:NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func query<Type: NSManagedObject>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willProduce: (StubberThrows<[Type]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Type]).self)
			willProduce(stubber)
			return given
        }
        public static func count<Type:NSFetchRequestResult>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_count__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func count<Type: NSFetchRequestResult>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, willProduce: (StubberThrows<Int>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_count__fetchRequest(`fetchRequest`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Int).self)
			willProduce(stubber)
			return given
        }
        public static func new<Type:NSManagedObject&CoreDataObject>(_ objectType: Parameter<Type.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_new__objectType(`objectType`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Parameter<Type.Type>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_new__objectType(`objectType`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func batchUpdate(_ request: Parameter<NSBatchUpdateRequest>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_batchUpdate__request(`request`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func batchUpdate(_ request: Parameter<NSBatchUpdateRequest>, willProduce: (StubberThrows<NSBatchUpdateResult>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_batchUpdate__request(`request`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (NSBatchUpdateResult).self)
			willProduce(stubber)
			return given
        }
        public static func pull<Type:NSManagedObject>(savedObject: Parameter<Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func pull<Type: NSManagedObject>(savedObject: Parameter<Type>, willProduce: (StubberThrows<Type>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Type).self)
			willProduce(stubber)
			return given
        }
        public static func delete(_ coreDataObject: Parameter<CoreDataObject>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_delete__coreDataObject(`coreDataObject`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func delete(_ coreDataObject: Parameter<CoreDataObject>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_delete__coreDataObject(`coreDataObject`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func deleteAll(_ objects: Parameter<[NSManagedObject]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_deleteAll__objects(`objects`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func deleteAll(_ objects: Parameter<[NSManagedObject]>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_deleteAll__objects(`objects`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func deleteAll(_ objectType: Parameter<NSManagedObject.Type>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_deleteAll__objectType(`objectType`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func deleteAll(_ objectType: Parameter<NSManagedObject.Type>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_deleteAll__objectType(`objectType`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func deleteAll(_ entityName: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_deleteAll__entityName(`entityName`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func deleteAll(_ entityName: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_deleteAll__entityName(`entityName`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func childTransaction() -> Verify { return Verify(method: .m_childTransaction)}
        public static func commit() -> Verify { return Verify(method: .m_commit)}
        public static func reset() -> Verify { return Verify(method: .m_reset)}
        public static func query<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>) -> Verify where Type:NSManagedObject { return Verify(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()))}
        public static func count<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>) -> Verify where Type:NSFetchRequestResult { return Verify(method: .m_count__fetchRequest(`fetchRequest`.wrapAsGeneric()))}
        public static func new<Type>(_ objectType: Parameter<Type.Type>) -> Verify where Type:NSManagedObject&CoreDataObject { return Verify(method: .m_new__objectType(`objectType`.wrapAsGeneric()))}
        public static func batchUpdateRequest<Type>(for type: Parameter<Type.Type>) -> Verify where Type:CoreDataObject { return Verify(method: .m_batchUpdateRequest__for_type(`type`.wrapAsGeneric()))}
        public static func batchUpdate(_ request: Parameter<NSBatchUpdateRequest>) -> Verify { return Verify(method: .m_batchUpdate__request(`request`))}
        public static func pull<Type>(savedObject: Parameter<Type>) -> Verify where Type:NSManagedObject { return Verify(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()))}
        public static func delete(_ coreDataObject: Parameter<CoreDataObject>) -> Verify { return Verify(method: .m_delete__coreDataObject(`coreDataObject`))}
        public static func deleteAll(_ objects: Parameter<[NSManagedObject]>) -> Verify { return Verify(method: .m_deleteAll__objects(`objects`))}
        public static func deleteAll(_ objectType: Parameter<NSManagedObject.Type>) -> Verify { return Verify(method: .m_deleteAll__objectType(`objectType`))}
        public static func deleteAll(_ entityName: Parameter<String>) -> Verify { return Verify(method: .m_deleteAll__entityName(`entityName`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func childTransaction(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_childTransaction, performs: perform)
        }
        public static func commit(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_commit, performs: perform)
        }
        public static func reset(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_reset, performs: perform)
        }
        public static func query<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, perform: @escaping (NSFetchRequest<Type>) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_query__fetchRequest(`fetchRequest`.wrapAsGeneric()), performs: perform)
        }
        public static func count<Type>(_ fetchRequest: Parameter<NSFetchRequest<Type>>, perform: @escaping (NSFetchRequest<Type>) -> Void) -> Perform where Type:NSFetchRequestResult {
            return Perform(method: .m_count__fetchRequest(`fetchRequest`.wrapAsGeneric()), performs: perform)
        }
        public static func new<Type>(_ objectType: Parameter<Type.Type>, perform: @escaping (Type.Type) -> Void) -> Perform where Type:NSManagedObject&CoreDataObject {
            return Perform(method: .m_new__objectType(`objectType`.wrapAsGeneric()), performs: perform)
        }
        public static func batchUpdateRequest<Type>(for type: Parameter<Type.Type>, perform: @escaping (Type.Type) -> Void) -> Perform where Type:CoreDataObject {
            return Perform(method: .m_batchUpdateRequest__for_type(`type`.wrapAsGeneric()), performs: perform)
        }
        public static func batchUpdate(_ request: Parameter<NSBatchUpdateRequest>, perform: @escaping (NSBatchUpdateRequest) -> Void) -> Perform {
            return Perform(method: .m_batchUpdate__request(`request`), performs: perform)
        }
        public static func pull<Type>(savedObject: Parameter<Type>, perform: @escaping (Type) -> Void) -> Perform where Type:NSManagedObject {
            return Perform(method: .m_pull__savedObject_savedObject(`savedObject`.wrapAsGeneric()), performs: perform)
        }
        public static func delete(_ coreDataObject: Parameter<CoreDataObject>, perform: @escaping (CoreDataObject) -> Void) -> Perform {
            return Perform(method: .m_delete__coreDataObject(`coreDataObject`), performs: perform)
        }
        public static func deleteAll(_ objects: Parameter<[NSManagedObject]>, perform: @escaping ([NSManagedObject]) -> Void) -> Perform {
            return Perform(method: .m_deleteAll__objects(`objects`), performs: perform)
        }
        public static func deleteAll(_ objectType: Parameter<NSManagedObject.Type>, perform: @escaping (NSManagedObject.Type) -> Void) -> Perform {
            return Perform(method: .m_deleteAll__objectType(`objectType`), performs: perform)
        }
        public static func deleteAll(_ entityName: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_deleteAll__entityName(`entityName`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

