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
    func fetchCharacters(orderByNameDesc: Bool)
    func fetchMoreCharacters()
}

public final class CharacterListViewModel: CharacterListViewModelType {

    private var cancellables = Set<AnyCancellable>()

    private let marvelCharacterService: MarvelCharacterServiceType

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

    init(marvelCharacterService: MarvelCharacterServiceType = MarvelCharacterService()) {
        self.marvelCharacterService = marvelCharacterService
    }

    public func fetchCharacters(query: CharactersQuery) {
        marvelCharacterService.fetchCharacters(query: query)            
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

    public func fetchCharacters(orderByNameDesc: Bool) {
        dataSource = []
        query.offset = 0
        query.nameStartsWith = nil
        query.orderBy = orderByNameDesc ? "-name" : "name"
        fetchCharacters(query: query)
    }

    public func fetchMoreCharacters() {
        query.offset+=query.limit
        fetchCharacters(query: query)
    }
}
