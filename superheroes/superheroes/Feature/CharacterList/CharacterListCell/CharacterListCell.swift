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

    private let labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 1
        label.font = UIFont(name: label.font.fontName, size: 20)
        // label.textColor = .white
        return label
    }()

    private let imageThumbnail: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
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
                                  size: .medium)
    }

    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 0.1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        contentView.addSubview(imageThumbnail)
        contentView.addSubview(labelName)

        NSLayoutConstraint.activate([
            imageThumbnail.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageThumbnail.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            imageThumbnail.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageThumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageThumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageThumbnail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            labelName.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
