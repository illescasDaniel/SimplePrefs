//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 06/01/2020.
//

import Foundation

public enum SimplePrefs {
	
	typealias File = FilePreferencesManager
	typealias Keychain = KeychainPreferencesManager
	typealias UserDefaults = UserDefaultsPreferencesManager
	
	typealias Mock = DefaultMockPreferencesManager
}

#if canImport(CryptoKit)
public extension SimplePrefs {
	@available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *)
	typealias EncryptedFile = EncryptedFilePreferencesManager
}
#endif
