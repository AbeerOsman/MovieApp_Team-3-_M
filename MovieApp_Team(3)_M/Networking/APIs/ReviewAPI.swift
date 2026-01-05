//
//  ReviewAPI.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 17/07/1447 AH.
//

import Foundation

struct ReviewAPI {
    
    static func fetchReviews(for movieID: String) async throws -> ReviewResponse {
        let data = try await NetworkService.fetch(Endpoints.reviews(movieID))
        let response = try JSONDecoder().decode(ReviewResponse.self, from: data)
        return response
    }
    
    static func postReview(_ review: ReviewInfo) async throws -> ReviewRecord {
        let body: [String: Any] = [
            "fields": [
                "rate": review.rate,
                "review_text": review.review_text,
                "movie_id": review.movie_id,
                "user_id": review.user_id ?? ""
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        let data = try await NetworkService.post(Endpoints.reviewsBase, body: jsonData)
        let result = try JSONDecoder().decode(ReviewRecord.self, from: data)
        return result
    }
    
    static func deleteReview(id: String) async throws {
        try await NetworkService.delete(Endpoints.review(id))
    }
}
