//
//  MarvelFavoriteHelperTests.swift
//  SuperheroesTests
//
//  Created by Dimitri Sopov on 6/3/22.
//

import XCTest
@testable import Superheroes

class MarvelFavoriteHelperTests: XCTestCase {

    func test_marvelFavoriteReadWrite() {
        let expected = "test"
        MarvelFavoriteHelper.storeFavorite(characterName: expected)
        XCTAssert(MarvelFavoriteHelper.isFavorite(characterName: expected))
        MarvelFavoriteHelper.removeFavorite(characterName: expected)
        XCTAssert(!MarvelFavoriteHelper.isFavorite(characterName: expected))
    }
}
