//
//  MovieDetailNetworkContext.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation

class MovieDetailNetworkContext: NetworkContext {
    
    let route: TmdbEndPoint
    var method: NetworkMethod { return .get }
    var parameters = [String: String]()
    
    init(id: Int) {
        route = .getMovieDetail(id: id)
        setApiKey()
        setLanguage()
    }
}
