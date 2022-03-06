//
//  UIColor+Random.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 6/3/22.
//

import UIKit.UIColor

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }

    static var randomLight: UIColor {
        return UIColor(
            red: .random(in: 0.5...1),
            green: .random(in: 0.5...1),
            blue: .random(in: 0.5...1),
            alpha: 1.0
        )
    }

    static var randomDark: UIColor {
        return UIColor(
            red: .random(in: 0...0.5),
            green: .random(in: 0...0.5),
            blue: .random(in: 0...0.5),
            alpha: 1.0
        )
    }
}
