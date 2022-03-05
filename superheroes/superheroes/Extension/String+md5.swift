//
//  String+md5.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation
import CryptoKit

extension String {
    public var md5: String {
        let data = self.data(using: .utf8) ?? Data()
        return Insecure.MD5
            .hash(data: data)
            .map {String(format: "%02x", $0)}
            .joined()
    }
}
