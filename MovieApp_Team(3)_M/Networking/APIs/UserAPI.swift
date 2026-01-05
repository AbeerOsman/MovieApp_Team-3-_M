//
//  UserAPI.swift
//  MovieApp_Team(3)_M
//
//  Created by ruam on 17/07/1447 AH.
//

import Foundation

struct UserAPI {
    
    static func fetchUsers() async throws -> UsersResponse {
        let data = try await NetworkService.fetch(Endpoints.users)
        let response = try JSONDecoder().decode(UsersResponse.self, from: data)
        return response
    }
    
    static func fetchUser(id: String) async throws -> UserRecord {
        let data = try await NetworkService.fetch(Endpoints.user(id))
        let user = try JSONDecoder().decode(UserRecord.self, from: data)
        return user
    }
    
    static func updateUser(id: String, user: UserInfo) async throws -> Data {
        let body: [String: Any] = [
            "fields": [
                "name": user.name ?? "",
                "password": user.password ?? "",
                "email": user.email ?? "",
                "profile_image": user.profileImage ?? ""
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        let data = try await NetworkService.put(Endpoints.user(id), body: jsonData)
        return data
    }
}
