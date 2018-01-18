// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest

//extension String
//{
//    func substring(to lastIndex: Int, pad: String) -> String {
//        let s = self[..<index(startIndex, offsetBy: lastIndex)]
//        return s.padding(toLength: self.count, withPad: pad, startingAt: 0)
//    }
//}

class StringTests: XCTestCase
{
    override func setUp() {
        super.setUp(); print()
    }
    override func tearDown() {
        print(); super.tearDown()
    }
    
    func testAppending() {
        let s = "ab".appending("cde")
        print(s)
    }
    
    func testSubstringAndPadding() {
        let stars = "✭✭✭✭✭"
        let index = stars.index(stars.startIndex, offsetBy: 3)
        let s = stars[..<index]
        print(s)
        
        let padded = s.padding(toLength: 5, withPad: "✩", startingAt: 0)
        print(padded)
    }
    
    func testSubstringAndPadding2() {
        let stars = "✭✭✭✭✭"
        let index = stars.index(stars.startIndex, offsetBy: 3)
        let s = stars[..<index].padding(toLength: stars.count, withPad: "✩", startingAt: 0)
        print(s)
    }

    func testSubstring() {
        let stars = "✭✭✭✭✭✩✩✩✩✩"
        let index1 = stars.index(stars.startIndex, offsetBy: 2)
        let index2 = stars.index(stars.endIndex, offsetBy: -3)
        let s = stars[index1..<index2]
        print(s)
    }
    
    func testSubstringDroppingFirstLast() {
        let stars = "✭✭✭✭✭✩✩✩✩✩"
        let x = stars.dropFirst(2)
        print(x)
        let y = x.dropLast(3)
        print(y)
//        let s = stars.dropFirst(2).dropLast(3)
//        print(s)
    }
    
    func testComposeString() {
        let s = String(repeatElement("✭", count: 0)) + String(repeatElement("✩", count: 5))
        print(s)
        let x = repeatElement("a", count: 3)
        print(x)
    }
}
