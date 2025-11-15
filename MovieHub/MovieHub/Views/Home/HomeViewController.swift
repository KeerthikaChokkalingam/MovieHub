//
//  HomeViewController.swift
//  MovieHub
//
//  Created by Keerthika on 14/11/25.
//

import UIKit

final class HomeViewController: UIViewController, UITextFieldDelegate {

    private let headerView: UILabel = {
        let label = UILabel()
        label.text = "MovieHub"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    
    private let searchField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search movies..."
        tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tf.layer.cornerRadius = 10
        tf.layer.masksToBounds = true
        tf.returnKeyType = .done

       
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .gray
        icon.frame = CGRect(x: 10, y: 0, width: 20, height: 20)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        container.addSubview(icon)

        tf.leftView = container
        tf.leftViewMode = .always

        return tf
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

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        
        view.addSubview(searchField)
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        searchField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 40),

            searchField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchField.heightAnchor.constraint(equalToConstant: 40)
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
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Keyboard return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  
        return true
    }
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if text.isEmpty {
            viewModel.fetchPopularMovies()
        } else {
            viewModel.searchMovies(query: text)
        }
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

        viewModel.fetchRuntime(for: movie.id) { runtime in
            DispatchQueue.main.async {
                cell.updateDuration(runtime)
            }
        }
        
        cell.onFavoriteTapped = {
            if FavoriteManager.shared.isFavorite(id: movie.id) {
                FavoriteManager.shared.removeFavorite(id: movie.id)
            } else {
                FavoriteManager.shared.addFavorite(movie: movie)
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        let detailVC = MovieDetailViewController(movieId: movie.id)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
