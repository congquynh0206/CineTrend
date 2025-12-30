//
//  Movies.swift
//  CineTrend
//
//  Created by Trangptt on 28/12/25.
//
import Foundation

// Đại diện object api trả về
struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double
    
    // Map sang tên của json
    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
