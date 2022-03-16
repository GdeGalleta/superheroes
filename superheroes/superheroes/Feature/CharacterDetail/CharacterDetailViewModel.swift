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

    private let marvelCharacterService: MarvelCharacterServiceType

    @Published public var dataSource: CharacterDetailModel?
    public var dataSourcePublished: Published<CharacterDetailModel?> { _dataSource }
    public var dataSourcePublisher: Published<CharacterDetailModel?>.Publisher { $dataSource }

    init(marvelCharacterService: MarvelCharacterServiceType = MarvelCharacterService()) {
        self.marvelCharacterService = marvelCharacterService
    }

    public func fetchCharacter(characterName: String) {
        marvelCharacterService.fetchCharacter(characterName: characterName)
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
