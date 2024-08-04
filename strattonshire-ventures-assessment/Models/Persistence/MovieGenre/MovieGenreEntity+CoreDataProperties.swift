//
//  MovieGenreEntity+CoreDataProperties.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//
//

import Foundation
import CoreData


extension MovieGenreEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieGenreEntity> {
        return NSFetchRequest<MovieGenreEntity>(entityName: "MovieGenreEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var movie: MovieEntity?

}

extension MovieGenreEntity : Identifiable {

}
