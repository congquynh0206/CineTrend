//
//  MovieGridViewController.swift
//  CineTrend
//
//  Created by Trangptt on 31/12/25.
//


import UIKit

class MovieGridViewController: UIViewController {

    // Dữ liệu phim
    var movies: [Movie] = []
    var pageTitle: String = ""

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // Chia 3 cột
        let itemWidth = UIScreen.main.bounds.width / 3 - 10
        layout.itemSize = CGSize(width: itemWidth, height: 180)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.title = pageTitle

        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        let nib = UINib(nibName: "MovieCellCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieCellId")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension MovieGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCellId", for: indexPath) as? MovieCellCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: movies[indexPath.row], isBig: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Khi bấm vào phim trong list View All thì chuyển sang Detail
        let detailVC = DetailViewController()
        detailVC.movie = movies[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
