//
//  Character.swift
//  CineTrend
//
//  Created by Trangptt on 5/1/26.
//

import Foundation

struct Person: Codable {
    let id: Int
    let name: String
    let biography: String
    let placeOfBirth: String?
    let birthday: String?
    let profilePath: String?
    let knownForDepartment: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, biography, birthday
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case knownForDepartment = "known_for_department"
    }
}

// Dsach phim của dvien
struct PersonMovieCreditsResponse: Codable {
    let cast: [Movie]
}
