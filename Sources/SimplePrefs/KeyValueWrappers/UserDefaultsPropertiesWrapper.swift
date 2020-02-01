//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 29/01/2020.
//

import class Foundation.UserDefaults
import struct Foundation.Data
import class Foundation.JSONEncoder
import class Foundation.JSONDecoder

internal protocol _UserDefaultsKeyValueWrapperInjectedValue: class {
	var key: String { get }
	var _userDefaults: UserDefaults! { get set }
	func _registerDefault()
}

@propertyWrapper
final internal class UserDefaultsPropertiesWrapper<T: Codable>: PropertiesWrapper, _UserDefaultsKeyValueWrapperInjectedValue {
	
	internal var projectedValue: UserDefaultsPropertiesWrapper<T> { self }
	
	internal var wrappedValue: T? {
		get {
			assert(_userDefaults != nil)
			guard let _userDefaults = self._userDefaults else { return nil }
			
			guard let object = _userDefaults.object(forKey: self.key) else {
				return nil
			}
			if (object is Data), !(T.self is Data.Type), let data = object as? Data {
				do {
					return try JSONDecoder().decode(T.self, from: data)
				} catch {}
			}
			return _userDefaults.object(forKey: self.key) as? T
		}
		set {
			assert(_userDefaults != nil)
			guard let _userDefaults = self._userDefaults else { return }
			
			guard let newValue = newValue else {
				_userDefaults.removeObject(forKey: self.key)
				return
			}
			
			if T.self is Data.Type {
				_userDefaults.set(newValue, forKey: self.key)
			} else {
				do {
					let newValueData = try JSONEncoder().encode(newValue)
					_userDefaults.set(newValueData, forKey: self.key)
				} catch {}
			}
		}
	}
	
	internal let key: String
	internal let defaultValue: T?
	
	internal init<C: CodingKey>(_ key: C, defaultValue: T? = nil) {
		self.key = key.stringValue
		self.defaultValue = defaultValue
	}
	
	internal init(_ key: String, defaultValue: T? = nil) {
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
