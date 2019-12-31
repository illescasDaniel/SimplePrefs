/*Copyright © 2019 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import Security

struct GenericPasswordStore {
	
	/// Stores a CryptoKit key in the keychain as a generic password.
	@discardableResult
	func storeKey(_ key: Data, account: String) -> Bool {
		
		// Treat the key data as a generic password.
		var query = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrAccount: account,
			kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
			kSecValueData: key
		] as [String: Any]
		
		if #available(OSX 10.15, iOS 13.0, *) {
			query[kSecUseDataProtectionKeychain as String] = true
		}
		
		// Add the key data.
		let status = SecItemAdd(query as CFDictionary, nil)
		return status == errSecSuccess
	}
	
	/// Reads a CryptoKit key from the keychain as a generic password.
	func readKey(account: String) -> Data? {
		
		// Seek a generic password with the given account.
		var query = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrAccount: account,
			kSecReturnData: true
		] as [String: Any]
		
		if #available(OSX 10.15, iOS 13.0, *) {
			query[kSecUseDataProtectionKeychain as String] = true
		}
		
		// Find and cast the result as data.
		var item: CFTypeRef?
		switch SecItemCopyMatching(query as CFDictionary, &item) {
		case errSecSuccess:
			guard let data = item as? Data else { return nil }
			return data
		default:
			return nil
		}
	}
	
	/// Removes any existing key with the given account.
	@discardableResult
	func deleteKey(account: String) -> Bool {
		var query = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrAccount: account
		] as [String: Any]
		
		if #available(OSX 10.15, iOS 13.0, *) {
			query[kSecUseDataProtectionKeychain as String] = true
		}
		
		switch SecItemDelete(query as CFDictionary) {
		case errSecItemNotFound, errSecSuccess:
			return true
		default:
			return false
		}
	}
}
