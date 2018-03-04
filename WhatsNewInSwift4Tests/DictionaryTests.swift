// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest

let books = [
    "Emma": 11.95,
    "Henry V": 14.99,
    "1984": 14.99,
    "Utopia": 11.95,
]

extension Dictionary where Value == Double
{
    func printValuesAsCurrency() {
        for (key, value) in self {
            print("\(key): \(String(format: "$%.2f", value))")
        }
    }
}
extension Dictionary where Value == [(key: String, value: Double)] {
    func printValuesAsCurrency() {
        for (key, value) in self {
            print("\(key): ")
            for element in value {
                print("\t\(element.key): \(element.value)")
            }
        }
    }
}

class DictionaryTests: XCTestCase
{
    override func setUp() {
        super.setUp()
        print()
    }
    override func tearDown() {
        print()
        super.tearDown()
    }
    
    func testAccessElementsByPositions() {
        guard let index = books.index(forKey: "Emma") else { fatalError() }
        print(books.values[index])
    }

    // In Swift 3, Dictionary's `filter()` method returned an
    // array of key-value tuples instead of a dictionary.
    func testFilter() {
        let booksUnder12Dollars = books.filter { $0.value < 12.00 }
        booksUnder12Dollars.printValuesAsCurrency()
    }
    
    // Produces an array of transformed values
    func testMap() {
        let discount = 0.10
        let discountedPrices = books.map { $0.value * (1 - discount) }
        print(discountedPrices)
    }
    
    // Produces a dictionary of keys and transformed values
    func testMapValues() {
        let discount = 0.10
        let discountedBooks = books.mapValues { $0 * (1 - discount) }
        books.printValuesAsCurrency()
        print("""

With discount
-------------
""")
        discountedBooks.printValuesAsCurrency()
    }
    
    // Takes a closure argument that defines how the items in the provided dictionary
    // should be grouped in the new dictionary. The result is a dictionary whose values
    // are arrays of key-value tuples.
    func testGrouping() {
        let booksGroupedByPrice = Dictionary(grouping: books, by: { $0.value } )
        booksGroupedByPrice.printValuesAsCurrency()
    }
    
    // Returns the provided default value for any missing keys.
    func testReadDefaultValue() {
        let price1 = books["Emma", default: 0]
        print("Emma: \(price1)")
        let price2 = books["Foo", default: 0]
        print("Foo: \(price2)")
        
        // Note, though, that the preceding line could be rewritten as follows:
        let price3 = books["Foo"] ?? 0
        print("Foo: \(price3)")
    }
    
    // Inserts any missing keys in dictionary with the provided default value.
    func testSetDefaultValue() {
        var discountedBooks = books
        let keys = ["Emma", "1984", "Foo"]
        for key in keys {
            discountedBooks[key, default: 0] *= 0.9
        }
        print(discountedBooks)
        discountedBooks.printValuesAsCurrency()
    }
}


let personal = ["home": "703-333-4567", "cell": "202-444-1234"]
let work1 = ["main": "571-222-9876", "mobile": "703-987-5678"]
let work2 = ["main": "571-222-9876", "cell": "703-987-5678"]

extension DictionaryTests
{
    func testMerge() {
        let p1: [String: Any] = personal.merging(work1) { first, _ in first }
        print(p1)
        
        var phones1 = personal
        phones1.merge(work1) { "\($0),\($1)" }
        print(phones1)
        
        var phones2 = personal
        phones2.merge(work2) { _, new in new }
        print(phones2)
        
        var phones3 = personal
        phones3.merge(work2) { "personal: \($0), work: \($1)" }
        print(phones3)
        
        var phones4: [String: Any] = personal
        phones4.merge(work2) { (personal: $0, work: $1) }
        print(phones4)
    }
}

let bookDict: [String: Any] = ["title": "Book Title", "year": 1999, "author": "Plato"]

extension Dictionary.Index {
    public var description: String {
        let substrings = String(describing: self).split(separator: "(")
        return String(substrings.last!.dropLast(3))
    }
}

extension DictionaryTests
{
    func testContainsKey() throws {
        let key = bookDict.keys.first!
        XCTAssertTrue(bookDict.keys.contains(key))
    }
    
    func testObtainIndexOfKey() throws {
        let index = bookDict.index(forKey: "year")!
        let value = bookDict.values[index] as? String
        XCTAssertEqual(value, bookDict["year"] as? String)
    }
    
    func testIndexes() {
        let titleIndex = bookDict.index(forKey: "title")!
        print(titleIndex.description)
        let yearIndex = bookDict.index(forKey: "year")!
        print(yearIndex.description)
        let authorIndex = bookDict.index(forKey: "author")!
        print(authorIndex.description)
    }
    
    func testSubscriptWithIndex() throws {
        let index = bookDict.index(forKey: "year")!
        print(index.description)
        let entry = bookDict[index]
        print(entry)
        let key = bookDict.keys[index]
        print(key)
        let value = bookDict.values[index]
        print(value)
    }
    
    func testMutateNestedArray() {
        // NOTE: This works without casts for strongly typed dictionaries
        // (e.g., the following dictionary's type is `[String: [String]]`).
        //
        var dict = [
            "cats": ["leo", "tiger"],
            "dogs": ["spot", "rover"]
        ]
        
        dict["cats"]?.append("kitty")
        
        print(dict)
        XCTAssertEqual(dict["cats"]!.count, 3)
        
        let dogsKey = "dogs"
        let dogName = "fido"
        
        // Append to existing value if present; otherwise, add new element
        // Swift 3:
        //
        // if let index = dict.index(forKey: "dogs") {
        //     dict.values[index].append(dogName)
        // } else {
        //     dict[dogsKey] = [dogName]
        // }
        //
        // Swift 4:
        //
        dict[dogsKey, default: [String]()].append(dogName)
        
        print(dict)
        XCTAssertEqual(dict[dogsKey]!.count, 3)
    }
}
