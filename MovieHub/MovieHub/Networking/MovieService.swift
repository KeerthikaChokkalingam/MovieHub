//
//  MovieService.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//

import Foundation

final class MovieService {

    func fetchPopularMovies(completion: @escaping(Result<MovieResponse, Error>) -> Void) {
        
        guard let url = URL(string:
            "\(APIConstants.baseURL)/movie/popular?api_key=\(APIConstants.apiKey)"
        ) else { return }
        
        APIClient.shared.request(url, completion: completion)
    }
}
