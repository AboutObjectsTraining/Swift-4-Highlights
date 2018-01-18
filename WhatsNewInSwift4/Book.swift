// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.
//

import Foundation

public enum Rating: Int, CustomStringConvertible {
    case none, one, two, three, four, five
    var stars: [String] {
        return ["✩✩✩✩✩", "✭✩✩✩✩", "✭✭✩✩✩", "✭✭✭✩✩", "✭✭✭✭✩", "✭✭✭✭✭"]
    }
    public var description: String { return stars[rawValue] }
}

struct Book: CustomStringConvertible
{
    public enum Author: String, CustomStringConvertible {
        case wells
        case austen
        case hemingway
        
        public var description: String { return self.rawValue.capitalized }
    }
    
    var title: String
    var author: Author
    var rating: Rating
    
    public var description: String { return "\(title) \(rating)" }
}
