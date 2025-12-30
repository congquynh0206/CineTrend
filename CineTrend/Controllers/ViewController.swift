//
//  ViewController.swift
//  CineTrend
//
//  Created by Trangptt on 26/12/25.
//

import UIKit

class ViewController: UIViewController {

    private var collectionView: UICollectionView!
    
    // Mảng chứa dữ liệu phim
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupCollectionView()
        fetchData()
    }
    
    // Vẽ khung giao diện
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        // Chia 3 cột
        let itemWidth = (view.frame.size.width - 40) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumLineSpacing = 10 // Gap giữa 2 dòng
        layout.minimumInteritemSpacing = 10 // Gap giữa 2 cột
        
        // Khởi tạo CollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.frame = view.bounds // Full màn hình
        
        let nib = UINib(nibName: "MovieCellCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieCellId")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    // Gọi api
    func fetchData() {
        Task {
            do {
                movies = try await NetworkManager.shared.getTrendingMovies()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Lỗi tải phim: \(error)")
            }
        }
    }
}

//Datasource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCellId", for: indexPath) as? MovieCellCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.configure(with: movie) // Đổ dữ liệu vào cell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Bạn vừa bấm vào phim: \(movies[indexPath.row].originalTitle ?? "")")
    }
}
