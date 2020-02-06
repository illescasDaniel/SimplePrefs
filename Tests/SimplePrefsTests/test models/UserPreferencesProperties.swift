//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 06/02/2020.
//

@testable import enum SimplePrefs.SimplePrefs

struct UserPreferencesProperties {
	
	typealias key = SimplePrefs.Key
	
	@key("age")
	var age: Int?
	
	@key("isDarkModeEnabled", defaultValue: false)
	var isDarkModeEnabled: Bool?
	
	@key("person", defaultValue: Person(name: "John"))
	var person: Person?
}

// necessary for UserDefaults or Keychain
extension UserPreferencesProperties: SimplePrefs.AllKeys {
	var allProperties: [SimplePrefs.KeyProtocol] {[
		$age, $isDarkModeEnabled, $person
	]}
}
