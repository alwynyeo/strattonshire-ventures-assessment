//
//  MovieActorEntity+CoreDataClass.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//
//

import CoreData

public class MovieActorEntity: NSManagedObject {
    // MARK: - Helpers

    func mapToString() -> String {
        let entity = self
        let name = entity.name ?? ""
        return name
    }

    func set(actor: String, to parentEntity: MovieEntity) {
        let entity = self
        let name = actor

        entity.name = name

        parentEntity.addToActorList(entity)
    }
}
