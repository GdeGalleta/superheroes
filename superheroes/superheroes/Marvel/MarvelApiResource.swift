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

        let authParameters = MarvelAuthHelper.generateDefaultCredentials().dictionary

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
}

public struct CharactersQuery: Encodable {
    let name: String? = nil /// Return only characters matching the specified full character name (e.g. Spider-Man).
    let nameStartsWith: String? = nil /// Return characters with names that begin with the specified string (e.g. Sp).
    let modifiedSince: Date? = nil /// Return only characters which have been modified since the specified date.
    let comics: Int? = nil /// Return only characters which appear in the specified comics (accepts a comma-separated list of ids).
    let series: Int? = nil /// Return only characters which appear the specified series (accepts a comma-separated list of ids).
    let events: Int? = nil /// Return only characters which appear in the specified events (accepts a comma-separated list of ids).
    let stories: Int? = nil /// Return only characters which appear the specified stories (accepts a comma-separated list of ids).
    let orderBy: String? = nil /// Order the result set by a field or fields. Add a "-" to the value sort in descending order. Multiple values are given priority in the order in which they are passed.
    let limit: Int? = nil /// Limit the result set to the specified number of resources.
    let offset: Int? = nil /// Skip the specified number of resources in the result set.
}
