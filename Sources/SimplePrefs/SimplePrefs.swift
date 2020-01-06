//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 06/01/2020.
//

import Foundation

enum SimplePrefs {
	
	typealias File<T: Codable> = FilePreferencesManager<T>
	typealias Keychain<T: Codable> = KeychainPreferencesManager<T>
	typealias UserDefaults<T: CodableWithKeys> = UserDefaultsPreferencesManager<T>
	
	typealias Mock<T: Codable> = DefaultMockPreferencesManager<T>
}

#if canImport(CryptoKit)
extension SimplePrefs {
	@available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *)
	typealias EncryptedFile = EncryptedFilePreferencesManager
}
#endif
