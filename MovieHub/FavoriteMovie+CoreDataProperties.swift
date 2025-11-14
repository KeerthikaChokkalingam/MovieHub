//
//  FavoriteMovie+CoreDataProperties.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//
//

public import Foundation
public import CoreData


public typealias FavoriteMovieCoreDataPropertiesSet = NSSet

extension FavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var rating: Double

}

extension FavoriteMovie : Identifiable {

}
