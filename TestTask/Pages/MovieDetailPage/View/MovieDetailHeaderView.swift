//
//  MovieDetailHeaderView.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit

class MovieDetailHeaderView: UIView {
    
    let movieImageView = AsyncImageView()
    let verticalStackView = UIStackView()
    let nameLabel = UILabel()
    let originalNameLabel = UILabel()
    let voteAverageLabel = UILabel()
    let genresLabel = UILabel()
    let taglineLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(movieDetail: MovieDetail) {
        nameLabel.text = movieDetail.title
        originalNameLabel.text = movieDetail.getOriginalNameWithReleaseDate()
        voteAverageLabel.attributedText = movieDetail.getVoteAverageWithPopularity()
        genresLabel.text = movieDetail.getGenres()
        taglineLabel.text = movieDetail.tagline
        if let posterPathUrlString = movieDetail.getPosterPathUrlString() {
            movieImageView.downloadImageFrom(urlString: posterPathUrlString)
        }
    }
    
    func set(movie: Movie) {
        
    }
}

extension MovieDetailHeaderView: ViewInstallationProtocol {
    func addSubviews() {
        addSubview(movieImageView)
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(originalNameLabel)
        verticalStackView.addArrangedSubview(voteAverageLabel)
        verticalStackView.addArrangedSubview(genresLabel)
        verticalStackView.addArrangedSubview(taglineLabel)
    }
    
    func setViewConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            movieImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            movieImageView.heightAnchor.constraint(equalToConstant: 120),
            movieImageView.widthAnchor.constraint(equalTo: movieImageView.heightAnchor, multiplier: 2/3),
            movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ]
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            verticalStackView.topAnchor.constraint(equalTo: movieImageView.topAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 12),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
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
        nameLabel.font =  UIFont.boldSystemFont(ofSize: 14)
        
        originalNameLabel.textColor = .black
        originalNameLabel.font = UIFont.systemFont(ofSize: 14)
        
        genresLabel.textColor = .black
        genresLabel.font = UIFont.systemFont(ofSize: 14)
        
        taglineLabel.textColor = .black
        taglineLabel.font = UIFont.systemFont(ofSize: 14)
    }
}
