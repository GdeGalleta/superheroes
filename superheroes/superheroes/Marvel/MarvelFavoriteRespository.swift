//
//  MarvelFavoriteRespository.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 6/3/22.
//

import Foundation

public struct MarvelFavoriteRespository {

    private static let userDefaults = UserDefaults.standard
    private static let keyPrefix = "kFavoriteKey_"

    public static func storeFavorite(characterName: String) {
        let key = "\(keyPrefix)\(characterName)"
        userDefaults.set(characterName, forKey: key)
    }

    public static func removeFavorite(characterName: String) {
        let key = "\(keyPrefix)\(characterName)"
        userDefaults.removeObject(forKey: key)
    }

    public static func isFavorite(characterName: String) -> Bool {
        let key = "\(keyPrefix)\(characterName)"
        return userDefaults.value(forKey: key) != nil
    }
}
