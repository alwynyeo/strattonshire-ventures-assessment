//
//  NetworkService.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

import Foundation

final class NetworkService {
    // MARK: - Declarations

    static let shared = NetworkService()

    private var urlSession: URLSession

    private let decoder: JSONDecoder

    private var urlComponents: URLComponents

    // MARK: - Object Lifecycle

    private init() {
        // URLSession
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.waitsForConnectivity = true
        urlSessionConfiguration.multipathServiceType = URLSessionConfiguration.MultipathServiceType.handover
        urlSessionConfiguration.allowsCellularAccess = true
        urlSessionConfiguration.timeoutIntervalForRequest = 30 // 30 seconds
        urlSessionConfiguration.timeoutIntervalForResource = 15 // 10 seconds
        urlSession = URLSession(configuration: urlSessionConfiguration)

        // JSONDecoder
        let decoder = JSONDecoder()
        self.decoder = decoder

        // URLComponents
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "freetestapi.com"
        self.urlComponents = urlComponents
    }
}

// MARK: - Public API
extension NetworkService {
    func fetchAllMovies() async throws -> [Movie] {
        urlComponents.path = "/api/v1/movies"

        guard let url = urlComponents.url else {
            throw NetworkError.invalidUrl
        }

        let (data, response) = try await urlSession.data(from: url)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        let statusCode = response.statusCode

        guard statusCode == NetworkStatusCode.success.rawValue else {
            throw NetworkError.statusCodeNotSuccess
        }

        do {
            let movies = try decoder.decode([Movie].self, from: data)
            return movies
        } catch let error {
            throw NetworkError.jsonDecodeFailure(error)
        }
    }
}
