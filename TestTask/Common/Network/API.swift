//
//  API.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation

struct TmdbAPI {
    static let baseURLString = "https://api.themoviedb.org/3/"
    static let apiKey = "add142bca4430d8dc55de845bad145fb"
    static let language = "ru"
    static let posterPath = "https://image.tmdb.org/t/p/w342"
    static let backdropPath = "https://image.tmdb.org/t/p/w780"
}

protocol URLConvertible {
    func url() -> URL?
}

enum TmdbEndPoint {
    
    case getPopularMovies
    case getMovieDetail(id: Int)
    case searchMovie
    
    private func getRoute() -> String {
        switch self {
        case .getPopularMovies:
            return "movie/popular"
        case .getMovieDetail(let id):
            return "movie/" + id.description
        case .searchMovie:
            return "search/movie"
        }
    }
    
    func getRouteWithBaseURL() -> String {
        return TmdbAPI.baseURLString + getRoute()
    }
}

extension TmdbEndPoint: URLConvertible{
    func url() -> URL? {
        return URL(string: TmdbAPI.baseURLString + getRoute())
    }
}
