// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest

struct GroceryItem {
    var name: String
    var count: Int
}

//let items = [
//    GroceryItem(name: "Milk", count: 3),
//    GroceryItem(name: "Bread", count: 2)
//]

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
//extension Array where Element == Dictionary<String, Double> {
//    func printValuesAsCurrency() {
//        for value in self {
//            value.printValuesAsCurrency()
//        }
//    }
//}

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
        print(books[index])
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
    // are arrays of dictionaries.
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
        discountedBooks.printValuesAsCurrency()
    }
}
