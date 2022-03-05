//
//  CharacterDetailViewController.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit

public final class CharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let identifier: Int
    private let viewModel: CharacterDetailViewModelType
    private let coordinator: CharacterDetailCoordinatorType?
    
    // MARK: - Initializer
    init(identifier: Int,
         viewModel: CharacterDetailViewModelType = CharacterDetailViewModel(),
         coordinator: CharacterDetailCoordinatorType? = nil) {
        self.identifier = identifier
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
