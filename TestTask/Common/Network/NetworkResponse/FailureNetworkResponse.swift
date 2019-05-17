//
//  FailureNetworkResponse.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation

class FailureNetworkResponse: NetworkResponse {
    var data: Data? { return nil }
    let networkError: NetworkError?
    
    init(networkError: NetworkError) {
        self.networkError = networkError
    }
}
