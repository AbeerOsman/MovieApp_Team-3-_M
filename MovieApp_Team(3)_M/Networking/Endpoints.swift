//
//  Endpoints.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 16/07/1447 AH.
//
//
import Foundation

enum Endpoints {
    
    // Movies
    static let movies = "/movies"
    static func movie(_ id: String) -> String {
        "/movies/\(id)"
    }
    
    // Actors
    static func movieActors(_ movieID: String) -> String {
        let formula = "movie_id=\"\(movieID)\""
        let encoded = formula.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? formula
        return "/movie_actors?filterByFormula=\(encoded)"
    }
    static func actor(_ id: String) -> String {
        "/movie_actors/\(id)"
    }
    
    // Directors
    static func movieDirectors(_ movieID: String) -> String {
        let formula = "movie_id=\"\(movieID)\""
        let encoded = formula.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? formula
        return "/movie_directors?filterByFormula=\(encoded)"
    }
    static func director(_ id: String) -> String {
        "/movie_directors/\(id)"
    }
    
    // Reviews
    static func reviews(_ movieID: String) -> String {
        let formula = "movie_id=\"\(movieID)\""
        let encoded = formula.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? formula
        return "/reviews?filterByFormula=\(encoded)"
    }
    static func review(_ id: String) -> String {
        "/reviews/\(id)"
    }
    static let reviewsBase = "/reviews"
    
    // Users
    static let users = "/users"
    static func user(_ id: String) -> String {
        "/users/\(id)"
    }
    
    // Saved Movies
    static let savedMovies = "/saved_movies"
    static func savedMoviesCheck(userID: String, movieID: String) -> String {
        let formula = "AND({user_id}='\(userID)',FIND('\(movieID)',{movie_id}))"
        let encoded = formula.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? formula
        return "/saved_movies?filterByFormula=\(encoded)"
    }
}
