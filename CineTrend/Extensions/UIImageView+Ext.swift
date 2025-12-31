//
//  UIImageView+Ext.swift
//  CineTrend
//
//  Created by Trangptt on 29/12/25.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    // Hàm tải ảnh
    func downloadImage(from urlString: String) {
        
        self.image = nil
        
        // Kiểm tra xem ảnh này đã tải lần nào chưa
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        // Bắt đầu tải
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // Tải xong, chuyển Data thành Image
                if let downloadedImage = UIImage(data: data) {
                    // Lưu vào cache để lần sau dùng
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    await MainActor.run {
                        self.image = downloadedImage
                    }
                }
            } catch {
                print("Lỗi tải ảnh: \(error)")
            }
        }
    }
}
