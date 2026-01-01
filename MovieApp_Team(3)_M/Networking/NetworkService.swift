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
}
