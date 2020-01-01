# SimplePrefs

[![Swift version](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://swift.org/download)
[![Version](https://img.shields.io/badge/version-1.3.0-green.svg)](https://github.com/illescasDaniel/Questions/releases)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/illescasDaniel/SimplePrefs/blob/master/LICENSE)

A simple way to manage your app preferences in your Swift projects (compatible with iOS, macOS, etc).

## Usage

**Note:** you can find full usage examples in the `Tests` folder.

To use this library, you must create a `struct` which implements one of the following protocols:
- `FilePreferences` (saves preferences as a plain JSON file), 
- `EncryptedFilePreferences` (saves preferences as en encrypted JSON file),
- `KeychainPreferences` (saves preferences on user's keychain),
- `UserDefaultsPreferences` (saves preferences using `UserDefaults`)

You can also have `mock` implementations of your preferences, see `AppFilePreferences.swift` file to see an actual example; in that case you can use the generic `Preferences` protocol too.

In this struct you just need to:
- Declare all the properties (must conform to `Codable` protocol) that you want to save.
- (singleton) Declare a static variable `shared` with this default value: `Self.loaded() ?? Self()` or `Self.loadedOrNew()`, that is, an instance with loaded preferences (either from disk or other source) or if there are no previous preferences saved, a new clean instance is created.

- (Only for keychain prefs.) Declare a `key: String` property, containing a `String` key (like a key from a dictionary, just to identify it).
- (Only for encrypted prefs.) Declare a `dataKey: Data` property, containing the 256bits key used for encryption.
- (Only necessary for user defaults) Declare a `CodingKeys` enum conforming to `String, CodingKey, CaseIterable` with the user preferences keys.

**Example:**

```swift
struct AppPreferencesManager: FilePreferences {
	
    static var shared: Self = Self.loaded() ?? Self()
	
    // MARK: Properties
	
    var age: Int?
    var isDarkModeEnabled: Bool = false
    var person: Person = .init(name: "John") // `Person` must conform to `Codable`
}
```
```swift

AppPreferencesManager.shared.isDarkMode = true
print(AppPreferencesManager.shared.isDarkMode) // true

AppPreferencesManager.shared.save()

// On iOS you may call the `save` method in 
// `func applicationDidEnterBackground(UIApplication)`
// and/or `func applicationWillTerminate(UIApplication)`.
// The `save` method persists your current preferences object on disk (in this case)
```

## Motivation

We all have used `UserDefaults` to store small data, mainly for user preferences in an application. Though is fast and reliable, you must store values using unique keys, which you should have as constants (or in an enum). 
`UserDefaults` is easy but have some disadvantages like small capacity, having to use string keys to store and retrieve values, is not easy to get this preferences as something you can send or download over the internet (remote preferences saved in the cloud for example!).

That's basically why I created **`SimplePrefs`**, which have different classes that store your preferences in different ways.
You can save data as a **.json file** so its way easier to manage it, or in an **encrypted** file (with Apple's new CryptoKit), or save it on the **keychain** if you prefer, or even use **`UserDefaults`** as its storage (useful when using a `Settings.bundle` for your app preferences in the Settings app)
