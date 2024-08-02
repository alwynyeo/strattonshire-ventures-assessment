//
//  Movie.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

import Foundation

struct Movie: Decodable {
    let id : Int?
    let title : String?
    let year : Int?
    let genre : [String]?
    let rating : Double?
    let director : String?
    let actors : [String]?
    let plot : String?
    let poster : String?
    let trailer : String?
    let runtime : Int?
    let awards : String?
    let country : String?
    let language : String?
    let boxOffice : String?
    let production : String?
    let website : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case year = "year"
        case genre = "genre"
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
        genre = try values.decodeIfPresent([String].self, forKey: .genre)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
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
}
