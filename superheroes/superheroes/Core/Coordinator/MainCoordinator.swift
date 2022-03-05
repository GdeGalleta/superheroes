//
//  MainCoordinator.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit

public final class MainCoordinator: FlowCoordinator {
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    public func start(animated: Bool = true) {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let startCoordinator = StartCoordinator(navigationController: navigationController)
        coordinate(to: startCoordinator, animated: animated)
    }
}
