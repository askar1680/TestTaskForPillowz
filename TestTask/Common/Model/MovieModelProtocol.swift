//
//  MovieModelProtocol.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit

protocol MovieModelProtocol {
    var id: Int { get }
    var vote_average: Double? { get }
    var title: String? { get }
    var poster_path: String? { get }
    var original_title: String? { get }
    var backdrop_path: String? { get }
    var overview: String? { get }
    var release_date: String? { get }
    var popularity: Double? { get }
}

extension MovieModelProtocol {
    func getPosterPathUrlString() -> String? {
        if let posterPath = poster_path {
            return TmdbAPI.posterPath + posterPath
        }
        return nil
    }
    
    func getOriginalNameWithReleaseDate() -> String {
        if release_date?.count ?? 0 >= 4 {
            return "\(original_title ?? "") (\(release_date?[0..<4] ?? ""))"
        }
        else{
            return original_title ?? ""
        }
    }
    
    func getVoteAverageWithPopularity() -> NSAttributedString{
        let voteAverageAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let voteAverageString = NSMutableAttributedString(string: "\(vote_average ?? 0.0)", attributes: voteAverageAttributes)
        
        let popularityAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.gray]
        let popularityString = NSMutableAttributedString(string: "  \(popularity ?? 0.0)", attributes: popularityAttributes)
        
        voteAverageString.append(popularityString)
        return voteAverageString
    }
    
    func isLiked() -> Bool {
        let movieIDForRealm = MovieIDForRealm(id: id.description)
        return FavouritesService.shared.contains(recipe: movieIDForRealm)
    }
}
