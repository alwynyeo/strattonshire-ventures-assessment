//
//  MovieEntity+CoreDataClass.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//
//

import Foundation
import CoreData

public class MovieEntity: NSManagedObject {
    // MARK: - Helpers

    static func getFetchedRequest() -> NSFetchRequest<MovieEntity> {
        let entity = self
        let request = entity.fetchRequest()

        let idKey = "id"
        let sortById = NSSortDescriptor(key: idKey, ascending: true)
        let sortDescriptors = [
            sortById
        ]

        request.sortDescriptors = sortDescriptors

        return request
    }

    func mapToMovie() -> Movie {
        let entity = self
        let id = Int(entity.id)
        let title = entity.title
        let year = Int(entity.year)
        let rating = entity.rating
        let director = entity.director
        let plot = entity.plot
        let poster = entity.poster
        let trailer = entity.trailer
        let runtime = Int(entity.runtime)
        let awards = entity.awards
        let country = entity.country
        let language = entity.language
        let boxOffice = entity.boxOffice
        let production = entity.production
        let website = entity.website
        let posterImageWidth = CGFloat(entity.posterImageWidth)
        let posterImageHeight = CGFloat(entity.posterImageHeight)

        print(posterImageWidth, posterImageHeight)

        let genres = entity.genreList?.map { movieGenreEntity -> String in
            let entity = movieGenreEntity as! MovieGenreEntity
            return entity.mapToString()
        }

        let actors = entity.actorList?.map { movieActorEntity -> String in
            let entity = movieActorEntity as! MovieActorEntity
            return entity.mapToString()
        }

        let movie = Movie(
            id: id,
            title: title,
            year: year,
            genres: genres,
            rating: rating,
            director: director,
            actors: actors,
            plot: plot,
            poster: poster,
            trailer: trailer,
            runtime: runtime,
            awards: awards,
            country: country,
            language: language,
            boxOffice: boxOffice,
            production: production,
            website: website,
            posterImageWidth: posterImageWidth,
            posterImageHeight: posterImageHeight
        )

        return movie
    }

    func set(movie: Movie, context: NSManagedObjectContext) {
        let entity = self
        let id = Int64(movie.id ?? 0)
        let title = movie.title
        let year = Int64(movie.year ?? 0)
        let genres = movie.genres ?? []
        let rating = movie.rating ?? 0
        let director = movie.director
        let actors = movie.actors ?? []
        let plot = movie.plot
        let poster = movie.poster
        let trailer = movie.trailer
        let runtime = Int64(movie.runtime ?? 0)
        let awards = movie.awards
        let country = movie.country
        let language = movie.language
        let boxOffice = movie.boxOffice
        let production = movie.production
        let website = movie.website
        let posterImageWidth = Float(movie.posterImageWidth ?? 0)
        let posterImageHeight = Float(movie.posterImageHeight ?? 0)

        entity.id = id
        entity.title = title
        entity.year = year
        entity.rating = rating
        entity.director = director
        entity.plot = plot
        entity.poster = poster
        entity.trailer = trailer
        entity.runtime = runtime
        entity.awards = awards
        entity.country = country
        entity.language = language
        entity.boxOffice = boxOffice
        entity.production = production
        entity.website = website
        entity.posterImageWidth = posterImageWidth
        entity.posterImageHeight = posterImageHeight

        genres.forEach { genre in
            let movieGenreEntity = MovieGenreEntity(context: context)
            movieGenreEntity.set(genre: genre, to: entity)
        }

        actors.forEach { actor in
            let movieActorEntity = MovieActorEntity(context: context)
            movieActorEntity.set(actor: actor, to: entity)
        }
    }
}
