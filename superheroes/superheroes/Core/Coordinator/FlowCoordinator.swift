//
//  FlowCoordinator.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation

public protocol FlowCoordinator {
    func start(animated: Bool)
    func coordinate(to coordinator: FlowCoordinator, animated: Bool)
}

extension FlowCoordinator {
    public func coordinate(to coordinator: FlowCoordinator, animated: Bool = true) {
        coordinator.start(animated: animated)
    }
}
