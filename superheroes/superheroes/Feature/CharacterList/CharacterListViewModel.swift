//
//  CharacterListViewModel.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation
import Combine

public protocol CharacterListViewModelType {

    var dataSource: [CharacterListModel] { get }
    var dataSourcePublished: Published<[CharacterListModel]> { get }
    var dataSourcePublisher: Published<[CharacterListModel]>.Publisher { get }
    func fetchCharacters(nameStartsWith: String?, orderByNameDesc: Bool)
    func fetchCharacters()
    func fetchMoreCharacters()
}

public final class CharacterListViewModel: CharacterListViewModelType {

    private var cancellables = Set<AnyCancellable>()

    private let apiProvider: ApiProviderType

    @Published public var dataSource: [CharacterListModel] = []
    public var dataSourcePublished: Published<[CharacterListModel]> { _dataSource }
    public var dataSourcePublisher: Published<[CharacterListModel]>.Publisher { $dataSource }

    private var query: CharactersQuery = {
        var query = CharactersQuery()
        query.offset = 0
        query.limit = 20
        query.orderBy = nil
        return query
    }()

    init(apiProvider: ApiProviderType = ApiProvider()) {
        self.apiProvider = apiProvider
    }

    public func fetchCharacters(query: CharactersQuery) {
        let resource = MarvelApiResource<MarvelCharactersDto>.characters(query: query)
        apiProvider
            .fetch(resource: resource)
            .compactMap({ (response: MarvelCharactersDto) -> [CharacterListModel] in
                var converted: [CharacterListModel] = []
                if let results = response.data?.results {
                    converted+=results.compactMap({
                        if let identifier = $0.identifier,
                           let name = $0.name,
                           let path = $0.thumbnail?.path,
                           let ext = $0.thumbnail?.thumbnailExtension {
                            return CharacterListModel(
                                identifier: identifier,
                                name: name,
                                image: CharacterListImageModel(path: path, ext: ext))
                        }
                        return nil
                    })
                }

                return converted
            })
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure:
                    self.dataSource = []
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.dataSource+=response
            }
            .store(in: &cancellables)
    }

    public func fetchCharacters(nameStartsWith: String?, orderByNameDesc: Bool = true) {
        dataSource = []
        query.offset = 0
        query.orderBy = orderByNameDesc ? "-name" : "name"

        if let nameStartsWithValue = nameStartsWith, !nameStartsWithValue.isEmpty {
            query.nameStartsWith = nameStartsWithValue
        } else {
            query.nameStartsWith = nil
        }

        fetchCharacters(query: query)
    }

    public func fetchCharacters() {
        dataSource = []
        query.offset = 0
        query.nameStartsWith = nil
        query.orderBy = nil
        fetchCharacters(query: query)
    }

    public func fetchMoreCharacters() {
        query.offset+=query.limit
        fetchCharacters(query: query)
    }
}
