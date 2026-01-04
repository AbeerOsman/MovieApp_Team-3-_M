//
//  SessionManager.swift
//  MovieApp_Team(3)_M
//
//  Created by Abeer Jeilani Osman  on 11/07/1447 AH.
//
import Foundation
import Combine

@MainActor
class SessionManager: ObservableObject {
    //Only one session manager exists +  Used everywhere in the app
    static let shared = SessionManager()
    
    @Published var currentUser: UserInfo?
    @Published var userRecordId: String? // This is the Airtable record ID
    @Published var isLoggedIn = false
    
    init() {
        // Load saved session when app starts
        loadSavedSession()
    }
    
    // MARK: - Save User Session After Sign In
    func saveUserSession(_ user: UserInfo, recordId: String) {
        self.currentUser = user
        self.userRecordId = recordId // Store the Airtable record ID
        self.isLoggedIn = true
        
        // Persist to UserDefaults
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(recordId, forKey: "userRecordId")
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        UserDefaults.standard.set(user.name ?? "User", forKey: "userName")
        UserDefaults.standard.set(user.profileImage ?? "", forKey: "userProfileImage")
    }
    
    // MARK: - Load Saved Session on App Start
    private func loadSavedSession() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn,
           let recordId = UserDefaults.standard.string(forKey: "userRecordId"),
           let email = UserDefaults.standard.string(forKey: "userEmail") {
            
            let name = UserDefaults.standard.string(forKey: "userName")
            let profileImage = UserDefaults.standard.string(forKey: "userProfileImage")
            
            self.userRecordId = recordId
            self.currentUser = UserInfo(
                name: name,
                password: nil, // Never store password
                email: email,
                profileImage: profileImage
            )
            self.isLoggedIn = true
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        currentUser = nil
        userRecordId = nil
        isLoggedIn = false
        
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userRecordId")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userProfileImage")
    }
}
