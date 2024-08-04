//
//  ListMoviesViewTypes.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/3/24.
//

import Foundation

protocol ListMoviesDisplayLogic: AnyObject {
    func displayLoadedMovies(layoutConfigurations: [PinterestLayoutConfiguration])
    func stopLoading()
    func routeToDetailMovie(intent: DetailMovieIntent)
}

protocol ListMoviesBusinessLogic {
    var dataSource: ListMoviesViewControllerDataSource? { get set }
    var isSearching: Bool { get }
    var isSameQuery: Bool { get }
    func loadAllMovies()
    func filterMovies(by query: String)
    func clearSearchResults()
    func loadNextPageOfMovies()
    func refreshMovieList()
    func routeToDetailMovie(indexPath: IndexPath)
}

struct ListMovieCellItem: Hashable {
    let movie: Movie
}

extension ListMovieCellItem: PinterestLayoutConfiguration {
    var imageAspectRatio: CGFloat {
        return (movie.posterImageWidth ?? 0) / (movie.posterImageHeight ?? 0)
    }

    var title: String {
        return movie.title ?? ""
    }

    var firstSubtitle: String {
        return "\(movie.year ?? 0)"
    }

    var secondSubtitle: String {
        return "\(movie.rating ?? 0)"
    }
}
