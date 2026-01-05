//
//  ReviewModel.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 16/07/1447 AH.
//

struct ReviewResponse: Codable {
    let records: [ReviewRecord]
}

struct ReviewRecord: Codable, Identifiable {
    let id: String
    let fields: ReviewInfo
}

struct ReviewInfo: Codable {
    let rate: Double
    let review_text: String //connected w MovieResponse id
    let movie_id: String
    let user_id: String?  // CHANGED TO OPTIONAL to see all reviews even if the user don't have id
}

struct ReviewUIModel: Identifiable {
    let id: String
    let userName: String
    let userImage: String
    let rating: Double
    let text: String
    let userId: String?
}
