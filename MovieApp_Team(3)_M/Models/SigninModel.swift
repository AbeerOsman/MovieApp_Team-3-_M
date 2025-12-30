//
//  Untitled.swift
//  MovieApp_Team(3)_M
//
//  Created by Shaikha Alnashri on 09/07/1447 AH.
//

import Foundation

struct UsersResponse: Codable {
    let records: [UserRecord]
}

struct UserRecord: Codable, Identifiable {
        let id: String
        let fields: UserInfo
}

struct UserInfo: Codable {
        let name: String
        let password: String
        let email:  String
        let profile_image: String
    
}
