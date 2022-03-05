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
    let id: Int?
    let name, resultDescription: String?
    let modified: String?
    let thumbnail: MarvelThumbnailDto?
    let resourceURI: String?
    let comics, series: MarvelComicsDto?
    let stories: MarvelStoriesDto?
    let events: MarvelComicsDto?
    let urls: [MarvelURLElementDto]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription
        case modified, thumbnail, resourceURI, comics, series, stories, events, urls
    }
}

// MARK: - Comics
public struct MarvelComicsDto: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [MarvelComicsItemDto]?
    let returned: Int?
}

// MARK: - ComicsItem
public struct MarvelComicsItemDto: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - Stories
public struct MarvelStoriesDto: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [StoriesItemDto]?
    let returned: Int?
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
        case thumbnailExtension
    }
}

// MARK: - URLElement
public struct MarvelURLElementDto: Codable {
    let type: String?
    let url: String?
}
