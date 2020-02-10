/*The MIT License (MIT)

Copyright (c) 2020 Daniel Illescas Romero

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import struct Foundation.Data
import class Foundation.JSONDecoder
import class Foundation.JSONEncoder
import class Foundation.UserDefaults

public final class UserDefaultsPropertiesManager<Value: AllPropertyKeys> {
	
	private let value: Value
	private let userDefaults: UserDefaults
	
	/// - Parameters:
	///   - defaultValue: Default prefrerences data value
	///   - userDefaults: `UserDefaults` instance to use. `UserDefaults.standard` by default.
	public init(defaultValue: Value, userDefaults: UserDefaults = .standard) {
		self.value = defaultValue
		self.userDefaults = userDefaults
	}
	
	public func getProperty<T: Codable>(_ keyPath: KeyPath<Value, PropertyKey<T>>) -> T? {
		
		let property = value[keyPath: keyPath]
		let key = property.key
		
		registerInitialValue(for: keyPath)
		
		guard let object = userDefaults.object(forKey: key) else {
			return nil
		}
		if (object is Data), !(T.self is Data.Type), let data = object as? Data {
			do {
				return try JSONDecoder().decode(T.self, from: data)
			} catch {}
		}
		return userDefaults.object(forKey: key) as? T
	}
	
	@discardableResult
	public func registerInitialValue<T: Codable>(for keyPath: KeyPath<Value, PropertyKey<T>>) -> Bool {
		
		let property = value[keyPath: keyPath]
		let key = property.key
		
		guard let initialValue = property.defaultValue else { return false }
		
		if T.self is Data.Type {
			userDefaults.register(defaults: [key: initialValue])
		} else {
			do {
				let initialValueData = try JSONEncoder().encode(initialValue)
				userDefaults.register(defaults: [key: initialValueData])
			} catch {
				return false
			}
		}
		return true
	}
	
	public func setProperty<T: Encodable>(_ keyPath: KeyPath<Value, PropertyKey<T>>, _ newValue: T?) {
		
		let property = value[keyPath: keyPath]
		let key = property.key
		
		guard let newValue = newValue else {
			userDefaults.removeObject(forKey: key)
			return
		}
		
		if T.self is Data.Type {
			userDefaults.set(newValue, forKey: key)
		} else {
			do {
				let newValueData = try JSONEncoder().encode(newValue)
				userDefaults.set(newValueData, forKey: key)
			} catch {}
		}
	}
	
	public subscript<T: Codable>(keyPath: KeyPath<Value, PropertyKey<T>>) -> T? {
		get { getProperty(keyPath) }
		set { setProperty(keyPath, newValue) }
	}
	
	@discardableResult
	public func delete() -> Bool {
		for property in self.value.allProperties {
			userDefaults.removeObject(forKey: property.key)
		}
		return true
	}
}
