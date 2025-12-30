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
    let title : String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let backDropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    
    // Map sang tên của json
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case backDropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let id: String
    let key: String    // Dùng để ghép thành link YouTube
    let name: String
    let site: String   // "YouTube"
    let type: String   // "Trailer", "Teaser"
}
