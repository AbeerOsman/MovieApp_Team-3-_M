//  NetworkService.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 11/07/1447 AH.

import Foundation
import UIKit

struct NetworkService {
    private static let baseURL = "https://api.airtable.com/v0/appsfcB6YESLj4NCN"
    
    // MARK: - GET Requests
    static func fetch(_ endpoint: String) async throws -> Data {
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "Bearer \(APIKey.airtable)",
            forHTTPHeaderField: "Authorization"
        )
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    // MARK: - Movie Endpoints
    static func movieEndpoint(for movieID: String) -> String {
        return "/movies/\(movieID)"
    }
    
    // MARK: - Actor Endpoints
    static func actorsEndpoint(for movieID: String) -> String {
        return "/movie_actors?filterByFormula=movie_id=\"\(movieID)\""
    }
    
    static func actorDetailEndpoint(for actorID: String) -> String {
        return "/movie_actors/\(actorID)"
    }
    
    // MARK: - Director Endpoints
    static func directorEndpoint(for movieID: String) -> String {
        return "/movie_directors?filterByFormula=movie_id=\"\(movieID)\""
    }
    
    static func directorDetailEndpoint(for directorID: String) -> String {
        return "/movie_directors/\(directorID)"
    }
    
    // MARK: - Review Endpoints
    static func reviewEndpoint(for movieID: String) -> String {
        return "/reviews?filterByFormula=movie_id=\"\(movieID)\""
    }
    
    // MARK: - User Endpoints
    static func userEndpoint() -> String {
        return "/users"
    }
    
    // MARK: - POST Requests
    static func postReview(_ review: ReviewInfo) async throws -> ReviewRecord {
        guard let url = URL(string: baseURL + "/reviews") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "fields": [
                "rate": review.rate,
                "review_text": review.review_text,
                "movie_id": review.movie_id,
                "user_id": review.user_id
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(ReviewRecord.self, from: data)
        return result
    }
    
    // MARK: - PUT Requests
    static func updateUser(recordId: String, user: UserInfo) async throws -> Data {
        guard let url = URL(string: baseURL + "/users/\(recordId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "fields": [
                "name": user.name ?? "",
                "password": user.password ?? "",
                "email": user.email ?? "",
                "profile_image": user.profileImage ?? ""
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    // MARK: - DELETE Requests
    static func deleteReview(reviewId: String) async throws {
        guard let url = URL(string: baseURL + "/reviews/\(reviewId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(
            "Bearer \(APIKey.airtable)",
            forHTTPHeaderField: "Authorization"
        )
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    // MARK: - Upload Image to Imgur
    static func uploadImageToImgur(imageData: Data) async throws -> String {
        guard let url = URL(string: "https://api.imgur.com/3/image") else {
            throw URLError(.badURL)
        }
        
        let compressedData = compressImage(imageData, maxSizeKB: 1024)
        let base64Image = compressedData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Client-ID 546c25a59c58ad7", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "image": base64Image,
            "type": "base64"
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let dataDict = json?["data"] as? [String: Any],
              let imageUrl = dataDict["link"] as? String else {
            throw URLError(.cannotParseResponse)
        }
        
        return imageUrl
    }
    
    // MARK: - Compress Image
    private static func compressImage(_ data: Data, maxSizeKB: Int) -> Data {
        guard let image = UIImage(data: data) else { return data }
        
        let maxBytes = maxSizeKB * 1024
        var compression: CGFloat = 1.0
        var imageData = data
        
        let maxDimension: CGFloat = 1024
        var newImage = image
        
        if image.size.width > maxDimension || image.size.height > maxDimension {
            let ratio = min(maxDimension / image.size.width, maxDimension / image.size.height)
            let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            newImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
        }
        
        while imageData.count > maxBytes && compression > 0.1 {
            compression -= 0.1
            if let compressed = newImage.jpegData(compressionQuality: compression) {
                imageData = compressed
            }
        }
        
        return imageData
    }
}
