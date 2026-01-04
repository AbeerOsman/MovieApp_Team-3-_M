//
//  NetworkService.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 11/07/1447 AH.

import Foundation

struct NetworkService {
    private static let GitURL = "https://api.airtable.com/v0/appsfcB6YESLj4NCN"
    
    static func fetch(_ endpoint: String) async throws -> Data {
        guard let url = URL(string: GitURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(APIKey.airtable)",forHTTPHeaderField: "Authorization")
        request.setValue(
            "Bearer \(APIKey.airtable)",
            forHTTPHeaderField: "Authorization"
        )
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    static func movieEndpoint(for movieID: String) -> String {
        return "/movies/\(movieID)"
    }
    
    static func actorsEndpoint(for movieID: String) -> String {
        return "/movie_actors?filterByFormula=movie_id=\"\(movieID)\""
    }
    
    static func directorEndpoint(for movieID: String) -> String {
        return "/movie_directors?filterByFormula=movie_id=\"\(movieID)\""
    }

    
    static func reviewEndpoint(for movieID: String) -> String {
        return "/reviews?filterByFormula=movie_id=\"\(movieID)\""
    }
    
    static func userEndpoint() -> String {
        return "/users"
    }

    static func postReview(_ review: ReviewInfo) async throws -> ReviewRecord {
        guard let url = URL(string: GitURL + "/reviews") else {
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
    
    static func updateUser(recordId: String, name: String) async throws -> Data {
        guard let url = URL(string: GitURL + "/users/\(recordId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["fields": ["name": name]]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
