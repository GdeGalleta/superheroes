//
//  CharacterListModel.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation

public struct CharacterListModel: Hashable {
    let identifier: Int
    let name: String
    let image: CharacterImageModel
}

public struct CharacterImageModel: Hashable {
    let path: String
    let ext: String
}
