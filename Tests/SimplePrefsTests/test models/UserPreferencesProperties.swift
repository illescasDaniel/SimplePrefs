//
//  File.swift
//
//
//  Created by Daniel Illescas Romero on 06/01/2020.
//

@testable import enum SimplePrefs.SimplePrefs

struct UserPreferencesProperties: SimplePrefs.AllProperties {

	typealias key = SimplePrefs.PropertiesKey

	@key("age")
	var age: Int?
	
	@key("isDarkModeEnabled", defaultValue: false)
	var isDarkModeEnabled: Bool?
	
	@key("person", defaultValue: Person(name: "John"))
	var person: Person?

	var allProperties: [Any?] {[
		$age, $isDarkModeEnabled, $person
	]}
}
