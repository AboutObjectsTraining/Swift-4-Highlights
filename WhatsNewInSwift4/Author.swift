//
// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

import Foundation

struct Author: Codable {
    var firstName: String?
    var lastName: String?
    var books: [Book]?
}
