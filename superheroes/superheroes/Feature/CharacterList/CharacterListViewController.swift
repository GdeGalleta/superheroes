//
//  CharacterListViewController.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit

public final class CharacterListViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: CharacterListViewModelType
    private let coordinator: CharacterListCoordinatorType?

    // MARK: - Initializer
    init(viewModel: CharacterListViewModelType = CharacterListViewModel(),
         coordinator: CharacterListCoordinatorType? = nil) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }
}
