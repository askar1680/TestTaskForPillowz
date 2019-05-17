//
//  MovieDetailViewController.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit
import RxSwift

class MovieDetailViewController: BaseViewController {
    
    lazy var presenter = MovieDetailPresenter(view: self, movieId: movieId)
    let disposeBag = DisposeBag()
    
    private let tableView = UITableView()
    private let headerView = MovieDetailHeaderView(
        frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 144)
    )
    
    private var movieDetail: MovieDetail?
    private let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        // without rx swift
        // presenter.loadMovieDetail(id: movie.id)
        
        loadMovieDetails()
        bindFilmDetailToTableView()
    }
    
    private func loadMovieDetails() {
        showActivityIndicator()
        presenter.filmDetail.drive(onNext: { [unowned self] result in
            self.hideActivityIndicator()
            switch result {
            case .success(let movieDetail):
                self.movieDetail = movieDetail
                self.headerView.set(movieDetail: movieDetail)
                self.tableView.reloadData()
            case .error(let error):
                self.showError(message: error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindFilmDetailToTableView() {
        presenter.filmDetail.map { [$0.value?.overview] }.asObservable().bind(
            to: tableView.rx.items(
                cellIdentifier: MovieDescriptionTVCell.defaultReuseIdentifier,
                cellType: MovieDescriptionTVCell.self
            )
        ) { row, model, cell in
            
            cell.descriptionLabel.text = model
            
        }.disposed(by: disposeBag)
    }
}

extension MovieDetailViewController: MovieDetailViewInput {
    func set(movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
        headerView.set(movieDetail: movieDetail)
        tableView.reloadData()
    }
}

extension MovieDetailViewController: ViewInstallationProtocol {
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
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MovieDescriptionTVCell.self)
        tableView.tableHeaderView = headerView
    }
}
