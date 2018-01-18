// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
@testable import WhatsNewInSwift4

class BookDictionaryTests: XCTestCase
{
    let books = [Book(title: "The Time Machine", author: .wells, rating: .three),
                 Book(title: "The Dream", author: .wells, rating: .two),
                 Book(title: "Emma", author: .austen, rating: .five),
                 Book(title: "Mansfield Park", author: .austen, rating: .four),
                 Book(title: "A Farewell to Arms", author: .hemingway, rating: .four)]

    override func setUp() {
        super.setUp()
        print()
    }
    override func tearDown() {
        print()
        super.tearDown()
    }
        
    func testBook() {
        let groupedBooks = Dictionary(grouping: books) { $0.author }
        print(groupedBooks)
        
    }
    
    func testRating() {
        let booksByAuthor = Dictionary(grouping: books) { $0.author }
        print(booksByAuthor)
    }
    
    
    func testZip() {
        let sortedBooks = books.sorted { $0.rating.rawValue > $1.rating.rawValue }
        print(sortedBooks)
        // Initializes a dictionary with a zipped sequence of key-value pairs.
        // Note: throws a fatal error if a duplicate key is encountered.
        let rankedBooks = Dictionary(uniqueKeysWithValues: zip(1...5, sortedBooks))
        for key in 1...5 {
            print("\(key): \(rankedBooks[key]?.description ?? "")")
        }
    }
}
