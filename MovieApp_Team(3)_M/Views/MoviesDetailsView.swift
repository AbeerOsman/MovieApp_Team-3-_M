//
//  MoviesDetailsView.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 04/07/1447 AH.
//
//
import SwiftUI
struct MoviesDetailsView: View {
    
    @State private var showNavTitle = false
    let movie_id: String
    @StateObject private var vm = MovieDetailsViewModel()
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
                    
                    ReviewsScrollView()
                    
                    Reviewbutton()
                }
                .padding(.horizontal)
            }
            .task {
                await vm.load_movie(movieID: movie_id)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.yelloww)
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.yelloww)
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Image(systemName: "bookmark")
                        .foregroundColor(.yelloww)
                    
                }
            }
        }
        
    }
}
struct Moviesposter: View {
    let poster: String
    let name: String
    
    var body: some View {
        ZStack() {
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
struct ReviewCard: View {
    @State private var rating = 4
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 12) {
                Image("images-2")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Afnan Abdullah")
                    ReviewModelView(rating: $rating)
                }
                Spacer()
            }
            
            Text("This is an engagingly simple, good-hearted film...")
            //   .foregroundColor(.white.opacity(0.9))
            
            HStack {
                Spacer()
                Text("Tuesday")
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .frame(width: 305, height: 188)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(18)
    }
}
struct ReviewsScrollView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ReviewCard()
                ReviewCard()
                ReviewCard()
                ReviewCard()
            }
            .padding(.horizontal)
        }
    }
}
struct Reviewbutton: View {
    var body: some View {
        Button(action: {
            print("Write a review")})
        {
            HStack {
                Image(systemName: "square.and.pencil")
                    .font(.title2)
                Text("Write a review")
                    .font(.title2)
                
                
            }
            .foregroundColor(.yelloww)
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.yelloww, lineWidth: 2)
            )
        }.padding(.horizontal)
    }
}
#Preview {
    MoviesDetailsView(movie_id: "reckJmZ458CZcLlUd")
}
