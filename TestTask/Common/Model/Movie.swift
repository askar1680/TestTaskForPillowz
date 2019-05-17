//
//  Movie.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit

struct Movie: MovieModelProtocol, Codable {
    let id: Int
    let vote_average: Double?
    let title: String?
    let poster_path: String?
    let original_title: String?
    let backdrop_path: String?
    let overview: String?
    let release_date: String?
    let popularity: Double?
}
