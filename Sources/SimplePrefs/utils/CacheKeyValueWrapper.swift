//
//  File.swift
//
//
//  Created by Daniel Illescas Romero on 29/01/2020.
//

import Foundation

internal protocol _CacheWrapperProtocol: class {
	var _cache: NSCache<NSString, AnyObject>! { get set }
}

@propertyWrapper
public class CacheKeyValueWrapper<T: Codable>: _CacheWrapperProtocol {
	
	public var wrappedValue: T? {
		get {
			assert(_cache != nil)
			return (_cache.object(forKey: self.key as NSString) as? Box<T>)?.value
		}
		set {
			assert(_cache != nil)
			_cache.setObject(Box(newValue), forKey: self.key as NSString)
		}
	}
	
	public let key: String
	private let defaultValue: T?
	
	public init<C: CodingKey>(_ key: C, defaultValue: T? = nil) {
		self.key = key.stringValue
		self.defaultValue = defaultValue
	}
	
	public init(_ key: String, defaultValue: T? = nil) {
		self.key = key
		self.defaultValue = defaultValue
	}
	
	// private
	
	internal var _cache: NSCache<NSString, AnyObject>! = nil
}
