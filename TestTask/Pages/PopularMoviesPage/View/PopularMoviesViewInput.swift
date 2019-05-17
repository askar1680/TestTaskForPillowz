//
//  PopularMoviesViewInput.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation

protocol PopularMoviesViewInput: BaseViewInputProtocol {
    func set(movies: [Movie])
    func set(maxResult: Int)
    func handledError()
    func reloadTableView(at indexPath: IndexPath)
}
