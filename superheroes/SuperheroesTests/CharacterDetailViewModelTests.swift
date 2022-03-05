//
//  CharacterDetailViewModelTests.swift
//  SuperheroesTests
//
//  Created by Dimitri Sopov on 5/3/22.
//

import XCTest
import Combine

class CharacterDetailViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var apiProvider: ApiProviderType?
    private var viewModel: CharacterDetailViewModelType?

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: configuration)
    }()

    override func setUpWithError() throws {
        cancellables = []
        apiProvider = ApiProvider(session: session)
        URLProtocol.registerClass(URLProtocolMock.self)

        viewModel = CharacterDetailViewModel(apiProvider: apiProvider!)
    }

    override func tearDownWithError() throws {
        apiProvider = nil
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
        let expectedImage = CharacterImageModel(url: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", ext: "jpg")
        let expectedModel = CharacterListModel(
            identifier: 1011334,
            name: characterName,
            image: expectedImage)

        viewModel!.dataSourcePublisher
            .receive(on: RunLoop.main)
            .sink { response in
                if response == expectedModel {
                    expectation0.fulfill()
                }
            }
            .store(in: &cancellables)


        viewModel!.fetchCharacter(characterName: characterName)

        wait(for: [expectation0], timeout: 5)
    }
}