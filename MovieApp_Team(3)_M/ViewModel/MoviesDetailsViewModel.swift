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
        await fetch_movie(movieID: movieID)
        await fetch_actors(movieID: movieID)
        await fetch_director(movieID: movieID)
        await fetchAllUsers()
        await fetchReviews(movieID: movieID)
    }
    
    private func fetch_movie(movieID: String) async {
        do {
            let endpoint = NetworkService.movieEndpoint(for: movieID)
            let data = try await NetworkService.fetch(endpoint)
            //       print(String(data: data, encoding: .utf8),"‼️")
            let response = try JSONDecoder().decode(MovieResponse.self, from: data)
            self.moviee = response.fields
        } catch {
            print("Movie fetch error:", error)
        }
    }
    
    //MORE DETAILS I DONT LIKE ITTTT
    private func fetch_actors(movieID: String) async {
        do {
            let endpoint = NetworkService.actorsEndpoint(for: movieID)
            let data = try await NetworkService.fetch(endpoint)
            let response = try JSONDecoder().decode(MovieActorsResponse.self, from: data)
            
            var actors: [ActorFilds] = []
            
            for record in response.records {
                let actorID = record.fields.actor_id
                let actorData = try await NetworkService.fetch("/movie_actors/\(actorID)")
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
                
                let directorData = try await NetworkService.fetch("/movie_directors/\(directorID)")
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
        } catch {
            print("Fetch all users error:", error)
        }
    }
    
    //  Fetch reviews
    private func fetchReviews(movieID: String) async {
        do {
            let data = try await NetworkService.fetch(NetworkService.reviewEndpoint(for: movieID))
            let response = try JSONDecoder().decode(ReviewResponse.self, from: data)
            
            var uiReviews: [ReviewUIModel] = []
            
            for record in response.records {
                if let userRecord = allUsers.first(where: { $0.id == record.fields.user_id }) {
                    let reviewUI = ReviewUIModel(
                        id: record.id,
                        userName: userRecord.fields.name ?? "Unknown",
                        userImage: userRecord.fields.profileImage ?? "",
                        rating: record.fields.rate,
                        text: record.fields.review_text
                    )
                    uiReviews.append(reviewUI)
                } else {
                    // fallback if user not found
                    let reviewUI = ReviewUIModel(
                        id: record.id,
                        userName: "Unknown",
                        userImage: "",
                        rating: record.fields.rate,
                        text: record.fields.review_text
                    )
                    uiReviews.append(reviewUI)
                }
            }
            
            self.reviews = uiReviews
            
        } catch {
            print("Review fetch error:", error)
        }
    }
}
  
