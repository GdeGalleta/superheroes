//
//  CharacterListModelFactory.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 16/3/22.
//

import Foundation

public struct CharacterListModelFactory: GenericDecoderFactory {

    public func decode(dto: MarvelCharactersDto) -> [CharacterListModel] {
        var converted: [CharacterListModel] = []
        if let results = dto.data?.results {
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
    }
}
