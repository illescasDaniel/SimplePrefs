# SimplePrefs

[![Swift version](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://swift.org/download)
[![Version](https://img.shields.io/badge/version-2.1-green.svg)](https://github.com/illescasDaniel/Questions/releases)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/illescasDaniel/SimplePrefs/blob/master/LICENSE)

A simple way to manage your app preferences in your Swift projects (compatible with iOS, macOS, etc).

## API:
```swift
public protocol PreferencesManager {
	
	associatedtype Value: Codable
	
	func load() -> Bool
	func getProperty<T>(_ keyPath: KeyPath<Value,T>) -> T
	mutating func setProperty<T>(_ keyPath: WritableKeyPath<Value,T>, _ value: T)
	func save() -> Bool
	func delete() -> Bool
}
public extension PreferencesManager {
	subscript<T>(keyPath: WritableKeyPath<Value,T>) -> T {
		get { getProperty(keyPath) }
		set { setProperty(keyPath, newValue) }
	}
}
```

### Specific **preferences managers** available:
- `SimplePrefs.File`: saves preferences as a **plain JSON file**
- `SimplePrefs.EncryptedFile`: saves preferences as en **encrypted JSON file**
- `SimplePrefs.Keychain`: saves preferences on **user's keychain**
- `SimplePrefs.UserDefaults`: saves preferences using **`UserDefaults`**
- `SimplePrefs.Mock`: doesn't persist anything but conforms to the same protocol as the others, it just uses a default instance passed in the constructor.

## Usage

You need a **model** with the properties you want to save:
```swift
// The model
struct UserPreferences: Codable {
    var age: Int?
    var isDarkModeEnabled: Bool = false
    var person: Person = .init(name: "John") // must conform to `Codable`
}

// Only necessary for `SimplePrefs.UserDefaults`
extension UserPreferences: CodableWithKeys {
    // It is recommended to use custom key values like these in order to save
    // unique keys into userDefaults (in case you use the same user defaults suite for
    // two different preferences)
    enum CodingKeys: String, CodingKey, CaseIterable {
        case age = "UserPreferences.age"
        case isDarkModeEnabled = "UserPreferences.isDarkModeEnabled"
        case person = "UserPreferences.person"
    }
}
```

The recommended way of using your preferences:
```swift
enum AppPrefs {
    #if DEBUG
    typealias Instance = SimplePrefs.Mock<UserPreferences>
    static let instance = Instance(defaultValue: .init(
        age: 22,
        isDarkModeEnabled: false,
        person: .init(name: "Peter"
    )))
    #else
    typealias Instance = SimplePrefs.File<UserPreferences>
    static let instance = Instance(defaultValue: .init())
    #endif
}

var appPrefs: AppPrefs.Instance { AppPrefs.instance }
```

Usage:
```swift
appPrefs.load() // - loads preferences

appPrefs[\.isDarkModeEnabled] // gets a value
appPrefs[\.age] = 60 // sets a value
// also: appPrefs.setProperty(\.age, value: 60)
// also: appPrefs.getProperty(\.isDarkModeEnabled)

appPrefs.save() // - saves preferences

// On iOS you may call the `save` method in
// `func applicationDidEnterBackground(UIApplication)` and/or `func applicationWillTerminate(UIApplication)`.
```

## Motivation

We all have used `UserDefaults` to store small data, mainly for user preferences in an application. Though is fast and reliable, you must store values using unique keys, which you should have as constants (or in an enum).
`UserDefaults` is easy but have some disadvantages like small capacity, having to use string keys to store and retrieve values, is not easy to get this preferences as something you can send or download over the internet (remote preferences saved in the cloud for example!).

That's basically why I created **`SimplePrefs`**, which have different classes that store your preferences in different ways.
You can save data as a **.json file** so its way easier to manage it, or in an **encrypted** file (with Apple's new CryptoKit), or save it on the **keychain** if you prefer, or even use **`UserDefaults`** as its storage (useful when using a `Settings.bundle` for your app preferences in the Settings app)
