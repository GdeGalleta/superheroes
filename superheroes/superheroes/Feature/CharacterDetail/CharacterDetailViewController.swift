//
//  CharacterDetailViewController.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit
import Combine

public final class CharacterDetailViewController: MarvelViewController {

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
        table.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0)
        table.showsVerticalScrollIndicator = false
        table.register(ComicListCell.self, forCellReuseIdentifier: ComicListCell.identifier)
        return table
    }()

    private let viewButtonDismiss: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = K.Color.background
        return view
    }()

    private let buttonDismiss: UIButton = {
        let button = PrimaryButton()
        button.titleColor = .red
        button.borderColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("kClose".localized, for: .normal)
        button.addTarget(self, action: #selector(buttonDismissTapped), for: .touchUpInside)
        return button
    }()

    private let viewTitle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = K.Color.background
        return view
    }()

    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
        label.textColor = K.Color.textLight
        label.text = " "
        return label
    }()

    private let image: MarvelImageView = {
        let image = MarvelImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "character_placeholder")
        return image
    }()

    private let labelComics: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = K.Color.textLight
        label.text = "kComics".localized
        label.backgroundColor = K.Color.background.withAlphaComponent(0.8)
        return label
    }()

    private let viewFavorite: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = K.Color.background
        return view
    }()

    private lazy var stackFavorite: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        stack.addArrangedSubview(labelFavorite)
        stack.addArrangedSubview(switchFavorite)
        return stack
    }()

    private let labelFavorite: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = K.Color.textLight
        label.text = "kFavorite".localized
        return label
    }()

    private lazy var switchFavorite: UISwitch = {
        let switchFavorite = UISwitch()
        switchFavorite.translatesAutoresizingMaskIntoConstraints = false
        switchFavorite.addTarget(self, action: #selector(switchFavoriteDidChange(_:)), for: .valueChanged)
        switchFavorite.isOn = MarvelFavoriteHelper.isFavorite(characterName: self.characterName)
        return switchFavorite
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

    @objc private func switchFavoriteDidChange(_ sender: UISwitch) {
        if sender.isOn {
            MarvelFavoriteHelper.storeFavorite(characterName: characterName)
        } else {
            MarvelFavoriteHelper.removeFavorite(characterName: characterName)
        }
    }
}

extension CharacterDetailViewController {
    private func setupLayout() {
        view.backgroundColor = K.Color.background

        view.addSubview(image)
        view.addSubview(viewFavorite)
        viewFavorite.addSubview(stackFavorite)
        view.addSubview(viewButtonDismiss)
        viewButtonDismiss.addSubview(buttonDismiss)
        view.addSubview(viewTitle)
        viewTitle.addSubview(labelTitle)
        view.addSubview(tableView)
        view.addSubview(labelComics)

        viewButtonDismiss.layer.cornerRadius = 10
        viewTitle.layer.cornerRadius = 10
        viewFavorite.layer.cornerRadius = 25

        let safeAreaLayout = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            viewButtonDismiss.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor, constant: 10),
            viewButtonDismiss.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            buttonDismiss.widthAnchor.constraint(equalToConstant: 60),
            buttonDismiss.topAnchor.constraint(equalTo: viewButtonDismiss.topAnchor),
            buttonDismiss.bottomAnchor.constraint(equalTo: viewButtonDismiss.bottomAnchor),
            buttonDismiss.leadingAnchor.constraint(equalTo: viewButtonDismiss.leadingAnchor),
            buttonDismiss.trailingAnchor.constraint(equalTo: viewButtonDismiss.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            stackFavorite.topAnchor.constraint(equalTo: viewFavorite.topAnchor, constant: 10),
            stackFavorite.bottomAnchor.constraint(equalTo: viewFavorite.bottomAnchor, constant: -10),
            stackFavorite.leadingAnchor.constraint(equalTo: viewFavorite.leadingAnchor, constant: 10),
            stackFavorite.trailingAnchor.constraint(equalTo: viewFavorite.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalTo: safeAreaLayout.widthAnchor),
            image.heightAnchor.constraint(equalTo: safeAreaLayout.widthAnchor),
            image.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor),
            image.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            viewTitle.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -5),
            viewTitle.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 5),
            viewTitle.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -5)
        ])

        NSLayoutConstraint.activate([
            viewFavorite.bottomAnchor.constraint(equalTo: viewTitle.topAnchor, constant: -5),
            viewFavorite.trailingAnchor.constraint(equalTo: viewTitle.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: viewTitle.topAnchor, constant: 10),
            labelTitle.bottomAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: -10),
            labelTitle.leadingAnchor.constraint(equalTo: viewTitle.leadingAnchor, constant: 10),
            labelTitle.trailingAnchor.constraint(equalTo: viewTitle.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            labelComics.heightAnchor.constraint(equalToConstant: 30),
            labelComics.topAnchor.constraint(equalTo: image.bottomAnchor),
            labelComics.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor),
            labelComics.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: image.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
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
                                      size: .incredible)
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
