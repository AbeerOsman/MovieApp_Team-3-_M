// SessionManager.swift
//  MovieApp_Team(3)_M
//
// Created by Abeer Jeilani Osman on 11/07/1447 AH.

import Foundation // for using UserDefaults
import Combine    // for using ObservableObject + Published

@MainActor

class SessionManager: ObservableObject {
    // Only one session manager exists +  Used everywhere in the app
    static let shared = SessionManager()
    // SwiftUI will automatically update the UI when these data changes
    @Published var currentUser: UserInfo?
    @Published var userRecordId: String?
    @Published var isLoggedIn = false
    
    init() {
        loadSavedSession()
    }
    
    // Save User Session After Sign In
    func saveUserSession(_ user: UserInfo, recordId: String) {
        self.currentUser = user
        self.userRecordId = recordId
        self.isLoggedIn = true
        
        updateUserDefaults(user: user)
        
        // Persist session state
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(recordId, forKey: "userRecordId")
    }
    
    // MARK: - Update UserDefaults
    func updateUserDefaults(user: UserInfo) {
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        UserDefaults.standard.set(user.name ?? "User", forKey: "userName")
        UserDefaults.standard.set(user.profileImage ?? "", forKey: "userProfileImage")
        
        if let password = user.password {
            UserDefaults.standard.set(password, forKey: "userPassword")
        }
    }
    
    // Load Saved Session on App Start
     func loadSavedSession() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn,
           let recordId = UserDefaults.standard.string(forKey: "userRecordId"),
           let email = UserDefaults.standard.string(forKey: "userEmail") {
            
            let name = UserDefaults.standard.string(forKey: "userName")
            let profileImage = UserDefaults.standard.string(forKey: "userProfileImage")
            let password = UserDefaults.standard.string(forKey: "userPassword")
            
            //re-create the user from saved data
            self.userRecordId = recordId
            self.currentUser = UserInfo(
                name: name,
                password: password,
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
        UserDefaults.standard.removeObject(forKey: "userPassword")
    }
}
