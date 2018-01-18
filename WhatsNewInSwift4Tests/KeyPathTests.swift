// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
@testable import WhatsNewInSwift4

struct Person {
    var name: String
    var address: Address
}
struct Address: CustomStringConvertible {
    var street: String
    var city: String
    var description: String {
        return "\(type(of: self))(street: \"\(street)\", city: \"\(city)\")"
    }
}

private let person = Person(name: "Fred", address: Address(street: "42 Maple St.", city: "Reston"))
private let nameKeyPath = \Person.name
private let cityKeyPath = \Person.address.city

class KeyPathTests: XCTestCase
{
    override func setUp() { super.setUp(); print() }
    override func tearDown() { print(); super.tearDown() }
    
    func testValueForKey() {
        let book: Book = Book(title: "Emma", author: .austen, rating: .five)
        let rating = book[keyPath: \Book.rating]
        print(rating)
    }

    func testValueForKeyPath() {
        let city = person[keyPath: \Person.address.city]
        print(city)
    }

    func testStoredKeyPath() {
        let keyPaths = [\Person.name, \Person.address.city, \Person.address.street]
        
        for currKeyPath in keyPaths {
            print(person[keyPath: currKeyPath])
        }
        
        let values = keyPaths.map { person[keyPath: $0] }
        print(values)
        
        // Currently useless. The KeyPath type doesn't yet provide a method
        // for obtaining a string representation of its contents.
        let keysAndValues = keyPaths.map { ($0, person[keyPath: $0]) }
        print(keysAndValues)
    }
    
    func testSetValueForKey() {
        var mutablePerson = person
        mutablePerson[keyPath: nameKeyPath] = "Jan"
        print(mutablePerson)
    }
    
    func testSetValueForKeyPath() {
        var mutablePerson = person
        mutablePerson[keyPath: cityKeyPath] = "Herndon"
        print(mutablePerson)
    }
}
