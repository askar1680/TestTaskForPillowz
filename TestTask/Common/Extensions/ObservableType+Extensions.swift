//
//  ObservableType.swift
//  TestTask
//
//  Created by Аскар on 5/16/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import RxSwift
import UIKit
import RxCocoa

extension ObservableType {
    
    func asResult() -> RxSwift.Observable<Result<Self.Element>> {
        return materialize()
            .map { (event) -> Result<Self.Element>? in
                switch event {
                case .next(let element): return Result<Self.Element>.success(element)
                case .error(let error): return Result<Self.Element>.error(error)
                case .completed: return nil
            }
        }.flatMap { Observable.from(optional: $0) }
    }
}
