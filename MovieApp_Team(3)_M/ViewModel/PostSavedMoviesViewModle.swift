//
//  PostSavedMoviesViewModel.swift
//  MovieApp_Team(3)_M
//

import Foundation
import Combine

@MainActor
class PostSavedMoviesViewModel: ObservableObject {
    @Published var isSaved = false
    
    // Check if movie is already saved
    func checkIfMovieSaved(userId: String, movieId: String) {
        guard let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/saved_movies?filterByFormula=AND({user_id}='\(userId)',FIND('\(movieId)',{movie_id}))") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "MoviesAPIToken") as? String {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        } else {
            print("API Key not found")
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error checking saved: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(SavedMoviesResponse.self, from: data)
                        self?.isSaved = !response.records.isEmpty
                        print("Movie saved status: \(self?.isSaved ?? false)")
                    } catch {
                        print("Failed to decode: \(error)")
                    }
                }
            }
        }.resume()
    }
    
    // Save movie
    func postSavedMovie(userId: String, movieId: String) {
        guard let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/saved_movies") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "MoviesAPIToken") as? String {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        } else {
            print("API Key not found")
            return
        }
        
//        let requestBody: [String: Any] = [
//            "records": [
//                [
//                    "fields": [
//                        "user_id": userId,
//                        "movie_id": [movieId]
//                    ]
//                ]
//            ]
//        ]
        
        let requestBody: [String: Any] = [
                    "fields": [
                        "user_id": userId,
                        "movie_id": [movieId]
                    ]
                ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            request.httpBody = jsonData
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Sending JSON: \(jsonString)")
            }
        } catch {
            print("Failed to encode: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: \(httpResponse.statusCode)")
                    
                    if let data = data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Response: \(jsonString)")
                        }
                    }
                    
                    if httpResponse.statusCode == 200 {
                        print("Movie saved successfully!")
                        self?.isSaved = true
                    }
                }
            }
        }.resume()
    }
}

//@MainActor
//class PostSavedMoviesViewModel: ObservableObject {
//    @Published var isSaved = false
//    
//    func postSavedMovie(userId: String, movieId: String) {
//        // 1. Airtable URL
//        guard let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/saved_movies") else {
//            print("Invalid URL")
//            return
//        }
//        
//        // 2. Create URLRequest
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        // 3. Add Authorization header
//        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "MoviesAPIToken") as? String {
//            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        } else {
//            print("API Key not found")
//            return
//        }
//        
//        // 4. Prepare data with correct format
//        let requestBody: [String: Any] = [
//            "fields": [
//                "user_id": userId,
//                "movie_id": [movieId]
//            ]
//        ]
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
//            request.httpBody = jsonData
//        } catch {
//            print("Failed to encode: \(error)")
//            return
//        }
//        
//        // 5. Send request
//        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                    return
//                }
//                
//                if let httpResponse = response as? HTTPURLResponse {
//                    if httpResponse.statusCode == 200 {
//                        print("Movie saved successfully!")
//                        self?.isSaved = true
//                    } else {
//                        print("Status code: \(httpResponse.statusCode)")
//                    }
//                }
//            }
//        }.resume()
//    }
//}


/* ANOTHER WAY TO DO IT
 
 //
 //  PostSavedMoviesViewModel.swift
 //  MovieApp_Team(3)_M
 //

 import Foundation

 @MainActor
 class PostSavedMoviesViewModel: ObservableObject {
     @Published var isSaved = false
     
     func postSavedMovie(userId: String, movieId: String) {
         guard let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/saved_movies") else {
             print("Invalid URL")
             return
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
         if let apiKey = Bundle.main.object(forInfoDictionaryKey: "MoviesAPIToken") as? String {
             request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
         } else {
             print("API Key not found")
             return
         }
         
         // IMPORTANT: Airtable requires "records" wrapper
         let requestBody: [String: Any] = [
             "records": [
                 [
                     "fields": [
                         "user_id": userId,
                         "movie_id": [movieId]
                     ]
                 ]
             ]
         ]
         
         do {
             let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
             request.httpBody = jsonData
             
             // DEBUG: Print what we're sending
             if let jsonString = String(data: jsonData, encoding: .utf8) {
                 print("Sending JSON: \(jsonString)")
             }
         } catch {
             print("Failed to encode: \(error)")
             return
         }
         
         URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
             DispatchQueue.main.async {
                 if let error = error {
                     print("Error: \(error.localizedDescription)")
                     return
                 }
                 
                 if let httpResponse = response as? HTTPURLResponse {
                     print("Status code: \(httpResponse.statusCode)")
                     
                     if let data = data {
                         if let jsonString = String(data: data, encoding: .utf8) {
                             print("Response: \(jsonString)")
                         }
                     }
                     
                     if httpResponse.statusCode == 200 {
                         print(" Movie saved successfully!")
                         self?.isSaved = true
                     }
                 }
             }
         }.resume()
     }
 }
 */
