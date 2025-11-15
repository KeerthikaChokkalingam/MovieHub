//
//  FavoriteManager.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//

//import CoreData
//import UIKit
//
//final class FavoriteManager {
//
//    static let shared = FavoriteManager()
//    private init() {}
//
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    func isFavorite(id: Int) -> Bool {
//        let request = FavoriteMovie.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %d", id)
//
//        return (try? context.count(for: request)) ?? 0 > 0
//    }
//
//    func addFavorite(movie: Movie) {
//        let fav = FavoriteMovie(context: context)
//        fav.id = Int64(movie.id)
//        fav.title = movie.title
//        save()
//    }
//
//    func removeFavorite(id: Int) {
//        let request = FavoriteMovie.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %d", id)
//
//        if let results = try? context.fetch(request), let obj = results.first {
//            context.delete(obj)
//            save()
//        }
//    }
//
//    func save() {
//        if context.hasChanges {
//            try? context.save()
//        }
//    }
//}


import CoreData
import UIKit

final class FavoriteManager {

    static let shared = FavoriteManager()
    private init() {}

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Check if favorite
    func isFavorite(id: Int) -> Bool {
        let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking favorite: \(error)")
            return false
        }
    }

    // MARK: - Add favorite
    func addFavorite(movie: Movie?) {
        guard let movie = movie, !isFavorite(id: movie.id) else { return }
        let fav = FavoriteMovie(context: context)
        fav.id = Int64(movie.id)
        fav.title = movie.title
        saveContext()
    }

    // MARK: - Remove favorite
    func removeFavorite(id: Int) {
        let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
                saveContext()
            }
        } catch {
            print("Error removing favorite: \(error)")
        }
    }

    // MARK: - Save context
    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
