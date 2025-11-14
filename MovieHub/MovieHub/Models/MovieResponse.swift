//
//  MovieResponse.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}
