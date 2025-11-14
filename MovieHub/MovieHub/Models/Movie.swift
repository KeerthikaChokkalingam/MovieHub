//
//  Movie.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let vote_average: Double
    let poster_path: String?
    let genre_ids: [Int]
    let runtime: Int?
}

struct MovieDetail: Codable {
    let runtime: Int?
}
