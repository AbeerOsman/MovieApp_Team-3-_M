
//  ReviewModelView.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 04/07/1447 AH.
//
//

import SwiftUI
import Combine

@MainActor
class AddReviewViewModel: ObservableObject {
    @Published var reviewText: String = ""
    @Published var rating: Int = 1
    @Published var isSubmitting: Bool = false
    @Published var errorMessage: String?
    
    func submitReview(movieID: String) async -> Bool {
        guard let userID = SessionManager.shared.userRecordId else {
            errorMessage = "User not logged in"
            return false
        }
        
        isSubmitting = true
        defer {
            isSubmitting = false
        }
        
        let review = ReviewInfo(
            rate: rating,
            review_text: reviewText,
            movie_id: movieID,
            user_id: userID
        )
        
        do {_ = try await NetworkService.postReview(review)
            return true
        } catch {
            errorMessage = error.localizedDescription
            print("Post review error:", error)
            return false
        }
    }
}

struct ReviewModelView : View {
    @Binding var rating: Int
    var label = ""
    var maximumRating: Int = 5
    var offImage: Image = Image(systemName: "star")
    var onImage: Image = Image( systemName: "star.fill")
    var offColor = Color.yelloww
    var onColor: Color = .yelloww
    var body: some View {
        HStack{
            if label.isEmpty == false {
                Text(label)}
            ForEach(1...maximumRating, id: \.self){ number in
                Button {
                    rating = number
                } label: {
                    image(for: number)
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
                
            }
        }
        .buttonStyle(.plain)
    }
    func image(for number : Int) ->Image {
        if number > rating {
            offImage /*?? onImage*/
        } else {
            onImage
        }
    }
}
