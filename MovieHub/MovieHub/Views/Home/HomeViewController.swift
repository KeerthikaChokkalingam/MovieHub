//
//  HomeViewController.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let headerView: UILabel = {
        let label = UILabel()
        label.text = "MovieHub"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let tableView = UITableView()
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchPopularMovies()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        self.title = ""
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor,constant: 60),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(MovieTableViewCell.self,
                           forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 180
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = viewModel.movies[indexPath.row]
        let isFav = FavoriteManager.shared.isFavorite(id: movie.id)
        
        cell.configure(with: movie, isFavorite: isFav)
        
        cell.onFavoriteTapped = { [weak self] in
            if FavoriteManager.shared.isFavorite(id: movie.id) {
                FavoriteManager.shared.removeFavorite(id: movie.id)
            } else {
                FavoriteManager.shared.addFavorite(movie: movie)
            }
            
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        viewModel.fetchRuntime(for: movie.id) { runtime in
            DispatchQueue.main.async {
                cell.updateDuration(runtime)
            }
        }
        
        return cell
    }
    
}
