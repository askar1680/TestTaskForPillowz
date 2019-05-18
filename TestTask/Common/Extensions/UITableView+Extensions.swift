//
//  UITableView+Extensions.swift
//  TestTask
//
//  Created by Аскар on 5/18/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import RxSwift

extension UITableView {
    var rx_reachedBottom: Observable<Void> {
        return self.rx
            .contentOffset
            .flatMapLatest { [unowned self] (offset) -> Observable<Void> in
                let shouldTriger = offset.y + self.frame.size.height + 40 > self.contentSize.height
                return shouldTriger ? Observable.just(Void()) : Observable.empty()
        }
    }
}
