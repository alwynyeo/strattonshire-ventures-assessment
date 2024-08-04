//
//  Movie.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

import Foundation

struct Movie: Decodable, Hashable {
    let id: Int?
    let title: String?
    let year: Int?
    let genres: [String]?
    let rating: Float?
    let director: String?
    let actors: [String]?
    let plot: String?
    let poster: String?
    let trailer: String?
    let runtime: Int?
    let awards: String?
    let country: String?
    let language: String?
    let boxOffice: String?
    let production: String?
    let website: String?

    var posterImageWidth: CGFloat?
    var posterImageHeight: CGFloat?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case year = "year"
        case genres = "genre"
        case rating = "rating"
        case director = "director"
        case actors = "actors"
        case plot = "plot"
        case poster = "poster"
        case trailer = "trailer"
        case runtime = "runtime"
        case awards = "awards"
        case country = "country"
        case language = "language"
        case boxOffice = "boxOffice"
        case production = "production"
        case website = "website"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        year = try values.decodeIfPresent(Int.self, forKey: .year)
        genres = try values.decodeIfPresent([String].self, forKey: .genres)
        rating = try values.decodeIfPresent(Float.self, forKey: .rating)
        director = try values.decodeIfPresent(String.self, forKey: .director)
        actors = try values.decodeIfPresent([String].self, forKey: .actors)
        plot = try values.decodeIfPresent(String.self, forKey: .plot)
        poster = try values.decodeIfPresent(String.self, forKey: .poster)
        trailer = try values.decodeIfPresent(String.self, forKey: .trailer)
        runtime = try values.decodeIfPresent(Int.self, forKey: .runtime)
        awards = try values.decodeIfPresent(String.self, forKey: .awards)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        boxOffice = try values.decodeIfPresent(String.self, forKey: .boxOffice)
        production = try values.decodeIfPresent(String.self, forKey: .production)
        website = try values.decodeIfPresent(String.self, forKey: .website)
    }

    init(
        id: Int?,
        title: String?,
        year: Int?,
        genres: [String]?,
        rating: Float?,
        director: String?,
        actors: [String]?,
        plot: String?,
        poster: String?,
        trailer: String?,
        runtime: Int?,
        awards: String?,
        country: String?,
        language: String?,
        boxOffice: String?,
        production: String?,
        website: String?,
        posterImageWidth: CGFloat,
        posterImageHeight: CGFloat
    ) {
        self.id = id
        self.title = title
        self.year = year
        self.genres = genres
        self.rating = rating
        self.director = director
        self.actors = actors
        self.plot = plot
        self.poster = poster
        self.trailer = trailer
        self.runtime = runtime
        self.awards = awards
        self.country = country
        self.language = language
        self.boxOffice = boxOffice
        self.production = production
        self.website = website
        self.posterImageWidth = posterImageWidth
        self.posterImageHeight = posterImageHeight
    }
}

extension Movie {
    var properties: [String: Any?] {
        return [
            "title": title,
            "year": year,
            "genres": genres,
            "rating": rating,
            "director": director,
            "actors": actors,
            "plot": plot,
            "awards": awards,
            "country": country,
            "language": language,
            "production": production
        ]
    }

    func matches(query: String) -> Bool {
        let lowercasedQuery = query.lowercased()

        for (key, value) in properties {
            if let stringValue = value as? String {
                if stringValue.lowercased().contains(lowercasedQuery) {
                    return true
                }
            } else if let arrayValue = value as? [String] {
                for element in arrayValue {
                    if element.lowercased().contains(lowercasedQuery) {
                        return true
                    }
                }
            } else if let numberValue = value as? NSNumber {
                if "\(numberValue)".contains(lowercasedQuery) {
                    return true
                }
            }
        }

        return false
    }
}
