//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 29/01/2020.
//

import Foundation

internal protocol _UserDefaultsKeyValueWrapperProtocol: class {
	var _userDefaults: UserDefaults! { get set }
	func _registerDefault()
}

@propertyWrapper
public class UserDefaultsKeyValueWrapper<T: Codable>: _UserDefaultsKeyValueWrapperProtocol {
	
	public var wrappedValue: T? {
		get {
			assert(_userDefaults != nil)
			guard let object = _userDefaults?.object(forKey: self.key) else {
				return nil
			}
			if (object is Data), !(T.self is Data.Type), let data = object as? Data {
				do {
					return try JSONDecoder().decode(T.self, from: data)
				} catch {}
			}
			return _userDefaults?.object(forKey: self.key) as? T
		}
		set {
			assert(_userDefaults != nil)
			do {
				if newValue != nil, !(T.self is Data.Type) {
					let newValueData = try JSONEncoder().encode(newValue)
					_userDefaults?.set(newValueData, forKey: self.key)
					return
				}
			} catch {}
			_userDefaults?.set(newValue, forKey: self.key)
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
	
	internal var _userDefaults: UserDefaults! = nil
	
	internal func _registerDefault() {
		assert(_userDefaults != nil)
		guard let defaultValue = defaultValue else { return }
		do {
			if !(T.self is Data.Type) {
				let defaultValueData = try JSONEncoder().encode(defaultValue)
				_userDefaults?.register(defaults: [self.key: defaultValueData])
				return
			}
		} catch {}
		_userDefaults?.register(defaults: [self.key: defaultValue])
	}
}
