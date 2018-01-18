// Copyright (C) 2018 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.\
import Foundation

struct Ebook2 {
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
    
    enum Currency: Codable {
        case dollar
        case pound(Double)
        case euro(Double)
        
        enum Keys: String, CodingKey {
            case isoCode
            case exchangeRate
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.singleValueContainer()
            let isoCode = try values.decode(String.self)
            switch isoCode  {
            case "USD": self = .dollar
            case "GBP": self = .pound(poundExchangeRate)
            case "EUR": self = .euro(euroExchangeRate)
            default:
                let context = DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unmatched currency: \(isoCode)")
                throw DecodingError.dataCorrupted(context)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var value = encoder.singleValueContainer()
            var isoCode: String
            switch self {
            case .dollar: isoCode = "USD"
            case .pound: isoCode = "GBP"
            case .euro: isoCode = "EUR"
            try value.encode(isoCode)
            }
        }
    }
    
    init(ebookId: Int, title: String, rating: Rating) {
        self.ebookId = ebookId
        self.title = title
        self.rating = rating
    }
}

extension Ebook2: Decodable {
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

extension Ebook2: Encodable {
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: Keys.self)
        try values.encode(ebookId, forKey: .ebookId)
        try values.encode(title, forKey: .title)
        try values.encode(rating?.average, forKey: Keys.averageUserRating)
        try values.encode(rating?.count, forKey: Keys.userRatingCount)
        try values.encode(currency, forKey: Keys.currency)
    }
}
