//
//  BaseViewControllerProtocol.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit

protocol BaseViewControllerProtocol: class {
    var activityIndicator: UIActivityIndicatorView { get }
}

extension BaseViewControllerProtocol where Self: UIViewController {
    
    func showError(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            completion?()
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        if let navigationController = navigationController {
            activityIndicator.frame = CGRect(
                x: 0,
                y: 0,
                width: navigationController.view.frame.width,
                height: navigationController.view.frame.height
            )
            navigationController.view.addSubview(activityIndicator)
        } else {
            activityIndicator.frame = CGRect(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: view.frame.height
            )
            view.addSubview(activityIndicator)
        }
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
