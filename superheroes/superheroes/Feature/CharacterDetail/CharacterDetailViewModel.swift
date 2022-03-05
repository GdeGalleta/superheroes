//
//  CharacterDetailViewModel.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation
import Combine

public protocol CharacterDetailViewModelType {

    var dataSource: CharacterListModel? { get }
    var dataSourcePublished: Published<CharacterListModel?> { get }
    var dataSourcePublisher: Published<CharacterListModel?>.Publisher { get }
    func fetchCharacter(characterName: String)
}

public final class CharacterDetailViewModel: CharacterDetailViewModelType {

    private var cancellables = Set<AnyCancellable>()

    private let apiProvider: ApiProviderType

    @Published public var dataSource: CharacterListModel?
    public var dataSourcePublished: Published<CharacterListModel?> { _dataSource }
    public var dataSourcePublisher: Published<CharacterListModel?>.Publisher { $dataSource }

    init(apiProvider: ApiProviderType = ApiProvider()) {
        self.apiProvider = apiProvider
    }

    public func fetchCharacter(characterName: String) {
        let resource = MarvelApiResource<MarvelCharactersDto>
            .character(characterName: characterName)

        apiProvider
            .fetch(resource: resource)
            .compactMap({ (response: MarvelCharactersDto) -> [CharacterListModel] in
                var converted: [CharacterListModel] = []
                if let results = response.data?.results {
                    converted+=results.compactMap({
                        if let identifier = $0.identifier,
                           let name = $0.name,
                           let url = $0.thumbnail?.path,
                           let ext = $0.thumbnail?.thumbnailExtension
                        {
                            return CharacterListModel(
                                identifier: identifier,
                                name: name,
                                image: CharacterImageModel(path: url, ext: ext))
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
                    self.dataSource = nil
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.dataSource = response.first
            }
            .store(in: &cancellables)
    }
}
