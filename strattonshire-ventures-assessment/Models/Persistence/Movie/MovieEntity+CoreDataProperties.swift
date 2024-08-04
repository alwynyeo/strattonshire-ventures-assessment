//
//  MovieEntity+CoreDataProperties.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/4/24.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var awards: String?
    @NSManaged public var boxOffice: String?
    @NSManaged public var country: String?
    @NSManaged public var director: String?
    @NSManaged public var id: Int64
    @NSManaged public var language: String?
    @NSManaged public var plot: String?
    @NSManaged public var poster: String?
    @NSManaged public var production: String?
    @NSManaged public var rating: Float
    @NSManaged public var runtime: Int64
    @NSManaged public var title: String?
    @NSManaged public var trailer: String?
    @NSManaged public var website: String?
    @NSManaged public var year: Int64
    @NSManaged public var posterImageWidth: Float
    @NSManaged public var posterImageHeight: Float
    @NSManaged public var actorList: NSSet?
    @NSManaged public var genreList: NSSet?

}

// MARK: Generated accessors for actorList
extension MovieEntity {

    @objc(addActorListObject:)
    @NSManaged public func addToActorList(_ value: MovieActorEntity)

    @objc(removeActorListObject:)
    @NSManaged public func removeFromActorList(_ value: MovieActorEntity)

    @objc(addActorList:)
    @NSManaged public func addToActorList(_ values: NSSet)

    @objc(removeActorList:)
    @NSManaged public func removeFromActorList(_ values: NSSet)

}

// MARK: Generated accessors for genreList
extension MovieEntity {

    @objc(addGenreListObject:)
    @NSManaged public func addToGenreList(_ value: MovieGenreEntity)

    @objc(removeGenreListObject:)
    @NSManaged public func removeFromGenreList(_ value: MovieGenreEntity)

    @objc(addGenreList:)
    @NSManaged public func addToGenreList(_ values: NSSet)

    @objc(removeGenreList:)
    @NSManaged public func removeFromGenreList(_ values: NSSet)

}

extension MovieEntity : Identifiable {

}
