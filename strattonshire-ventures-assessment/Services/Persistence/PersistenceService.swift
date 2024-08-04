//
//  PersistenceService.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

import UIKit
import CoreData

final class PersistenceService {
    // MARK: - Declarations

    static let shared = PersistenceService()

    private let context: NSManagedObjectContext

    // MARK: - Object Lifecycle

    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        self.context = context
    }

    // MARK: - Public Methods

    func persist(movies: [Movie]) {
        performBatchDelete { [weak self] completed in
            guard let self else { return }
            guard completed else {
                print("Error: happened under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }
            save(for: movies)
        }
    }

    func fetchAllMovies() -> [Movie] {
        let entities = getMovieEntities()
        let movies = entities.map { $0.mapToMovie() }
        return movies
    }

    private func saveContext() {
        do {
            try context.save()
        } catch let error {
            print("Error: \(error.localizedDescription). Happened under \(#function) at line \(#line) in \(#fileID) file.")
        }
    }
}

private extension PersistenceService {
    func getMovieEntities() -> [MovieEntity] {
        let request = MovieEntity.getFetchedRequest()

        do {
            let entities = try context.fetch(request)
            return entities
        } catch {
            print("Error: \(error.localizedDescription). Happened under \(#function) at line \(#line) in \(#fileID) file.")
            return []
        }
    }

    func saveMovieEntity(movie: Movie) {
        let movieEntity = MovieEntity(context: context)
        movieEntity.set(
            movie: movie,
            context: context
        )
    }

    func save(for movies: [Movie]) {
        movies.enumerated().forEach {
            let movie: Movie = $0.element
            saveMovieEntity(movie: movie)
        }

        saveContext()
    }

    func performBatchDelete(completion: (_ completed: Bool) -> Void) {
        let result: Bool

        defer {
            completion(result)
        }

        let movieEntityFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        let movieGenreEntityFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieGenreEntity")
        let movieActorEntityFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieActorEntity")

        let movieEntityDeleteRequest = NSBatchDeleteRequest(fetchRequest: movieEntityFetchRequest)
        let movieGenreEntityDeleteRequest = NSBatchDeleteRequest(fetchRequest: movieGenreEntityFetchRequest)
        let movieActorEntityDeleteRequest = NSBatchDeleteRequest(fetchRequest: movieActorEntityFetchRequest)

        do {
            // Perform the batch delete & Merge the delete changes into the managed object context
            try context.executeAndMergeChanges(using: movieEntityDeleteRequest)
            try context.executeAndMergeChanges(using: movieGenreEntityDeleteRequest)
            try context.executeAndMergeChanges(using: movieActorEntityDeleteRequest)
            result = true
        } catch let error {
            print("Error: \(error.localizedDescription) happened while deleting batch requests under \(#function) at line \(#line) in \(#fileID) file.")
            result = false
        }
    }
}
