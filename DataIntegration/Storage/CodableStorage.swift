//
//  CodableStorage.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public enum StorageDirectory {
	/// Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
	case documents

	/// Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
	case caches
}

public enum CodableStorageError: Error {
	case fileDoesNotExist
	case noDataFound
}

//sourcery: AutoMockable
public protocol CodableStorage {

	func store<T: Encodable>(_ object: T, to directory: StorageDirectory, as fileName: String) throws
	func retrieve<T: Decodable>(_ fileName: String, from directory: StorageDirectory, as type: T.Type) throws -> T
	func clear(_ directory: StorageDirectory) throws
	func remove(_ fileName: String, from directory: StorageDirectory) throws
	func fileExists(_ fileName: String, in directory: StorageDirectory) -> Bool
}

public final class CodableStorageImpl: CodableStorage {

	/// Store an encodable struct to the specified directory on disk
	///
	/// - Parameters:
	///   - object: the encodable struct to store
	///   - directory: where to store the struct
	///   - fileName: what to name the file where the struct data will be stored
	public final func store<T: Encodable>(_ object: T, to directory: StorageDirectory, as fileName: String) throws {
		let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)

		let encoder = JSONEncoder()
		do {
			let data = try encoder.encode(object)
			if FileManager.default.fileExists(atPath: url.path) {
				try FileManager.default.removeItem(at: url)
			}
			FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
		} catch {
			os_log("Failed to store object (%@) in '%@' as '%@': %@", type: .error, String(describing: object), String(describing: directory), fileName, error.localizedDescription)
			throw error
		}
	}

	/// Retrieve and convert a struct from a file on disk
	///
	/// - Parameters:
	///   - fileName: name of the file where struct data is stored
	///   - directory: directory where struct data is stored
	///   - type: struct type (i.e. Message.self)
	/// - Returns: decoded struct model(s) of data
	public final func retrieve<T: Decodable>(_ fileName: String, from directory: StorageDirectory, as type: T.Type) throws -> T {
		let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)

		if !FileManager.default.fileExists(atPath: url.path) {
			os_log("File at path '%@' does not exist!", type: .error, url.path)
			throw CodableStorageError.fileDoesNotExist
		}

		if let data = FileManager.default.contents(atPath: url.path) {
			let decoder = JSONDecoder()
			let model = try decoder.decode(type, from: data)
			return model
		} else {
			os_log("No data at %@", type: .error, url.path)
			throw CodableStorageError.noDataFound
		}
	}

	/// Remove all files at specified directory
	public final func clear(_ directory: StorageDirectory) throws {
		let url = getURL(for: directory)
		let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
		for fileUrl in contents {
			try FileManager.default.removeItem(at: fileUrl)
		}
	}

	/// Remove specified file from specified directory
	public final func remove(_ fileName: String, from directory: StorageDirectory) throws {
		let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
		if FileManager.default.fileExists(atPath: url.path) {
			try FileManager.default.removeItem(at: url)
		}
	}

	/// Returns BOOL indicating whether file exists at specified directory with specified file name
	public final func fileExists(_ fileName: String, in directory: StorageDirectory) -> Bool {
		let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
		return FileManager.default.fileExists(atPath: url.path)
	}

	/// Returns URL constructed from specified directory
	private final func getURL(for directory: StorageDirectory) -> URL {
		var searchPathDirectory: FileManager.SearchPathDirectory

		switch directory {
		case .documents:
			searchPathDirectory = .documentDirectory
		case .caches:
			searchPathDirectory = .cachesDirectory
		}

		if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
			return url
		} else {
			fatalError("Could not create URL for specified directory!")
		}
	}
}
