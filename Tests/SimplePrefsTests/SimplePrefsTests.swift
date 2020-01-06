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
		XCTAssertEqual(prefs.value.age, nil)
		XCTAssertEqual(prefs.value.isDarkModeEnabled, false)
		XCTAssertEqual(prefs.value.person, Person(name: "John"))
		
		// new values
		prefs.value.age = newAge
		prefs.value.isDarkModeEnabled = isDark
		prefs.value.person = person
		
		// saving
		XCTAssertTrue(prefs.save())
		XCTAssertTrue(FileManager.default.fileExists(atPath: prefs.path))
		
		// loading and checking values
		XCTAssertTrue(prefs.load())
		XCTAssertEqual(prefs.value.age, newAge)
		XCTAssertEqual(prefs.value.isDarkModeEnabled, isDark)
		XCTAssertEqual(prefs.value.person, person)
		
		prefs.delete()
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
			XCTAssertEqual(prefs.value.age, nil)
			XCTAssertEqual(prefs.value.isDarkModeEnabled, false)
			XCTAssertEqual(prefs.value.person, Person(name: "John"))
			
			// new values
			prefs.value.age = newAge
			prefs.value.isDarkModeEnabled = isDark
			prefs.value.person = person
			
			// saving
			XCTAssertTrue(prefs.save())
			XCTAssertTrue(FileManager.default.fileExists(atPath: prefs.path))
			
			// loading and checking values
			XCTAssertTrue(prefs.load())
			XCTAssertEqual(prefs.value.age, newAge)
			XCTAssertEqual(prefs.value.isDarkModeEnabled, isDark)
			XCTAssertEqual(prefs.value.person, person)
		} else {
			print("EncryptedFilePreferencesManager not compatible")
		}
		#else
		print("EncryptedFilePreferencesManager not compatible")
		#endif
	}
	
	func testUserDefaultPrefs() {
		
		let prefs = SimplePrefs.UserDefaults<UserPreferences>(defaultValue: .init())
		prefs.delete()
		
		// default values
		XCTAssertEqual(prefs.value.age, nil)
		XCTAssertEqual(prefs.value.isDarkModeEnabled, false)
		XCTAssertEqual(prefs.value.person, Person(name: "John"))
		
		// new values
		prefs.value.age = newAge
		prefs.value.isDarkModeEnabled = isDark
		prefs.value.person = person
		
		// saving
		XCTAssertTrue(prefs.save())
		
		// loading and checking values
		XCTAssertTrue(prefs.load())
		XCTAssertEqual(prefs.value.age, newAge)
		XCTAssertEqual(prefs.value.isDarkModeEnabled, isDark)
		XCTAssertEqual(prefs.value.person, person)
		
		prefs.delete()
	}
	
	// Keychain doesn't work in Swift package manager (?)
	/*func testKeychainPrefs() {
		
		let prefs = KeychainPreferencesManager<UserPreferences>(
			defaultValue: .init(),
			key: "com.myname.simpleprefs.tests"
		)
		prefs.delete()
		
		// default values
		XCTAssertEqual(prefs.value.age, nil)
		XCTAssertEqual(prefs.value.isDarkModeEnabled, false)
		XCTAssertEqual(prefs.value.person, Person(name: "John"))
		
		// new values
		prefs.value.age = newAge
		prefs.value.isDarkModeEnabled = isDark
		prefs.value.person = person
		
		// saving
		XCTAssertTrue(prefs.save())
		
		// loading and checking values
		XCTAssertTrue(prefs.load())
		XCTAssertEqual(prefs.value.age, newAge)
		XCTAssertEqual(prefs.value.isDarkModeEnabled, isDark)
		XCTAssertEqual(prefs.value.person, person)
		
		prefs.delete()
	}*/
	
	static var allTests = [
		("testFilePrefs", testFilePrefs),
		("testEncryptedFilePrefs", testEncryptedFilePrefs),
		("testUserDefaultPrefs", testUserDefaultPrefs),
		//("testKeychainPrefs", testKeychainPrefs)
	]
}
