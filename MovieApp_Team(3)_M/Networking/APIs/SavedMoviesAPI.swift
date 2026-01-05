//
//  SavedMoviesAPI.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 17/07/1447 AH.
//
import Foundation

struct SavedMoviesAPI {
    
    static func fetchSavedMovies() async throws -> SavedMoviesResponse {
        let data = try await NetworkService.fetch(Endpoints.savedMovies)
        let response = try JSONDecoder().decode(SavedMoviesResponse.self, from: data)
        return response
    }
    
    static func checkIfMovieSaved(userID: String, movieID: String) async throws -> Bool {
        let data = try await NetworkService.fetch(Endpoints.savedMoviesCheck(userID: userID, movieID: movieID))
        let response = try JSONDecoder().decode(SavedMoviesResponse.self, from: data)
        return !response.records.isEmpty
    }
    
    static func saveMovie(userID: String, movieID: String) async throws {
        let body: [String: Any] = [
            "fields": [
                "user_id": userID,
                "movie_id": [movieID]
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        _ = try await NetworkService.post(Endpoints.savedMovies, body: jsonData)
    }
}
