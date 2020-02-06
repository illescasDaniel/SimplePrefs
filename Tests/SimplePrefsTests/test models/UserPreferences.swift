//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 06/01/2020.
//

@testable import enum SimplePrefs.SimplePrefs

struct UserPreferences: Codable {
	var age: Int?
	var isDarkModeEnabled: Bool = false
	var person: Person = .init(name: "John")
}

// necessary for `UserDefaultsPreferencesManager`
extension UserPreferences: SimplePrefs.UserDefaultsKey {
	// It is recommended to use custom key values like these in order to save
	// unique keys into userDefaults (in case you use the same user defaults suite for
	// two different preferences)
	enum CodingKeys: String, CodingKey, CaseIterable {
		case age = "UserPreferences.age"
		case isDarkModeEnabled = "UserPreferences.isDarkModeEnabled"
		case person = "UserPreferences.person"
	}
}
