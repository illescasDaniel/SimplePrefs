//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 31/12/2019.
//

import Foundation
@testable import SimplePrefs

struct AppKeychainPreferencesManager: KeychainPreferences {
	
	static var key: String {
		"AKey1234"
	}
	
	static var shared: Self = Self.loadedOrNew()
	
	// MARK: Properties
	
	var userName: String = "guest"
	var password: String?
	var randomThing: Int = 12
}
