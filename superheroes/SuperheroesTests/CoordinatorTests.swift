//
//  CoordinatorTests.swift
//  SuperheroesTests
//
//  Created by Dimitri Sopov on 5/3/22.
//

import XCTest

class CoordinatorTests: XCTestCase {

    private let identifier = Int.zero
    private var window: UIWindow?
    private var navigationController: UINavigationControllerMock?
    private var startCoordinator: FlowCoordinator?
    private var characterListCoordinator: (FlowCoordinator & CharacterListCoordinatorType)?
    private var characterDetailCoordinator: (FlowCoordinator & CharacterDetailCoordinatorType)?

    override func setUpWithError() throws {
        window = UIWindow()
        navigationController = UINavigationControllerMock()
        startCoordinator = MainCoordinator(window: window!)
        characterListCoordinator = CharacterListCoordinator(navigationController: navigationController!)
        characterDetailCoordinator = CharacterDetailCoordinator(navigationController: navigationController!, identifier: identifier)

        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
    }

    override func tearDownWithError() throws {
        window = nil
        navigationController = nil
        startCoordinator = nil
        characterListCoordinator = nil
        characterDetailCoordinator = nil
    }

    func test_startApplication() {
        let expectedViewController = CharacterListViewController()

        startCoordinator!.start(animated: false)

        if let navigationController = window!.rootViewController as? UINavigationController,
           let viewController = navigationController.viewControllers.first {
            XCTAssert(type(of: viewController) == type(of: expectedViewController))
        } else {
            XCTFail("Wrong view controller")
        }
    }

    func test_startCharacterList() {
        let expectedViewController = CharacterListViewController()

        characterListCoordinator!.start(animated: false)

        if let viewController = navigationController!.viewControllers.first {
            XCTAssert(type(of: viewController) == type(of: expectedViewController))
        } else {
            XCTFail("Wrong view controller")
        }

        let expectedViewController2 = CharacterDetailViewController(identifier: identifier)

        characterListCoordinator!.coordinateToCharacterDetail(identifier: identifier)

        if let viewController = navigationController!.presentedViewController {
            XCTAssert(type(of: viewController) == type(of: expectedViewController2))
        } else {
            XCTFail("Wrong view controller")
        }
    }

    func test_startCharacterDetail() {
        let expectedViewController = CharacterDetailViewController(identifier: identifier)

        characterDetailCoordinator!.start(animated: false)

        if let viewController = navigationController!.presentedViewController {
            XCTAssert(type(of: viewController) == type(of: expectedViewController))
        } else {
            XCTFail("Wrong view controller")
        }

        navigationController!.dismissed = false
        characterDetailCoordinator!.dismiss()
        XCTAssert(navigationController!.dismissed)
    }
}

private final class UINavigationControllerMock: UINavigationController {
    fileprivate var dismissed = false
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissed = true
        super.dismiss(animated: flag, completion: completion)
    }
}
