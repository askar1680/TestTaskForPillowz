//
//  MovieResult.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

struct TmdbResult<T: Codable>: Codable {
    let results: Array<T>
    let total_results: Int?
}
