//
//  FavoriteManager.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//

import CoreData
import UIKit

final class FavoriteManager {

    static let shared = FavoriteManager()
    private init() {}

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func isFavorite(id: Int) -> Bool {
        let request = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)

        return (try? context.count(for: request)) ?? 0 > 0
    }

    func addFavorite(movie: Movie) {
        let fav = FavoriteMovie(context: context)
        fav.id = Int64(movie.id)
        fav.title = movie.title
        save()
    }

    func removeFavorite(id: Int) {
        let request = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)

        if let results = try? context.fetch(request), let obj = results.first {
            context.delete(obj)
            save()
        }
    }

    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
