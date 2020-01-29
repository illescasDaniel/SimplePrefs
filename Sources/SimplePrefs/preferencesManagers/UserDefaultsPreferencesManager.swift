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

public protocol WithKeys {
	associatedtype CodingKeys: CodingKey, CaseIterable
}

public class UserDefaultsPreferencesManager<Value: WithKeys>: PreferencesManager, PreferencesManagerInternals {
	
	internal var value: Value
	
	/// `UserDefaults` instance to use. `UserDefaults.standard` by default.
	public let userDefaults: UserDefaults
	
	/// `UserDefaults` preferences manager
	/// - Parameters:
	///   - defaultValue: Default prefrerences data value
	///   - userDefaults: `UserDefaults` instance to use. `UserDefaults.standard` by default.
	public init(defaultValue: Value, userDefaults: UserDefaults = .standard) {
		self.value = defaultValue
		self.userDefaults = userDefaults
		for (_, value) in Mirror(reflecting: self.value).children {
			if let keyValueObject = (value as? _UserDefaultsKeyValueWrapperProtocol) {
				keyValueObject._userDefaults = self.userDefaults
				keyValueObject._registerDefault()
			}
		}
	}
	
	@discardableResult
	public func load() -> Bool {
		return true
	}
	
	@discardableResult
	public func save() -> Bool {
		return true
	}
	
	@discardableResult
	public func delete() -> Bool {
		Value.CodingKeys.allCases.forEach { key in
			self.userDefaults.removeObject(forKey: key.stringValue)
		}
		return true
	}
}
