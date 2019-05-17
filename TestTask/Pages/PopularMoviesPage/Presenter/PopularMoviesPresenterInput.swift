//
//  PopularMoviesPresenterInput.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation

protocol PopularMoviesPresenterInput {
    func loadMoviesAt(page: Int)
    func likeButtonClicked(at indexPath: IndexPath)
}
