//
//  CharacterListCoordinator.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit

public protocol CharacterListCoordinatorType: AnyObject {
    func coordinateToCharacterDetail(characterName: String)
}

public final class CharacterListCoordinator: FlowCoordinator, CharacterListCoordinatorType {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool = true) {
        let startViewController = CharacterListViewController(coordinator: self)
        navigationController.pushViewController(startViewController, animated: animated)
    }

    // MARK: - Flow Methods
    public func coordinateToCharacterDetail(characterName: String) {
        let detailCoordinator = CharacterDetailCoordinator(
            navigationController: navigationController,
            characterName: characterName)
        coordinate(to: detailCoordinator, animated: true)
    }
}
