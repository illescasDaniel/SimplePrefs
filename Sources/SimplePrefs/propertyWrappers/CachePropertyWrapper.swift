//
//  File.swift
//
//
//  Created by Daniel Illescas Romero on 29/01/2020.
//

import class Foundation.NSCache
import class Foundation.NSString

internal protocol _CachePropertyWrapper: class {
	var _cache: NSCache<NSString, AnyObject>! { get set }
}

@propertyWrapper
final internal class CachePropertyWrapper<T>: StoragePropertyWrapper, _CachePropertyWrapper {
	
	internal var projectedValue: CachePropertyWrapper<T> { self }
	
	internal var wrappedValue: T? {
		get {
			assert(_cache != nil)
			guard let _cache = self._cache else { return nil }
			
			if T.self is AnyObject.Type {
				return _cache.object(forKey: self.key as NSString) as? T ?? self.defaultValue
			}
			return (_cache.object(forKey: self.key as NSString) as? Box<T>)?.value ?? self.defaultValue
		}
		set {
			assert(_cache != nil)
			guard let _cache = self._cache else { return }
			
			guard let newValue = newValue else {
				_cache.removeObject(forKey: self.key as NSString)
				return
			}
			
			if T.self is AnyObject.Type {
				_cache.setObject(newValue as AnyObject, forKey: self.key as NSString, cost: self.cost)
			} else {
				_cache.setObject(Box(newValue), forKey: self.key as NSString, cost: self.cost)
			}
		}
	}
	
	internal let key: String
	internal let defaultValue: T?
	internal let cost: Int
	
	internal init<C: CodingKey>(_ key: C, defaultValue: T? = nil) {
		self.key = key.stringValue
		self.cost = 0
		self.defaultValue = defaultValue
	}
	
	internal init(_ key: String, defaultValue: T? = nil) {
		self.key = key
		self.cost = 0
		self.defaultValue = defaultValue
	}
	
	internal init<C: CodingKey>(_ key: C, cost: Int, defaultValue: T? = nil) {
		self.key = key.stringValue
		self.cost = cost
		self.defaultValue = defaultValue
	}
	
	internal init(_ key: String, cost: Int, defaultValue: T? = nil) {
		self.key = key
		self.cost = cost
		self.defaultValue = defaultValue
	}
	
	// private
	
	internal var _cache: NSCache<NSString, AnyObject>!
}
