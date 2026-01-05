//
//  NetworkService.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 11/07/1447 AH.
//


import Foundation

struct NetworkService {
    private static let baseURL = "https://api.airtable.com/v0/appsfcB6YESLj4NCN"
    
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
    static func updateUser(recordId: String, user : UserInfo) async throws -> Data {
        guard let url = URL(string: baseURL + "/users/\(recordId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "fields": [
                "name": user.name,
                "password": user.password,
                "email": user.email,
                "profileImage": user.profileImage
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
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
}
