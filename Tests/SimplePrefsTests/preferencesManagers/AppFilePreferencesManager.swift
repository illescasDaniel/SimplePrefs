//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 06/01/2020.
//

import Foundation
@testable import SimplePrefs

enum AppFilePreferencesManager {
/* Example using mock default values preferences */
//	#if DEBUG
//	static let shared = DefaultMockPreferencesManager<UserPreferences>(
//		defaultValue: .init(age: 22, isDarkModeEnabled: false, person: .init(name: "Peter"))
//	)
//	#else
	static let shared = SimplePrefs.File<UserPreferences>(defaultValue: .init()).loaded
//	#endif
}
