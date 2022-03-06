//
//  MarvelConstants.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit.UIColor

public struct K {
    public struct Color {
        public static let background = UIColor(named: "background") ?? .darkGray
        public static let textLight = UIColor(named: "text_light") ?? .white
        public static let textDark = UIColor(named: "text_dark") ?? .black
    }
    public struct AccessIden {
        public static let listLabelTitle = "listLabelTitle"
    }
}

// MARK: - MarvelImageAspect

public enum MarvelImageAspect: String {
    case portrait
    case standard
    case landscape
}

// MARK: - MarvelImageSize

public enum MarvelImageSize: String {
    case small // 50x75px
    case medium // 100x150px
    case xlarge // 150x225px
    case fantastic // 168x252px
    case uncanny // 300x450px
    case incredible // 216x324px
}
