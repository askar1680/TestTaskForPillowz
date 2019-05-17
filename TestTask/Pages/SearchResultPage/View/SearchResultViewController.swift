//
//  SearchResultViewController.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import UIKit

class SearchResultViewController: BaseViewController {
    
    lazy var presenter: SearchResultPresenterInput = SearchResultPresenter(view: self)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: VerticalCVLayout())
    
    private var movies = [Movie]()
    private var page = 1
    private var maxResult = -1
    
    private let query: String
    
    init(query: String) {
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.searchMovie(query: query, page: page)
    }
}

extension SearchResultViewController: SearchResultViewInput {
    func set(movies: [Movie]) {
        self.movies = movies
        self.collectionView.reloadData()
    }
    
    func set(maxResult: Int) {
        self.maxResult = maxResult
    }
    
    func handledError() {
        
    }
}

extension SearchResultViewController {
    func routeToDetailPage(movie: Movie) {
        let detailViewController = MovieDetailViewController(movieId: movie.id)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieCVCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.set(movie: movies[indexPath.row])
        return cell
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 && maxResult != -1 && maxResult != movies.count {
            page += 1
            presenter.searchMovie(query: query, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        routeToDetailPage(movie: movies[indexPath.row])
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch UIDevice.current.orientation {
        case .portrait:
            return calculatePortraitCVCellSize()
        case .portraitUpsideDown:
            return calculatePortraitCVCellSize()
        case .landscapeLeft:
            return calculateLandscapeCVCellSize()
        case .landscapeRight:
            return calculateLandscapeCVCellSize()
        default:
            return calculatePortraitCVCellSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SearchResultViewController: ViewInstallationProtocol {
    func addSubviews() {
        view.addSubview(collectionView)
    }
    
    func setViewConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        title = "Favourites"
        
        view.backgroundColor = .white
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCVCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 16, right: 12)
    }
}

extension SearchResultViewController {
    private func calculatePortraitCVCellSize() -> CGSize {
        let imageWidth = UIScreen.main.bounds.width / 2 - 16
        let imageHeight = imageWidth * 3 / 2
        let width = imageWidth + 2
        let height = imageHeight + 48
        return CGSize(width: width, height: height)
    }
    
    private func calculateLandscapeCVCellSize() -> CGSize {
        let imageWidth = (UIScreen.main.bounds.width - getScreenSidesSafeAreaInsets()) / 4 - 16
        
        let imageHeight = imageWidth * 3 / 2
        let width = imageWidth + 2
        let height = imageHeight + 48
        return CGSize(width: width, height: height)
    }
    
    private func getScreenSidesSafeAreaInsets() -> CGFloat {
        var safeAreaInsets: CGFloat = 0
        if let window = UIApplication.shared.keyWindow {
            safeAreaInsets += window.safeAreaInsets.right + window.safeAreaInsets.left
        }
        return safeAreaInsets
    }
}
