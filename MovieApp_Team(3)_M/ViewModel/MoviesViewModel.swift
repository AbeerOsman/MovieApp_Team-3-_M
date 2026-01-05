//
//  MoviesViewModel.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 06/07/1447 AH.
//

import Foundation
import Combine

@MainActor
class MoviesViewModel: ObservableObject {
    //Initializer
    @Published var movies: [MoviesInfo] = []
    @Published var moviesRecored: [MovieRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    //computed property
    var uniqueGenres: [String] {
        let allGenres = movies.flatMap { $0.genre }
        return Array(Set(allGenres)).sorted()
    }
    
    // Load movies
    func loadMovies() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fullRecords = try await getMoviesRecords()
            moviesRecored = fullRecords
            movies = fullRecords.map { $0.fields }
            print("DEBUG: Loaded \(moviesRecored.count) movie records")
        } catch {
            errorMessage = error.localizedDescription
            print("Error loading movies:", error)
        }
    }
    
    // Networking - now using MovieAPI
    private func getMoviesRecords() async throws -> [MovieRecord] {
        let response = try await MovieAPI.fetchMovies()
        return response.records
    }
}
