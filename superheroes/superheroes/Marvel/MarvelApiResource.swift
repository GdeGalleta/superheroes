//
//  MarvelApiResource.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation
import Combine

private enum MarvelEndpoint: String {
    case undefined
    case characters
}

public final class MarvelApiResource<T: Decodable>: ApiResource<T> {

    private convenience init(endpoint: MarvelEndpoint,
                             queryParameters: [String: Any] = [:]) {

        let authParameters = MarvelAuthRepository.generateDefaultCredentials().dictionary

        var marvelQueryParameters = queryParameters
        marvelQueryParameters+=authParameters

        self.init(baseURL: "https://gateway.marvel.com/v1/public/",
                  pathURL: endpoint.rawValue,
                  queryParameters: marvelQueryParameters)
    }

    // MARK: - Actions
    public class func characters(query: CharactersQuery? = nil) -> MarvelApiResource<MarvelCharactersDto> {
        let queryParameters = query?.dictionary ?? [:]
        return MarvelApiResource<MarvelCharactersDto>(endpoint: .characters, queryParameters: queryParameters)
    }

    public class func character(characterName: String) -> MarvelApiResource<MarvelCharactersDto> {
        var query = CharactersQuery()
        query.name = characterName
        return characters(query: query)
    }
}

public struct CharactersQuery: Encodable {
    var name: String? /// Return only characters matching the specified full character name (e.g. Spider-Man).
    var nameStartsWith: String? /// Return characters with names that begin with the specified string (e.g. Sp).
    var modifiedSince: Date? /// Return only characters which have been modified since the specified date.
    var comics: Int? /// Return only characters which appear in the specified comics (accepts a comma-separated list of ids).
    var series: Int? /// Return only characters which appear the specified series (accepts a comma-separated list of ids).
    var events: Int? /// Return only characters which appear in the specified events (accepts a comma-separated list of ids).
    var stories: Int? /// Return only characters which appear the specified stories (accepts a comma-separated list of ids).
    var orderBy: String? /// Order the result set by a field or fields. Add a "-" to the value sort in descending order. Multiple values are given priority in the order in which they are passed.
    var limit: Int = 20 /// Limit the result set to the specified number of resources.
    var offset: Int = 0 /// Skip the specified number of resources in the result set.
}
