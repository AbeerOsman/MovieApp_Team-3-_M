import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var userViewModel = UsesViewModel()
    @StateObject var moviesViewModel = MoviesViewModel()
    @StateObject private var savedMoviesViewModel = SavedMoviesViewModle()
    @EnvironmentObject var sessionManager: SessionManager
    @State private var isLoading = true
    
    var currentUserSavedMovies: [MovieRecord] {
        guard let recordId = sessionManager.userRecordId else {
            print("DEBUG: No user record ID")
            return []
        }
        
        print("DEBUG: Current user record ID: \(recordId)")
        print("DEBUG: All saved movies count: \(savedMoviesViewModel.savedMovies.count)")
        
        let savedMovieIds = savedMoviesViewModel.savedMovies
            .filter { $0.userId == recordId }
            .flatMap { $0.movieId }
        
        print("DEBUG: Filtered movie IDs for user: \(savedMovieIds)")
        print("DEBUG: Total movies in ViewModel: \(moviesViewModel.moviesRecored.count)")
        
        let filtered = moviesViewModel.moviesRecored.filter { savedMovieIds.contains($0.id) }
        print("DEBUG: Filtered movies found: \(filtered.count)")
        
        return filtered
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                
                // Title
                Text("Profile")
                    .font(.system(size: 38, weight: .bold))
                    .padding(.top, 21)
                    .padding(.horizontal)
                
                Divider()
                
                // Profile Card
                if let user = sessionManager.currentUser {
                    NavigationLink(destination: EditProfileView()) {
                        HStack(spacing: 16) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                
                                Image(user.profileImage ?? "User Avatare")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                            
                            // User Info
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name ?? "User Name")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text(user.email ?? "User Email")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(white: 0.15))
                        )
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 30)
                    
                    // Saved Movies Title
                    Text("Saved Movies")
                        .font(.system(size: 26, weight: .bold))
                        .padding(.top, 40)
                        .padding(.horizontal)
                    
                    // Saved Movies List
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else if !currentUserSavedMovies.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(currentUserSavedMovies) { movieRecord in
                                    SavedMoviePosterCard(movie: movieRecord.fields)
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        VStack(spacing: 5) {
                            Image(.movieismeLogo)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 94, height: 94)
                                .padding(.top, 95)
                            
                            Text("No saved movies yet, start save\nyour favourites")
                                .font(.system(size: 17))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Spacer()
            }
            .onAppear {
                Task {
                    print("DEBUG: Starting to load data...")
                    isLoading = true
                    
                    // Load all data concurrently
                    async let userTask = userViewModel.fetchUser()
                    async let savedMoviesTask = savedMoviesViewModel.loadSavedMovies()
                    async let moviesTask = moviesViewModel.loadMovies()
                    
                    _ = await (userTask, savedMoviesTask, moviesTask)
                    
                    print("DEBUG: All data loaded")
                    isLoading = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.yellow)
                    }
                }
            }
        }
    }
}

struct SavedMoviePosterCard: View {
    let movie: MoviesInfo

    var body: some View {
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
            .frame(width: 208, height: 275)
            .clipped()
            .cornerRadius(8)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(SessionManager())
        .preferredColorScheme(.dark)
}
