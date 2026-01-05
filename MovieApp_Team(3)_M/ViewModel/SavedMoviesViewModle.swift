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
        let endpoint = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/saved_movies"
        guard let url = URL(string: endpoint) else {
            throw SavedMoviesError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw SavedMoviesError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let savedMoviesResponse = try decoder.decode(SavedMoviesResponse.self, from: data)
        
        // Filter out records with missing userId or movieId
        return savedMoviesResponse.records
            .map { $0.fields }
            .filter { $0.userId != nil && $0.movieId != nil }
    }
}
