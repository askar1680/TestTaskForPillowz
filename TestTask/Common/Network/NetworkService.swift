//
//  NetworkService.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import RxSwift

protocol NetworkService {
    func load(context: NetworkContext, completion: @escaping (NetworkResponse) -> Void)
    func loadDecodable<T: Decodable>(context: NetworkContext, type: T.Type, completion: @escaping (Result<T>) -> Void)
    func executeAsObservable<T: Decodable>(_ context: NetworkContext) -> Observable<T>
}
