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

    public enum HttpMethod: String {
        case GET
        case POST
    }

    let httpMethod: HttpMethod
    let baseURL: String
    let pathURL: String
    let queryParameters: [String: Any]
    let headers: [String: String]

    public var request: URLRequest? {
        switch httpMethod {
            case .GET:
                return requestGET
            case .POST:
                return requestPOST
        }
    }

    private var requestGET: URLRequest? {
        let path = "\(baseURL)\(pathURL)"

        var components = URLComponents(string: path)
        components?.queryItems = queryParameters
            .compactMapValues { String(describing: $0) }
            .map { (key, value) in return URLQueryItem(name: key, value: value) }

        guard let finalURL = components?.url?.absoluteURL else {
            return nil
        }

        var request = URLRequest(url: finalURL)
        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod.rawValue
        return request
    }

    private var requestPOST: URLRequest? {
        guard !baseURL.isEmpty else {
            return nil
        }

        guard let finalURL = URLComponents(string: "\(baseURL)\(pathURL)")?.url else {
            return nil
        }

        var request = URLRequest(url: finalURL)
        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod.rawValue
        request.httpBody = try? JSONSerialization.data(withJSONObject: queryParameters, options: [])
        return request
    }

    public init(httpMethod: HttpMethod = .GET,
                baseURL: String,
                pathURL: String,
                queryParameters: [String: Any] = [:],
                headers: [String: String] = [:]) {
        self.httpMethod = httpMethod
        self.baseURL = baseURL
        self.pathURL = pathURL
        self.queryParameters = queryParameters
        self.headers = headers
    }
}
