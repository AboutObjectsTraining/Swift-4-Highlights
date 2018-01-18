// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest

struct Dog
{
    var name: String
    var toys: [String]
    
    // read-only computed property
    var favoriteToy: String {
        get { return toys.isEmpty ? "N/A" : toys[0] }
        set {
            guard !toys.isEmpty, let index = toys.index(of: newValue) else { return }
            toys.remove(at: index)
            toys.insert(newValue, at: 0)
        }
    }
    // ...
}

class MiscTests: XCTestCase
{
    override func setUp() {
        super.setUp(); print()
    }
    override func tearDown() {
        print(); super.tearDown()
    }
    
    func testDog() {
        var rover = Dog(name: "Rover", toys: ["Ball", "Kong", "Rope"])
        rover.favoriteToy = "Kong"
        print("favorite toy: \(rover.favoriteToy)")
        print(rover.favoriteToy)
        // "Kong"
//        print(rover.toys)
    }
}

