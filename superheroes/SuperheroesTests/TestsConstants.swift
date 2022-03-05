//
//  TestsConstants.swift
//  SuperheroesTests
//
//  Created by Dimitri Sopov on 5/3/22.
//

import XCTest

public struct TestsConstants {
    private class Class {}
    static var testsBundle: Bundle { return Bundle(for: TestsConstants.Class.self) }

    static let sampleJsonData: Data = {
        let fileUrl = testsBundle.url(forResource: "sample", withExtension: "json")
        guard let url = fileUrl, let data = try? Data(contentsOf: url) else {
            XCTFail("Error creating data from file")
            return Data()
        }
        return data
    }()

    static let charactersJsonData: Data = {
        let fileUrl = testsBundle.url(forResource: "characters", withExtension: "json")
        guard let url = fileUrl, let data = try? Data(contentsOf: url) else {
            XCTFail("Error creating data from file")
            return Data()
        }
        return data
    }()
}
