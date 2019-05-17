//
//  PopularMoviesViewController.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PopularMoviesViewController: BaseViewController {
    
    lazy var presenter = PopularMoviesPresenter(view: self)
    let disposeBag = DisposeBag()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private let spinnerFooterView = SpinnerFooterView(
        frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
    )
    
    private var movies = [Movie]()
    private var page = 1
    private var maxResult = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        spinnerFooterView.showSpinner()
        
        // without rx
        // presenter.loadMoviesAt(page: page)
        
        loadMovies()
    }
    
    private func loadMovies() {
        self.showActivityIndicator()
        presenter.loadMoviesRXAt(page: page).drive(onNext: { [unowned self] result in
            self.hideActivityIndicator()
            switch result {
            case .success(let tmdbResult):
                self.movies += tmdbResult.results
                self.maxResult = tmdbResult.total_results ?? -1
                self.tableView.reloadData()
            case .error(let error):
                self.showError(message: error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
}

extension PopularMoviesViewController: PopularMoviesViewInput {
    func set(maxResult: Int) {
        self.maxResult = maxResult
    }
    
    func set(movies: [Movie]) {
        spinnerFooterView.hideSpinner()
        self.movies = movies
        self.tableView.reloadData()
    }
    
    func handledError() {
        spinnerFooterView.showNoConnectionLabel()
    }
    
    func reloadTableView(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension PopularMoviesViewController {
    func routeToDetailPage(movie: Movie) {
        let detailViewController = MovieDetailViewController(movieId: movie.id)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func routeToSearchPage(query: String) {
        let searchController = SearchResultViewController(query: query)
        navigationController?.pushViewController(searchController, animated: true)
    }
}

extension PopularMoviesViewController: LikeClickDelegate {
    func likeClicked(at indexPath: IndexPath) {
        presenter.likeButtonClicked(at: indexPath)
    }
}

extension PopularMoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        routeToSearchPage(query: searchText)
    }
}

extension PopularMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieTVCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let movie = movies[indexPath.row]
        cell.set(movie: movie)
        cell.indexPath = indexPath
        cell.set(isMovieLiked: movie.isLiked())
        cell.likeClickDelegate = self
        return cell
    }
}

extension PopularMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 && maxResult != -1 && maxResult != movies.count {
            spinnerFooterView.showSpinner()
            page += 1
            // without rx
            //presenter.loadMoviesAt(page: page)
            loadMovies()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        routeToDetailPage(movie: movies[indexPath.row])
    }
}

extension PopularMoviesViewController: ViewInstallationProtocol {
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setViewConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        title = "Popular movies"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Поиск"
        searchController.dimsBackgroundDuringPresentation = false
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = spinnerFooterView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTVCell.self)
    }
}
