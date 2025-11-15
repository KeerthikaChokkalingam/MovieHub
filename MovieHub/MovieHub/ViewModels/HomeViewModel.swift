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
    var isLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchPopularMovies() {
        guard NetworkMonitor.shared.isConnected else {
            onError?("No Internet Connection.\nPlease check your network.")
            return
        }

        isLoading?(true)
        service.fetchPopularMovies { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading?(false)
                switch result {
                case .success(let movies):
                    self?.movies = movies.results
                    self?.onUpdate?()
                case .failure(let error):
                    // Differentiate network error vs API error
                    if (error as? URLError)?.code == .notConnectedToInternet {
                        self?.onError?("No Internet Connection.\nPlease check your network.")
                    } else {
                        self?.onError?("Failed to fetch movies.\nPlease try again later.")
                    }
                    self?.movies = []
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

    
    func searchMovies(query: String) {
            APIService.shared.searchMovies(query: query) { [weak self] movies in
                DispatchQueue.main.async {
                    self?.movies = movies
                    self?.onUpdate?()
                }
            }
        }


}
