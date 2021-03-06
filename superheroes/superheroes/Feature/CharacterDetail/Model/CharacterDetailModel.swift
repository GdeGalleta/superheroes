//
//  CharacterDetailModel.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation

public struct CharacterDetailModel: Hashable {
    private let id = UUID()
    let identifier: Int
    let name: String
    let image: CharacterDetailImageModel
    let comics: [CharacterDetailComicModel]?
}

public struct CharacterDetailImageModel: Hashable {
    let path: String
    let ext: String
}

public struct CharacterDetailComicModel: Hashable {
    private let id = UUID()
    let title: String
}
