//
//  CharacterListViewModelTests.swift
//  SuperheroesTests
//
//  Created by Dimitri Sopov on 5/3/22.
//

import XCTest
import Combine
@testable import Superheroes

class CharacterListViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var apiProvider: ApiProviderType?
    private var viewModel: CharacterListViewModelType?

    override func setUpWithError() throws {
        cancellables = []
        apiProvider = ApiProvider(session: TestsConstants.session)
        URLProtocol.registerClass(URLProtocolMock.self)

        viewModel = CharacterListViewModel(apiProvider: apiProvider!)
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

        let expectedImage = CharacterListImageModel(path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", ext: "jpg")
        let expectedModel = CharacterListModel(
            identifier: 1011334,
            name: "3-D Man",
            image: expectedImage)

        viewModel!.dataSourcePublisher
            .receive(on: RunLoop.main)
            .sink { response in
                let foundModel = response.filter({
                    return $0.identifier == expectedModel.identifier
                }).first
                if let model = foundModel {
                    XCTAssertEqual(model.identifier, expectedModel.identifier)
                    XCTAssertEqual(model.name, expectedModel.name)
                    XCTAssertEqual(model.image.path, expectedModel.image.path)
                    XCTAssertEqual(model.image.ext, expectedModel.image.ext)

                    expectation0.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel!.fetchCharacters()

        wait(for: [expectation0], timeout: 5)
    }
}
