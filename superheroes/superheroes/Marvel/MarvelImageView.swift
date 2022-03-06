//
//  MarvelImageView.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 6/3/22.
//

import UIKit

public class MarvelImageView: UIImageView {
    
    public func loadImageData(url: URL) throws -> Data? {
        return try? Data(contentsOf: url)
    }
    
    public func loadMarvel(path: String, ext: String, aspect: MarvelImageAspect, size: MarvelImageSize, completion: (() -> Void)? = nil) {
        if let url = URL(string: "\(path)/\(aspect.rawValue)_\(size.rawValue).\(ext)") {
            load(url: url, completion: completion)
        }
    }
    
    public func load(url: URL, completion: (() -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? self?.loadImageData(url: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                        completion?()
                    }
                }
            }
        }
    }
}
