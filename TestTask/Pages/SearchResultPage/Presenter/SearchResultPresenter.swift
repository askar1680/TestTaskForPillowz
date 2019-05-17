//
//  SearchResultPresenter.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultPresenter: SearchResultPresenterInput {
    
    weak var view: SearchResultViewInput?
    
    let networkService: NetworkService = NetworkAdapter()
    
    let textSearchTrigger: PublishRelay<String> = PublishRelay()
    let nextPageTrigger: PublishRelay<Void> = PublishRelay()
    
    private var movies = [Movie]()
    
    init(view: SearchResultViewInput) {
        self.view = view
    }
    
    func searchMovie(query: String, page: Int) {
        let networkContext = SearchMovieNetworkContext(query: query, page: page)
        networkService.loadDecodable(context: networkContext, type: TmdbResult<Movie>.self) { [weak self] result in
            guard let strongSelf = self else { return }
            if page == 1 { strongSelf.view?.hideActivityIndicator() }
            switch result {
            case .success(let movieResult):
                strongSelf.movies += movieResult.results
                strongSelf.view?.set(movies: strongSelf.movies)
                strongSelf.view?.set(maxResult: movieResult.total_results ?? -1)
            case .error(let error):
                strongSelf.view?.showError(message: error.localizedDescription)
                strongSelf.view?.handledError()
            }
        }
    }
}
