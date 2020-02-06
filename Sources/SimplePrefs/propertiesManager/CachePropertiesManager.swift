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

import class Foundation.NSCache
import class Foundation.NSString

public final class CachePropertiesManager<Value> {
	
	private let value: Value
	private let cache = NSCache<NSString, AnyObject>()
	
	public init(defaultValue: Value, totalCostLimit: Int? = nil, countLimit: Int? = nil) {
		self.value = defaultValue
		if let totalCostLimit = totalCostLimit {
			self.cache.totalCostLimit = totalCostLimit
		}
		if let countLimit = countLimit {
			self.cache.countLimit = countLimit
		}
	}
	
	public func getProperty<T>(_ keyPath: KeyPath<Value, PropertyKey<T>>) -> T? {
		
		let property = value[keyPath: keyPath]
		let (key, defaultValue) = (property.key as NSString, property.defaultValue)
		
		if T.self is AnyObject.Type {
			return cache.object(forKey: key) as? T ?? defaultValue
		}
		return (cache.object(forKey: key) as? Box<T>)?.value ?? defaultValue
	}
	
	public func setProperty<T>(_ keyPath: KeyPath<Value,PropertyKey<T>>, _ newValue: T?, withCost cost: Int = 0) {
		
		let property = value[keyPath: keyPath]
		let key = property.key as NSString
		
		guard let newValue = newValue else {
			cache.removeObject(forKey: key)
			return
		}
		
		if T.self is AnyObject.Type {
			cache.setObject(newValue as AnyObject, forKey: key, cost: cost)
		} else {
			cache.setObject(Box(newValue), forKey: key, cost: cost)
		}
	}
	
	public subscript<T>(keyPath: KeyPath<Value, PropertyKey<T>>) -> T? {
		get { getProperty(keyPath) }
		set { setProperty(keyPath, newValue) }
	}
	
	@discardableResult
	public func delete() -> Bool {
		cache.removeAllObjects()
		return true
	}
}
