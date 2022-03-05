//
//  UIImageView+URL.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import UIKit.UIImageView

extension UIImageView {
    func loadMarvel(path: String, ext: String, aspect: MarvelImageAspect, size: MarvelImageSize) {
        if let url = URL(string: "\(path)/\(aspect.rawValue)_\(size.rawValue).\(ext)") {
            load(url: url)
        }
    }

    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
