//
//  AppError.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

protocol AppError: Error {
    var description: String { get }
}
