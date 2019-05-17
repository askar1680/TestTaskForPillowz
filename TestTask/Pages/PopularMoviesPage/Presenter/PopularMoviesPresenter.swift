//
//  PopularMoviesPresenter.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PopularMoviesPresenter: PopularMoviesPresenterInput {
    
    weak var view: PopularMoviesViewInput?
    
    let networkService: NetworkService = NetworkAdapter()
    
    private var movies = [Movie]()
    
    let reloadTrigger: PublishRelay<Void> = PublishRelay()
    let nextPageTrigger: PublishRelay<Void> = PublishRelay()
    
    init(view: PopularMoviesViewInput) {
        self.view = view
    }
    
    func loadMoviesRXAt(page: Int) -> Driver<Result<TmdbResult<Movie>>> {
        
        return createMovieLoaderObservable(page: page)
            .asResult()
            .asDriver(onErrorJustReturn: Result.error(NetworkError.noConnection))
    }
    
    private func createMovieLoaderObservable(page: Int) -> Observable<TmdbResult<Movie>> {
        let networkContext = PopularMoviesNetworkContext(page: page)
        return networkService.executeAsObservable(networkContext)
    }
    
    func loadMoviesAt(page: Int) {
        let networkContext = PopularMoviesNetworkContext(page: page)
        networkService.loadDecodable(context: networkContext, type: TmdbResult<Movie>.self) { [weak self] result in
            guard let strongSelf = self else { return }
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
    
    func likeButtonClicked(at indexPath: IndexPath) {
        let id = movies[indexPath.row].id
        let movieIDForRealm = MovieIDForRealm(id: id.description)
        if FavouritesService.shared.contains(recipe: movieIDForRealm) {
            FavouritesService.shared.remove(movieIDForRealm)
        } else {
            FavouritesService.shared.add(movieIDForRealm)
        }
        view?.reloadTableView(at: indexPath)
    }
}


class PaginationNetworkModel<T1: Decodable>: NSObject {
    
    let refreshTrigger = PublishSubject<Void>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let loading = BehaviorRelay<Bool>(value: false)
    let elements = BehaviorRelay<[T1]>(value: [])
    var offset:Int = 0
    let error = PublishSubject<Swift.Error>()
    
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        let refreshRequest = loading.asObservable()
            .sample(refreshTrigger)
            .flatMap { loading -> Observable<Int> in
                if loading {
                    return Observable.empty()
                } else {
                    return Observable<Int>.create { observer in
                        observer.onNext(0)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                }
        }
        
        let nextPageRequest = loading.asObservable()
            .sample(loadNextPageTrigger)
            .flatMap { [unowned self] loading -> Observable<Int> in
                if loading {
                    return Observable.empty()
                } else {
                    return Observable<Int>.create { [unowned self] observer in
                        self.offset += 1
                        observer.onNext(self.offset)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                }
        }
        
        let request = Observable
            .of(refreshRequest, nextPageRequest)
            .merge()
            .share(replay: 1)
        
        let response = request.flatMap { offset -> Observable<[T1]> in
            self.loadData(offset: offset)
                .do(onError: { [weak self] error in
                    self?.error.onNext(error)
                }).catchError({ error -> Observable<[T1]> in
                    Observable.empty()
                })
            }.share(replay: 1)
        
        Observable
            .combineLatest(request, response, elements.asObservable()) { [unowned self] request, response, elements in
                return self.offset == 0 ? response : elements + response
            }
            .sample(response)
            .bind(to: elements)
            .disposed(by: disposeBag)
        
        Observable
            .of(request.map{_ in true},
                response.map { $0.count == 0 },
                error.map { _ in false })
            .merge()
            .bind(to: loading)
            .disposed(by: disposeBag)
    }
    
    func loadData(offset: Int) -> Observable<[T1]> {
        return Observable.empty()
    }
}
