//
// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import Foundation

let poundExchangeRate = 1.27
let euroExchangeRate = 1.12

enum Currency: String, Codable {
    case dollar = "USD"
    case pound = "GBP"
    case euro = "EUR"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        if let value = Currency(rawValue: rawValue) {
            self = value
        } else {
            let context = DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Raw value \(rawValue) doesn't match")
            throw DecodingError.dataCorrupted(context)
        }
    }
}

struct Ebook {
    var ebookId: Int?
    var title: String?
    var rating: Rating?
    var price: Double?
    var currency: Currency?
    
    enum Keys: String, CodingKey {
        case ebookId = "trackId"
        case title = "trackName"
        case averageUserRating
        case userRatingCount
        case currency
    }
    
    init(ebookId: Int, title: String, rating: Rating) {
        self.ebookId = ebookId
        self.title = title
        self.rating = rating
    }
}

extension Ebook: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        ebookId = try values.decode(Int.self, forKey: .ebookId)
        title = try values.decode(String.self, forKey: .title)
        
        let average = try values.decode(Double.self, forKey: Keys.averageUserRating)
        let count = try values.decode(Int.self, forKey: Keys.userRatingCount)
        rating = Rating(average: average, count: count)
        
        currency = try values.decode(Currency.self, forKey: .currency)
    }
}

extension Ebook: Encodable {
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: Keys.self)
        try values.encode(ebookId, forKey: .ebookId)
        try values.encode(title, forKey: .title)
        try values.encode(rating?.average, forKey: Keys.averageUserRating)
        try values.encode(rating?.count, forKey: Keys.userRatingCount)
        try values.encode(currency, forKey: Keys.currency)
    }
}
