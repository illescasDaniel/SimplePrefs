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

import Foundation

public class KeychainPreferencesManager<Value: Codable>: PreferencesManager, PreferencesManagerInternals {
	
	internal var value: Value
	
	/// Similar to a dictionary key, used to identify the saved data. (Is not an encryption key)
	public let key: String
	
	/// Keychain preferences manager
	/// - Parameters:
	///   - defaultValue: Default prefrerences data value
	///   - dataKey: 256bits/32bytes data key
	///   - path: Where the preferences file is saved
	///   - fileName: Preferences file name
	public init(defaultValue: Value, key: String) {
		self.value = defaultValue
		self.key = key
	}
	
	@discardableResult
	public func load() -> Bool {
		if let data = GenericPasswordStore().readKey(account: self.key),
			let instance = try? JSONDecoder().decode(Value.self, from: data) {
			self.value = instance
			return true
		}
		return false
	}
	
	@discardableResult
	public func save() -> Bool {
		guard let data = try? JSONEncoder().encode(self.value) else {
			return false
		}
		if GenericPasswordStore().storeKey(data, account: self.key) == false {
			return GenericPasswordStore().updateKey(data, account: self.key)
		} else {
			return true
		}
	}
	
	@discardableResult
	public func delete() -> Bool {
		return GenericPasswordStore().deleteKey(account: self.key)
	}
}
