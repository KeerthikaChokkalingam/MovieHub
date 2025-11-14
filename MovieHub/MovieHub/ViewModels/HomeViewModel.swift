//
//  HomeViewModel.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//

import Foundation

final class HomeViewModel {

    private let service = MovieService()

    var movies: [Movie] = []
    var onUpdate: (() -> Void)?

    func fetchPopularMovies() {
        service.fetchPopularMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.movies = data.results
                    self?.onUpdate?()
                case .failure(let error):
                    print("Error:", error)
                }
            }
        }
    }
    
    func fetchRuntime(for movieID: Int, completion: @escaping (Int?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(APIConstants.apiKey)"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }

            let details = try? JSONDecoder().decode(MovieDetail.self, from: data)
            completion(details?.runtime)
        }.resume()
    }

}
