//
//  ApiProviderTests.swift
//  SuperheroesTests
//
//  Created by Dimitri Sopov on 5/3/22.
//

import XCTest
import Combine
@testable import Superheroes

class ApiProviderTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var apiProvider: ApiProviderType?

    override func setUpWithError() throws {
        cancellables = []
        apiProvider = ApiProvider(session: TestsConstants.session)
        URLProtocol.registerClass(URLProtocolMock.self)
    }

    override func tearDownWithError() throws {
        apiProvider = nil
    }

    func test_fetchSample() {
        let expectation0 = expectation(description: "call executed")
        let expectation1 = expectation(description: "expected values received")

        let resource = ApiResource<Data>(baseURL: "test.com/", pathURL: "sample")

        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: (resource.request?.url)!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, TestsConstants.sampleJsonData)
        }

        apiProvider!.fetchData(resource: resource)
            .sink { completion in
                switch completion {
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    case.finished:
                        break
                }
                expectation0.fulfill()
            } receiveValue: { response in
                if !response.isEmpty {
                    expectation1.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation0, expectation1], timeout: 5)
    }

    func test_fetchCharacters() {
        let expectation0 = expectation(description: "call executed")
        let expectation1 = expectation(description: "expected values received")

        let resource = MarvelApiResource<MarvelCharactersDto>.characters()

        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: (resource.request?.url)!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, TestsConstants.charactersJsonData)
        }

        apiProvider!.fetch(resource: resource)
            .sink { completion in
                switch completion {
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    case.finished:
                        break
                }
                expectation0.fulfill()
            } receiveValue: { (response: MarvelCharactersDto) in
                if let results = response.data?.results, !results.isEmpty {
                    expectation1.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation0, expectation1], timeout: 5)
    }
}
