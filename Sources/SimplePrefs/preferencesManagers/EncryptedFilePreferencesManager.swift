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

#if canImport(CryptoKit)
import Foundation
import CryptoKit

@available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *)
public class EncryptedFilePreferencesManager<Value: Codable>: PreferencesManagerClass {
	
	internal var value: Value
	
	/// 256bits/32bytes data key
	public let dataKey: Data
	public let path: String
	public let fileName: String
	
	private var key: SymmetricKey {
		SymmetricKey(data: self.dataKey)
	}
	
	/// Encrypted file preferences manager
	/// - Parameters:
	///   - defaultValue: Default prefrerences data value
	///   - dataKey: 256bits/32bytes data key
	///   - path: Where the preferences file is saved
	///   - fileName: Preferences file name
	public init(defaultValue: Value, dataKey: Data, path: String? = nil, fileName: String? = nil) {
		self.value = defaultValue
		self.dataKey = dataKey
		self.fileName = fileName ?? ".\(Value.self).enc"
		if let path = path {
			self.path = path
		} else {
			self.path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.fileName).path
		}
	}
	
	@discardableResult
	public func load() -> Bool {
		if let encryptedData = FileManager.default.contents(atPath: self.path),
			let sealedBox = try? ChaChaPoly.SealedBox(combined: encryptedData),
			let decryptedData = try? ChaChaPoly.open(sealedBox, using: self.key),
			let instance = try? JSONDecoder().decode(Value.self, from: decryptedData) {
				
			self.value = instance
			return true
		}
		return false
	}
	
	@discardableResult
	public func save() -> Bool {
		
		guard let encriptedData = try? JSONEncoder().encode(self.value) else {
			return false
		}
		
		if let encryptedData = try? ChaChaPoly.seal(encriptedData, using: self.key).combined {
			return FileManager.default.createFile(atPath: self.path, contents: encryptedData, attributes: nil)
		}
		return false
	}
	
	@discardableResult
	public func delete() -> Bool {
		return ( try? FileManager.default.removeItem(atPath: self.path) ) != nil
	}
}
#endif
