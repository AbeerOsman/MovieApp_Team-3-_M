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

    @Published var movies: [MoviesInfo] = []
    @Published var moviesRecored: [MovieRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    var uniqueGenres: [String] {
           let allGenres = movies.flatMap { $0.genre }
           return Array(Set(allGenres)).sorted() // Remove duplicates and sort alphabetically
       }
    
    /// Get movies filtered by genre / category
    func moviesByGenre(_ genre: String) -> [MoviesInfo] {
        movies.filter { $0.genre.contains(genre) }
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

    // Networking
    private func getMoviesRecords() async throws -> [MovieRecord] {
        let endpoint = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies"
        // Convert string url into URL object
        guard let url = URL(string: endpoint) else {
            throw MoviesError.invalidURL
        }

        // Create a URLRequest to add the Authorization header
        var request = URLRequest(url: url)
        print("token is: \(APIKey.airtable)")
        request.setValue(
            "Bearer \(APIKey.airtable)",
            forHTTPHeaderField: "Authorization"
        )
        // Call network
        let (data, response) = try await URLSession.shared.data(for: request)
      //  print(String(data: data, encoding: .utf8),"⌚️")
        // Check HTTP response
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MoviesError.invalidResponse
        }
        // Decode JSON
        let decoder = JSONDecoder()
        let result = try decoder.decode(MoviesResponse.self, from: data)
        // Return array of MovieRecord
        return result.records
    }
}
