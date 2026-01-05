//
//  SavedMovies.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 10/07/1447 AH.
//

import Foundation

struct SavedMoviesResponse: Codable {
    let records: [SavedMoviesRecord]
}

struct SavedMoviesRecord: Codable, Identifiable {
    let id: String
    let fields: SavedMoviesData
}

struct SavedMoviesData: Codable {
    let userId: String?
    let movieId: [String]?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case movieId = "movie_id"
    }
}


// Error handling
enum SavedMoviesError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
