//
//  MovieDetailViewController.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//

import UIKit
import AVKit

final class MovieDetailViewController: UIViewController {
    
    let movieId: Int
    private let viewModel = MovieDetailViewModel()
    
    private let bannerImage = UIImageView()
    
    private let playButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        btn.tintColor = .white
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        return btn
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 20)
        l.textColor = .black
        l.numberOfLines = 0
        return l
    }()
    
    private let favButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .systemRed
        return btn
    }()
    
    private let ratingLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .darkGray
        return l
    }()
    
    private let durationLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .darkGray
        return l
    }()
    
    private let languagesLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .darkGray
        l.numberOfLines = 0
        return l
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 16)
        l.textColor = .black
        l.text = "Plot: "
        return l
    }()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.numberOfLines = 0
        l.textColor = .darkGray
        return l
    }()
    
    private let castLabel: UILabel = {
        let l = UILabel()
        l.text = "Cast"
        l.font = .boldSystemFont(ofSize: 18)
        return l
    }()
    
    private let genreLabel: UILabel = {
        let l = UILabel()
        l.text = "Genres"
        l.font = .boldSystemFont(ofSize: 16)
        return l
    }()

    private let genreScroll = UIScrollView()
    private let genreStack = UIStackView()

    
    private let castScroll = UIScrollView()
    private let castStack = UIStackView()
    
    // MARK: - Init
    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchDetails(movieId: movieId)
    }
    
    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            self?.updateUI()
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Banner
        bannerImage.contentMode = .scaleAspectFill
        bannerImage.clipsToBounds = true
        view.addSubview(bannerImage)
        bannerImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bannerImage.topAnchor.constraint(equalTo: view.topAnchor),
            bannerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerImage.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: bannerImage.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: bannerImage.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 80),
            playButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        playButton.addTarget(self, action: #selector(playTrailer), for: .touchUpInside)
        
        // ScrollView + ContentView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: bannerImage.bottomAnchor, constant: -40),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 35
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Title + Fav Button
        contentView.addSubview(titleLabel)
        contentView.addSubview(favButton)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        favButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: favButton.leadingAnchor, constant: -10),
            
            favButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            favButton.widthAnchor.constraint(equalToConstant: 30),
            favButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        favButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        // Rating
        contentView.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        ])
        
        // Duration
        contentView.addSubview(durationLabel)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            durationLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            durationLabel.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
        ])
        
        // Languages
        contentView.addSubview(languagesLabel)
        languagesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            languagesLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 4),
            languagesLabel.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            languagesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        // Genre Label
        contentView.addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: languagesLabel.bottomAnchor, constant: 15),
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])

        // Genre Scroll + Stack
        genreStack.axis = .horizontal
        genreStack.spacing = 10
        genreScroll.addSubview(genreStack)
        genreScroll.showsHorizontalScrollIndicator = false

        contentView.addSubview(genreScroll)
        genreScroll.translatesAutoresizingMaskIntoConstraints = false
        genreStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            genreScroll.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 10),
            genreScroll.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genreScroll.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            genreScroll.heightAnchor.constraint(equalToConstant: 40),

            genreStack.topAnchor.constraint(equalTo: genreScroll.topAnchor),
            genreStack.bottomAnchor.constraint(equalTo: genreScroll.bottomAnchor),
            genreStack.leadingAnchor.constraint(equalTo: genreScroll.leadingAnchor, constant: 20),
            genreStack.trailingAnchor.constraint(equalTo: genreScroll.trailingAnchor, constant: -20),
        ])

        // Description Title + Description
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(descriptionLabel)
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: genreStack.bottomAnchor, constant: 15),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
        
        // Cast Scroll
        castStack.axis = .horizontal
        castStack.spacing = 15
        castScroll.addSubview(castStack)
        castScroll.showsHorizontalScrollIndicator = false
        
        contentView.addSubview(castLabel)
        contentView.addSubview(castScroll)
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        castScroll.translatesAutoresizingMaskIntoConstraints = false
        castStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            castLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25),
            castLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            castScroll.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 10),
            castScroll.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            castScroll.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            castScroll.heightAnchor.constraint(equalToConstant: 130),
            castScroll.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            castStack.topAnchor.constraint(equalTo: castScroll.topAnchor),
            castStack.bottomAnchor.constraint(equalTo: castScroll.bottomAnchor),
            castStack.leadingAnchor.constraint(equalTo: castScroll.leadingAnchor, constant: 20),
            castStack.trailingAnchor.constraint(equalTo: castScroll.trailingAnchor, constant: -20),
            castStack.heightAnchor.constraint(equalTo: castScroll.heightAnchor)
        ])
    }
    
    // MARK: - Update UI
    private func updateUI() {
        guard let detail = viewModel.movieDetail else { return }
        
        // Banner
        if let posterPath = detail.posterPath, !posterPath.isEmpty {
            bannerImage.loadImage(from: "https://image.tmdb.org/t/p/w500\(posterPath)", placeholder: UIImage(named: "placeholder"))
        } else {
            bannerImage.image = UIImage(named: "placeholder")
        }

        // Title & Rating
        titleLabel.text = detail.title
        ratingLabel.text = "⭐ \(String(format: "%.1f", detail.voteAverage))/10 IMDb"
        
        // Duration
        if let runtime = detail.runtime {
            durationLabel.text = "⏱ \(runtime) min"
        } else {
            durationLabel.text = ""
        }
        
        // Languages
        if let langs = detail.spokenLanguages, !langs.isEmpty {
            languagesLabel.text = "Languages: " + langs.map { $0.englishName }.joined(separator: ", ")
        } else {
            languagesLabel.text = ""
        }
        
        // Genres
        genreStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if let genres = viewModel.movieDetail?.genres {
            for g in genres {
                let chip = createGenreChip(title: g.name)
                genreStack.addArrangedSubview(chip)
            }
        }

        // Description
        descriptionLabel.text = detail.overview
        
        // Cast
        castStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for c in viewModel.cast.prefix(10) {
            let item = createCastItem(name: c.name, image: c.profilePath)
            castStack.addArrangedSubview(item)
        }
    }
    
    // MARK: - Actions
    @objc private func playTrailer() {
        guard let key = viewModel.trailerKey else { return }
        let url = URL(string: "https://www.youtube.com/watch?v=\(key)")!
        let vc = AVPlayerViewController()
        vc.player = AVPlayer(url: url)
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    private func createCastItem(name: String, image: String?) -> UIView {
            let view = UIView()
            view.widthAnchor.constraint(equalToConstant: 80).isActive = true
    
            let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.layer.cornerRadius = 8
            img.clipsToBounds = true
            img.loadImage(from: String("https://image.tmdb.org/t/p/w200\(image ?? "")"))
    
            let lbl = UILabel()
            lbl.font = .systemFont(ofSize: 12, weight: .medium)
            lbl.textAlignment = .center
            lbl.numberOfLines = 2
            lbl.text = name
    
            view.addSubview(img)
            view.addSubview(lbl)
    
            img.translatesAutoresizingMaskIntoConstraints = false
            lbl.translatesAutoresizingMaskIntoConstraints = false
    
            NSLayoutConstraint.activate([
                img.topAnchor.constraint(equalTo: view.topAnchor),
                img.widthAnchor.constraint(equalToConstant: 80),
                img.heightAnchor.constraint(equalToConstant: 80),
    
                lbl.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 5),
                lbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                lbl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    
            return view
        }
    
    @objc private func toggleFavorite() {
        favButton.isSelected.toggle()
        let imageName = favButton.isSelected ? "heart.fill" : "heart"
        favButton.setImage(UIImage(systemName: imageName), for: .normal)
        // TODO: save favorite state
    }
    
    private func createGenreChip(title: String) -> UIView {
        let label = PaddingLabel()
        label.text = title
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return label
    }

}

