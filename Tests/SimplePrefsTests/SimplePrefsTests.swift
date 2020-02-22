import func XCTest.XCTAssertEqual
import func XCTest.XCTAssertTrue
import func XCTest.XCTAssert
import class XCTest.XCTestCase
import class Foundation.JSONEncoder
import class Foundation.JSONSerialization
import class Foundation.FileManager
import struct Foundation.Data
@testable import enum SimplePrefs.SimplePrefs
@testable import protocol SimplePrefs.PreferencesManager

final class SimplePrefsTests: XCTestCase {
	
	let newAge: Int = 100
	let isDark = true
	let person = Person(name: "Daniel")
	let car = Car(brand: "Mercedez", model: "F1", year: 3243)
	
	//
	
	func testFilePrefs() {
		let prefs = SimplePrefs.File<UserPreferences>(defaultValue: .init())
		checkPrefs(prefs)
	}
	
	func testEncryptedFilePrefs() {
		#if canImport(CryptoKit)
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			let prefs = SimplePrefs.EncryptedFile<UserPreferences>(
				defaultValue: .init(),
				dataKey: Data("abcdefghijklmnopqrstuvwxyz123456".utf8)
			)
			checkPrefs(prefs)
		} else {
			print("EncryptedFilePreferencesManager not compatible")
		}
		#else
		print("EncryptedFilePreferencesManager not compatible")
		#endif
	}
	
	/*
	// Keychain doesn't work in Swift package manager (?)
	func testKeychainPrefs() {
		
		let prefs = SimplePrefs.Keychain<UserPreferences>(
			defaultValue: .init(),
			key: "com.myname.simpleprefs.tests"
		)
		checkPrefs(prefs)
	}*/
	
	func testUserDefaultPrefs() {
		let prefs = SimplePrefs.UserDefaults<UserPreferences>(defaultValue: .init())
		checkPrefs(prefs)
	}
	
	//
	
	func testUserDefaultsProperties() {
		
		let prefs = SimplePrefs.UserDefaultsProperties<UserPreferencesProperties>(defaultValue: .init())
		prefs.delete()
		
		// default values
		XCTAssertEqual(prefs[\.$age], nil)
		XCTAssertEqual(prefs.getProperty(\.$age), nil)
		XCTAssertEqual(prefs[\.$isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.$person], Person(name: "John"))
		XCTAssertEqual(prefs[\.$car], Car(brand: "Toyota", model: "Celica", year: 1970))
		
		// new values
		prefs[\.$age] = newAge
		prefs.setProperty(\.$isDarkModeEnabled, isDark)
		prefs[\.$person] = person
		prefs[\.$car] = car
		
		// checking values
		XCTAssertEqual(prefs[\.$age], newAge)
		XCTAssertEqual(prefs[\.$isDarkModeEnabled], isDark)
		XCTAssertEqual(prefs[\.$person], person)
		XCTAssertEqual(prefs[\.$car], car)
		
		XCTAssertTrue(prefs.delete())
		
		// default values
		XCTAssertEqual(prefs[\.$age], nil)
		XCTAssertEqual(prefs.getProperty(\.$age), nil)
		XCTAssertEqual(prefs[\.$isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.$person], Person(name: "John"))
		XCTAssertEqual(prefs[\.$car], Car(brand: "Toyota", model: "Celica", year: 1970))
	}
	
	func testCacheProperties() {
		
		let prefs = SimplePrefs.CacheProperties<UserPreferencesProperties>(defaultValue: .init())
		prefs.delete()
		
		// default values
		XCTAssertEqual(prefs[\.$age], nil)
		XCTAssertEqual(prefs.getProperty(\.$age), nil)
		XCTAssertEqual(prefs[\.$isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.$person], Person(name: "John"))
		XCTAssertEqual(prefs[\.$car], Car(brand: "Toyota", model: "Celica", year: 1970))
		
		// new values
		prefs[\.$age] = newAge
		prefs.setProperty(\.$isDarkModeEnabled, isDark)
		prefs[\.$person] = person
		prefs[\.$car] = car
		
		// checking values
		XCTAssertEqual(prefs[\.$age], newAge)
		XCTAssertEqual(prefs[\.$isDarkModeEnabled], isDark)
		XCTAssertEqual(prefs[\.$person], person)
		XCTAssertEqual(prefs[\.$car], car)
		
		XCTAssertTrue(prefs.delete())
		
		// default values
		XCTAssertEqual(prefs[\.$age], nil)
		XCTAssertEqual(prefs.getProperty(\.$age), nil)
		XCTAssertEqual(prefs[\.$isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.$person], Person(name: "John"))
		XCTAssertEqual(prefs[\.$car], Car(brand: "Toyota", model: "Celica", year: 1970))
	}
	
	// Keychain doesn't work in Swift package manager (?)
	/*func testKeychainProperties() {
		
		let prefs = SimplePrefs.KeychainProperties<UserPreferencesProperties>(defaultValue: .init())
		prefs.delete()
		
		// default values
		XCTAssertEqual(prefs[\.$age], nil)
		XCTAssertEqual(prefs.getProperty(\.$age), nil)
		XCTAssertEqual(prefs[\.$isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.$person], Person(name: "John"))
		XCTAssertEqual(prefs[\.$car], Car(brand: "Toyota", model: "Celica", year: 1970))
		
		// new values
		prefs[\.$age] = newAge
		prefs.setProperty(\.$isDarkModeEnabled, isDark)
		prefs[\.$person] = person
		prefs[\.$car] = car
		
		// checking values
		XCTAssertEqual(prefs[\.$age], newAge)
		XCTAssertEqual(prefs[\.$isDarkModeEnabled], isDark)
		XCTAssertEqual(prefs[\.$person], person)
		XCTAssertEqual(prefs[\.$car], car)
		
		XCTAssertTrue(prefs.delete())
	
		// default values
		XCTAssertEqual(prefs[\.$age], nil)
		XCTAssertEqual(prefs.getProperty(\.$age), nil)
		XCTAssertEqual(prefs[\.$isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.$person], Person(name: "John"))
		XCTAssertEqual(prefs[\.$car], Car(brand: "Toyota", model: "Celica", year: 1970))
	}
*/
	
	//
	
	func testRegisterDefaultsInUserDefaultPrefs() {
		
		let prefs = SimplePrefs.UserDefaults<UserPreferences>(defaultValue: .init())
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
		
		guard let carData = try? JSONEncoder().encode(prefs[\.car]),
			let carDictionary = (try? JSONSerialization.jsonObject(with: carData)) as? [String: Any] else {
			XCTAssert(false, "Error encoding car object")
			return
		}
		guard let userDefaultsCarDict = prefs.userDefaults.dictionary(forKey: UserPreferences.CodingKeys.car.rawValue) else {
			XCTAssert(false, "Error obtaining car dictionary from user defaults")
			return
		}
		XCTAssertEqual(
			carDictionary.keys,
			userDefaultsCarDict.keys
		)
		XCTAssertEqual(
			carDictionary[Car.CodingKeys.brand.rawValue] as? String,
			userDefaultsCarDict[Car.CodingKeys.brand.rawValue] as? String
		)
		
		// new values
		prefs[\.age] = newAge
		prefs[\.isDarkModeEnabled] = isDark
		prefs[\.person] = person
		prefs[\.car] = car
		
		// saving
		XCTAssertTrue(prefs.save())
		
		// loading and checking values
		XCTAssertTrue(prefs.load())
		XCTAssertEqual(prefs[\.age], newAge)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], isDark)
		XCTAssertEqual(prefs[\.person], person)
		XCTAssertEqual(prefs[\.car], car)
		
		XCTAssertTrue(prefs.delete())
	}
	
	static var allTests = [
		("testFilePrefs", testFilePrefs),
		("testEncryptedFilePrefs", testEncryptedFilePrefs),
		("testUserDefaultPrefs", testUserDefaultPrefs),
		("testUserDefaultsProperties", testUserDefaultsProperties),
		("testCacheProperties", testCacheProperties),
		//("testKeychainProperties", testKeychainProperties),
		//("testKeychainPrefs", testKeychainPrefs),
		("testRegisterDefaultsInUserDefaultPrefs", testRegisterDefaultsInUserDefaultPrefs)
	]
	
	// Convenience
	
	private func checkPrefs<Manager>(_ prefs: Manager) where Manager: PreferencesManager, Manager.Value == UserPreferences {
		
		_ = prefs.delete()
		
		// default values
		XCTAssertEqual(prefs[\.age], nil)
		XCTAssertEqual(prefs.getProperty(\.age), nil)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.person], Person(name: "John"))
		XCTAssertEqual(prefs[\.car], Car(brand: "Toyota", model: "Celica", year: 1970))
		
		// new values
		prefs[\.age] = newAge
		prefs.setProperty(\.isDarkModeEnabled, isDark)
		prefs[\.person] = person
		prefs[\.car] = car
		
		// saving
		XCTAssertTrue(prefs.save())
		
		// loading and checking values
		XCTAssertTrue(prefs.load())
		XCTAssertEqual(prefs[\.age], newAge)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], isDark)
		XCTAssertEqual(prefs[\.person], person)
		XCTAssertEqual(prefs[\.car], car)
		
		XCTAssertTrue(prefs.delete())
		
		// ~~~~
		
		// after deleting, it just deletes the "source" values, so the local ones stays the same
		// as long as the manager preferences instance (the manager) is alive
		XCTAssertEqual(prefs[\.age], newAge)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], isDark)
		XCTAssertEqual(prefs[\.person], person)
		XCTAssertEqual(prefs[\.car], car)
		
		// set the values again
		prefs[\.age] = newAge
		prefs.setProperty(\.isDarkModeEnabled, isDark)
		prefs[\.person] = person
		prefs[\.car] = car
		
		XCTAssertTrue(prefs.save())
		
		// to actually reset the values you use `deleteReplacing(with:)`
		// (you can also change the whole internal value by just using [\.self])
		XCTAssertTrue(prefs.deleteReplacing(with: .init()))
		
		// default values
		XCTAssertEqual(prefs[\.age], nil)
		XCTAssertEqual(prefs.getProperty(\.age), nil)
		XCTAssertEqual(prefs[\.isDarkModeEnabled], false)
		XCTAssertEqual(prefs[\.person], Person(name: "John"))
		XCTAssertEqual(prefs[\.car], Car(brand: "Toyota", model: "Celica", year: 1970))
	}
}
