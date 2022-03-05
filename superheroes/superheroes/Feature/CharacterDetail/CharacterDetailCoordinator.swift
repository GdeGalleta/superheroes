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
    let identifier: Int

    init(navigationController: UINavigationController, identifier: Int) {
        self.navigationController = navigationController
        self.identifier = identifier
    }

    public func start(animated: Bool = true) {
        let viewController = CharacterDetailViewController(identifier: identifier, coordinator: self)
        navigationController.present(viewController, animated: animated, completion: nil)
    }

    // MARK: - Flow Methods
    public func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
