//
//  SucceessNetworkResponse.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation

class SucceessNetworkResponse: NetworkResponse {
    var data: Data?
    var networkError: NetworkError? = nil
    
    init(data: Data?) {
        self.data = data
    }
}
