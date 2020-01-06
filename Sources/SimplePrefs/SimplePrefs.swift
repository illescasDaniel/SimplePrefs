//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 06/01/2020.
//

import Foundation

enum SimplePrefs {
	
	typealias File = FilePreferencesManager
	@available(OSX 10.15, *)
	typealias EncryptedFile = EncryptedFilePreferencesManager
	typealias Keychain = KeychainPreferencesManager
	typealias UserDefaults = UserDefaultsPreferencesManager
	
	typealias Mock = DefaultMockPreferencesManager
}
