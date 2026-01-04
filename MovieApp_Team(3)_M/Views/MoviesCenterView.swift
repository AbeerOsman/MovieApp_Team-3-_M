import SwiftUI

struct MoviesCenterView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = MoviesViewModel()
    @StateObject private var DeatailsviewModel = MovieDetailsViewModel()
    
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                if !searchText.isEmpty {
                    FilteredMovieView(
                        movies: viewModel.moviesRecored,
                        actors: DeatailsviewModel.actorss,
                        searchText: searchText
                    )
                } else {
                    VStack(spacing: 24) {
                        HighRatedMovies()

                        MoviesCategoryListView()
                    }
                }
                
            }//to stic the top
            .safeAreaInset(edge: .top){
                HeaderView(searchText: $searchText)
            }.padding()
        }
        //featch all data (movies)
        .task {
            await viewModel.loadMovies()
        }
    }
}
struct HeaderView: View {
    @Binding var searchText: String
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
            VStack(spacing: 16) {
                
                    HStack {
                        Text("Movies Center")
                            .font(.system(size: 28, weight: .bold))
                        Spacer()
                        if let user = sessionManager.currentUser {
                            NavigationLink(destination: ProfileView()
                                .navigationBarBackButtonHidden(true)){
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Image(user.profileImage ?? "User Avatare")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 40)
                                        )
                                }
                        }
                    }
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for movie name, actors ...", text: $searchText)
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }.background(
                Rectangle()
                    .fill(Color(.black))
                    .frame(height: 125)
                    .ignoresSafeArea()
            )
        
        
    }
}

struct MoviesCategoryListView: View {
    @StateObject private var viewModel = MoviesViewModel()
    

    var body: some View {
        VStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(100)
                    } else {
                        VStack(spacing: 24) {
                            ForEach(viewModel.uniqueGenres, id: \.self) { genre in
                                MovieCategorySection(
                                    category: genre,
                                    movies: viewModel.moviesRecored.filter { $0.fields.genre.contains(genre) }
                                )
                            }
                        }
                        .padding(.top, 24)
                    }
                }
                .task {
                    await viewModel.loadMovies()
                }
    }
}

struct MovieCategorySection: View {
    let category: String
    let movies: [MovieRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                Text(category)
                    .font(.system(size: 22, weight: .semibold))
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Show more")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.yelloww)
                }

            }
                        
            if movies.isEmpty {
                Text("No \(category.lowercased()) movies found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(movies) { movie in
                            MoviePosterCard(movie: movie)
                        }
                    }
                }
            }
        }
    }
}
struct MoviePosterCard: View {
    let movie: MovieRecord

    var body: some View {
        NavigationLink(destination: MoviesDetailsView(movie_id: movie.id)) {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: movie.fields.poster)) { image in
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
                .frame(width: 208, height: 275)
                .clipped()
                .cornerRadius(8)

                Text(movie.fields.name)
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilteredMovieView: View {
    let movies: [MovieRecord]
    let actors: [ActorFilds]
    let searchText: String

    var filteredMovies: [MovieRecord] {
        movies.filter {
            $0.fields.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredActors: [ActorFilds] {
        actors.filter {
            searchText.isEmpty ||
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        if filteredMovies.isEmpty {
            Text("No results found")
                .foregroundColor(.gray)
                .padding()
        } else {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(filteredMovies) { movie in
                    MoviePosterCard(movie: movie)
                }
            }
        }
    }
}

#Preview {
    MoviesCenterView()
}

