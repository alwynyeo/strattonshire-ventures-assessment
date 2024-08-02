//
//  ListMoviesViewModel.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

// MARK: - ListMoviesBusinessLogic Protocol
protocol ListMoviesBusinessLogic {
    func doSomething()
}

final class ListMoviesViewModel {
    // MARK: - Declarations

    weak var view: ListMoviesDisplayLogic?

    // MARK: - Object Lifecycle

    init() {}

    // MARK: - Helpers
}

// MARK: - ListMoviesBusinessLogic Extension
extension ListMoviesViewModel: ListMoviesBusinessLogic {
    func doSomething() {
        view?.displaySomething()
    }
}
