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

    private var persistenceService: PersistenceService

    // MARK: - Object Lifecycle

    private init() {
        // URLSession
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.waitsForConnectivity = true
        urlSessionConfiguration.multipathServiceType = URLSessionConfiguration.MultipathServiceType.handover
        urlSessionConfiguration.allowsCellularAccess = true
        urlSessionConfiguration.timeoutIntervalForRequest = 30 // 30 seconds
        urlSessionConfiguration.timeoutIntervalForResource = 5 // 5 seconds
        urlSession = URLSession(configuration: urlSessionConfiguration)

        // JSONDecoder
        let decoder = JSONDecoder()
        self.decoder = decoder

        // URLComponents
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "freetestapi.com"
        self.urlComponents = urlComponents

        // PersistenceService
        let persistenceService = PersistenceService.shared
        self.persistenceService = persistenceService
    }

    // MARK: - Helpers

    // Validate the HTTP response
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard httpResponse.statusCode == NetworkStatusCode.success.rawValue else {
            throw NetworkError.statusCodeNotSuccess
        }
    }

    // Fetch data from the URL
    private func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await urlSession.data(from: url)
            return (data, response)
        } catch let error {
            print("Error: '\(error.localizedDescription)' happened under \(#function) at line \(#line) in \(#fileID) file.")
            throw NetworkError.requestTimeout
        }
    }

    // Decode movies from JSON data
    private func decodeMovies(from data: Data) throws -> [Movie] {
        do {
            let movies = try decoder.decode([Movie].self, from: data)
            return movies
        } catch let error {
            print("Error: '\(error.localizedDescription)' happened under \(#function) at line \(#line) in \(#fileID) file.")
            throw NetworkError.jsonDecodeFailure(error)
        }
    }

    // Fetch and set image dimensions for each movie
    private func fetchAndSetMovieDimensions(movies: [Movie]) async -> [Movie] {
        var updatedMovies: [Movie] = []

        for movie in movies {
            async let imageAspectRatio = fetchImageDimensions(for: movie.poster)
            var updatedMovie = movie
            if let (width, height) = await imageAspectRatio {
                updatedMovie.posterImageWidth = width
                updatedMovie.posterImageHeight = height
            }
            updatedMovies.append(updatedMovie)
        }

        return updatedMovies
    }


    // Fetch image dimensions from URL
    private func fetchImageDimensions(for posterString: String?) async -> (CGFloat, CGFloat)? {
        guard let posterString = posterString, let url = URL(string: posterString) else { return nil }
        return url.getImageAspectRatio()
    }

    // Fetch movies from persistence service
    private func fetchMoviesFromPersistence() -> [Movie] {
        return persistenceService.fetchAllMovies()
    }
}

// MARK: - Public API
extension NetworkService {
    // Fetch all movies from API
    func fetchAllMovies() async throws -> [Movie] {
        urlComponents.path = "/api/v1/movies"

        guard let url = urlComponents.url else {
            throw NetworkError.invalidUrl
        }

        do {
            let (data, response) = try await fetchData(from: url)
            try validateResponse(response)
            var movies = try decodeMovies(from: data)
            movies = await fetchAndSetMovieDimensions(movies: movies)
            persistenceService.persist(movies: movies)
            return movies
        } catch {
            print("Error: '\(error.localizedDescription)' happened under \(#function) at line \(#line) in \(#fileID) file.")
            let movies = fetchMoviesFromPersistence()
            return movies
        }
    }
}
