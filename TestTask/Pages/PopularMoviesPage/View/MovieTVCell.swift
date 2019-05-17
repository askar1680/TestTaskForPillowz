//
//  MovieTVCell.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit

protocol LikeClickDelegate: class {
    func likeClicked(at indexPath: IndexPath)
}

class MovieTVCell: UITableViewCell, ReusableView {
    
    private let movieImageView = AsyncImageView()
    private let verticalStackView = UIStackView()
    private let nameLabel = UILabel()
    private let likeImageView = UIImageView()
    private let originalNameLabel = UILabel()
    private let voteAverageLabel = UILabel()
    private let overviewLabel = UILabel()
    
    private let likeImageViewSize = CGSize(width: 20, height: 20)
    
    weak var likeClickDelegate: LikeClickDelegate?
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(movie: Movie) {
        nameLabel.text = movie.title
        originalNameLabel.text = movie.getOriginalNameWithReleaseDate()
        overviewLabel.text = movie.overview
        voteAverageLabel.attributedText = movie.getVoteAverageWithPopularity()
        if let posterPathUrlString = movie.getPosterPathUrlString() {
            movieImageView.downloadImageFrom(urlString: posterPathUrlString)
        }
    }
    
    func set(isMovieLiked: Bool) {
        let imageName = isMovieLiked ? "heart_filled" : "heart"
        likeImageView.image = UIImage(named: imageName)?.resized(to: likeImageViewSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
    }
    
    @objc func likeTapped() {
        if let indexPath = indexPath {
            likeClickDelegate?.likeClicked(at: indexPath)
        }
    }
}

extension MovieTVCell: ViewInstallationProtocol {
    func addSubviews() {
        addSubview(movieImageView)
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        addSubview(likeImageView)
        verticalStackView.addArrangedSubview(originalNameLabel)
        verticalStackView.addArrangedSubview(voteAverageLabel)
        verticalStackView.addArrangedSubview(overviewLabel)
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
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -8)
        ]
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            nameLabel.trailingAnchor.constraint(equalTo: likeImageView.leadingAnchor, constant: -4)
        ]
        
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
             likeImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
             likeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
             likeImageView.widthAnchor.constraint(equalToConstant: likeImageViewSize.width),
             likeImageView.heightAnchor.constraint(equalToConstant: likeImageViewSize.height)
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
        nameLabel.font =  UIFont.boldSystemFont(ofSize: 12)
        
        likeImageView.isUserInteractionEnabled = true
        likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeTapped)))
        
        originalNameLabel.textColor = .black
        originalNameLabel.font = UIFont.systemFont(ofSize: 12)
        
        overviewLabel.textColor = .darkGray
        overviewLabel.font = UIFont.systemFont(ofSize: 12)
        overviewLabel.numberOfLines = 3
    }
}
