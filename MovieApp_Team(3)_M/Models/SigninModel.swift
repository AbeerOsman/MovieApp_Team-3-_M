//
//  UserInfo.swift
//  MovieApp_Team(3)_M
//
//  Created by Shaikha Alnashri on 09/07/1447 AH.
//

import Foundation

struct UsersResponse: Codable {
    let records: [UserRecord]
}

struct UserRecord: Codable, Identifiable {
<<<<<<< HEAD
    let id: String
=======
    let id: String                 // ✅ Airtable user record ID
>>>>>>> main
    let fields: UserInfo
}

struct UserInfo: Codable {
<<<<<<< HEAD
    let name: String?
    let password: String
    let email: String
    let profile_image: String?
}

enum SigninError: Error {
    case invalidURL
    case invalidResponse
    case invalidEmail
    case invalidPassword
    case userNotFound
    case networkError
    case unknownError
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPassword:
            return "Invalid password. Please try again"
        case .userNotFound:
            return "No account found with this email"
        case .networkError:
            return "Network error. Please check your connection"
        case .unknownError:
            return "Something went wrong. Please try again"
        }
=======
    let name: String
    let password: String
    let email: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case name, password, email
        case profileImage = "profile_image"
>>>>>>> main
    }
}


<<<<<<< HEAD
=======
// Error handling
enum UsersError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

>>>>>>> main
