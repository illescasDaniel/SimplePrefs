import XCTest
@testable import SimplePrefs

final class SimplePrefsTests: XCTestCase {
	
	let newAge: Int = 100
	let isDark = true
	let person = Person(name: "Daniel")
	
	//
	
	func testFilePrefs() {
		
		let prefs = SimplePrefs.File<UserPreferences>(defaultValue: .init())
		prefs.delete()
		
		// default values
		XCTAssertEqual(prefs[\.age], nil)
		XCTAssertEqual(prefs.getProperty(\.age), nil)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.person], Person(name: "John"))
		
		// new values
		prefs[\.age] = newAge
		prefs.setProperty(\.isDarkModeEnabled, isDark)
		prefs[\.person] = person
		
		// saving
		XCTAssertTrue(prefs.save())
		XCTAssertTrue(FileManager.default.fileExists(atPath: prefs.path))
		
		// loading and checking values
		XCTAssertTrue(prefs.load())
		XCTAssertEqual(prefs[\.age], newAge)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], isDark)
		XCTAssertEqual(prefs[\.person], person)
		
		XCTAssertTrue(prefs.delete())
	}
	
	func testEncryptedFilePrefs() {
		#if canImport(CryptoKit)
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			let prefs = SimplePrefs.EncryptedFile<UserPreferences>(
				defaultValue: .init(),
				dataKey: Data("abcdefghijklmnopqrstuvwxyz123456".utf8)
			)
			prefs.delete()
			
			// default values
			XCTAssertEqual(prefs[\.age], nil)
			XCTAssertEqual(prefs.getProperty(\.age), nil)
			XCTAssertEqual(prefs[\.isDarkModeEnabled], false)
			XCTAssertEqual(prefs[\.person], Person(name: "John"))
			
			// new values
			prefs[\.age] = newAge
			prefs.setProperty(\.isDarkModeEnabled, isDark)
			prefs[\.person] = person
			
			// saving
			XCTAssertTrue(prefs.save())
			XCTAssertTrue(FileManager.default.fileExists(atPath: prefs.path))
			
			// loading and checking values
			XCTAssertTrue(prefs.load())
			XCTAssertEqual(prefs[\.age], newAge)
			XCTAssertEqual(prefs[\.isDarkModeEnabled], isDark)
			XCTAssertEqual(prefs[\.person], person)
			
			XCTAssertTrue(prefs.delete())
		} else {
			print("EncryptedFilePreferencesManager not compatible")
		}
		#else
		print("EncryptedFilePreferencesManager not compatible")
		#endif
	}
	
	func testLazyUserDefaultPrefs() {
		
		let prefs = SimplePrefs.LazyUserDefaults<UserPreferences>(defaultValue: .init())
		prefs.delete()
		
		// default values
		XCTAssertEqual(prefs[\.age], nil)
		XCTAssertEqual(prefs.getProperty(\.age), nil)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.person], Person(name: "John"))
		
		// new values
		prefs[\.age] = newAge
		prefs.setProperty(\.isDarkModeEnabled, isDark)
		prefs[\.person] = person
		
		// saving
		XCTAssertTrue(prefs.save())
		
		// loading and checking values
		XCTAssertTrue(prefs.load())
		XCTAssertEqual(prefs[\.age], newAge)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], isDark)
		XCTAssertEqual(prefs[\.person], person)
		
		XCTAssertTrue(prefs.delete())
	}
	
	func testUserDefaultsPrefs() {
		
		let prefs = SimplePrefs.UserDefaults<UserPreferences2>(defaultValue: .init())
		prefs.delete()
		
		// default values
		XCTAssertEqual(prefs[\.age], nil)
		XCTAssertEqual(prefs.getProperty(\.age), nil)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.person], Person(name: "John"))
		
		// new values
		prefs[\.age] = newAge
		prefs.setProperty(\.isDarkModeEnabled, isDark)
		prefs[\.person] = person
		
		// saving
		XCTAssertTrue(prefs.save())
		
		// loading and checking values
		XCTAssertTrue(prefs.load())
		XCTAssertEqual(prefs[\.age], newAge)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], isDark)
		XCTAssertEqual(prefs[\.person], person)
		
		XCTAssertTrue(prefs.delete())
	}
	
	// Keychain doesn't work in Swift package manager (?)
	/*func testKeychainPrefs() {
		
		let prefs = KeychainPreferencesManager<UserPreferences>(
			defaultValue: .init(),
			key: "com.myname.simpleprefs.tests"
		)
		prefs.delete()
		
		// default values
		XCTAssertEqual(prefs[\.age], nil)
		XCTAssertEqual(prefs.getProperty(\.age), nil)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.person], Person(name: "John"))
		
		// new values
		prefs[\.age] = newAge
		prefs.setProperty(\.isDarkModeEnabled, isDark)
		prefs[\.person] = person
		
		// saving
		XCTAssertTrue(prefs.save())
		
		// loading and checking values
		XCTAssertTrue(prefs.load())
		XCTAssertEqual(prefs[\.age], newAge)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], isDark)
		XCTAssertEqual(prefs[\.person], person)
		
		XCTAssertTrue(prefs.delete())
	}*/
	
	//
	
	func testRegisterDefaultsInUserDefaultPrefs() {
		
		let prefs = SimplePrefs.LazyUserDefaults<UserPreferences>(defaultValue: .init())
		prefs.delete()
		
		XCTAssertTrue(prefs.registerDefaults())
		
		// default values
		XCTAssertEqual(
			prefs[\.age] ?? 0,
			prefs.userDefaults.integer(forKey: UserPreferences.CodingKeys.age.rawValue)
		)
		XCTAssertEqual(
			prefs[\.isDarkModeEnabled],
			prefs.userDefaults.bool(forKey: UserPreferences.CodingKeys.isDarkModeEnabled.rawValue)
		)
		guard let personData = try? JSONEncoder().encode(prefs[\.person]),
			let personDictionary = (try? JSONSerialization.jsonObject(with: personData)) as? [String: Any] else {
			XCTAssert(false, "Error encoding person object")
			return
		}
		guard let userDefaultsPersonDict = prefs.userDefaults.dictionary(forKey: UserPreferences.CodingKeys.person.rawValue) else {
			XCTAssert(false, "Error obtaining person dictionary from user defaults")
			return
		}
		XCTAssertEqual(
			personDictionary.keys,
			userDefaultsPersonDict.keys
		)
		XCTAssertEqual(
			personDictionary[Person.CodingKeys.name.rawValue] as? String,
			userDefaultsPersonDict[Person.CodingKeys.name.rawValue] as? String
		)
		
		// new values
		prefs[\.age] = newAge
		prefs[\.isDarkModeEnabled] = isDark
		prefs[\.person] = person
		
		// saving
		XCTAssertTrue(prefs.save())
		
		// loading and checking values
		XCTAssertTrue(prefs.load())
		XCTAssertEqual(prefs[\.age], newAge)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], isDark)
		XCTAssertEqual(prefs[\.person], person)
		
		XCTAssertTrue(prefs.delete())
	}
	
	static var allTests = [
		("testFilePrefs", testFilePrefs),
		("testEncryptedFilePrefs", testEncryptedFilePrefs),
		("testLazyUserDefaultPrefs", testLazyUserDefaultPrefs),
		("testUserDefaultsPrefs", testUserDefaultsPrefs),
		//("testKeychainPrefs", testKeychainPrefs),
		("testRegisterDefaultsInUserDefaultPrefs", testRegisterDefaultsInUserDefaultPrefs)
	]
}
