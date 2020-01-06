//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 06/01/2020.
//

import Foundation

public protocol PreferencesManager {
	associatedtype Value: Codable
	var value: Value { get set }
	
	mutating func load() -> Bool
	func save() -> Bool
	mutating func delete() -> Bool
}

public protocol MockPreferencesManager: PreferencesManager {
	var value: Value { get set }
}
public extension MockPreferencesManager {
	mutating func load() -> Bool { true }
	func save() -> Bool { true }
	mutating func delete() -> Bool {true }
}

public struct DefaultMockPreferencesManager<Value: Codable>: MockPreferencesManager {
	public var value: Value
	
	public init(defaultValue: Value) {
		self.value = defaultValue
	}
}
public struct FilePreferencesManager<Value: Codable>: PreferencesManager {
	
	public var value: Value
	
	public let path: String
	public let fileName: String
	
	public init(defaultValue: Value, path: String? = nil, fileName: String? = nil) {
		self.value = defaultValue
		self.fileName = fileName ?? "\(Self.self).json"
		if let path = path {
			self.path = path
		} else {
			self.path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.fileName).path
		}
	}
	
	public mutating func load() -> Bool {
		if let data = FileManager.default.contents(atPath: self.path),
			let instance = try? JSONDecoder().decode(Value.self, from: data) {
			
			self.value = instance
			return true
		}
		return false
	}
	
	public func save() -> Bool {
		guard let data = try? JSONEncoder().encode(self.value) else {
			return false
		}
		return FileManager.default.createFile(atPath: self.path, contents: data, attributes: nil)
	}
	
	public mutating func delete() -> Bool {
		return (try? FileManager.default.removeItem(atPath: self.path)) != nil
	}
}
