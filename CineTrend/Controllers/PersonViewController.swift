//
//  PersonViewController.swift
//  CineTrend
//
//  Created by Trangptt on 5/1/26.
//

import UIKit

class PersonViewController : UIViewController{
    var personId : Int = 0
    private var movies : [Movie] = []
    
    // Scroll View
    private let scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // ContentView
    private let contentView : UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    //Background Img
    private let headerImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.alpha = 0.9
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .black
        return iv
    }()
    
    // Avatar
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.systemBackground.cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // Tên
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // job
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Tiểu sử
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Known for
    private let knownForTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Known for"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Phim
    private let moviesCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 240)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerImageView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(jobLabel)
        contentView.addSubview(bioLabel)
        contentView.addSubview(knownForTitleLabel)
        contentView.addSubview(moviesCollectionView)
        
        // Setup CollectionView
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        let nib = UINib(nibName: "MovieCellCollectionViewCell", bundle: nil)
        moviesCollectionView.register(nib, forCellWithReuseIdentifier: "MovieCellId")
        
        NSLayoutConstraint.activate([
            // ScrollView full màn hình
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header Image
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 250),
            
            // Avatar
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 140),
            
            // Name & Job
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 10),
            
            jobLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            jobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            // Bio
            bioLabel.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 5),
            bioLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Known for
            knownForTitleLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 24),
            knownForTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // List phim
            moviesCollectionView.topAnchor.constraint(equalTo: knownForTitleLabel.bottomAnchor, constant: 12),
            moviesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            moviesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            moviesCollectionView.heightAnchor.constraint(equalToConstant: 240),
            
            // Neo đáy để ScrollView
            moviesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // Fetch Data
    private func fetchData() {
        Task {
            do {
                // Gọi song song 2 API Info & Movies
                async let personDetail = NetworkManager.shared.getPersonDetail(id: personId)
                async let personMovies = NetworkManager.shared.getPersonMovieCredits(id: personId)
                
                let (person, movies) = try await (personDetail, personMovies)
                self.movies = movies
                
                DispatchQueue.main.async {
                    self.updateUI(with: person)
                    self.moviesCollectionView.reloadData()
                    
                    // Lấy ảnh của phim nổi tiếng nhất làm ảnh nền Header
                    if let bestMovie = movies.first, let backdrop = bestMovie.backDropPath {
                        let url = Constants.imageBaseURL + backdrop
                        self.headerImageView.downloadImage(from: url) 
                    }
                }
            } catch {
                print("Lỗi load profile: \(error)")
            }
        }
    }
    
    private func updateUI(with person: Person) {
        nameLabel.text = person.name
        jobLabel.text = person.knownForDepartment
        bioLabel.text = person.biography.isEmpty ? "No biography available." : person.biography
        
        if let path = person.profilePath {
            avatarImageView.downloadImage(from: Constants.imageBaseURL + path)
        }
    }
}

// Datasource, delegate
extension PersonViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCellId", for: indexPath) as? MovieCellCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: movies[indexPath.row], isBig: false)
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        return cell
    }
    
    // Bấm vào phim thì lại mở màn hình Detail phim
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.movie = movies[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

