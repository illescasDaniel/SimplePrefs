//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 01/02/2020.
//

internal protocol _GenericPropertyWrapper: class {
	var cacheWrapper: _CachePropertyWrapper? { get set }
	var userDefaultsWrapper: _UserDefaultsPropertiesWrapper? { get set }
	var keychainWrapper: _KeychainPropertyWrapper? { get set }
}

@propertyWrapper
final public class GenericPropertyWrapper<T: Codable>: _GenericPropertyWrapper {
	
	public var projectedValue: GenericPropertyWrapper<T> { self }
	
	internal var cache: CachePropertyWrapper<T>?
	internal var userDefaults: UserDefaultsPropertiesWrapper<T>?
	internal var keychain: KeychainPropertyWrapper<T>?
	
	internal var cacheWrapper: _CachePropertyWrapper? {
		get { cache }
		set {
			if newValue == nil {
				cache = nil
			}
		}
	}
	internal var userDefaultsWrapper: _UserDefaultsPropertiesWrapper? {
		get { userDefaults }
		set {
			if newValue == nil {
				userDefaults = nil
			}
		}
	}
	internal var keychainWrapper: _KeychainPropertyWrapper? {
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
	
	/// `Cost` is only effective for `Cache`
	public init(_ key: String, cost: Int = 0, defaultValue: T? = nil) {
		self.cache = CachePropertyWrapper<T>(key, cost: cost, defaultValue: defaultValue)
		self.userDefaults = UserDefaultsPropertiesWrapper<T>(key, defaultValue: defaultValue)
		self.keychain = KeychainPropertyWrapper<T>(key, defaultValue: defaultValue)
	}
}
