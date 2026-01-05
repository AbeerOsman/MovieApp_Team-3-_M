import Foundation
import Combine

@MainActor
class PostSavedMoviesViewModel: ObservableObject {
    @Published var isSaved = false
    private let baseURL = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/saved_movies"
    
    private var token: String {
        Bundle.main.object(forInfoDictionaryKey: "MoviesAPIToken") as? String ?? ""
    }
    
    // Check if movie is saved
    func checkIfMovieSaved(userId: String, movieId: String) {
        getUser(userId: userId) { record in
            let savedMovies = record?["movie_id"] as? [String] ?? []
            self.isSaved = savedMovies.contains(movieId)
        }
    }
    
    // Add or remove movie
    func toggleSaveMovie(userId: String, movieId: String) {
        getUser(userId: userId) { record in
            if let recordId = record?["id"] as? String {
                // User exists - update their record
                self.updateUser(recordId: recordId, userId: userId, movieId: movieId)
            } else {
                // New user - create record
                self.createUser(userId: userId, movieId: movieId)
            }
        }
    }
    
    // Get user's saved movies
    private func getUser(userId: String, completion: @escaping ([String: Any]?) -> Void) {
        let url = baseURL + "?filterByFormula={user_id}='\(userId)'"
        
        apiCall(url: url, method: "GET") { data in
            let record = self.parseRecords(data).first
            completion(record)
        }
    }
    
    // Update user's movies (add/remove)
    private func updateUser(recordId: String, userId: String, movieId: String) {
        getUser(userId: userId) { record in
            var movies = record?["movie_id"] as? [String] ?? []
            
            if movies.contains(movieId) {
                movies.removeAll { $0 == movieId }  // Remove
            } else {
                movies.append(movieId)  // Add
            }
            
            let body = ["fields": ["user_id": userId, "movie_id": movies]]
            self.apiCall(url: self.baseURL + "/" + recordId, method: "PATCH", body: body) { _ in
                self.isSaved.toggle()
            }
        }
    }
    
    // Create new user record
    private func createUser(userId: String, movieId: String) {
        let body = ["fields": ["user_id": userId, "movie_id": [movieId]]]
        
        apiCall(url: baseURL, method: "POST", body: body) { _ in
            self.isSaved = true
        }
    }
    
    // Parse API response , converts raw API data -> JSON -> usable records
    private func parseRecords(_ data: Data) -> [[String: Any]] {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let records = json["records"] as? [[String: Any]] else {
            return []
        }
        
        return records.compactMap { record in
            var result = record["fields"] as? [String: Any] ?? [:]
            ///Airtable record ID is outside fields, We add it manually so we don’t lose it
            result["id"] = record["id"]
            return result
        }
    }
    
    // Make API request
    private func apiCall(url: String, method: String, body: [String: Any]? = nil, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    completion(data)
                }
            }
        }.resume()
    }
}
