//
//  MoviesDetailsView.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 04/07/1447 AH.
//
//
import SwiftUI
struct MoviesDetailsView: View {
    @StateObject private var vm = MovieDetailsViewModel()
    @StateObject private var saveVM = PostSavedMoviesViewModel()
    @EnvironmentObject var sessionManager: SessionManager
    @State private var showNavTitle = false
    @State private var showSaveMovieButton = false
    @Environment(\.dismiss) var dismiss
    let movie_id: String
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let moviee = vm.moviee {
                    Moviesposter(
                        poster: moviee.poster,
                        name: moviee.name
                    )}
                
                VStack(alignment: .leading, spacing: 26) {
                    if let moviee = vm.moviee {
                        MoviesDetails(
                            runtime: moviee.runtime,
                            language: moviee.language.joined(separator: ", "),
                            genre: moviee.genre.joined(separator: ", "),
                            age: moviee.rating
                        )}
                    
                    
                    Divider().foregroundColor(.gray).opacity(0.5)
                    
                    if let moviee = vm.moviee {
                        Story(text: moviee.story)
                    }
                    Divider().foregroundColor(.gray).opacity(0.5)
                    
                    if let moviee = vm.moviee {
                        Rating(IMDb_rating: moviee.IMDbRating )
                        
                    }
                    
                    Divider().foregroundColor(.gray).opacity(0.5)
                    
                    if let director = vm.director {
                        Director(name: director.name, image: director.image)
                    }
                    if !vm.actorss.isEmpty {
                        Stars(actors: vm.actorss)
                    }
                    Divider().foregroundColor(.gray).opacity(0.5)
                    
                    Reviews()
                    
                    ReviewsScrollView(reviews: vm.reviews)
                    
                    Reviewbutton(movieID: movie_id)
                }
                .padding(.horizontal)
            }
            .task {
                await vm.load_movie(movieID: movie_id)
                // Check if movie is already saved
                if let user = sessionManager.userRecordId {
                    saveVM.checkIfMovieSaved(userId: user, movieId: movie_id)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.yelloww)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if
                        let movie = vm.moviee,
                        let shareURL = URL(string: movie_id),
                        let posterURL = URL(string: movie.poster)
                    {
                        ShareLink(
                            item: shareURL,
                            preview: SharePreview(
                                "\(movie.name)\n\(movie.genre.joined(separator: " Movie • "))",
                                image: posterURL
                            )
                        ) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.yelloww)
                        }
                    }
                    
                }
                
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Save/Bookmark button
                    if let user = sessionManager.userRecordId {
                        Button {
                            saveVM.postSavedMovie(userId: user, movieId: movie_id)
                        } label: {
                            Image(systemName: saveVM.isSaved ? "bookmark.fill" : "bookmark")
                                .foregroundColor(.yelloww)
                        }
                    }
                }
                
            }
        }.navigationBarBackButtonHidden(true)
        
    }
}
struct Moviesposter: View {
    let poster: String
    let name: String
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: poster)) { image in
                if let image = image.image {
                    ZStack{
                        image
                            .resizable()
                            .scaledToFill()
                            .padding(.top, -120)
                        
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.999),
                                Color.black.opacity(0)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    }.frame(maxHeight:300)
                    
                    Text(name)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .bottomLeading)
                    
                }
                
            }
        }
    }
}
struct MoviesDetails: View {
    let runtime: String
    let language: String
    let genre: String
    let age: String
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 30) {
            item(title: "Duration", value: runtime)
            item(title: "Language", value: language)
            item(title: "Genre", value: genre)
            item(title: "Age", value: age)
        }
    }
    
    func item(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            Text(value)
                .font(.system(size: 15))
                .foregroundColor(.gray)
        }
    }
}

struct Story: View {
    let text: String
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Story")
                .font(.title2)
                .bold()
            
            Text(text)
                .foregroundColor(.gray)
        }
    }
}
struct Rating: View {
    let IMDb_rating: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("IMDb Rating")
                .font(.title2)
                .bold()
            
            Text("\(IMDb_rating, specifier: "%.1f") / 10")
                .foregroundColor(.gray)
        }
    }
}
struct Director: View {
    let name: String
    let image: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Director")
                .font(.title2)
                .bold()
            
            AsyncImage(url: URL(string: image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    Color.gray
                } else {
                    ProgressView()
                }
            }
            .frame(width: 76, height: 76)
            .clipShape(Circle())
            
            Text(name)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
struct Stars: View {
    let actors: [ActorFilds]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stars")
                .font(.title2)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(actors, id: \.name) { actor in
                        star(actor: actor)
                    }
                }
            }
        }
    }
    
    func star(actor: ActorFilds) -> some View {
        VStack(spacing: 6) {
            AsyncImage(url: URL(string: actor.image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    Color.gray
                } else {
                    ProgressView()
                }
            }
            .frame(width: 76, height: 76)
            .clipShape(Circle())
            
            Text(actor.name)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct Reviews: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rating & Reviews")
                .font(.title2)
                .bold()
            
            Text("4.8 out of 5")
                .foregroundColor(.gray)
        }
    }
}

struct ReviewCardView: View {
    let review: ReviewUIModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: review.userImage)) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFill()
                    } else if phase.error != nil {
                        Color.gray
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 44, height: 44)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(review.userName)
                        .font(.subheadline)
                        .bold()
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(review.rating) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                    }
                }
                Spacer()
            }
            
            Text(review.text)
                .font(.body)
            
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .frame(width: 300)
    }
}
struct ReviewsScrollView: View {
    let reviews: [ReviewUIModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(reviews) { review in
                    ReviewCardView(review: review)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct Reviewbutton: View {
    let movieID: String
    
    var body: some View {
        NavigationLink(destination: AddReviewView(movieID: movieID)) {
            HStack {
                Image(systemName: "square.and.pencil")
                Text("Write a review")
            }
            .foregroundColor(.yellow)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.yellow, lineWidth: 2)
            )
        }
        .padding(.horizontal)
    }
}
