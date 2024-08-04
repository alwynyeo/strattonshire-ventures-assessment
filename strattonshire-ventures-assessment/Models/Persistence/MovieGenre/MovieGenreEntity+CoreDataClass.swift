//
//  MovieGenreEntity+CoreDataClass.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//
//

import CoreData

public class MovieGenreEntity: NSManagedObject {
    // MARK: - Helpers

    func mapToString() -> String {
        let entity = self
        let name = entity.name ?? ""
        return name
    }

    func set(genre: String, to parentEntity: MovieEntity) {
        let entity = self
        let name = genre

        entity.name = name

        parentEntity.addToGenreList(entity)
    }
}
