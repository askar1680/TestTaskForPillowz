//
//  BaseViewInputProtocol.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation

typealias VoidCompletion = (() -> Void)

protocol BaseViewInputProtocol: class {
    
    func showActivityIndicator()
    func hideActivityIndicator()
    
    func showError(message: String, completion: VoidCompletion?)
}

extension BaseViewInputProtocol {
    func showError(message: String, completion: VoidCompletion? = nil) {
        showError(message: message, completion: completion)
    }
}
