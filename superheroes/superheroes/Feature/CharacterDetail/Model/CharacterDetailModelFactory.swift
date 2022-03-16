//
//  CharacterDetailModelFactory.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 16/3/22.
//

import Foundation

public struct CharacterDetailModelFactory: GenericDecoderFactory {

    public func decode(dto: MarvelCharactersDto) -> [CharacterDetailModel] {
        var converted: [CharacterDetailModel] = []
        if let results = dto.data?.results {
            converted+=results.prefix(1).compactMap({
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
    }
}
