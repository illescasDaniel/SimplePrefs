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

final public class CachePropertiesPreferencesManager<Value: AllModelProperties>: PreferencesManager, PreferencesManagerInternals {
	
	internal var value: Value
	
	/// `UserDefaults` instance to use. `UserDefaults.standard` by default.
	public let cache = NSCache<NSString, AnyObject>()
	
	/// `UserDefaults` preferences manager
	/// - Parameters:
	///   - defaultValue: Default prefrerences data value.
	///   - userDefaults: `UserDefaults` instance to use. `UserDefaults.standard` by default.
	///   - totalCostLimit: The maximum total cost that the cache can hold before it starts evicting objects.
	///   - countLimit: The maximum number of objects the cache should hold.
	public init(defaultValue: Value, totalCostLimit: Int? = nil, countLimit: Int? = nil) {
		self.value = defaultValue
		if let totalCostLimit = totalCostLimit {
			self.cache.totalCostLimit = totalCostLimit
		}
		if let countLimit = countLimit {
			self.cache.countLimit = countLimit
		}
		for property in self.value.allProperties {
			if let genericWrapper = (property as? _GenericPropertiesWrapperProtocol) {
				genericWrapper.cacheWrapper?._cache = self.cache
				genericWrapper.userDefaultsWrapper = nil
				genericWrapper.keychainWrapper = nil
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
		self.cache.removeAllObjects()
		return true
	}
}
