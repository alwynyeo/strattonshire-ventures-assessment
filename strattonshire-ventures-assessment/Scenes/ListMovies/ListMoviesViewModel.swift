//
//  ListMoviesViewModel.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

import Foundation

final class ListMoviesViewModel {
    // MARK: - Declarations

    weak var view: ListMoviesDisplayLogic?

    var persistenceService: PersistenceService

    var networkService: NetworkService?

    private var allMovies: [ListMovieCellItem] = []

    private var filteredMovies: [ListMovieCellItem] = []

    private var paginatedMovies: [ListMovieCellItem] = []

    private var currentPageNumber = 1

    private let moviesPerPageCount = 5

    private var canLoadMoreMovies = true

    private var isPaginatingMovies = false

    private var queryText = ""

    var dataSource: ListMoviesViewControllerDataSource?

    var isSearching: Bool = false

    var isSameQuery: Bool = false

    private let mainQueue = DispatchQueue.main

    // MARK: - Object Lifecycle

    init() {
        let persistenceService = PersistenceService.shared
        let networkService = NetworkService.shared
        self.persistenceService = persistenceService
        self.networkService = networkService
    }

    // MARK: - Helpers
    // Fetch movies from network
    private func fetchMoviesFromNetwork() async throws -> [Movie]? {
        guard let movies = try await networkService?.fetchAllMovies() else {
            return nil
        }
        return movies
    }

    // Paginate movies
    private func paginateMovies(movies: [ListMovieCellItem], pageNumber: Int, moviesPerPageCount: Int) -> [ListMovieCellItem] {
        var startIndex = (pageNumber - 1) * moviesPerPageCount
        if startIndex < 0 { startIndex = 0 }
        let endIndex = min(startIndex + moviesPerPageCount, movies.count)
        guard startIndex < endIndex else {
            canLoadMoreMovies = false
            return []
        }
        let paginatedMovies = movies[startIndex..<endIndex]
        return Array(paginatedMovies)
    }

    // Handle network errors
    private func handleNetworkError(_ error: NetworkError) {
        switch error {
            case .invalidUrl:
                print("Error: invalidURL under \(#function) at line \(#line) in \(#fileID) file.")
            case .invalidResponse:
                print("Error: invalidResponse under \(#function) at line \(#line) in \(#fileID) file.")
            case .requestTimeout:
                print("Error: invalidResponse under \(#function) at line \(#line) in \(#fileID) file.")
            case .statusCodeNotSuccess:
                print("Error: statusCodeNotSuccess under \(#function) at line \(#line) in \(#fileID) file.")
            case .jsonDecodeFailure(let error):
                print("Error: jsonDecodeFailure, \(error.localizedDescription) under \(#function) at line \(#line) in \(#fileID) file.")
        }
    }

    private func _loadAllMovies() {
        Task {
            do {
                guard let movies = try await fetchMoviesFromNetwork() else { return }
                let allMovies = movies.map { ListMovieCellItem(movie: $0) }
                self.allMovies = allMovies
                let paginatedMovies = paginateMovies(
                    movies: allMovies,
                    pageNumber: currentPageNumber,
                    moviesPerPageCount: moviesPerPageCount
                )
                self.paginatedMovies = paginatedMovies
                displayLoadedMovies(items: paginatedMovies)
            } catch let error as NetworkError {
                handleNetworkError(error)
            } catch {
                print("Unexpected error: '\(error.localizedDescription)' under \(#function) at line \(#line) in \(#fileID) file.")
            }
        }
    }

    private func displayLoadedMovies(items: [ListMovieCellItem]) {
        var snapshot = ListMoviesViewControllerDataSourceSnapshot()
        snapshot.appendSections(ListMoviesViewControllerDataSourceSection.allCases)
        snapshot.appendItems(items, toSection: ListMoviesViewControllerDataSourceSection.main)
        mainQueue.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
            self.view?.displayLoadedMovies(layoutConfigurations: items)
        }
    }
}

// MARK: - ListMoviesBusinessLogic Extension
extension ListMoviesViewModel: ListMoviesBusinessLogic {
    func loadAllMovies() {
        _loadAllMovies()
    }

    func filterMovies(by query: String) {
        queryText = query
        if !isSearching { isSearching = true }
        let filteredMovies = paginatedMovies.filter { $0.movie.matches(query: query) }
        isSameQuery = filteredMovies == self.filteredMovies
        if !isSameQuery { self.filteredMovies = filteredMovies }
        displayLoadedMovies(items: filteredMovies)
    }

    func clearSearchResults() {
        if isSearching { isSearching = false }
        displayLoadedMovies(items: paginatedMovies)
    }

    func loadNextPageOfMovies() {
        guard !isPaginatingMovies else { return }

        guard !isSearching && canLoadMoreMovies else {
            view?.stopLoading()
            return
        }

        if !isPaginatingMovies { isPaginatingMovies = true }

        currentPageNumber += 1

        let paginatedMovies = paginateMovies(
            movies: allMovies,
            pageNumber: currentPageNumber,
            moviesPerPageCount: moviesPerPageCount
        )

        guard paginatedMovies.isNotEmpty else {
            isPaginatingMovies = false
            view?.stopLoading()
            return
        }

        self.paginatedMovies.append(contentsOf: paginatedMovies)

        displayLoadedMovies(items: self.paginatedMovies)

        isPaginatingMovies = false
    }

    func refreshMovieList() {
        guard !isSearching else { return }
        currentPageNumber = 1
        canLoadMoreMovies = true
        loadAllMovies()
    }

    func routeToDetailMovie(indexPath: IndexPath) {
        let filteredMovies = paginatedMovies.filter { $0.movie.matches(query: queryText) }
        isSameQuery = filteredMovies == self.filteredMovies
        if !isSameQuery { self.filteredMovies = filteredMovies }

        guard let movie = dataSource?.itemIdentifier(for: indexPath)?.movie as? Movie else { return }

        let intent = DetailMovieIntent(movie: movie)
        view?.routeToDetailMovie(intent: intent)
    }
}

private extension ListMoviesViewModel {
    
}
