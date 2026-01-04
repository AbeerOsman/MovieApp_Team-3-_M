//
//  PostSavedMoviewModle.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 15/07/1447 AH.
//

import Foundation

struct PostSavedMovieRecord: Codable {
    let fields: Fields
    
    struct Fields: Codable {
        let userId: String
        let movieId: [String]
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case movieId = "movie_id"
        }
    }
}
