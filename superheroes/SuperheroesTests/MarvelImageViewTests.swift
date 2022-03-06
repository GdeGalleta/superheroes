//
//  MarvelImageViewTests.swift
//  SuperheroesTests
//
//  Created by Dimitri Sopov on 6/3/22.
//

import XCTest
import UIKit.UIImageView

class MarvelImageViewTests: XCTestCase {
    
    func test_marvelImageFromURL() {
        let expectation0 = expectation(description: "image loaded")
        
        let expected = UIImage(data: TestsConstants.marvelImageData)
        let path = "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"
        let ext = "jpg"
        let imageView = UIImageViewMock()
        
        XCTAssertNil(imageView.image)
        
        imageView.loadMarvel(path: path, ext: ext, aspect: .standard, size: .small) {
            let data1 = imageView.image!.pngData()!
            let data2 = expected!.pngData()!
            if data1 == data2 {
                expectation0.fulfill()
            }
        }
        
        wait(for: [expectation0], timeout: 5)
    }
    
    private class UIImageViewMock: MarvelImageView {
        
        override func loadImageData(url: URL) throws -> Data? {
            return TestsConstants.marvelImageData
        }
    }
}
