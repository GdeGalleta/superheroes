//
//  CharacterDetailViewModelTests.swift
//  SuperheroesTests
//
//  Created by Dimitri Sopov on 5/3/22.
//

import XCTest
import Combine
@testable import Superheroes

class CharacterDetailViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var apiProvider: ApiProviderType?
    private var marvelCharacterService: MarvelCharacterServiceType?
    private var viewModel: CharacterDetailViewModelType?

    override func setUpWithError() throws {
        cancellables = []
        apiProvider = ApiProvider(session: TestsConstants.session)
        marvelCharacterService = MarvelCharacterService(apiProvider: apiProvider!)
        URLProtocol.registerClass(URLProtocolMock.self)

        viewModel = CharacterDetailViewModel(marvelCharacterService: marvelCharacterService!)
    }

    override func tearDownWithError() throws {
        apiProvider = nil
        marvelCharacterService = nil
        viewModel = nil
    }

    func test_fetchCharacters() {
        let expectation0 = expectation(description: "expected values received")

        URLProtocolMock.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "test.com")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, TestsConstants.charactersJsonData)
        }

        let characterName = "3-D Man"
        let expectedImage = CharacterDetailImageModel(path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", ext: "jpg")
        let comic = CharacterDetailComicModel(title: "FREE COMIC BOOK DAY 2013 1 (2013) #1")
        let expectedModel = CharacterDetailModel(
            identifier: 1011334,
            name: characterName,
            image: expectedImage,
            comics: [comic])

        viewModel!.dataSourcePublisher
            .receive(on: RunLoop.main)
            .sink { response in
                if let model = response {
                    XCTAssertEqual(model.identifier, expectedModel.identifier)
                    XCTAssertEqual(model.name, expectedModel.name)
                    XCTAssertEqual(model.image.path, expectedModel.image.path)
                    XCTAssertEqual(model.image.ext, expectedModel.image.ext)
                    XCTAssertEqual(model.comics!.first!.title, expectedModel.comics!.first!.title)

                    expectation0.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel!.fetchCharacter(characterName: characterName)

        wait(for: [expectation0], timeout: 5)
    }
}
