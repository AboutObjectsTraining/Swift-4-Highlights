//
// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

import XCTest
@testable import WhatsNewInSwift4

let book1 = Book(title: "Book One", year: 1999, favorite: false, rating: Rating(average: 4.75, count: 32))
let book2 = Book(title: "Book Two", year: 2001, favorite: true, rating: Rating(average: 3.5, count: 27))

let author1 = Author(firstName: "Fred", lastName: "Smith", books: [book1, book2])

let ebook1 = Ebook(ebookId: 123456, title: "Ebook One", rating: Rating(average: 2.75, count: 42))
let ebook2: Ebook = {
    var ebook = Ebook(ebookId: 56789, title: "Ebook Two", rating: Rating(average: 3.75, count: 11));
    ebook.currency = Currency.euro
    return ebook
}()

let book1Json = """
{
"title": "Title One",
"year": 2017,
"favorite": true,
"rating": { "average": 4.5, "count": 23 }
}
"""
let book2Json = """
{
"title": "Title Two",
"year": 2016,
"favorite": false,
"rating": { "average": 5, "count": 12 }
}
"""

let authorJson = """
{
"firstName": "FNameOne",
"lastName": "LNameOne"
}
"""

let authorAndBooksJson = """
{
"firstName": "FNameTwo",
"lastName": "LNameTwo",
"books": [\(book1Json), \(book2Json)]
}
"""

let iTunesEbookJson = """
{
"fileSizeBytes":5990135,
"artistId":2122513,
"artistName":"Ernest Hemingway",
"genres":["Classics", "Books", "Fiction & Literature", "Literary"],
"kind":"ebook",
"price":9.99,
"currency":"USD",
"description":"One of the enduring works of American fiction.",
"trackName":"The Old Man and the Sea",
"trackId":381645838,
"formattedPrice":"$9.99",
"releaseDate":"2002-07-25T07:00:00Z",
"averageUserRating":4.5,
"userRatingCount":660
}
"""

let iTunesEbookJson2 = """
{
"fileSizeBytes":5990135,
"artistId":2122513,
"artistName":"Ernest Hemingway",
"genres":["Classics", "Books", "Fiction & Literature", "Literary"],
"kind":"ebook",
"price":9.99,
"currency": "GBP",
"description":"One of the enduring works of American fiction.",
"trackName":"The Old Man and the Sea",
"trackId":381645838,
"formattedPrice":"$9.99",
"releaseDate":"2002-07-25T07:00:00Z",
"averageUserRating":4.5,
"userRatingCount":660
}
"""

