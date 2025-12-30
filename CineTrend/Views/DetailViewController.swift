//
//  DetailViewController.swift
//  CineTrend
//
//  Created by Trangptt on 30/12/25.
//
import UIKit

class DetailViewController : UIViewController {
    var movie: Movie?
    private var trailerKey: String?
    
    // Scroll view
    private let scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // ContentView
    private let contentView : UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    
    //Ảnh bìa
    private let backImage : UIImageView = {
        let bi = UIImageView()
        bi.contentMode = .scaleAspectFill
        bi.clipsToBounds = true
        bi.backgroundColor = .systemGray5
        bi.translatesAutoresizingMaskIntoConstraints = false
        return bi
    }()
    
    // Button
    private let youtubeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Watch Trailer on YouTube", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemRed
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        return btn
    }()
    
    // Tên phim
    private let titleLable : UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 24, weight: .bold)
        title.numberOfLines = 0
        title.textColor = .label
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    //Sub title
    private let subTitleLabel : UILabel = {
        let subTitle = UILabel()
        subTitle.text = "OverView"
        subTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        subTitle.textColor = .secondaryLabel
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        return subTitle
    }()
    
    //Tóm tắt
    private let summary : UILabel = {
        let summary = UILabel()
        summary.numberOfLines = 0
        summary.font = .systemFont(ofSize: 16, weight: .regular)
        summary.textColor = .label
        summary.translatesAutoresizingMaskIntoConstraints = false
        return summary
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        youtubeButton.addTarget(self, action: #selector(didTapYoutubeButton), for: .touchUpInside)
        setUpUI()
        configureData()
        getTrailer()
    }
    
    // Hàm xử lý khi bấm nút
    @objc private func didTapYoutubeButton() {
        guard let key = trailerKey else { return }
        
        if let webURL = URL(string: "https://www.youtube.com/watch?v=\(key)") {
            UIApplication.shared.open(webURL)
        }
    }
    
    private func setUpUI(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backImage)
        contentView.addSubview(youtubeButton)
        contentView.addSubview(titleLable)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(summary)
        
        NSLayoutConstraint.activate([
            // scroll
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // content
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            // Ảnh bìa
            backImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            backImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backImage.heightAnchor.constraint(equalToConstant: 220),
            
            // Button
            youtubeButton.topAnchor.constraint(equalTo: backImage.bottomAnchor, constant: 10),
            youtubeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            youtubeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            youtubeButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Tên phim
            titleLable.topAnchor.constraint(equalTo: youtubeButton.bottomAnchor, constant: 20),
            titleLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Nội dung phụ
            subTitleLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 20),
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Summary
            summary.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 8),
            summary.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            summary.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            summary.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    
    private func configureData(){
        guard let movie = movie else {return}
        
        titleLable.text = movie.title ?? movie.originalTitle
        summary.text = movie.overview
        
        let path = movie.backDropPath ??  movie.posterPath ?? ""
        let url = Constants.imageBaseURL + path
        backImage.downloadImage(from: url)
    }
    
    private func getTrailer() {
        guard let movie = movie else { return }
        
        Task {
            do {
                let videos = try await NetworkManager.shared.getMovieVideos(movieId: movie.id)
                
                // Lọc video
                let trailer = videos.first { video in
                    return video.site == "YouTube" && (video.type == "Trailer" || video.type == "Teaser")
                }
                
                // Nếu tìm thấy trailer
                if let trailer = trailer {
                    self.trailerKey = trailer.key // Lưu key
                    
                    // Hiện nút lên
                    DispatchQueue.main.async {
                        self.youtubeButton.isHidden = false
                    }
                }
            } catch {
                print("Lỗi lấy trailer: \(error)")
            }
        }
    }
    
}
