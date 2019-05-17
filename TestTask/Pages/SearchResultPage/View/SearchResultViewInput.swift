//
//  SearchResultViewInput.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

protocol SearchResultViewInput: BaseViewInputProtocol {
    func set(movies: [Movie])
    func set(maxResult: Int)
    func handledError()
}
