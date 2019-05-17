//
//  ViewInstallationProtocol.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

protocol ViewInstallationProtocol {
    func setupViews()
    func addSubviews()
    func setViewConstraints()
    func stylizeViews()
}

extension ViewInstallationProtocol {
    func setupViews() {
        addSubviews()
        setViewConstraints()
        stylizeViews()
    }
}
