//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 01/02/2020.
//

import Foundation

internal protocol _GenericPropertiesWrapperProtocol: class {
	var cacheWrapper: _CacheKeyValueWrapperInjectedValue? { get set }
	var userDefaultsWrapper: _UserDefaultsKeyValueWrapperInjectedValue? { get set }
	var keychainWrapper: _KeychainKeyValueWrapperProtocol? { get set }
}

@propertyWrapper
final public class GenericPropertiesWrapper<T: Codable>: _GenericPropertiesWrapperProtocol {
	
	public var projectedValue: GenericPropertiesWrapper<T> { self }
	
	internal var cache: CachePropertiesWrapper<T>?
	internal var userDefaults: UserDefaultsPropertiesWrapper<T>?
	internal var keychain: KeychainPropertiesWrapper<T>?
	
	internal var cacheWrapper: _CacheKeyValueWrapperInjectedValue? {
		get { cache }
		set {
			if newValue == nil {
				cache = nil
			}
		}
	}
	internal var userDefaultsWrapper: _UserDefaultsKeyValueWrapperInjectedValue? {
		get { userDefaults }
		set {
			if newValue == nil {
				userDefaults = nil
			}
		}
	}
	internal var keychainWrapper: _KeychainKeyValueWrapperProtocol? {
		get { keychain }
		set {
			if newValue == nil {
				keychain = nil
			}
		}
	}
	
	public var wrappedValue: T? {
		get {
			if let cache = cache {
				return cache.wrappedValue
			} else if let userDefaults = userDefaults {
				return userDefaults.wrappedValue
			} else if let keychain = keychain {
				return keychain.wrappedValue
			}
			return nil
		}
		set {
			if let cache = cache {
				cache.wrappedValue = newValue
			} else if let userDefaults = userDefaults {
				userDefaults.wrappedValue = newValue
			} else if let keychain = keychain {
				keychain.wrappedValue = newValue
			}
		}
	}
	
	//
	
	/// Cost is only effective for `UserDefaults` and `Keychain`
	public init(_ key: String, cost: Int = 0, defaultValue: T? = nil) {
		self.cache = CachePropertiesWrapper<T>(key, cost: cost, defaultValue: defaultValue)
		self.userDefaults = UserDefaultsPropertiesWrapper<T>(key, defaultValue: defaultValue)
		self.keychain = KeychainPropertiesWrapper<T>(key, defaultValue: defaultValue)
	}
}
