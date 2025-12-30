//
//  NetwordManager.swift
//  CineTrend
//
//  Created by Trangptt on 28/12/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    // Hàm lấy phim Trending
    func getTrendingMovies() async throws -> [Movie] {
        
        // Ghép thành 1 link từ constant
        let endpoint = "\(Constants.baseURL)/trending/movie/day?api_key=\(Constants.apiKey)"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        // Gửi lệnh lên mạng
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check xem Server có trả lời OK không (200 là OK)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Dịch JSON sang Swift
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(MovieResponse.self, from: data)
            return result.results
        } catch {
            print("Lỗi dịch dữ liệu: \(error)")
            throw NetworkError.invalidData
        }
    }
    
    // Hàm lấy danh sách trailer của phim
    func getMovieVideos(movieId: Int) async throws -> [Video] {
        // Endpoint
        let endpoint = "\(Constants.baseURL)/movie/\(movieId)/videos?api_key=\(Constants.apiKey)"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(VideoResponse.self, from: data)
            return result.results
        } catch {
            print("Lỗi decode video: \(error)")
            throw NetworkError.invalidData
        }
        
    }
}
