//
//  ImageAPI.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 17/07/1447 AH.
//

import Foundation
import UIKit

struct ImageAPI {
    
    static func uploadToImgur(imageData: Data) async throws -> String {
        let compressedData = compressImage(imageData, maxSizeKB: 1024)
        let base64Image = compressedData.base64EncodedString()
        
        let body: [String: Any] = [
            "image": base64Image,
            "type": "base64"
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL(string: "https://api.imgur.com/3/image") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Client-ID 546c25a59c58ad7", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        print("Uploading image to Imgur...")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response type")
            throw NetworkError.badResponse
        }
        
        print("Imgur Response Status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            if let responseString = String(data: data, encoding: .utf8) {
                print(" Imgur Error Response: \(responseString)")
            }
            throw NetworkError.badResponse
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let dataDict = json?["data"] as? [String: Any],
              let imageUrl = dataDict["link"] as? String else {
            print("Cannot parse Imgur response")
            throw NetworkError.decodingError
        }
        
        print("Image uploaded: \(imageUrl)")
        return imageUrl
    }
    
    // Image Compression
    private static func compressImage(_ data: Data, maxSizeKB: Int) -> Data {
        guard let image = UIImage(data: data) else { return data }
        
        let maxBytes = maxSizeKB * 1024
        var compression: CGFloat = 1.0
        var imageData = data
        
        let maxDimension: CGFloat = 1024
        var newImage = image
        
        // Resize if needed
        if image.size.width > maxDimension || image.size.height > maxDimension {
            let ratio = min(maxDimension / image.size.width, maxDimension / image.size.height)
            let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            newImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
        }
        
        // Compress
        while imageData.count > maxBytes && compression > 0.1 {
            compression -= 0.1
            if let compressed = newImage.jpegData(compressionQuality: compression) {
                imageData = compressed
            }
        }
        
        return imageData
    }
}
