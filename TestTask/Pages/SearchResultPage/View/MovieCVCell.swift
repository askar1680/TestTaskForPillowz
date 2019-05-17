//
//  MovieCVCell.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit

class MovieCVCell: UICollectionViewCell, ReusableView {
    
    let movieImageView = AsyncImageView()
    let verticalStackView = UIStackView()
    let nameLabel = UILabel()
    let originalNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(movie: Movie) {
        nameLabel.text = movie.title
        originalNameLabel.text = movie.getOriginalNameWithReleaseDate()
        if let posterPathUrlString = movie.getPosterPathUrlString() {
            movieImageView.downloadImageFrom(urlString: posterPathUrlString)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
    }
}

extension MovieCVCell: ViewInstallationProtocol {
    func addSubviews() {
        addSubview(movieImageView)
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(originalNameLabel)
    }
    
    func setViewConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            movieImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            movieImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 3/2)
        ]
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            verticalStackView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 0),
            verticalStackView.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        
        verticalStackView.distribution = .fill
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 4
        
        nameLabel.textColor = .black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        originalNameLabel.textColor = .black
        originalNameLabel.font = UIFont.systemFont(ofSize: 15)
    }
}
