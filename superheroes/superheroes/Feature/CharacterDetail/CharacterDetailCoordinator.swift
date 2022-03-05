//
//  CharacterDetailCoordinator.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit

public protocol CharacterDetailCoordinatorType: AnyObject {
    func dismiss()
}

public final class CharacterDetailCoordinator: FlowCoordinator, CharacterDetailCoordinatorType {
    let navigationController: UINavigationController
    let characterName: String

    init(navigationController: UINavigationController, characterName: String) {
        self.navigationController = navigationController
        self.characterName = characterName
    }

    public func start(animated: Bool = true) {
        let viewController = CharacterDetailViewController(characterName: characterName, coordinator: self)
        navigationController.present(viewController, animated: animated, completion: nil)
    }

    // MARK: - Flow Methods
    public func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
