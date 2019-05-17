//
//  NetworkAdapter.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Alamofire
import RxSwift

class NetworkAdapter: NetworkService {
    
    func load(context: NetworkContext, completion: @escaping (NetworkResponse) -> Void) {
        guard let url = context.url else {
            completion(FailureNetworkResponse(networkError: .unknown))
            return
        }
        print("URL = ", url.absoluteString)
        Alamofire.request(
            url,
            method: context.httpMethod(),
            parameters: context.getParameters(),
            encoding: JSONEncoding.default
        ).responseJSON { [weak self] response in
            self?.log(data: response.data)
            if response.error != nil {
                print(response.error?.localizedDescription as Any)
                completion(FailureNetworkResponse(networkError: .unknown))
                return
            }
            guard let data = response.data else {
                completion(FailureNetworkResponse(networkError: .dataLoad))
                return
            }
            completion(SucceessNetworkResponse(data: data))
            return
        }
    }
    
    func loadDecodable<T: Decodable>(context: NetworkContext, type: T.Type, completion: @escaping (Result<T>) -> Void) {
        load(context: context) { networkResponse in
            if let error = networkResponse.networkError {
                completion(.error(error))
                return
            }
            guard let result: T = networkResponse.decode() else {
                completion(.error(NetworkError.dataLoad))
                return
            }
            completion(.success(result))
        }
    }
    
    func executeAsObservable<T: Decodable>(_ context: NetworkContext) -> Observable<T> {
        return Observable.create { [weak self] (observer) -> Disposable in
            let completion: (Result<T>) -> Void = { result in
                switch result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .error(let error):
                    observer.onError(error)
                }
            }
            do {
                self?.load(context: context, completion: { networkResponse in
                    if let error = networkResponse.networkError {
                        completion(Result.error(error))
                        return
                    }
                    if let result: T = networkResponse.decode() {
                        completion(Result.success(result))
                    } else {
                        completion(Result.error(NetworkError.dataLoad))
                    }
                })
            }
            return Disposables.create()
        }.observeOn(MainScheduler.instance)
    }
    
    private func log(data: Data?) {
        print("--------Data-----------")
        guard let data = data else {
            print("Data is nil")
            return
        }
        print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) as Any)
        print("-------END---------")
    }
}
