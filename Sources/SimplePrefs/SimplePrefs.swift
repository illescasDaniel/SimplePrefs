//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 06/01/2020.
//

public enum SimplePrefs {
	
	public typealias File = FilePreferencesManager
	public typealias Keychain = KeychainPreferencesManager
	public typealias UserDefaults = UserDefaultsPreferencesManager
	public typealias UserDefaultsKey = CodableModelWithStringKeysCaseIterable
	
	#if canImport(CryptoKit)
	@available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *)
	public typealias EncryptedFile = EncryptedFilePreferencesManager
	#endif
	
	public typealias Mock = DefaultMockPreferencesManager
}
