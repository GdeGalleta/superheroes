//
//  CharacterDetailViewModel.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation
import Combine

public protocol CharacterDetailViewModelType {

    var dataSource: CharacterDetailModel? { get }
    var dataSourcePublished: Published<CharacterDetailModel?> { get }
    var dataSourcePublisher: Published<CharacterDetailModel?>.Publisher { get }
    func fetchCharacter(characterName: String)
}

public final class CharacterDetailViewModel: CharacterDetailViewModelType {

    private var cancellables = Set<AnyCancellable>()

    private let apiProvider: ApiProviderType

    @Published public var dataSource: CharacterDetailModel?
    public var dataSourcePublished: Published<CharacterDetailModel?> { _dataSource }
    public var dataSourcePublisher: Published<CharacterDetailModel?>.Publisher { $dataSource }

    init(apiProvider: ApiProviderType = ApiProvider()) {
        self.apiProvider = apiProvider
    }

    public func fetchCharacter(characterName: String) {
        let resource = MarvelApiResource<MarvelCharactersDto>
            .character(characterName: characterName)

        apiProvider
            .fetch(resource: resource)
            .compactMap({ (response: MarvelCharactersDto) -> [CharacterDetailModel] in
                var converted: [CharacterDetailModel] = []
                if let results = response.data?.results {
                    converted+=results.compactMap({
                        if let identifier = $0.identifier,
                           let name = $0.name,
                           let url = $0.thumbnail?.path,
                           let ext = $0.thumbnail?.thumbnailExtension {
                            let image = CharacterDetailImageModel(path: url, ext: ext)

                            var comicItems: [MarvelComicsItemDto] = []
                            comicItems.append(contentsOf: ($0.comics?.comicItems) ?? [])

                            let comics: [CharacterDetailComicModel]? = $0.comics?.comicItems?.compactMap({ (item: MarvelComicsItemDto) in
                                if let title = item.name {
                                    return CharacterDetailComicModel(title: title)
                                }
                                return nil
                            })

                            return CharacterDetailModel(identifier: identifier,
                                                        name: name,
                                                        image: image,
                                                        comics: comics)
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
