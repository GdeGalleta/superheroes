//
//  MarvelCharacterService.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 16/3/22.
//

import Foundation
import Combine

public protocol MarvelCharacterServiceType {
    func fetchCharacters(query: CharactersQuery) -> AnyPublisher<[CharacterListModel], ApiError>
    func fetchCharacter(characterName: String) -> AnyPublisher<[CharacterDetailModel], ApiError>
}

public final class MarvelCharacterService: MarvelCharacterServiceType {

    private let apiProvider: ApiProviderType

    init(apiProvider: ApiProviderType = ApiProvider()) {
        self.apiProvider = apiProvider
    }

    public func fetchCharacters(query: CharactersQuery) -> AnyPublisher<[CharacterListModel], ApiError> {
        let resource = MarvelApiResource<MarvelCharactersDto>.characters(query: query)
        return apiProvider
            .fetch(resource: resource)
            .compactMap({ (response: MarvelCharactersDto) -> [CharacterListModel] in
                let factory = CharacterListModelFactory()
                return factory.decode(dto: response)
            })
            .eraseToAnyPublisher()
    }

    public func fetchCharacter(characterName: String) -> AnyPublisher<[CharacterDetailModel], ApiError> {
        let resource = MarvelApiResource<MarvelCharactersDto>
            .character(characterName: characterName)
        
        return apiProvider
            .fetch(resource: resource)
            .compactMap({ (response: MarvelCharactersDto) -> [CharacterDetailModel] in
                let factory = CharacterDetailModelFactory()
                return factory.decode(dto: response)
            })
            .eraseToAnyPublisher()
    }
}
