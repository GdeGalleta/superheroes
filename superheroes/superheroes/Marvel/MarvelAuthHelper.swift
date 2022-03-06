//
//  MarvelAuthHelper.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation

struct MarvelAuthCredentials {
    var publicKey: String
    var privateKey: String
}

struct MarvelAuthEntity: Encodable {
    var ts = String(Date().timeIntervalSince1970)
    var hash: String
    var apikey: String
}

class MarvelAuthHelper {
    static func generateCredentials(credentials: MarvelAuthCredentials) -> MarvelAuthEntity {
        generateCredentials(publicKey: credentials.publicKey, privateKey: credentials.privateKey)
    }

    static func generateCredentials(publicKey: String, privateKey: String) -> MarvelAuthEntity {
        let ts = String(Date().timeIntervalSince1970)
        let hash = "\(ts)\(privateKey)\(publicKey)".md5
        return MarvelAuthEntity(ts: ts, hash: hash, apikey: publicKey)
    }

    static func generateDefaultCredentials() -> MarvelAuthEntity {
        let defaultCredentials = MarvelAuthCredentials(
            publicKey: "aaeb0e87f67e8c94777a8356e9e57ef3",
            privateKey: "fe5ec6dfc8d444d216e4c55f835f282945b55148")
        return generateCredentials(credentials: defaultCredentials)
    }
}
