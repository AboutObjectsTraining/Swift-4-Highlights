// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
@testable import WhatsNewInSwift4

struct Contact {
    var name: String
    var address: Address
    var workAddress: Address?
    var pets: [Pet]
    
    init(name: String, address: Address, pets: [Pet] = []) {
        self.name = name
        self.address = address
        self.pets = pets
    }
}
struct Address: CustomStringConvertible {
    var street: String
    var city: String
    var description: String {
        return "\(type(of: self))(street: \"\(street)\", city: \"\(city)\")"
    }
}

struct Pet {
    var name: String
    var breed: String
}

private let person = Contact(name: "Fred", address: Address(street: "42 Maple St.", city: "Reston"))
private let nameKeyPath = \Contact.name
private let cityKeyPath = \Contact.address.city

class KeyPathTests: XCTestCase
{
    override func setUp() { super.setUp(); print() }
    override func tearDown() { print(); super.tearDown() }

    func testOptionalProperties() {
        let address = Address(street: "21 Elm", city: "Reston")
        let pets = [Pet(name: "Spot", breed: "Collie"), Pet(name: "Tiger", breed: "Siamese")]
        var contact = Contact(name: "Jo", address: address, pets: pets)
        print (contact[keyPath: \Contact.workAddress?.city] ?? "N/A")
        
        contact[keyPath: \Contact.workAddress] = Address(street: "32 Pine", city: "Reston")
        print (contact[keyPath: \Contact.workAddress?.city] ?? "N/A")
    }
    
    func testSubscripts() {
        let address = Address(street: "21 Elm", city: "Reston")
        let pets = [Pet(name: "Spot", breed: "Collie"), Pet(name: "Tiger", breed: "Siamese")]
        var contact = Contact(name: "Jo", address: address, pets: pets)
        print(contact[keyPath: \Contact.pets[1].breed])
        contact[keyPath: \Contact.pets[1].breed] = "Persian"
        print(contact[keyPath: \Contact.pets[1].breed])
    }
    
    func testCombiningKeyPaths() {
        let address = Address(street: "21 Elm", city: "Reston")
        let pets = [Pet(name: "Spot", breed: "Collie"), Pet(name: "Tiger", breed: "Siamese")]
        var contact = Contact(name: "Jo", address: address, pets: pets)
        
        let petsKeyPath = \Contact.pets[1]
        let breedKeyPath: WritableKeyPath<Pet, String> = \.breed
        let combinedKeyPath = petsKeyPath.appending(path: breedKeyPath)
        
        print(contact[keyPath: combinedKeyPath])
        contact[keyPath: combinedKeyPath] = "Persian"
        print(contact[keyPath: combinedKeyPath])
    }
    
    func testExampleCode() {
        let address = Address(street: "21 Elm", city: "Reston")
        var contact = Contact(name: "Jo", address: address)
        contact[keyPath: \Contact.name] = "Kay"
        contact[keyPath: \Contact.address.city] = "Herndon"
        print(contact)
        
        let person = Contact(name: "Jo", address: address)
        let keyPaths = [\Contact.name,
                        \.address.city,
                        \.address.street]
        
        let values = keyPaths.map { person[keyPath: $0] }
        print(values)
        
        let name = person[keyPath: \Contact.name]
        print(name)
        
        let city = person[keyPath: \Contact.address.city]
        print(city)
}
    
    func testValueForKey() {
        let book: Novel = Novel(title: "Emma", author: .austen, rating: .five)
        let rating = book[keyPath: \Novel.rating]
        print(rating)
    }

    func testValueForKeyPath() {
        let city = person[keyPath: cityKeyPath]
        print(city)
    }

    func testStoredKeyPath() {
        let keyPaths = [\Contact.name, \Contact.address.city, \Contact.address.street]
        
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
        mutablePerson[keyPath: cityKeyPath] = "Herndon"
        print(mutablePerson)
    }
    
    func testSetValueForKeyPath() {
        var mutablePerson = person
        mutablePerson[keyPath: cityKeyPath] = "Herndon"
        print(mutablePerson)
    }
}
