//
//  AddReviewView.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 04/07/1447 AH.
//

import SwiftUI

struct AddReviewView: View {
    let movieID: String
    @StateObject private var vm = AddReviewViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                // Review Text
                Text("Your Review")
                    .font(.headline)
                
                ZStack(alignment: .topLeading) {
                    if vm.reviewText.isEmpty {
                        Text("Enter your review")
                            .foregroundColor(Color.gray)
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                    TextEditor(text: $vm.reviewText)
                        .frame(height: 150)
                        .padding(4)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .accentColor(.yellow)
                }
                
                // Rating
                HStack(spacing: 150) {
                    Text("Rating")
                        .font(.headline)
                    ReviewModelView(rating: $vm.rating)
                }
                
                Spacer()
                
                // Show error if any
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
            }
            .padding()
            .navigationTitle("Write a Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            let success = await vm.submitReview(movieID: movieID)
                            if success {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Add")
                            .bold()
                            .foregroundColor(.yelloww)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .cornerRadius(6)
                    }
                    
                    .disabled(vm.isSubmitting || vm.reviewText.isEmpty)
                }
                
            }
        }
    }
}
