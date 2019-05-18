//
//  MovieDetailPresenter.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailPresenter: MovieDetailPresenterInput {
    
    weak var view: MovieDetailViewInput?
    
    let networkService: NetworkService = NetworkAdapter()
    
    lazy var filmDetail = loadMovieDetailRX(id: movieId)
    
    private var movies = [Movie]()
    
    let movieId: Int
    
    init(view: MovieDetailViewInput, movieId: Int) {
        self.view = view
        self.movieId = movieId
    }
    
    func loadMovieDetail(id: Int) {
        let networkContext = MovieDetailNetworkContext(id: id)
        networkService.loadDecodable(context: networkContext, type: MovieDetail.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let movieDetail):
                strongSelf.view?.set(movieDetail: movieDetail)
            case .error(let error):
                strongSelf.view?.showError(message: error.localizedDescription)
            }
        }
    }
    
    func loadMovieDetailRX(id: Int) -> Driver<Result<MovieDetail>> {
        return self.createMovieDetailObservable(id: id)
            .asResult()
            .asDriver(onErrorJustReturn: Result.error(NetworkError.noConnection))
    }
    
    private func createMovieDetailObservable(id: Int) -> Observable<MovieDetail> {
        let networkContext = MovieDetailNetworkContext(id: id)
        return networkService.executeAsObservable(networkContext, type: MovieDetail.self)
    }
}
