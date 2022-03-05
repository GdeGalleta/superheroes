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

    private enum Section: CaseIterable { case comics }
    private typealias DataSource = UITableViewDiffableDataSource<Section, CharacterDetailComicModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CharacterDetailComicModel>
    private var dataSource: DataSource!

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        table.register(ComicListCell.self, forCellReuseIdentifier: ComicListCell.identifier)
        return table
    }()

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
        setupDataSource()
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
        view.addSubview(tableView)

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

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: image.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor)
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
                self.setupSnapshot()
            }
            .store(in: &cancellables)
    }

    private func fetchData() {
        viewModel.fetchCharacter(characterName: characterName)
    }
}

extension CharacterDetailViewController {

    private func setupDataSource() {
        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, model -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(withIdentifier: ComicListCell.identifier, for: indexPath) as? ComicListCell
                cell?.setup(with: model)
                return cell
            })
    }

    private func setupSnapshot() {
        guard let comics = viewModel.dataSource?.comics else {
            return
        }

        var snapshot = Snapshot()
        snapshot.appendSections([.comics])
        snapshot.appendItems(comics)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CharacterDetailViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
