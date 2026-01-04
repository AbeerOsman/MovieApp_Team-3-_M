//
//  PostSavedMoviesViewModle.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 15/07/1447 AH.
//

import Foundation

func postSavedMovie(userId: String, movieIds: [String]) {
    // 1. Airtable URL
    guard let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/saved_movies") else {
        print("Invalid URL")
        return
    }
    
    // 2. Create URLRequest
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // 3. Add Authorization header using API key from .xcconfig
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "AIRTABLE_API_KEY") as? String {
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    } else {
        print("API Key not found in .xcconfig")
        return
    }
    
    // 4. Encode data
    let record = PostSavedMovieRecord(fields: .init(userId: userId, movieId: movieIds))
    
    do {
        let jsonData = try JSONEncoder().encode(record)
        request.httpBody = jsonData
    } catch {
        print("Failed to encode record: \(error)")
        return
    }
    
    // 5. Send request
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code: \(httpResponse.statusCode)")
        }
        
        if let data = data {
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }
    }.resume()
}
