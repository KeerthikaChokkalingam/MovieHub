//
//  MovieTableViewCell.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    
    static let identifier = "MovieTableViewCell"
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let durationLabel = UILabel()
    private let favoriteButton = UIButton()
    
    
    var onFavoriteTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with movie: Movie, isFavorite: Bool) {
        titleLabel.text = movie.title
        titleLabel.numberOfLines = 2
        ratingLabel.text = "⭐ \(movie.vote_average)/10 IMDb"
        
        durationLabel.text = ""
        updateFavoriteButton(isFavorite)
        updateDuration(movie.runtime)
        
        if let posterPath = movie.poster_path,
           let url = URL(string: APIConstants.imageBaseURL + posterPath) {
            loadImage(from: url, into: posterImageView)
        }
    }
    
    func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    func updateDuration(_ runtime: Int?) {
        guard let runtime = runtime else {
            durationLabel.text = "⏱ --"
            return
        }
        durationLabel.text = "⏱ \(runtime / 60)h \(runtime % 60)m"
    }
    
    private func updateFavoriteButton(_ isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(
            UIImage(systemName: imageName),
            for: .normal
        )
        favoriteButton.tintColor = isFavorite ? .systemRed : .gray
    }
    
    @objc private func favoriteTapped() {
        onFavoriteTapped?()
    }
    func configure(with movie: Movie) {
        let isFav = FavoriteManager.shared.isFavorite(id: movie.id)
        updateFavoriteButton(isFav)
    }

    private func setupUI() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        ratingLabel.font = .systemFont(ofSize: 14)
        durationLabel.font = .systemFont(ofSize: 14)
        ratingLabel.textColor = .gray
        durationLabel.textColor = .gray
        
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        favoriteButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(favoriteButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            posterImageView.widthAnchor.constraint(equalToConstant: 110),
            
           
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            durationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            durationLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 12)
        ])
    }
}
