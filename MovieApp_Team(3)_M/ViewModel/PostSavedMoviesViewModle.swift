//
//  PostSavedMoviesViewModel.swift
//  MovieApp_Team(3)_M
//

import Foundation
import Combine

@MainActor
class PostSavedMoviesViewModel: ObservableObject {
    @Published var isSaved = false
    
    func checkIfMovieSaved(userId: String, movieId: String) {
        Task {
            do {
                isSaved = try await SavedMoviesAPI.checkIfMovieSaved(userID: userId, movieID: movieId)
            } catch {
                print("Error checking saved: \(error)")
            }
        }
    }
    
    func postSavedMovie(userId: String, movieId: String) {
        Task {
            do {
                try await SavedMoviesAPI.saveMovie(userID: userId, movieID: movieId)
                isSaved = true
                print("Movie saved successfully!")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

