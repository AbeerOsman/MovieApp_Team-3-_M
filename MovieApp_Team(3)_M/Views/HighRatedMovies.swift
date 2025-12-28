//
//  HighRatedMovies.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 06/07/1447 AH.
//

import SwiftUI

import SwiftUI

struct HighRatedMovies: View {
    @StateObject private var viewModel = HighRatedViewModel()
    var highRatedMovies : [MoviesInfo]{
        viewModel.movies.filter { $0.imdbRating >= 5 }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("High Rated")
                .font(.system(size: 22, weight: .semibold))
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(100)

            } else if highRatedMovies.isEmpty {
                Text("No Movies Found")
                    .foregroundColor(.gray)
                    .padding()

            } else{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(highRatedMovies) { movie in
                            VStack(alignment: .leading) {
                                AsyncImage(url: URL(string: movie.poster)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .overlay(
                                                LinearGradient(
                                                    colors: [.black.opacity(0.9), .clear],
                                                    startPoint: .bottom,
                                                    endPoint: .center
                                                )
                                            )
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 355, height: 429)
                                .clipped()
                                .cornerRadius(8)

                                .overlay {
                                    ZStack(alignment: .bottomLeading) {
                                        
                                        LinearGradient( colors: [.black.opacity(0.4), .clear], startPoint: .bottom, endPoint: .top )
                                        
                                        VStack(alignment: .leading, spacing: 5){
                                            Text(movie.name)
                                                .font(.system(size: 28, weight: .bold))
                                            HStack {
                                                ForEach(1...5, id: \.self) { _ in Image(systemName: "star.fill") .foregroundColor(.yellow) .font(.system(size: 8)) } }
                                            HStack {
                                                Text(String(format: "%.1f", movie.imdbRating))
                                                    .font(.system(size: 20, weight: .semibold))
                                                Text("out of 10") .font(.system(size: 12))
                                            }
                                            
                                            HStack {
                                                /*is a method for arrays of strings.
                                                It takes all the elements of the array and combines them into a single string, inserting the separator between each element.*/
                                                Text(movie.genre.joined(separator: ", "))  .font(.system(size: 12))
                                                
                                                Text(movie.runtime)
                                                    .font(.system(size: 12))
                                            }
                                            
                                        }.padding()
                                        
                                    }
                                    
                                }
                                
                            }//End of Vstack
                            .frame(width: 250)
                        }.padding(.trailing, 55)
                        .padding(.leading, 40)
                    }
                    .padding(.horizontal)
                }//scroll
            }
        }
        .padding(.top, 24)
        .task {
            await viewModel.loadMovies()
        }
    }
}

#Preview {
    HighRatedMovies()
}
