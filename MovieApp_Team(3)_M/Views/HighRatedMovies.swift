//
//  HighRatedMovies.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 06/07/1447 AH.
//

import SwiftUI

struct HighRatedMovies: View {
    @StateObject private var viewModel = MoviesViewModel()

    var highRatedMovies: [MoviesInfo] {
        viewModel.movies.filter { $0.imdbRating > 5 }
    }

    var body: some View {
        VStack(alignment: .leading) {
            SectionTitle(title: "High Rated")

            if viewModel.isLoading {
                LoadingView()
            } else if highRatedMovies.isEmpty {
                EmptyStateView(message: "No Movies Found")
            } else {
                MoviesScrollView(movies: highRatedMovies)
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

struct MoviesScrollView: View {
    let movies: [MoviesInfo]
    
    @State private var selectedMovieIndex = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selectedMovieIndex) {
             ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                            MovieCardView(movie: movie)
                 .tag(index)
              }
                }
               .frame(height: 475)
               .tabViewStyle(
                  PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
}



struct MovieCardView: View {
    let movie: MoviesInfo

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: movie.poster)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .overlay(gradientOverlay)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 365, height: 410)
            .clipped()
            .cornerRadius(8)
            .overlay(movieInfoOverlay)
        }
    }

    private var gradientOverlay: some View {
        LinearGradient(
            colors: [.black.opacity(0.9), .clear],
            startPoint: .bottom,
            endPoint: .center
        )
    }

    private var movieInfoOverlay: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [.black.opacity(0.4), .clear],
                startPoint: .bottom,
                endPoint: .top
            )

            MovieInfoView(movie: movie)
                .padding()
        }
    }
}


struct MovieInfoView: View {
    let movie: MoviesInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(movie.name)
                .font(.system(size: 28, weight: .bold))

            RatingStarsView(rating: movie.imdbRating)

            HStack {
                Text(String(format: "%.1f", movie.imdbRating))
                    .font(.system(size: 20, weight: .semibold))
                Text("out of 10")
                    .font(.system(size: 12))
            }

            HStack {
                Text(movie.genre.joined(separator: ", "))
                    .font(.system(size: 10))

                Text(movie.runtime)
                    .font(.system(size: 10))
            }
        }
    }
}


struct RatingStarsView: View {
    let rating: Double
    
    var body: some View {
        let highlightedStars = starsCount(from: rating)
        HStack {
            ForEach(1...5, id: \.self) { index in
              Image(systemName: "star.fill")
                 .foregroundColor(index <= highlightedStars ? .yellow : .gray)
                 .font(.system(size: 8))
                
             }
        }
    }
}

func starsCount(from rating: Double) -> Int {
    switch rating {
    case 9.0...10.0:
        return 5
    case 8.0..<9.0:
        return 4
    case 7.0..<8.0:
        return 3
    case 6.0..<7.0:
        return 2
    case 5.0..<6.0:
        return 1
    default:
        return 0
    }
}


struct LoadingView: View {
    var body: some View {
        ProgressView()
            .padding(100)
    }
}


struct EmptyStateView: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundColor(.gray)
            .padding()
    }
}


struct SectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .semibold))
    }
}

