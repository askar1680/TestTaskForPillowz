//
//  NetworkResponse.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation

protocol NetworkResponse {
    var data: Data? { get }
    var networkError: NetworkError? { get }
}

extension NetworkResponse {
    func decode<T: Decodable>() -> T? {
        guard let data = data else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            dump(error)
            return nil
        }
    }
}
