//
//  Result.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
    
    public init(_ value: T) {
        self = .success(value)
    }
    
    public init(_ error: Error) {
        self = .error(error)
    }
    
    public var value: T? {
        switch self {
        case .success(let value):
            return value
        case .error:
            return nil
        }
    }
}
