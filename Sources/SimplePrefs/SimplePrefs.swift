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

public enum SimplePrefs {
	
	public typealias File = FilePreferencesManager
	public typealias Keychain = KeychainPreferencesManager
	public typealias UserDefaults = UserDefaultsPreferencesManager
	public typealias UserDefaultsKey = CodableModelWithStringKeysCaseIterable
	
	public typealias KeychainProperties = KeychainPropertiesManager
	public typealias CacheProperties = CachePropertiesManager
	public typealias UserDefaultsProperties = UserDefaultsPropertiesManager
	
	public typealias KeyProtocol = PropertyKeyProtocol
	public typealias Key = PropertyKey
	
	#if canImport(CryptoKit)
	@available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *)
	public typealias EncryptedFile = EncryptedFilePreferencesManager
	#endif
	
	public typealias Mock = DefaultMockPreferencesManager
	
	public typealias AllKeys = AllPropertyKeys
}
