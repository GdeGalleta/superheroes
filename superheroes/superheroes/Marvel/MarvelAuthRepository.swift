//
//  MarvelAuthRepository.swift
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

class MarvelAuthRepository {
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
            publicKey: ApiKeys.apikey,
            privateKey: ApiKeys.secret)
        return generateCredentials(credentials: defaultCredentials)
    }
}
