//
//  DirectorAPI.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 17/07/1447 AH.
//

import Foundation

struct DirectorAPI {
    
    // Keep your exact same logic
    static func fetchDirector(for movieID: String) async throws -> DirectorFields? {
        // Fetch movie_directors records
        let response = try await MovieAPI.fetchMovieDirectorsResponse(for: movieID)
        
        guard let firstRecord = response.records.first else {
            return nil
        }
        
        // Fetch director details
        let directorID = firstRecord.fields.director_id
        let directorResponse = try await MovieAPI.fetchDirectorResponse(id: directorID)
        
        return directorResponse.fields
    }
}
