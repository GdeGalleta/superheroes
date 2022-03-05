//
//  ApiResource.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation

public protocol ApiResourceType: AnyObject {
    associatedtype Model: Decodable
    var request: URLRequest? { get }
}

public class ApiResource<T: Decodable>: ApiResourceType {
    public typealias Model = T

    let baseURL: String
    let pathURL: String
    let queryParameters: [String: Any]

    public var request: URLRequest? {
        guard !baseURL.isEmpty else {
            return nil
        }
        let path = "\(baseURL)\(pathURL)"
        var components = URLComponents(string: path)
        components?.queryItems = queryParameters
            .compactMapValues { $0 as? String }
            .map { (key, value) in return URLQueryItem(name: key, value: value) }
        if let url = components?.url?.absoluteURL {
            return URLRequest(url: url)
        }
        return nil
    }

    public init(baseURL: String,
                pathURL: String,
                queryParameters: [String: Any] = [:]) {
        self.baseURL = baseURL
        self.pathURL = pathURL
        self.queryParameters = queryParameters
    }
}
