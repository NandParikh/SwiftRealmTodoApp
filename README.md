
https://github.com/user-attachments/assets/31fbf0ee-df38-473e-9b94-972f82ef70b5


# Realm Database in Swift (Complete Guide)

## 📘 What is Realm?

**Realm** is a lightweight, high-performance mobile database designed
for iOS and Android apps. It serves as an alternative to Core Data or
SQLite --- providing an object-oriented approach with less boilerplate
code.

It automatically saves Swift objects to a local `.realm` file, which can
be viewed using **Realm Studio** or **Realm Browser**.

------------------------------------------------------------------------

## ⚙️ Adding Realm to Your Project

### **Using CocoaPods**

``` bash
pod 'RealmSwift'
```

Then run:

``` bash
pod install
```

### **Using Swift Package Manager**

In **Xcode → File → Add Packages**, search for:

    https://github.com/realm/realm-swift

Import it:

``` swift
import RealmSwift
```

------------------------------------------------------------------------

## 🧱 Setting Up Realm

In your **AppDelegate.swift**:

``` swift
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return true
    }
}
```

This prints your local database file path (usually `default.realm`).

------------------------------------------------------------------------

## 🧩 Defining Realm Models

Realm objects must subclass `Object`. Use `@objc dynamic` for persisted
properties.

``` swift
class DataModel: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
```

### Why `@objc dynamic`?

-   `@objc` exposes the property to the Objective‑C runtime (Realm uses
    it internally for reflection).
-   `dynamic` enables **KVO (Key‑Value Observing)**, allowing Realm to
    detect changes at runtime.

------------------------------------------------------------------------

## 💾 Writing and Reading Data

``` swift
let realm = try! Realm()
let person = DataModel()
person.name = "Nand"
person.age = 35

try! realm.write {
    realm.add(person)
}
```

### Fetch Data

``` swift
let results = realm.objects(DataModel.self)
```

### Delete Data

``` swift
try! realm.write {
    realm.delete(person)
}
```

------------------------------------------------------------------------

## 🔗 Relationships Between Objects

Realm supports **one‑to‑many** and **inverse** relationships using
`List` and `LinkingObjects`.

Example: **Category ↔ Item**

``` swift
class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() // One‑to‑many relationship
}

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // Inverse relationship (many‑to‑one)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
```

-   `List<Item>` = array‑like container that holds related `Item`
    objects.
-   `LinkingObjects` = automatically links back to the parent category
    (no need to manually assign).

------------------------------------------------------------------------

## 🧠 Example: Using Realm in a To‑Do App

### Save a new category:

``` swift
func save(category: Category) {
    do {
        try realm.write {
            realm.add(category)
        }
    } catch {
        print("Error saving category: \(error)")
    }
}
```

### Load categories:

``` swift
categories = realm.objects(Category.self)
```

### Delete a category:

``` swift
try realm.write {
    realm.delete(categoryToDelete)
}
```

### Query with Filter and Sort:

``` swift
todoItems = todoItems?
    .filter("title CONTAINS[cd] %@", searchBar.text!)
    .sorted(byKeyPath: "dateCreated", ascending: true)
```

------------------------------------------------------------------------

## 🧰 Realm File Info

-   **Default File:** `default.realm`
-   **View Database:** Use **Realm Studio** to open the file path
    printed from `AppDelegate`.

``` swift
print(Realm.Configuration.defaultConfiguration.fileURL!)
```

------------------------------------------------------------------------

## 🧩 Summary for Interviews

  Concept              Description
  -------------------- ----------------------------------------------
  **Realm**            Lightweight object‑based mobile database
  **@objc dynamic**    Required for Realm's data persistence & KVO
  **List**             Defines a one‑to‑many relationship
  **LinkingObjects**   Inverse relationship reference (many‑to‑one)
  **Realm Studio**     GUI tool to view `.realm` database
  **default.realm**    Default data storage file created by Realm

------------------------------------------------------------------------

## ✅ Advantages of Realm

-   Fast, thread‑safe, and lightweight.
-   Object‑oriented (no SQL queries).
-   Relationships handled easily with `List` and `LinkingObjects`.
-   Works offline automatically.

------------------------------------------------------------------------

## 🚀 Quick Reference Code

``` swift
let realm = try! Realm()
let newCategory = Category()
newCategory.name = "Work"

try! realm.write {
    realm.add(newCategory)
}
```

To check your Realm file:

``` swift
print(Realm.Configuration.defaultConfiguration.fileURL!)
```

------------------------------------------------------------------------
