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

/// Saves preferences as a plain JSON file
public protocol KeychainPreferences {
	/// Like a key from a dictionary, just to identify the saved data
	static var key: String { get }
}

public extension KeychainPreferences {
	/// Note: after deleting from keychain, is recomended to re-assign a new empty instance to your shared instance (MyPreferences.shared = .init())
	@discardableResult
	func delete() -> Bool {
		return GenericPasswordStore().deleteKey(account: Self.key)
	}
}

public extension KeychainPreferences where Self: Encodable {
	
	@discardableResult
	func save() -> Bool {
		guard let data = try? JSONEncoder().encode(self) else {
			return false
		}
		if GenericPasswordStore().storeKey(data, account: Self.key) == false {
			return GenericPasswordStore().updateKey(data, account: Self.key)
		} else {
			return true
		}
	}
	
	/// Is not mandatory to call this method, since the `save` method will update the keychain values if there are previous ones
	@discardableResult
	func update() -> Bool {
		guard let data = try? JSONEncoder().encode(self) else {
			return false
		}
		return GenericPasswordStore().updateKey(data, account: Self.key)
	}
}

public extension KeychainPreferences where Self: Decodable {
	static func loaded() -> Self? {
		if let data = GenericPasswordStore().readKey(account: Self.key),
			let instance = try? JSONDecoder().decode(Self.self, from: data) {
			
			return instance
		}
		return nil
	}
}
