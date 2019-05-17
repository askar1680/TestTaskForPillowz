//
//  UITableView+ReusableCell.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView{
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UITableView{
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Can not dequeue \(T.self) with identifier \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}
