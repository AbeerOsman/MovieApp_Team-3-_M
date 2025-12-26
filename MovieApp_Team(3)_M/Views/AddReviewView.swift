//
//  AddReviewView.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 04/07/1447 AH.
//
import SwiftUI
struct AddReviewView: View {
    @State private var Review: String = " "
   @Binding var rating: Int
    var body: some View {
        VStack{
            HStack(spacing: 78){
                Button("Back", systemImage: "chevron.backward"){
               }
                .foregroundColor(.yelloww)
                Text("Write a review")
                    .font(.title2)
                Button("Add"){
                    
               }
                .foregroundColor(.yelloww)
            }
            Rectangle()
                .frame(height: 0.3)
                .foregroundColor(.gray)
            Spacer().frame(width: 38, height: 78)
            
            VStack(alignment: .leading, spacing: 12){
                Text("Review")
                
                ZStack(alignment: .topLeading){
                    if Review.isEmpty{
                        Text("Enter your review")
                            .foregroundColor(Color.white.opacity(0.4))
                            .padding(.top, 12)
                            .padding(.leading, 16)
                    }
                    TextEditor(text: $Review)
                        .foregroundColor(Color.white.opacity(0.4))
                        .padding(12)
                        .scrollContentBackground(.hidden)
                    
                }
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .accentColor(.yellow)
            
                HStack(spacing: 200){
                    Text("Rating")
                    ReviewModelView(rating: $rating)
                        
                   
                }
            Spacer().frame(height: 410)
            }
        }
    }
}
#Preview {
    AddReviewView(rating: .constant(1))
}
