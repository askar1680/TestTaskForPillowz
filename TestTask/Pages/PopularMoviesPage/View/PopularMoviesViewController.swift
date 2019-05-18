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
    
    let paginationModel = PopularPaginationModel()
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
        
        paginationModel.elements.asObservable().bind(
            to: tableView.rx.items(
                cellIdentifier: MovieTVCell.defaultReuseIdentifier,
                cellType: MovieTVCell.self
            )
        ) { row, movie, cell in
            cell.set(movie: movie)
            cell.indexPath = IndexPath(row: row, section: 0)
            cell.set(isMovieLiked: movie.isLiked())
            cell.likeClickDelegate = self
        }.disposed(by: disposeBag)
        
        rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .map { _ in () }
            .bind(to: paginationModel.refreshTrigger)
            .disposed(by: disposeBag)
        
        tableView.rx_reachedBottom
            .map{ _ in ()}
            .bind(to: paginationModel.loadNextPageTrigger)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind() { [unowned self] indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Movie.self).subscribe(onNext: { [unowned self] movie in
            self.routeToDetailPage(movie: movie)
        }).disposed(by: disposeBag)
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
//        presenter.likeButtonClicked(at: indexPath)
    }
}

extension PopularMoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        routeToSearchPage(query: searchText)
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
        tableView.register(MovieTVCell.self)
    }
}
