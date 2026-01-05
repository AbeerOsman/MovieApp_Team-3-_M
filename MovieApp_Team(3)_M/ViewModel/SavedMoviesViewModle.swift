//
//  SavedMoviesViewModle.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 10/07/1447 AH.
//

import Foundation
import Combine

@MainActor
class SavedMoviesViewModle: ObservableObject {
    @Published var savedMovies: [SavedMoviesData] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadSavedMovies() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            savedMovies = try await getSavedMovies()
            print("Loaded saved movies: \(savedMovies.count) records")
            for movie in savedMovies {
                print("  User: \(movie.userId ?? "nil"), Movie IDs: \(movie.movieId ?? [])")
            }
        } catch {
            errorMessage = error.localizedDescription
            print("Error loading saved movies:", error)
        }
    }
    
    private func getSavedMovies() async throws -> [SavedMoviesData] {
        let response = try await SavedMoviesAPI.fetchSavedMovies()
        
        // Filter out records with missing userId or movieId
        return response.records
            .map { $0.fields }
            .filter { $0.userId != nil && $0.movieId != nil }
    }
}
