# SimplePrefs

[![Swift version](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://swift.org/download)
[![Version](https://img.shields.io/badge/version-2.0-green.svg)](https://github.com/illescasDaniel/Questions/releases)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/illescasDaniel/SimplePrefs/blob/master/LICENSE)

A simple way to manage your app preferences in your Swift projects (compatible with iOS, macOS, etc).

## Usage

**Note:** you can find full examples in the `Tests` folder.

These are the preferences managers available right now:
- `SimplePrefs.File`: saves preferences as a plain JSON file
- `SimplePrefs.EncryptedFile`: saves preferences as en encrypted JSON file
- `SimplePrefs.Keychain`: saves preferences on user's keychain
- `SimplePrefs.UserDefaults`: saves preferences using `UserDefaults`)`
- `SimplePrefs.Mock`: doesn't persist anything but conforms to the same protocol as the others, it just uses a default instance passed in the constructor.

```swift
// The model
struct UserPreferences: Codable {
	var age: Int?
	var isDarkModeEnabled: Bool = false
	var person: Person = .init(name: "John")
}

// Only necessary for `UserDefaultsPreferencesManager`
extension UserPreferences: CodableWithKeys {
	enum CodingKeys: String, CodingKey, CaseIterable {
		case age
		case isDarkModeEnabled
		case person
	}
}

// The recommended preferences manager which uses a mock instance if runnning on a DEBUG executable
enum AppFilePreferencesManager {
	#if DEBUG
	static let shared = SimplePrefs.Mock<UserPreferences>(
		defaultValue: .init(age: 22, isDarkModeEnabled: false, person: .init(name: "Peter"))
	)
	#else
	static let shared = SimplePrefs.File<UserPreferences>(defaultValue: .init()).loaded
	#endif
}

```
```swift
// You must call the `load` method here, or use `loaded` when creating the shared instance
// AppFilePreferencesManager.shared.load()

AppFilePreferencesManager.shared.age = 20 // Optional(20)
AppFilePreferencesManager.shared.isDarkModeEnabled // false

AppFilePreferencesManager.shared.save() // saves preferences
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
