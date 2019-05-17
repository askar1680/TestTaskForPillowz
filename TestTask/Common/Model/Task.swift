//
//  Task.swift
//  TestTask
//
//  Created by Аскар on 5/16/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation
import RxSwift

enum Task<T> {
    
    case loading
    case completed(Result<T>)
    
    init(_ value: T) {
        self = .completed(Result(value))
    }
    
    init(_ error: Error) {
        self = .completed(Result(error))
    }
}

extension Task {
    
    var isLoading: Bool {
        guard case .loading = self else { return false }
        return true
    }
    
    var result: Result<T>? {
        guard case let .completed(result) = self else { return nil }
        return result
    }
}

extension ObservableType {
    func asTask() -> RxSwift.Observable<Task<Self.Element>> {
        return asResult().map { Task.completed($0) }
    }
}
