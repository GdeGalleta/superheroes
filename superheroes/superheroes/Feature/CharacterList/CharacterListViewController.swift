//
//  CharacterListViewController.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit
import Combine

public final class CharacterListViewController: UIViewController {

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    private let viewModel: CharacterListViewModelType
    private let coordinator: CharacterListCoordinatorType?

    private enum Section: CaseIterable { case characters }
    private typealias DataSource = UITableViewDiffableDataSource<Section, CharacterListModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CharacterListModel>
    private var dataSource: DataSource!

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        table.register(CharacterListCell.self, forCellReuseIdentifier: CharacterListCell.identifier)
        return table
    }()

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

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDataSource()
        setupBinding()
        fetchData()
    }
}

extension CharacterListViewController {
    private func setupLayout() {
        view.addSubview(tableView)

        let safeAreaLayout = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor)
        ])
    }

    private func setupBinding() {
        viewModel.dataSourcePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.setupSnapshot()
            }
            .store(in: &cancellables)
    }

    private func fetchData() {
        viewModel.fetchCharacters()
    }
}

extension CharacterListViewController {

    private func setupDataSource() {
        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, model -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(withIdentifier: CharacterListCell.identifier, for: indexPath) as? CharacterListCell                
                cell?.viewModel = CharacterListCellViewModel(character: model)
                return cell
            })
    }

    private func setupSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.characters])
        snapshot.appendItems(viewModel.dataSource)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CharacterListViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSource[indexPath.row]
        coordinator?.coordinateToCharacterDetail(characterName: model.name)
    }
}
