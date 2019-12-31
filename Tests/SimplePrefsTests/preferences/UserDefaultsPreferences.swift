//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 30/12/2019.
//

import Foundation
@testable import SimplePrefs

struct UserDefaultsPreferencesManager: Preferences, UserDefaultsPreferences {
	
	static var shared: Self = Self.loaded() ?? Self()
	
	enum CodingKeys: String, CodingKey, CaseIterable {
		case age
		// if you want a custom key text: case age = "myAgeKey"
		case isDarkModeEnabled
		case person
	}
	
	// MARK: Properties
	
	var age: Int?
	var isDarkModeEnabled: Bool = false
	var person: Person = .init(name: "John")
}
