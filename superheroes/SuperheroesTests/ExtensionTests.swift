//
//  ExtensionTests.swift
//  SuperheroesTests
//
//  Created by Dimitri Sopov on 5/3/22.
//

import XCTest

class ExtensionString: XCTestCase {

    func test_stringToMD5() {
        let string = "Hello World!"
        let md5 = "ed076287532e86365e841e92bfc50d8c"
        let md5String = string.md5
        XCTAssertEqual(md5String, md5)
    }
}

private struct EncodableClass: Codable {
    var foo = "foo"
    var bar = 123
}

class ExtensionEncodable: XCTestCase {

    func test_encodableToDictionary() {
        let encodable = EncodableClass()
        let dictionary = encodable.dictionary
        XCTAssertEqual(dictionary["foo"] as? String, encodable.foo)
        XCTAssertEqual(dictionary["bar"] as? Int, dictionary["bar"] as? Int)
    }

    func test_subscript() {
        let encodable = EncodableClass()
        let foo = encodable["foo"]
        let bar = encodable["bar"]
        XCTAssertEqual(foo as? String, encodable.foo)
        XCTAssertEqual(bar as? Int, encodable.bar)
    }
}
