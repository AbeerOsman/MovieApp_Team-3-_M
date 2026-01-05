//
//  MoviesDetailsViewModel.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 09/07/1447 AH.
//
import Foundation
import Combine

@MainActor
class MovieDetailsViewModel: ObservableObject {
    
    @Published var moviee: MovieFields?
    @Published var actorss: [ActorFilds] = []
    @Published var director: DirectorFields?
    @Published var reviews: [ReviewUIModel] = []
    @Published var allUsers: [UserRecord] = []
    @Published var isSaved = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func load_movie(movieID: String) async {
        isLoading = true
        await fetch_movie(movieID: movieID)
        await fetch_actors(movieID: movieID)
        await fetch_director(movieID: movieID)
        await fetchAllUsers()  // Load users first
        await fetchReviews(movieID: movieID)  // Then fetch reviews
        isLoading = false
    }
    
    private func fetch_movie(movieID: String) async {
        do {
            let response = try await MovieAPI.fetchMovie(id: movieID)
            self.moviee = response.fields
        } catch {
            print("Movie fetch error:", error)
            errorMessage = "Failed to load movie details"
        }
    }
    private func fetch_actors(movieID: String) async {
        do {
            self.actorss = try await ActorAPI.fetchActors(for: movieID)
        } catch {
            print("Actor fetch error:", error)
        }
    }
    
    private func fetch_director(movieID: String) async {
        do {
            self.director = try await DirectorAPI.fetchDirector(for: movieID)
        } catch {
            print("Director fetch error:", error)
        }
    }
    private func fetchAllUsers() async {
        do {
            let response = try await UserAPI.fetchUsers()
            self.allUsers = response.records
            print("Loaded \(response.records.count) users")
        } catch {
            print("Fetch all users error:", error)
            errorMessage = "Failed to load users"
        }
    }
    
    private func fetchReviews(movieID: String) async {
        do {
            let response = try await ReviewAPI.fetchReviews(for: movieID)
            
            // Keep your existing UI mapping logic here
            var uiReviews: [ReviewUIModel] = []
            for record in response.records {
                if let userRecord = allUsers.first(where: { $0.id == record.fields.user_id }) {
                    let reviewUI = ReviewUIModel(
                        id: record.id,
                        userName: userRecord.fields.name ?? "Unknown",
                        userImage: userRecord.fields.profileImage ?? "",
                        rating: record.fields.rate,
                        text: record.fields.review_text,
                        userId: record.fields.user_id
                    )
                    uiReviews.append(reviewUI)
                }
            }
            self.reviews = uiReviews
        } catch {
            print("Review fetch error:", error)
            errorMessage = "Failed to load reviews"
        }
    }
    func deleteReview(_ review: ReviewUIModel) {
        Task {
            do {
                try await ReviewAPI.deleteReview(id: review.id)
                reviews.removeAll { $0.id == review.id }
            } catch {
                print("Failed to delete:", error)
            }
        }
    }

}
