//
//  PopularMoviesNetworkContext.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation

class PopularMoviesNetworkContext: NetworkContext {
    
    var route: TmdbEndPoint { return .getPopularMovies }
    var method: NetworkMethod { return .get }
    var parameters = [String: String]()
    
    init(page: Int) {
        parameters["page"] = page.description
        setApiKey()
        setLanguage()
    }
}
