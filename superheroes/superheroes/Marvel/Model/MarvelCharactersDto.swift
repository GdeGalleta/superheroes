//
//  MarvelCharactersDto.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation

// MARK: - MarvelCharactersDto
public struct MarvelCharactersDto: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: MarvelDataClassDto?
}

// MARK: - DataClass
public struct MarvelDataClassDto: Codable {
    let offset, limit, total, count: Int?
    let results: [MarvelResultDto]?
}

// MARK: - Result
public struct MarvelResultDto: Codable {
    let identifier: Int?
    let name, resultDescription: String?
    let modified: String?
    let thumbnail: MarvelThumbnailDto?
    let resourceURI: String?
    let comics: MarvelComicsDto?
//    let series: MarvelSeriesDto?
//    let stories: MarvelStoriesDto?
//    let events: MarvelEventsDto?
//    let urls: [MarvelURLElementDto]?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case resultDescription = "description"
        case modified
        case thumbnail
        case resourceURI
        case comics
//        case series
//        case stories
//        case events
//        case urls
    }
}

// MARK: - Comics
public struct MarvelComicsDto: Codable {
    let available: Int?
    let collectionURI: String?
    let comicItems: [MarvelComicsItemDto]?
    let returned: Int?

    enum CodingKeys: String, CodingKey {
        case available
        case collectionURI
        case comicItems = "items"
        case returned
    }
}

// MARK: - Series
public struct MarvelSeriesDto: Codable {
    let available: Int?
    let collectionURI: String?
    let serieItems: [MarvelSeriesItemDto]?
    let returned: Int?

    enum CodingKeys: String, CodingKey {
        case available
        case collectionURI
        case serieItems = "items"
        case returned
    }
}

// MARK: - Events
public struct MarvelEventsDto: Codable {
    let available: Int?
    let collectionURI: String?
    let eventItems: [MarvelEventsItemDto]?
    let returned: Int?

    enum CodingKeys: String, CodingKey {
        case available
        case collectionURI
        case eventItems = "items"
        case returned
    }
}

// MARK: - ComicsItem
public struct MarvelComicsItemDto: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - SerieItem
public struct MarvelSeriesItemDto: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - EventsItem
public struct MarvelEventsItemDto: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - Stories
public struct MarvelStoriesDto: Codable {
    let available: Int?
    let collectionURI: String?
    let storyItems: [StoriesItemDto]?
    let returned: Int?

    enum CodingKeys: String, CodingKey {
        case available
        case collectionURI
        case storyItems = "items"
        case returned
    }
}

// MARK: - StoriesItem
public struct StoriesItemDto: Codable {
    let resourceURI: String?
    let name: String?
    let type: String?
}

// MARK: - Thumbnail
public struct MarvelThumbnailDto: Codable {
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
public struct MarvelURLElementDto: Codable {
    let type: String?
    let url: String?
}
