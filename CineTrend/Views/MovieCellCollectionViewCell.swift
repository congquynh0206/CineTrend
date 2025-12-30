//
//  MovieCellCollectionViewCell.swift
//  CineTrend
//
//  Created by Trangptt on 30/12/25.
//

import UIKit

class MovieCellCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var posterImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        posterImageView.backgroundColor = .systemGray5
    }

    // Hàm nhận dữ liệu từ ViewController để hiển thị
    func configure(with movie: Movie) {
        let fullURL = Constants.imageBaseURL + (movie.posterPath ?? "")
        
        self.posterImageView.downloadImage(from: fullURL)
        self.titleLabel.text = movie.originalTitle
        }
}
