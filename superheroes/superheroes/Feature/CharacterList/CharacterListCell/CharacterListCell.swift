//
//  CharacterListCell.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit

public final class CharacterListCell: UITableViewCell {

    // MARK: - Properties
    public static let identifier = "CharacterListCell"

    private let viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()

    private let labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.textColor = K.Color.textDark
        return label
    }()

    private let imageThumbnail: MarvelImageView = {
        let image = MarvelImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "character_placeholder")
        return image
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

extension CharacterListCell {

    public func setup(with model: CharacterListModel) {
        labelName.text = model.name
        imageThumbnail.loadMarvel(path: model.image.path,
                                  ext: model.image.ext,
                                  aspect: .standard,
                                  size: .xlarge)
    }

    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(viewContainer)
        viewContainer.addSubview(imageThumbnail)
        viewContainer.addSubview(labelName)

        let rColor = UIColor.randomLight
        viewContainer.backgroundColor = rColor
        viewContainer.layer.borderWidth = 2
        viewContainer.layer.borderColor = rColor.cgColor
        viewContainer.layer.cornerRadius = 10
        viewContainer.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.5),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.5),
            viewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2.5),
            viewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2.5),

            imageThumbnail.widthAnchor.constraint(equalToConstant: 100),
            imageThumbnail.heightAnchor.constraint(equalToConstant: 100),
            imageThumbnail.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            imageThumbnail.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
            imageThumbnail.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),

            labelName.leadingAnchor.constraint(equalTo: imageThumbnail.trailingAnchor, constant: 10),
            labelName.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            labelName.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
            labelName.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10)
        ])
    }
}
