//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 30/12/2019.
//

import Foundation
@testable import SimplePrefs

protocol AppFilePreferences: Preferences {
	var age: Int? { get set }
	var isDarkModeEnabled: Bool { get set }
	var person: Person { get set }
}

struct DefaultAppFilePreferencesManager: AppFilePreferences, FilePreferences {
	var age: Int?
	var isDarkModeEnabled: Bool = false
	var person: Person = .init(name: "John")
}

struct MockAppFilePreferencesManager: AppFilePreferences {
	
	func save() -> Bool { true }
	
	var age: Int? = 90
	var isDarkModeEnabled: Bool = true
	var person: Person = .init(name: "Something here")
}

struct AppFilePreferencesManager {
	static var shared: AppFilePreferences = DefaultAppFilePreferencesManager.loadedOrNew() // or: MockAppFilePreferencesManager()
}
