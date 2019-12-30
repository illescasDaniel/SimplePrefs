//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 30/12/2019.
//

import Foundation
@testable import SimplePrefs

struct FilePreferencesExample: FilePreferences {
	
	static var shared: Self = _loadedPreferences() ?? .init()
	
	// MARK: Properties
	
	var age: Int?
	var isDarkModeEnabled: Bool = false
	var person: Person = .init(name: "John")
}
