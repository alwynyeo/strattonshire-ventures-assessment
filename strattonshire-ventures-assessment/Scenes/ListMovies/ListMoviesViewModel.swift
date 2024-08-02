//
//  ListMoviesViewModel.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

// MARK: - ListMoviesBusinessLogic Protocol
protocol ListMoviesBusinessLogic {
    func fetchAllMovies()
}

final class ListMoviesViewModel {
    // MARK: - Declarations

    weak var view: ListMoviesDisplayLogic?

    var networkService: NetworkService?

    // MARK: - Object Lifecycle

    init() {
        let networkService = NetworkService.shared
        self.networkService = networkService
    }

    // MARK: - Helpers
}

// MARK: - ListMoviesBusinessLogic Extension
extension ListMoviesViewModel: ListMoviesBusinessLogic {
    func fetchAllMovies() {
        Task {
            do {
                guard let movies = try await networkService?.fetchAllMovies() else { return }
                print(movies.count)
                view?.displayMovies()
            } catch let error as NetworkError {
                switch error {
                    case .invalidUrl:
                        print("Error: invalidURL under \(#function) at line \(#line) in \(#fileID) file.")
                    case .invalidResponse:
                        print("Error: invalidResponse under \(#function) at line \(#line) in \(#fileID) file.")
                    case .statusCodeNotSuccess:
                        print("Error: statusCodeNotSuccess under \(#function) at line \(#line) in \(#fileID) file.")
                    case .jsonDecodeFailure(let error):
                        print("Error: jsonDecodeFailure, \(error.localizedDescription) under \(#function) at line \(#line) in \(#fileID) file.")
                }
            }
        }
    }
}
