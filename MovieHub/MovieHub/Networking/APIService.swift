//
//  APIService.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//


import Foundation

final class APIService {

    static let shared = APIService()   // Singleton

    private init() {}

    // MARK: - Search Movies
    func searchMovies(query: String, completion: @escaping ([Movie]) -> Void) {

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let urlString =
        "\(APIConstants.baseURL)/search/movie?api_key=\(APIConstants.apiKey)&query=\(encodedQuery)"

        guard let url = URL(string: urlString) else {
            print("❌ Invalid Search URL")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                print("❌ Search API Error:", error.localizedDescription)
                completion([])
                return
            }

            guard let data else {
                completion([])
                return
            }

            let decoded = try? JSONDecoder().decode(MovieResponse.self, from: data)
            completion(decoded?.results ?? [])

        }.resume()
    }
}
