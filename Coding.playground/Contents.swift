//: Playground - noun: a place where people can play

import Foundation

// Instantiate an encoder
let encoder = JSONEncoder()

//Instantiate a decoder
let decoder = JSONDecoder()

// Configure a property for nicely formatted output.
encoder.outputFormatting = .prettyPrinted

// Declare Person and Dog structs conforming to Codable
struct Person: Codable {
    var name: String
    var age: Int
    var dog: Dog
}

struct Dog: Codable {
    var name: String
    var breed: Breed
    
    // Codable has built-in support for enums with raw values.
    enum Breed: String, Codable {
        case collie = "Collie"
        case beagle = "Beagle"
        case greatDane = "Great Dane"
    }
}

// Given an instance of Person with a nested Dog...
let spot = Dog(name: "Spot", breed: .beagle)
let fred = Person(name: "Fred", age: 30, dog: spot)

// Encoding objects to JSON
let data = try! encoder.encode(fred)
print("Encoded fred: " + String(data: data, encoding: .utf8)!)

// Decoding objects from JSON
let fredsClone = try! decoder.decode(Person.self, from: data)
print("Decoded fred: \(fredsClone)".replacingOccurrences(of: "__lldb_expr_", with: ""))

// Declare a `Group` class conforming to `Codable` that has a property
// of type array of `Person`
class Group: Codable, CustomStringConvertible {
    var title: String
    var people: [Person]
    
    init(title: String, people: [Person]) {
        self.title = title
        self.people = people
    }
    
    var description: String {
        return "\(Group.self)(title: \"\(title)\", people: \n\(people))"
    }
}

// Initializing a group with two people
let jim = Person(name: "Jim", age: 30, dog: Dog(name: "Rover", breed: .beagle))
let sue = Person(name: "Sue", age: 27, dog: Dog(name: "Lassie", breed: .collie))
let group = Group(title: "Dog Lovers", people: [fred, sue])

// Encoding the group
let groupData = try! encoder.encode(group)
print("Encoded group" + String(data: groupData, encoding: .utf8)!)

// Decoding the group
let clonedGroup = try! decoder.decode(Group.self, from: groupData)
print("Decoded group: \(clonedGroup)".replacingOccurrences(of: "__lldb_expr_", with: ""))

// Coercing `Date` objects by configuring an encoding strategy
struct BlogPost: Codable {
    let title: String
    let date: Date
    let baseUrl: URL = URL(string: "https://media.aboutobjects.com/blog")!
}

let blog = BlogPost(title: "Swift 4 Coding", date: Date())

encoder.dateEncodingStrategy = .iso8601
let blogData = try! encoder.encode(blog)
print("Encoded blog:" + String(data: blogData, encoding: .utf8)!)

decoder.dateDecodingStrategy = .iso8601
let clonedBlog = try! decoder.decode(BlogPost.self, from: blogData)
print("Decoded blog: \(clonedBlog)".replacingOccurrences(of: "__lldb_expr_", with: ""))


// Defining custom mappings by supplying a `CodingKeys` enum
struct Book: Codable {
    var title: String
    var author: String
    var year: Int
    var pageCount: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case year = "publication_year"
        case pageCount = "number_of_pages"
    }
}

// Decoding from JSON text
//
// Note the use of Swift 4 multiline string literal syntax
let bookJsonText = """
    {
        "title": "War of the Worlds",
        "author": "H. G. Wells",
        "publication_year": 2012,
        "number_of_pages": 240
    }
    """

let bookData = bookJsonText.data(using: .utf8)!
let book = try! decoder.decode(Book.self, from: bookData)
print("Decoded book: \(book)".replacingOccurrences(of: "__lldb_expr_", with: ""))


// Custom encoding/decoding

let eBookJsonText = """
{
    "fileSize":5990135,
    "title":"The Old Man and the Sea",
    "author":"Ernest Hemingway",
    "releaseDate":"2002-07-25T07:00:00Z",
    "averageUserRating":4.5,
    "userRatingCount":660
}
"""

struct Rating {
    var average: Double
    var count: Int
}

struct EBook {
    var title: String
    var author: String
    var releaseDate: Date
    var rating: Rating

    enum CodingKeys: String, CodingKey {
        case title
        case author
        case releaseDate
        // Used to map flattened values from JSON into properties of
        // nested Rating object
        case averageUserRating
        case userRatingCount
    }
}

extension EBook: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        author = try values.decode(String.self, forKey: .author)
        releaseDate = try values.decode(Date.self, forKey: .releaseDate)
        let average = try values.decode(Double.self, forKey: CodingKeys.averageUserRating)
        let count = try values.decode(Int.self, forKey: CodingKeys.userRatingCount)
        rating = Rating(average: average, count: count)
    }
}

extension EBook: Encodable {
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(title, forKey: .title)
        try values.encode(author, forKey: .author)
        try values.encode(releaseDate, forKey: .releaseDate)
        try values.encode(rating.average, forKey: CodingKeys.averageUserRating)
        try values.encode(rating.count, forKey: CodingKeys.userRatingCount)
    }
}

// Note: decoding strategy was set earlier in playground
// decoder.dateDecodingStrategy = .iso8601
let eBookData = eBookJsonText.data(using: .utf8)!
let eBook = try! decoder.decode(EBook.self, from: eBookData)
print("Decoded ebook: \(eBook)".replacingOccurrences(of: "__lldb_expr_", with: ""))

