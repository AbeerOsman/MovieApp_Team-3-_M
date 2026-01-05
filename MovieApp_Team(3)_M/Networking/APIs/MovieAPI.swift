//
//  MovieAPI.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 16/07/1447 AH.
//
import Foundation

struct MovieAPI {
    
    static func fetchMovies() async throws -> MoviesResponse {
        let data = try await NetworkService.fetch(Endpoints.movies)
        let response = try JSONDecoder().decode(MoviesResponse.self, from: data)
        return response
    }
    
    static func fetchMovie(id: String) async throws -> MovieResponse {
        let data = try await NetworkService.fetch(Endpoints.movie(id))
        let response = try JSONDecoder().decode(MovieResponse.self, from: data)
        return response
    }
    
    static func fetchMovieActorsResponse(for movieID: String) async throws -> MovieActorsResponse {
        let data = try await NetworkService.fetch(Endpoints.movieActors(movieID))
        let response = try JSONDecoder().decode(MovieActorsResponse.self, from: data)
        return response
    }
    
    static func fetchActorResponse(id: String) async throws -> ActorResponse {
        let data = try await NetworkService.fetch(Endpoints.actor(id))
        let response = try JSONDecoder().decode(ActorResponse.self, from: data)
        return response
    }
    
    static func fetchMovieDirectorsResponse(for movieID: String) async throws -> MovieDirectorsResponse {
        let data = try await NetworkService.fetch(Endpoints.movieDirectors(movieID))
        let response = try JSONDecoder().decode(MovieDirectorsResponse.self, from: data)
        return response
    }
    
    static func fetchDirectorResponse(id: String) async throws -> DirectorResponse {
        let data = try await NetworkService.fetch(Endpoints.director(id))
        let response = try JSONDecoder().decode(DirectorResponse.self, from: data)
        return response
    }
}
