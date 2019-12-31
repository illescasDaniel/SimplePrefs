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
public protocol FilePreferences {
	static var fileName: String { get }
	static var path: String? { get }
}
public extension FilePreferences {
	
	/// File name including extension
	static var fileName: String {
		return "\(Self.self).json"
	}
	
	/// Self-generated path. By default saves a file named YOUR_CLASS_NAME.json
	static var path: String? {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
			.appendingPathComponent(Self.fileName)
			.path
	}
}

public extension FilePreferences where Self: Encodable {
	@discardableResult
	func save() -> Bool {
		guard let data = try? JSONEncoder().encode(self), let path = Self.path else {
			return false
		}
		return FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
	}
}

public extension FilePreferences where Self: Decodable {
	static func loaded() -> Self? {
		if let path = Self.path,
			let data = FileManager.default.contents(atPath: path),
			let instance = try? JSONDecoder().decode(Self.self, from: data) {
			
			return instance
		}
		return nil
	}
}
