//
//  CharacterListCellViewModel.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation

public struct CharacterListCellViewModel {
    let name: String

    public init(character: CharacterListModel) {
        self.name = character.name
    }
}
