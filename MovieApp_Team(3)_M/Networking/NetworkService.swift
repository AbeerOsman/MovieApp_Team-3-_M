//
//  NetworkService.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 11/07/1447 AH.
//
import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum NetworkError: Error {
    case badURL
    case badResponse
    case decodingError
    case encodingError
}

struct NetworkService {
    private static let baseURL = "https://api.airtable.com/v0/appsfcB6YESLj4NCN"
    
    // Core Request Method
    private static func request(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Data? = nil
    ) async throws -> Data {
        
        let urlString = baseURL + endpoint
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        print("Request: \(method.rawValue) \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response type")
            throw NetworkError.badResponse
        }
        
        print("Response Status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            if let responseString = String(data: data, encoding: .utf8) {
                print("Error Response: \(responseString)")
            }
            throw NetworkError.badResponse
        }
        
        return data
    }
    
    //GET Request
    static func fetch(_ endpoint: String) async throws -> Data {
        return try await request(endpoint: endpoint, method: .GET)
    }
    
    // POST Request
    static func post(_ endpoint: String, body: Data) async throws -> Data {
        return try await request(endpoint: endpoint, method: .POST, body: body)
    }
    
    // PUT Request
    static func put(_ endpoint: String, body: Data) async throws -> Data {
        return try await request(endpoint: endpoint, method: .PUT, body: body)
    }
    
    // DELETE Request
    static func delete(_ endpoint: String) async throws {
        _ = try await request(endpoint: endpoint, method: .DELETE)
    }
}
