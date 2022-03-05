//
//  ApiError.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation

public enum ApiError: LocalizedError, Equatable {
    case unknown
    case invalidURL
    case decodingError(description: String)
    case apiError(description: String)

    public var errorDescription: String? {
        switch self {
            case .unknown:
                return "Unknown error"
            case .invalidURL:
                return "Invalid URL"
            case .decodingError(let description), .apiError(let description):
                return description
        }
    }
}
