//
//  MovieDetail.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

struct MovieDetail: MovieModelProtocol, Codable {
    let id: Int
    let title: String?
    let original_title: String?
    let vote_average: Double?
    let vote_count: Int?
    let overview: String?
    let popularity: Double?
    let backdrop_path: String?
    let poster_path: String?
    
    let budget: Int?
    let genres: Array<Genre>?
    let production_companies: Array<ProductionCompany>?
    let production_countries: Array<ProductionCountry>?
    let spoken_languages: Array<SpokenLanguages>?
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    
    func getGenres() -> String? {
        if let genres = genres, !genres.isEmpty {
            return genres.compactMap { $0.name }.joined(separator: ", ")
        } else {
            return nil
        }
    }
}

struct Genre: Codable {
    var id: Int?
    var name: String?
}

struct ProductionCompany: Codable {
    var id: Int?
    var name: String?
    var logo_path: String?
    var origin_country: String?
}

struct ProductionCountry: Codable {
    var iso_3166_1: String?
    var name: String?
}

struct SpokenLanguages: Codable {
    var iso_639_1: String?
    var name: String?
}
