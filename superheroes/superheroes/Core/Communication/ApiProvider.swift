//
//  ApiProvider.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 5/3/22.
//

import Foundation
import Combine

public protocol ApiProviderType {
    func fetchData<V: ApiResourceType>(resource: V) -> AnyPublisher<Data, ApiError>
    func fetch<T: Decodable, V: ApiResourceType>(resource: V) -> AnyPublisher<T, ApiError>
}

public final class ApiProvider: ApiProviderType {

    private let session: URLSession

    public init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.session = session
    }

    private func setupErrorDetails(context: DecodingError.Context) -> String {
        return context.underlyingError?.localizedDescription
        ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
    }

    // MARK: - Fetching by Resource
    public func fetchData<V: ApiResourceType>(resource: V) -> AnyPublisher<Data, ApiError> {
        guard let resourceRequest = resource.request else {
            return Fail(error: ApiError.invalidURL).eraseToAnyPublisher()
        }

        return fetchData(request: resourceRequest)
    }

    public func fetch<T: Decodable, V: ApiResourceType>(resource: V) -> AnyPublisher<T, ApiError> {
        guard let resourceRequest = resource.request else {
            return Fail(error: ApiError.invalidURL).eraseToAnyPublisher()
        }

        return fetch(request: resourceRequest)
    }

    // MARK: - Fetching by URLRequest

    private func fetchData(request: URLRequest) -> AnyPublisher<Data, ApiError> {
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw ApiError.unknown
                }
                return data
            }
            .mapError { error in
                if let error = error as? ApiError {
                    return error
                } else {
                    return ApiError.apiError(description: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }

    private func fetch<T: Decodable>(request: URLRequest) -> AnyPublisher<T, ApiError> {
        return fetchData(request: request)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { [weak self] error in
                guard let self = self else {
                    return ApiError.unknown
                }
                if let error = error as? DecodingError {
                    var errorToReport = error.localizedDescription
                    switch error {
                    case .dataCorrupted(let context):
                        let details = self.setupErrorDetails(context: context)
                        errorToReport = "\(context.debugDescription) - (\(details))"
                    case .keyNotFound(let key, let context):
                        let details = self.setupErrorDetails(context: context)
                        errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
                    case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                        let details = self.setupErrorDetails(context: context)
                        errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
                    @unknown default:
                        break
                    }
                    return ApiError.decodingError(description: errorToReport)
                } else {
                    return ApiError.apiError(description: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
