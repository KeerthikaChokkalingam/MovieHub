//
//  MovieDetail.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//

import UIKit

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let runtime: Int?
    let genres: [Genre]
    let voteAverage: Double
    let spokenLanguages: [Language]?
    let adult: Bool
    let posterPath: String?
    
    let videos: VideoResponse?
    let credits: Credits?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, adult, videos, credits
        case voteAverage = "vote_average"
        case spokenLanguages = "spoken_languages"
        case posterPath = "poster_path"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct Language: Codable {
    let englishName: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
    }
}

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let key: String
    let name: String
    let type: String
}

struct Credits: Codable {
    let cast: [CastMember]
}

struct CastMember: Codable {
    let id: Int
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePath = "profile_path"
    }
}

struct TrailerResponse: Decodable {
    let results: [Trailer]
}

struct Trailer: Decodable {
    let key: String
    let name: String
    let type: String
    let site: String
}

struct MovieDetailResponse: Decodable {
    let movie: MovieDetail
    let credits: CreditsResponse?
}

struct CreditsResponse: Decodable {
    let cast: [CastMember]
}


class PaddingLabel: UILabel {
    var padding = UIEdgeInsets.zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder

        // Check cache first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, let downloaded = UIImage(data: data), error == nil else { return }

            imageCache.setObject(downloaded, forKey: urlString as NSString)

            DispatchQueue.main.async {
                self?.image = downloaded
            }
        }.resume()
    }
}
