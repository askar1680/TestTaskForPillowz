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

class PopularPaginationModel {
    
    let refreshTrigger = PublishSubject<Void>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let loading = BehaviorRelay<Bool>(value: false)
    let elements = BehaviorRelay<[Movie]>(value: [])
    var offset: Int = 1
    let error = PublishSubject<Swift.Error>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        let refreshRequest = loading.asObservable()
            .sample(refreshTrigger)
            .flatMap { loading -> Observable<Int> in
                if loading {
                    return Observable.empty()
                } else {
                    return Observable<Int>.create { observer in
                        observer.onNext(1)
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
        
        let response = request.flatMap { offset -> Observable<[Movie]> in
            self.loadData(offset: offset)
                .do(onError: { [weak self] error in
                    self?.error.onNext(error)
                }).catchError({ error -> Observable<[Movie]> in
                    Observable.empty()
                })
            }.share(replay: 1)
        
        Observable
            .combineLatest(request, response, elements.asObservable()) { [unowned self] request, response, elements in
                return self.offset == 1 ? response : elements + response
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
    
    let networkService: NetworkService = NetworkAdapter()
    
    func loadData(offset: Int) -> Observable<[Movie]> {
        let networkContext = PopularMoviesNetworkContext(page: offset)
        return networkService.executeAsObservable(networkContext, type: TmdbResult<Movie>.self)
            .map { $0.results }
    }
}
