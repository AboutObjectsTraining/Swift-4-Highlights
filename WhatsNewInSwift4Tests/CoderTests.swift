//
// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

import XCTest
@testable import WhatsNewInSwift4

private let decoder: JSONDecoder = JSONDecoder()

private let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return encoder
}()

class CoderTests: XCTestCase {
    override func setUp() { super.setUp(); print() }
    override func tearDown() { print(); super.tearDown() }
}

// MARK: - Coding Basics
extension CoderTests {
    func testEncodeAndDecodeBook() throws {
        let data = try encoder.encode(book1)
        print(String(data: data, encoding: .utf8) ?? "null")
        
        let newBook = try decoder.decode(Book.self, from: data)
        print(newBook)
    }
    
    func testEncodeAndDecodeAuthor() throws {
        let data = try encoder.encode(author1)
        print(String(data: data, encoding: .utf8) ?? "null")
        
        let newAuthor = try decoder.decode(Author.self, from: data)
        print(newAuthor)
    }
}

// MARK: - Working with JSON
extension CoderTests {
    func testDecodeBookFromJsonText() throws {
        let data = book1Json.data(using: .utf8) ?? Data()
        print(String(data: data, encoding: .utf8) ?? "null")
        
        let newBook = try decoder.decode(Book.self, from: data)
        print(newBook)
    }
    
    func testDecodeAuthorFromJsonText() throws {
        let data = authorJson.data(using: .utf8) ?? Data()
        print(String(data: data, encoding: .utf8) ?? "null")
        
        let newAuthor = try decoder.decode(Author.self, from: data)
        print(newAuthor)
    }
    
    func testDecodeAuthorAndNestedBookFromJsonText() throws {
        let data = authorAndBooksJson.data(using: .utf8) ?? Data()
        print(String(data: data, encoding: .utf8) ?? "null")
        
        let newAuthor = try decoder.decode(Author.self, from: data)
        print(newAuthor)
    }
    
}

// MARK: - Manual Coding and Enums
extension CoderTests {
    func testManuallyDecodeFromJsonText() throws {
        let data = iTunesEbookJson.data(using: .utf8) ?? Data()
        print(String(data: data, encoding: .utf8) ?? "null")
        
        let newEbook = try decoder.decode(Ebook.self, from: data)
        print(newEbook)
    }
    
    func testManuallyEncodeEbook() throws {
        let data = try encoder.encode(ebook2)
        print(String(data: data, encoding: .utf8) ?? "null")
    }
    
    func testManuallyDecodeAndEncodeFromJsonTextWithAssociatedEnumValue() throws {
        let data = iTunesEbookJson2.data(using: .utf8) ?? Data()
        print(String(data: data, encoding: .utf8) ?? "null")
        
        let newEbook = try decoder.decode(Ebook2.self, from: data)
        print(newEbook)
        
        let clonedData = try encoder.encode(newEbook)
        print(String(data: clonedData, encoding: .utf8)!)
    }
}

// MARK: - Working with Files
extension CoderTests {
    var authorUrl: URL {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent("Authors")
        url.appendPathExtension("json")
        return url
    }
    
    func testStoreAuthorAndNestedBook() throws {
        let authorData = try encoder.encode(author1)
        print(String(data: authorData, encoding: .utf8)!)
        
        do {
            try authorData.write(to: authorUrl)
        }
        catch {
            print(error); XCTFail()
        }
        
        let fetchedData = try Data(contentsOf: authorUrl, options: [])
        let fetchedAuthor = try decoder.decode(Author.self, from: fetchedData)
        print(fetchedAuthor)
    }
    
    func testDecodeEbookFromJsonFile() throws {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "ebook", withExtension: "json") else {
            XCTFail("Unable to find JSON file in directory \(bundle.bundlePath)"); return
        }
        
        let data = try Data(contentsOf: url, options:[])
        let newEbook = try decoder.decode(Ebook.self, from: data)
        print(newEbook)
    }
}

// MARK: - Working with User Info
extension CoderTests {
    
    var birthDate: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 1980
        dateComponents.month = 7
        dateComponents.day = 11
        return Calendar.current.date(from: dateComponents)!
    }
    
    func testEncodePerson() throws {
        
        let person = Person(name: "Fred", dateOfBirth: birthDate, friends: [], rating: Rating(average: 4.5, count: 3))
        let myEncoder = JSONEncoder()
        myEncoder.outputFormatting = .prettyPrinted
        myEncoder.userInfo[Person.userInfoKey] = Person.Context(encodeFriends: false, encodeRating: true)
        
        let data = try myEncoder.encode(person)
        print(String(data: data, encoding: .utf8)!)
        
        let clonedPerson = try? decoder.decode(Person.self, from: data)
        print(clonedPerson!)
    }
}
