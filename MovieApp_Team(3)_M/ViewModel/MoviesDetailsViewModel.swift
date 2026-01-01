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
    
    func load_movie(movieID: String) async {
        await fetch_movie(movieID: movieID)
        await fetch_actors(movieID: movieID)
        await fetch_director(movieID: movieID)
    }
    
    private func fetch_movie(movieID: String) async {
        do {
            let endpoint = NetworkService.movieEndpoint(for: movieID)
            let data = try await NetworkService.fetch(endpoint)
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
}
