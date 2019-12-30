//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 30/12/2019.
//

import Foundation
@testable import SimplePrefs

@available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *)
struct EncryptedFilePreferencesExample: EncryptedFilePreferences {
	
	// 256 bit key / 32 bytes key / 32 UInt8 numbers or characters
	// you can use 32 ASCII characters text or raw bytes using an array
	static let dataKey = Data("danielDanielThisIsAKeyLOL0000000".utf8)/*Data([
		1,2,3,4,5,1,2,3,4,5,
		1,2,3,4,5,1,2,3,4,5,
		1,2,3,4,5,1,2,3,4,5,
		6,7
	])*/
	
	static var shared: Self = _loadedPreferences() ?? .init()
	
	// optional to override
	static var fileName: String {
		".prefs.enc"
	}
	
	// MARK: Properties
	
	var age: Int?
	var isDarkModeEnabled: Bool = false
	var person: Person = .init(name: "John")
}
