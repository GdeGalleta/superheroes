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

    public var viewModel: CharacterListCellViewModel? {
        didSet {
            labelName.text = viewModel?.name
        }
    }

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

    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 0.1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        contentView.addSubview(labelName)

        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            labelName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
