// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest

let personInfoString = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>name</key>
<string>John Doe</string>
<key>phones</key>
<array>
<string>408-974-0000</string>
<string>503-333-5555</string>
</array>
</dict>
</plist>
"""

class StringTests: XCTestCase
{
    override func setUp() {
        super.setUp(); print()
    }
    override func tearDown() {
        print(); super.tearDown()
    }
    
    func testAppending() {
        let s = "abc".appending("def")
        print(s)
    }
    
    func testExtendedGraphemeCluster() {
        let usFlag: Character = "\u{1F1FA}\u{1F1F8}"
        print(usFlag)
    }
    
    func testMultilineStringLiterals1() {
        let text = """
                   To Do
                   -----

                   1. Write "Hello World!"
                   2. Say "Hello World!"
                      - Softly
                      - Slowly

                   """
        print(text)
    }

    func testMultilineStringLiterals2() {
        let s = """
                {
                  "name": "Fred",
                  "age": 23,
                  "mood": "😀"
                }
                """
        print(s)
        
        guard let data = s.data(using: .utf8),
            let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = jsonObj as? [String: Any] else {
            return
        }
        print(jsonDict)
    }
    
    func testPlist() {
        print(personInfoString.propertyList())
        
        guard let personInfo = personInfoString.propertyList() as? [String: Any] else { fatalError() }
        let name = personInfo["name"] ?? ""
        print(name)
        
        guard let phones = personInfo["phones"] as? [String] else { fatalError() }
        phones.forEach { print($0) }
    }
    
    func testStringBasics() {
        let s = "Hello World!"
        print(s.count)
        print(s.contains("World"))
        
        let spaceIndex = s.index(of: " ") ?? s.endIndex
        print(s[..<spaceIndex])
        
        let wIndex = s.index(of: "W") ?? s.startIndex
        let indexOfExclamation = s.index(of: "!") ?? s.endIndex
        print(s[wIndex...indexOfExclamation])
        
        // Swift 3 implementation
        //
        // print(s.substring(to: s.index(of: " ")!))
        // print(s.substring(with: s.index(of: "W")!..<s.index(of: "!")!))
        
        print(s.prefix(upTo: spaceIndex))
        print(s.suffix(from: wIndex))
    }


    func testSubSequence() {
        var s = String("abcdef")
        withUnsafePointer(to: &s) { print("\(type(of: s))    \($0) \(s)") }

        var subsequence: String.SubSequence = s.dropLast(3)
        XCTAssertEqual(subsequence.count, 3)
        withUnsafePointer(to: &subsequence) { print("\(type(of: subsequence)) \($0) \(subsequence)") }

        var substring: Substring = subsequence
        substring.replaceSubrange(substring.startIndex..., with: "woohoo!")
        withUnsafePointer(to: &substring) { print("\(type(of: substring)) \($0) \(substring)") }
        
        print()
        print(substring)
        print(subsequence)
        print(s)
        print()
        
        // Compiler prevents storing a Substring instance as a String. The
        // following won't compile:
        //
        // let foo: String = substring
        // print(foo)
        
        // Instead, initialize a new String with the Substring:
        
        let foo: String = String(substring)
        print(foo)
    }
    
    func testInsertSubstring() {
        var name = "Fred Smith"
        let index = name.index(of: " ") ?? name.endIndex
        name.insert(contentsOf: " W.", at: index)
        
        XCTAssertEqual(name, "Fred W. Smith")
        print(name)
        
        print(name.prefix(upTo: index))
    }
    
    func testEnumeration() {
        let s = "abc"
        for c in s {
            print(c)
        }
    }
    
    func testSubstring1() {
        let name = "Fred Smith"
        let last: Substring = name.dropFirst(5)
        print(last)
        
        let first = name.dropLast(6)
        print(first)
    }
    
    func testSubstring2() {
        let name = "Fred Smith"
        let spaceIndex = name.index(of: " ") ?? name.endIndex
        let firstName = name[..<spaceIndex]
        print(firstName)
        
        let lastNameIndex = name.index(after: spaceIndex)
        let lastName = name[lastNameIndex...]
        print(lastName)
    }
    
    func testIndexes() {
        let s = "Hello 🌎!"
        print(s.count)
        print(s.utf8.count)
        print(s.utf16.count)
        
        // Compute an index relative to start of string.
        let index = s.index(s.startIndex, offsetBy: 6)
        
        // Use subscript with range to obtain substrings.
        // Note that this returns a view (an instance of Substring).
        let head = s[..<index]
        print(head) // "Hello "
        
        let tail = s[index...]
        print(tail) // "🌎!"
    }
    
    func testArrayOfStrings() {
        var words = ["one", "two", "three"]
        // ["one", "two", "three"]
        print(words.count)
        
        words.insert("ONE", at: 0)
        // ["ONE", "uno", "two", "three"]
        words.remove(at: 1)
        // ["ONE", "two", "three"]
        words.append("four")
        // ["ONE", "two", "three", "four"]
        words.append(contentsOf: ["five", "six"])
        // ["ONE", "two", "three", "four", "five", "six"]
        
        print(words.joined(separator: ", "))
        // ONE, two, three, four, five, six
        
        print(words.sorted())
        // ["ONE", "five", "four", "six", "three", "two"]
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

    func testSubstring3() {
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
    }
    
    func testComposeString() {
        let s = String(repeatElement("✭", count: 0)) + String(repeatElement("✩", count: 5))
        print(s)
        let x = repeatElement("a", count: 3)
        print(x)
    }
}
