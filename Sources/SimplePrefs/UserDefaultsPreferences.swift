/*The MIT License (MIT)

Copyright (c) 2019 Daniel Illescas Romero

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

/// Saves preferences in the UserDefaults
public protocol UserDefaultsPreferences {
	associatedtype CodingKeys: CaseIterable, RawRepresentable where CodingKeys.RawValue == String
	static var userDefaults: UserDefaults { get }
}
public extension UserDefaultsPreferences {
	static var userDefaults: UserDefaults { .standard }
}

public extension UserDefaultsPreferences where Self: Encodable {
	@discardableResult
	func save() -> Bool {
		guard let data = try? JSONEncoder().encode(self) else {
			return false
		}
		if let jsonDictionary = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] {
			for (key,value) in jsonDictionary {
				Self.userDefaults.set(value, forKey: key)
			}
			return true
		}
		return false
	}
}

public extension UserDefaultsPreferences where Self: Decodable {
	static func loaded() -> Self? {
		let userDefaultsDictionary = Self.userDefaults.dictionaryWithValues(forKeys: CodingKeys.allCases.map { $0.rawValue })
		if let data = try? JSONSerialization.data(withJSONObject: userDefaultsDictionary),
			let instance = try? JSONDecoder().decode(Self.self, from: data) {
			
			return instance
		}
		return nil
	}
}
