# SimplePrefs

[![Swift version](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://swift.org/download)
[![Version](https://img.shields.io/badge/version-1.0.1--beta-green.svg)](https://github.com/illescasDaniel/Questions/releases)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/illescasDaniel/SimplePrefs/blob/master/LICENSE)

Simple, easy and fast preferences for your Swift projects.

**Note:** you can find full usage examples in the `Tests` folder.

To use this library, you must create a `struct` which implements one of the following protocols:
- `FilePreferences` (saves preferences as a plain JSON file), 
- `EncryptedFilePreferences` (saves preferences as en encrypted JSON file) or 
- `UserDefaultsPreferences` (saves preferences in the UserDefaults)

In this struct you just need to:
- Declare all the properties (must conform to Codable protocol) that you want to save.
- Declare a `shared` property with this default value: `_loadedPreferences() ?? .init()`, that is, the loaded preferences (either from disk or other source) or if there are no previous preferences saved, a new clean instance is created.
- (Only for encrypted prefs.) Declare a `dataKey: Data` property, containing the 256bits key used for encryption.
- (Only necessary for user defaults) Declare a `CodingKeys` enum conforming to `String, CodingKey, CaseIterable` with the user preferences keys.

**Example:**

```swift
struct FilePreferencesExample: FilePreferences {
	
	static var shared: Self = _loadedPreferences() ?? .init()
	
	// MARK: Properties
	
	var age: Int?
	var isDarkModeEnabled: Bool = false
	var person: Person = .init(name: "John") // `Person` must conform to `Codable`
}
```
**Usage:**
```swift

FilePreferencesExample.shared.isDarkMode = true
print(FilePreferencesExample.shared.isDarkMode) // true

FilePreferencesExample.shared.save()

// On iOS you may call the `save` method in 
// `func applicationDidEnterBackground(UIApplication)`
// and/or `func applicationWillTerminate(UIApplication)`.
// The `save` method persists your current preferences object on disk (in this case)
```
