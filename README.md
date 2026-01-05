# MovieApp_Team(3)_M
A SwiftUI-based iOS movie application that enables users to browse movies, manage user accounts, write reviews, and save favorite movies. The app integrates with the Airtable API to perform comprehensive CRUD operations.
Table of Contents

# Overview
# Features
# Architecture
# CRUD Operations & API Integration

# Overview
This project demonstrates a fully functional movie application with user authentication, movie discovery, review management, and personalized saving features. The application follows the MVVM (Model-View-ViewModel) architectural pattern and leverages async/await for efficient asynchronous network requests.
Features

User Authentication: Sign in with email and password validation
Movie Browsing: Discover movies filtered by genre and category
Movie Details: View comprehensive movie information including cast, director, and ratings
Review System: Read user reviews and submit your own ratings and comments
Saved Movies: Save favorite movies for quick access
User Profile Management: Update user information and profile picture
Session Persistence: Automatic session management with UserDefaults

# Architecture
The application follows the MVVM (Model-View-ViewModel) pattern:

- Models: Define data structures that mirror the Airtable API responses
- ViewModels: Handle business logic and data fetching operations
- Views: SwiftUI views that display data and handle user interactions
- Services: Centralized network and session management

# CRUD Operations & API Integration
All communication with the Airtable API is handled through the NetworkService class, which provides a centralized interface for HTTP requests. The application implements the following CRUD operations:
# Create (POST)
1. Post Review
swift// File: NetworkService.swift
static func postReview(_ review: ReviewInfo) async throws -> ReviewRecord

Endpoint: POST /reviews
Purpose: Creates a new review for a movie
Data Sent:

rate: Rating (1-5)
review_text: Review content
movie_id: Associated movie ID
user_id: Current user ID


Implementation: Used in AddReviewViewModel to submit user reviews

2. Post Saved Movie
swift// File: PostSavedMoviesViewModle.swift
func postSavedMovie(userId: String, movieId: String)

Endpoint: POST /saved_movies
Purpose: Saves a movie to the user's collection
Data Sent:

user_id: User identifier
movie_id: Array of movie IDs to save


Implementation: Triggered when user clicks the save button on movie details

# Read (GET)
1. Fetch All Movies
swift// File: MoviesViewModel.swift
private func getMoviesRecords() async throws -> [MovieRecord]

Endpoint: GET /movies
Purpose: Retrieves all available movies from the database
Returns: Array of MovieRecord objects with complete movie information
Usage: Populates the main movie list and enables filtering by genre

2. Fetch Movie Details
swift// File: MoviesDetailsViewModel.swift
private func fetch_movie(movieID: String) async

Endpoint: GET /movies/{movieID}
Purpose: Retrieves detailed information for a specific movie
Returns: MovieFields containing title, poster, story, runtime, genre, rating, and IMDb rating

3. Fetch Actors
swift// File: MoviesDetailsViewModel.swift
private func fetch_actors(movieID: String) async

Endpoint: GET /movie_actors?filterByFormula=movie_id="{movieID}"
Purpose: Retrieves actor IDs associated with a movie, then fetches each actor's details
Returns: Array of ActorFilds with actor name and image

4. Fetch Director
swift// File: MoviesDetailsViewModel.swift
private func fetch_director(movieID: String) async

Endpoint: GET /movie_directors?filterByFormula=movie_id="{movieID}"
Purpose: Retrieves director information for a movie
Returns: DirectorFields with director name and image

5. Fetch Reviews
swift// File: MoviesDetailsViewModel.swift
private func fetchReviews(movieID: String) async

Endpoint: GET /reviews?filterByFormula=movie_id="{movieID}"
Purpose: Retrieves all reviews for a specific movie
Processing: Maps review data with user information for display
Returns: Array of ReviewUIModel ready for UI presentation

6. Fetch User Information
swift// File: SigninViewModel.swift
private func fetchUsers() async throws -> UsersResponse

Endpoint: GET /users
Purpose: Retrieves all users for authentication and profile display
Usage: Used during sign-in to validate credentials

7. Fetch Saved Movies
swift// File: SavedMoviesViewModle.swift
private func getSavedMovies() async throws -> [SavedMoviesData]

Endpoint: GET /saved_movies
Purpose: Retrieves the current user's saved movies
Returns: Array of user-saved movie records

8. Check If Movie Saved
swift// File: PostSavedMoviesViewModle.swift
func checkIfMovieSaved(userId: String, movieId: String)

Endpoint: GET /saved_movies?filterByFormula=AND(...)
Purpose: Verifies if a specific movie is already saved by the user
Updates: isSaved published property for UI binding

# Update (PUT)
1. Update User Profile
swift// File: NetworkService.swift
static func updateUser(recordId: String, user: UserInfo) async throws -> Data

Endpoint: PUT /users/{recordId}
Purpose: Updates user profile information
Data Updated:

name: User's full name
email: Email address
password: Password (if changed)
profileImage: Profile picture URL


Implementation: Called from user settings/profile edit views

# Delete (DELETE)
Deleting reviews
Account deletion
