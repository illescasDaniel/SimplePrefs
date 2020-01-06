//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 06/01/2020.
//

import Foundation
@testable import SimplePrefs

struct UserPreferences: Codable {
	var age: Int?
	var isDarkModeEnabled: Bool = false
	var person: Person = .init(name: "John")
}

// necessary for `UserDefaultsPreferencesManager`
extension UserPreferences: CodableWithKeys {
	enum CodingKeys: String, CodingKey, CaseIterable {
		case age
		case isDarkModeEnabled
		case person
	}
}
