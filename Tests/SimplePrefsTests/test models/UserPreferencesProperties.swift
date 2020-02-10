//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 06/02/2020.
//

@testable import enum SimplePrefs.SimplePrefs

struct UserPreferencesProperties {
	
	typealias key = SimplePrefs.Properties.Key
	
	@key("age")
	var age: Int?
	
	@key("isDarkModeEnabled", defaultValue: false)
	var isDarkModeEnabled: Bool?
	
	@key("person", defaultValue: Person(name: "John"))
	var person: Person?
	
	@key("car", defaultValue: Car(brand: "Toyota", model: "Celica", year: 1970))
	var car: Car?
}

// necessary for UserDefaults or Keychain
extension UserPreferencesProperties: SimplePrefs.Properties.KeysProtocol {
	var allProperties: SimplePrefs.Properties.Keys {[
		$age, $isDarkModeEnabled, $person, $car
	]}
}
