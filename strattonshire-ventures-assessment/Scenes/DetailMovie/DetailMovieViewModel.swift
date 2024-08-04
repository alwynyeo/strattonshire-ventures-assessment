//
//  DetailMovieViewModel.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/4/24.
//

import Foundation

final class DetailMovieViewModel {
    // MARK: - Declarations

    weak private(set) var view: DetailMovieDisplayLogic?

    var intent: DetailMovieIntent?

    // MARK: - Object Lifecycle

    init(view: DetailMovieDisplayLogic?) {
        self.view = view
    }

    // MARK: - Helpers
}

// MARK: - DetailMovieBusinessLogic Extension
extension DetailMovieViewModel: DetailMovieBusinessLogic {}
