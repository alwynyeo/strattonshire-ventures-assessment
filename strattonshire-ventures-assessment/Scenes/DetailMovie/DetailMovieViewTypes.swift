//
//  DetailMovieViewTypes.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/4/24.
//

import Foundation

protocol DetailMovieDisplayLogic: AnyObject {}

protocol DetailMovieBusinessLogic {
    var intent: DetailMovieIntent? { get set }
}

struct DetailMovieIntent {
    let movie: Movie
}
