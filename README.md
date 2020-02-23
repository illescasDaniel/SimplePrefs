# SimplePrefs

[![Swift version](https://img.shields.io/badge/Swift-5-orange.svg)](https://swift.org/download)
[![Version](https://img.shields.io/badge/version-2.5-green.svg)](https://github.com/illescasDaniel/SimplePrefs/releases)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/illescasDaniel/SimplePrefs/blob/master/LICENSE)

A simple way to manage your app preferences in your Swift projects (compatible with iOS, macOS, etc).

**⚠️ Warning:** the app uses the Apple library ***CryptoKit***. **You need to add a flag to your project** in order to compile it for a lower version than what the framework supports.
This is not something I can fix since since is not my fault. See more: https://stackoverflow.com/questions/58287922/cryptokit-craches-app-on-phones-with-ios-version-below-13

**TL;DR:** just add `-weak_framework CryptoKit` in "Other Linker Flags" in your project settings. 

## API (Preferences Managers):
```swift
associatedtype Value: Codable

func load() -> Bool

func getProperty<T>(_ keyPath: KeyPath<Value,T>) -> T
func setProperty<T>(_ keyPath: WritableKeyPath<Value,T>, _ value: T)
subscript<T>(keyPath: WritableKeyPath<Value,T>) -> T

func save() -> Bool

func delete() -> Bool
func deleteReplacing(with newValue: Value) -> Bool
```

### Specific **preferences managers** available:
- `SimplePrefs.File`: saves preferences as a **plain JSON file**.
- `SimplePrefs.EncryptedFile`: saves preferences as en **encrypted JSON file**.
- `SimplePrefs.Keychain`: saves preferences on **user's keychain**, the whole model object is saved with a **single key**.
- `SimplePrefs.UserDefaults`: saves preferences using **`UserDefaults`**  .
- `SimplePrefs.Mock`: doesn't persist anything but conforms to the same protocol as the others, it just uses a default instance passed in the constructor.

**Note:** all preferences managers sync with their respective underlying storage ONLY when calling the `load` or `save` methods.

Also, there are these "**Properties managers**", which behave similarly but you must create a model with specific keys for each value. 
**These are in sync with their underlying storage** all the time:
- `SimplePrefs.UserDefaultsProperties`: saves preferences using **`UserDefaults`**.
- `SimplePrefs.CacheProperties`: saves preferences using **`NSCache`**.
- `SimplePrefs.KeychainProperties`: saves preferences on user's keychain, **every value has its own key**.

## Usage

You need a **model** with the properties you want to save:
```swift
struct UserPreferences: Codable {
    var age: Int?
    var isDarkModeEnabled: Bool = false
    var person: Person = .init(name: "John") // must conform to `Codable`
}

// Only necessary for `SimplePrefs.UserDefaults`
extension UserPreferences: SimplePrefs.UserDefaultsKey {
    // It is recommended to use custom key values like these in order to save
    // unique keys into userDefaults
    enum CodingKeys: String, CodingKey, CaseIterable {
        case age = "UserPreferences.age"
        case isDarkModeEnabled = "UserPreferences.isDarkModeEnabled"
        case person = "UserPreferences.person"
    }
}
```
For **Properties managers**:
```swift
import enum SimplePrefs.SimplePrefs

struct UserPreferencesProperties {
    
    typealias key = SimplePrefs.Properties.Key
    
    @key("age")
    var age: Int?
    
    @key("isDarkModeEnabled", defaultValue: false)
    var isDarkModeEnabled: Bool?
    
    @key("person", defaultValue: Person(name: "John"))
    var person: Person?
}

// necessary for UserDefaults or Keychain
extension UserPreferencesProperties: SimplePrefs.Properties.KeysProtocol {
    var allProperties: SimplePrefs.Properties.Keys {[
        $age, $isDarkModeEnabled, $person
    ]}
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

// for "properties managers":
appPrefs[\.$isDarkModeEnabled] // gets a value
appPrefs[\.$age] = 60 // sets a value

appPrefs.save() // - saves preferences

// On iOS you may call the `save` method in
// `func applicationDidEnterBackground(UIApplication)` and/or `func applicationWillTerminate(UIApplication)`.
```

## Motivation

We all have used `UserDefaults` to store small data, mainly for user preferences in an application. Though is fast and reliable, you must store values using unique keys, which you should have as constants (or in an enum).
`UserDefaults` is easy but have some disadvantages like small capacity, having to use string keys to store and retrieve values, is not easy to get this preferences as something you can send or download over the internet (remote preferences saved in the cloud for example!).

That's basically why I created **`SimplePrefs`**, which have different classes that store your preferences in different ways.
You can save data as a **.json file** so its way easier to manage it, or in an **encrypted** file (with Apple's new CryptoKit), or save it on the **keychain** if you prefer, or even use **`UserDefaults`** as its storage (useful when using a `Settings.bundle` for your app preferences in the Settings app)
