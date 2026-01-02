//
//  MovieDetails.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 09/07/1447 AH.
//
// MovieModel.swift

import Foundation

struct MovieResponse: Codable {
    let id: String
    let createdTime: String
    let fields: MovieFields
}

struct MovieFields: Codable {
    let name: String
    let poster: String
    let story: String
    let runtime: String
    let genre: [String]
    let rating: String
    let IMDb_rating: Double
    let language: [String]
}

// Mapping of movies to actor IDs
struct MovieActorsResponse: Codable {
    let records: [MovieActorRecord]
}

struct MovieActorRecord: Codable {
    let id: String
    let fields: MovieActorFields
    
}

struct MovieActorFields: Codable {
    //movie
    let movie_id: String
    // movie actor
    let actor_id: String
}

// Single actor info
struct ActorResponse: Codable {
    let id: String
    let fields: ActorFilds
}

struct ActorFilds: Codable {
    let name: String
    let image: String
}

struct DirectorResponse: Codable {
    let id: String
    let fields:DirectorFields
}
struct DirectorFields: Codable {
    let name: String
    let image: String
}
struct MovieDirectorsResponse: Codable {
    let records: [MovieDirectorRecord]
}

struct MovieDirectorRecord: Codable {
    let fields: MovieDirectorFields
}

struct MovieDirectorFields: Codable {
    let movie_id: String
    let director_id: String
}
