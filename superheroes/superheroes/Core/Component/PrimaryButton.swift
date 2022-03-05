//
//  PrimaryButton.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit

@IBDesignable public final class PrimaryButton: UIButton {

    @IBInspectable var borderColor: UIColor = .black
    @IBInspectable var titleColor: UIColor = .black
    @IBInspectable var fillColor: UIColor = UIColor.clear

    private var borderWidth = 4.0
    private var cornerRadius = 10.0
    private let border = CAShapeLayer()

    public override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    private func setupLayout() {
        border.lineWidth = borderWidth
        border.frame = bounds
        border.fillColor = fillColor.cgColor
        border.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        border.lineDashPattern = nil
        border.strokeColor = borderColor.cgColor

        setTitleColor(titleColor, for: .normal)

        layer.addSublayer(border)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}

