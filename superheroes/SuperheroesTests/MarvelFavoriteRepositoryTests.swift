//
//  MarvelFavoriteRepositoryTests.swift
//  SuperheroesTests
//
//  Created by Dimitri Sopov on 6/3/22.
//

import XCTest
@testable import Superheroes

class MarvelFavoriteRepositoryTests: XCTestCase {

    func test_marvelFavoriteReadWrite() {
        let expected = "test"
        MarvelFavoriteRespository.storeFavorite(characterName: expected)
        XCTAssert(MarvelFavoriteRespository.isFavorite(characterName: expected))
        MarvelFavoriteRespository.removeFavorite(characterName: expected)
        XCTAssert(!MarvelFavoriteRespository.isFavorite(characterName: expected))
    }
}
