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
            let endpoint = NetworkService.movieEndpoint(for: movieID)
            let data = try await NetworkService.fetch(endpoint)
            let response = try JSONDecoder().decode(MovieResponse.self, from: data)
            self.moviee = response.fields
        } catch {
            print("Movie fetch error:", error)
            errorMessage = "Failed to load movie details"
        }
    }
    
    private func fetch_actors(movieID: String) async {
        do {
            let endpoint = NetworkService.actorsEndpoint(for: movieID)
            let data = try await NetworkService.fetch(endpoint)
            let response = try JSONDecoder().decode(MovieActorsResponse.self, from: data)
            
            var actors: [ActorFilds] = []
            
            for record in response.records {
                let actorID = record.fields.actor_id
                let actorEndpoint = NetworkService.actorDetailEndpoint(for: actorID)
                let actorData = try await NetworkService.fetch(actorEndpoint)
                let actorResponse = try JSONDecoder().decode(ActorResponse.self, from: actorData)
                actors.append(actorResponse.fields)
            }
            
            self.actorss = actors
            
        } catch {
            print("Actor fetch error:", error)
        }
    }
    
    
    private func fetch_director(movieID: String) async {
        do {
            let endpoint = NetworkService.directorEndpoint(for: movieID)
            let data = try await NetworkService.fetch(endpoint)
            
            let response = try JSONDecoder().decode(MovieDirectorsResponse.self, from: data)
            
            if let firstRecord = response.records.first {
                let directorID = firstRecord.fields.director_id
                let directorEndpoint = NetworkService.directorDetailEndpoint(for: directorID)
                let directorData = try await NetworkService.fetch(directorEndpoint)
                let directorResponse = try JSONDecoder().decode(DirectorResponse.self, from: directorData)
                self.director = directorResponse.fields
            }
            
        } catch {
            print("Director fetch error:", error)
        }
    }
    
    private func fetchAllUsers() async {
        do {
            let data = try await NetworkService.fetch(NetworkService.userEndpoint())
            let response = try JSONDecoder().decode(UsersResponse.self, from: data)
            self.allUsers = response.records
            print("Loaded \(response.records.count) users")
        } catch {
            print("Fetch all users error:", error)
            errorMessage = "Failed to load users"
        }
    }
    
    private func fetchReviews(movieID: String) async {
        do {
            let endpoint = NetworkService.reviewEndpoint(for: movieID)
            print("Fetching reviews from endpoint: \(endpoint)")
            
            let data = try await NetworkService.fetch(endpoint)
            
            // Print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw response: \(jsonString)")
            }
            
            let response = try JSONDecoder().decode(ReviewResponse.self, from: data)
            
            print("Fetched \(response.records.count) reviews for movie \(movieID)")
            print("Total users loaded: \(allUsers.count)")
            
            var uiReviews: [ReviewUIModel] = []
            
            for record in response.records {
                print("Processing review ID: \(record.id), User ID: \(record.fields.user_id)")
                
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
                    print("User found for review: \(userRecord.fields.name ?? "Unknown")")
                } else {
                    print("User NOT found for review with ID: \(record.fields.user_id)")
                    let reviewUI = ReviewUIModel(
                        id: record.id,
                        userName: "Unknown",
                        userImage: "",
                        rating: record.fields.rate,
                        text: record.fields.review_text,
                        userId: record.fields.user_id 
                    )
                    uiReviews.append(reviewUI)
                }
            }
            
            self.reviews = uiReviews
            print("Final: Processed \(uiReviews.count) reviews with user data")
            
        } catch {
            print("Review fetch error:", error)
            errorMessage = "Failed to load reviews"
        }
    }
    func deleteReview(_ review: ReviewUIModel) {
            Task {
                do {
                    try await NetworkService.deleteReview(reviewId: review.id)
                    print("Deleted review:", review.id)
                    reviews.removeAll { $0.id == review.id }
                } catch {
                    print("Failed to delete:", error)
                }
            }
        }

}
