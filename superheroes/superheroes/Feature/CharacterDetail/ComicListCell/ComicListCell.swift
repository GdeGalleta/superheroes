//
//  ComicListCell.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit

public final class ComicListCell: UITableViewCell {

    // MARK: - Properties
    public static let identifier = "ComicListCell"

    private let viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()

    private let labelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = K.Color.textDark
        return label
    }()

    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Initializer
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComicListCell {

    public func setup(with model: CharacterDetailComicModel) {
        labelTitle.text = model.title
    }

    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(viewContainer)
        viewContainer.addSubview(labelTitle)

        let rColor = UIColor.randomLight
        viewContainer.backgroundColor = rColor
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.borderColor = rColor.cgColor
        viewContainer.layer.cornerRadius = 10
        viewContainer.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.5),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.5),
            viewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2.5),
            viewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2.5),

            labelTitle.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            labelTitle.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10),
            labelTitle.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 10),
            labelTitle.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10)
        ])
    }
}
