//
//  File.swift
//
//
//  Created by Daniel Illescas Romero on 29/01/2020.
//

import struct Foundation.Data
import class Foundation.JSONEncoder
import class Foundation.JSONDecoder

internal protocol _KeychainPropertyWrapper: class {
	var key: String { get }
}

@propertyWrapper
final internal class KeychainPropertyWrapper<T: Codable>: StoragePropertyWrapper, _KeychainPropertyWrapper {
	
	private let keychain = GenericPasswordStore()
	
	internal var projectedValue: KeychainPropertyWrapper<T> { self }
	
	internal var wrappedValue: T? {
		get {
			guard let keychainData = keychain.readKey(account: self.key) else {
				return self.defaultValue
			}
			
			if T.self is Data.Type {
				return keychainData as? T ?? self.defaultValue
			} else {
				do {
					return try JSONDecoder().decode(T.self, from: keychainData)
				} catch {
					return self.defaultValue
				}
			}
		}
		set {
			guard let newValue = newValue else {
				keychain.deleteKey(account: self.key)
				return
			}
			
			if T.self is Data.Type, let data = newValue as? Data {
				keychain.storeKey(data, account: self.key)
			} else {
				do {
					let newValueData = try JSONEncoder().encode(newValue)
					keychain.storeKey(newValueData, account: self.key)
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
}
