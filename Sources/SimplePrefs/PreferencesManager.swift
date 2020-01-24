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

public protocol PreferencesManager {
	
	associatedtype Value: Codable
	
	var value: Value { get set }
	
	func load() -> Bool
	func save() -> Bool
	func delete() -> Bool
}
public extension PreferencesManager {
	
	var loaded: Self {
		_ = load()
		return self
	}
	
	func getProperty<T>(_ keyPath: KeyPath<Value,T>) -> T {
		return value[keyPath: keyPath]
	}
	
	mutating func setProperty<T>(_ keyPath: WritableKeyPath<Value,T>, _ value: T) {
		self.value[keyPath: keyPath] = value
	}
	
	subscript<T>(keyPath: WritableKeyPath<Value,T>) -> T {
		get { getProperty(keyPath) }
		set { setProperty(keyPath, newValue) }
	}
}

public protocol PreferencesManagerClass: class, PreferencesManager {
	var value: Value { get set }
}
public extension PreferencesManagerClass {
	func setProperty<T>(_ keyPath: WritableKeyPath<Value,T>, _ value: T) {
		self.value[keyPath: keyPath] = value
	}
	subscript<T>(keyPath: WritableKeyPath<Value,T>) -> T {
		get { getProperty(keyPath) }
		set { setProperty(keyPath, newValue) }
	}
}
