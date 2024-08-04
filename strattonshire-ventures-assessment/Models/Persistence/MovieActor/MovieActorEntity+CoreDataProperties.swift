//
//  MovieActorEntity+CoreDataProperties.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//
//

import Foundation
import CoreData


extension MovieActorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieActorEntity> {
        return NSFetchRequest<MovieActorEntity>(entityName: "MovieActorEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var movie: MovieEntity?

}

extension MovieActorEntity : Identifiable {

}
