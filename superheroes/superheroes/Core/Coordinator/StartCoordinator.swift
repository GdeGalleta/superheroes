//
//  StartCoordinator.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit

public final class StartCoordinator: FlowCoordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool = true) {
        let startCoordinator = CharacterListCoordinator(navigationController: navigationController)
        coordinate(to: startCoordinator, animated: animated)
    }
}
