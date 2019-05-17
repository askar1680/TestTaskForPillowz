//
//  SearchMovieNetworkContext.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

class SearchMovieNetworkContext: NetworkContext {
    var parameters = [String: String]()
    
    var route: TmdbEndPoint { return .searchMovie }
    var method: NetworkMethod { return .get }
    
    init(query: String, page: Int) {
        parameters["query"] = query
        parameters["page"] = page.description
        setApiKey()
        setLanguage()
    }
    
}
