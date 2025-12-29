//
//  MovieInfoModle.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 05/07/1447 AH.
//

import Foundation

//all movies in API
struct MoviesResponse: Codable {
    let records: [MovieRecord]
}

// Each record
struct MovieRecord: Codable, Identifiable {
    let id: String
    let createdTime: String
    let fields: MoviesInfo
}

// Actual movie data
struct MoviesInfo: Codable, Identifiable {
    var id: String { name }    // Use movie name as ID for SwiftUI ForEach
    let name: String
    let poster: String
    let story: String
    let runtime: String
    let genre: [String]
    let rating: String
    let imdbRating: Double
    let language: [String]

    enum CodingKeys: String, CodingKey {
        case name, poster, story, runtime, genre, rating, language
        case imdbRating = "IMDb_rating"
    }
}

// Error handling
enum MoviesError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

enum APIKey {
    static let airtable = Bundle.main
        .infoDictionary?["MoviesAPIToken"] as? String ?? ""
}
