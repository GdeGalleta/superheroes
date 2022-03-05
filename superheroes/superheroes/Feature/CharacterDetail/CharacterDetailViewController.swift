//
//  CharacterDetailViewController.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit
import Combine

public final class CharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    private let characterName: String
    private let viewModel: CharacterDetailViewModelType
    private let coordinator: CharacterDetailCoordinatorType?

    private let buttonDismiss: UIButton = {
        let button = PrimaryButton()
        button.titleColor = .red
        button.borderColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("kClose".localized, for: .normal)
        button.addTarget(self, action: #selector(buttonDismissTapped), for: .touchUpInside)
        return button
    }()

    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: label.font.fontName, size: 30)
        label.textColor = .black
        return label
    }()

    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    // MARK: - Initializer
    init(characterName: String,
         viewModel: CharacterDetailViewModelType = CharacterDetailViewModel(),
         coordinator: CharacterDetailCoordinatorType? = nil) {
        self.characterName = characterName
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBinding()
        fetchData()
    }

    // MARK: - Actions
    @objc private func buttonDismissTapped(_ sender: UIButton) {
        coordinator?.dismiss()
    }
}

extension CharacterDetailViewController {
    private func setupLayout() {
        view.backgroundColor = .darkGray

        view.addSubview(image)
        view.addSubview(buttonDismiss)
        view.addSubview(labelTitle)

        let safeAreaLayout = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalTo: safeAreaLayout.widthAnchor),
            image.heightAnchor.constraint(equalTo: safeAreaLayout.widthAnchor),
            image.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor),
            image.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            buttonDismiss.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor, constant: 10),
            buttonDismiss.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor, constant: -10),
            buttonDismiss.widthAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: buttonDismiss.bottomAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor),
            labelTitle.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor)
        ])
    }

    private func setupBinding() {
        viewModel.dataSourcePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                guard let model = response else { return }
                self.labelTitle.text = model.name
                self.image.loadMarvel(path: model.image.path,
                                      ext: model.image.ext,
                                      aspect: .standard,
                                      size: .medium)
            }
            .store(in: &cancellables)
    }

    private func fetchData() {
        viewModel.fetchCharacter(characterName: characterName)
    }
}
