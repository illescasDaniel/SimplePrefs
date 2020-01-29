//
//  File.swift
//
//
//  Created by Daniel Illescas Romero on 06/01/2020.
//

import Foundation
@testable import SimplePrefs

struct UserPreferences2: WithKeys {

	typealias key = UserDefaultsKeyValueWrapper
	typealias k = CodingKeys
	
	@key(k.age)
	var age: Int?
	
	@key(k.isDarkModeEnabled, defaultValue: false)
	var isDarkModeEnabled: Bool?
	
	@key(k.person, defaultValue: Person(name: "John"))
	var person: Person?
	
	enum CodingKeys: CodingKey, CaseIterable {
		case age
		case isDarkModeEnabled
		case person
	}
}
