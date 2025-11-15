//
//  MovieDetailViewModel.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//


import Foundation
import UIKit

final class MovieDetailViewModel {

    var movieDetail: MovieDetail?
    var trailerKey: String?
    var cast: [CastMember] = []
    
    var onUpdate: (() -> Void)?
    
    func fetchDetails(movieId: Int) {
        
        let detailUrl = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(APIConstants.apiKey)&append_to_response=credits"
        guard let url = URL(string: detailUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else { return }
            
            do {
                let detail = try JSONDecoder().decode(MovieDetail.self, from: data)
                self.movieDetail = detail
                
                
                self.cast = detail.credits?.cast ?? []
                
                DispatchQueue.main.async {
                    self.onUpdate?()
                }
            } catch {
                print("Detail decode error:", error)
            }
        }.resume()
        
        // Fetch trailers
        fetchTrailers(movieId: movieId)
    }
    
    private func fetchTrailers(movieId: Int) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(APIConstants.apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else { return }
            
            do {
                let trailerResponse = try JSONDecoder().decode(TrailerResponse.self, from: data)
               
                self.trailerKey = trailerResponse.results.first(where: { $0.type == "Trailer" && $0.site == "YouTube" })?.key
                
                DispatchQueue.main.async {
                    self.onUpdate?()
                }
            } catch {
                print("Trailer decode error:", error)
            }
        }.resume()
    }
}
