//
//  SpinnerFooterView.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit

class SpinnerFooterView: UIView {
    
    let spinner = UIActivityIndicatorView.init(style: .gray)
    let noConnectionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showSpinner() {
        spinner.startAnimating()
        noConnectionLabel.isHidden = true
    }
    
    func hideSpinner() {
        spinner.stopAnimating()
        noConnectionLabel.isHidden = true
    }
    
    func showNoConnectionLabel() {
        noConnectionLabel.isHidden = false
        spinner.stopAnimating()
    }
}

extension SpinnerFooterView: ViewInstallationProtocol {
    func addSubviews() {
        addSubview(spinner)
        addSubview(noConnectionLabel)
    }
    
    func setViewConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 25),
            spinner.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        noConnectionLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            noConnectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            noConnectionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        spinner.color = UIColor.darkGray
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
        
        noConnectionLabel.text = "Нет подключения к интернету"
        noConnectionLabel.isHidden = true
    }
}
